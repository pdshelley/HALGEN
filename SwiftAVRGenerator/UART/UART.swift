//
//  UART.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 12/02/2026.
//
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

func buildUART(file: AVRToolsDeviceFile) -> [GeneratedCodeFile] {
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
    
    // TODO: Find a better way to filter to the needed module
    for module in file.modules.module {
        let uartNames = module.registerGroup.compactMap { uartNamesDict[$0.name] }
        for uartName in uartNames {
            uartFiles.append(buildUART(module: module, uartName: uartName, chipName: file.devices.device.name))
        }
    }
    return uartFiles
}

func buildUART(module: AVRModules.Module, uartName: String, chipName: String) -> GeneratedCodeFile {
    let fileName = "\(uartName).swift"
    var code = buildUartFileHeader(for: uartName)
    var memberBlockList = MemberBlockItemListSyntax()
    
    for registerGroup in module.registerGroup {
        for register in registerGroup.register {
            memberBlockList.append(generateUartRegister(register))
        }
    }
    
    let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())
    
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

func generateUartRegister(_ register: AVRModules.Module.RegisterGroup.Register) -> MemberBlockItemSyntax {
    let supData: SupplementalRegisterData = uartSupplementalData(for: register)
    
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
          /// \(raw: register.name) – \(raw: register.caption?.rawValue ?? supData.variableName)
          ///```
          ///--------------------------------------------------------------------------------
          ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
          ///--------------------------------------------------------------------------------
          ///| (\(raw: register.offset.rawValue))       |\(raw: register.name)|
          ///--------------------------------------------------------------------------------
          ///| Read/Write   ||
          ///--------------------------------------------------------------------------------
          ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
          ///--------------------------------------------------------------------------------
          ///```
          @inlinable
          @inline(__always)
          public static var \(raw: supData.variableName): \(raw: bit.size) {
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
