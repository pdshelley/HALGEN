//
//  AVRPinouts.swift
//  SwiftAVRGenerator
//
//  Created by HALGEN on 03/12/2026.
//

import Foundation
import XMLCoder
struct AVRPinouts: Codable {
    let pinout: [Pinout]

    enum CodingKeys: String, CodingKey {
        case pinout
    }

    struct Pinout: Codable {
        @Attribute var name: Name
        @Attribute var caption: Caption?
        let pin: [Pin]

        enum CodingKeys: String, CodingKey {
            case name
            case caption
            case pin
        }

        typealias Name = String

        typealias Caption = String

        struct Pin: Codable {
            @Attribute var position: Position
            @Attribute var pad: Pad

            enum CodingKeys: String, CodingKey {
                case position
                case pad
            }

            typealias Position = String

            typealias Pad = String
        }
    }
}
