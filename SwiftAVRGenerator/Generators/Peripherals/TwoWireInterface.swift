//
//  TwoWireInterface.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 16/04/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

struct TwoWireInterfaceGenerator: PeripheralGenerator {
    let name: String = "TwoWireInterface"
    let logName: String = "TWI"
    let subdirectory: String = "module/TwoWireInterface"

    func supports(device: AVRToolsDeviceFile) -> Bool {
        classicTWIRegisterGroups(in: device).isEmpty == false
    }

    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        let registerGroups = classicTWIRegisterGroups(in: device)
        guard registerGroups.isEmpty == false else {
            return []
        }

        var files: [GeneratedCodeFile] = [
            GeneratedCodeFile(
                fileName: "TwoWireInterface.swift",
                content: buildFileHeader(for: name, generateTypealias: false)
                    + BoilerplateTemplate.load(
                        named: "TwoWireInterface.swift.template",
                        documentationDirectory: documentation.directory
                    ),
                subdirectory: subdirectory
            )
        ]

        for registerGroup in registerGroups {
            let structName = "TwoWireInterface\(peripheralInstanceIndex(for: registerGroup.name))"
            var code = buildFileHeader(for: structName, generateTypealias: false)

            if registerGroups.count == 1 {
                code.append("public typealias TwoWireInterface = \(structName)\n\n\n")
            }
            var memberBlockList = MemberBlockItemListSyntax()

            for register in registerGroup.register {
                memberBlockList.append(
                    contentsOf: generateRegister(
                        register: register,
                        registerData: documentation.supplementalData(for:),
                        bitfieldData: documentation.supplementalData(for:)
                    )
                )
            }

            memberBlockList = normalizeMemberSpacing(memberBlockList)

            let memberBlock = MemberBlockSyntax(
                leftBrace: .leftBraceToken(),
                members: memberBlockList,
                rightBrace: .rightBraceToken()
            )

            let inheritedTypes = InheritedTypeListSyntax(
                arrayLiteral:
                    InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "TwoWireInterfacePort"))
            )

            let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypes)

            code.append(
                SourceFileSyntax {
                    StructDeclSyntax(
                        modifiers: DeclModifierListSyntax(
                            arrayLiteral: DeclModifierSyntax(name: "public")
                        ),
                        name: "\(raw: structName)",
                        inheritanceClause: inheritanceClause,
                        memberBlock: memberBlock
                    )
                }
                .formatted()
                .description
            )

            files.append(
                GeneratedCodeFile(
                    fileName: "\(structName).swift",
                    content: code,
                    subdirectory: subdirectory
                )
            )
        }

        return files
    }
}

private let classicTWIRegisterNames: Set<String> = [
    "TWBR",
    "TWCR",
    "TWSR",
    "TWDR",
    "TWAR",
    "TWAMR"
]

private func classicTWIRegisterGroups(in device: AVRToolsDeviceFile) -> [AVRModules.Module.RegisterGroup] {
    guard let twiModule = device.modules.module.first(where: { $0.name == "TWI" }) else {
        return []
    }

    return twiModule.registerGroup.filter(registerGroupUsesClassicTWIRegisters)
}

private func registerGroupUsesClassicTWIRegisters(_ registerGroup: AVRModules.Module.RegisterGroup) -> Bool {
    let registerNames = Set(registerGroup.register.map { normalizedClassicTWIRegisterName(for: $0.name) })
    return registerNames.isSuperset(of: classicTWIRegisterNames)
}

private func normalizedClassicTWIRegisterName(for registerName: String) -> String {
    let baseName: String
    if let suffix = trailingNumericSuffix(in: registerName) {
        baseName = String(registerName.dropLast(suffix.count))
    } else {
        baseName = registerName
    }

    return classicTWIRegisterNames.contains(baseName) ? baseName : registerName
}
