//
//  SerialPeripheralInterface.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 02/04/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

struct SPIGenerator: PeripheralGenerator {
    let name: String = "SPI"
    let subdirectory: String = "module/SPI"

    func supports(device: AVRToolsDeviceFile) -> Bool {
        device.modules.module.contains { $0.name == "SPI" }
    }

    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        var files: [GeneratedCodeFile] = []
        files.append(
            GeneratedCodeFile(
                fileName: "SPI.swift",
                content: buildFileHeader(for: "SPI", generateTypealias: false)
                    + BoilerplateTemplate.load(named: "SPI.swift.template", documentationDirectory: documentation.directory),
                subdirectory: subdirectory
            )
        )

        guard let spiModule = device.modules.module.first(where: { $0.name == "SPI" }) else {
            return files
        }

        for registerGroup in spiModule.registerGroup {
            let structName = "SPI\(peripheralInstanceIndex(for: registerGroup.name))"
            let canonicalRegisters = canonicalSPIRegisters(in: registerGroup)
            let isClassicSPI = registerGroupUsesClassicSPIRegisters(canonicalRegisters)
            var code = buildFileHeader(for: structName)
            var memberBlockList = MemberBlockItemListSyntax()

            for register in canonicalRegisters {
                memberBlockList.append(
                    contentsOf: generateRegister(
                        register: register,
                        registerData: documentation.supplementalData(for:),
                        bitfieldData: documentation.supplementalData(for:)
                    )
                )

                for bitfield in register.bitfield {
                    if isClassicSPI,
                       let compatibilityAccessor = generateClassicSPICompatibilityAccessor(
                        bitfield: bitfield,
                        parentRegister: register,
                        registerData: documentation.supplementalData(for:),
                        bitfieldData: documentation.supplementalData(for:)
                       ) {
                        memberBlockList.append(compatibilityAccessor)
                        continue
                    }

                    if let bitfieldAccessor = generateBitfieldAccessor(
                        bitfield: bitfield,
                        parentVariable: register,
                        registerGroup: registerGroup,
                        registerData: documentation.supplementalData(for:),
                        bitfieldData: documentation.supplementalData(for:)
                    ) {
                        memberBlockList.append(bitfieldAccessor)
                    }
                }
            }

            if isClassicSPI {
                memberBlockList.append(
                    makeClassicSPISetupMethod(
                        device: device,
                        registerGroup: registerGroup
                    )
                )
            }

            memberBlockList = normalizeMemberSpacing(memberBlockList)
            let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())
            let inheritedType = InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "SPIPort"))
            let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: InheritedTypeListSyntax(arrayLiteral: inheritedType))

            code.append(SourceFileSyntax {
                StructDeclSyntax(
                    modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
                    name: "\(raw: structName)",
                    inheritanceClause: inheritanceClause,
                    memberBlock: memberBlock
                )
            }.formatted().description)

            files.append(
                GeneratedCodeFile(
                    fileName: "\(structName).swift",
                    content: code,
                    subdirectory: subdirectory
                )
            )
        }

        return files
    }
}

private func registerGroupUsesClassicSPIRegisters(
    _ registers: [AVRModules.Module.RegisterGroup.Register]
) -> Bool {
    let registerNames = Set(registers.map { normalizedSPIRegisterKey(for: $0.name) })
    return registerNames.isSuperset(of: ["SPCR", "SPSR", "SPDR"])
}

