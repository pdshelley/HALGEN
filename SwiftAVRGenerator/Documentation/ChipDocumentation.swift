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
        let variableName: String
        let valueType: String?
        let defaultValue: String?
        let access: String?
        let documentation: String?
        let documentationL: String?
        let documentationH: String?
        let bitfields: [String: Bitfield]?
        
        func toSupplementalData() -> SupplementalRegisterData {
            return SupplementalRegisterData(
                variableName: variableName,
                valueType: valueType ?? "",
                defaultValue: defaultValue ?? "",
                documentation: documentation ?? "",
                access: access ?? "",
                documentationL: documentationL,
                documentationH: documentationH
            )
        }
    }
    
    struct Bitfield: Codable {
        let variableName: String
        let valueType: String?
        let defaultValue: String?
        let access: String?
        let documentation: String?
        let splitTarget: String?
        
        func toSupplementalData() -> SupplementalBitfieldData {
            return SupplementalBitfieldData(
                variableName: variableName,
                valueType: valueType ?? "",
                defaultValue: defaultValue ?? "",
                documentation: documentation ?? "",
                access: Access(rawValue: access ?? "") ?? .readWrite
            )
        }
    }
}
