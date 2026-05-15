//
//  EEPROM.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 15/05/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

struct EEPROMGenerator: PeripheralGenerator {
    let name: String = "EEPROM"
    let subdirectory: String = "module"

    func supports(device: AVRToolsDeviceFile) -> Bool {
        device.modules.module.contains { $0.name == "EEPROM" }
    }

    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        var files: [GeneratedCodeFile] = []

        for registerGroup in device.modules.module.first(where: { $0.name == "EEPROM" })!.registerGroup {
            let instanceIndex = peripheralInstanceIndex(for: registerGroup.name)
            var code = buildFileHeader(for: name)
            var memberBlockList = MemberBlockItemListSyntax()
            for register in registerGroup.register {
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
                        registerGroup: registerGroup,
                        registerData: documentation.supplementalData(for:),
                        bitfieldData: documentation.supplementalData(for:)
                    ) {
                        memberBlockList.append(bitfieldAccessor)
                    }
                }
            }

            memberBlockList = normalizeMemberSpacing(memberBlockList)

            let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())

            code.append(SourceFileSyntax {
                StructDeclSyntax(
                    modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
                    name: "\(raw: name)",
                    memberBlock: memberBlock
                )
            }.formatted().description)

            // Append the EEPROM helper template inside the generated struct.
            let helperTemplate = BoilerplateTemplate.load(
                named: "EEPROM.swift.template",
                documentationDirectory: documentation.directory
            )
            if let lastBrace = code.lastIndex(of: "}") {
                code.insert(contentsOf: helperTemplate, at: lastBrace)
            }

            files.append(GeneratedCodeFile(fileName: "\(name).swift", content: code, subdirectory: subdirectory))
        }

        return files
    }
}
