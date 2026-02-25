//
//  Utils.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 19/02/2026.
//
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

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

func generateRegister(
    register: AVRModules.Module.RegisterGroup.Register,
    variableName externalVariableName: String = "",
    optionalDocumentation: String = "",
    registerData: (_ register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData,
    bitfieldData: (_ bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData,
    generateRegisterTable: Bool = true
) -> MemberBlockItemListSyntax {
    
    // If the register has bitfields then generate each bit name, if not then there is just one name for all of the bits.
    var registerName = ""
    var readWrite = ""
    let registerAccess = registerData(register).access
    let documentation = (optionalDocumentation.isEmpty == false) ? optionalDocumentation : registerData(register).documentation
    let variableName = (externalVariableName.isEmpty == false) ? externalVariableName : registerData(register).variableName
    var memberBlockList = MemberBlockItemListSyntax()
    var generateRegisterTableDoc = generateRegisterTable
    
    if register.size == .two {
        // get register and change size to 1 so uint8 registers are generated instead of 16 bit
        var customRegisterL: AVRModules.Module.RegisterGroup.Register = register
        customRegisterL.size = .one
        memberBlockList.append(
            contentsOf: generateRegister(
                register: customRegisterL,
                variableName: "\(registerData(register).variableName)L",
                optionalDocumentation: "\(registerData(register).documentationL ?? "")",
                registerData: registerData,
                bitfieldData: bitfieldData
            )
        )
        
        var customRegisterH: AVRModules.Module.RegisterGroup.Register = register
        customRegisterH.size = .one
        // I have no idea if this is ok, I'll just assume it is since it works
        customRegisterH.offset = .init(rawValue: (register.offset.rawValue.hexValue() + 1).toHex()) ?? .zeroX
        memberBlockList.append(
            contentsOf: generateRegister(
                register: customRegisterH,
                variableName: "\(registerData(register).variableName)H",
                optionalDocumentation: "\(registerData(register).documentationH ?? "")",
                registerData: registerData,
                bitfieldData: bitfieldData
            )
        )
        generateRegisterTableDoc = false
    }
    
    if register.bitfield.isEmpty {
        registerName = padString(register.name.rawValue, padding: 63)
        readWrite = padString(registerAccess, padding: 63)
    } else {
        var bitNames = getBitNames(from: register)
        bitNames = bitNames.map { padString($0, padding: 7) }
        registerName = "\(bitNames[7])|\(bitNames[6])|\(bitNames[5])|\(bitNames[4])|\(bitNames[3])|\(bitNames[2])|\(bitNames[1])|\(bitNames[0])"
        
        var bitAccess = getBitAccess(from: register, parentAccess: registerAccess, supplementalData: bitfieldData) // TODO: Check the register for it's access level
        bitAccess = bitAccess.map { padString($0, padding: 7) }
        readWrite = "\(bitAccess[7])|\(bitAccess[6])|\(bitAccess[5])|\(bitAccess[4])|\(bitAccess[3])|\(bitAccess[2])|\(bitAccess[1])|\(bitAccess[0])"
    }
    
    var bit: (size: String, atomicStart: String, atomicEnd: String) {
        switch register.size {
        case .one:
            return (size: "UInt8", atomicStart: "", atomicEnd: "")
        case .two:
            return (size: "UInt16", atomicStart: "atomic {", atomicEnd: " }")
        }
    }
    
    let table = """
      \n    ///```
          ///--------------------------------------------------------------------------------
          ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
          ///--------------------------------------------------------------------------------
          ///| (\(register.offset.rawValue))       |\(registerName)|
          ///--------------------------------------------------------------------------------
          ///| Read/Write   |\(readWrite)|
          ///--------------------------------------------------------------------------------
          ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
          ///--------------------------------------------------------------------------------
          ///```
      """
    
    let source = DeclSyntax(
      """
          /// \(raw: register.name) – \(raw: register.caption?.rawValue ?? variableName) \(raw: documentation) \(raw: generateRegisterTableDoc ? table : "")
          @inlinable
          @inline(__always)
          public static var \(raw: variableName): \(raw: bit.size) {
              get {
                  \(raw: bit.atomicStart)_volatileRegisterRead\(raw: bit.size)(\(raw: register.offset.rawValue))\(raw: bit.atomicEnd)
              }
              set {
                  \(raw: bit.atomicStart)_volatileRegisterWrite\(raw: bit.size)(\(raw: register.offset.rawValue), newValue)\(raw: bit.atomicEnd)
              }
          }
      """
    ).with(\.trailingTrivia, .newlines(2))
    
    memberBlockList.append(MemberBlockItemSyntax(decl: source))
    
    return memberBlockList
}

var bitfieldsToIgnore: [AVRModules.Module.RegisterGroup.Register.Bitfield] = []

func generateBitfieldAccessor(
    bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
    parentVariable: AVRModules.Module.RegisterGroup.Register,
    registerGroup: AVRModules.Module.RegisterGroup,
    timerInfo: TimerInfo? = nil,
    chipName: String,
    registerData: (_ register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData,
    bitfieldData: (_ bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData
) -> MemberBlockItemSyntax {
    
    // The bitfield that has a splitTarget is the bitfield with the MSB(high)
    if bitfieldData(bitfield).splitTarget != nil {
        let bitfieldA = bitfield
        let parentVariableA = parentVariable
        let parentVariableB = registerGroup.register.first(where: {$0.bitfield.contains(where: {$0.name.rawValue == bitfieldData(bitfield).splitTarget})})
        let bitfieldB = parentVariableB?.bitfield.first(where: {$0.name.rawValue == bitfieldData(bitfield).splitTarget!})
        bitfieldsToIgnore.append(bitfieldB!)
        return generateSplitBitfieldAccessor(bitfieldA: bitfieldA, bitfieldB: bitfieldB!, parentVariableA: parentVariableA, parentVariableB: parentVariableB!, timerInfo: timerInfo, chipName: chipName, bitfieldData: bitfieldData, registerData: registerData)
    }
    
    
    if bitfieldsToIgnore.contains(where: {$0.name == bitfield.name}) {
        return MemberBlockItemSyntax(decl: DeclSyntax(""))
    }
    
    let parentVariableName: String = registerData(parentVariable).variableName
    
    let caption = bitfield.caption?.rawValue ?? "" // .filter { $0 != " " } // TODO: Print some kind of error.
    let info = bitfieldData(bitfield)
    let bitmask = bitfield.mask.value.lowByte.binaryString
    let bitshift = UInt8(bitfield.mask.value.trailingZeroBitCount)
    let enumBitmask = (bitfield.mask.value.lowByte >> bitshift).binaryString
    
    var sourceForGet = """
      get {
                  let mode = (\(parentVariableName) & \(bitmask)) >> UInt8(\(bitshift))
                  return \(info.valueType).init(rawValue: mode) ?? \(info.defaultValue)
      }
      """
    
    var sourceForBoolGet = """
      get {
          let flag = (\(parentVariableName) & \(bitmask)) >> UInt8(\(bitshift))
          return flag == 1
      }
      """
    
    if bitfieldData(bitfield).access == .write {
        sourceForGet = ""
        sourceForBoolGet = ""
    }
    
    let source = DeclSyntax(
      """
          /// \(raw: bitfield.name) – \(raw: caption) \(raw: info.documentation)
          @inlinable
          @inline(__always)
          public static var \(raw: info.variableName): \(raw: info.valueType) {
              \(raw: sourceForGet)
              set {
                  \(raw: parentVariableName) |= (newValue.rawValue & \(raw: enumBitmask)) << UInt8(\(raw: bitshift))
              }
          }
      """
    )
    
    let sourceForBool = DeclSyntax(
      """
          /// \(raw: bitfield.name) – \(raw: caption) \(raw: info.documentation)
          @inlinable
          @inline(__always)
          public static var \(raw: info.variableName): \(raw: info.valueType) {\(raw: sourceForBoolGet)
      set {
      \(raw: parentVariableName) |= (newValue ? 1 : 0) & \(raw: enumBitmask) << UInt8(\(raw: bitshift))
      }
          }
      """
    )
    
    if info.valueType == "Bool" {
        return MemberBlockItemSyntax(decl: sourceForBool.with(\.trailingTrivia, .newlines(2)))
    } else {
        return MemberBlockItemSyntax(decl: source.with(\.trailingTrivia, .newlines(2)))
    }
}

func generateSplitBitfieldAccessor(
    bitfieldA: AVRModules.Module.RegisterGroup.Register.Bitfield,
    bitfieldB: AVRModules.Module.RegisterGroup.Register.Bitfield,
    parentVariableA: AVRModules.Module.RegisterGroup.Register,
    parentVariableB: AVRModules.Module.RegisterGroup.Register,
    timerInfo: TimerInfo?,
    chipName: String,
    bitfieldData: (_ bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData,
    registerData: (_ register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData
) -> MemberBlockItemSyntax {
    
    // TODO: Some chips only seem to have 1 bite for WGM. This breaks this logic and should be accounted for.
    
    // Example Data:
    // Register A Bitmask:           0b00000011
    // Register B Bitmask:           0b00001000
    // New Value Bitmask:            0b00000111
    // Register B New Value Bitmask: 0b00000100
    // Register B Bitshift should be: << 1 to get back to the "Register B Bitmask" location
    
    
    // The Below logic does not work for this second example
    
    // Another Example:
    // Register A Bitmask:           0b00000011
    // Register B Bitmask:           0b00000011
    // New Value Bitmask:            0b00001111
    // Register B New Value Bitmask: 0b00001100
    // Register B Bitshift should be: << 2 to get back to the "Register B Bitmask" location
    
    let caption = bitfieldA.caption?.rawValue ?? "" // .filter { $0 != " " } // TODO: Print some kind of error.
    let info = bitfieldData(bitfieldA)
    
    var lowBitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
    var lowParentVariableName: String
    var highBitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
    var hightParentVariableName: String
    
    // The LSBs of WMG should always be on TCCRnA and the MSBs should be on TCCRnB.
    
   
    highBitfield = bitfieldA
    hightParentVariableName = registerData(parentVariableB).variableName
    lowBitfield = bitfieldB
    lowParentVariableName = registerData(parentVariableA).variableName
    
    // Mask Value is 16 Bits and we have to have 8. Assuming that it's a total error to have a mask with bits above 8 we will just throw those away.
    let lowBitmask = lowBitfield.mask.value.lowByte.binaryString
    let highBitmask = highBitfield.mask.value.lowByte.binaryString
    
    
    
    
    // We then make sure that the byte is shifted all the way over to the Least Significant Bit because the value assigned will also be in the Least Significant Bits.
    let lowBitshift = UInt8(lowBitfield.mask.value.trailingZeroBitCount)
//    let highBitshift = UInt8(highBitfield.mask.value.trailingZeroBitCount)
    
    // Then turn all of this into a bianary string for legibility, a bitmask should be seen as bits and not an Int or Hex value.
    let newValueLowBitmask = (lowBitfield.mask.value.lowByte >> lowBitshift).binaryString
    
    print()
    print("-----------------------------------------------------------")
    print("Low Bitmask Value: \(lowBitfield.mask.value), Mask: \(lowBitmask), Shift: \(lowBitshift)")
//    print("high Bitmask Value: \(highBitfield.mask.value), Mask: \(highBitmask), Shift: \(highBitshift)")
//    print("adjustedHighBitshift = \(highBitshift) - \(UInt8(lowBitfield.mask.value.nonzeroBitCount))")
    print("-----------------------------------------------------------")
    print()
    
    // This would give me the number of bits to shift, assuming that there is only a single group of bits and not two or more groups split by one or more 0s.
    // The difference between the Bitfield Bitmask and the newValue Bitmask This should account for shifting in either direction.
    let adjustedHighBitshift = Int8(highBitfield.mask.value.trailingZeroBitCount) - Int8(lowBitfield.mask.value.nonzeroBitCount)
    let getShiftDirection: String = adjustedHighBitshift >= 0 ? ">>" : "<<"
    let setShiftDirection: String = adjustedHighBitshift >= 0 ? "<<" : ">>"
    
    
    // Make sure the high bitmask is shifted all the way to the right and then shift it back by the LSB. This should always put it in the correct position for the newValueHighBitmask
    let newValueHighBitmask = ((highBitfield.mask.value.lowByte >> highBitfield.mask.value.trailingZeroBitCount) << lowBitfield.mask.value.nonzeroBitCount).binaryString
    
    let source = DeclSyntax(
      """
          /// \(raw: bitfieldA.name) – \(raw: caption) \(raw: info.documentation)
          @inlinable
          @inline(__always)
          public static var \(raw: info.variableName): \(raw: (timerInfo?.timerProtocol != nil ? (timerInfo!.timerProtocol + ".") : ""))\(raw: info.valueType) {
              get {
                  let mode = ((\(raw: hightParentVariableName) & \(raw: highBitmask)) \(raw: getShiftDirection) \(raw: abs(adjustedHighBitshift))) | (\(raw: lowParentVariableName) & \(raw: lowBitmask))
                  return \(raw: (timerInfo?.timerProtocol != nil ? (timerInfo!.timerProtocol + ".") : ""))\(raw: info.valueType)(rawValue: mode) ?? \(raw: info.defaultValue)
              }
              set {
                  \(raw: lowParentVariableName) |= ((newValue.rawValue & \(raw: newValueLowBitmask)) << UInt8(\(raw: lowBitshift)))
                  \(raw: hightParentVariableName) |= ((newValue.rawValue & \(raw: newValueHighBitmask)) \(raw: setShiftDirection) UInt8(\(raw: abs(adjustedHighBitshift))))
              }
          }
      """
    )
    
    return MemberBlockItemSyntax(decl: source)
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

struct SupplementalRegisterData {
    let variableName: String
    let valueType: String
    let defaultValue: String
    let documentation: String
    let access: String
    var documentationL: String? = nil
    var documentationH: String? = nil
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
    var splitTarget: String? = nil
}
