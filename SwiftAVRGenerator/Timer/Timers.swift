//
//  Timers.swift
//  SwiftAVRGenerator
//
//  Created by Paul Shelley on 7/6/23.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

func buildTimers(file: AVRToolsDeviceFile) -> [GeneratedCodeFile] { // TODO: This should probably return a "File" as there can be many different timers.
//    let fileName = "Timer0.swift" // TODO
//    var code: String = ""
    var timerFiles: [GeneratedCodeFile] = []
    
    // Filter for Modules named "PORT" // TODO: Find a better way to filter.
    for module in file.modules.module {
        for registerGroup in module.registerGroup {
            switch registerGroup.name {
            case .TC0:
                timerFiles.append(buildTimer(module: module, timerName: "Timer0"))
            case .TC1:
                timerFiles.append(buildTimer(module: module, timerName: "Timer1"))
            case .TC2:
                timerFiles.append(buildTimer(module: module, timerName: "Timer2"))
            case .TC3:
                timerFiles.append(buildTimer(module: module, timerName: "Timer3"))
            case .TC4:
                timerFiles.append(buildTimer(module: module, timerName: "Timer4"))
            case .TC5:
                timerFiles.append(buildTimer(module: module, timerName: "Timer5")) // TODO: Are there timers A and B? What does TCA stand for?
            default:
                break
            }
        }
    }
    
    return timerFiles
}


func buildProtocolDeclarationsFrom(module: AVRModules.Module) -> String {
    var hasProtocols: [String] = []
    
    // The name of the module indicates if it is 8 or 16 bit as well as if it is Async.
    // TODO: Check to see if any 16 bit timers have
    switch module.name {
    case .tc8Async:
        hasProtocols.append("Timer8Bit")
        hasProtocols.append("AsyncTimer")
    case .tc8:
        hasProtocols.append("Timer8Bit")
    case .tc10:
        hasProtocols.append("Timer10Bit")
    case .tc16:
        hasProtocols.append("Timer16Bit")
    default: ()
    }
    
    // To check for an external clock you need to check each register and each bitfiled to see if there is a bitfiled with a name of "EXCLK"
    // Module -> Register Group -> [Register] -> [Bitfield] -> EXCLK
    for registerGroup in module.registerGroup {
        var externalClock = "HasExternalClock"
        for register in registerGroup.register {
            for bitfield in register.bitfield {
                if bitfield.name == .EXCLK { // TODO: This name seems to indicate an external clock but from our example code we have the opposite, where this would indicate it has an internal clock only. Check this and figure out what is going on.
                    externalClock = "InternalClockOnly"
                }
            }
        }
        hasProtocols.append(externalClock)
    }
    
    return hasProtocols.isEmpty ? "" : " \(hasProtocols.joined(separator: ", ")) "
}

func buildFileHeaderFor(fileName: String) -> String {
    let fullFormatter = DateFormatter()
    fullFormatter.dateFormat = "MM/dd/yyyy"
    let fullDateString = fullFormatter.string(from: Date())
    
    let yearFormatter = DateFormatter()
    yearFormatter.dateFormat = "yyyy"
    let yearString = yearFormatter.string(from: Date())
    
    let fileHeader = """
    //===----------------------------------------------------------------------===//
    //
    // \(fileName).swift
    // CoreAVR
    //
    // Created by Swift AVR Generator on \(fullDateString).
    // Copyright © \(yearString) Paul Shelley. All rights reserved.
    //
    //===----------------------------------------------------------------------===//
    
    
    public typealias \(fileName.lowercased()) = \(fileName)
    
    
    """
    // TODO: The typealias should be generated in a different location.
    return fileHeader
}

enum timerBitSize: String, Codable {
    case eightBit = "UInt8"
    case sixteenBit = "UInt16"
    case none
}

