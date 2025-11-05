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

func buildTimer(module: AVRModules.Module, timerName: String) -> GeneratedCodeFile {
    let fileName = "\(timerName).swift"
    var code: String = buildFileHeaderFor(fileName: timerName)
    
    let bitSize: String = {
        switch module.name {
        case .tc8, .tc8Async:
            return "UInt8"
        case .tc10, .tc16:
            return "UInt16"
        default:
            assertionFailure("Failed to find bit size.")
            return ""
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
                let bitfieldMemberBlock = generateBitfieldAccessor(bitfield: bitfield, parentVariableName: registerVariableName)
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
    print("Get Bit Names From Register:")
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
        return "timerCounter" // TODO: What should this be called? Number?
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

func generateRegister(register: AVRModules.Module.RegisterGroup.Register, bitSize: String) -> MemberBlockItemSyntax {
    
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
          public static var \(raw: variableName): \(raw: bitSize) {
              get {
                  _volatileRegisterRead\(raw: bitSize)(\(raw: register.offset.rawValue))
              }
              set {
                  _volatileRegisterWrite\(raw: bitSize)(\(raw: register.offset.rawValue), newValue)
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
        return SupplementalData(variableName: "compareOutputModeB", valueType: "Timer.CompareOutputMode", defaultValue: ".normal", documentation: "")
    case .WGM0, .WGM1, .WGM2, .WGM3, .WGM4, .WGM5:
        return SupplementalData(variableName: "waveformGenerationMode", valueType: "Timer8Bit.WaveformGenerationMode", defaultValue: ".normal", documentation: "") // TODO: Needs to know if this is an 8 bit or 16 bit timer.
        
        // Control Register B
    case .FOC0A, .FOC1A, .FOC2A, .FOC3A, .FOC4A, .FOC5A:
        return SupplementalData(variableName: "forceOutputCompareA", valueType: "", defaultValue: "", documentation: "") // TODO: Finish this in CoreAVR
    case .FOC0B, .FOC1B, .FOC2B, .FOC3B, .FOC4B, .FOC5B:
        return SupplementalData(variableName: "forceOutputCompareB", valueType: "", defaultValue: "", documentation: "") // TODO: Finish this in CoreAVR
    case .CS0, .CS1, .CS2, .CS3, .CS4, .CS5:
        return SupplementalData(variableName: "prescaler", valueType: "InternalClockOnlyPrescaling", defaultValue: ".noClockSource", documentation: "") // TODO: This needs to know if the parent clock is an internal or external timer.
    
        // Asynchronous Status Register
    case .EXCLK:
        return SupplementalData(variableName: "enableExternalClockInput", valueType: "", defaultValue: "", documentation: "")
    case .AS2:
        return SupplementalData(variableName: "asynchronousTimerCounter", valueType: "", defaultValue: "", documentation: "")
    case .TCN2UB:
        return SupplementalData(variableName: "updateBusy", valueType: "", defaultValue: "", documentation: "")
    case .OCR2AUB:
        return SupplementalData(variableName: "outputCompareRegisterUpdateBusy", valueType: "", defaultValue: "", documentation: "")
    case .OCR2BUB:
        return SupplementalData(variableName: "outputCompareRegisterUpdateBusy", valueType: "", defaultValue: "", documentation: "")
    case .TCR2AUB:
        return SupplementalData(variableName: "controlRegisterUpdateBusy", valueType: "", defaultValue: "", documentation: "")
    case .TCR2BUB:
        return SupplementalData(variableName: "controlRegisterUpdateBusy", valueType: "", defaultValue: "", documentation: "")
        
    
        // General Timer/Counter Control Register
    case .TSM:
        return SupplementalData(variableName: "timerSynchronizationMode", valueType: "Timer.TimerSynchronizationMode", defaultValue: ".disabled", documentation: "")
    case .PSRASY:
        return SupplementalData(variableName: "prescalerReset", valueType: "Bool", defaultValue: "", documentation: "")
        
    default :
        return SupplementalData(variableName: "", valueType: "", defaultValue: "", documentation: "")
    }
}


// TODO: Pass the parent register name to this function so I can set the bits on the parent register.
func generateBitfieldAccessor(bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield, parentVariableName: String) -> MemberBlockItemSyntax {
    
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
    
    return MemberBlockItemSyntax(decl: source)
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
