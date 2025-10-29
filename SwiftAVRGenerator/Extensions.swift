//
//  Extensions.swift
//  SwiftAVRGenerator
//
//  Created by Paul Shelley on 6/22/24.
//

import Foundation

extension String {
    func hexValue() -> Int {
        guard self.isValidHex() else { return 0 } // TODO: Throw error.
        var newhex = self
        if self.prefix(2) == "0x" || self.prefix(2) == "0X" { newhex = String(newhex.dropFirst(2)) }
        return Int(UInt64(newhex, radix: 16)!)
    }
    
    func isValidHex() -> Bool {
        var newText = self
        if self.prefix(2) == "0x" || self.prefix(2) == "0X" { newText = String(newText.dropFirst(2)) }
        let allowedHexChars = Set("0123456789abcdefABCDEF")
        return allowedHexChars.isSuperset(of: newText)
    }
}

extension Int {
    func toHex() -> String {
        return "0x" + String(self, radix: 16).uppercased()
    }
}

extension UInt8 {
    var binaryString: String {
        let leadingZeros = "" + String(repeating: "0", count: Int(self.leadingZeroBitCount))
        return "0b" + leadingZeros + String(self, radix: 2)
    }
}

extension UInt16 {
    var binaryString: String {
        let leadingZeros = "" + String(repeating: "0", count: Int(self.leadingZeroBitCount))
        return "0b" + leadingZeros + String(self, radix: 2)
    }
}

/// Extracts the low-order (rightmost) byte or a word.
extension BinaryInteger {
    var lowByte: UInt8 {
        return UInt8(self & 0b11111111)
    }
}
