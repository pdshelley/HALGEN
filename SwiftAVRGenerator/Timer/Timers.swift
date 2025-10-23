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

func buildTimer(module: AVRModules.Module, timerName: String) -> GeneratedCodeFile {
    let fileName = "\(timerName).swift"
    var code: String = ""
    
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

    print(code)
    
    return GeneratedCodeFile(fileName: fileName, content: code)
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
    
    // TODO: Generate bit names and R/W in documentation table properly.
    // TODO: I don't think the UInt8 & UInt16 is set properly as the timer can be a 16 bit timer but only some of the registers need to be 16 bit while others are still 8 bit.
    let source = DeclSyntax(
      """
          /// \(raw: register.name) – \(raw: variableName)
          ///```
          ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
          ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
          ///| (\(raw: register.offset.rawValue))       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
          ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
          ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
          ///```
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
