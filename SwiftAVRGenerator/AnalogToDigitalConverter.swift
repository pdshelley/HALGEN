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
    var code = buildFileHeader(for: adcName)
    code.append(adcDocs.adcEnums)
    var memberBlockList = MemberBlockItemListSyntax()
    
    for decl in adcDocs.adcTypealiases {
        memberBlockList.append(MemberBlockItemSyntax(decl: decl))
    }
    
    // Generation of registers
    for register in registerGroup.register {
        memberBlockList.append(generateAnalogToDigitalConverterRegister(register: register))
        if register.size == .two {
            memberBlockList.append(contentsOf: generateRegisterWithSizeTwo(register: register))
        }
        for bitfield in register.bitfield {
            memberBlockList.append(generateBitfieldAccessor(for: bitfield, in: register, registerGroup, chipName))
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

fileprivate func generateBitfieldAccessor(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
                              in register: AVRModules.Module.RegisterGroup.Register,
                              _ registerGroup: AVRModules.Module.RegisterGroup,
                              _ chipName: String) -> MemberBlockItemSyntax {
//    if splitBitfieldAccessors.contains(where: { $0.self.key == bitfield.name}) {
//        let bitfieldBName = splitBitfieldAccessors[bitfield.name]
//        let registerB = registerGroup.register.first(where: {$0.bitfield.contains(where: { $0.name == bitfieldBName! })})
//        let bitfieldB = registerB?.bitfield.first(where: {$0.name == bitfieldBName})
//        return generateSplitBitfieldAccessorUart(bitfieldA: bitfield, bitfieldB: bitfieldB!, parentVariableA: register, parentVariableB: registerB!, chipName: chipName)
//    }
    
    let supData = supplementalData(for: bitfield)
    let variableName = (supData.variableName != "") ? supData.variableName : getVariableName(caption: bitfield.caption?.rawValue ?? "")
    let supDataParent = supplementalData(for: register)
    let bitmask = bitfield.mask.value.lowByte.binaryString
    let bitshift = UInt8(bitfield.mask.value.trailingZeroBitCount)
    let caption: String = bitfield.caption.map(\.rawValue.capitalized) ?? "Unknown"
    //let enumBitmask = (bitfield.mask.value.lowByte >> bitshift).binaryString
    
    if supData.valueType == "Bool" {
        var sourceForBoolGet = """
          get {
              return !((\(supDataParent.variableName) & \(bitmask)) == 0)
          }
          """
        
        var sourceForBoolSet = """
          set {
              \(supDataParent.variableName) |= UInt8(newValue.hashValue) & \(bitmask)
          }
          """
        if supData.access == Access.write {
            sourceForBoolGet = ""
        }
        if supData.access == Access.read {
            sourceForBoolSet = ""
        }
        
        let sourceForBool = DeclSyntax(
          """
              /// \(raw: bitfield.name) – \(raw: caption) \(raw: supData.documentation)
              @inlinable
              @inline(never)
              public static var \(raw: variableName): \(raw: supData.valueType) {\(raw: sourceForBoolGet)\(raw: sourceForBoolSet)
              }
          """
        ).with(\.trailingTrivia, .newlines(2))
        return MemberBlockItemSyntax(decl: sourceForBool)
    }
    
    if bitshift == 0 {
        let source = DeclSyntax(
            """
                /// \(raw: bitfield.name) – \(raw: caption) \(raw: supData.documentation)
                @inlinable
                @inline(__always)
                public static var \(raw: variableName): \(raw: supData.valueType) {
                    get {
                        let mode = \(raw: supDataParent.variableName) & \(raw: bitmask)
                        return \(raw: supData.valueType).init(rawValue: mode) ?? \(raw: supData.defaultValue)
                    }
                    set {
                        \(raw: supDataParent.variableName) = (\(raw: supDataParent.variableName) & ~\(raw: bitmask)) | (newValue.rawValue & \(raw: bitmask))
                    }
                }
            """
        ).with(\.trailingTrivia, .newlines(2))
        return MemberBlockItemSyntax(decl: source)
    }
    
    let source = DeclSyntax(
        """
            /// \(raw: bitfield.name) – \(raw: caption) \(raw: supData.documentation)
            @inlinable
            @inline(__always)
            public static var \(raw: variableName): \(raw: supData.valueType) {
                get {
                    let mode = (\(raw: supDataParent.variableName) & \(raw: bitmask)) >> \(raw: bitshift)
                    return \(raw: supData.valueType).init(rawValue: mode) ?? \(raw: supData.defaultValue)
                }
                set {
                    \(raw: supDataParent.variableName) = (\(raw: supDataParent.variableName) & ~\(raw: bitmask)) | ((newValue.rawValue << \(raw: bitshift)) & \(raw: bitmask))
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
        return SupplementalBitfieldData(variableName: "reference", valueType: "VoltageReferenceSelection", defaultValue: ".internalTurnedOff", documentation: adcDocs.referenceDocumentation, access: .readWrite)
    case .ADLAR:
        return SupplementalBitfieldData(variableName: "leftAdjust", valueType: "Bool", defaultValue: "", documentation: adcDocs.leftAdjustDocumentation, access: .readWrite)
    case .MUX, .MUX5: // Is MUX5 a part of the adc?
        return SupplementalBitfieldData(variableName: "channel", valueType: "AnalogChannelSelection", defaultValue: ".adc0", documentation: adcDocs.channelDocumentation, access: .readWrite)
    case .ADEN:
        return SupplementalBitfieldData(variableName: "enabled", valueType: "Bool", defaultValue: "", documentation: adcDocs.enabledDocumentation, access: .readWrite)
    case .ADSC:
        return SupplementalBitfieldData(variableName: "converting", valueType: "Bool", defaultValue: "", documentation: adcDocs.convertingDocumentation, access: .readWrite)
    case .ADATE:
        return SupplementalBitfieldData(variableName: "autoTriggerEnabled", valueType: "Bool", defaultValue: "", documentation: adcDocs.autoTriggerEnabledDocumentation, access: .readWrite)
    case .ADIF:
        return SupplementalBitfieldData(variableName: "interruptFlag", valueType: "Bool", defaultValue: "", documentation: adcDocs.interruptFlagDocumentation, access: .readWrite)
    case .ADIE:
        return SupplementalBitfieldData(variableName: "interruptEnabled", valueType: "Bool", defaultValue: "", documentation: adcDocs.interruptEnabledDocumentation, access: .readWrite)
    case .ADPS:
        return SupplementalBitfieldData(variableName: "prescaler", valueType: "AnalogPrescalerSelection", defaultValue: "", documentation: adcDocs.prescalerDocumentation, access: .readWrite)
    case .ACME:
        return SupplementalBitfieldData(variableName: "multiplexerEnable", valueType: "Bool", defaultValue: "", documentation: adcDocs.multiplexerEnabledDocumentation, access: .readWrite)
    case .ADTS, .ADTS0, .ADTS1, .ADTS2, .ADTS3: // Are .ADTSn a part of the adc?
        return SupplementalBitfieldData(variableName: "autoTriggerSource", valueType: "AutoTriggerSource", defaultValue: ".freeRunning", documentation: adcDocs.autoTriggerSourceDocumentation, access: .readWrite)
    case .ADC5D:
        return SupplementalBitfieldData(variableName: "digitalInput5Disabled", valueType: "Bool", defaultValue: "", documentation: adcDocs.digitalInput5DisabledDocumentation, access: .readWrite)
    case .ADC4D:
        return SupplementalBitfieldData(variableName: "digitalInput4Disabled", valueType: "Bool", defaultValue: "", documentation: adcDocs.digitalInput4DisabledDocumentation, access: .readWrite)
    case .ADC3D:
        return SupplementalBitfieldData(variableName: "digitalInput3Disabled", valueType: "Bool", defaultValue: "", documentation: adcDocs.digitalInput3DisabledDocumentation, access: .readWrite)
    case .ADC2D:
        return SupplementalBitfieldData(variableName: "digitalInput2Disabled", valueType: "Bool", defaultValue: "", documentation: adcDocs.digitalInput2DisabledDocumentation, access: .readWrite)
    case .ADC1D:
        return SupplementalBitfieldData(variableName: "digitalInput1Disabled", valueType: "Bool", defaultValue: "", documentation: adcDocs.digitalInput1DisabledDocumentation, access: .readWrite)
    case .ADC0D:
        return SupplementalBitfieldData(variableName: "digitalInput0Disabled", valueType: "Bool", defaultValue: "", documentation: adcDocs.digitalInput0DisabledDocumentation, access: .readWrite)
    default :
        return SupplementalBitfieldData(variableName: "", valueType: "", defaultValue: "", documentation: "", access: .readWrite)
    }
}

private enum adcDocs {
    static let referenceDocumentation = """
        \n    /// 
            /// These bits select the voltage reference for the ADC, as shown in the table below.
            /// If these bits are changed during a conversion, the change will not go in effect until this conversion is completed (ADIF in ADCSRA is set).
            /// The internal voltage reference options may not be used if an external reference voltage is being applied to the AREF pin.
            ///
            /// ```
            /// | REFS1 | REFS0 | Voltage Reference Selection                                         |
            /// |-------|-------|---------------------------------------------------------------------|
            /// |   0   |   0   | AREF, Internal Vref turned off                                      |
            /// |   0   |   1   | AVcc with external capacitor at AREF pin                            |
            /// |   1   |   0   | Reserved                                                            |
            /// |   1   |   1   | Internal 1.1V Voltage Reference with external capacitor at AREF pin |
            /// ```
        """
    
    static let leftAdjustDocumentation = """
        \n    ///
            /// The ADLAR bit affects the presentation of the ADC conversion result in the ADC Data Register.
            /// Write one to ADLAR to left adjust the result.
            /// Otherwise, the result is right adjusted.
            /// Changing the ADLAR bit will affect the ADC Data Register immediately, regardless of any ongoing conversions.
        """
    
    static let channelDocumentation = """
        \n    ///
            /// The value of these bits select which analog inputs are connected to the ADC. See the table below for details. If these bits are changed during a conversion, the change will not go in effect until this conversion is complete (ADIF in ADCSRA is set).
            ///
            /// ```
            /// | MUX3  | MUX2  | MUX1  | MUX0  | Single Ended Input |
            /// |-------|-------|-------|-------|--------------------|
            /// |   0   |   0   |   0   |   0   | ADC0               |
            /// |   0   |   0   |   0   |   1   | ADC1               |
            /// |   0   |   0   |   1   |   0   | ADC2               |
            /// |   0   |   0   |   1   |   1   | ADC3               |
            /// |   0   |   1   |   0   |   0   | ADC4               |
            /// |   0   |   1   |   0   |   1   | ADC5               |
            /// |   0   |   1   |   1   |   0   | ADC6               |
            /// |   0   |   1   |   1   |   1   | ADC7               |
            /// |   1   |   0   |   0   |   0   | ADC8               |
            /// |   1   |   0   |   0   |   1   | Reserved           |
            /// |   1   |   0   |   1   |   0   | Reserved           |
            /// |   1   |   0   |   1   |   1   | Reserved           |
            /// |   1   |   1   |   0   |   0   | Reserved           |
            /// |   1   |   1   |   0   |   1   | Reserved           |
            /// |   1   |   1   |   1   |   0   | 1.1V (Vbg)         |
            /// |   1   |   1   |   1   |   1   | 0V (GND)           |
            /// 
            /// ```
        """
    
    static let enabledDocumentation = """
        \n    ///
            /// Writing this bit to one enables the ADC.
            /// By writing it to zero, the ADC is turned off.
            /// Turning off the ADC off while a conversion is in progress, will terminate this conversion.
        """
    
    static let convertingDocumentation = """
        \n    ///
            /// In Single Conversion mode, write this bit to one to start each conversion.
            /// In Free Running mode, write this bit to one to start the first conversion.
            /// The first conversion after ADSC has been written after the ADC has been enabled, or if ADSC is written at the same time as the ADC is enabled, will take 25 ADC clock cycles instead of the normal 13.
            /// This first conversion performs initialization of the ADC.
            ///
            /// ADSC will read as one as long as a conversion is in progress. When the conversion is complete, it returns to zero.
            /// Writing zero to this bit has no effect.
        """
    
    static let autoTriggerEnabledDocumentation = """
        \n    ///
            /// When this bit is written to one, Auto Triggering of the ADC is enabled.
            /// The ADC will start a conversion on a positive edge of the selected trigger signal. The trigger source is selected by setting the ADC Trigger Select bits, ADTS in ADCSRB.
        """
    
    static let interruptFlagDocumentation = """
        \n    ///
            /// This bit is set when an ADC conversion completes and the Data Registers are updated.
            /// The ADC Conversion Complete Interrupt is executed if the ADIE bit and the I-bit in SREG are set.
            /// ADIF is cleared by hardware when executing the corresponding interrupt handling vector.
            /// Alternatively, ADIF is cleared by writing a logical one to the flag.
            /// Beware that if doing a Read-Modify-Write on ADCSRA, a pending interrupt can be disabled.
            /// This also applies if the SBI and CBI instructions are used.
        """
    
    static let interruptEnabledDocumentation = """
        \n    ///
            /// When this bit is written to one and the I-bit in SREG is set, the ADC Conversion Complete Interrupt is activated.
        """
    
    static let prescalerDocumentation = """
        \n    ///
            /// These bits determine the division factor between the system clock frequency and the input clock to the ADC.
            ///
            /// ```
            /// | ADPS2 | ADPS1 | ADPS0 | Division Factor |
            /// |-------|-------|-------|-----------------|
            /// |   0   |   0   |   0   | 2               |
            /// |   0   |   0   |   1   | 2               |
            /// |   0   |   1   |   0   | 4               |
            /// |   0   |   1   |   1   | 8               |
            /// |   1   |   0   |   0   | 16              |
            /// |   1   |   0   |   1   | 32              |
            /// |   1   |   1   |   0   | 64              |
            /// |   1   |   1   |   1   | 128             |
            /// ```
        """
    
    static let multiplexerEnabledDocumentation = """
        \n    ///
            /// When this bit is written logic one and the ADC is switched off (ADEN in ADCSRA is zero), the ADC multiplexer selects the negative input to the Analog Comparator.
            /// When this bit is written logic zero, AIN1 is applied to the negative input of the Analog Comparator.
        """
    
    static let autoTriggerSourceDocumentation = """
        \n    ///
            /// If ADATE in ADCSRA is written to one, the value of these bits selects which source will trigger an ADC conversion.
            /// If ADATE is cleared, the ADTS[2:0] settings will have no effect.
            /// A conversion will be triggered by the rising edge of the selected Interrupt Flag.
            /// Note that switching from a trigger source that is cleared to a trigger source that is set, will generate a positive edge on the trigger signal.
            /// If ADEN in ADCSRA is set, this will start a conversion.
            /// Switching to Free Running mode (ADTS[2:0] = 0) will not cause a trigger event, even if the ADC Interrupt Flag is set.
            ///
            /// ```
            /// | ADTS2 | ADTS1 | ADTS0 | Trigger Source                 |
            /// |-------|-------|-------|--------------------------------|
            /// |   0   |   0   |   0   | Free Running mode              |
            /// |   0   |   0   |   1   | Analog Comparator              |
            /// |   0   |   1   |   0   | External Interrupt Request 0   |
            /// |   0   |   1   |   1   | Timer/Counter0 Compare Match A |
            /// |   1   |   0   |   0   | Timer/Counter0 Overflow        |
            /// |   1   |   0   |   1   | Timer/Counter1 Compare Match B |
            /// |   1   |   1   |   0   | Timer/Counter1 Overflow        |
            /// |   1   |   1   |   1   | Timer/Counter1 Capture Event   |
            /// ```
        """
    
    static let digitalInput5DisabledDocumentation = """
        \n    ///
            /// When this bit is written to a logic one, the digital input buffer on the corresponding ADC pin is disabled.
            /// The corresponding PIN Register bit will always read as zero when this bit is set.
            /// When an analog signal is applied to the ADC5 pin and the digital input from this pin is not needed, this bit should be written to logic one to reduce power consumption in the digital input buffer.
            ///
        """
    
    static let digitalInput4DisabledDocumentation = """
        \n    ///
            /// When this bit is written to a logic one, the digital input buffer on the corresponding ADC pin is disabled.
            /// The corresponding PIN Register bit will always read as zero when this bit is set.
            /// When an analog signal is applied to the ADC4 pin and the digital input from this pin is not needed, this bit should be written to logic one to reduce power consumption in the digital input buffer.
            ///
        """
    
    static let digitalInput3DisabledDocumentation = """
        \n    ///
            /// When this bit is written to a logic one, the digital input buffer on the corresponding ADC pin is disabled.
            /// The corresponding PIN Register bit will always read as zero when this bit is set.
            /// When an analog signal is applied to the ADC3 pin and the digital input from this pin is not needed, this bit should be written to logic one to reduce power consumption in the digital input buffer.
            ///
        """
    
    static let digitalInput2DisabledDocumentation = """
        \n    ///
            /// When this bit is written to a logic one, the digital input buffer on the corresponding ADC pin is disabled.
            /// The corresponding PIN Register bit will always read as zero when this bit is set.
            /// When an analog signal is applied to the ADC2 pin and the digital input from this pin is not needed, this bit should be written to logic one to reduce power consumption in the digital input buffer.
            ///
        """
    
    static let digitalInput1DisabledDocumentation = """
        \n    ///
            /// When this bit is written to a logic one, the digital input buffer on the corresponding ADC pin is disabled.
            /// The corresponding PIN Register bit will always read as zero when this bit is set.
            /// When an analog signal is applied to the ADC1 pin and the digital input from this pin is not needed, this bit should be written to logic one to reduce power consumption in the digital input buffer.
            ///
        """
    
    static let digitalInput0DisabledDocumentation = """
        \n    ///
            /// When this bit is written to a logic one, the digital input buffer on the corresponding ADC pin is disabled.
            /// The corresponding PIN Register bit will always read as zero when this bit is set.
            /// When an analog signal is applied to the ADC0 pin and the digital input from this pin is not needed, this bit should be written to logic one to reduce power consumption in the digital input buffer.
            ///
        """
    
    static let adcEnums = """
        public enum VoltageReference: UInt8 {
            /// AREF, Internal Vref turned off
            case internalTurnedOff = 0
            /// AVcc with external capacitor at AREF pin
            case externalCapacitor = 1
            // 2 is reserved
            /// Internal 1.1V Voltage Reference with external capacitor at AREF pin
            case interval1v1WithExternalReference = 3
        }

        public enum AnalogChannel: UInt8 {
            case adc0 = 0
            case adc1 = 1
            case adc2 = 2
            case adc3 = 3
            case adc4 = 4
            case adc5 = 5
            case adc6 = 6
            case adc7 = 7
            case adc8 = 8
            // 9 through 13 are reserved
            case vbg = 14
            case gnd = 15
        }

        public enum AnalogPrescaler: UInt8 {
            case divide2 = 0
            case divide2x = 1
            case divide4 = 2
            case divide8 = 3
            case divide16 = 4
            case divide32 = 5
            case divide64 = 6
            case divide128 = 7
        }

        public enum AutoTriggerSource: UInt8 {
            /// Free Running mode
            case freeRunning = 0
            /// Analog Comparator
            case analogComparator = 1
            /// External Interrupt Request 0
            case externalInterrupt0 = 2
            /// Timer/Counter0 Compare Match A
            case timer0CompareMatchA = 3
            /// Timer/Counter0 Overflow
            case timer0Overflow = 4
            /// Timer/Counter1 Compare Match B
            case timer1CompareMatchB = 5
            /// Timer/Counter1 Overflow
            case timer1Overflow = 6
            /// Timer/Counter1 Capture
            case timer1Capture = 7
        }
        
        
        """
    
    // Thank youu chatgpt🙏
    static let adcTypealiases: [DeclSyntax] = [
        DeclSyntax(
            TypeAliasDeclSyntax(
                modifiers: [.init(name: .keyword(.public))],
                typealiasKeyword: .keyword(.typealias),
                identifier: .identifier("VoltageReferenceSelection"),
                genericParameterClause: nil,
                initializer: TypeInitializerClauseSyntax(
                    equal: .equalToken(),
                    value: TypeSyntax(IdentifierTypeSyntax(name: .identifier("VoltageReference")))
                )
            )
        ),
        DeclSyntax(
            TypeAliasDeclSyntax(
                modifiers: [.init(name: .keyword(.public))],
                typealiasKeyword: .keyword(.typealias),
                identifier: .identifier("AnalogChannelSelection"),
                genericParameterClause: nil,
                initializer: TypeInitializerClauseSyntax(
                    equal: .equalToken(),
                    value: TypeSyntax(IdentifierTypeSyntax(name: .identifier("AnalogChannel")))
                )
            )
        ),
        DeclSyntax(
            TypeAliasDeclSyntax(
                modifiers: [.init(name: .keyword(.public))],
                typealiasKeyword: .keyword(.typealias),
                identifier: .identifier("AnalogPrescalerSelection"),
                genericParameterClause: nil,
                initializer: TypeInitializerClauseSyntax(
                    equal: .equalToken(),
                    value: TypeSyntax(IdentifierTypeSyntax(name: .identifier("AnalogPrescaler")))
                )
            )
        )
    ]
}
