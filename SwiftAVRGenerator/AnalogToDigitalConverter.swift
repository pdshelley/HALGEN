//
//  AnalogToDigitalConverter.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 23/02/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

func buildAnalogToDigitalConverters(file: AVRToolsDeviceFile) -> [GeneratedCodeFile] {
    var analogToDigitalConverterFiles: [GeneratedCodeFile] = []
    
    if let module: AVRModules.Module = file.modules.module.first(where: { $0.name == .adc }) {
        analogToDigitalConverterFiles.append(buildAnalogToDigitalConverter(registerGroup: module.registerGroup.first!, chipName: file.devices.device.name))
    }
    
    return analogToDigitalConverterFiles
}

func buildAnalogToDigitalConverter(registerGroup: AVRModules.Module.RegisterGroup, chipName: String) -> GeneratedCodeFile {
    let fileName = "AnalogToDigitalConverter.swift"
    var code = buildFileHeader(for: fileName)
    var memberBlockList = MemberBlockItemListSyntax()
    
    // Generation of registers
    for register in registerGroup.register {
        memberBlockList.append(generateAnalogToDigitalConverterRegister(register: register, variableName: supplementalData(for: register).variableName))
    }
    
    let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())
        
    // Information needed to setup the Struct.
//    let InheritedType = InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "UARTPort"))
//    let inheritedTypeList = InheritedTypeListSyntax(arrayLiteral: InheritedType)
//    let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
    
    code.append(SourceFileSyntax {
        StructDeclSyntax(
            modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
            name: "AnalogToDigitalConverter",
//            inheritanceClause: inheritanceClause,
            memberBlock: memberBlock
        )
    }.formatted().description)
    
    return GeneratedCodeFile(fileName: fileName, content: code)
}

func generateAnalogToDigitalConverterRegister(register: AVRModules.Module.RegisterGroup.Register, variableName: String) -> MemberBlockItemSyntax {
    // If the register has bitfields then generate each bit name, if not then there is just one name for all of the bits.
        var registerName = ""
        var readWrite = ""
        let registerAccess = supplementalData(for: register).access
        let documentation = supplementalData(for: register).documentation
        
        if register.bitfield.isEmpty {
            registerName = padString(register.name.rawValue, padding: 63)
            readWrite = padString(registerAccess, padding: 63)
        } else {
            var bitNames = getBitNames(from: register)
            bitNames = bitNames.map { padString($0, padding: 7) }
            registerName = "\(bitNames[7])|\(bitNames[6])|\(bitNames[5])|\(bitNames[4])|\(bitNames[3])|\(bitNames[2])|\(bitNames[1])|\(bitNames[0])"
            
            var bitAccess = getBitAccess(from: register, parentAccess: registerAccess, supplementalData: supplementalData(for:)) // TODO: Check the register for it's access level
            bitAccess = bitAccess.map { padString($0, padding: 7) }
            readWrite = "\(bitAccess[7])|\(bitAccess[6])|\(bitAccess[5])|\(bitAccess[4])|\(bitAccess[3])|\(bitAccess[2])|\(bitAccess[1])|\(bitAccess[0])"
        }
        
        var bit: (size: String, atomicStart: String, atomicEnd: String) {
            switch register.size {
            case .one:
                return (size: "UInt8", atomicStart: "", atomicEnd: "")
            case .two:
                return (size: "UInt16", atomicStart: "atomic {", atomicEnd: " }")
            }
        }
        
        let source = DeclSyntax(
          """
              /// \(raw: register.name) – \(raw: register.caption?.rawValue ?? variableName) \(raw: documentation)
              ///```
              ///--------------------------------------------------------------------------------
              ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
              ///--------------------------------------------------------------------------------
              ///| (\(raw: register.offset.rawValue))       |\(raw: registerName)|
              ///--------------------------------------------------------------------------------
              ///| Read/Write   |\(raw: readWrite)|
              ///--------------------------------------------------------------------------------
              ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
              ///--------------------------------------------------------------------------------
              ///```
              @inlinable
              @inline(__always)
              public static var \(raw: variableName): \(raw: bit.size) {
                  get {
                      \(raw: bit.atomicStart)_volatileRegisterRead\(raw: bit.size)(\(raw: register.offset.rawValue))\(raw: bit.atomicEnd)
                  }
                  set {
                      \(raw: bit.atomicStart)_volatileRegisterWrite\(raw: bit.size)(\(raw: register.offset.rawValue), newValue)\(raw: bit.atomicEnd)
                  }
              }
          """
        ).with(\.trailingTrivia, .newlines(2))
        return MemberBlockItemSyntax(decl: source)
}

