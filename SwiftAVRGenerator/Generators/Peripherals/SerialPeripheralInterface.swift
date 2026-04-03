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
                content: buildFileHeader(for: "SPI", generateTypealias: false) + SPIDocs.boilerplate,
                subdirectory: subdirectory
            )
        )

        guard let spiModule = device.modules.module.first(where: { $0.name == "SPI" }) else {
            return files
        }

        for registerGroup in spiModule.registerGroup {
            let structName = "SPI\(spiInstanceIndex(for: registerGroup))"
            var code = buildFileHeader(for: structName)
            var memberBlockList = MemberBlockItemListSyntax()

            for register in canonicalSPIRegisters(in: registerGroup) {
                memberBlockList.append(
                    contentsOf: generateRegister(
                        register: register,
                        registerData: documentation.supplementalData(for:),
                        bitfieldData: documentation.supplementalData(for:)
                    )
                )

                for bitfield in register.bitfield {
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

/// Extracts the SPI instance number from a register group name.
///
/// Used to generate struct names like `SPI0`, `SPI1`, etc. from register group names.
/// For example, "SPI1" returns "1", while "SPI" returns "0" (default instance).
///
/// - Parameter registerGroup: The register group containing SPI registers.
/// - Returns: The instance number as a string, or "0" if no numeric suffix exists.
func spiInstanceIndex(for registerGroup: AVRModules.Module.RegisterGroup) -> String {
    let trailingDigits = String(registerGroup.name.reversed().prefix { $0.isNumber }.reversed())
    return trailingDigits.isEmpty ? "0" : trailingDigits
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
    let trailingDigits = String(registerGroupName.reversed().prefix { $0.isNumber }.reversed())
    return trailingDigits.isEmpty ? nil : trailingDigits
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
    let suffix = String(registerName.reversed().prefix { $0.isNumber }.reversed())

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

private enum SPIDocs {
    static let boilerplate = """
public enum SPI {
    /// SPI Clock Polarity.
    public enum ClockPolarity: UInt8 {
        case rising = 0
        case falling = 1
    }

    /// SPI Clock Phase.
    public enum ClockPhase: UInt8 {
        case sample = 0
        case setup = 1
    }

    /// SPI Data Order.
    public enum DataOrder: UInt8 {
        case mostSignificantBitFirst = 0
        case leastSignificantBitFirst = 1
    }

    /// SPI Clock Rate Select.
    ///
    /// Combines `SPR1:SPR0` from `SPCR` with `SPI2X` from `SPSR`.
    public enum ClockRateSelect: UInt8 {
        case f4 = 0
        case f16 = 1
        case f64 = 2
        case f128 = 3
        case f2 = 4
        case f8 = 5
        case f32 = 6
        case f64_2 = 7
    }

    /// SPI Mode.
    ///
    /// Mode 0 = CPOL 0, CPHA 0
    /// Mode 1 = CPOL 0, CPHA 1
    /// Mode 2 = CPOL 1, CPHA 0
    /// Mode 3 = CPOL 1, CPHA 1
    public enum Mode: UInt8 {
        case zero = 0
        case one = 1
        case two = 2
        case three = 3
    }
}

public protocol SPIPort {
    associatedtype PortDataType: BinaryInteger

    static var controlRegister: UInt8 { get set }
    static var statusRegister: UInt8 { get set }
    static var dataRegister: PortDataType { get set }

    static var interruptFlag: Bool { get }
    static var dataOrder: SPI.DataOrder { get set }
}

public extension SPIPort {
    /// SPI mode convenience wrapper for `CPOL` and `CPHA`.
    @inlinable
    @inline(__always)
    static var mode: SPI.Mode {
        get {
            let rawMode = (controlRegister & 0b00001100) >> UInt8(2)
            return SPI.Mode(rawValue: rawMode) ?? .zero
        }
        set {
            controlRegister = (controlRegister & ~0b00001100) | ((newValue.rawValue << UInt8(2)) & 0b00001100)
        }
    }

    /// SPI clock rate convenience wrapper for `SPR1:SPR0` and `SPI2X`.
    @inlinable
    @inline(__always)
    static var clockRateSelect: SPI.ClockRateSelect {
        get {
            let rawMode = (controlRegister & 0b00000011) | ((statusRegister & 0b00000001) << UInt8(2))
            return SPI.ClockRateSelect(rawValue: rawMode) ?? .f4
        }
        set {
            controlRegister = (controlRegister & ~0b00000011) | (newValue.rawValue & 0b00000011)
            statusRegister = (statusRegister & ~0b00000001) | ((newValue.rawValue & 0b00000100) >> UInt8(2))
        }
    }
}

public extension SPIPort where PortDataType == UInt8 {
    /// Transfers a single byte and returns the byte received at the same time.
    @inlinable
    @inline(__always)
    @discardableResult
    static func transfer(_ byte: UInt8) -> UInt8 {
        dataRegister = byte
        noOpperation()
        while !interruptFlag { }
        return dataRegister
    }

    /// Convenience alias for `transfer(_:)`.
    @inlinable
    @inline(__always)
    @discardableResult
    static func write(_ byte: UInt8) -> UInt8 {
        transfer(byte)
    }

    /// Transfers each byte in-place and replaces the buffer with the received bytes.
    @inlinable
    @inline(__always)
    @discardableResult
    static func transmit(_ buffer: UnsafeMutableBufferPointer<UInt8>) -> UnsafeMutableBufferPointer<UInt8> {
        for index in 0..<buffer.count {
            buffer[index] = transfer(buffer[index])
        }

        return buffer
    }

    @inlinable
    @inline(__always)
    static func write16(_ value: UInt16) -> UInt16 {
        switch dataOrder {
        case .mostSignificantBitFirst:
            let highByte = transfer(UInt8((value & 0xFF00) >> 8))
            let lowByte = transfer(UInt8(value & 0x00FF))
            return (UInt16(highByte) << 8) | UInt16(lowByte)
        case .leastSignificantBitFirst:
            let lowByte = transfer(UInt8(value & 0x00FF))
            let highByte = transfer(UInt8((value & 0xFF00) >> 8))
            return UInt16(lowByte) | (UInt16(highByte) << 8)
        }
    }

    @inlinable
    @inline(__always)
    static func write32(_ value: UInt32) -> UInt32 {
        switch dataOrder {
        case .mostSignificantBitFirst:
            let byte1 = transfer(UInt8((value & 0xFF000000) >> 24))
            let byte2 = transfer(UInt8((value & 0x00FF0000) >> 16))
            let byte3 = transfer(UInt8((value & 0x0000FF00) >> 8))
            let byte4 = transfer(UInt8(value & 0x000000FF))
            return (UInt32(byte1) << 24) | (UInt32(byte2) << 16) | (UInt32(byte3) << 8) | UInt32(byte4)
        case .leastSignificantBitFirst:
            let byte4 = transfer(UInt8(value & 0x000000FF))
            let byte3 = transfer(UInt8((value & 0x0000FF00) >> 8))
            let byte2 = transfer(UInt8((value & 0x00FF0000) >> 16))
            let byte1 = transfer(UInt8((value & 0xFF000000) >> 24))
            return UInt32(byte4) | (UInt32(byte3) << 8) | (UInt32(byte2) << 16) | (UInt32(byte1) << 24)
        }
    }
}
"""
}
