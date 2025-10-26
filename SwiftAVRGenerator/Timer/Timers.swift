//
//  Timers.swift
//  SwiftAVRGenerator
//
//  Created by Paul Shelley on 7/6/23.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

func buildTimers(file: AVRToolsDeviceFile) -> [GeneratedCodeFile] { // TODO: This should probably return a "File" as there can be many different timers.
//    let fileName = "Timer0.swift" // TODO
//    var code: String = ""
    var timerFiles: [GeneratedCodeFile] = []
    
    // Filter for Modules named "PORT" // TODO: Find a better way to filter.
    for module in file.modules.module {
        for registerGroup in module.registerGroup {
            switch registerGroup.name {
            case .TC0:
                timerFiles.append(buildTimer(module: module, timerName: "Timer0"))
            case .TC1:
                timerFiles.append(buildTimer(module: module, timerName: "Timer1"))
            case .TC2:
                timerFiles.append(buildTimer(module: module, timerName: "Timer2"))
            case .TC3:
                timerFiles.append(buildTimer(module: module, timerName: "Timer3"))
            case .TC4:
                timerFiles.append(buildTimer(module: module, timerName: "Timer4"))
            case .TC5:
                timerFiles.append(buildTimer(module: module, timerName: "Timer5")) // TODO: Are there timers A and B? What does TCA stand for?
            default:
                break
            }
        }
    }
    
    return timerFiles
}


func buildProtocolDeclarationsFrom(module: AVRModules.Module) -> String {
    var hasProtocols: [String] = []
    
    // The name of the module indicates if it is 8 or 16 bit as well as if it is Async.
    // TODO: Check to see if any 16 bit timers have
    switch module.name {
    case .tc8Async:
        hasProtocols.append("Timer8Bit")
        hasProtocols.append("AsyncTimer")
    case .tc8:
        hasProtocols.append("Timer8Bit")
    case .tc10:
        hasProtocols.append("Timer10Bit")
    case .tc16:
        hasProtocols.append("Timer16Bit")
    default: ()
    }
    
    // To check for an external clock you need to check each register and each bitfiled to see if there is a bitfiled with a name of "EXCLK"
    // Module -> Register Group -> [Register] -> [Bitfield] -> EXCLK
    for registerGroup in module.registerGroup {
        var externalClock = "HasExternalClock"
        for register in registerGroup.register {
            for bitfield in register.bitfield {
                if bitfield.name == .EXCLK { // TODO: This name seems to indicate an external clock but from our example code we have the opposite, where this would indicate it has an internal clock only. Check this and figure out what is going on.
                    externalClock = "InternalClockOnly"
                }
            }
        }
        hasProtocols.append(externalClock)
    }
    
    return hasProtocols.isEmpty ? "" : " \(hasProtocols.joined(separator: ", ")) "
}

