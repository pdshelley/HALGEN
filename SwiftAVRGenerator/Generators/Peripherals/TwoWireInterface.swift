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
        device.modules.module.contains { $0.name == "TWI" }
    }

    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        guard let twiModule = device.modules.module.first(where: { $0.name == "TWI" }) else {
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

        for registerGroup in twiModule.registerGroup {
            let structName = "TwoWireInterface\(peripheralInstanceIndex(for: registerGroup.name))"
            var code = buildFileHeader(for: structName, generateTypealias: false)

            if twiModule.registerGroup.count == 1 {
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
