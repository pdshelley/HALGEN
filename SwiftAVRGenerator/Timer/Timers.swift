//
//  Timers.swift
//  XMLTest
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
    
    for registerGroup in module.registerGroup { // always register Group TC0
        for register in registerGroup.register {
            let memberBlock = generateRegister(register: register, bitSize: bitSize) // TODO: add this to the stored member blocks
            memberBlockList.append(memberBlock)
        }
    }
    
    let memberBlock = MemberBlockSyntax(leftBrace: .leftBraceToken(), members: memberBlockList, rightBrace: .rightBraceToken())

    // Information needed to setup the Struct.
    let InheritedType = InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "Timer8Bit, HasExternalClock ")) // TODO: Set these based on ATDF Data.
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
