//
//  Utils.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 19/02/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

/// Builds a file header string for Swift source files.
///
/// Creates a formatted header comment block containing the file name,
/// creation date, and copyright information. Optionally generates a
/// lowercase typealias for the file's main type.
///
/// - Parameters:
///   - fileName: The name of the file to include in the header.
///   - generateTypealias: When `true`, includes a typealias declaration
///     at the end of the header. Defaults to `true`.
/// - Returns: A formatted string containing the complete file header.
///
/// - Note: The function uses the current system date to populate
///   the creation date and copyright year. The typealias generation
///   is currently a temporary implementation and should be moved
///   to a different location in a future refactor.
///
/// - Example:
///   ```swift
///   let header = buildFileHeader(for: "MyClass", generateTypealias: true)
///   ```
func buildFileHeader(for fileName: String, generateTypealias: Bool = true) -> String {
    let fullFormatter = DateFormatter()
    fullFormatter.dateFormat = "MM/dd/yyyy"
    let fullDateString = fullFormatter.string(from: Date())
    
    let yearFormatter = DateFormatter()
    yearFormatter.dateFormat = "yyyy"
    let yearString = yearFormatter.string(from: Date())
    
    var typealiasString = ""
    if generateTypealias {
        typealiasString = "public typealias \(fileName.lowercased()) = \(fileName)"
    }
    
    let fileHeader = """
    //===----------------------------------------------------------------------===//
    //
    // \(fileName).swift
    // CoreAVR
    //
    // Created by Swift AVR Generator on \(fullDateString).
    // Copyright © \(yearString) Paul Shelley. All rights reserved.
    //
    //===----------------------------------------------------------------------===//
    
    
    \(typealiasString)
    
    
    """
    // TODO: The typealias should be generated in a different location.
    return fileHeader
}

