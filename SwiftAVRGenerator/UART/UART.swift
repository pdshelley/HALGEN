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
    let code: String = buildFileHeader(for: fileName, generateTypealias: false) + UARTDocs.uartBoilerPlate
    uartFiles.append(GeneratedCodeFile(fileName: fileName, content: code))
    
    let uartNamesDict: [AVRModules.Module.RegisterGroup.Name: String] = [
        .USART0: "UART0",
        .USART1: "UART1",
        .USART2: "UART2",
        .USART3: "UART3"
    ]
    
    if let module: AVRModules.Module = file.modules.module.first(where: { $0.name == .usart }) {
        let registerGroups: [AVRModules.Module.RegisterGroup] = module.registerGroup.filter { uartNamesDict.keys.contains($0.name) }
        for registerGroup in registerGroups {
            uartFiles.append(buildUART(registerGroup: registerGroup, uartName: uartNamesDict[registerGroup.name]!, chipName: file.devices.device.name))
        }
    }
    return uartFiles
}

func buildUART(registerGroup: AVRModules.Module.RegisterGroup, uartName: String, chipName: String) -> GeneratedCodeFile {
    let fileName = "\(uartName).swift"
    var code = buildFileHeader(for: uartName)
    var memberBlockList = MemberBlockItemListSyntax()
    
    for register in registerGroup.register {
        switch register.name {
        case .UBRR0, .UBRR1, .UBRR2, .UBRR3:
            memberBlockList.append(contentsOf: generateUartBaudRegister(register))
            continue
        default:
            memberBlockList.append(generateUartRegister(register))
        }
    }
    
    // Doing this in the above loop would be more efficient but I want to generate the registers before anything else
    for register in registerGroup.register {
        for bitfield in register.bitfield {
            if !splitBitfieldAccessors.values.contains(where: { $0 == bitfield.name}) {
                memberBlockList.append(generateBitfieldAccessor(for: bitfield, in: register, registerGroup, chipName))
            }
        }
    }
    
    let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())
    
    // Information needed to setup the Struct.
    let InheritedType = InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "UARTPort"))
    let inheritedTypeList = InheritedTypeListSyntax(arrayLiteral: InheritedType)
    let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
    
    code.append(SourceFileSyntax {
        StructDeclSyntax(
            modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
            name: "\(raw: uartName)",
            inheritanceClause: inheritanceClause,
            memberBlock: memberBlock
        )
    }.formatted().description)
    
    return GeneratedCodeFile(fileName: fileName, content: code)
}

func generateUartRegister(_ register: AVRModules.Module.RegisterGroup.Register) -> MemberBlockItemSyntax {
    let supData: SupplementalRegisterData = supplementalData(for: register)
    
    return generateRegister(register, supData.variableName)
}