func buildFileHeaderFor(fileName: String) -> String {
    let fullFormatter = DateFormatter()
    fullFormatter.dateFormat = "MM/dd/yyyy"
    let fullDateString = fullFormatter.string(from: Date())
    
    let yearFormatter = DateFormatter()
    yearFormatter.dateFormat = "yyyy"
    let yearString = yearFormatter.string(from: Date())
    
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
    
    
    public typealias \(fileName.lowercased()) = \(fileName) 
    
    
    """
    // TODO: The typealias should be generated in a different location.
    return fileHeader
}

func buildTimer(module: AVRModules.Module, timerName: String) -> GeneratedCodeFile {
    let fileName = "\(timerName).swift"
    var code: String = buildFileHeaderFor(fileName: timerName)
    
    let bitSize: String = {
        switch module.name {
        case .tc8, .tc8Async:
            return "UInt8"
        case .tc10, .tc16:
            return "UInt16"
        default:
            assertionFailure("Failed to find bit size.")
            return ""
        }
    }()
    
    var memberBlockList = MemberBlockItemListSyntax()
    
    for registerGroup in module.registerGroup {
        for register in registerGroup.register {
            let memberBlock = generateRegister(register: register, bitSize: bitSize) // TODO: add this to the stored member blocks
            memberBlockList.append(memberBlock)
        }
    }
    
    let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())
    let protocolDeclarations = buildProtocolDeclarationsFrom(module: module)

    // Information needed to setup the Struct.
    let InheritedType = InheritedTypeSyntax(type: TypeSyntax(stringLiteral: protocolDeclarations))
    let inheritedTypeList = InheritedTypeListSyntax(arrayLiteral: InheritedType)
    let inheritanceClause = InheritanceClauseSyntax(inheritedTypes: inheritedTypeList)
    
    code.append(SourceFileSyntax {
        StructDeclSyntax(
            modifiers: DeclModifierListSyntax(arrayLiteral: DeclModifierSyntax(name: "public")),
            name: "\(raw: timerName)",
            inheritanceClause: inheritanceClause,
            memberBlock: memberBlock
        )
    }.formatted().description)

//    print(code)
    
    return GeneratedCodeFile(fileName: fileName, content: code)
}


/// This function help create what is needed to generate documentation for a register object.
/// Note that the data sheet adds a bit number to a bit name when there are more than one bit needed for a given value. This function adds these extra numbers to the bit name as they are not always present in the ATDF file. This also alwasy assumes that when a value is split accross two different registers, the most significan bit will be allone on one register and the least significant bits will be all togeather on the other register. This is believed to be the case but this function will calculate bit names incorectly if this is not the case. Ex: "FOC2A", "FOC2B", "-",  "-", "WGM22", "CS22", "CS21", "CS20"] and ["COM2A1", "COM2A0", "COM2B1", "COM2B0", "-", "-", "WGM21", "WGM20"] This example works because the ATDF file lists WGM2  as a setting with 2 bits on one register and then lists WGM22 as a setting on the other register. The second register will not add a number to the end because it is the only bit with that name.
/// This function will work for non-consecutive bit locations (Ex: 00110010) and give them the correct names.
/// - Parameter register: A register from the ATDF file object.
/// - Returns: A fixed array of 16 that includes either a "-" if there is no bit in that positon or the name of the bit in that position.
/// Example output: ["FOC2A", "FOC2B", "-", "-", "WGM22", "CS22", "CS21", "CS20"]
func getBitNamesFrom(register: AVRModules.Module.RegisterGroup.Register) -> [String] {
    print("Get Bit Names From Register:")
    var bitNames = Array(repeating: "-", count: 16)
        
    for bitField in register.bitfield {
        var mask: UInt16 = bitField.mask.value
        let name = bitField.name.rawValue
        
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

/// Adds Padding to strings for documentation. This is intended to be used for centering text in mono-spaced ASCII tables.
/// - Parameter input: String of 7 characters or less.
/// - Returns: A string of 7 characters, if the input string had more than 7 characters it should be unchanged.
func padString(_ input: String, padding: Int) -> String {
    if input.count >= padding {
        return input
    }
    
    let totalPadding = padding - input.count
    let leftPadding = totalPadding / 2
    let rightPadding = totalPadding - leftPadding
    
    return String(repeating: " ", count: leftPadding) + input + String(repeating: " ", count: rightPadding)
}

func generateRegister(register: AVRModules.Module.RegisterGroup.Register, bitSize: String) -> MemberBlockItemSyntax {
    
    var variableName: String {
        var variableName = register.caption?.rawValue ?? "" // .filter { $0 != " " } // TODO: Print some kind of error.
        variableName = variableName.filter { $0 != " " }
        variableName = variableName.filter { $0 != "/" }
        variableName = variableName.filter { $0 != "0" }
        variableName = variableName.filter { $0 != "1" }
        variableName = variableName.filter { $0 != "2" }
        variableName = variableName.filter { $0 != "3" }
        variableName = variableName.filter { $0 != "4" }
        variableName = variableName.filter { $0 != "5" }
        return variableName.prefix(1).lowercased() + variableName.dropFirst()
    }
    
    
    
    // If the register has bitfields then generate each bit name, if not then there is just one name for all of the bits.
    var registerName = ""
    
    if register.bitfield.isEmpty {
        registerName = padString(register.name.rawValue, padding: 63)
    } else {
        var bitNames = getBitNamesFrom(register: register)
        bitNames = bitNames.map { padString($0, padding: 7) }
        registerName = "\(bitNames[7])|\(bitNames[6])|\(bitNames[5])|\(bitNames[4])|\(bitNames[3])|\(bitNames[2])|\(bitNames[1])|\(bitNames[0])"
    }
    
    
    
    
    // TODO: Generate bit names and R/W in documentation table properly.
    // TODO: I don't think the UInt8 & UInt16 is set properly as the timer can be a 16 bit timer but only some of the registers need to be 16 bit while others are still 8 bit.
    let source = DeclSyntax(
      """
          /// \(raw: register.name) – \(raw: variableName)
          /// ```
          ///--------------------------------------------------------------------------------
          ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
          ///--------------------------------------------------------------------------------
          ///| (\(raw: register.offset.rawValue))       |\(raw: registerName)|
          ///--------------------------------------------------------------------------------
          ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
          ///--------------------------------------------------------------------------------
          ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
          ///--------------------------------------------------------------------------------
          /// ```
          static var \(raw: variableName): \(raw: bitSize) {
              get {
                  _volatileRegisterRead\(raw: bitSize)(\(raw: register.offset.rawValue))
              }
              set {
                  _volatileRegisterWrite\(raw: bitSize)(\(raw: register.offset.rawValue), newValue)
              }
          }
      """
    )
    
    return MemberBlockItemSyntax(decl: source)
}


// Note: These are only here for being able to build as these symbols are not linked like they would be in a true HAL project.
//func _volatileRegisterReadUInt8(_: UInt16) -> UInt8 { return 0 }
//
//func _volatileRegisterWriteUInt8(_: UInt16, _: UInt8) { }

