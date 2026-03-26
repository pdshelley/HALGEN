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
        buildTimers(file: device, chipDocumentation: documentation)
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
                                let bitfieldMemberBlock = generateEnum(from: valueGroup, bitfieldName: bitfield.name)
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

func generateEnum(from ValueGroup: AVRModules.Module.ValueGroup, bitfieldName: String) -> MemberBlockItemSyntax {
    
    var documentationTable = """
        /// |--------|-------|-------|-------|-----------------------------------------------------------------|
        /// |  Mode  | \(bitfieldName)2  | \(bitfieldName)1  | \(bitfieldName)0  | Description                                                     |
        /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    """
    
    var enumValues = ""
    
    for value in ValueGroup.value {
        var description = ""
        var enumValue = ""
        
        switch value.name {
        case "NO_CLOCK_SOURCE_STOPPED", "NO_CLOCK_SOURCE_TIMER_COUNTER_STOPPED", "NO_CLOCK_SOURCE_TIMER_COUNTER0_STOPPED", "NO_CLOCK_SOURCE_TIMER_COUNTER2_STOPPED":
            description = "No Clock Source (Stopped)"
            enumValue = "stopped"
        case "RUNNING_NO_PRESCALING":
            description = "Running, No Prescaling"
            enumValue = "runningWithoutPrescaling"
        case "RUNNING_CLK_8":
            description = "Running, CLK/8"
            enumValue = "running8"
        case "RUNNING_CLK_16":
            description = "Running, CLK/16"
            enumValue = "running16"
        case "RUNNING_CLK_32":
            description = "Running, CLK/32"
            enumValue = "running32"
        case "RUNNING_CLK_64":
            description = "Running, CLK/64"
            enumValue = "running64"
        case "RUNNING_CLK_128":
            description = "Running, CLK/128"
            enumValue = "running128"
        case "RUNNING_CLK_256":
            description = "Running, CLK/256"
            enumValue = "running256"
        case "RUNNING_CLK_1024":
            description = "Running, CLK/1024"
            enumValue = "running1024"
        case "RUNNING_EXTCLK_TN_FALLING_EDGE":
            description = "External clock source. Clock on falling edge."
            enumValue = "runningExternalFallingEdge"
        case "RUNNING_EXTCLK_TN_RISING_EDGE":
            description = "External clock source. Clock on rising edge."
            enumValue = "runningExternalRisingEdge"
        default:
            description = ""
        }
        
        // Note: Can't Convert in the Codable conversion because there is messy data that is not always numbers.
        let number = numberFrom(value: value.value)
        
        let documentationRow = """
        
            /// |    \(number)   |   \((number & 0b00000100) >> 2)   |   \((number & 0b00000010) >> 1)   |   \(number & 0b00000001)   | \(description.padding(toLength: 64, withPad: " ", startingAt: 0))|
            /// |--------|-------|-------|-------|-----------------------------------------------------------------|
        """
        
        let enumValueRow = "        case \(enumValue) = \(number)\n"
        
        documentationTable.append(documentationRow)
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
