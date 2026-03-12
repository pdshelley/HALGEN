//
//  AnalogToDigitalConverter.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 23/02/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

struct ADCGenerator: PeripheralGenerator {
    let name = "AnalogToDigitalConverter"
    let subdirectory: String = "module"
    
    func supports(device: AVRToolsDeviceFile) -> Bool {
        device.modules.module.contains { $0.name == .ADC }
    }
    
    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        var code = buildFileHeader(for: name, generateTypealias: false)
        code.append(adcDocs.adcEnums)
        documentation.load(chipName: device.devices.device.name)
        let adcRegisterGroup = device.modules.module.first(where: { $0.name == .ADC })!.registerGroup.first!
        var memberBlockList = MemberBlockItemListSyntax()
        
//        for decl in adcDocs.adcTypealiases {
//            memberBlockList.append(MemberBlockItemSyntax(decl: decl))
//        }
        memberBlockList.append(
            MemberBlockItemSyntax(decl: DeclSyntax("\(raw: adcDocs.adcTypealiasesString)"))
        )
        
        for register in adcRegisterGroup.register {
            memberBlockList.append(
                contentsOf:
                    generateRegister(
                        register: register,
                        registerData: documentation.supplementalData(for:),
                        bitfieldData: documentation.supplementalData(for:)
                    )
            )
            for bitfield in register.bitfield {
                if let bitfieldAccessor = generateBitfieldAccessor(
                    bitfield: bitfield,
                    parentVariable: register,
                    registerGroup: adcRegisterGroup,
                    registerData: documentation.supplementalData(for:),
                    bitfieldData: documentation.supplementalData(for:)
                ) {
                    memberBlockList.append(bitfieldAccessor)
                }
            }
        }
        
        let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())
        
        code.append(SourceFileSyntax {
            StructDeclSyntax(
                modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
                name: "\(raw: name)",
                memberBlock: memberBlock
            )
        }.formatted().description)
        
        return [GeneratedCodeFile(fileName: "\(name).swift", content: code, subdirectory: subdirectory)]
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
        
        public typealias adc = AnalogToDigitalConverter
        
        
        """
    
    // Thank youu chatgpt🙏
//    static let adcTypealiases: [DeclSyntax] = [
//        DeclSyntax(
//            TypeAliasDeclSyntax(
//                modifiers: [.init(name: .keyword(.public))],
//                typealiasKeyword: .keyword(.typealias),
//                identifier: .identifier("VoltageReferenceSelection"),
//                genericParameterClause: nil,
//                initializer: TypeInitializerClauseSyntax(
//                    equal: .equalToken(),
//                    value: TypeSyntax(IdentifierTypeSyntax(name: .identifier("VoltageReference")))
//                )
//            )
//        ),
//        DeclSyntax(
//            TypeAliasDeclSyntax(
//                modifiers: [.init(name: .keyword(.public))],
//                typealiasKeyword: .keyword(.typealias),
//                identifier: .identifier("AnalogChannelSelection"),
//                genericParameterClause: nil,
//                initializer: TypeInitializerClauseSyntax(
//                    equal: .equalToken(),
//                    value: TypeSyntax(IdentifierTypeSyntax(name: .identifier("AnalogChannel")))
//                )
//            )
//        ),
//        DeclSyntax(
//            TypeAliasDeclSyntax(
//                modifiers: [.init(name: .keyword(.public))],
//                typealiasKeyword: .keyword(.typealias),
//                identifier: .identifier("AnalogPrescalerSelection"),
//                genericParameterClause: nil,
//                initializer: TypeInitializerClauseSyntax(
//                    equal: .equalToken(),
//                    value: TypeSyntax(IdentifierTypeSyntax(name: .identifier("AnalogPrescaler")))
//                )
//            )
//        )
//    ]
    
    static let adcTypealiasesString = """
            public typealias VoltageReferenceSelection = VoltageReference
            public typealias AnalogChannelSelection = AnalogChannel
            public typealias AnalogPrescalerSelection = AnalogPrescaler
        """
}
