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
        let initialValues: [String]?
        let initialValuesL: [String]?
        let initialValuesH: [String]?
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
                initialValues: formatInitialValues(initialValues),
                initialValuesL: formatInitialValues(initialValuesL),
                initialValuesH: formatInitialValues(initialValuesH),
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
        let splitTargetLSB: String?
        let overrideGeneratedDocumentation: Bool?
        
        func toSupplementalData() -> SupplementalBitfieldData {
            return SupplementalBitfieldData(
                variableName: variableName ?? "",
                valueType: valueType ?? "",
                defaultValue: defaultValue ?? "",
                documentation: formatDocumentation(documentation),
                access: Access(rawValue: access ?? "") ?? .readWrite,
                inline: inline ?? "__always",
                splitTargetLSB: splitTargetLSB,
                overrideGeneratedDocumentation: overrideGeneratedDocumentation ?? false
            )
        }
    }
}

func formatDocumentation(_ paragraphs: [String]?) -> String {
    guard let paragraphs, !paragraphs.isEmpty else { return "" }
    return paragraphs.joined(separator: "\n")
}

func formatInitialValues(_ values: [String]?) -> [String]? {
    guard let values, values.isEmpty == false else {
        return nil
    }

    var normalizedValues = values.prefix(8).map { value -> String in
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedValue.isEmpty ? "?" : trimmedValue
    }

    if normalizedValues.count < 8 {
        normalizedValues.append(contentsOf: repeatElement("?", count: 8 - normalizedValues.count))
    }

    return normalizedValues
}
