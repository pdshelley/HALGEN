//
//  AVRToolsDeviceFile.swift
//  SwiftAVRGenerator
//
//  Created by HALGEN on 03/12/2026.
//

import Foundation
import XMLCoder
struct AVRToolsDeviceFile: Codable {
    let variants: AVRVariants
    let devices: AVRDevices
    let modules: AVRModules
    let pinouts: AVRPinouts?
}

protocol ATDFStringValue: Codable, CaseIterable, RawRepresentable, Hashable, CustomStringConvertible where RawValue == String, AllCases == [Self] {
    var alternateValues: [String] { get }
    init(value: String, alternateValues: [String])
}

extension ATDFStringValue {
    init?(rawValue: String) {
        guard let match = Self.allCases.first(where: {
            $0.rawValue == rawValue || $0.alternateValues.contains(rawValue)
        }) else {
            return nil
        }

        self = match
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        guard let decoded = Self(rawValue: stringValue) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown value '\(stringValue)'"
            )
        }

        self = decoded
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    var description: String {
        rawValue
    }
}