func generateRegister(_ register: AVRModules.Module.RegisterGroup.Register, _ variableName: String, optionalDocumentation: String = "") -> MemberBlockItemSyntax {
    
    // If the register has bitfields then generate each bit name, if not then there is just one name for all of the bits.
    var registerName = ""
    var readWrite = ""
    let registarAccess = supplementalData(for: register).access
    let documentation = (optionalDocumentation.isEmpty == false) ? optionalDocumentation : supplementalData(for: register).documentation
    
    if register.bitfield.isEmpty {
        registerName = padString(register.name.rawValue, padding: 63)
        readWrite = padString(registarAccess, padding: 63)
    } else {
        var bitNames = getBitNames(from: register)
        bitNames = bitNames.map { padString($0, padding: 7) }
        registerName = "\(bitNames[7])|\(bitNames[6])|\(bitNames[5])|\(bitNames[4])|\(bitNames[3])|\(bitNames[2])|\(bitNames[1])|\(bitNames[0])"
        
        var bitAccess = getBitAccess(from: register, parentAccess: registarAccess, supplementalData: supplementalData(for:)) // TODO: Check the register for it's access level
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

func generateUartBaudRegister(_ register: AVRModules.Module.RegisterGroup.Register) -> MemberBlockItemListSyntax {
    var memberBlockList = MemberBlockItemListSyntax()
    if register.size == AVRModules.Module.RegisterGroup.Register.Size.one {
        memberBlockList.append(generateRegister(register, "baudRateRegister"))
        return memberBlockList
    }
    // get register and change size to 1 so uint8 registers are generated instead of 16 bit
    var customRegister: AVRModules.Module.RegisterGroup.Register = register
    customRegister.size = .one
    
    memberBlockList.append(generateRegister(customRegister, "baudRateRegisterL", optionalDocumentation: UARTDocs.baudRegisterLDocumentation))
    
    // I have no idea if this is ok, I'll just assume it is since it works
    customRegister.offset = .init(rawValue: (register.offset.rawValue.hexValue() + 1).toHex()) ?? .zeroX
    memberBlockList.append(generateRegister(customRegister, "baudRateRegisterH", optionalDocumentation: UARTDocs.baudRegisterHDocumentation))

    memberBlockList.append(MemberBlockItemSyntax(decl: DeclSyntax("\(raw: UARTDocs.uart16bitBaudRegister)").with(\.trailingTrivia, .newlines(2))))
    
    return memberBlockList
}

let splitBitfieldAccessors: [AVRModules.Module.RegisterGroup.Register.Bitfield.Name: AVRModules.Module.RegisterGroup.Register.Bitfield.Name] = [
    //HIGH - LOW
    .UCSZ02: .UCSZ0
]

func generateBitfieldAccessor(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
                              in register: AVRModules.Module.RegisterGroup.Register,
                              _ registerGroup: AVRModules.Module.RegisterGroup,
                              _ chipName: String) -> MemberBlockItemSyntax {
    if splitBitfieldAccessors.contains(where: { $0.self.key == bitfield.name}) {
        let bitfieldBName = splitBitfieldAccessors[bitfield.name]
        let registerB = registerGroup.register.first(where: {$0.bitfield.contains(where: { $0.name == bitfieldBName! })})
        let bitfieldB = registerB?.bitfield.first(where: {$0.name == bitfieldBName})
        return generateSplitBitfieldAccessorUart(bitfieldA: bitfield, bitfieldB: bitfieldB!, parentVariableA: register, parentVariableB: registerB!, chipName: chipName)
    }
    
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
              \(variableName) |= UInt8(newValue.hashValue) & \(bitmask)
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
                  \(raw: hightParentVariableName) = (\(raw: hightParentVariableName) & ~\(raw: highBitmask)) | ((newValue.rawValue \(raw: setShiftDirection) \(raw: highBitshift)) & \(raw: newValueHighBitmask))
              }
          }
      """
    )
    
    return MemberBlockItemSyntax(decl: source)
}

fileprivate func supplementalData(for register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData {
    switch register.name {
    case .UDR0, .UDR1, .UDR2, .UDR3:
        return SupplementalRegisterData(variableName: "dataRegister", valueType: "", defaultValue: "", documentation: UARTDocs.dataRegisterDocumentation, access: Access.readWrite.rawValue)
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
    case .UPM0, .UPM1, .UPM2, .UPM3:
        return SupplementalBitfieldData(variableName: "parityMode", valueType: "UART.ParityMode", defaultValue: ".disabled", documentation: UARTDocs.parityModeDocumentation, access: .readWrite)
    case .USBS0, .USBS1, .USBS2, .USBS3:
        return SupplementalBitfieldData(variableName: "numberOfStopBits", valueType: "UART.NumberOfStopBits", defaultValue: ".one", documentation: UARTDocs.numberOfStopBitsDocumentation, access: .readWrite)
    case .UCSZ0, .UCSZ1, .UCSZ2, .UCSZ3, .UCSZ02:
        return SupplementalBitfieldData(variableName: "numberOfDataBits", valueType: "UART.NumberOfDataBits", defaultValue: ".eight", documentation: UARTDocs.numberOfDataBitsDocumentation, access: .readWrite)
    case .UCPOL0, .UCPOL1, .UCPOL2, .UCPOL3:
        return SupplementalBitfieldData(variableName: "clockPolarity", valueType: "UART.ClockPolarity", defaultValue: ".rising", documentation: UARTDocs.clockPolarityDocumentation, access: .readWrite)
    case .U2X0, .U2X1, .U2X2, .U2X3:
        return SupplementalBitfieldData(variableName: "asynchronousDoubleSpeedMode", valueType: "UART.AsynchronousDoubleSpeedMode", defaultValue: ".off", documentation: UARTDocs.asynchronousDoubleSpeedModeDocumentation, access: .readWrite)
    case .RXEN0, .RXEN1, .RXEN2, .RXEN3:
        return SupplementalBitfieldData(variableName: "receiverEnable", valueType: "UART.ReceiverEnable", defaultValue: ".off", documentation: "", access: .readWrite)
    case .TXEN0, .TXEN1, .TXEN2, .TXEN3:
        return SupplementalBitfieldData(variableName: "transmitterEnable", valueType: "UART.TransmitterEnable", defaultValue: ".off", documentation: "", access: .readWrite)
    case .UDRIE0, .UDRIE1, .UDRIE2, .UDRIE3:
        return SupplementalBitfieldData(variableName: "dataRegisterEmptyInterruptEnable", valueType: "UART.DRECompleteInterruptEnable", defaultValue: ".off", documentation: "", access: .readWrite)
    case .TXCIE0, .TXCIE1, .TXCIE2, .TXCIE3:
        return SupplementalBitfieldData(variableName: "txCompleteInterruptEnable", valueType: "UART.TXCompleteInterruptEnable", defaultValue: ".off", documentation: "", access: .readWrite)
    case .RXCIE0, .RXCIE1, .RXCIE2, .RXCIE3:
        return SupplementalBitfieldData(variableName: "rxCompleteInterruptEnable", valueType: "UART.RXCompleteInterruptEnable", defaultValue: ".off", documentation: "", access: .readWrite)
    case .UPE0, .UPE1, .UPE2, .UPE3:
        return SupplementalBitfieldData(variableName: "parityError", valueType: "Bool", defaultValue: "", documentation: UARTDocs.parityErrorDocumentation, access: .read )
    case .DOR0, .DOR1, .DOR2, .DOR3:
        return SupplementalBitfieldData(variableName: "dataOverrun", valueType: "Bool", defaultValue: "", documentation: UARTDocs.dataOverrunDocumentation, access: .read )
    case .FE0, .FE1, .FE2, .FE3:
        return SupplementalBitfieldData(variableName: "frameError", valueType: "Bool", defaultValue: "", documentation: UARTDocs.frameErrorDocumentation, access: .read )
    case .UDRE0, .UDRE1, .UDRE2, .UDRE3:
        return SupplementalBitfieldData(variableName: "dataRegisterEmpty", valueType: "Bool", defaultValue: "", documentation: UARTDocs.dataRegisterEmptyDocumentation, access: .read )
    case .TXC0, .TXC1, .TXC2, .TXC3:
        return SupplementalBitfieldData(variableName: "txComplete", valueType: "Bool", defaultValue: "", documentation: UARTDocs.txCompleteDocumentation, access: .readWrite )
    case .RXC0, .RXC1, .RXC2, .RXC3:
        return SupplementalBitfieldData(variableName: "rxDataAvailable", valueType: "Bool", defaultValue: "", documentation: UARTDocs.rxDataAvailableDocumentation, access: .read )
    case .RXB80, .RXB81, .RXB82, .RXB83:
        return SupplementalBitfieldData(variableName: "", valueType: "Bool", defaultValue: "", documentation: "", access: .read )
    case .TXB80, .TXB81, .TXB82, .TXB83:
        return SupplementalBitfieldData(variableName: "", valueType: "Bool", defaultValue: "", documentation: "", access: .readWrite )
    case .UMSEL0, .UMSEL1, .UMSEL2, .UMSEL3:
        return SupplementalBitfieldData(variableName: "modeSelect", valueType: "UART.ModeSelect", defaultValue: ".asynchronous", documentation: UARTDocs.modeSelectDocumentation, access: .readWrite)
        
    default :
        // TODO: What do we do with bitfields that have no case? They are currently generated without variable name breaking the code
        return SupplementalBitfieldData(variableName: "", valueType: "", defaultValue: "", documentation: "", access: .readWrite)
    }
}

private enum UARTDocs {
    static let uartBoilerPlate = """
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
    
    static let uart16bitBaudRegister = """
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
     
    static let dataRegisterDocumentation = """
        \n    /// See ATMega328p Datasheet Section 36 Register Summary  
            /// The USART Transmit Data Buffer Register and USART Receive Data Buffer Registers share the same I/O address referred to as
            /// USART Data Register or UDRn. The Transmit Data Buffer Register (TXB) will be the destination for data written to the UDRn
            /// Register location. Reading the UDRn Register location will return the contents of the Receive Data Buffer Register (RXB).
            ///
            /// For 5-, 6-, or 7-bit characters the upper unused bits will be ignored by the Transmitter and set to zero by the Receiver.
            ///
            /// The transmit buffer can only be written when the UDREn Flag in the UCSRnA Register is set. Data written to UDRn when the
            /// UDREn Flag is not set, will be ignored by the USART Transmitter. When data is written to the transmit buffer, and the
            /// Transmitter is enabled, the Transmitter will load the data into the Transmit Shift Register when the Shift Register is empty.
            /// Then the data will be serially transmitted on the TxDn pin.
            ///
            /// The receive buffer consists of a two level FIFO. The FIFO will change its state whenever the receive buffer is accessed. Due
            /// to this behavior of the receive buffer, do not use Read-Modify-Write instructions (SBI and CBI) on this location. Be careful
            /// when using bit test instructions (SBIC and SBIS), since these also will change the state of the FIFO.
        """
    
    static let baudRegisterLDocumentation = """
        \n    /// This is a 12-bit register which contains the USART baud rate. The UBRRnH contains the four most significant bits, and the
            /// UBRRnL contains the eight least significant bits of the USART baud rate. Ongoing transmissions by the Transmitter and Receiver
            /// will be corrupted if the baud rate is changed. Writing UBRRnL will trigger an immediate update of the baud rate prescaler.
        """
    
    static let baudRegisterHDocumentation = """
        \n    /// Bits 15 through 12 are reserved for future use. For compatibility with future devices, these bit must be written to zero
            /// when UBRRnH is written.
            ///
            /// This is a 12-bit register which contains the USART baud rate. The UBRRnH contains the four most significant bits, and the
            /// UBRRnL contains the eight least significant bits of the USART baud rate. Ongoing transmissions by the Transmitter and Receiver
            /// will be corrupted if the baud rate is changed. Writing UBRRnL will trigger an immediate update of the baud rate prescaler.
        """

    static let parityModeDocumentation = """
        \n    /// Parity Mode
            /// See ATMega328p Datasheet Section 20.11.4.
            /// UPMn0 and UPMn1 are bits 4 & 5 on UCSRnC.
            ///
            /// These bits enable and set type of parity generation and check. If enabled, the Transmitter will automatically generate and send the
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
        """
    
    static let numberOfStopBitsDocumentation = """
        \n    /// See ATMega328p Datasheet Section 20.11.4.
            /// USBSn is bit 3 on UCSRnC.
        """
    
    static let numberOfDataBitsDocumentation = """
        \n    /// See ATMega328p Datasheet Section 20.11.3 and Section 20.11.4.
            /// UCSZn0 and UCSZn1 are bits 1 and 2 on UCSRnC while UCSZn2 is bit 2 on UCSRnB
        """
    
    static let clockPolarityDocumentation = """
        \n    /// See ATMega328p Datasheet Section 20.11.4.
            /// UCPOLn is bit 0 on UCSRnC.
        """
    
    static let asynchronousDoubleSpeedModeDocumentation = """
        \n    /// See ATMega328p Datasheet Section 20.
            /// U2Xn is bit 1 on UCSRnA.
        """
    
    static let parityErrorDocumentation = """
        \n    /// UPEn is Bit 2 on UCSRnA. See Section 20.11.2.
        """
    
    static let dataOverrunDocumentation = """
        \n    /// UDROn is Bit 3 on UCSRnA. See Section 20.11.2.
        """
    
    static let frameErrorDocumentation = """
        \n    /// UFEn is Bit 4 on UCSRnA. See Section 20.11.2.
        """
    
    static let dataRegisterEmptyDocumentation = """
        \n    /// UDREn is Bit 5 on UCSRnA. See Section 20.11.2.
        """
    
    static let txCompleteDocumentation = """
        \n    /// UTXCn is Bit 6 on UCSRnA. See Section 20.11.2.
        """
    
    static let rxDataAvailableDocumentation = """
        \n    /// URXCn is Bit 7 on UCSRnA. See Section 20.11.2.
        """
    
    static let modeSelectDocumentation = """
        \n    /// See ATMega328p Datasheet Section 20.11.4
            /// UMSELn are bit 7 and 6 on UCSRnC
        """
}
