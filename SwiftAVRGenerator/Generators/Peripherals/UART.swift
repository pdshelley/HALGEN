//
//  UART.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 12/02/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

struct UARTGenerator: PeripheralGenerator {
    let name: String = "UART"
    let subdirectory: String = "module/UART"
    
    func supports(device: AVRToolsDeviceFile) -> Bool {
        device.modules.module.contains { $0.name == "USART" }
    }
    
    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        var files: [GeneratedCodeFile] = []
        files.append(
            GeneratedCodeFile(
                fileName: "\(name).swift",
                content: buildFileHeader(for: name, generateTypealias: false)
                    + BoilerplateTemplate.load(named: "UART.swift.template", documentationDirectory: documentation.directory),
                subdirectory: subdirectory
            )
        )
        
        for registerGroup in device.modules.module.first(where: { $0.name == "USART" })!.registerGroup {
            var code = buildFileHeader(for: "UART\(registerGroup.name.first(where: { $0.isNumber }) ?? "0")")
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
            
            // Information needed to setup the Struct.
            let InheritedType = InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "UARTPort"))
            let inheritedTypeList = InheritedTypeListSyntax(arrayLiteral: InheritedType)
            let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
            
            code.append(SourceFileSyntax {
                StructDeclSyntax(
                    modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
                    name: "\(raw: "UART\(registerGroup.name.first(where: { $0.isNumber }) ?? "0")")",
                    inheritanceClause: inheritanceClause,
                    memberBlock: memberBlock
                )
            }.formatted().description)
            
            files.append(GeneratedCodeFile(fileName: "UART\(registerGroup.name.first(where: { $0.isNumber }) ?? "0").swift", content: code, subdirectory: subdirectory))
        }
        
        return files
    }
}
