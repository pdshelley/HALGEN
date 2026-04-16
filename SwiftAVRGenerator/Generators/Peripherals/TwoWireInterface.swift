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
        guard let twiModule = device.modules.module.first(where: { $0.name == "TWI" }) else {
            return false
        }

        return twiModule.registerGroup.contains(where: registerGroupUsesClassicTwoWireRegisters)
    }

    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        guard let twiModule = device.modules.module.first(where: { $0.name == "TWI" }) else {
            return []
        }

        let classicRegisterGroups = twiModule.registerGroup.filter(registerGroupUsesClassicTwoWireRegisters)

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

        for registerGroup in classicRegisterGroups {
            let structName = "TwoWireInterface\(peripheralInstanceIndex(for: registerGroup.name))"
            var code = buildFileHeader(for: structName, generateTypealias: false)

            if classicRegisterGroups.count == 1 {
                code.append("public typealias TwoWireInterface = \(structName)\n\n\n")
            }
            var memberBlockList = MemberBlockItemListSyntax()

            for register in canonicalTwoWireRegisters(in: registerGroup) {
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

private let classicRequiredTwoWireRegisterKeys: Set<String> = [
    "TWBR",
    "TWCR",
    "TWSR",
    "TWDR",
    "TWAR",
    "TWAMR"
]

private let classicTwoWireRegisterOrder: [String] = [
    "TWBR",
    "TWCR",
    "TWSR",
    "TWDR",
    "TWAR",
    "TWAMR"
]

private func registerGroupUsesClassicTwoWireRegisters(
    _ registerGroup: AVRModules.Module.RegisterGroup
) -> Bool {
    // The generated API must stay source-compatible with the handwritten HAL,
    // which expects the classic TWBR/TWCR/TWSR/TWDR/TWAR/TWAMR register set.
    let registerNames = Set(registerGroup.register.map { normalizedTwoWireRegisterKey(for: $0.name) })

    return registerNames.isSuperset(of: classicRequiredTwoWireRegisterKeys)
        && registerNames.isSubset(of: classicRequiredTwoWireRegisterKeys)
}

private func canonicalTwoWireRegisters(
    in registerGroup: AVRModules.Module.RegisterGroup
) -> [AVRModules.Module.RegisterGroup.Register] {
    var registersByKey: [String: AVRModules.Module.RegisterGroup.Register] = [:]

    for register in registerGroup.register {
        let key = normalizedTwoWireRegisterKey(for: register.name)

        guard classicTwoWireRegisterOrder.contains(key) else {
            continue
        }

        if let existingRegister = registersByKey[key] {
            if shouldReplaceTwoWireRegister(
                existingRegister,
                with: register,
                normalizedKey: key
            ) {
                registersByKey[key] = register
            }
        } else {
            registersByKey[key] = register
        }
    }

    return classicTwoWireRegisterOrder.compactMap { registersByKey[$0] }
}

private func normalizedTwoWireRegisterKey(for registerName: String) -> String {
    guard let suffix = trailingNumericSuffix(in: registerName) else {
        return registerName
    }

    return String(registerName.dropLast(suffix.count))
}

private func shouldReplaceTwoWireRegister(
    _ existingRegister: AVRModules.Module.RegisterGroup.Register,
    with candidateRegister: AVRModules.Module.RegisterGroup.Register,
    normalizedKey: String
) -> Bool {
    let existingIsUnsuffixed = existingRegister.name == normalizedKey
    let candidateIsUnsuffixed = candidateRegister.name == normalizedKey

    if existingIsUnsuffixed != candidateIsUnsuffixed {
        return candidateIsUnsuffixed
    }

    return false
}
