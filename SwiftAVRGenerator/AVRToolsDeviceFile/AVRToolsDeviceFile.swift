//
//  AVRToolsDeviceFile.swift
//  SwiftAVRGenerator
//
//  Created by Paul Shelley on 7/2/23.
//

import Foundation
import XMLCoder

struct AVRToolsDeviceFile: Codable {
    let variants: AVRVariants
    let devices: AVRDevices
    let modules: AVRModules
    let pinouts: AVRPinouts?
}