func buildTimer(module: AVRModules.Module, timerName: String) -> GeneratedCodeFile {
    let fileName = "\(timerName).swift"
    var code: String = buildFileHeaderFor(fileName: timerName)
    
    let bitSize: timerBitSize = {
        switch module.name {
        case .tc8, .tc8Async:
            return .eightBit
        case .tc10, .tc16:
            return .sixteenBit
        default:
            assertionFailure("Failed to find bit size.")
            return .none
        }
    }()
    
    var memberBlockList = MemberBlockItemListSyntax()
    
    for registerGroup in module.registerGroup {
        for register in registerGroup.register {
            let memberBlock = generateRegister(register: register, bitSize: bitSize) // TODO: add this to the stored member blocks
            memberBlockList.append(memberBlock)
            
            let registerVariableName = variableNameFor(register: register)
//            let registerVariableName = variableNameFromString(register.caption?.rawValue ?? "") // .filter { $0 != " " } // TODO: Print some kind of error.
            
            // TODO: Generate Bitfield Accessor EX: Wave Form Generation Mode (WGM)
            for bitfield in register.bitfield {
                let bitfieldMemberBlock = generateBitfieldAccessor(bitfield: bitfield, parentVariableName: registerVariableName, bitSize: bitSize)
                memberBlockList.append(bitfieldMemberBlock)
            }
        }
    }
    
    let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())
    let protocolDeclarations = buildProtocolDeclarationsFrom(module: module)

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
    
    return GeneratedCodeFile(fileName: fileName, content: code)
}


/// This function help create what is needed to generate documentation for a register object.
/// Note that the data sheet adds a bit number to a bit name when there are more than one bit needed for a given value. This function adds these extra numbers to the bit name as they are not always present in the ATDF file. This also alwasy assumes that when a value is split accross two different registers, the most significan bit will be allone on one register and the least significant bits will be all togeather on the other register. This is believed to be the case but this function will calculate bit names incorectly if this is not the case. Ex: "FOC2A", "FOC2B", "-",  "-", "WGM22", "CS22", "CS21", "CS20"] and ["COM2A1", "COM2A0", "COM2B1", "COM2B0", "-", "-", "WGM21", "WGM20"] This example works because the ATDF file lists WGM2  as a setting with 2 bits on one register and then lists WGM22 as a setting on the other register. The second register will not add a number to the end because it is the only bit with that name.
/// This function will work for non-consecutive bit locations (Ex: 00110010) and give them the correct names.
/// - Parameter register: A register from the ATDF file object.
/// - Returns: A fixed array of 16 that includes either a "-" if there is no bit in that positon or the name of the bit in that position.
/// Example output: ["FOC2A", "FOC2B", "-", "-", "WGM22", "CS22", "CS21", "CS20"]
func getBitNamesFrom(register: AVRModules.Module.RegisterGroup.Register) -> [String] {
    var bitNames = Array(repeating: "-", count: 16)
        
    for bitField in register.bitfield {
        var mask: UInt16 = bitField.mask.value
        let name = bitField.name.rawValue
        
        // 0b0100100
        
        let numberOfBitsInMask = mask.nonzeroBitCount
        let startIndex = mask.trailingZeroBitCount
        var currentIndex = startIndex
        mask = mask >> mask.trailingZeroBitCount // Shift out any 0s before starting.

        while mask.nonzeroBitCount > 0 {
            var adjustedName = ""
            if numberOfBitsInMask > 1 { adjustedName = "\(numberOfBitsInMask - mask.nonzeroBitCount)" } // Check if and calculated the bit name number.
            bitNames[currentIndex] = name + adjustedName // Save name at current index.
            mask = mask >> 1 // Shift out bit that we just saved.
            currentIndex += 1 + mask.trailingZeroBitCount // Increase the index, if there are more 0s increase the index by how many 0s there are.
            mask = mask >> mask.trailingZeroBitCount // If there are 0s shift them out of the mask so we don't save a name for them.
        }
    }
    
    return bitNames
}

/// Adds Padding to strings for documentation. This is intended to be used for centering text in mono-spaced ASCII tables.
/// - Parameter input: String of 7 characters or less.
/// - Returns: A string of 7 characters, if the input string had more than 7 characters it should be unchanged.
func padString(_ input: String, padding: Int) -> String {
    if input.count >= padding {
        return input
    }
    
    let totalPadding = padding - input.count
    let leftPadding = totalPadding / 2
    let rightPadding = totalPadding - leftPadding
    
    return String(repeating: " ", count: leftPadding) + input + String(repeating: " ", count: rightPadding)
}



