//
//  AVRVariants.swift
//  SwiftAVRGenerator
//
//  Created by HALGEN on 03/12/2026.
//

import Foundation
import XMLCoder
struct AVRVariants: Codable {
    let variant: [Variant]

    struct Variant: Codable {
        @Attribute var ordercode: String
        @Attribute var tempmin: String
        @Attribute var tempmax: String
        @Attribute var speedmax: String
        @Attribute var pinout: String?
        @Attribute var package: String
        @Attribute var vccmin: String
        @Attribute var vccmax: String
    }
}
