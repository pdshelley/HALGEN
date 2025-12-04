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
    var timerFiles: [GeneratedCodeFile] = []
    
    // TODO: Are there timers A and B? What does TCA stand for?
    // Classic AVR does not use timers A and B, this is an indication of a "new" AVR. These cases need to be handled.
    
    // Filter for Modules named "PORT" // TODO: Find a better way to filter.
    for module in file.modules.module {
        for registerGroup in module.registerGroup {
            switch registerGroup.name {
            case .TC0:
                timerFiles.append(buildTimer(module: module, timerName: "Timer0", chipName: file.devices.device.name))
            case .TC1:
                timerFiles.append(buildTimer(module: module, timerName: "Timer1", chipName: file.devices.device.name))
            case .TC2:
                timerFiles.append(buildTimer(module: module, timerName: "Timer2", chipName: file.devices.device.name))
            case .TC3:
                timerFiles.append(buildTimer(module: module, timerName: "Timer3", chipName: file.devices.device.name))
            case .TC4:
                timerFiles.append(buildTimer(module: module, timerName: "Timer4", chipName: file.devices.device.name))
            case .TC5:
                timerFiles.append(buildTimer(module: module, timerName: "Timer5", chipName: file.devices.device.name))
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

func gatherTimerInfoFrom(module: AVRModules.Module) -> TimerInfo {
    var bitSize: TimerInfo.BitSize = .eightBit
    var isAsync: Bool = false
    
    // The name of the module indicates if it is 8 or 16 bit as well as if it is Async.
    // TODO: Check to see if any 16 bit timers have
    switch module.name {
    case .tc8Async:
        isAsync = true
        bitSize = .eightBit
    case .tc8:
        bitSize = .eightBit
    case .tc10:
        bitSize = .tenBit
    case .tc16:
        bitSize = .sixteenBit
    default: ()
    }
    
    return TimerInfo(isAsynchronous: isAsync, bitSize: bitSize)
}

func buildProtocolDeclarationsFrom(info: TimerInfo) -> String {
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

func buildTimer(module: AVRModules.Module, timerName: String, chipName: String) -> GeneratedCodeFile {
    print("------------------\(timerName)------------------")
    let fileName = "\(timerName).swift"
    var code: String = buildFileHeaderFor(fileName: timerName)
    let timerInfo = gatherTimerInfoFrom(module: module)
    var memberBlockList = MemberBlockItemListSyntax()
    let protocolDeclarations = buildProtocolDeclarationsFrom(info: timerInfo) // buildProtocolDeclarationsFrom(module: module)
    
    for registerGroup in module.registerGroup {
        for register in registerGroup.register {
            let memberBlock = generateRegister(register: register, bitSize: timerInfo.bitSize) // TODO: add this to the stored member blocks
            memberBlockList.append(memberBlock)
            
//            let registerVariableName = variableNameFor(register: register)
//            let registerVariableName = variableNameFromString(register.caption?.rawValue ?? "") // .filter { $0 != " " } // TODO: Print some kind of error.
            
            // TODO: Generate Bitfield Accessor EX: Wave Form Generation Mode (WGM)
            for bitfield in register.bitfield {
                
                switch bitfield.name {
                    // TODO: Move the WGM logic here?
                    // The WGM Bitfield is split between two registers so this takes special handling.
//                case .WGM0, .WGM1, .WGM2, .WGM3, .WGM4, .WGM5, .WGM00, .WGM02, .WGM01, .WGM20, .WGM21, .WGM22:
//                    print()
//                    print("Bitfield: \(bitfield.name)")
//                    if let wgmBitfield = wmgBitfieldA {
//                        print("Privious Bitfield: \(wgmBitfield.bitfield.name)")
//                        let bitFieldAccessor = generateSplitBitfieldAccessor(bitfieldA: wgmBitfield.bitfield, bitfieldB: bitfield, parentVariableNameA: wgmBitfield.parentVariableName, parentVariableNameB: parentVariableName, timerInfo: timerInfo)
//                        wmgBitfieldA = nil
//                        return bitFieldAccessor
//                    } else {
//                        print("New Bitfield: \(bitfield.name)")
//                        wmgBitfieldA = (bitfield, parentVariableName)
//                        return MemberBlockItemSyntax(decl: DeclSyntax("")) // Return nothing
//                    }
                case .CS0, .CS1, .CS2, .CS3, .CS4, .CS5:
                    // Generate The Enum
                    if let valueGroupName = bitfield.values?.rawValue {
                        for valueGroup in module.valueGroup {
                            // Make sure that the name of the valueGroup matches
                            if valueGroup.name.rawValue == valueGroupName {
                                let bitfieldMemberBlock = generateEnumFrom(ValueGroup: valueGroup, bitfieldName: bitfield.name.rawValue)
                                memberBlockList.append(bitfieldMemberBlock)
                            }
                        }
                    }
                    
                    // Then Generate the standard Bitfield Accessor
                    let bitfieldMemberBlock = generateBitfieldAccessor(bitfield: bitfield, parentVariable: register, timerInfo: timerInfo, chipName: chipName)
                    memberBlockList.append(bitfieldMemberBlock)
                default:
                    // Generate the standard Bitfield Accessor
                    let bitfieldMemberBlock = generateBitfieldAccessor(bitfield: bitfield, parentVariable: register, timerInfo: timerInfo, chipName: chipName)
                    memberBlockList.append(bitfieldMemberBlock)
                }
            }
        }
    }
    
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
        return "count"
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

func generateRegister(register: AVRModules.Module.RegisterGroup.Register, bitSize: TimerInfo.BitSize) -> MemberBlockItemSyntax {
    
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

func supplementalData(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield, with timerInfo: TimerInfo) -> SupplementalData {
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
        return SupplementalData(variableName: "prescaler", valueType: "Prescaling", defaultValue: ".stopped", documentation: prescalerDocumentation)
    
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
        return SupplementalData(variableName: "prescalerReset", valueType: "Bool", defaultValue: "", documentation: prescalerResetDocumentation)
    case .PSRSYNC:
        return SupplementalData(variableName: "prescalerResetSync", valueType: "Bool", defaultValue: "", documentation: prescalerResetSyncDocumentation)
        
    default :
        return SupplementalData(variableName: "", valueType: "", defaultValue: "", documentation: "")
    }
}

var wmgBitfieldA: (bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield, parentVariable: AVRModules.Module.RegisterGroup.Register)? = nil

func generateSplitBitfieldAccessor(bitfieldA: AVRModules.Module.RegisterGroup.Register.Bitfield, bitfieldB: AVRModules.Module.RegisterGroup.Register.Bitfield, parentVariableA: AVRModules.Module.RegisterGroup.Register, parentVariableB: AVRModules.Module.RegisterGroup.Register, timerInfo: TimerInfo, chipName: String) -> MemberBlockItemSyntax {
    
    // TODO: Some chips only seem to have 1 bite for WGM. This breaks this logic and should be accounted for.
    
    // Example Data:
    // Register A Bitmask:           0b00000011
    // Register B Bitmask:           0b00001000
    // New Value Bitmask:            0b00000111
    // Register B New Value Bitmask: 0b00000100
    // Register B Bitshift should be: << 1 to get back to the "Register B Bitmask" location
    
    
    // The Below logic does not work for this second example
    
    // Another Example:
    // Register A Bitmask:           0b00000011
    // Register B Bitmask:           0b00000011
    // New Value Bitmask:            0b00001111
    // Register B New Value Bitmask: 0b00001100
    // Register B Bitshift should be: << 2 to get back to the "Register B Bitmask" location
    
    let caption = bitfieldA.caption?.rawValue ?? "" // .filter { $0 != " " } // TODO: Print some kind of error.
    let info = supplementalData(for: bitfieldA, with: timerInfo)
    
    var lowBitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
    var lowParentVariableName: String
    var highBitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
    var hightParentVariableName: String
    
    // The LSBs of WMG should always be on TCCRnA and the MSBs should be on TCCRnB.
    
    switch parentVariableA.name {
    case .TCCR0A, .TCCR1A, .TCCR2A, .TCCR3A, .TCCR4A, .TCCR5A:
        lowBitfield = bitfieldA
        lowParentVariableName = variableNameFor(register: parentVariableA)
        highBitfield = bitfieldB
        hightParentVariableName = variableNameFor(register: parentVariableB)
    case .TCCR0B, .TCCR1B, .TCCR2B, .TCCR3B, .TCCR4B, .TCCR5B:
        lowBitfield = bitfieldB
        lowParentVariableName = variableNameFor(register: parentVariableB)
        highBitfield = bitfieldA
        hightParentVariableName = variableNameFor(register: parentVariableA)
    case .TCCR2, .TCCR0, .TCCR4D: // ATmega8, ATmega16, ATmega16U4 // I think this only has one TCCR register.
        print("Failed to generate WaveformGenerationMode Accessor.")
        logs.addLog("Failed to generate WaveformGenerationMode Accessor. The register: \(parentVariableA.name) has something different that needs to be handled.", toChip: chipName) // TODO: Set to the correct chip name!
        let source = DeclSyntax("")
        return MemberBlockItemSyntax(decl: source)
    default :
        // By having a default case that is different from the logging case above I can have two levels of errors.
        // Forced errors at run time that will show me every case that has issues which have been added to the case above to fail more gracefully and can be known, researched, and fixed.
        fatalError("Unhandled parent variable name for WaveformGenerationMode: \(parentVariableA.name.rawValue)")
    }
    
    // Mask Value is 16 Bits and we have to have 8. Assuming that it's a total error to have a mask with bits above 8 we will just throw those away.
    let lowBitmask = lowBitfield.mask.value.lowByte.binaryString
    let highBitmask = highBitfield.mask.value.lowByte.binaryString
    
    
    
    
    // We then make sure that the byte is shifted all the way over to the Least Significant Bit because the value assigned will also be in the Least Significant Bits.
    let lowBitshift = UInt8(lowBitfield.mask.value.trailingZeroBitCount)
//    let highBitshift = UInt8(highBitfield.mask.value.trailingZeroBitCount)
    
    // Then turn all of this into a bianary string for legibility, a bitmask should be seen as bits and not an Int or Hex value.
    let newValueLowBitmask = (lowBitfield.mask.value.lowByte >> lowBitshift).binaryString
    
    print()
    print("-----------------------------------------------------------")
    print("Low Bitmask Value: \(lowBitfield.mask.value), Mask: \(lowBitmask), Shift: \(lowBitshift)")
//    print("high Bitmask Value: \(highBitfield.mask.value), Mask: \(highBitmask), Shift: \(highBitshift)")
//    print("adjustedHighBitshift = \(highBitshift) - \(UInt8(lowBitfield.mask.value.nonzeroBitCount))")
    print("-----------------------------------------------------------")
    print()
    
    // This would give me the number of bits to shift, assuming that there is only a single group of bits and not two or more groups split by one or more 0s.
    // The difference between the Bitfield Bitmask and the newValue Bitmask This should account for shifting in either direction.
    let adjustedHighBitshift = Int8(highBitfield.mask.value.trailingZeroBitCount) - Int8(lowBitfield.mask.value.nonzeroBitCount)
    let getShiftDirection: String = adjustedHighBitshift >= 0 ? ">>" : "<<"
    let setShiftDirection: String = adjustedHighBitshift >= 0 ? "<<" : ">>"
    
    
    // Make sure the high bitmask is shifted all the way to the right and then shift it back by the LSB. This should always put it in the correct position for the newValueHighBitmask
    let newValueHighBitmask = ((highBitfield.mask.value.lowByte >> highBitfield.mask.value.trailingZeroBitCount) << lowBitfield.mask.value.nonzeroBitCount).binaryString
    
    let source = DeclSyntax(
      """
          /// \(raw: bitfieldA.name) – \(raw: caption) \(raw: info.documentation)
          @inlinable
          @inline(__always)
          public static var \(raw: info.variableName): \(raw: timerInfo.timerProtocol).\(raw: info.valueType) {
              get {
                  let mode = ((\(raw: hightParentVariableName) & \(raw: highBitmask)) \(raw: getShiftDirection) \(raw: abs(adjustedHighBitshift))) | (\(raw: lowParentVariableName) & \(raw: lowBitmask))
                  return \(raw: timerInfo.timerProtocol).\(raw: info.valueType)(rawValue: mode) ?? \(raw: info.defaultValue)
              }
              set {
                  \(raw: lowParentVariableName) |= ((newValue.rawValue & \(raw: newValueLowBitmask)) << UInt8(\(raw: lowBitshift)))
                  \(raw: hightParentVariableName) |= ((newValue.rawValue & \(raw: newValueHighBitmask)) \(raw: setShiftDirection) UInt8(\(raw: abs(adjustedHighBitshift))))
              }
          }
      """
    )
    
    return MemberBlockItemSyntax(decl: source)
}

/// This takes messy string data that should be a number and tries to convert it to a UInt8. Default Value is 0.
/// - Parameter stringValue: Hex values as a string, Intigers as a string, or anything else that will default to 0
/// - Returns: UInt8. If the number is greater than 8 Bit Max then return 0.
func numberFromValue(stringValue: String) -> UInt8 {
    let trimmedString = stringValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
    // Empty string → default
    guard !trimmedString.isEmpty else { return 0 }
    
    // Hex: either starts with "0x" or consists only of hex digits
    let hexString: String
    if trimmedString.hasPrefix("0x") {
        hexString = String(trimmedString.dropFirst(2))
    } else if trimmedString.allSatisfy({ $0.isHexDigit }) {
        hexString = trimmedString
    } else {
        hexString = ""
    }
    
    // Try hex first
    if !hexString.isEmpty,
        let value = UInt8(hexString, radix: 16), value <= 255 {
        return value
    }
    
    // Then try decimal
    if let value = UInt8(trimmedString), value <= 255 {
        return value
    }
    
    // Anything else (text, out-of-range, etc.) → default
    return 0
}

func generateEnumFrom(ValueGroup: AVRModules.Module.ValueGroup, bitfieldName: String) -> MemberBlockItemSyntax {
    
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
        case .NOCLOCKSOURCESTOPPED, .NOCLOCKSOURCETIMERCOUNTERSTOPPED, .NOCLOCKSOURCETIMERCOUNTER0STOPPED, .NOCLOCKSOURCETIMERCOUNTER2STOPPED:
            description = "No Clock Source (Stopped)"
            enumValue = "stopped"
        case .RUNNINGNOPRESCALING:
            description = "Running, No Prescaling"
            enumValue = "runningWithoutPrescaling"
        case .RUNNINGCLK8:
            description = "Running, CLK/8"
            enumValue = "running8"
        case .RUNNINGCLK16:
            description = "Running, CLK/16"
            enumValue = "running16"
        case .RUNNINGCLK32:
            description = "Running, CLK/32"
            enumValue = "running32"
        case .RUNNINGCLK64:
            description = "Running, CLK/64"
            enumValue = "running64"
        case .RUNNINGCLK128:
            description = "Running, CLK/128"
            enumValue = "running128"
        case .RUNNINGCLK256:
            description = "Running, CLK/256"
            enumValue = "running256"
        case .RUNNINGCLK1024:
            description = "Running, CLK/1024"
            enumValue = "running1024"
        case .RUNNINGEXTCLKTNFALLINGEDGE:
            description = "External clock source. Clock on falling edge."
            enumValue = "runningExternalFallingEdge"
        case .RUNNINGEXTCLKTNRISINGEDGE:
            description = "External clock source. Clock on rising edge."
            enumValue = "runningExternalRisingEdge"
        default:
            description = ""
        }
        
        // Note: Can't Convert in the Codable conversion because there is messy data that is not always numbers.
        let number = numberFromValue(stringValue: value.value.rawValue)
        
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
    )
    
    return MemberBlockItemSyntax(decl: source)
}

// TODO: Pass the parent register name to this function so I can set the bits on the parent register.
func generateBitfieldAccessor(bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield, parentVariable: AVRModules.Module.RegisterGroup.Register, timerInfo: TimerInfo, chipName: String) -> MemberBlockItemSyntax {
    
    switch bitfield.name {
        // The WGM Bitfield is split between two registers so this takes special handling.
    case .WGM0, .WGM1, .WGM2, .WGM3, .WGM4, .WGM5, .WGM00, .WGM01, .WGM02, .WGM10, .WGM13, .WGM20, .WGM21, .WGM22, .WGM32, .WGM33, .WGM42, .WGM43, .WGMODE:
        print()
        print("Bitfield: \(bitfield.name)")
        if let wgmBitfield = wmgBitfieldA { // If we previously found and saved a WGM Bitfield
            print("Privious Bitfield: \(wgmBitfield.bitfield.name)")
            let bitFieldAccessor = generateSplitBitfieldAccessor(bitfieldA: wgmBitfield.bitfield, bitfieldB: bitfield, parentVariableA: wgmBitfield.parentVariable, parentVariableB: parentVariable, timerInfo: timerInfo, chipName: chipName)
            wmgBitfieldA = nil // Clear for next Timer
            return bitFieldAccessor
        } else {  // We have not previously found and saved a WGM Bitfield
            print("New Bitfield: \(bitfield.name)")
            wmgBitfieldA = (bitfield, parentVariable) // Save for later when we find the second half
            return MemberBlockItemSyntax(decl: DeclSyntax("")) // Return nothing
        }
    default:
        break
    }
    
    let parentVariableName = variableNameFor(register: parentVariable)
    
    let caption = bitfield.caption?.rawValue ?? "" // .filter { $0 != " " } // TODO: Print some kind of error.
    let info = supplementalData(for: bitfield, with: timerInfo)
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
\n    /// The three Clock Select bits select the clock source to be used by the Timer/Counter.
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

let prescalerResetDocumentation: String = """
\n    ///
    /// When this bit is one, the Timer/Counter2 prescaler will be reset. This bit is normally cleared immediately by
    /// hardware. If the bit is written when Timer/Counter2 is operating in asynchronous mode, the bit will remain one
    /// until the prescaler has been reset. The bit will not be cleared by hardware if the TSM bit is set. Refer to the
    /// description of the ”Bit 7 – TSM: Timer/Counter Synchronization Mode” for a description of the
    /// Timer/Counter Synchronization mode.
"""

let prescalerResetSyncDocumentation: String = """
\n    ///
    /// When this bit is one, Timer/Counter1 and Timer/Counter0 prescaler will be Reset. This bit is normally cleared
    /// immediately by hardware, except if the TSM bit is set. Note that Timer/Counter1 and Timer/Counter0 share the
    /// same prescaler and a reset of this prescaler will affect both timers.
"""
