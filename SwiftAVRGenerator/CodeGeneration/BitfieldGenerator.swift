//
//  BitfieldGenerator.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 26/02/2026.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

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
