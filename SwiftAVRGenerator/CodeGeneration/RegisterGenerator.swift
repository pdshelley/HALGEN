//
//  RegisterGenerator.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 26/02/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

func generateRegister(
    register: AVRModules.Module.RegisterGroup.Register,
    variableName externalVariableName: String = "",
    optionalDocumentation: String = "",
    registerData: (_ register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData,
    bitfieldData: (_ bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData,
    generateRegisterTable: Bool = true
) -> MemberBlockItemListSyntax {
    
    // If the register has bitfields then generate each bit name, if not then there is just one name for all of the bits.
    var registerName = ""
    var readWrite = ""
    let registerAccess = registerData(register).access
    let documentation = (optionalDocumentation.isEmpty == false) ? optionalDocumentation : registerData(register).documentation
    let variableName = (externalVariableName.isEmpty == false) ? externalVariableName : registerData(register).variableName
    var memberBlockList = MemberBlockItemListSyntax()
    var generateRegisterTableDoc = generateRegisterTable
    
    if register.size == .two {
        // get register and change size to 1 so uint8 registers are generated instead of 16 bit
        var customRegisterL: AVRModules.Module.RegisterGroup.Register = register
        customRegisterL.size = .one
        memberBlockList.append(
            contentsOf: generateRegister(
                register: customRegisterL,
                variableName: "\(registerData(register).variableName)L",
                optionalDocumentation: "\(registerData(register).documentationL ?? "")",
                registerData: registerData,
                bitfieldData: bitfieldData
            )
        )
        
        var customRegisterH: AVRModules.Module.RegisterGroup.Register = register
        customRegisterH.size = .one
        // I have no idea if this is ok, I'll just assume it is since it works
        customRegisterH.offset = .init(rawValue: (register.offset.rawValue.hexValue() + 1).toHex()) ?? .zeroX
        memberBlockList.append(
            contentsOf: generateRegister(
                register: customRegisterH,
                variableName: "\(registerData(register).variableName)H",
                optionalDocumentation: "\(registerData(register).documentationH ?? "")",
                registerData: registerData,
                bitfieldData: bitfieldData
            )
        )
        generateRegisterTableDoc = false
    }
    
    if register.bitfield.isEmpty {
        registerName = padString(register.name.rawValue, padding: 63)
        readWrite = padString(registerAccess, padding: 63)
    } else {
        var bitNames = getBitNames(from: register)
        bitNames = bitNames.map { padString($0, padding: 7) }
        registerName = "\(bitNames[7])|\(bitNames[6])|\(bitNames[5])|\(bitNames[4])|\(bitNames[3])|\(bitNames[2])|\(bitNames[1])|\(bitNames[0])"
        
        var bitAccess = getBitAccess(from: register, parentAccess: registerAccess, supplementalData: bitfieldData) // TODO: Check the register for it's access level
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
    
    let table = """
      \n    ///```
          ///--------------------------------------------------------------------------------
          ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
          ///--------------------------------------------------------------------------------
          ///| (\(register.offset.rawValue))       |\(registerName)|
          ///--------------------------------------------------------------------------------
          ///| Read/Write   |\(readWrite)|
          ///--------------------------------------------------------------------------------
          ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
          ///--------------------------------------------------------------------------------
          ///```
      """
    
    let source = DeclSyntax(
      """
          /// \(raw: register.name) – \(raw: register.caption?.rawValue ?? variableName) \(raw: documentation) \(raw: generateRegisterTableDoc ? table : "")
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
    
    memberBlockList.append(MemberBlockItemSyntax(decl: source))
    
    return memberBlockList
}
