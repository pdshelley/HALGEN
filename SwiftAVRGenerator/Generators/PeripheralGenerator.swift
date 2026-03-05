//
//  PeripheralGenerator.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 26/02/2026.
//

protocol PeripheralGenerator {
    var name: String { get }
    var subdirectory: String { get }
    /// Determines whether this peripheral generator can generate code for the specified device.
    /// - Parameter device: The device file to check support for.
    /// - Returns: `true` if this generator can produce code for the device; `false` otherwise.
    func supports(device: AVRToolsDeviceFile) -> Bool
    /// Generates code files for the specified device using the provided documentation.
    /// - Parameters:
    ///   - device: The device file to generate code for.
    ///   - documentation: The chip documentation loader containing device specifications.
    /// - Returns: An array of generated code files for the peripheral.
    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile]
}
