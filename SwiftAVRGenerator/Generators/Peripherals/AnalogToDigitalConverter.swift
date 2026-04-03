//
//  AnalogToDigitalConverter.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 23/02/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

struct ADCGenerator: PeripheralGenerator {
    let name = "AnalogToDigitalConverter"
    let logName = "ADC"
    let subdirectory: String = "module"
    
    func supports(device: AVRToolsDeviceFile) -> Bool {
        device.modules.module.contains { $0.name == "ADC" }
    }
    
    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        let adcRegisterGroup = device.modules.module.first(where: { $0.name == "ADC" })!.registerGroup.first!
        var memberBlockList = MemberBlockItemListSyntax()

        memberBlockList.append(
            MemberBlockItemSyntax(
                decl: DeclSyntax(
                    """
                    public typealias VoltageReferenceSelection = VoltageReference
                    public typealias AnalogChannelSelection = AnalogChannel
                    public typealias AnalogPrescalerSelection = AnalogPrescaler
                    """
                )
            )
        )
        
        for register in adcRegisterGroup.register {
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
                    registerGroup: adcRegisterGroup,
                    registerData: documentation.supplementalData(for:),
                    bitfieldData: documentation.supplementalData(for:)
                ) {
                    memberBlockList.append(bitfieldAccessor)
                }
            }
        }

        memberBlockList = normalizeMemberSpacing(memberBlockList)
        
        let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())

        let structDeclaration = SourceFileSyntax {
            StructDeclSyntax(
                modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
                name: "\(raw: name)",
                memberBlock: memberBlock
            )
        }.formatted().description

        let code = buildFileHeader(for: name, generateTypealias: false)
            + BoilerplateTemplate.render(
                named: "AnalogToDigitalConverter.swift.template",
                documentationDirectory: documentation.directory,
                substitutions: ["STRUCT_DECLARATION": structDeclaration]
            )

        return [GeneratedCodeFile(fileName: "\(name).swift", content: code, subdirectory: subdirectory)]
    }
}