func variableNameFor(register: AVRModules.Module.RegisterGroup.Register) -> String {
    switch register.name {
    case .TIMSK0, .TIMSK1, .TIMSK2, .TIMSK3, .TIMSK4, .TIMSK5:
        return "interruptMaskRegister"
    case .TIFR0, .TIFR1, .TIFR2, .TIFR3, .TIFR4, .TIFR5:
        return "interruptFlagRegister"
    case .TCCR0A, .TCCR1A, .TCCR2A, .TCCR3A, .TCCR4A, .TCCR5A:
        return "controlRegisterA"
    case .TCCR0B, .TCCR1B, .TCCR2B, .TCCR3B, .TCCR4B, .TCCR5B:
        return "controlRegisterB"
    case .TCNT0, .TCNT1, .TCNT2, .TCNT3, .TCNT4, .TCNT5:
        return "number" // TODO: What should this be called? "number"?
    case .OCR0B, .OCR1B, .OCR2B, .OCR3B, .OCR4B, .OCR5B:
        return "outputCompareRegisterB"
    case .OCR0A, .OCR1A, .OCR2A, .OCR3A, .OCR4A, .OCR5A:
        return "outputCompareRegisterA"
    case .ASSR:
        return "asynchronousStatusRegister"
    case .GTCCR:
        return "generalControlRegister"
    default :
        var variableName = register.caption?.rawValue ?? ""
        variableName = variableName.filter { $0 != " " }
        variableName = variableName.filter { $0 != "/" }
        variableName = variableName.filter { $0 != "0" }
        variableName = variableName.filter { $0 != "1" }
        variableName = variableName.filter { $0 != "2" }
        variableName = variableName.filter { $0 != "3" }
        variableName = variableName.filter { $0 != "4" }
        variableName = variableName.filter { $0 != "5" }
        return variableName.prefix(1).lowercased() + variableName.dropFirst()
    }
}

func generateRegister(register: AVRModules.Module.RegisterGroup.Register, bitSize: timerBitSize) -> MemberBlockItemSyntax {
    
    let variableName = variableNameFor(register: register)
    
    // If the register has bitfields then generate each bit name, if not then there is just one name for all of the bits.
    var registerName = ""
    
    if register.bitfield.isEmpty {
        registerName = padString(register.name.rawValue, padding: 63)
    } else {
        var bitNames = getBitNamesFrom(register: register)
        bitNames = bitNames.map { padString($0, padding: 7) }
        registerName = "\(bitNames[7])|\(bitNames[6])|\(bitNames[5])|\(bitNames[4])|\(bitNames[3])|\(bitNames[2])|\(bitNames[1])|\(bitNames[0])"
    }
    
    var registerBitSize: String {
        switch bitSize {
        case .eightBit:
            return "UInt8"
        case .sixteenBit:
            return "UInt16"
        default:
            return ""
        }
    }
    
    // TODO: Generate bit names and R/W in documentation table properly.
    // TODO: I don't think the UInt8 & UInt16 is set properly as the timer can be a 16 bit timer but only some of the registers need to be 16 bit while others are still 8 bit.
    let source = DeclSyntax(
      """
          /// \(raw: register.name) – \(raw: register.caption?.rawValue ?? variableName)
          ///```
          ///--------------------------------------------------------------------------------
          ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
          ///--------------------------------------------------------------------------------
          ///| (\(raw: register.offset.rawValue))       |\(raw: registerName)|
          ///--------------------------------------------------------------------------------
          ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
          ///--------------------------------------------------------------------------------
          ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
          ///--------------------------------------------------------------------------------
          ///```
          @inlinable
          @inline(__always)
          public static var \(raw: variableName): \(raw: registerBitSize) {
              get {
                  _volatileRegisterRead\(raw: registerBitSize)(\(raw: register.offset.rawValue))
              }
              set {
                  _volatileRegisterWrite\(raw: registerBitSize)(\(raw: register.offset.rawValue), newValue)
              }
          }
      """
    )
    
    return MemberBlockItemSyntax(decl: source)
}

struct SupplementalData {
    let variableName: String
    let valueType: String
    let defaultValue: String
    let documentation: String
}