/// Generates an array of access strings for each bit position in a register.
///
/// This function processes a register's bitfield definitions and determines the access
/// type (read, write, or read/write) for each of the 16 possible bit positions.
/// It uses the `supplementalData` closure to retrieve access information for each
/// bitfield, falling back to the `parentAccess` value for bits without specific
/// bitfield definitions.
///
/// - Parameters:
///   - register: The register object containing bitfield definitions from the ATDF file.
///   - parentAccess: The default access string to use for bits not covered by any bitfield.
///   - supplementalData: A closure that receives a bitfield and returns its `SupplementalBitfieldData`,
///     which includes the access type for that bitfield.
/// - Returns: An array of 16 strings, where each element represents the access type for
///   the corresponding bit position (0-15). Bits without a bitfield definition receive
///   the `parentAccess` value.
///
/// - Note: This function handles bitfields that span multiple consecutive bits using
///   mask values. It processes the mask to determine which bit positions belong to
///   each bitfield and assigns the appropriate access string to each position.
///
/// - Example:
///   ```swift
///   let accessTypes = getBitAccess(
///       from: register,
///       parentAccess: "R/W",
///       supplementalData: { bitfield in
///           // Return supplemental data with access information
///           return SupplementalBitfieldData(
///               variableName: bitfield.name.rawValue,
///               valueType: "UInt8",
///               defaultValue: "0",
///               documentation: "",
///               access: .readWrite
///           )
///       }
///   )
///   // accessTypes[0] contains the access string for bit 0
///   // accessTypes[15] contains the access string for bit 15
///   ```
func getBitAccess(from register: AVRModules.Module.RegisterGroup.Register, parentAccess: String, supplementalData: (_ bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData ) -> [String] {
    var bitAccess = Array(repeating: parentAccess, count: 16)
        
    for bitField in register.bitfield {
        var mask: UInt16 = bitField.mask.value
//        let name = bitField.name.rawValue
        let access = supplementalData(bitField).access
        
        // 0b0100100
        
//        let numberOfBitsInMask = mask.nonzeroBitCount
        let startIndex = mask.trailingZeroBitCount
        var currentIndex = startIndex
        mask = mask >> mask.trailingZeroBitCount // Shift out any 0s before starting.

        while mask.nonzeroBitCount > 0 {
//            var adjustedName = "" // TODO: Remove this because we don't need to change the "R/W" like we need to asjust the bit names.
//            if numberOfBitsInMask > 1 { adjustedName = "\(numberOfBitsInMask - mask.nonzeroBitCount)" } // Check if and calculated the bit name number.
            bitAccess[currentIndex] = access.rawValue //+ adjustedName // Save name at current index.
            mask = mask >> 1 // Shift out bit that we just saved.
            currentIndex += 1 + mask.trailingZeroBitCount // Increase the index, if there are more 0s increase the index by how many 0s there are.
            mask = mask >> mask.trailingZeroBitCount // If there are 0s shift them out of the mask so we don't save a name for them.
        }
    }
    
    return bitAccess
}

/// Creates a valid Swift variable name from a caption string.
///
/// Filters out invalid characters (spaces, forward slashes, digits 0-5, and hyphens)
/// and ensures the name starts with a lowercase letter.
///
/// - Parameter caption: The original caption or label text to convert.
/// - Returns: A cleaned string suitable for use as a Swift variable name.
///
/// - Note: This function is designed to create readable variable names from
///   human-readable captions, such as those found in hardware register
///   documentation or user interface labels.
///
/// - Example:
///   ```swift
///   let name = getVariableName(caption: "Timer Control")
///   // Returns: "timerControl"
///   ```
func getVariableName(caption: String) -> String {
    var variableName = caption
    let charactersToRemove: Set<Character> = [" ", "/", "0", "1", "2", "3", "4", "5", "-"]
    variableName = variableName.filter { !charactersToRemove.contains($0) }
    let name = variableName.prefix(1).lowercased() + variableName.dropFirst()
    return name
}

/// This function help create what is needed to generate documentation for a register object.
/// Note that the data sheet adds a bit number to a bit name when there are more than one bit needed for a given value. This function adds these extra numbers to the bit name as they are not always present in the ATDF file. This also alwasy assumes that when a value is split accross two different registers, the most significan bit will be allone on one register and the least significant bits will be all togeather on the other register. This is believed to be the case but this function will calculate bit names incorectly if this is not the case. Ex: "FOC2A", "FOC2B", "-",  "-", "WGM22", "CS22", "CS21", "CS20"] and ["COM2A1", "COM2A0", "COM2B1", "COM2B0", "-", "-", "WGM21", "WGM20"] This example works because the ATDF file lists WGM2  as a setting with 2 bits on one register and then lists WGM22 as a setting on the other register. The second register will not add a number to the end because it is the only bit with that name.
/// This function will work for non-consecutive bit locations (Ex: 00110010) and give them the correct names.
/// - Parameter register: A register from the ATDF file object.
/// - Returns: A fixed array of 16 that includes either a "-" if there is no bit in that positon or the name of the bit in that position.
/// Example output: ["FOC2A", "FOC2B", "-", "-", "WGM22", "CS22", "CS21", "CS20"]
func getBitNames(from register: AVRModules.Module.RegisterGroup.Register) -> [String] {
    var bitNames = Array(repeating: "-", count: 16)
        
    for bitField in register.bitfield {
        var mask: UInt16 = bitField.mask.value
        let name = bitField.name.rawValue
        
        // 0b0100100
        
        let numberOfBitsInMask = mask.nonzeroBitCount
        let startIndex = mask.trailingZeroBitCount
        var currentIndex = startIndex
        mask = mask >> mask.trailingZeroBitCount // Shift out any 0s before starting.

        while mask.nonzeroBitCount > 0 {
            var adjustedName = ""
            if numberOfBitsInMask > 1 { adjustedName = "\(numberOfBitsInMask - mask.nonzeroBitCount)" } // Check if and calculated the bit name number.
            bitNames[currentIndex] = name + adjustedName // Save name at current index.
            mask = mask >> 1 // Shift out bit that we just saved.
            currentIndex += 1 + mask.trailingZeroBitCount // Increase the index, if there are more 0s increase the index by how many 0s there are.
            mask = mask >> mask.trailingZeroBitCount // If there are 0s shift them out of the mask so we don't save a name for them.
        }
    }
    
    return bitNames
}
