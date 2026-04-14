//
//  Timers.swift
//  SwiftAVRGenerator
//
//  Created by Paul Shelley on 7/6/23.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

struct TimerGenerator: PeripheralGenerator {
    let name = "Timer"
    let subdirectory: String = "module/Timer"
    
    func supports(device: AVRToolsDeviceFile) -> Bool {
        device.modules.module.contains { module in
            switch module.name {
            case "TC8", "TC10", "TC16", "TC8_ASYNC":
                return true
            default:
                return false
            }
        }
    }
    
    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        var files = [
            GeneratedCodeFile(
                fileName: "Timers.swift",
                content: buildFileHeader(for: "Timers", generateTypealias: false)
                    + BoilerplateTemplate.load(named: "Timers.swift.template", documentationDirectory: documentation.directory),
                subdirectory: subdirectory
            )
        ]

        files.append(contentsOf: buildTimers(file: device, chipDocumentation: documentation))
        return files
    }
}

func buildTimers(file: AVRToolsDeviceFile, chipDocumentation: ChipDocumentationLoader) -> [GeneratedCodeFile] { // TODO: This should probably return a "File" as there can be many different timers.
    var timerFiles: [GeneratedCodeFile] = []
    
    // TODO: Are there timers A and B? What does TCA stand for?
    // Classic AVR does not use timers A and B, this is an indication of a "new" AVR. These cases need to be handled.
        
    // Filter for Modules named "PORT" // TODO: Find a better way to filter.
    for module in file.modules.module {
        for registerGroup in module.registerGroup {
            switch registerGroup.name {
            case "TC0":
                timerFiles.append(buildTimer(module: module, timerName: "Timer0", chipName: file.devices.device.name, chipDocumentation: chipDocumentation))
            case "TC1":
                timerFiles.append(buildTimer(module: module, timerName: "Timer1", chipName: file.devices.device.name, chipDocumentation: chipDocumentation))
            case "TC2":
                timerFiles.append(buildTimer(module: module, timerName: "Timer2", chipName: file.devices.device.name, chipDocumentation: chipDocumentation))
            case "TC3":
                timerFiles.append(buildTimer(module: module, timerName: "Timer3", chipName: file.devices.device.name, chipDocumentation: chipDocumentation))
            case "TC4":
                timerFiles.append(buildTimer(module: module, timerName: "Timer4", chipName: file.devices.device.name, chipDocumentation: chipDocumentation))
            case "TC5":
                timerFiles.append(buildTimer(module: module, timerName: "Timer5", chipName: file.devices.device.name, chipDocumentation: chipDocumentation))
            default:
                break
            }
        }
    }
    
    return timerFiles
}

struct TimerInfo {
    let isAsynchronous: Bool
    let bitSize: BitSize
    
    var timerProtocol: String {
        switch bitSize {
        case .eightBit:
            return "Timer8Bit"
        case .tenBit:
            return "Timer10Bit"
        case .sixteenBit:
            return "Timer16Bit"
        }
    }
    
    enum BitSize: String, Codable {
        case eightBit = "UInt8"
        case tenBit = "UInt10"
        case sixteenBit = "UInt16"
    }
}

func gatherTimerInfo(from module: AVRModules.Module) -> TimerInfo {
    var bitSize: TimerInfo.BitSize = .eightBit
    var isAsync: Bool = false
    
    // The name of the module indicates if it is 8 or 16 bit as well as if it is Async.
    // TODO: Check to see if any 16 bit timers have
    switch module.name {
    case "TC8_ASYNC":
        isAsync = true
        bitSize = .eightBit
    case "TC8":
        bitSize = .eightBit
    case "TC10":
        bitSize = .tenBit
    case "TC16":
        bitSize = .sixteenBit
    default: ()
    }
    
    return TimerInfo(isAsynchronous: isAsync, bitSize: bitSize)
}

func buildProtocolDeclarations(from info: TimerInfo) -> String {
    var hasProtocols: [String] = []
    
    // The name of the module indicates if it is 8 or 16 bit as well as if it is Async.
    // TODO: Check to see if any 16 bit timers have
    switch info.bitSize {
    case .eightBit:
        hasProtocols.append("Timer8Bit")
    case .tenBit:
        hasProtocols.append("Timer10Bit")
    case .sixteenBit:
        hasProtocols.append("Timer16Bit")
    }
    
    if info.isAsynchronous {
        hasProtocols.append("AsyncTimer")
    }
    
//    if info.internalTimer {
//        hasProtocols.append("InternalClockOnly")
//    } else {
//        hasProtocols.append("HasExternalClock")
//    }
    
    return hasProtocols.isEmpty ? "" : " \(hasProtocols.joined(separator: ", ")) "
}

