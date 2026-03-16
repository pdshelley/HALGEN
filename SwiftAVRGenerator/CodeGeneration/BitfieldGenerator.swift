//
//  BitfieldGenerator.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 26/02/2026.
//

import SwiftSyntax
import SwiftSyntaxBuilder

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
///     context for split bitfield lookup.
///   - registerData: Supplemental register data loaded from the chip documentation,
///     including variable names, access permissions, and documentation text.
///   - bitfieldData: Supplemental bitfield data loaded from the chip documentation,
///     including variable names, access permissions, and documentation text.
/// - Returns: A generated member declaration for the bitfield, or `nil` when the
///   current bitfield is only the secondary half of a split accessor.
func generateBitfieldAccessor(
    bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
    parentVariable: AVRModules.Module.RegisterGroup.Register,
    registerGroup: AVRModules.Module.RegisterGroup,
    registerData: (_ register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData,
    bitfieldData: (_ bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData
) -> MemberBlockItemSyntax? {
    let info = bitfieldData(bitfield)

    if shouldSkipBitfieldAccessor(
        for: bitfield,
        parentVariable: parentVariable,
        in: registerGroup,
        bitfieldData: bitfieldData
    ) {
        return nil
    }

    if let splitTarget = info.splitTarget {
        guard let splitPair = resolveSplitBitfieldPair(
            splitTarget: splitTarget,
            in: registerGroup
        ) else {
            return nil
        }

        if parentVariable.name == splitPair.register.name {
            return nil
        }
        
        return generateSplitBitfieldAccessor(
            bitfieldA: bitfield,
            bitfieldB: splitPair.bitfield,
            parentVariableA: parentVariable,
            parentVariableB: splitPair.register,
            bitfieldData: bitfieldData,
            registerData: registerData
        )
    }

    let parentVariableName = registerData(parentVariable).variableName
    let caption = bitfield.caption ?? ""
    let registerMask = bitfield.mask.value.lowByte
    let bitshift = UInt8(bitfield.mask.value.trailingZeroBitCount)
    let valueMask = registerMask >> bitshift

    let getter = accessorGetterSource(
        info: info,
        parentVariableName: parentVariableName,
        registerMask: registerMask,
        bitshift: bitshift
    )
    let setter = accessorSetterSource(
        info: info,
        parentVariableName: parentVariableName,
        valueMask: valueMask,
        bitshift: bitshift
    )

    let source = makeAccessorDeclaration(
        bitfieldName: bitfield.name,
        caption: caption,
        info: info,
        getter: getter,
        setter: setter
    )

    return MemberBlockItemSyntax(decl: source.with(\.trailingTrivia, .newlines(2)))
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
///   - bitfieldData: Closure to retrieve supplemental bitfield metadata.
///   - registerData: Closure to retrieve supplemental register metadata.
/// - Returns: A `MemberBlockItemSyntax` containing the generated accessor declaration
///   for the split bitfield.
func generateSplitBitfieldAccessor(
    bitfieldA: AVRModules.Module.RegisterGroup.Register.Bitfield,
    bitfieldB: AVRModules.Module.RegisterGroup.Register.Bitfield,
    parentVariableA: AVRModules.Module.RegisterGroup.Register,
    parentVariableB: AVRModules.Module.RegisterGroup.Register,
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

    let caption = bitfieldA.caption ?? ""
    let info = bitfieldData(bitfieldA)

    let highBitfield = bitfieldA
    let highParentVariableName = registerData(parentVariableA).variableName
    let lowBitfield = bitfieldB
    let lowParentVariableName = registerData(parentVariableB).variableName

    // Mask Value is 16 Bits and we have to have 8. Assuming that it's a total error to have a mask with bits above 8 we will just throw those away.
    let lowBitmask = lowBitfield.mask.value.lowByte
    let highBitmask = highBitfield.mask.value.lowByte

    // We then make sure that the byte is shifted all the way over to the Least Significant Bit because the value assigned will also be in the Least Significant Bits.
    let lowBitshift = UInt8(lowBitfield.mask.value.trailingZeroBitCount)

    // Then turn all of this into a binary string for legibility, a bitmask should be seen as bits and not an Int or Hex value.
    let newValueLowBitmask = lowBitmask >> lowBitshift

    // This would give me the number of bits to shift, assuming that there is only a single group of bits and not two or more groups split by one or more 0s.
    // The difference between the Bitfield Bitmask and the newValue Bitmask This should account for shifting in either direction.
    let adjustedHighBitshift = Int8(highBitfield.mask.value.trailingZeroBitCount) - Int8(lowBitfield.mask.value.nonzeroBitCount)
    let getShiftDirection = adjustedHighBitshift >= 0 ? ">>" : "<<"
    // Make sure the high bitmask is shifted all the way to the right and then shift it back by the LSB. This should always put it in the correct position for the newValueHighBitmask
    let newValueHighBitmask = (highBitmask >> highBitfield.mask.value.trailingZeroBitCount) << lowBitfield.mask.value.nonzeroBitCount

    let getter = splitAccessorGetterSource(
        info: info,
        highParentVariableName: highParentVariableName,
        highBitmask: highBitmask,
        getShiftDirection: getShiftDirection,
        adjustedHighBitshift: adjustedHighBitshift,
        lowParentVariableName: lowParentVariableName,
        lowBitmask: lowBitmask
    )
    let setter = splitAccessorSetterSource(
        lowParentVariableName: lowParentVariableName,
        lowBitmask: lowBitmask,
        newValueLowBitmask: newValueLowBitmask,
        lowBitshift: lowBitshift,
        highParentVariableName: highParentVariableName,
        highBitmask: highBitmask,
        newValueHighBitmask: newValueHighBitmask,
        adjustedHighBitshift: adjustedHighBitshift
    )

    let source = makeAccessorDeclaration(
        bitfieldName: bitfieldA.name,
        caption: caption,
        info: info,
        getter: getter,
        setter: setter
    )

    return MemberBlockItemSyntax(decl: source)
}

/// Determines whether a bitfield accessor should be skipped during code generation.
///
/// This function evaluates whether a given bitfield needs its own accessor or should be
/// handled as part of a split bitfield pair across multiple registers. It returns `true`
/// when the bitfield is the secondary component of a split accessor (meaning the primary
/// bitfield will handle access to this combined value), and `false` when the bitfield
/// should have its own accessor declaration.
///
/// - Parameters:
///   - bitfield: The bitfield definition from the ATDF file that is being evaluated
///     for accessor generation.
///   - parentVariable: The register variable that contains this bitfield, providing
///     context for the bitfield's location within the register hierarchy.
///   - registerGroup: The register group containing the parent register, used to
///     search for other registers that may reference this bitfield as a split target.
///   - bitfieldData: A closure that retrieves supplemental bitfield metadata,
///     including the `splitTarget` property that indicates if this bitfield is
///     part of a split accessor configuration.
/// - Returns: `true` if the bitfield should be skipped (it's the secondary half of a
///   split accessor), `false` if a standalone accessor should be generated.
///
/// - Complexity: O(n) where n is the number of registers in the register group,
///   as it iterates through all registers to check for split target relationships.
///
/// - SeeAlso: `generateBitfieldAccessor`, `resolveSplitBitfieldPair`, `generateSplitBitfieldAccessor`
private func shouldSkipBitfieldAccessor(
    for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
    parentVariable: AVRModules.Module.RegisterGroup.Register,
    in registerGroup: AVRModules.Module.RegisterGroup,
    bitfieldData: (_ bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield) -> SupplementalBitfieldData
) -> Bool {
    if bitfieldData(bitfield).splitTarget != nil {
        return false
    }

    for register in registerGroup.register where register.name != parentVariable.name {
        if register.bitfield.contains(where: { bitfieldData($0).splitTarget == bitfield.name }) {
            return true
        }
    }

    return false
}

/// Searches a register group to find the corresponding bitfield pair for a split bitfield accessor.
///
/// When a bitfield is split across multiple registers, this function locates the register
/// and bitfield that completes the pair by searching for the split target name within
/// the provided register group.
///
/// - Parameters:
///   - splitTarget: The name of the bitfield that completes the split pair.
///   - registerGroup: The register group to search within for the matching bitfield.
/// - Returns: A tuple containing the register and bitfield that complete the split pair,
///   or `nil` if no matching bitfield is found in the register group.
private func resolveSplitBitfieldPair(
    splitTarget: String,
    in registerGroup: AVRModules.Module.RegisterGroup
) -> (
    register: AVRModules.Module.RegisterGroup.Register,
    bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
)? {
    for register in registerGroup.register {
        if let bitfield = register.bitfield.first(where: { $0.name == splitTarget }) {
            return (register, bitfield)
        }
    }

    return nil
}

private func makeAccessorDeclaration(
    bitfieldName: String,
    caption: String,
    info: SupplementalBitfieldData,
    getter: String?,
    setter: String?
) -> DeclSyntax {
    let documentationComment = makeDocumentationComment(
        bitfieldName: bitfieldName,
        caption: caption,
        documentation: info.documentation
    )

    var declarationLines = [
        documentationComment,
        "@inlinable",
        "@inline(__always)",
        "public static var \(info.variableName): \(info.valueType) {"
    ]

    if let getter {
        declarationLines.append(indent(getter, by: 4))
    }
    
    if let setter {
        declarationLines.append(indent(setter, by: 4))
    }

    declarationLines.append("}")

    let declaration = declarationLines.joined(separator: "\n")

    return DeclSyntax("\(raw: declaration)")
}

/// Creates a formatted documentation comment string for a bitfield accessor.
///
/// This helper function generates the Swift documentation comment that precedes
/// a generated bitfield property accessor. It formats the bitfield name and
/// caption on the first line, followed by any additional documentation text
/// from the chip's documentation data.
///
/// - Parameters:
///   - bitfieldName: The name of the bitfield as defined in the chip's ATDF file.
///   - caption: A short human-readable description or caption for the bitfield.
///   - documentation: Extended documentation text from the chip documentation,
///     or an empty string if no additional documentation is available.
/// - Returns: A formatted documentation comment string with `///` prefixes,
///   suitable for use in generated Swift source code.
///
/// - Example:
///   ```
///   /// USIDR - USI Data Register
///   ///
///   /// Contains the data byte for the USI shift register.
///   ///
///   @inlinable
///   @inline(__always)
///   public static var USIDR: UInt8 { ... }
///   ```
private func makeDocumentationComment(
    bitfieldName: String,
    caption: String,
    documentation: String
) -> String {
    makeDocumentationComment(
        title: "\(bitfieldName) - \(caption)",
        body: documentation
    )
}

/// Generates the getter source code for a bitfield property accessor.
///
/// This function creates the Swift source code for reading a bitfield value from
/// a hardware register. It generates code that applies a bitmask and shifts the
/// register value to extract the specific bitfield bits.
///
/// The generated getter handles two cases:
/// - Boolean bitfields: Returns `true` or `false` based on whether the extracted
///   bit equals 1.
/// - Enum bitfields: Returns an enum value with a raw value type, or the
///   default value if the raw value is invalid.
///
/// - Parameters:
///   - info: The bitfield metadata containing access permissions, value type,
///     and default value information.
///   - parentVariableName: The name of the parent register variable to read from.
///   - registerMask: The bitmask to extract the bitfield bits from the register.
///   - bitshift: The number of bit positions to shift the extracted value.
/// - Returns: A string containing the generated getter code.
///
/// - SeeAlso: `accessorSetterSource`, `makeAccessorDeclaration`
private func accessorGetterSource(
    info: SupplementalBitfieldData,
    parentVariableName: String,
    registerMask: UInt8,
    bitshift: UInt8
) -> String? {
    if info.valueType == "Bool" {
        return """
        get {
            let flag = (\(parentVariableName) & \(registerMask.binaryString)) >> UInt8(\(bitshift))
            return flag == 1
        }
        """
    }

    return """
    get {
        let mode = (\(parentVariableName) & \(registerMask.binaryString)) >> UInt8(\(bitshift))
        return \(info.valueType).init(rawValue: mode) ?? \(info.defaultValue)
    }
    """
}

/// Generates the setter code for a single-bitfield accessor property.
///
/// This function creates the Swift code that handles setting a value for a bitfield
/// within a register. It generates code that masks and shifts the new value before
/// applying it to the underlying register variable. The setter logic differs based
/// on whether the value type is `Bool` or an enum type.
///
/// - Parameters:
///   - info: The supplemental bitfield metadata, containing the value type,
///     access permissions, and default value for the bitfield.
///   - parentVariableName: The name of the register variable that contains
///     this bitfield, used as the target for the write operation.
///   - valueMask: The bitmask that isolates the bits belonging to this
///     bitfield within a byte, used to prevent writing to adjacent bits.
///   - bitshift: The number of bit positions to shift the value to align
///     it with the bitfield's position in the register.
/// - Returns: A string containing the Swift code for the setter, including
///   the `set` keyword and the logic to apply the new value to the register.
///
/// - Complexity: O(1) as it performs a fixed amount of string interpolation.
///
/// - SeeAlso: `accessorGetterSource`, `makeAccessorDeclaration`, `generateBitfieldAccessor`
private func accessorSetterSource(
    info: SupplementalBitfieldData,
    parentVariableName: String,
    valueMask: UInt8,
    bitshift: UInt8
) -> String? {
    let assignedValue: String
    if info.valueType == "Bool" {
        assignedValue = "(newValue ? 1 : 0)"
    } else {
        assignedValue = "newValue.rawValue"
    }
    
    if info.access == .read {
        return nil
    } else {
        return """
        set {
            \(parentVariableName) |= (\(assignedValue) & \(valueMask.binaryString)) << UInt8(\(bitshift))
        }
        """
    }
}

private func splitAccessorGetterSource(
    info: SupplementalBitfieldData,
    highParentVariableName: String,
    highBitmask: UInt8,
    getShiftDirection: String,
    adjustedHighBitshift: Int8,
    lowParentVariableName: String,
    lowBitmask: UInt8
) -> String {
    """
    get {
        let mode = ((\(highParentVariableName) & \(highBitmask.binaryString)) \(getShiftDirection) \(abs(adjustedHighBitshift))) | (\(lowParentVariableName) & \(lowBitmask.binaryString))
        return \(info.valueType)(rawValue: mode) ?? \(info.defaultValue)
    }
    """
}

private func splitAccessorSetterSource(
    lowParentVariableName: String,
    lowBitmask: UInt8,
    newValueLowBitmask: UInt8,
    lowBitshift: UInt8,
    highParentVariableName: String,
    highBitmask: UInt8,
    newValueHighBitmask: UInt8,
    adjustedHighBitshift: Int8
) -> String {
    let highValueExpression: String

    if adjustedHighBitshift >= 0 {
        highValueExpression = "(((newValue.rawValue & \(newValueHighBitmask.binaryString)) << UInt8(\(adjustedHighBitshift))) & \(highBitmask.binaryString))"
    } else {
        highValueExpression = "(((newValue.rawValue & \(newValueHighBitmask.binaryString)) >> UInt8(\(abs(adjustedHighBitshift)))) & \(highBitmask.binaryString))"
    }

    return """
    set {
        \(lowParentVariableName) = (\(lowParentVariableName) & ~\(lowBitmask.binaryString)) | (((newValue.rawValue & \(newValueLowBitmask.binaryString)) << UInt8(\(lowBitshift))) & \(lowBitmask.binaryString))
        \(highParentVariableName) = (\(highParentVariableName) & ~\(highBitmask.binaryString)) | \(highValueExpression)
    }
    """
}
