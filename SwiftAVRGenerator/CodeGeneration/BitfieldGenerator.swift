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

/// Generates Swift property accessors for a bitfield within a register.
///
/// This function creates the getter and setter code for a specific bitfield,
/// wrapping the underlying register access with appropriate bit masking and shifting.
/// The generated code includes documentation from the `ChipDocumentationLoader`
/// when available, using the variable name and description from the chip's documentation.
///
/// - Parameters:
///   - bitfield: The bitfield definition from the ATDF file, containing the name,
///     caption, and bit position information.
///   - parentVariable: The register variable that contains this bitfield, used to
///     determine the register address and size.
///   - registerGroup: The register group containing the parent register, providing
///     context for the register's offset and address space.
///   - timerInfo: Additional timer-specific information when this bitfield is part
///     of a timer peripheral. May be nil for non-timer peripherals.
///   - chipName: The name of the target chip (e.g., "ATmega328P"), used for
///     chip-specific documentation references.
///   - registerData: Supplemental register data loaded from the chip documentation,
///     including variable names, access permissions, and documentation text.
///   - bitfieldData: Supplemental bitfield data loaded from the chip documentation,
///     including variable names, access permissions, and documentation text.
///
/// - Returns: A `MemberBlockItemSyntax` containing the generated Swift code for the bitfield
///   accessor, including property declarations with documentation comments.
///
/// - SeeAlso: `generateSplitBitfieldAccessor`
///
/// - Example Generated Code:
///   ```swift
///   /// When this bit is written to a logic one, the digital input buffer on the
///   /// corresponding ADC pin is disabled.
///   ///
///   public static var digitalInput5Disabled: Bool {
///       get { (controlRegisterA >> 5) & 1 }
///       set { controlRegisterA = (controlRegisterA & ~(1 << 5)) | (newValue ? 1 << 5 : 0) }
///   }
///   ```
func generateBitfieldAccessor(
    bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
    parentVariable: AVRModules.Module.RegisterGroup.Register,
    registerGroup: AVRModules.Module.RegisterGroup,
    chipName: String,
    registerData: (_ register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData,
    bitfieldData: (_ bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData
) -> MemberBlockItemSyntax {
    
    if bitfieldsToIgnore.contains(where: {$0.name == bitfield.name}) {
        return MemberBlockItemSyntax(decl: DeclSyntax(""))
    }
    
    // The bitfield that has a splitTarget is the bitfield with the MSB(high)
    if bitfieldData(bitfield).splitTarget != nil {
        let bitfieldA = bitfield
        let parentVariableA = parentVariable
        let parentVariableB = registerGroup.register.first(where: {$0.bitfield.contains(where: {$0.name.rawValue == bitfieldData(bitfield).splitTarget})})
        let bitfieldB = parentVariableB?.bitfield.first(where: {$0.name.rawValue == bitfieldData(bitfield).splitTarget!})
        let output = generateSplitBitfieldAccessor(
            bitfieldA: bitfieldA,
            bitfieldB: bitfieldB!,
            parentVariableA: parentVariableA,
            parentVariableB: parentVariableB!,
            chipName: chipName,
            bitfieldData: bitfieldData,
            registerData: registerData)
        // Edge case when 2 split bitfields have the same name.
        // The split bitfield would otherwise be generated twice,
        // Once wrong (using the same register twice)
        // And once correctly
        if output.description != "" {
            bitfieldsToIgnore.append(bitfieldB!)
        }
        return output
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
    
    let documentationFromJson = """
      \n    /// \(info.documentation)
      """
    
    let source = DeclSyntax(
      """
          /// \(raw: bitfield.name) – \(raw: caption) \(raw: info.documentation != "" ? documentationFromJson : "")
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
          /// \(raw: bitfield.name) – \(raw: caption) \(raw: info.documentation != "" ? documentationFromJson : "")
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

/// Generates accessor code for a bitfield that is split across two different registers.
///
/// This function handles the complex case where a single logical bitfield spans multiple
/// hardware registers, requiring special logic to read and write the combined value.
///
/// - Parameters:
///   - bitfieldA: The first bitfield component (typically the MSB/high bits).
///   - bitfieldB: The second bitfield component (typically the LSB/low bits).
///   - parentVariableA: The register containing bitfieldA.
///   - parentVariableB: The register containing bitfieldB.
///   - timerInfo: Optional timer-specific information for protocol type prefixes.
///   - chipName: The name of the target chip for context.
///   - bitfieldData: Closure to retrieve supplemental bitfield metadata.
///   - registerData: Closure to retrieve supplemental register metadata.
/// - Returns: A `MemberBlockItemSyntax` containing the generated accessor declaration
///   for the split bitfield, or an empty declaration if edge cases prevent generation.
///
/// - Note: This function calculates appropriate bitmasks and shifts to combine the
///   two register values when reading, and properly distributes the value back to
///   each register when writing.
func generateSplitBitfieldAccessor(
    bitfieldA: AVRModules.Module.RegisterGroup.Register.Bitfield,
    bitfieldB: AVRModules.Module.RegisterGroup.Register.Bitfield,
    parentVariableA: AVRModules.Module.RegisterGroup.Register,
    parentVariableB: AVRModules.Module.RegisterGroup.Register,
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
    
    // Edge case for 2 splitbitfields with the same name
    if parentVariableA.name == parentVariableB.name {
        return MemberBlockItemSyntax(decl: DeclSyntax(""))
    }
    
    let caption = bitfieldA.caption?.rawValue ?? "" // .filter { $0 != " " } // TODO: Print some kind of error.
    let info = bitfieldData(bitfieldA)
    
    var lowBitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
    var lowParentVariableName: String
    var highBitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
    var hightParentVariableName: String
    
    highBitfield = bitfieldA
    hightParentVariableName = registerData(parentVariableA).variableName
    lowBitfield = bitfieldB
    lowParentVariableName = registerData(parentVariableB).variableName
    
    // Mask Value is 16 Bits and we have to have 8. Assuming that it's a total error to have a mask with bits above 8 we will just throw those away.
    let lowBitmask = lowBitfield.mask.value.lowByte.binaryString
    let highBitmask = highBitfield.mask.value.lowByte.binaryString
    
    // We then make sure that the byte is shifted all the way over to the Least Significant Bit because the value assigned will also be in the Least Significant Bits.
    let lowBitshift = UInt8(lowBitfield.mask.value.trailingZeroBitCount)
    //let highBitshift = UInt8(highBitfield.mask.value.trailingZeroBitCount)
    
    // Then turn all of this into a bianary string for legibility, a bitmask should be seen as bits and not an Int or Hex value.
    let newValueLowBitmask = (lowBitfield.mask.value.lowByte >> lowBitshift).binaryString
    
    // This would give me the number of bits to shift, assuming that there is only a single group of bits and not two or more groups split by one or more 0s.
    // The difference between the Bitfield Bitmask and the newValue Bitmask This should account for shifting in either direction.
    let adjustedHighBitshift = Int8(highBitfield.mask.value.trailingZeroBitCount) - Int8(lowBitfield.mask.value.nonzeroBitCount)
    let getShiftDirection: String = adjustedHighBitshift >= 0 ? ">>" : "<<"
    let setShiftDirection: String = adjustedHighBitshift >= 0 ? "<<" : ">>"
    
    // Make sure the high bitmask is shifted all the way to the right and then shift it back by the LSB. This should always put it in the correct position for the newValueHighBitmask
    let newValueHighBitmask = ((highBitfield.mask.value.lowByte >> highBitfield.mask.value.trailingZeroBitCount) << lowBitfield.mask.value.nonzeroBitCount).binaryString
    
    let documentationFromJson = """
      \n    /// \(info.documentation)
      """
    
    let source = DeclSyntax(
      """
          /// \(raw: bitfieldA.name) – \(raw: caption) \(raw: info.documentation != "" ? documentationFromJson : "")
          @inlinable
          @inline(__always)
          public static var \(raw: info.variableName): \(raw: info.valueType) {
              get {
                  let mode = ((\(raw: hightParentVariableName) & \(raw: highBitmask)) \(raw: getShiftDirection) \(raw: abs(adjustedHighBitshift))) | (\(raw: lowParentVariableName) & \(raw: lowBitmask))
                  return \(raw: info.valueType)(rawValue: mode) ?? \(raw: info.defaultValue)
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
