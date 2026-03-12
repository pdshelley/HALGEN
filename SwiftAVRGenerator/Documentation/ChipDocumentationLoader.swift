//
//  ChipDocumentationLoader.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 25/02/2026.
//

import Foundation

class ChipDocumentationLoader {
    private var chipDocumentation: ChipDocumentation?
    private var generalDocumentation: GeneralDocumentation?
    var directory: URL?
    
    @discardableResult
    func loadGeneral() -> Bool {
        guard let fileURL = directory?.appendingPathComponent("general.json") else {
            return false
        }
        
        guard let data = try? Data(contentsOf: fileURL) else {
            return false
        }
        
        guard let decodedData = try? JSONDecoder().decode(GeneralDocumentation.self, from: data) else {
            return false
        }
        
        generalDocumentation = decodedData
        return true
    }
    
    /// Loads supplemental documentation for a specific chip from a JSON file.
    /// - Parameter chipName: The name of the chip (e.g., "ATmega328P").
    /// - Returns: `true` if the documentation was successfully loaded, `false` otherwise.
    /// - Note: The JSON file must be named `<chipName>.json` and located in the configured directory.
    @discardableResult
    func load(chipName: String) -> Bool {
        guard let fileURL = directory?.appendingPathComponent("\(chipName).json") else {
            return false
        }
        
        guard let data = try? Data(contentsOf: fileURL) else {
            return false
        }
        
        guard let decodedData = try? JSONDecoder().decode(ChipDocumentation.self, from: data) else {
            return false
        }
        
        chipDocumentation = decodedData
        
        return true
    }
    
    func supplementalData(for register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData {
        guard let docs = chipDocumentation?.registers[register.name.rawValue] else {
            return SupplementalRegisterData(
                variableName: getVariableName(
                    caption: register.caption?.rawValue ?? register.name.rawValue),
                valueType: "",
                defaultValue: "",
                documentation: "",
                access: "R/W"
            )
        }
        
        var supData = docs.toSupplementalData()
        
        if generalDocumentation != nil {
            if let generalDocs = registerVariableName(for: register.name.rawValue, in: generalDocumentation!) {
                return SupplementalRegisterData(
                    variableName: generalDocs,
                    valueType: supData.valueType,
                    defaultValue: supData.defaultValue,
                    documentation: supData.documentation,
                    access: supData.access
                )
            }
        }
        
        return docs.toSupplementalData()
    }
    
    func supplementalData(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData {
        guard let docs = chipDocumentation?.bitfields[bitfield.name.rawValue] else {
            return SupplementalBitfieldData(
                variableName: getVariableName(caption: bitfield.caption?.rawValue ?? bitfield.name.rawValue),
                valueType: "",
                defaultValue: "",
                documentation: "",
                access: .readWrite
            )
        }
        
        let supData = docs.toSupplementalData()
        
        if generalDocumentation != nil {
            if let generalDocs = bitfieldVariableName(for: bitfield.name.rawValue, in: generalDocumentation!) {
                return SupplementalBitfieldData(variableName: generalDocs, valueType: supData.valueType, defaultValue: supData.defaultValue, documentation: supData.documentation, access: supData.access)
            }
        }
        return docs.toSupplementalData()
    }
    
    private func registerVariableName(for alias: String, in doc: GeneralDocumentation) -> String? {
        doc.registers.first { $0.aliases.contains(alias) }?.variableName
    }
    
    private func bitfieldVariableName(for alias: String, in doc: GeneralDocumentation) -> String? {
        doc.registers.first { $0.aliases.contains(alias) }?.variableName
    }
}
