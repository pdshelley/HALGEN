//
//  AVRToolsDeviceFile.swift
//  SwiftAVRGenerator
//
//  Created by HALGEN on 03/12/2026.
//

struct AVRToolsDeviceFile: Codable {
    let variants: AVRVariants
    let devices: AVRDevices
    let modules: AVRModules
    let pinouts: AVRPinouts?
}