fileprivate func supplementalData(for register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData {
    switch register.name {
    case .ADMUX:
        return SupplementalRegisterData(variableName: "multiplexerSelectionRegister", valueType: "", defaultValue: "", documentation: "", access: Access.readWrite.rawValue)
    case .UCSR0A, .UCSR1A, .UCSR2A, .UCSR3A:
        return SupplementalRegisterData(variableName: "controlRegisterA", valueType: "", defaultValue: "", documentation: "", access: "")
    case .UCSR0B, .UCSR1B, .UCSR2B, .UCSR3B:
        return SupplementalRegisterData(variableName: "controlRegisterB", valueType: "", defaultValue: "", documentation: "", access: "")
    case .UCSR0C, .UCSR1C, .UCSR2C, .UCSR3C:
        return SupplementalRegisterData(variableName: "controlRegisterC", valueType: "", defaultValue: "", documentation: "", access: "")
    case .UCSR0D, .UCSR1D, .UCSR2D:
        return SupplementalRegisterData(variableName: "controlRegisterD", valueType: "", defaultValue: "", documentation: "", access: "")
    case .UBRR0, .UBRR1, .UBRR2, .UBRR3:
        return SupplementalRegisterData(variableName: "", valueType: "", defaultValue: "", documentation: "", access: "R/W")
    default :
        return SupplementalRegisterData(variableName: getVariableName(caption: register.caption?.rawValue ?? ""), valueType: "", defaultValue: "", documentation: "", access: "")
    }
}

fileprivate func supplementalData(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData {
    switch bitfield.name {
        // Interrupt Mask Register
    case .OCIE0B, .OCIE1B, .OCIE2B, .OCIE3B, .OCIE4B, .OCIE5B:
        return SupplementalBitfieldData(variableName: "outputCompareMatchBInterruptEnable", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .OCIE0A, .OCIE1A, .OCIE2A, .OCIE3A, .OCIE4A, .OCIE5A:
        return SupplementalBitfieldData(variableName: "outputCompareMatchAInterruptEnable", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .TOIE0, .TOIE1, .TOIE2, .TOIE3, .TOIE4, .TOIE5:
        return SupplementalBitfieldData(variableName: "overflowInterruptEnable", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ICIE0, .ICIE1, .ICIE3, .ICIE4, .ICIE5:
        return SupplementalBitfieldData(variableName: "inputCaptureInterruptEnable", valueType: "Bool", defaultValue: "", documentation: inputCaptureInterruptEnableDocumentation, access: .readWrite)
        
        // Interrupt Flag Register
    case .OCF0B, .OCF1B, .OCF2B, .OCF3B, .OCF4B, .OCF5B:
        return SupplementalBitfieldData(variableName: "outputCompareFlagB", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .OCF0A, .OCF1A, .OCF2A, .OCF3A, .OCF4A, .OCF5A:
        return SupplementalBitfieldData(variableName: "outputCompareFlagA", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .TOV0, .TOV1, .TOV2, .TOV3, .TOV4, .TOV5:
        return SupplementalBitfieldData(variableName: "overflowFlag", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ICF0, .ICF1, .ICF3, .ICF4, .ICF5:
        return SupplementalBitfieldData(variableName: "inputCaptureFlag", valueType: "Bool", defaultValue: "", documentation: inputCaptureFlagDocumentation, access: .readWrite)
        
        // Control Register A
    case .COM0A, .COM1A, .COM2A, .COM3A, .COM4A, .COM5A:
        return SupplementalBitfieldData(variableName: "compareOutputModeA", valueType: "Timer.CompareOutputMode", defaultValue: ".normal", documentation: outputCompareModeADocumentation, access: .readWrite)
    case .COM0B, .COM1B, .COM2B, .COM3B, .COM4B, .COM5B:
        return SupplementalBitfieldData(variableName: "compareOutputModeB", valueType: "Timer.CompareOutputMode", defaultValue: ".normal", documentation: outputCompareModeBDocumentation, access: .readWrite)
    case .WGM0, .WGM1, .WGM2, .WGM3, .WGM4, .WGM5, .WGM00, .WGM02, .WGM01, .WGM20, .WGM21, .WGM22:
        return SupplementalBitfieldData(variableName: "waveformGenerationMode", valueType: "WaveformGenerationMode", defaultValue: ".normal", documentation: waveformGenerationModeDocumentation, access: .readWrite)
        
        // Control Register B
    case .FOC0A, .FOC2A: // NOTE: On the Atmega328P Datasheet FOC1A, FOC2A and FOC1B, FOC2B are Write only while the same bit on other Timers registers are Read/Write. Is this an error in the Datasheet?
        return SupplementalBitfieldData(variableName: "forceOutputCompareA", valueType: "Bool", defaultValue: "", documentation: forceOutputCompareADocumentation, access: .write)
    case .FOC1A, .FOC3A, .FOC4A, .FOC5A:
        return SupplementalBitfieldData(variableName: "forceOutputCompareA", valueType: "Bool", defaultValue: "", documentation: forceOutputCompareADocumentation, access: .readWrite)
    case .FOC0B, .FOC2B: // NOTE: On the Atmega328P Datasheet FOC1A, FOC2A and FOC1B, FOC2B are Write only while the same bit on other Timers registers are Read/Write. Is this an error in the Datasheet?
        return SupplementalBitfieldData(variableName: "forceOutputCompareB", valueType: "Bool", defaultValue: "", documentation: forceOutputCompareBDocumentation, access: .write)
    case .FOC1B, .FOC3B, .FOC4B, .FOC5B:
        return SupplementalBitfieldData(variableName: "forceOutputCompareB", valueType: "Bool", defaultValue: "", documentation: forceOutputCompareBDocumentation, access: .readWrite)
    case .CS0, .CS1, .CS2, .CS3, .CS4, .CS5:
        return SupplementalBitfieldData(variableName: "prescaler", valueType: "Prescaling", defaultValue: ".stopped", documentation: prescalerDocumentation, access: .readWrite)
    case .ICNC0, .ICNC1, .ICNC3, .ICNC4, .ICNC5:
        return SupplementalBitfieldData(variableName: "inputCaptureNoiseCanceler", valueType: "Bool", defaultValue: "", documentation: inputCaptureNoiseCancelerDocumentation, access: .readWrite)
    case .ICES0, .ICES1, .ICES3, .ICES4, .ICES5:
        return SupplementalBitfieldData(variableName: "inputCaptureEdgeSelect", valueType: "Bool", defaultValue: "", documentation: inputCaptureEdgeSelectDocumentation, access: .readWrite)
    
        // Asynchronous Status Register
    case .EXCLK:
        return SupplementalBitfieldData(variableName: "enableExternalClockInput", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .AS2:
        return SupplementalBitfieldData(variableName: "asynchronousTimerCounter", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .TCN2UB:
        return SupplementalBitfieldData(variableName: "updateBusy", valueType: "Bool", defaultValue: "", documentation: "", access: .read)
    case .OCR2AUB:
        return SupplementalBitfieldData(variableName: "outputCompareRegisterAUpdateBusy", valueType: "Bool", defaultValue: "", documentation: "", access: .read)
    case .OCR2BUB:
        return SupplementalBitfieldData(variableName: "outputCompareRegisterBUpdateBusy", valueType: "Bool", defaultValue: "", documentation: "", access: .read)
    case .TCR2AUB:
        return SupplementalBitfieldData(variableName: "controlRegisterAUpdateBusy", valueType: "Bool", defaultValue: "", documentation: "", access: .read)
    case .TCR2BUB:
        return SupplementalBitfieldData(variableName: "controlRegisterBUpdateBusy", valueType: "Bool", defaultValue: "", documentation: "", access: .read)
        
    
        // General Timer/Counter Control Register
    case .TSM:
        return SupplementalBitfieldData(variableName: "timerSynchronizationMode", valueType: "Timer.TimerSynchronizationMode", defaultValue: ".disabled", documentation: timerSynchronizationModeDocumentation, access: .readWrite)
    case .PSRASY:
        return SupplementalBitfieldData(variableName: "prescalerReset", valueType: "Bool", defaultValue: "", documentation: prescalerResetDocumentation, access: .readWrite)
    case .PSRSYNC:
        return SupplementalBitfieldData(variableName: "prescalerResetSync", valueType: "Bool", defaultValue: "", documentation: prescalerResetSyncDocumentation, access: .readWrite)
        
    default :
        return SupplementalBitfieldData(variableName: "", valueType: "", defaultValue: "", documentation: "", access: .readWrite)
    }
}
