//
//  SwiftAVRGeneratorTests.swift
//  SwiftAVRGeneratorTests
//
//  Created by Paul Shelley on 5/27/23.
//

import Foundation
import XCTest
import XMLCoder
@testable import SwiftAVRGenerator

final class SwiftAVRGeneratorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public protocol UARTPort {
            static var dataRegister: PortDataType { get set }
            static var dataRegisterEmpty: Bool { get }
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("static var dataRegister: PortDataType { get set }"))
        XCTAssertTrue(result.content.contains("static var dataRegisterEmpty: Bool { get }"))
    }

    func testPerformanceExample() throws {
        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum PORTD {
            public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x2A) } set { _volatileRegisterWriteUInt8(0x2A, newValue) } }
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("public static var dataDirection: UInt8 {"))
        XCTAssertTrue(result.content.contains("get {"))
        XCTAssertTrue(result.content.contains("_volatileRegisterReadUInt8(0x2A)"))
        XCTAssertTrue(result.content.contains("set {"))
        XCTAssertTrue(result.content.contains("_volatileRegisterWriteUInt8(0x2A, newValue)"))
    }

    func testChipDocumentationLoaderUsesGeneralAsBaseAndChipOverridesIt() throws {
        let docsDirectory = try makeTemporaryDirectory()
        try write(
            """
            {
              "registers": [
                {
                  "aliases": ["UDR0"],
                  "variableName": "generalDataRegister",
                  "access": "R"
                }
              ],
              "bitfields": [
                {
                  "aliases": ["RXC0"],
                  "variableName": "generalReceiveComplete",
                  "valueType": "Bool",
                  "defaultValue": "",
                  "access": "R"
                }
              ]
            }
            """,
            to: docsDirectory.appendingPathComponent("general.json")
        )
        try write(
            """
            {
              "chip": "ATmega328P",
              "datasheet": "Test Datasheet",
              "registers": {
                "UDR0": {
                  "documentation": ["Chip register docs"],
                  "access": "R/W"
                }
              },
              "bitfields": {
                "RXC0": {
                  "variableName": "chipReceiveComplete",
                  "documentation": ["Chip bitfield docs"]
                }
              }
            }
            """,
            to: docsDirectory.appendingPathComponent("ATmega328P.json")
        )

        let register = try sampleRegister()
        let bitfield = try XCTUnwrap(register.bitfield.first)
        let loader = ChipDocumentationLoader()
        loader.directory = docsDirectory

        XCTAssertTrue(loader.loadGeneral())
        XCTAssertTrue(loader.load(chipName: "ATmega328P"))

        let registerData = loader.supplementalData(for: register)
        XCTAssertEqual(registerData.variableName, "generalDataRegister")
        XCTAssertEqual(registerData.documentation, "Chip register docs")
        XCTAssertEqual(registerData.access, "R/W")

        let bitfieldData = loader.supplementalData(for: bitfield)
        XCTAssertEqual(bitfieldData.variableName, "chipReceiveComplete")
        XCTAssertEqual(bitfieldData.valueType, "Bool")
        XCTAssertEqual(bitfieldData.documentation, "Chip bitfield docs")
        XCTAssertEqual(bitfieldData.access, .read)

        XCTAssertTrue(loader.generationLog.exported)
        XCTAssertTrue(loader.generationLog.missingRegisters.isEmpty)
        XCTAssertTrue(loader.generationLog.missingBitfields.isEmpty)
    }

    func testSplitTargetsStayChipSpecific() throws {
        let docsDirectory = try makeTemporaryDirectory()
        try write(
            """
            {
              "registers": [],
              "bitfields": [
                {
                  "aliases": ["UCSZ02"],
                  "variableName": "numberOfDataBits",
                  "valueType": "UART.NumberOfDataBits",
                  "defaultValue": ".eight",
                  "access": "R/W"
                }
              ]
            }
            """,
            to: docsDirectory.appendingPathComponent("general.json")
        )
        try write(
            """
            {
              "chip": "ATmega328P",
              "datasheet": "Test Datasheet",
              "registers": {},
              "bitfields": {
                "UCSZ02": {
                  "documentation": ["Chip split bitfield docs"],
                  "splitTarget": "UCSZ0"
                }
              }
            }
            """,
            to: docsDirectory.appendingPathComponent("ATmega328P.json")
        )

        let bitfield = try sampleSplitBitfield()
        let loader = ChipDocumentationLoader()
        loader.directory = docsDirectory

        XCTAssertTrue(loader.loadGeneral())
        XCTAssertTrue(loader.load(chipName: "ATmega328P"))

        let bitfieldData = loader.supplementalData(for: bitfield)
        XCTAssertEqual(bitfieldData.variableName, "numberOfDataBits")
        XCTAssertEqual(bitfieldData.valueType, "UART.NumberOfDataBits")
        XCTAssertEqual(bitfieldData.splitTarget, "UCSZ0")
        XCTAssertEqual(bitfieldData.documentation, "Chip split bitfield docs")
    }

    func testExportAllSkipsChipWhenSupplementalDocsAreMissing() throws {
        let docsDirectory = try makeTemporaryDirectory()
        let outputDirectory = try makeTemporaryDirectory()

        try write(
            """
            {
              "registers": [],
              "bitfields": []
            }
            """,
            to: docsDirectory.appendingPathComponent("general.json")
        )

        exportAll(
            fromURLs: [atdfURL(named: "ATmega328P")],
            toURL: outputDirectory,
            docURL: docsDirectory
        )

        let logsURL = outputDirectory.appendingPathComponent("logs.json")
        let chipOutputDirectory = outputDirectory.appendingPathComponent("ATmega328P")

        XCTAssertTrue(FileManager.default.fileExists(atPath: logsURL.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: chipOutputDirectory.path))

        let logsData = try Data(contentsOf: logsURL)
        let logs = try JSONDecoder().decode(Logs.self, from: logsData)
        let chipLog = try XCTUnwrap(logs.chips.first(where: { $0.name == "ATmega328P" }))

        XCTAssertFalse(chipLog.exported)
        XCTAssertTrue(chipLog.missingRegisters.contains(where: { $0.name == "UDR0" }))
        XCTAssertTrue(chipLog.missingBitfields.contains(where: { $0.name == "RXC0" }))
    }

    private func repositoryRootURL() -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    private func atdfURL(named chipName: String) -> URL {
        repositoryRootURL().appendingPathComponent("atdf/\(chipName).atdf")
    }

    private func sampleRegister() throws -> AVRModules.Module.RegisterGroup.Register {
        let xml = """
        <register name="UDR0" offset="0x0C" size="1" caption="USART Data Register" rw="R/W">
            <bitfield name="RXC0" mask="0x80" caption="Receive Complete" rw="R"/>
        </register>
        """

        return try XMLDecoder().decode(
            AVRModules.Module.RegisterGroup.Register.self,
            from: Data(xml.utf8)
        )
    }

    private func sampleSplitBitfield() throws -> AVRModules.Module.RegisterGroup.Register.Bitfield {
        let xml = """
        <register name="UCSR0B" offset="0x0A" size="1" caption="USART Control and Status Register B" rw="R/W">
            <bitfield name="UCSZ02" mask="0x04" caption="Character Size Bit 2" rw="R/W"/>
        </register>
        """

        let register = try XMLDecoder().decode(
            AVRModules.Module.RegisterGroup.Register.self,
            from: Data(xml.utf8)
        )

        return try XCTUnwrap(register.bitfield.first)
    }

    private func makeTemporaryDirectory() throws -> URL {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    private func write(_ contents: String, to url: URL) throws {
        try contents.write(to: url, atomically: true, encoding: .utf8)
    }

}
