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
    let adcName = "AnalogToDigitalConverter"
    let fileName = "\(adcName).swift"
    var code = buildFileHeader(for: fileName)
    var memberBlockList = MemberBlockItemListSyntax()
    
    // Generation of registers
    for register in registerGroup.register {
        memberBlockList.append(generateAnalogToDigitalConverterRegister(register: register))
        if register.size == .two {
            memberBlockList.append(contentsOf: generateRegisterWithSizeTwo(register: register))
        }
    }
    
    let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())
        
    // Information needed to setup the Struct.
//    let InheritedType = InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "UARTPort"))
//    let inheritedTypeList = InheritedTypeListSyntax(arrayLiteral: InheritedType)
//    let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
    
    code.append(SourceFileSyntax {
        StructDeclSyntax(
            modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
            name: "\(raw: adcName)",
//            inheritanceClause: inheritanceClause,
            memberBlock: memberBlock
        )
    }.formatted().description)
    
    return GeneratedCodeFile(fileName: fileName, content: code)
}

func generateAnalogToDigitalConverterRegister(register: AVRModules.Module.RegisterGroup.Register) -> MemberBlockItemSyntax {
    return generateRegister(register: register, variableName: supplementalData(for: register).variableName)
}

func generateRegisterWithSizeTwo(register: AVRModules.Module.RegisterGroup.Register) -> MemberBlockItemListSyntax {
    var memberBlockList = MemberBlockItemListSyntax()
    
    // get register and change size to 1 so uint8 registers are generated instead of 16 bit
    var customRegisterL: AVRModules.Module.RegisterGroup.Register = register
    customRegisterL.size = .one
    memberBlockList.append(generateRegister(register: customRegisterL, variableName: "\(supplementalData(for: register).variableName)L"))
    
    var customRegisterH: AVRModules.Module.RegisterGroup.Register = register
    customRegisterH.size = .one
    // I have no idea if this is ok, I'll just assume it is since it works
    customRegisterH.offset = .init(rawValue: (register.offset.rawValue.hexValue() + 1).toHex()) ?? .zeroX
    memberBlockList.append(generateRegister(register: customRegisterH, variableName: "\(supplementalData(for: register).variableName)H"))
    
    return memberBlockList
}

func generateRegister(register: AVRModules.Module.RegisterGroup.Register, variableName: String) -> MemberBlockItemSyntax {
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
    case .ADC:
        return SupplementalRegisterData(variableName: "dataRegister", valueType: "", defaultValue: "", documentation: "", access: Access.read.rawValue)
    case .ADCSRA:
        return SupplementalRegisterData(variableName: "controlRegisterA", valueType: "", defaultValue: "", documentation: "", access: Access.readWrite.rawValue)
    case .ADCSRB:
        return SupplementalRegisterData(variableName: "controlRegisterB", valueType: "", defaultValue: "", documentation: "", access: Access.readWrite.rawValue)
    case .ADCSRC:
        return SupplementalRegisterData(variableName: "controlRegisterC", valueType: "", defaultValue: "", documentation: "", access: Access.readWrite.rawValue)
    case .DIDR0, .DIDR1, .DIDR2:
        return SupplementalRegisterData(variableName: "digitalInputDisableRegister", valueType: "", defaultValue: "", documentation: "", access: Access.readWrite.rawValue)
    default :
        return SupplementalRegisterData(variableName: getVariableName(caption: register.caption?.rawValue ?? ""), valueType: "", defaultValue: "", documentation: "", access: "")
    }
}

fileprivate func supplementalData(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData {
    switch bitfield.name {
    case .REFS, .REFS0: // Is REFS0 a part of the adc?
        return SupplementalBitfieldData(variableName: "reference", valueType: "VoltageReferenceSelection", defaultValue: ".internalTurnedOff", documentation: "", access: .readWrite)
    case .ADLAR:
        return SupplementalBitfieldData(variableName: "leftAdjust", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .MUX, .MUX5: // Is MUX5 a part of the adc?
        return SupplementalBitfieldData(variableName: "channel", valueType: "AnalogChannelSelection", defaultValue: ".adc0", documentation: "", access: .readWrite)
    case .ADEN:
        return SupplementalBitfieldData(variableName: "enabled", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADSC:
        return SupplementalBitfieldData(variableName: "converting", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADATE:
        return SupplementalBitfieldData(variableName: "autoTriggerEnabled", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADIF:
        return SupplementalBitfieldData(variableName: "interruptFlag", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADIE:
        return SupplementalBitfieldData(variableName: "interruptEnabled", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADPS:
        return SupplementalBitfieldData(variableName: "prescaler", valueType: "AnalogPrescalerSelection", defaultValue: "", documentation: "", access: .readWrite)
    case .ACME:
        return SupplementalBitfieldData(variableName: "multiplexerEnable", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADTS, .ADTS0, .ADTS1, .ADTS2, .ADTS3: // Are .ADTSn a part of the adc?
        return SupplementalBitfieldData(variableName: "autoTriggerSource", valueType: "AutoTriggerSource", defaultValue: ".freeRunning", documentation: "", access: .readWrite)
    case .ADC5D:
        return SupplementalBitfieldData(variableName: "digitalInput5Disabled", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADC4D:
        return SupplementalBitfieldData(variableName: "digitalInput4Disabled", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADC3D:
        return SupplementalBitfieldData(variableName: "digitalInput3Disabled", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADC2D:
        return SupplementalBitfieldData(variableName: "digitalInput2Disabled", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADC1D:
        return SupplementalBitfieldData(variableName: "digitalInput1Disabled", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    case .ADC0D:
        return SupplementalBitfieldData(variableName: "digitalInput0Disabled", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite)
    default :
        return SupplementalBitfieldData(variableName: "", valueType: "", defaultValue: "", documentation: "", access: .readWrite)
    }
}
