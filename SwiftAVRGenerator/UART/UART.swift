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
    let code: String = buildUartFileHeader(for: fileName) + uartBoilerPlate
    uartFiles.append(GeneratedCodeFile(fileName: fileName, content: code))
    
    let uartNamesDict: [AVRModules.Module.RegisterGroup.Name: String] = [
        .USART0: "UART0",
        .USART1: "UART1",
        .USART2: "UART2",
        .USART3: "UART3"
    ]
    
//    for module in file.modules.module {
//        let uartNames = module.registerGroup.compactMap { uartNamesDict[$0.name] }
//        for uartName in uartNames {
//            uartFiles.append(buildUART(module: module, uartName: uartName, chipName: file.devices.device.name))
//        }
//    }
    
    let bitfieldAccessorsToGenerate: [AVRModules.Module.RegisterGroup.Register.Bitfield.Name] = [
        .UPM0
    ]
    
    if let module: AVRModules.Module = file.modules.module.first(where: { $0.name == .usart }) {
        let uartNames = module.registerGroup.compactMap { uartNamesDict[$0.name] }
        for uartName in uartNames {
            uartFiles.append(buildUART(module: module, uartName: uartName, chipName: file.devices.device.name, bitfieldsToGenerate: bitfieldAccessorsToGenerate))
        }
    }
    
//    var uartNames: [String] = []
//
//    // TODO: Find a better way to filter to the needed module
//    for module in file.modules.module {
//        uartNames = module.registerGroup.compactMap { uartNamesDict[$0.name] }
//    }
//    for uartName in uartNames {
//        uartFiles.append(buildUART(module: module, uartName: uartName, chipName: file.devices.device.name))
//    }
    return uartFiles
}

func buildUART(module: AVRModules.Module, uartName: String, chipName: String, bitfieldsToGenerate: [AVRModules.Module.RegisterGroup.Register.Bitfield.Name]) -> GeneratedCodeFile {
    let fileName = "\(uartName).swift"
    var code = buildUartFileHeader(for: uartName)
    var memberBlockList = MemberBlockItemListSyntax()
    
//    for registerGroup in module.registerGroup {
//        for register in registerGroup.register {
//            if register.name == AVRModules.Module.RegisterGroup.Register.Name.UBRR0 {
//                memberBlockList.append(contentsOf: generateUartBaudRegister(register))
//                continue
//            }
//            memberBlockList.append(generateUartRegister(register))
//        }
//    }
    
    if let lastChar = uartName.last, let registerGroupIndex = lastChar.wholeNumberValue {
        let registerGroup = module.registerGroup[registerGroupIndex]
        for register in registerGroup.register {
//            if register.name == AVRModules.Module.RegisterGroup.Register.Name.UBRR0 {
//                memberBlockList.append(contentsOf: generateUartBaudRegister(register))
//                continue
//            }
            switch register.name {
            case .UBRR0, .UBRR1, .UBRR2, .UBRR3:
                memberBlockList.append(contentsOf: generateUartBaudRegister(register))
                continue
            default:
                break
            }
            memberBlockList.append(generateUartRegister(register))
        }
        // TODO: Improve this
        for register in registerGroup.register {
            for bitfield in bitfieldsToGenerate {
                //let bitfield = register.bitfield.first(where: { $0.name == bitfield })!
                guard let bitfield = register.bitfield.first(where: { $0.name == bitfield }) else {
                    continue
                }
                memberBlockList.append(generateBitfieldAccessor(for: bitfield, in: register))
            }
        }
        //for bitfield in bitfieldsToGenerate {
            //let bitfieldRegister: AVRModules.Module.RegisterGroup.Register = registerGroup.register.first(where: { $0.bitfield(for: bitfield.rawValue) != nil })!
//            let registers: [AVRModules.Module.RegisterGroup.Register] = registerGroup.register
//
//            let bitfieldRegister: AVRModules.Module.RegisterGroup.Register =
//                registers.first(where: { $0.bitfield?.name == bitfield })!
//            let bitfieldRegister: AVRModules.Module.RegisterGroup.Register =
//                Swift.Array(registerGroup.register).first(where: { $0.bitfield?.name == bitfield })!
            

            //memberBlockList.append(generateBitfieldAccessor(for: module.registerGroup[registerGroupIndex].register[0], bitfield: bitfield, in: uartName))
        //}
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
    
//    let origOffset: String = register.offset.rawValue
//    var newOffset = origOffset.hexValue()
//    newOffset += 1
    // I have no idea if this is ok, I'll just assume it is since it works
    customRegister.offset = .init(rawValue: (register.offset.rawValue.hexValue() + 1).toHex()) ?? .zeroX
    memberBlockList.append(generateRegister(customRegister, "baudRateRegisterH"))

    memberBlockList.append(MemberBlockItemSyntax(decl: DeclSyntax("\(raw: uart16bitBaudRegister)")))
    
    return memberBlockList
}

func buildUartFileHeader(for fileName: String) -> String {
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
    //===----------------------------------------------------------------------===//
    // UART Serial Communications
    //===----------------------------------------------------------------------===//
    
    
    """
    
    return fileHeader
}

func uartSupplementalData(for register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData {
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

func uartSupplementalData(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalRegisterData {
    switch bitfield.name {
    case .UPM0:
        return SupplementalRegisterData(variableName: "parityMode", valueType: "UART.ParityMode", defaultValue: "", documentation: """
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
    let supData: SupplementalRegisterData = uartSupplementalData(for: register)
    
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
    )
    return MemberBlockItemSyntax(decl: source)
}

func generateBitfieldAccessor(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
                              in register: AVRModules.Module.RegisterGroup.Register) -> MemberBlockItemSyntax {
    let supData = uartSupplementalData(for: bitfield)
    let supDataParent = uartSupplementalData(for: register)
    let source = DeclSyntax(
        """
        /// \(raw: bitfield.name) – \(raw: bitfield.caption) \(raw:supData.documentation)
        @inlinable
        @inline(__always)
        static var \(raw: supData.variableName): \(raw: supData.valueType) {
            get {
                let mode = (\(raw: supDataParent.variableName)
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
