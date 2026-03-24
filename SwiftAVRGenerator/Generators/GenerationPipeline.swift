//
//  GenerationPipeline.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 26/02/2026.
//

struct GenerationPipeline {
    /// Runs all registered peripheral generators for a given device.
    /// - Parameters:
    ///   - device: The AVR device description loaded from an ATDF file.
    ///   - documentation: The supplemental documentation loader for enriched register/bitfield info.
    /// - Returns: An array of generated Swift code files ready for export.
    func run(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        var files: [GeneratedCodeFile] = []
        documentation.loadGeneral()
        documentation.load(chipName: device.devices.device.name)
        for generator in GeneratorRegistry.allGenerators where generator.supports(device: device) {
            let generatedFiles = documentation.withPeripheralContext(named: generator.logName) {
                generator.generate(device: device, documentation: documentation)
            }
            files.append(contentsOf: generatedFiles)
        }
        return files
    }
}
