//
//  Extensions.swift
//  SwiftAVRGenerator
//
//  Created by Paul Shelley on 6/22/24.
//

import Foundation

extension String {
    /// Converts a hexadecimal string representation to its integer value.
    ///
    /// This function parses a hex string and returns the corresponding `Int`.
    /// If the string is not a valid hexadecimal, the function returns `0`.
    ///
    /// - Note: The function accepts hex strings with or without the `0x` or `0X` prefix.
    /// - Example: `"0xFF"` converts to `255`
    /// - Example: `"ff"` converts to `255`
    /// - Example: `"invalid"` returns `0`
    ///
    /// - Returns: The integer value of the hex string, or `0` if the string is invalid.
    ///
    /// - Complexity: O(n) where n is the length of the string.
    func hexValue() -> Int {
        guard self.isValidHex() else { return 0 } // TODO: Throw error.
        var newhex = self
        if self.prefix(2) == "0x" || self.prefix(2) == "0X" { newhex = String(newhex.dropFirst(2)) }
        return Int(UInt64(newhex, radix: 16)!)
    }
    
    /// Checks whether a string represents a valid hexadecimal number.
    ///
    /// This function validates that a string contains only valid hexadecimal characters
    /// (0-9, a-f, A-F), optionally preceded by a `0x` or `0X` prefix.
    ///
    /// - Note: The function accepts hex strings with or without the `0x` or `0X` prefix.
    /// - Example: `"0xFF"` returns `true`
    /// - Example: `"ff"` returns `true`
    /// - Example: `"invalid"` returns `false`
    /// - Example: `""` returns `false`
    ///
    /// - Returns: `true` if the string is a valid hexadecimal representation; `false` otherwise.
    ///
    /// - Complexity: O(n) where n is the length of the string.
    func isValidHex() -> Bool {
        var newText = self
        if self.prefix(2) == "0x" || self.prefix(2) == "0X" { newText = String(newText.dropFirst(2)) }
        let allowedHexChars = Set("0123456789abcdefABCDEF")
        return allowedHexChars.isSuperset(of: newText)
    }
}

extension Int {
    /// Converts an integer to its hexadecimal string representation.
    ///
    /// This function transforms an `Int` value into a hexadecimal string with the `0x` prefix
    /// and uppercase digits.
    ///
    /// - Note: The returned string always includes the `0x` prefix and uses uppercase
    ///   hexadecimal digits (0-9, A-F).
    /// - Example: `255.toHex()` returns `"0xFF"`
    /// - Example: `0.toHex()` returns `"0x0"`
    /// - Example: `-1.toHex()` returns `"0xFF"` (two's complement representation)
    ///
    /// - Returns: A string representing the hexadecimal value of the integer, prefixed with `0x`.
    ///
    /// - Complexity: O(n) where n is the number of hexadecimal digits in the result.
    func toHex() -> String {
        return "0x" + String(self, radix: 16).uppercased()
    }
}

extension UInt8 {
    /// Converts a UInt8 value to its binary string representation.
    ///
    /// This computed property transforms a UInt8 value into a binary string with the `0b` prefix
    /// and includes leading zeros to represent the full 8-bit value.
    ///
    /// - Note: The returned string always includes the `0b` prefix and uses lowercase binary digits (0-1).
    /// - Example: `0.toBinaryString()` returns `"0b00000000"`
    /// - Example: `255.toBinaryString()` returns `"0b11111111"`
    /// - Example: `1.toBinaryString()` returns `"0b00000001"`
    ///
    /// - Returns: A string representing the binary value of the UInt8, prefixed with `0b`.
    ///
    /// - Complexity: O(n) where n is the number of bits (8 for UInt8).
    var binaryString: String {
        let leadingZeros = "" + String(repeating: "0", count: Int(self.leadingZeroBitCount))
        return "0b" + leadingZeros + String(self, radix: 2)
    }
}

extension UInt16 {
    /// Converts a UInt16 value to its binary string representation.
    ///
    /// This computed property transforms a UInt16 value into a binary string with the `0b` prefix
    /// and includes leading zeros to represent the full 16-bit value.
    ///
    /// - Note: The returned string always includes the `0b` prefix and uses lowercase binary digits (0-1).
    /// - Example: `0.toBinaryString()` returns `"0b0000000000000000"`
    /// - Example: `65535.toBinaryString()` returns `"0b1111111111111111"`
    /// - Example: `1.toBinaryString()` returns `"0b0000000000000001"`
    ///
    /// - Returns: A string representing the binary value of the UInt16, prefixed with `0b`.
    ///
    /// - Complexity: O(n) where n is the number of bits (16 for UInt16).
    var binaryString: String {
        let leadingZeros = "" + String(repeating: "0", count: Int(self.leadingZeroBitCount))
        return "0b" + leadingZeros + String(self, radix: 2)
    }
}

/// Extracts the low-order (rightmost) byte or a word.
extension BinaryInteger {
    /// Extracts the low-order (rightmost) byte from a binary integer.
    ///
    /// This computed property masks the lower 8 bits of the integer value,
    /// returning them as a `UInt8`. This is equivalent to applying a bitwise
    /// AND operation with `0xFF` (255 in decimal).
    ///
    /// - Note: The property works with any `BinaryInteger` type by masking
    ///   all but the lowest 8 bits.
    /// - Example: `1600.lowByte` returns `64` (0xA0)
    /// - Example: `255.lowByte` returns `255` (0xFF)
    /// - Example: `0x12345678.lowByte` returns `120` (0x78)
    ///
    /// - Returns: The lower 8 bits of the integer as a `UInt8` value.
    ///
    /// - Complexity: O(1) - constant time operation.
    var lowByte: UInt8 {
        return UInt8(self & 0b11111111)
    }
}
