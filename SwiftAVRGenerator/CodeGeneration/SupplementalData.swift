//
//  SupplementalData.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 26/02/2026.
//

struct SupplementalRegisterData {
    let variableName: String
    let valueType: String
    let defaultValue: String
    let documentation: String
    let access: String
    var documentationL: String? = nil
    var documentationH: String? = nil
}

struct SupplementalBitfieldData {
    let variableName: String
    let valueType: String
    let defaultValue: String
    let documentation: String
    let access: Access
    var splitTarget: String? = nil
}

enum Access: String {
    case read = "R"
    case write = "W"
    case readWrite = "R/W"
}