func supplementalDataFor(bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalData {
    switch bitfield.name {
        // Interrupt Mask Register
    case .OCIE0B, .OCIE1B, .OCIE2B, .OCIE3B, .OCIE4B, .OCIE5B:
        return SupplementalData(variableName: "outputCompareMatchBInterruptEnable", valueType: "Bool", defaultValue: "", documentation: "")
    case .OCIE0A, .OCIE1A, .OCIE2A, .OCIE3A, .OCIE4A, .OCIE5A:
        return SupplementalData(variableName: "outputCompareMatchAInterruptEnable", valueType: "Bool", defaultValue: "", documentation: "")
    case .TOIE0, .TOIE1, .TOIE2, .TOIE3, .TOIE4, .TOIE5:
        return SupplementalData(variableName: "overflowInterruptEnable", valueType: "Bool", defaultValue: "", documentation: "")
        
        // Interrupt Flag Register
    case .OCF0B, .OCF1B, .OCF2B, .OCF3B, .OCF4B, .OCF5B:
        return SupplementalData(variableName: "outputCompareFlagB", valueType: "Bool", defaultValue: "", documentation: "")
    case .OCF0A, .OCF1A, .OCF2A, .OCF3A, .OCF4A, .OCF5A:
        return SupplementalData(variableName: "outputCompareFlagA", valueType: "Bool", defaultValue: "", documentation: "")
    case .TOV0, .TOV1, .TOV2, .TOV3, .TOV4, .TOV5:
        return SupplementalData(variableName: "overflowFlag", valueType: "Bool", defaultValue: "", documentation: "")
        
        // Control Register A
    case .COM0A, .COM1A, .COM2A, .COM3A, .COM4A, .COM5A:
        return SupplementalData(variableName: "compareOutputModeA", valueType: "Timer.CompareOutputMode", defaultValue: ".normal", documentation: outputCompareModeADocumentation)
    case .COM0B, .COM1B, .COM2B, .COM3B, .COM4B, .COM5B:
        return SupplementalData(variableName: "compareOutputModeB", valueType: "Timer.CompareOutputMode", defaultValue: ".normal", documentation: outputCompareModeBDocumentation)
    case .WGM0, .WGM1, .WGM2, .WGM3, .WGM4, .WGM5, .WGM00, .WGM02, .WGM01, .WGM20, .WGM21, .WGM22:
        return SupplementalData(variableName: "waveformGenerationMode", valueType: "WaveformGenerationMode", defaultValue: ".normal", documentation: waveformGenerationModeDocumentation)
        
        // Control Register B
    case .FOC0A, .FOC1A, .FOC2A, .FOC3A, .FOC4A, .FOC5A:
        return SupplementalData(variableName: "forceOutputCompareA", valueType: "Bool", defaultValue: "", documentation: forceOutputCompareADocumentation)
    case .FOC0B, .FOC1B, .FOC2B, .FOC3B, .FOC4B, .FOC5B:
        return SupplementalData(variableName: "forceOutputCompareB", valueType: "Bool", defaultValue: "", documentation: forceOutputCompareBDocumentation)
    case .CS0, .CS1, .CS2, .CS3, .CS4, .CS5:
        return SupplementalData(variableName: "prescaler", valueType: "InternalClockOnlyPrescaling", defaultValue: ".noClockSource", documentation: prescalerDocumentation) // TODO: This needs to know if the parent clock is an internal or external timer.
    
        // Asynchronous Status Register
    case .EXCLK:
        return SupplementalData(variableName: "enableExternalClockInput", valueType: "Bool", defaultValue: "", documentation: "")
    case .AS2:
        return SupplementalData(variableName: "asynchronousTimerCounter", valueType: "Bool", defaultValue: "", documentation: "")
    case .TCN2UB:
        return SupplementalData(variableName: "updateBusy", valueType: "Bool", defaultValue: "", documentation: "")
    case .OCR2AUB:
        return SupplementalData(variableName: "outputCompareRegisterAUpdateBusy", valueType: "Bool", defaultValue: "", documentation: "")
    case .OCR2BUB:
        return SupplementalData(variableName: "outputCompareRegisterBUpdateBusy", valueType: "Bool", defaultValue: "", documentation: "")
    case .TCR2AUB:
        return SupplementalData(variableName: "controlRegisterAUpdateBusy", valueType: "Bool", defaultValue: "", documentation: "")
    case .TCR2BUB:
        return SupplementalData(variableName: "controlRegisterBUpdateBusy", valueType: "Bool", defaultValue: "", documentation: "")
        
    
        // General Timer/Counter Control Register
    case .TSM:
        return SupplementalData(variableName: "timerSynchronizationMode", valueType: "Timer.TimerSynchronizationMode", defaultValue: ".disabled", documentation: timerSynchronizationModeDocumentation)
    case .PSRASY:
        return SupplementalData(variableName: "prescalerReset", valueType: "Bool", defaultValue: "", documentation: "")
        
    default :
        return SupplementalData(variableName: "", valueType: "", defaultValue: "", documentation: "")
    }
}

var wmgBitfieldA: (bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield, parentVariableName: String)? = nil

func generateSplitBitfieldAccessor(
    bitfieldA: AVRModules.Module.RegisterGroup.Register.Bitfield,
    bitfieldB: AVRModules.Module.RegisterGroup.Register.Bitfield,
    parentVariableNameA: String,
    parentVariableNameB: String,
    bitSize: timerBitSize) -> MemberBlockItemSyntax {
    
    let caption = bitfieldA.caption?.rawValue ?? "" // .filter { $0 != " " } // TODO: Print some kind of error.
    let info = supplementalDataFor(bitfield: bitfieldA)
    
    var timerType: String {
        switch bitSize {
        case .eightBit:
            return "Timer8Bit"
        case .sixteenBit:
            return "Timer16Bit"
        default:
            return ""
        }
    }
    
    let bitmaskA = bitfieldA.mask.value.lowByte.binaryString
    let bitshiftA = UInt8(bitfieldA.mask.value.trailingZeroBitCount)
    let enumBitmaskA = (bitfieldA.mask.value.lowByte >> bitshiftA).binaryString
    
    let bitmaskB = bitfieldB.mask.value.lowByte.binaryString
    let bitshiftB = UInt8(bitfieldB.mask.value.trailingZeroBitCount)
    let enumBitmaskB = (bitfieldB.mask.value.lowByte >> bitshiftB).binaryString
    
    let source = DeclSyntax(
      """
          /// \(raw: bitfieldA.name) – \(raw: caption) \(raw: info.documentation)
          @inlinable
          @inline(__always)
          public static var \(raw: info.variableName): \(raw: timerType).\(raw: info.valueType) {
              get {
                  let mode = ((\(raw: parentVariableNameB) & \(raw: bitmaskB)) >> 1) | (\(raw: parentVariableNameA) & \(raw: bitmaskA))
                  return \(raw: timerType).\(raw: info.valueType)(rawValue: mode) ?? \(raw: info.defaultValue)
              }
              set {
                  \(raw: parentVariableNameA) |= (newValue.rawValue & \(raw: enumBitmaskA)) << UInt8(\(raw: bitshiftA)))
                  \(raw: parentVariableNameB) |= ((newValue.rawValue & \(raw: enumBitmaskB)) << UInt8(\(raw: bitshiftB)))
              }
          }
      """
    )
    
    return MemberBlockItemSyntax(decl: source)
}


// TODO: Pass the parent register name to this function so I can set the bits on the parent register.
func generateBitfieldAccessor(bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield, parentVariableName: String, bitSize: timerBitSize) -> MemberBlockItemSyntax {
    
    // The WGM Bitfield is split between two registers so this takes special handling.
    switch bitfield.name {
    case .WGM0, .WGM1, .WGM2, .WGM3, .WGM4, .WGM5, .WGM00, .WGM02, .WGM01, .WGM20, .WGM21, .WGM22:
        print()
        print("Bitfield: \(bitfield.name)")
        if let wgmBitfield = wmgBitfieldA {
            print("Privious Bitfield: \(wgmBitfield.bitfield.name)")
            let bitFieldAccessor = generateSplitBitfieldAccessor(bitfieldA: wgmBitfield.bitfield, bitfieldB: bitfield, parentVariableNameA: wgmBitfield.parentVariableName, parentVariableNameB: parentVariableName, bitSize: bitSize)
            wmgBitfieldA = nil
            return bitFieldAccessor
        } else {
            print("New Bitfield: \(bitfield.name)")
            wmgBitfieldA = (bitfield, parentVariableName)
            return MemberBlockItemSyntax(decl: DeclSyntax("")) // Return nothing
        }
    default:
        break
    }
    
    let caption = bitfield.caption?.rawValue ?? "" // .filter { $0 != " " } // TODO: Print some kind of error.
    let info = supplementalDataFor(bitfield: bitfield)
    let bitmask = bitfield.mask.value.lowByte.binaryString
    let bitshift = UInt8(bitfield.mask.value.trailingZeroBitCount)
    let enumBitmask = (bitfield.mask.value.lowByte >> bitshift).binaryString
    
    // TODO: Generate bit names and R/W in documentation table properly.
    // TODO: I don't think the UInt8 & UInt16 is set properly as the timer can be a 16 bit timer but only some of the registers need to be 16 bit while others are still 8 bit.
    let source = DeclSyntax(
      """
          /// \(raw: bitfield.name) – \(raw: caption) \(raw: info.documentation)
          @inlinable
          @inline(__always)
          public static var \(raw: info.variableName): \(raw: info.valueType) {
              get {
                  let mode = (\(raw: parentVariableName) & \(raw: bitmask)) >> UInt8(\(raw: bitshift))
                  return \(raw: info.valueType).init(rawValue: mode) ?? \(raw: info.defaultValue)
              }
              set {
                  \(raw: parentVariableName) |= (newValue.rawValue & \(raw: enumBitmask)) << UInt8(\(raw: bitshift))
              }
          }
      """
    )
    
    let sourceForBool = DeclSyntax(
      """
          /// \(raw: bitfield.name) – \(raw: caption) \(raw: info.documentation)
          @inlinable
          @inline(__always)
          public static var \(raw: info.variableName): \(raw: info.valueType) {
              get {
                  let flag = (\(raw: parentVariableName) & \(raw: bitmask)) >> UInt8(\(raw: bitshift))
                  return flag == 1
              }
              set {
                  \(raw: parentVariableName) |= (newValue ? 1 : 0) & \(raw: enumBitmask) << UInt8(\(raw: bitshift))
              }
          }
      """
    )
    
    if info.valueType == "Bool" {
        return MemberBlockItemSyntax(decl: sourceForBool)
    } else {
        return MemberBlockItemSyntax(decl: source)
    }
}



// Note: These are only here for being able to build as these symbols are not linked like they would be in a true HAL project.
//func _volatileRegisterReadUInt8(_: UInt16) -> UInt8 { return 0 }
//
//func _volatileRegisterWriteUInt8(_: UInt16, _: UInt8) { }

let outputCompareModeADocumentation: String = """
\n    ///
    /// These bits control the Output Compare pin (OC2A) behavior. If one or both of the COM2A1:0 bits are set, the
    /// OC2A output overrides the normal port functionality of the I/O pin it is connected to. However, note that the Data
    /// Direction Register (DDR) bit corresponding to the OC2A pin must be set in order to enable the output driver.
    /// When OC2A is connected to the pin, the function of the COM2A1:0 bits depends on the WGM22:0 bit setting.
    /// Table 1 shows the COM2A1:0 bit functionality when the WGM22:0 bits are set to a normal or CTC mode
    /// (non-PWM).
    ///
    /// Table 1. Compare Output Mode, non-PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2A1| COM2A0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC0A disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Toggle OC2A on Compare Match                                     |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2A on Compare Match                                      |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2A on Compare Match                                        |
    ///---------------------------------------------------------------------------------------------
    ///```
    ///
    /// Table 2 shows the COM2A1:0 bit functionality when the WGM21:0 bits are set to fast PWM mode.
    ///
    /// Table 2. Compare Output Mode, Fast PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2A1| COM2A0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2A disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | WGM22 = 0: Normal Port Operation, OC0A Disconnected.             |
    ///|        |       |       | WGM22 = 1: Toggle OC2A on Compare Match.                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2A on Compare Match, set OC2A at BOTTOM,                 |
    ///|        |       |       | (non-inverting mode).                                            |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2A on Compare Match, clear OC2A at BOTTOM,                 |
    ///|        |       |       | (inverting mode).                                                |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2A equals TOP and COM2A1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at BOTTOM. See ”Fast PWM Mode” in datasheet  for more details.
    ///
    /// Table 3 shows the COM2A1:0 bit functionality when the WGM22:0 bits are set to phase correct PWM mode.
    ///
    /// Table 3. Compare Output Mode, Phase Correct PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2A1| COM2A0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2A disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | WGM22 = 0: Normal Port Operation, OC0A Disconnected.             |
    ///|        |       |       | WGM22 = 1: Toggle OC2A on Compare Match.                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2A on Compare Match when up-counting.                    |
    ///|        |       |       | Set OC2A on Compare Match when down-counting.                    |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2A on Compare Match when up-counting.                      |
    ///|        |       |       | Clear OC2A on Compare Match when down-counting.                  |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2A equals TOP and COM2A1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at TOP. See ”Phase Correct PWM Mode” in datasheet for more details.
    ///
"""

let outputCompareModeBDocumentation: String = """
\n    /// See ATMega328p Datasheet Table 18-5, Table 18-6, and Table 18-7.
    ///
    /// These bits control the Output Compare pin (OC2B) behavior. If one or both of the COM2B1:0 bits are set, the
    /// OC2B output overrides the normal port functionality of the I/O pin it is connected to. However, note that the Data
    /// Direction Register (DDR) bit corresponding to the OC2B pin must be set in order to enable the output driver.
    /// When OC2B is connected to the pin, the function of the COM2B1:0 bits depends on the WGM22:0 bit setting.
    /// Table 18-5 shows the COM2B1:0 bit functionality when the WGM22:0 bits are set to a normal or CTC mode
    /// (non-PWM).
    ///
    /// Table 18-5. Compare Output Mode, non-PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2B1| COM2B0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC0B disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Toggle OC2B on Compare Match                                     |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2B on Compare Match                                      |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2B on Compare Match                                        |
    ///---------------------------------------------------------------------------------------------
    ///```
    ///
    /// Table 18-6 shows the COM2B1:0 bit functionality when the WGM22:0 bits are set to fast PWM mode.
    ///
    /// Table 18-6. Compare Output Mode, Fast PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2B1| COM2B0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2B disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Reserved                                                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2B on Compare Match, set OC2B at BOTTOM,                 |
    ///|        |       |       | (non-inverting mode).                                            |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2B on Compare Match, clear OC2B at BOTTOM,                 |
    ///|        |       |       | (inverting mode).                                                |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2B equals TOP and COM2B1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at BOTTOM. See ”Phase Correct PWM Mode” on page 157 for more
    ///       details.
    ///
    /// Table 18-7 shows the COM2B1:0 bit functionality when the WGM22:0 bits are set to phase correct PWM mode.
    ///
    /// Table 18-7. Compare Output Mode, Phase Correct PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2B1| COM2B0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2B disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Reserved                                                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2B on Compare Match when up-counting.                    |
    ///|        |       |       | Set OC2B on Compare Match when down-counting.                    |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2B on Compare Match when up-counting.                      |
    ///|        |       |       | Clear OC2B on Compare Match when down-counting.                  |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2B equals TOP and COM2B1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at TOP. See ”Phase Correct PWM Mode” on page 157 for more details.
    ///
"""

let waveformGenerationModeDocumentation: String = """
\n    ///
    /// Combined with the WGM22 bit found in the TCCR2B Register, these bits control the counting sequence of the
    /// counter, the source for maximum (TOP) counter value, and what type of waveform generation to be used, see
    /// Table 18-8. Modes of operation supported by the Timer/Counter unit are: Normal mode (counter), Clear Timer
    /// on Compare Match (CTC) mode, and two types of Pulse Width Modulation (PWM) modes (see ”Modes of
    /// Operation” on page 155).
    ///
    /// Table 18-8. Waveform Generation Mode Bit Description
    ///```
    ///-----------------------------------------------------------------------------------------------------
    ///|  Mode  | WGM22 | WGM21 | WGM20 | Mode of Operation  |  TOP  | Update of OCRx at | TOV Flag Set on |
    ///-----------------------------------------------------------------------------------------------------
    ///|    0   |   0   |   0   |   0   | Normal             | 0xFF  | Immediate         | MAX             |
    ///-----------------------------------------------------------------------------------------------------
    ///|    1   |   0   |   0   |   1   | PWM, Phase Correct | 0xFF  | TOP               | BOTTOM          |
    ///-----------------------------------------------------------------------------------------------------
    ///|    2   |   0   |   1   |   0   | CTC                | OCRA  | Immediate         | MAX             |
    ///-----------------------------------------------------------------------------------------------------
    ///|    3   |   0   |   1   |   1   | Fast PWM           | 0xFF  | BOTTOM            | MAX             |
    ///-----------------------------------------------------------------------------------------------------
    ///|    4   |   1   |   0   |   0   | Reserved           |   -   |         -         |        -        |
    ///-----------------------------------------------------------------------------------------------------
    ///|    5   |   1   |   0   |   1   | PWM, Phase Correct | OCRA  | TOP               | BOTTOM          |
    ///-----------------------------------------------------------------------------------------------------
    ///|    6   |   1   |   1   |   0   | Reserved           |   -   |         -         |        -        |
    ///-----------------------------------------------------------------------------------------------------
    ///|    7   |   1   |   1   |   1   | Fast PWM           | OCRA  | BOTTOM            | TOP             |
    ///-----------------------------------------------------------------------------------------------------
    ///```
    /// Notes: 1. MAX= 0xFF
    ///      2. BOTTOM= 0x00
    ///
"""

let prescalerDocumentation: String = """
\n    /// The three Clock Select bits select the clock source to be used by the Timer/Counter, see Table 18-9 on page 165.
    ///
    /// Table 18-9. Clock Select Bit Description
    ///```
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |  Mode  | CS22  | CS21  | CS20  | Description                                                     |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    0   |   0   |   0   |   0   | No clock source (Timer/Counter stopped)                         |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    1   |   0   |   0   |   1   | clk T2S/(No prescaling)                                         |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    2   |   0   |   1   |   0   | clk T2S/8 (From prescaler)                                      |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    3   |   0   |   1   |   1   | clk T2S/32 (From prescaler)                                     |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    4   |   1   |   0   |   0   | clkI T2S/64 (From prescaler)                                    |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    5   |   1   |   0   |   1   | clkI T2S/128 (From prescaler)                                   |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    6   |   1   |   1   |   0   | clkI T2S/256 (From prescaler)                                   |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    7   |   1   |   1   |   1   | clkI T2S/1024 (From prescaler)                                  |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// ```
    /// If external pin modes are used for the Timer/Counter0, transitions on the T0 pin will clock the counter even if the
    /// pin is configured as an output. This feature allows software control of the counting.
    ///
    /// Note: In the datasheet this is called the Clock Select. Prescaler is probably more descriptive.
"""

let timerSynchronizationModeDocumentation: String = """
\n    ///
    /// Writing the TSM bit to one activates the Timer/Counter Synchronization mode. In this mode, the value that is
    /// written to the PSRASY and PSRSYNC bits is kept, hence keeping the corresponding prescaler reset signals
    /// asserted. This ensures that the corresponding Timer/Counters are halted and can be configured to the same
    /// value without the risk of one of them advancing during configuration. When the TSM bit is written to zero, the
    /// PSRASY and PSRSYNC bits are cleared by hardware, and the Timer/Counters start counting simultaneously.
    ///
"""

let forceOutputCompareADocumentation: String = """
\n    ///
    /// The FOC2A bit is only active when the WGM bits specify a non-PWM mode.
    /// However, for ensuring compatibility with future devices, this bit must be set to zero when TCCR2B is written
    /// when operating in PWM mode. When writing a logical one to the FOC2A bit, an immediate Compare Match is
    /// forced on the Waveform Generation unit. The OC2A output is changed according to its COM2A1:0 bits setting.
    /// Note that the FOC2A bit is implemented as a strobe. Therefore it is the value present in the COM2A1:0 bits that
    /// determines the effect of the forced compare.
    /// A FOC2A strobe will not generate any interrupt, nor will it clear the timer in CTC mode using OCR2A as TOP.
    /// The FOC2A bit is always read as zero.
"""

let forceOutputCompareBDocumentation: String = """
\n    ///
    /// The FOC2B bit is only active when the WGM bits specify a non-PWM mode.
    /// However, for ensuring compatibility with future devices, this bit must be set to zero when TCCR2B is written
    /// when operating in PWM mode. When writing a logical one to the FOC2B bit, an immediate Compare Match is
    /// forced on the Waveform Generation unit. The OC2B output is changed according to its COM2B1:0 bits setting.
    /// Note that the FOC2B bit is implemented as a strobe. Therefore it is the value present in the COM2B1:0 bits that
    /// determines the effect of the forced compare.
    /// A FOC2B strobe will not generate any interrupt, nor will it clear the timer in CTC mode using OCR2B as TOP.
    /// The FOC2B bit is always read as zero.
"""