func buildTimer(module: AVRModules.Module, timerName: String, chipName: String, chipDocumentation: ChipDocumentationLoader) -> GeneratedCodeFile {
    let fileName = "\(timerName).swift"
    var code: String = buildFileHeader(for: timerName)
    let timerInfo = gatherTimerInfo(from: module)
    var memberBlockList = MemberBlockItemListSyntax()
    let protocolDeclarations = buildProtocolDeclarations(from: timerInfo) // buildProtocolDeclarationsFrom(module: module)
    
    for registerGroup in module.registerGroup {
        for register in registerGroup.register {
            let memberBlock = generateRegister(
                register: register,
                registerData: chipDocumentation.supplementalData(for:),
                bitfieldData: chipDocumentation.supplementalData(for:)
            )
            
            memberBlockList.append(contentsOf: memberBlock)
 
            // TODO: Generate Bitfield Accessor EX: Wave Form Generation Mode (WGM)
            for bitfield in register.bitfield {
                
                switch bitfield.name {
                case "CS0", "CS1", "CS2", "CS3", "CS4", "CS5":
                    // Generate The Enum
                    if let valueGroupName = bitfield.values {
                        for valueGroup in module.valueGroup {
                            // Make sure that the name of the valueGroup matches
                            if valueGroup.name == valueGroupName {
                                let bitfieldWidth = max(
                                    significantBitWidth(of: bitfield.mask.value),
                                    significantBitWidth(of: UInt16(valueGroup.value.map { numberFrom(value: $0.value) }.max() ?? 0))
                                )
                                let bitfieldMemberBlock = generateEnum(
                                    from: valueGroup,
                                    bitfieldName: bitfield.name,
                                    bitWidth: bitfieldWidth
                                )
                                memberBlockList.append(bitfieldMemberBlock)
                            }
                        }
                    }
                    if let bitfieldMemberBlock = generateBitfieldAccessor(bitfield: bitfield, parentVariable: register, registerGroup: registerGroup, registerData: chipDocumentation.supplementalData(for:), bitfieldData: chipDocumentation.supplementalData(for:)) {
                        memberBlockList.append(bitfieldMemberBlock)
                    }
                default:
                    if let bitfieldMemberBlock = generateBitfieldAccessor(bitfield: bitfield, parentVariable: register, registerGroup: registerGroup, registerData: chipDocumentation.supplementalData(for:), bitfieldData: chipDocumentation.supplementalData(for:)) {
                        memberBlockList.append(bitfieldMemberBlock)
                    }
                }
            }
        }
    }

    memberBlockList = normalizeMemberSpacing(memberBlockList)
     
    let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())

    // Information needed to setup the Struct.
    let InheritedType = InheritedTypeSyntax(type: TypeSyntax(stringLiteral: protocolDeclarations))
    let inheritedTypeList = InheritedTypeListSyntax(arrayLiteral: InheritedType)
    let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
    
    code.append(SourceFileSyntax {
        StructDeclSyntax(
            modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
            name: "\(raw: timerName)",
            inheritanceClause: inheritanceClause,
            memberBlock: memberBlock
        )
    }.formatted().description)

//    print(code)
    // TODO: Move generation logic to the generator function in the PeripheralGenerator struct so no new instantiation is needed to get the subdir
    return GeneratedCodeFile(fileName: fileName, content: code, subdirectory: TimerGenerator().subdirectory)
}

