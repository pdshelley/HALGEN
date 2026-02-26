//
//  GenerationPipeline.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 26/02/2026.
//

struct GenerationPipeline {
    func run(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        var files: [GeneratedCodeFile] = []
        for generator in GeneratorRegistry.allGenerators where generator.supports(device: device) {
            files.append(contentsOf: generator.generate(device: device, documentation: documentation))
        }
        return files
    }
}