private func generateClassicSPICompatibilityAccessor(
    bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
    parentRegister: AVRModules.Module.RegisterGroup.Register,
    registerData: (_ register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData,
    bitfieldData: (_ bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData
) -> MemberBlockItemSyntax? {
    guard normalizedSPIRegisterKey(for: parentRegister.name) == "SPSR" else {
        return nil
    }

    let info = bitfieldData(bitfield)
    guard info.variableName == "interruptFlag" || info.variableName == "writeCollisionFlag" else {
        return nil
    }

    let registerName = registerData(parentRegister).variableName
    let registerMask = bitfield.mask.value.lowByte
    let bitshift = UInt8(bitfield.mask.value.trailingZeroBitCount)
    let caption = bitfield.caption ?? ""
    let source = """
    /// \(bitfield.name) - \(caption)
    @inlinable
    @inline(__always)
    public static var \(info.variableName): Bool {
        get {
            let flag = (\(registerName) & \(registerMask.binaryString)) >> UInt8(\(bitshift))
            return flag == 1
        }
        set {
            \(registerName) = (\(registerName) & ~\(registerMask.binaryString)) | (((newValue ? 1 : 0) & 0b00000001) << UInt8(\(bitshift)))
        }
    }
    """

    return MemberBlockItemSyntax(decl: DeclSyntax("\(raw: source)").with(\.trailingTrivia, .newlines(2)))
}

private func makeClassicSPISetupMethod(
    device: AVRToolsDeviceFile,
    registerGroup: AVRModules.Module.RegisterGroup
) -> MemberBlockItemSyntax {
    let pinDirectionLines = classicSPIPinDirectionLines(
        device: device,
        registerGroup: registerGroup
    )
    var sourceLines = [
        "@inlinable",
        "@inline(__always)",
        "public static func setup() {",
        "    let savedStatus = cpuCore.statusRegister",
        "    cpuCore.globalInterruptEnable = false",
        ""
    ]

    if pinDirectionLines.isEmpty == false {
        sourceLines.append(contentsOf: pinDirectionLines.map { "    \($0)" })
        sourceLines.append("")
    }

    sourceLines.append("    masterSlaveSelect = true")
    sourceLines.append("    enable = true")
    sourceLines.append("")
    sourceLines.append("    cpuCore.statusRegister = savedStatus")
    sourceLines.append("}")
    let source = sourceLines.joined(separator: "\n")

    return MemberBlockItemSyntax(decl: DeclSyntax("\(raw: source)").with(\.trailingTrivia, .newlines(2)))
}

private func classicSPIPinDirectionLines(
    device: AVRToolsDeviceFile,
    registerGroup: AVRModules.Module.RegisterGroup
) -> [String] {
    guard let spiModule = device.devices.device.peripherals.module.first(where: { $0.name == "SPI" }) else {
        return []
    }

    guard let instance = spiModule.instance.first(where: {
        $0.registerGroup?.name == registerGroup.name || $0.name == registerGroup.name
    }) else {
        return []
    }

    let orderedSignalGroups: [(group: String, direction: String)] = [
        ("SS", ".output"),
        ("SCK", ".output"),
        ("MOSI", ".output"),
        ("MISO", ".input")
    ]

    return orderedSignalGroups.compactMap { signal in
        guard let pad = preferredClassicSPIPad(
            for: signal.group,
            in: instance.signals?.signal ?? []
        ) else {
            return nil
        }

        return "GPIO.\(pad.lowercased()).setDataDirection(\(signal.direction)) // \(signal.group)"
    }
}

private func preferredClassicSPIPad(
    for group: String,
    in signals: [AVRDevices.Device.Peripherals.Module.Instance.Signals.Signal]
) -> String? {
    signals
        .filter { $0.group == group }
        .max { lhs, rhs in
            classicSPISignalPriority(lhs) < classicSPISignalPriority(rhs)
        }?
        .pad
}

private func classicSPISignalPriority(
    _ signal: AVRDevices.Device.Peripherals.Module.Instance.Signals.Signal
) -> Int {
    switch signal.function?.uppercased() {
    case "DEFAULT":
        return 4
    case "SPI":
        return 3
    case nil:
        return 2
    default:
        return 1
    }
}

/// Deduplicates SPI registers when ATDF contains multiple variants of the same logical register.
///
/// Some ATDF files define multiple register names for the same hardware register
/// (e.g., `SPCR`, `SPCR0`, `SPCR1`). This function selects the most appropriate variant
/// for each canonical register type (SPCR, SPSR, SPDR) based on suffix matching and
/// returns a deduplicated, sorted list.
///
/// - Parameter registerGroup: The register group containing potentially duplicate SPI registers.
/// - Returns: Canonical registers sorted by offset, then by name.
func canonicalSPIRegisters(in registerGroup: AVRModules.Module.RegisterGroup) -> [AVRModules.Module.RegisterGroup.Register] {
    let preferredSuffix = preferredSPIRegisterSuffix(for: registerGroup.name)
    var bestRegistersByKey: [String: AVRModules.Module.RegisterGroup.Register] = [:]

    for register in registerGroup.register {
        let key = normalizedSPIRegisterKey(for: register.name)

        guard let currentBest = bestRegistersByKey[key] else {
            bestRegistersByKey[key] = register
            continue
        }

        let candidateScore = spiRegisterSelectionScore(for: register.name, preferredSuffix: preferredSuffix)
        let currentScore = spiRegisterSelectionScore(for: currentBest.name, preferredSuffix: preferredSuffix)
        if candidateScore > currentScore {
            bestRegistersByKey[key] = register
        }
    }

    return bestRegistersByKey.values.sorted { lhs, rhs in
        let lhsOffset = lhs.offset.hexValue()
        let rhsOffset = rhs.offset.hexValue()
        if lhsOffset == rhsOffset {
            return lhs.name < rhs.name
        }

        return lhsOffset < rhsOffset
    }
}

/// Extracts the numeric suffix from a register group name to use as a preference hint.
///
/// When multiple register variants exist (e.g., `SPCR`, `SPCR0`, `SPCR1`), this suffix
/// helps select the variant that matches the register group's instance number.
/// For example, register group "SPI1" prefers registers ending in "1".
///
/// - Parameter registerGroupName: The name of the register group (e.g., "SPI1").
/// - Returns: The trailing digits as a string, or `nil` if no numeric suffix exists.
private func preferredSPIRegisterSuffix(for registerGroupName: String) -> String? {
    trailingNumericSuffix(in: registerGroupName)
}

/// Maps SPI register names to their canonical key for deduplication.
///
/// Different ATDF files may use different naming conventions for the same logical register.
/// This function normalizes names like `SPCR`, `SPCR0`, `SPCR1` all to the key `"SPCR"`,
/// enabling the deduplication logic to group and select the best variant.
///
/// - Parameter registerName: The register name from the ATDF (e.g., "SPCR0").
/// - Returns: The canonical register key (e.g., "SPCR").
private func normalizedSPIRegisterKey(for registerName: String) -> String {
    if registerName.hasPrefix("SPCR") {
        return "SPCR"
    }

    if registerName.hasPrefix("SPSR") {
        return "SPSR"
    }

    if registerName.hasPrefix("SPDR") {
        return "SPDR"
    }

    return registerName
}

/// Scores a register name to determine preference when selecting among duplicates.
///
/// Used by `canonicalSPIRegisters` to pick the best register variant. Higher scores
/// indicate better matches. The scoring logic is:
/// - When a preferred suffix exists: exact match (3), no suffix (2), other (1)
/// - When no preferred suffix: no suffix (3), "0" suffix (2), other (1)
///
/// This ensures that register group "SPI1" selects "SPCR1" over "SPCR" or "SPCR0",
/// while register group "SPI" selects "SPCR" over "SPCR0" or "SPCR1".
///
/// - Parameters:
///   - registerName: The register name to score (e.g., "SPCR1").
///   - preferredSuffix: The preferred numeric suffix, if any (e.g., "1").
/// - Returns: A score from 1 to 3, with higher values indicating stronger preference.
private func spiRegisterSelectionScore(for registerName: String, preferredSuffix: String?) -> Int {
    let suffix = trailingNumericSuffix(in: registerName) ?? ""

    if let preferredSuffix {
        if suffix == preferredSuffix {
            return 3
        }

        if suffix.isEmpty {
            return 2
        }

        return 1
    }

    if suffix.isEmpty {
        return 3
    }

    if suffix == "0" {
        return 2
    }

    return 1
}
