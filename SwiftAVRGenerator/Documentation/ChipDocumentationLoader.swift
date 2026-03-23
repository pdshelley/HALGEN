//
//  ChipDocumentationLoader.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 25/02/2026.
//

import Foundation

struct MissingRegisterLog: Codable {
    let name: String
    let caption: String
    let offset: String
    let suggestedVariableName: String
}

struct MissingBitfieldLog: Codable {
    let name: String
    let caption: String
    let mask: String
    let suggestedVariableName: String
}

struct ChipGenerationLog: Codable {
    let name: String
    let exported: Bool
    let missingRegisters: [MissingRegisterLog]
    let missingBitfields: [MissingBitfieldLog]

    enum CodingKeys: String, CodingKey {
        case name
        case exported
        case missingRegisters
        case missingBitfields
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(exported, forKey: .exported)
        try container.encode(missingRegisters, forKey: .missingRegisters)
        try container.encode(missingBitfields, forKey: .missingBitfields)
    }
}

class ChipDocumentationLoader {
    private var chipDocumentation: ChipDocumentation?
    private var generalDocumentation: GeneralDocumentation?
    private var chipName: String = ""
    private var missingRegisters: [String: MissingRegisterLog] = [:]
    private var missingBitfields: [String: MissingBitfieldLog] = [:]
    private var registerCache: [String: SupplementalRegisterData] = [:]
    private var bitfieldCache: [String: SupplementalBitfieldData] = [:]
    var directory: URL?

    var hasMissingSupplementalData: Bool {
        missingRegisters.isEmpty == false || missingBitfields.isEmpty == false
    }

    var generationLog: ChipGenerationLog {
        let sortedMissingRegisters = missingRegisters.values.sorted { $0.name < $1.name }
        let sortedMissingBitfields = missingBitfields.values.sorted { $0.name < $1.name }

        return ChipGenerationLog(
            name: chipName,
            exported: sortedMissingRegisters.isEmpty && sortedMissingBitfields.isEmpty,
            missingRegisters: sortedMissingRegisters,
            missingBitfields: sortedMissingBitfields
        )
    }
    
    @discardableResult
    func loadGeneral() -> Bool {
        generalDocumentation = nil

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
        self.chipName = chipName
        chipDocumentation = nil
        missingRegisters.removeAll()
        missingBitfields.removeAll()
        registerCache.removeAll()
        bitfieldCache.removeAll()

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
        if let cachedData = registerCache[register.name] {
            return cachedData
        }

        let chipDocs = chipDocumentation?.registers[register.name]
        let generalDocs = generalRegister(for: register.name)

        guard chipDocs != nil || generalDocs != nil else {
            let fallbackData = missingSupplementalData(for: register)
            registerCache[register.name] = fallbackData
            return fallbackData
        }

        let fallbackVariableName = getVariableName(caption: register.caption ?? register.name)
        let resolvedData = SupplementalRegisterData(
            variableName: preferredVariableName(chipDocs?.variableName, generalDocs?.variableName, fallback: fallbackVariableName),
            valueType: chipDocs?.valueType ?? generalDocs?.valueType ?? "",
            defaultValue: chipDocs?.defaultValue ?? generalDocs?.defaultValue ?? "",
            documentation: formatDocumentation(chipDocs?.documentation),
            access: chipDocs?.access ?? generalDocs?.access ?? register.rw ?? "R/W",
            documentationL: formatOptionalDocumentation(chipDocs?.documentationL),
            documentationH: formatOptionalDocumentation(chipDocs?.documentationH),
            initialValues: formatInitialValues(chipDocs?.initialValues),
            initialValuesL: formatInitialValues(chipDocs?.initialValuesL),
            initialValuesH: formatInitialValues(chipDocs?.initialValuesH),
            overrideGeneratedDocumentation: chipDocs?.overrideGeneratedDocumentation ?? false
        )

        registerCache[register.name] = resolvedData
        return resolvedData
    }
    
    func supplementalData(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData {
        if let cachedData = bitfieldCache[bitfield.name] {
            return cachedData
        }

        let chipDocs = chipDocumentation?.bitfields[bitfield.name]
        let generalDocs = generalBitfield(for: bitfield.name)

        guard chipDocs != nil || generalDocs != nil else {
            let fallbackData = missingSupplementalData(for: bitfield)
            bitfieldCache[bitfield.name] = fallbackData
            return fallbackData
        }

        let fallbackVariableName = getVariableName(caption: bitfield.caption ?? bitfield.name)
        let resolvedData = SupplementalBitfieldData(
            variableName: preferredVariableName(chipDocs?.variableName, generalDocs?.variableName, fallback: fallbackVariableName),
            valueType: chipDocs?.valueType ?? generalDocs?.valueType ?? "",
            defaultValue: chipDocs?.defaultValue ?? generalDocs?.defaultValue ?? "",
            documentation: formatDocumentation(chipDocs?.documentation),
            access: Access(rawValue: chipDocs?.access ?? generalDocs?.access ?? bitfield.rw ?? "") ?? .readWrite,
            inline: preferredInline(chipDocs?.inline, generalDocs?.inline),
            splitTarget: chipDocs?.splitTarget,
            overrideGeneratedDocumentation: chipDocs?.overrideGeneratedDocumentation ?? false
        )

        bitfieldCache[bitfield.name] = resolvedData
        return resolvedData
    }

    private func generalRegister(for alias: String) -> GeneralRegister? {
        generalDocumentation?.registers.first { $0.aliases.contains(alias) }
    }

    private func generalBitfield(for alias: String) -> GeneralBitfield? {
        generalDocumentation?.bitfields.first { $0.aliases.contains(alias) }
    }

    private func preferredVariableName(_ primary: String?, _ secondary: String?, fallback: String) -> String {
        if let primary, primary.isEmpty == false {
            return primary
        }

        if let secondary, secondary.isEmpty == false {
            return secondary
        }

        return fallback
    }

    private func formatOptionalDocumentation(_ paragraphs: [String]?) -> String? {
        guard let paragraphs else {
            return nil
        }

        return formatDocumentation(paragraphs)
    }

    private func preferredInline(_ primary: String?, _ secondary: String?) -> String {
        normalizedNonEmpty(primary) ?? normalizedNonEmpty(secondary) ?? "__always"
    }

    private func normalizedNonEmpty(_ value: String?) -> String? {
        guard let value else {
            return nil
        }

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedValue.isEmpty == false else {
            return nil
        }

        return trimmedValue
    }

    private func missingSupplementalData(for register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData {
        let suggestedVariableName = getVariableName(caption: register.caption ?? register.name)

        missingRegisters[register.name] = MissingRegisterLog(
            name: register.name,
            caption: register.caption ?? "",
            offset: register.offset,
            suggestedVariableName: suggestedVariableName
        )

        return SupplementalRegisterData(
            variableName: suggestedVariableName,
            valueType: "",
            defaultValue: "",
            documentation: "",
            access: register.rw ?? "R/W",
            isMissing: true
        )
    }

    private func missingSupplementalData(for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData {
        let suggestedVariableName = getVariableName(caption: bitfield.caption ?? bitfield.name)

        missingBitfields[bitfield.name] = MissingBitfieldLog(
            name: bitfield.name,
            caption: bitfield.caption ?? "",
            mask: Int(bitfield.mask.value).toHex(),
            suggestedVariableName: suggestedVariableName
        )

        return SupplementalBitfieldData(
            variableName: suggestedVariableName,
            valueType: "",
            defaultValue: "",
            documentation: "",
            access: Access(rawValue: bitfield.rw ?? "") ?? .readWrite
        )
    }
}
