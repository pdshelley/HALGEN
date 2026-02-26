//
//  PeripheralGenerator.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 26/02/2026.
//

protocol PeripheralGenerator {
    var name: String { get }
    func supports(device: AVRToolsDeviceFile) -> Bool
    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile]
}
