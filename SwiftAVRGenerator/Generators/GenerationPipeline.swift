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
        for generator in GeneratorRegistry.allGenerators where generator.supports(device: device) {
            files.append(contentsOf: generator.generate(device: device, documentation: documentation))
        }
        return files
    }
}
