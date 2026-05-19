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
            + generateInterruptVectorEnum(device: device)
            + "\n\n"
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

private func generateInterruptVectorEnum(device: AVRToolsDeviceFile) -> String {
    let interrupts = device.devices.device.interrupts.interrupt.sorted { lhs, rhs in
        interruptVectorIndex(lhs) < interruptVectorIndex(rhs)
    }
    var usedCaseNames: Set<String> = []
    var lines = ["public enum InterruptVector: UInt8 {"]

    for interrupt in interrupts {
        let caseName = uniqueInterruptVectorCaseName(for: interrupt, usedCaseNames: &usedCaseNames)
        var documentationParts = [interrupt.name.trimmingCharacters(in: .whitespacesAndNewlines)]
        if let caption = interrupt.caption?.trimmingCharacters(in: .whitespacesAndNewlines), caption.isEmpty == false {
            documentationParts.append(caption)
        }
        let documentationTitle = documentationParts
            .filter { !$0.isEmpty }
            .joined(separator: " - ")
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")

        if documentationTitle.isEmpty == false {
            lines.append("    /// \(documentationTitle)")
        }
        lines.append("    case \(caseName) = \(interruptVectorIndex(interrupt))")
    }

    lines.append("}")
    return lines.joined(separator: "\n")
}

private func uniqueInterruptVectorCaseName(
    for interrupt: AVRDevices.Device.Interrupts.Interrupt,
    usedCaseNames: inout Set<String>
) -> String {
    var caseName = lowerCamelIdentifier(from: interrupt.name)
    if caseName.isEmpty {
        caseName = "vector\(interruptVectorIndex(interrupt))"
    }

    if usedCaseNames.insert(caseName).inserted {
        return caseName
    }

    let disambiguatedCaseName = "\(caseName)\(interruptVectorIndex(interrupt))"
    usedCaseNames.insert(disambiguatedCaseName)
    return disambiguatedCaseName
}

private func lowerCamelIdentifier(from value: String) -> String {
    let tokens = value
        .components(separatedBy: CharacterSet.alphanumerics.inverted)
        .filter { $0.isEmpty == false }

    guard let firstToken = tokens.first else {
        return ""
    }

    let leadingToken = firstToken.lowercased()
    let remainingTokens = tokens.dropFirst().map { token in
        let lowercasedToken = token.lowercased()
        return lowercasedToken.prefix(1).uppercased() + lowercasedToken.dropFirst()
    }
    var identifier = ([leadingToken] + remainingTokens).joined()

    if identifier.first?.isNumber == true {
        identifier = "_\(identifier)"
    }

    return identifier
}

private func interruptVectorIndex(_ interrupt: AVRDevices.Device.Interrupts.Interrupt) -> Int {
    Int(interrupt.index) ?? 0
}
