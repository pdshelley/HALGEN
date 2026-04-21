//
//  CPUCore.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 20/04/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

struct CPUCoreGenerator: PeripheralGenerator {
    let name: String = "CPUCore"
    let subdirectory: String = "module"
    
    func supports(device: AVRToolsDeviceFile) -> Bool {
        device.modules.module.contains { $0.name == "CPU" }
    }
    
    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        var files: [GeneratedCodeFile] = []
//        files.append(
//            GeneratedCodeFile(
//                fileName: "\(name).swift",
//                content: buildFileHeader(for: name, generateTypealias: false)
//                    + BoilerplateTemplate.load(named: "UART.swift.template", documentationDirectory: documentation.directory),
//                subdirectory: subdirectory
//            )
//        )
        
        for registerGroup in device.modules.module.first(where: { $0.name == "CPU" })!.registerGroup {
//            let instanceIndex = peripheralInstanceIndex(for: registerGroup.name)
            let structName = "CPUCore"
            var code = buildFileHeader(for: structName, generateTypealias: false)
            code.append(
                """
                public protocol AVRCPUCore {
                    static var statusRegister: UInt8 { get set }
                }

                """
            )
            code.append("public typealias cpuCore = CPUCore\n\n")
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
            let InheritedType = InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "AVRCPUCore"))
            let inheritedTypeList = InheritedTypeListSyntax(arrayLiteral: InheritedType)
            let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
            
            code.append(SourceFileSyntax {
                StructDeclSyntax(
                    modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
                    name: "\(raw: structName)",
                    inheritanceClause: inheritanceClause,
                    memberBlock: memberBlock
                )
            }.formatted().description)
            
            files.append(GeneratedCodeFile(fileName: "\(structName).swift", content: code, subdirectory: subdirectory))
        }
        
        return files
    }
}
