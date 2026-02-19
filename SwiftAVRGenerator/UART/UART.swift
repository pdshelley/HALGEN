//
//  UART.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 12/02/2026.
//
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

func buildUARTs(file: AVRToolsDeviceFile) -> [GeneratedCodeFile] {
    var uartFiles: [GeneratedCodeFile] = []
    
    let fileName = "UART.swift"
    let code: String = buildFileHeader(for: fileName) + uartBoilerPlate
    uartFiles.append(GeneratedCodeFile(fileName: fileName, content: code))
    
    let uartNamesDict: [AVRModules.Module.RegisterGroup.Name: String] = [
        .USART0: "UART0",
        .USART1: "UART1",
        .USART2: "UART2",
        .USART3: "UART3"
    ]
    
    let bitfieldAccessorsToGenerate: [AVRModules.Module.RegisterGroup.Register.Bitfield.Name] = [
        .UPM0, .UPM1, .UPM2, .UPM3,
        .USBS0, .USBS1, .USBS2, .USBS3,
        .UCSZ02,
        .UCPOL0, .UCPOL1, .UCPOL2, .UCPOL3,
        .U2X0, .U2X1, .U2X2, .U2X3,
        .RXEN0, .RXEN1, .RXEN2, .RXEN3,
        .TXEN0, .TXEN1, .TXEN2, .TXEN3,
    ]
    
    if let module: AVRModules.Module = file.modules.module.first(where: { $0.name == .usart }) {
        let uartNames = module.registerGroup.compactMap { uartNamesDict[$0.name] }
        for uartName in uartNames {
            uartFiles.append(buildUART(module: module, uartName: uartName, chipName: file.devices.device.name, bitfieldsToGenerate: bitfieldAccessorsToGenerate))
        }
    }
    return uartFiles
}

func buildUART(module: AVRModules.Module, uartName: String, chipName: String, bitfieldsToGenerate: [AVRModules.Module.RegisterGroup.Register.Bitfield.Name]) -> GeneratedCodeFile {
    let fileName = "\(uartName).swift"
    var code = buildFileHeader(for: uartName)
    var memberBlockList = MemberBlockItemListSyntax()
    
    if let lastChar = uartName.last, let registerGroupIndex = lastChar.wholeNumberValue {
        let registerGroup = module.registerGroup[registerGroupIndex]
        for register in registerGroup.register {
            switch register.name {
            case .UBRR0, .UBRR1, .UBRR2, .UBRR3:
                memberBlockList.append(contentsOf: generateUartBaudRegister(register))
                continue
            default:
                break
            }
            memberBlockList.append(generateUartRegister(register))
        }
        for bitfield in bitfieldsToGenerate {
            if let register = registerGroup.register.first(where: {$0.bitfield.contains(where: { $0.name == bitfield })}), let bitfield = register.bitfield.first(where: { $0.name == bitfield }) {
                memberBlockList.append(generateBitfieldAccessor(for: bitfield, in: register, registerGroup, chipName))
            }
        }
    }
    
    let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())
    
    // TODO: Check what this does and clean this up, I simply copy pasted from timers to get something working quickly.
    
    // Information needed to setup the Struct.
//    let InheritedType = InheritedTypeSyntax(type: TypeSyntax(stringLiteral: protocolDeclarations))
//    let inheritedTypeList = InheritedTypeListSyntax(arrayLiteral: InheritedType)
//    let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
    
    code.append(SourceFileSyntax {
        StructDeclSyntax(
            modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
            name: "\(raw: uartName)",
            //inheritanceClause: inheritanceClause,
            memberBlock: memberBlock
        )
    }.formatted().description)
    
    return GeneratedCodeFile(fileName: fileName, content: code)
}

func generateUartBaudRegister(_ register: AVRModules.Module.RegisterGroup.Register) -> MemberBlockItemListSyntax {
    var memberBlockList = MemberBlockItemListSyntax()
    if register.size == AVRModules.Module.RegisterGroup.Register.Size.one {
        memberBlockList.append(generateRegister(register, "baudRateRegister"))
        return memberBlockList
    }
    // get register and change size to 1 so uint8 registers are generated instead of 16 bit
    var customRegister: AVRModules.Module.RegisterGroup.Register = register
    customRegister.size = .one
    
    memberBlockList.append(generateRegister(customRegister, "baudRateRegisterL"))
    
    // I have no idea if this is ok, I'll just assume it is since it works
    customRegister.offset = .init(rawValue: (register.offset.rawValue.hexValue() + 1).toHex()) ?? .zeroX
    memberBlockList.append(generateRegister(customRegister, "baudRateRegisterH"))

    memberBlockList.append(MemberBlockItemSyntax(decl: DeclSyntax("\(raw: uart16bitBaudRegister)").with(\.trailingTrivia, .newlines(2))))
    
    return memberBlockList
}