func generateEnum(
    from ValueGroup: AVRModules.Module.ValueGroup,
    bitfieldName: String,
    bitWidth: Int
) -> MemberBlockItemSyntax {
    var enumValues = ""
    var generatedValues: [(baseName: String, number: UInt8, caption: String, description: String)] = []
    
    for value in ValueGroup.value {
        var fallbackDescription = ""
        var enumValue = ""
        
        let number = numberFrom(value: value.value)
        
        switch value.name {
        case "NO_CLOCK_SOURCE_STOPPED", "NO_CLOCK_SOURCE_TIMER_COUNTER_STOPPED", "NO_CLOCK_SOURCE_TIMER_COUNTER0_STOPPED", "NO_CLOCK_SOURCE_TIMER_COUNTER2_STOPPED":
            fallbackDescription = "No Clock Source (Stopped)"
            enumValue = "stopped"
        case "RUNNING_NO_PRESCALING", "CLK_IO_1_NO_PRESCALING", "CLK_T2S_1_NO_PRESCALING":
            fallbackDescription = "Running, No Prescaling"
            enumValue = "runningWithoutPrescaling"
        case "RUNNING_CLK_8", "CLK_IO_8_FROM_PRESCALER", "CLK_T2S_8_FROM_PRESCALER":
            fallbackDescription = "Running, CLK/8"
            enumValue = "running8"
        case "RUNNING_CLK_16":
            fallbackDescription = "Running, CLK/16"
            enumValue = "running16"
        case "RUNNING_CLK_32", "CLK_T2S_32_FROM_PRESCALER":
            fallbackDescription = "Running, CLK/32"
            enumValue = "running32"
        case "RUNNING_CLK_64", "CLK_IO_64_FROM_PRESCALER", "CLK_T2S_64_FROM_PRESCALER":
            fallbackDescription = "Running, CLK/64"
            enumValue = "running64"
        case "RUNNING_CLK_128", "CLK_T2S_128_FROM_PRESCALER":
            fallbackDescription = "Running, CLK/128"
            enumValue = "running128"
        case "RUNNING_CLK_256", "CLK_IO_256_FROM_PRESCALER", "CLK_T2S_256_FROM_PRESCALER":
            fallbackDescription = "Running, CLK/256"
            enumValue = "running256"
        case "RUNNING_CLK_1024", "CLK_IO_1024_FROM_PRESCALER", "CLK_T2S_1024_FROM_PRESCALER":
            fallbackDescription = "Running, CLK/1024"
            enumValue = "running1024"
        case "RUNNING_CLK_2":
            fallbackDescription = "Running, CLK/2"
            enumValue = "running2"
        case "RUNNING_CLK_4":
            fallbackDescription = "Running, CLK/4"
            enumValue = "running4"
        case "RUNNING_CLK_512":
            fallbackDescription = "Running, CLK/512"
            enumValue = "running512"
        case "RUNNING_CLK_2048":
            fallbackDescription = "Running, CLK/2048"
            enumValue = "running2048"
        case "RUNNING_CLK_4096":
            fallbackDescription = "Running, CLK/4096"
            enumValue = "running4096"
        case "RUNNING_CLK_8192":
            fallbackDescription = "Running, CLK/8192"
            enumValue = "running8192"
        case "RUNNING_CLK_16384":
            fallbackDescription = "Running, CLK/16384"
            enumValue = "running16384"
        case "RUNNING_EXTCLK_TN_FALLING_EDGE", "EXTERNAL_CLOCK_SOURCE_ON_TN_PIN_CLOCK_ON_FALLING_EDGE", "EXTERNAL_CLOCK_SOURCE_ON_T0_PIN_CLOCK_ON_FALLING_EDGE":
            fallbackDescription = "External clock source. Clock on falling edge."
            enumValue = "runningExternalFallingEdge"
        case "RUNNING_EXTCLK_TN_RISING_EDGE", "EXTERNAL_CLOCK_SOURCE_ON_TN_PIN_CLOCK_ON_RISING_EDGE", "EXTERNAL_CLOCK_SOURCE_ON_T0_PIN_CLOCK_ON_RISING_EDGE":
            fallbackDescription = "External clock source. Clock on rising edge."
            enumValue = "runningExternalRisingEdge"
        case "RESERVED":
            fallbackDescription = "Reserved"
            enumValue = "reserved\(number)"
        default:
            fallbackDescription = ""
        }

        let sanitizedCaption = sanitizeDocumentationTableText(value.caption)
        let description = sanitizedCaption.isEmpty ? fallbackDescription : sanitizedCaption
        generatedValues.append(
            (baseName: enumValue, number: number, caption: sanitizedCaption, description: description)
        )
    }

    let documentationTable = makePrescalingDocumentationTable(
        rows: generatedValues.map { (number: $0.number, description: $0.description) },
        bitfieldName: bitfieldName,
        bitWidth: bitWidth
    )

    let duplicateNames = Set(
        Dictionary(grouping: generatedValues, by: \.baseName)
            .filter { !$0.key.isEmpty && $0.value.count > 1 }
            .map(\.key)
    )

    var seenCounts: [String: Int] = [:]

    for generatedValue in generatedValues {
        let enumValue: String
        if duplicateNames.contains(generatedValue.baseName) {
            let nextCount = seenCounts[generatedValue.baseName, default: 0] + 1
            seenCounts[generatedValue.baseName] = nextCount
            enumValue = nextCount == 1 ? generatedValue.baseName : "\(generatedValue.baseName)_\(nextCount)"
        } else {
            enumValue = generatedValue.baseName
        }

        let sanitizedCaption = generatedValue.caption.isEmpty ? generatedValue.description : generatedValue.caption
        let enumValueRow = "        case \(enumValue) = \(generatedValue.number) // \(sanitizedCaption)\n"

        enumValues.append(enumValueRow)
    }
    
    
    
    
    let source = DeclSyntax(
      """
          /// ```
      \(raw: documentationTable)
          /// ```
          public enum Prescaling: UInt8 {
      \(raw: enumValues)}
      """
    ).with(\.trailingTrivia, .newlines(2))
    
    return MemberBlockItemSyntax(decl: source)
}

