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

    if let splitTargetLSB = info.splitTargetLSB {
        guard let splitPair = resolveSplitBitfieldPair(
            splitTargetLSB: splitTargetLSB,
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
    let variableName = disambiguatedBitfieldVariableName(
        baseName: info.variableName,
        bitfield: bitfield,
        in: registerGroup
    )
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
        registerMask: registerMask,
        valueMask: valueMask,
        bitshift: bitshift
    )

    let source = makeAccessorDeclaration(
        bitfieldName: bitfield.name,
        caption: caption,
        info: info,
        variableName: variableName,
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
    let caption = bitfieldA.caption ?? ""
    let info = bitfieldData(bitfieldA)

    let fragmentA = makeSplitBitfieldFragment(
        bitfield: bitfieldA,
        parentVariable: parentVariableA,
        pairedBitfield: bitfieldB,
        registerData: registerData
    )
    let fragmentB = makeSplitBitfieldFragment(
        bitfield: bitfieldB,
        parentVariable: parentVariableB,
        pairedBitfield: bitfieldA,
        registerData: registerData
    )

    let highFragment: SplitBitfieldFragment
    let lowFragment: SplitBitfieldFragment

    if fragmentA.semanticBitshift >= fragmentB.semanticBitshift {
        highFragment = fragmentA
        lowFragment = fragmentB
    } else {
        highFragment = fragmentB
        lowFragment = fragmentA
    }

    let getter = splitAccessorGetterSource(
        info: info,
        highFragment: highFragment,
        lowFragment: lowFragment
    )
    let setter = info.access == .read ? nil : splitAccessorSetterSource(info: info, highFragment: highFragment, lowFragment: lowFragment)

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
///     including the `splitTargetLSB` property that indicates if this bitfield is
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
    if bitfieldData(bitfield).splitTargetLSB != nil {
        return false
    }

    for register in registerGroup.register where register.name != parentVariable.name {
        if register.bitfield.contains(where: { bitfieldData($0).splitTargetLSB == bitfield.name }) {
            return true
        }
    }

    return false
}

private func disambiguatedBitfieldVariableName(
    baseName: String,
    bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
    in registerGroup: AVRModules.Module.RegisterGroup
) -> String {
    let matchingBitfieldCount = registerGroup.register.reduce(0) { count, register in
        count + register.bitfield.filter { $0.name == bitfield.name }.count
    }

    guard matchingBitfieldCount > 1 else {
        return baseName
    }

    return "\(baseName)\(bitfield.lsb ?? 0)"
}

/// Searches a register group to find the corresponding bitfield pair for a split bitfield accessor.
///
/// When a bitfield is split across multiple registers, this function locates the register
/// and bitfield that completes the pair by searching for the split target name within
/// the provided register group.
///
/// - Parameters:
///   - splitTargetLSB: The name of the bitfield that completes the split pair.
///   - registerGroup: The register group to search within for the matching bitfield.
/// - Returns: A tuple containing the register and bitfield that complete the split pair,
///   or `nil` if no matching bitfield is found in the register group.
private func resolveSplitBitfieldPair(
    splitTargetLSB: String,
    in registerGroup: AVRModules.Module.RegisterGroup
) -> (
    register: AVRModules.Module.RegisterGroup.Register,
    bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
)? {
    for register in registerGroup.register {
        if let bitfield = register.bitfield.first(where: { $0.name == splitTargetLSB }) {
            return (register, bitfield)
        }
    }

    return nil
}

private func makeAccessorDeclaration(
    bitfieldName: String,
    caption: String,
    info: SupplementalBitfieldData,
    variableName: String? = nil,
    getter: String?,
    setter: String?
) -> DeclSyntax {
    let documentationComment = makeDocumentationComment(
        bitfieldName: bitfieldName,
        caption: caption,
        documentation: info.documentation,
        overrideGeneratedDocumentation: info.overrideGeneratedDocumentation
    )

    var declarationLines: [String] = []
    if documentationComment.isEmpty == false {
        declarationLines.append(documentationComment)
    }

    declarationLines.append(contentsOf: [
        "@inlinable",
        "@inline(\(info.inline))",
        "public static var \(variableName ?? info.variableName): \(info.valueType) {"
    ])

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
    documentation: String,
    overrideGeneratedDocumentation: Bool
) -> String {
    if overrideGeneratedDocumentation {
        return makeDocumentationComment(body: documentation)
    }

    return makeDocumentationComment(
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

    if info.valueType == "UInt8" && info.defaultValue.isEmpty {
        return """
        get {
            (\(parentVariableName) & \(registerMask.binaryString)) >> UInt8(\(bitshift))
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
    registerMask: UInt8,
    valueMask: UInt8,
    bitshift: UInt8
) -> String? {
    let assignedValue: String
    if info.valueType == "Bool" {
        assignedValue = "(newValue ? 1 : 0)"
    } else if info.valueType == "UInt8" && info.defaultValue.isEmpty {
        assignedValue = "newValue"
    } else {
        assignedValue = "newValue.rawValue"
    }
    
    if info.access == .read {
        return nil
    } else {
        let shiftedValue: String
        if bitshift == 0 {
            shiftedValue = "(\(assignedValue) & \(valueMask.binaryString))"
        } else {
            shiftedValue = "((\(assignedValue) & \(valueMask.binaryString)) << UInt8(\(bitshift)))"
        }

        return """
        set {
            \(parentVariableName) = (\(parentVariableName) & ~\(registerMask.binaryString)) | \(shiftedValue)
        }
        """
    }
}

private struct SplitBitfieldFragment {
    let parentVariableName: String
    let registerMask: UInt8
    let registerBitshift: UInt8
    let valueMask: UInt8
    let semanticBitshift: UInt8
}

private func makeSplitBitfieldFragment(
    bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
    parentVariable: AVRModules.Module.RegisterGroup.Register,
    pairedBitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
    registerData: (_ register: AVRModules.Module.RegisterGroup.Register) -> SupplementalRegisterData
) -> SplitBitfieldFragment {
    let registerMask = bitfield.mask.value.lowByte
    let registerBitshift = UInt8(bitfield.mask.value.trailingZeroBitCount)
    let valueMask = registerMask >> registerBitshift
    let semanticBitshift = UInt8(resolveSplitSemanticBitshift(for: bitfield, pairedWith: pairedBitfield))

    return SplitBitfieldFragment(
        parentVariableName: registerData(parentVariable).variableName,
        registerMask: registerMask,
        registerBitshift: registerBitshift,
        valueMask: valueMask,
        semanticBitshift: semanticBitshift
    )
}

private func resolveSplitSemanticBitshift(
    for bitfield: AVRModules.Module.RegisterGroup.Register.Bitfield,
    pairedWith pairedBitfield: AVRModules.Module.RegisterGroup.Register.Bitfield
) -> Int {
    if let lsb = bitfield.lsb {
        return lsb
    }

    if let pairedLSB = pairedBitfield.lsb {
        return pairedLSB == 0 ? pairedBitfield.mask.value.nonzeroBitCount : 0
    }

    let bitfieldWidth = bitfield.mask.value.nonzeroBitCount
    let pairedWidth = pairedBitfield.mask.value.nonzeroBitCount

    if bitfieldWidth != pairedWidth {
        return bitfieldWidth > pairedWidth ? 0 : pairedWidth
    }

    let bitfieldRegisterBitshift = bitfield.mask.value.trailingZeroBitCount
    let pairedRegisterBitshift = pairedBitfield.mask.value.trailingZeroBitCount
    return bitfieldRegisterBitshift < pairedRegisterBitshift ? 0 : pairedWidth
}

private func splitAccessorGetterSource(
    info: SupplementalBitfieldData,
    highFragment: SplitBitfieldFragment,
    lowFragment: SplitBitfieldFragment
) -> String {
    if info.valueType == "UInt8" && info.defaultValue.isEmpty {
        return """
        get {
            \(splitAccessorGetterExpression(for: highFragment)) | \(splitAccessorGetterExpression(for: lowFragment))
        }
        """
    }

    return """
    get {
        let mode = \(splitAccessorGetterExpression(for: highFragment)) | \(splitAccessorGetterExpression(for: lowFragment))
        return \(info.valueType)(rawValue: mode) ?? \(info.defaultValue)
    }
    """
}

private func splitAccessorSetterSource(
    info: SupplementalBitfieldData,
    highFragment: SplitBitfieldFragment,
    lowFragment: SplitBitfieldFragment
) -> String {
    return """
    set {
        \(lowFragment.parentVariableName) = (\(lowFragment.parentVariableName) & ~\(lowFragment.registerMask.binaryString)) | \(splitAccessorSetterExpression(for: lowFragment, isRawValue: info.valueType != "UInt8" || !info.defaultValue.isEmpty))
        \(highFragment.parentVariableName) = (\(highFragment.parentVariableName) & ~\(highFragment.registerMask.binaryString)) | \(splitAccessorSetterExpression(for: highFragment, isRawValue: info.valueType != "UInt8" || !info.defaultValue.isEmpty))
    }
    """
}

private func splitAccessorGetterExpression(for fragment: SplitBitfieldFragment) -> String {
    let maskedRegister = "\(fragment.parentVariableName) & \(fragment.registerMask.binaryString)"
    let shiftDelta = Int(fragment.registerBitshift) - Int(fragment.semanticBitshift)

    if shiftDelta == 0 {
        return "(\(maskedRegister))"
    }

    if shiftDelta > 0 {
        return "((\(maskedRegister)) >> UInt8(\(shiftDelta)))"
    }

    return "((\(maskedRegister)) << UInt8(\(-shiftDelta)))"
}

private func splitAccessorSetterExpression(for fragment: SplitBitfieldFragment, isRawValue: Bool) -> String {
    let rawValueMask = fragment.valueMask << fragment.semanticBitshift
    let shiftDelta = Int(fragment.registerBitshift) - Int(fragment.semanticBitshift)
    let valueAccessor = isRawValue ? "newValue.rawValue" : "newValue"

    if shiftDelta == 0 {
        if fragment.valueMask == 1 && fragment.semanticBitshift > 0 {
            return "((\(valueAccessor) << UInt8(\(fragment.semanticBitshift))) & \(fragment.registerMask.binaryString))"
        }

        return "(\(valueAccessor) & \(rawValueMask.binaryString))"
    }

    if shiftDelta > 0 {
        return "((\(valueAccessor) & \(rawValueMask.binaryString)) << UInt8(\(shiftDelta)))"
    }

    return "((\(valueAccessor) & \(rawValueMask.binaryString)) >> UInt8(\(-shiftDelta)))"
}