fileprivate func supplementalData(for register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData {
    switch register.name {
    case .UDR0, .UDR1, .UDR2, .UDR3:
        return SupplementalRegisterData(variableName: "dataRegister", valueType: "", defaultValue: "", documentation: "", access: "")
    case .UCSR0A, .UCSR1A, .UCSR2A, .UCSR3A:
        return SupplementalRegisterData(variableName: "controlRegisterA", valueType: "", defaultValue: "", documentation: "", access: "")
    case .UCSR0B, .UCSR1B, .UCSR2B, .UCSR3B:
        return SupplementalRegisterData(variableName: "controlRegisterB", valueType: "", defaultValue: "", documentation: "", access: "")
    case .UCSR0C, .UCSR1C, .UCSR2C, .UCSR3C:
        return SupplementalRegisterData(variableName: "controlRegisterC", valueType: "", defaultValue: "", documentation: "", access: "")
    case .UCSR0D, .UCSR1D, .UCSR2D:
        return SupplementalRegisterData(variableName: "controlRegisterD", valueType: "", defaultValue: "", documentation: "", access: "")
    
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
        let name = variableName.prefix(1).lowercased() + variableName.dropFirst()
        return SupplementalRegisterData(variableName: name, valueType: "", defaultValue: "", documentation: "", access: "")
    }
}

fileprivate func supplementalData(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalRegisterData {
    switch bitfield.name {
    case .UPM0, .UPM1, .UPM2, .UPM3:
        return SupplementalRegisterData(variableName: "parityMode", valueType: "UART.ParityMode", defaultValue: ".disabled", documentation: """
    /// Parity Mode
    /// See ATMega328p Datasheet Section 20.11.4.
    /// UPMn0 and UPMn1 are bits 4 & 5 on UCSRnC.
    ///
    ///These bits enable and set type of parity generation and check. If enabled, the Transmitter will automatically generate and send the
    /// parity of the transmitted data bits within each frame. The Receiver will generate a parity value for the incoming data and compare
    /// it to the UPMn setting. If a mismatch is detected, the UPEn Flag in UCSRnA will be set.
    ///
    /// ```
    ///| UPMn1 | UPMn0 | Parity Mode          |
    ///|-------|-------|----------------------|
    ///| 0     | 0     | Disabled             |
    ///| 0     | 1     | Reserved             |
    ///| 1     | 0     | Enabled, Even Parity |
    ///| 1     | 1     | Enabled, Odd Parity  |
    /// ```
""", access: "")
    case .USBS0, .USBS1, .USBS2, .USBS3:
        return SupplementalRegisterData(variableName: "numberOfStopBits", valueType: "UART.NumberOfStopBits", defaultValue: ".one", documentation: "", access: "")
    case .UCSZ0, .UCSZ1, .UCSZ2, .UCSZ3, .UCSZ02:
        return SupplementalRegisterData(variableName: "numberOfDataBits", valueType: "UART.NumberOfDataBits", defaultValue: ".eight", documentation: "", access: "")
    case .UCPOL0, .UCPOL1, .UCPOL2, .UCPOL3:
        return SupplementalRegisterData(variableName: "clockPolarity", valueType: "UART.ClockPolarity", defaultValue: ".rising", documentation: "", access: "")
    case .U2X0, .U2X1, .U2X2, .U2X3:
        return SupplementalRegisterData(variableName: "asynchronousDoubleSpeedMode", valueType: "UART.AsynchronousDoubleSpeedMode", defaultValue: ".off", documentation: "", access: "")
    case .RXEN0, .RXEN1, .RXEN2, .RXEN3:
        return SupplementalRegisterData(variableName: "receiveEnable", valueType: "UART.ReceiverEnable", defaultValue: ".off", documentation: "", access: "")
    case .TXEN0, .TXEN1, .TXEN2, .TXEN3:
        return SupplementalRegisterData(variableName: "transmitterEnable", valueType: "UART.TransmitterEnable", defaultValue: ".off", documentation: "", access: "")
    default :
        var variableName = bitfield.caption?.rawValue ?? ""
        variableName = variableName.filter { $0 != " " }
        variableName = variableName.filter { $0 != "/" }
        variableName = variableName.filter { $0 != "0" }
        variableName = variableName.filter { $0 != "1" }
        variableName = variableName.filter { $0 != "2" }
        variableName = variableName.filter { $0 != "3" }
        variableName = variableName.filter { $0 != "4" }
        variableName = variableName.filter { $0 != "5" }
        let name = variableName.prefix(1).lowercased() + variableName.dropFirst()
        return SupplementalRegisterData(variableName: name, valueType: "", defaultValue: "", documentation: "", access: "")
    }
}

func generateUartRegister(_ register: AVRModules.Module.RegisterGroup.Register) -> MemberBlockItemSyntax {
    let supData: SupplementalRegisterData = supplementalData(for: register)
    
    return generateRegister(register, supData.variableName)
}

func generateRegister(_ register: AVRModules.Module.RegisterGroup.Register, _ variableName: String) -> MemberBlockItemSyntax {
    
    // If the register has bitfields then generate each bit name, if not then there is just one name for all of the bits.
    var registerName = ""
    var readWrite = ""
    let registarAccess = supplementalData(for: register).access
    
    
    if register.bitfield.isEmpty {
        registerName = padString(register.name.rawValue, padding: 63)
        readWrite = padString(registarAccess, padding: 63)
    } else {
        var bitNames = getBitNames(from: register)
        bitNames = bitNames.map { padString($0, padding: 7) }
        registerName = "\(bitNames[7])|\(bitNames[6])|\(bitNames[5])|\(bitNames[4])|\(bitNames[3])|\(bitNames[2])|\(bitNames[1])|\(bitNames[0])"
        
        var bitAccess = getBitAccess(from: register, parentAccess: registarAccess) // TODO: Check the register for it's access level
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
          /// \(raw: register.name) – \(raw: register.caption?.rawValue ?? variableName)
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

let splitBitfieldAccessors: [AVRModules.Module.RegisterGroup.Register.Bitfield.Name: AVRModules.Module.RegisterGroup.Register.Bitfield.Name] = [
    .UCSZ02: .UCSZ0
]

func generateBitfieldAccessor(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
                              in register: AVRModules.Module.RegisterGroup.Register, _ registerGroup: AVRModules.Module.RegisterGroup, _ chipName: String) -> MemberBlockItemSyntax {
    if splitBitfieldAccessors.contains(where: { $0.self.key == bitfield.name}) {
        let bitfieldBName = splitBitfieldAccessors[bitfield.name]
        let registerB = registerGroup.register.first(where: {$0.bitfield.contains(where: { $0.name == bitfieldBName! })})
        let bitfieldB = registerB?.bitfield.first(where: {$0.name == bitfieldBName})
        return generateSplitBitfieldAccessorUart(bitfieldA: bitfield, bitfieldB: bitfieldB!, parentVariableA: register, parentVariableB: registerB!, chipName: chipName)
    }
    let supData = supplementalData(for: bitfield)
    let supDataParent = supplementalData(for: register)
    let bitmask = bitfield.mask.value.lowByte.binaryString
    let bitshift = UInt8(bitfield.mask.value.trailingZeroBitCount)
    let caption: String = bitfield.caption.map(\.rawValue.capitalized) ?? "Unknown"
    let enumBitmask = (bitfield.mask.value.lowByte >> bitshift).binaryString
    // TODO: Fix the weirdness happening when trying to include documentation
    // /// \(raw: bitfield.name) – \(raw: bitfield.caption?.rawValue) \(raw:supData.documentation)
    let source = DeclSyntax(
        """
        /// \(raw: bitfield.name) – \(raw: caption)
        @inlinable
        @inline(__always)
        static var \(raw: supData.variableName): \(raw: supData.valueType) {
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

func generateSplitBitfieldAccessorUart(bitfieldA: AVRModules.Module.RegisterGroup.Register.Bitfield, bitfieldB: AVRModules.Module.RegisterGroup.Register.Bitfield, parentVariableA: AVRModules.Module.RegisterGroup.Register, parentVariableB: AVRModules.Module.RegisterGroup.Register, chipName: String) -> MemberBlockItemSyntax {
    
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
    let info = supplementalData(for: bitfieldA)
    
    var lowBitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
    var lowParentVariableName: String
    var highBitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
    var hightParentVariableName: String
    
    // The LSBs of WMG should always be on TCCRnA and the MSBs should be on TCCRnB.
    
//    switch parentVariableA.name {
//    case .TCCR0A, .TCCR1A, .TCCR2A, .TCCR3A, .TCCR4A, .TCCR5A:
//        lowBitfield = bitfieldA
//        lowParentVariableName = supplementalData(for: parentVariableA).variableName
//        highBitfield = bitfieldB
//        hightParentVariableName = supplementalData(for: parentVariableB).variableName
//    case .TCCR0B, .TCCR1B, .TCCR2B, .TCCR3B, .TCCR4B, .TCCR5B:
//        lowBitfield = bitfieldB
//        lowParentVariableName = supplementalData(for: parentVariableB).variableName
//        highBitfield = bitfieldA
//        hightParentVariableName = supplementalData(for: parentVariableA).variableName
//    case .TCCR2, .TCCR0, .TCCR4D: // ATmega8, ATmega16, ATmega16U4 // I think this only has one TCCR register.
//        print("Failed to generate WaveformGenerationMode Accessor.")
//        logs.addLog("Failed to generate WaveformGenerationMode Accessor. The register: \(parentVariableA.name) has something different that needs to be handled.", toChip: chipName) // TODO: Set to the correct chip name!
//        let source = DeclSyntax("")
//        return MemberBlockItemSyntax(decl: source)
//    default :
//        // By having a default case that is different from the logging case above I can have two levels of errors.
//        // Forced errors at run time that will show me every case that has issues which have been added to the case above to fail more gracefully and can be known, researched, and fixed.
//        fatalError("Unhandled parent variable name for WaveformGenerationMode: \(parentVariableA.name.rawValue)")
//    }
    lowParentVariableName = supplementalData(for: parentVariableB).variableName
    hightParentVariableName = supplementalData(for: parentVariableA).variableName
    lowBitfield = bitfieldB
    highBitfield = bitfieldA
    // Mask Value is 16 Bits and we have to have 8. Assuming that it's a total error to have a mask with bits above 8 we will just throw those away.
    let lowBitmask = lowBitfield.mask.value.lowByte.binaryString
    let highBitmask = highBitfield.mask.value.lowByte.binaryString
    
    
    
    
    // We then make sure that the byte is shifted all the way over to the Least Significant Bit because the value assigned will also be in the Least Significant Bits.
    let lowBitshift = UInt8(lowBitfield.mask.value.trailingZeroBitCount)
    let highBitshift = UInt8(highBitfield.mask.value.trailingZeroBitCount)
    
    // Then turn all of this into a bianary string for legibility, a bitmask should be seen as bits and not an Int or Hex value.
    let newValueLowBitmask = (lowBitfield.mask.value.lowByte >> lowBitshift).binaryString
    
    print()
    print("-----------------------------------------------------------")
    print("Low Bitmask Value: \(lowBitfield.mask.value), Mask: \(lowBitmask), Shift: \(lowBitshift)")
    print("high Bitmask Value: \(highBitfield.mask.value), Mask: \(highBitmask), Shift: \(highBitshift)")
    print("adjustedHighBitshift = \(highBitshift) - \(UInt8(lowBitfield.mask.value.nonzeroBitCount))")
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
          public static var \(raw: info.variableName): \(raw: info.valueType) {
              get {
                  let mode = ((\(raw: hightParentVariableName) & \(raw: highBitmask)) \(raw: getShiftDirection) \(raw: highBitshift)) | ((\(raw: lowParentVariableName) & \(raw: lowBitmask)) \(raw: getShiftDirection) \(raw: lowBitshift))
                  return \(raw: info.valueType).init(rawValue: mode) ?? \(raw: info.defaultValue)
              }
              set {
                  \(raw: lowParentVariableName) = (\(raw: lowParentVariableName) & ~\(raw: lowBitmask)) | ((newValue.rawValue & \(raw: newValueLowBitmask)) << UInt8(\(raw: lowBitshift)))
                  \(raw: hightParentVariableName) = (\(raw: hightParentVariableName) & ~\(raw: highBitmask)) | ((newValue.rawValue \(raw: setShiftDirection) \(raw: highBitshift) ) & \(raw: newValueHighBitmask))
              }
          }
      """
    )
    
    return MemberBlockItemSyntax(decl: source)
}

let uartBoilerPlate = """
public enum UART {

    /// See ATMega328p Datasheet Section 20.4.1 and Table 20-9.
    public enum ParityMode: UInt8 {
        case disabled = 0
        case even = 2
        case odd = 3
    }

    /// See ATMega328p Datasheet Table 20-10.
    public enum NumberOfStopBits: UInt8 {
        case one = 0
        case two = 1
    }

    /// See ATMega328p Datasheet Section 20.4 and Table 20-11.
    public enum NumberOfDataBits: UInt8 {
        case five = 0
        case six = 1
        case seven = 2
        case eight = 3
        case nine = 7
    }

    /// See ATMega328p Datasheet Table 20-12.
    // This is relitive to the Transmitted Data Changed (Output of TxDn Pin)
    // Received Data Sampled will be opposite of Transmitted Data Changed, Ex: Rising for TX is Falling for RX.
    public enum ClockPolarity: UInt8 {
        case rising = 0
        case falling = 1
    }

    /// See ATMega328p Datasheet Section 20.11.2
    public enum AsynchronousDoubleSpeedMode: UInt8 {
        case off = 0
        case on = 1
    }

    /// See ATMega328p Datasheet Section 20.11.3
    public enum ReceiverEnable: UInt8 {
        case off = 0
        case on = 1
    }

    /// See ATMega328p Datasheet Section 20.11.3
    public enum TransmitterEnable: UInt8 {
        case off = 0
        case on = 1
    }

    /// See ATMega328p Datasheet Section 20.11.3
    public enum RXCompleteInterruptEnable: UInt8 {
        case off = 0
        case on = 1
    }

    /// See ATMega328p Datasheet Section 20.11.3
    public enum TXCompleteInterruptEnable: UInt8 {
        case off = 0
        case on = 1
    }

    /// See ATMega328p Datasheet Section 20.11.3
    public enum DRECompleteInterruptEnable: UInt8 {
        case off = 0
        case on = 1
    }
}

public protocol UARTPort {
    // this will probably(?) always be UInt8, but is useful for preventing the protocol
    // from ever accidentally being used as an existential type
    associatedtype PortDataType: BinaryInteger

    // Registers
    static var dataRegister: PortDataType { get set }
    static var baudRateRegisterH: UInt8 { get set }
    static var baudRateRegisterL: UInt8 { get set }
    static var baudRateRegister: UInt16 { get set }
    static var controlRegisterA: UInt8 { get set }
    static var controlRegisterB: UInt8 { get set }
    static var controlRegisterC: UInt8 { get set }
    
    // Communication
    static func writeByte(_ byte: PortDataType)
}
"""


let uart16bitBaudRegister = """
    /// UBBRn – USART Baud Rate Register
    /// ```
    /// --------------------------------------------------------------------------------
    /// | Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    /// --------------------------------------------------------------------------------
    /// |              |   -   |   -   |   -   |   -   |         UBRRn[12:8]           |
    /// |              |                       UBRRn[7:0]                              |
    /// --------------------------------------------------------------------------------
    /// | Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |
    /// --------------------------------------------------------------------------------
    /// | InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    /// --------------------------------------------------------------------------------
    /// ```
    /// Bits 15 through 12 are reserved for future use. For compatibility with future devices, these bit must be written to zero
    /// when UBRRnH is written.
    ///
    /// This is a 12-bit register which contains the USART baud rate. The UBRRnH contains the four most significant bits, and the
    /// UBRRnL contains the eight least significant bits of the USART baud rate. Ongoing transmissions by the Transmitter and Receive
    /// will be corrupted if the baud rate is changed. Writing UBRRnL will trigger an immediate update of the baud rate prescaler.
    @inlinable
    @inline(__always)
    public static var baudRateRegister: UInt16 {
        get {
            return (UInt16(baudRateRegisterH) << 8) | UInt16(baudRateRegisterL)
        }
        set {
            baudRateRegisterH = UInt8((newValue & 0b11111111_00000000) >> 8)
            baudRateRegisterL = UInt8(newValue & 0b11111111)
        }
    }
"""
