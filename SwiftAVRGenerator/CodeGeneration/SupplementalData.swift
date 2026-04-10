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
    var initialValues: [String]? = nil
    var initialValuesL: [String]? = nil
    var initialValuesH: [String]? = nil
    var overrideGeneratedDocumentation: Bool = false
    
    var isMissing: Bool = false
}

struct SupplementalBitfieldData {
    let variableName: String
    let valueType: String
    let defaultValue: String
    let documentation: String
    let access: Access
    var inline: String = "__always"
    var splitTargetLSB: String? = nil
    var overrideGeneratedDocumentation: Bool = false
}

enum Access: String {
    case read = "R"
    case write = "W"
    case readWrite = "R/W"
}
