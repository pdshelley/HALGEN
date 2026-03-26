//
//  GeneralDocumentation.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 12/03/2026.
//

import Foundation

struct GeneralDocumentation: Codable {
    let registers: [GeneralRegister]
    let bitfields: [GeneralBitfield]
}


struct GeneralRegister: Codable {
    let aliases: [String]
    let variableName: String
    let valueType: String?
    let defaultValue: String?
    let access: String?
}

struct GeneralBitfield: Codable {
    let aliases: [String]
    let variableName: String
    let valueType: String?
    let defaultValue: String?
    let access: String?
    let inline: String?
}
