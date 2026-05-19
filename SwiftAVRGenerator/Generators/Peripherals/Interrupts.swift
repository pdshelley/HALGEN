//
//  Interrupts.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 19/05/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

struct InterruptsGenerator: PeripheralGenerator {
    let name = "Interrupts"
    let logName = "Interrupts"
    let subdirectory: String = "module"
    
    func supports(device: AVRToolsDeviceFile) -> Bool {
        device.modules.module.contains { $0.name == "EXINT" }
    }
    
    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        let interruptRegisterGroup = device.modules.module.first(where: { $0.name == "EXINT" })!.registerGroup.first!
        var memberBlockList = MemberBlockItemListSyntax()
        
        for register in interruptRegisterGroup.register {
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
                    registerGroup: interruptRegisterGroup,
                    registerData: documentation.supplementalData(for:),
                    bitfieldData: documentation.supplementalData(for:)
                ) {
                    memberBlockList.append(bitfieldAccessor)
                }
            }
        }

        memberBlockList = normalizeMemberSpacing(memberBlockList)
        
        let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())

        let code = buildFileHeader(for: name, generateTypealias: false)
            + SourceFileSyntax {
                StructDeclSyntax(
                    modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
                    name: "\(raw: name)",
                    memberBlock: memberBlock
                )
            }.formatted().description

        return [GeneratedCodeFile(fileName: "\(name).swift", content: code, subdirectory: subdirectory)]
    }
}
