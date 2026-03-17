//
//  ChipDocumentation.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 25/02/2026.
//

import Foundation

struct ChipDocumentation: Codable {
    let chip: String
    let datasheet: String
    let registers: [String: Register]
    let bitfields: [String: Bitfield]
    
    struct Register: Codable {
        let variableName: String?
        let valueType: String?
        let defaultValue: String?
        let access: String?
        let documentation: [String]?
        let documentationL: [String]?
        let documentationH: [String]?
        let bitfields: [String: Bitfield]?
        let overrideGeneratedDocumentation: Bool?
        
        func toSupplementalData() -> SupplementalRegisterData {
            return SupplementalRegisterData(
                variableName: variableName ?? "",
                valueType: valueType ?? "",
                defaultValue: defaultValue ?? "",
                documentation: formatDocumentation(documentation),
                access: access ?? "",
                documentationL: documentationL.map { formatDocumentation($0) },
                documentationH: documentationH.map { formatDocumentation($0) },
                overrideGeneratedDocumentation: overrideGeneratedDocumentation ?? false
            )
        }
    }
    
    struct Bitfield: Codable {
        let variableName: String?
        let valueType: String?
        let defaultValue: String?
        let access: String?
        let documentation: [String]?
        let inline: String?
        let splitTarget: String?
        let overrideGeneratedDocumentation: Bool?
        
        func toSupplementalData() -> SupplementalBitfieldData {
            return SupplementalBitfieldData(
                variableName: variableName ?? "",
                valueType: valueType ?? "",
                defaultValue: defaultValue ?? "",
                documentation: formatDocumentation(documentation),
                access: Access(rawValue: access ?? "") ?? .readWrite,
                inline: inline ?? "__always",
                splitTarget: splitTarget,
                overrideGeneratedDocumentation: overrideGeneratedDocumentation ?? false
            )
        }
    }
}

func formatDocumentation(_ paragraphs: [String]?) -> String {
    guard let paragraphs, !paragraphs.isEmpty else { return "" }
    return paragraphs.joined(separator: "\n")
}
