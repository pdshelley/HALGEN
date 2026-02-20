//
//  Utils.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 19/02/2026.
//
import Foundation

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

struct SupplementalRegisterData {
    let variableName: String
    let valueType: String
    let defaultValue: String
    let documentation: String
    let access: String
}

enum Access: String {
    case read = "R"
    case write = "W"
    case readWrite = "R/W"
}

struct SupplementalBitfieldData {
    let variableName: String
    let valueType: String
    let defaultValue: String
    let documentation: String
    let access: Access
}

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

func getVariableName(caption: String) -> String {
    var variableName = caption
    let charactersToRemove: Set<Character> = [" ", "/", "0", "1", "2", "3", "4", "5", "-"]
    variableName = variableName.filter { !charactersToRemove.contains($0) }
    let name = variableName.prefix(1).lowercased() + variableName.dropFirst()
    return name
}
