//
//  RegisterGenerator.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 26/02/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

private enum RegisterByteWidth: String {
    case one = "1"
    case two = "2"
    case four = "4"
}

/// Generates Swift code for a hardware register with optional documentation
///
/// This function creates Swift code representation for a hardware register,
/// incorporating variable names, optional documentation comments, and supplemental
/// data from chip documentation files. It handles both register-level and bitfield-level
/// information to produce comprehensive register documentation.
///
/// - Parameter register: The register object containing metadata such as name, offset,
///   and bitfield information from the ATDF device file.
/// - Parameter externalVariableName: The Swift identifier to use for the register in generated code.
/// - Parameter optionalDocumentation: Optional array of documentation strings to include
///   in the generated comments.
/// - Parameter registerData: Supplemental data for the register including access type,
///   default value, and formatted documentation from chip documentation files.
/// - Parameter bitfieldData: Supplemental data for bitfields including access type,
///   default value, and formatted documentation from chip documentation files.
/// - Parameter generateRegisterTable: Boolean flag indicating whether to generate a
///   register table for documentation purposes.
///
/// - Returns: Generated Swift code file containing the register definition and documentation.
func generateRegister(
    register: AVRModules.Module.RegisterGroup.Register,
    variableName externalVariableName: String = "",
    optionalDocumentation: String = "",
    optionalInitialValues: [String]? = nil,
    registerData: (_ register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData,
    bitfieldData: (_ bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData,
    generateRegisterTable: Bool = true
) -> MemberBlockItemListSyntax {
    guard let registerSize = RegisterByteWidth(rawValue: register.size) else {
        preconditionFailure("Unsupported register size: \(register.size)")
    }

    let supplementalRegisterData = registerData(register)
    
    // If the register has bitfields then generate each bit name, if not then there is just one name for all of the bits.
    var registerName = ""
    var readWrite = ""
    let registerAccess = supplementalRegisterData.access
    let documentation = (optionalDocumentation.isEmpty == false) ? optionalDocumentation : supplementalRegisterData.documentation
    let initialValues = optionalInitialValues ?? supplementalRegisterData.initialValues
    let variableName = (externalVariableName.isEmpty == false) ? externalVariableName : supplementalRegisterData.variableName
    var memberBlockList = MemberBlockItemListSyntax()
    var generateRegisterTableDoc = generateRegisterTable
    
    if registerSize == .two {
        // get register and change size to 1 so uint8 registers are generated instead of 16 bit
        var customRegisterL: AVRModules.Module.RegisterGroup.Register = register
        customRegisterL.size = RegisterByteWidth.one.rawValue
        memberBlockList.append(
            contentsOf: generateRegister(
                register: customRegisterL,
                variableName: "\(supplementalRegisterData.variableName)L",
                optionalDocumentation: "\(supplementalRegisterData.documentationL ?? "")",
                optionalInitialValues: supplementalRegisterData.initialValuesL,
                registerData: registerData,
                bitfieldData: bitfieldData
            )
        )
        
        var customRegisterH: AVRModules.Module.RegisterGroup.Register = register
        customRegisterH.size = RegisterByteWidth.one.rawValue
        // I have no idea if this is ok, I'll just assume it is since it works
        customRegisterH.offset = (register.offset.hexValue() + 1).toHex()
        memberBlockList.append(
            contentsOf: generateRegister(
                register: customRegisterH,
                variableName: "\(supplementalRegisterData.variableName)H",
                optionalDocumentation: "\(supplementalRegisterData.documentationH ?? "")",
                optionalInitialValues: supplementalRegisterData.initialValuesH,
                registerData: registerData,
                bitfieldData: bitfieldData
            )
        )
        generateRegisterTableDoc = false
    }
    
    if register.bitfield.isEmpty {
        registerName = padString(register.name, padding: 63)
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
        switch registerSize {
        case .one:
            return (size: "UInt8", atomicStart: "", atomicEnd: "")
        case .two:
            return (size: "UInt16", atomicStart: "atomic {", atomicEnd: " }")
        case .four:
            return (size: "UInt32", atomicStart: "atomic {", atomicEnd: " }")
        }
    }
    
    let table = """
    ```
    --------------------------------------------------------------------------------
    | Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    --------------------------------------------------------------------------------
    | (\(register.offset))       |\(registerName)|
    --------------------------------------------------------------------------------
    | Read/Write   |\(readWrite)|
    --------------------------------------------------------------------------------
    | InitialValue |\(makeInitialValueRow(from: initialValues))|
    --------------------------------------------------------------------------------
    ```
    """

    let documentationComment: String
    if supplementalRegisterData.overrideGeneratedDocumentation {
        documentationComment = makeDocumentationComment(body: documentation)
    } else {
        documentationComment = makeDocumentationComment(
            title: "\(register.name) – \(register.caption ?? variableName)",
            body: joinDocumentationSections([
                documentation,
                generateRegisterTableDoc ? table : ""
            ])
        )
    }
    
    let setterLines: [String]
    if registerAccess == Access.read.rawValue {
        setterLines = [
        ]
    } else {
        setterLines = [
            "    set {",
            "        \(bit.atomicStart)_volatileRegisterWrite\(bit.size)(\(register.offset), newValue)\(bit.atomicEnd)",
            "    }"
        ]
    }

    var declarationLines: [String] = []
    if documentationComment.isEmpty == false {
        declarationLines.append(documentationComment)
    }

    declarationLines.append(contentsOf: [
        "@inlinable",
        "@inline(__always)",
        "public static var \(variableName): \(bit.size) {",
        "    get {",
        "        \(bit.atomicStart)_volatileRegisterRead\(bit.size)(\(register.offset))\(bit.atomicEnd)",
        "    }"
    ])

    declarationLines.append(contentsOf: setterLines)
    declarationLines.append("}")

    let declaration = declarationLines.joined(separator: "\n")

    let source = DeclSyntax("\(raw: declaration)").with(\.trailingTrivia, .newlines(2))
    
    memberBlockList.append(MemberBlockItemSyntax(decl: source))
    
    return memberBlockList
}
