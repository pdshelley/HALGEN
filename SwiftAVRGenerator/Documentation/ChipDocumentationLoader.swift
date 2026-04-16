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

struct PeripheralGenerationLog: Codable {
    let name: String
    let missingRegisters: [MissingRegisterLog]
    let missingBitfields: [MissingBitfieldLog]
}

struct ChipGenerationLog: Codable {
    let name: String
    let exported: Bool

    let peripherals: [PeripheralGenerationLog]

    var missingRegisters: [MissingRegisterLog] {
        peripherals.flatMap { $0.missingRegisters }
    }

    var missingBitfields: [MissingBitfieldLog] {
        peripherals.flatMap { $0.missingBitfields }
    }
}

class ChipDocumentationLoader {
    private var chipDocumentation: ChipDocumentation?
    private var generalDocumentation: GeneralDocumentation?
    private var chipName: String = ""
    private let uncategorizedPeripheralName = "Uncategorized"
    private var currentPeripheralName: String?
    private var missingRegistersByPeripheral: [String: [String: MissingRegisterLog]] = [:]
    private var missingBitfieldsByPeripheral: [String: [String: MissingBitfieldLog]] = [:]
    private var registerCache: [String: SupplementalRegisterData] = [:]
    private var bitfieldCache: [String: SupplementalBitfieldData] = [:]
    var directory: URL?
    var inferValueTypes: Bool = false

    var hasMissingSupplementalData: Bool {
        missingRegistersByPeripheral.values.contains { $0.isEmpty == false }
            || missingBitfieldsByPeripheral.values.contains { $0.isEmpty == false }
    }

    var generationLog: ChipGenerationLog {
        let peripheralNames = Set(missingRegistersByPeripheral.keys).union(missingBitfieldsByPeripheral.keys).sorted()
        let peripheralLogs: [PeripheralGenerationLog] = peripheralNames.compactMap { peripheralName in
            let missingRegisters = (missingRegistersByPeripheral[peripheralName] ?? [:]).values.sorted { $0.name < $1.name }
            let missingBitfields = (missingBitfieldsByPeripheral[peripheralName] ?? [:]).values.sorted { $0.name < $1.name }

            guard missingRegisters.isEmpty == false || missingBitfields.isEmpty == false else {
                return nil
            }

            return PeripheralGenerationLog(
                name: peripheralName,
                missingRegisters: missingRegisters,
                missingBitfields: missingBitfields
            )
        }

        return ChipGenerationLog(
            name: chipName,
            exported: peripheralLogs.isEmpty,
            peripherals: peripheralLogs
        )
    }

    func withPeripheralContext<T>(named peripheralName: String, perform: () throws -> T) rethrows -> T {
        let previousPeripheralName = currentPeripheralName
        currentPeripheralName = peripheralName
        defer {
            currentPeripheralName = previousPeripheralName
        }

        return try perform()
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
        currentPeripheralName = nil
        missingRegistersByPeripheral.removeAll()
        missingBitfieldsByPeripheral.removeAll()
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
        let rawValueType = chipDocs?.valueType ?? generalDocs?.valueType ?? ""
        let inferredValueType = inferValueTypeIfNeeded(rawValueType, bitfield: bitfield)
        let resolvedData = SupplementalBitfieldData(
            variableName: preferredVariableName(chipDocs?.variableName, generalDocs?.variableName, fallback: fallbackVariableName),
            valueType: inferredValueType,
            defaultValue: chipDocs?.defaultValue ?? generalDocs?.defaultValue ?? "",
            documentation: formatDocumentation(chipDocs?.documentation),
            access: Access(rawValue: chipDocs?.access ?? generalDocs?.access ?? bitfield.rw ?? "") ?? .readWrite,
            inline: preferredInline(chipDocs?.inline, generalDocs?.inline),
            splitTargetLSB: chipDocs?.splitTargetLSB,
            overrideGeneratedDocumentation: chipDocs?.overrideGeneratedDocumentation ?? false
        )

        bitfieldCache[bitfield.name] = resolvedData
        return resolvedData
    }

    func boardConfiguration(for device: AVRToolsDeviceFile) -> BoardConfiguration {
        let boardOverrides = chipDocumentation?.board

        return BoardConfiguration(
            ramSize: boardOverrides?.ramSize ?? device.memorySegmentSize(named: "IRAM", type: "ram") ?? 0,
            flashSize: boardOverrides?.flashSize ?? device.memorySegmentSize(named: "FLASH", type: "flash") ?? 0,
            eepromSize: boardOverrides?.eepromSize ?? device.memorySegmentSize(named: "EEPROM", type: "eeprom"),
            baud: boardOverrides?.baud ?? 115200,
            cpuFrequency: boardOverrides?.cpuFrequency ?? device.maximumClockFrequency ?? 16000000
        )
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

    private func activePeripheralName() -> String {
        currentPeripheralName ?? uncategorizedPeripheralName
    }

    private func missingSupplementalData(for register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData {
        let suggestedVariableName = getVariableName(caption: register.caption ?? register.name)

        let peripheralName = activePeripheralName()
        var missingRegisters = missingRegistersByPeripheral[peripheralName] ?? [:]

        missingRegisters[register.name] = MissingRegisterLog(
            name: register.name,
            caption: register.caption ?? "",
            offset: register.offset,
            suggestedVariableName: suggestedVariableName
        )
        missingRegistersByPeripheral[peripheralName] = missingRegisters

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

        let peripheralName = activePeripheralName()
        var missingBitfields = missingBitfieldsByPeripheral[peripheralName] ?? [:]

        missingBitfields[bitfield.name] = MissingBitfieldLog(
            name: bitfield.name,
            caption: bitfield.caption ?? "",
            mask: Int(bitfield.mask.value).toHex(),
            suggestedVariableName: suggestedVariableName
        )
        missingBitfieldsByPeripheral[peripheralName] = missingBitfields

        return SupplementalBitfieldData(
            variableName: suggestedVariableName,
            valueType: "",
            defaultValue: "",
            documentation: "",
            access: Access(rawValue: bitfield.rw ?? "") ?? .readWrite
        )
    }

    private func inferValueTypeIfNeeded(_ valueType: String, bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> String {
        guard inferValueTypes else { return valueType }
        guard valueType.isEmpty else { return valueType }

        let mask = bitfield.mask.value
        let bitCount = mask.nonzeroBitCount

        // Single-bit fields are represented as Bool regardless of bit position.
        if bitCount == 1 {
            return "Bool"
        }

        // Only infer UInt8 for multi-bit fields whose mask fits in the low byte.
        if mask <= 0xFF {
            return "UInt8"
        }

        // For wider masks, do not infer a type yet.
        return valueType
    }
}