private func significantBitWidth(of value: UInt16) -> Int {
    guard value > 0 else {
        return 1
    }

    return UInt16.bitWidth - value.leadingZeroBitCount
}

private func sanitizeDocumentationTableText(_ text: String) -> String {
    text
        .replacingOccurrences(of: "\n", with: " ")
        .replacingOccurrences(of: "\r", with: " ")
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

private func makePrescalingDocumentationTable(
    rows: [(number: UInt8, description: String)],
    bitfieldName: String,
    bitWidth: Int
) -> String {
    let normalizedBitWidth = max(bitWidth, 1)
    let bitHeaders = stride(from: normalizedBitWidth - 1, through: 0, by: -1).map { "\(bitfieldName)\($0)" }
    let modeWidth = max("Mode".count, rows.map { String($0.number).count }.max() ?? 1)
    let bitWidths = bitHeaders.map { max($0.count, 1) }
    let descriptionWidth = max("Description".count, rows.map(\.description.count).max() ?? 1)
    let widths = [modeWidth] + bitWidths + [descriptionWidth]

    let divider = makeMarkdownTableDivider(widths: widths)
    let header = makeMarkdownTableRow(
        contents: ["Mode"] + bitHeaders + ["Description"],
        widths: widths
    )

    var lines = [
        "/// \(divider)",
        "/// \(header)",
        "/// \(divider)"
    ]

    for row in rows {
        let bitValues = stride(from: normalizedBitWidth - 1, through: 0, by: -1).map {
            String((row.number >> UInt8($0)) & 0x01)
        }
        let rowText = makeMarkdownTableRow(
            contents: [String(row.number)] + bitValues + [row.description],
            widths: widths
        )

        lines.append("/// \(rowText)")
        lines.append("/// \(divider)")
    }

    return lines.joined(separator: "\n")
}

private func makeMarkdownTableDivider(widths: [Int]) -> String {
    "|" + widths
        .map { String(repeating: "-", count: $0 + 2) }
        .joined(separator: "|") + "|"
}

private func makeMarkdownTableRow(contents: [String], widths: [Int]) -> String {
    let descriptionIndex = contents.count - 1
    let cells = zip(contents, widths).enumerated().map { index, pair in
        let (content, width) = pair
        let alignment: MarkdownTableAlignment = index == descriptionIndex ? .leading : .centered
        return makeMarkdownTableCell(content: content, width: width, alignment: alignment)
    }

    return "|" + cells.joined(separator: "|") + "|"
}

private func makeMarkdownTableCell(
    content: String,
    width: Int,
    alignment: MarkdownTableAlignment
) -> String {
    let padding = max(width - content.count, 0)

    switch alignment {
    case .centered:
        let leadingPadding = padding / 2
        let trailingPadding = padding - leadingPadding
        return " "
            + String(repeating: " ", count: leadingPadding)
            + content
            + String(repeating: " ", count: trailingPadding)
            + " "
    case .leading:
        return " " + content + String(repeating: " ", count: padding) + " "
    }
}

private enum MarkdownTableAlignment {
    case centered
    case leading
}
