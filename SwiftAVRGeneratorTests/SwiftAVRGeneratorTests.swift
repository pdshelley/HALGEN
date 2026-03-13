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
                  "documentation": ["General register docs"],
                  "access": "R"
                }
              ],
              "bitfields": [
                {
                  "aliases": ["RXC0"],
                  "variableName": "generalReceiveComplete",
                  "valueType": "Bool",
                  "defaultValue": "",
                  "documentation": ["General bitfield docs"],
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
                  "variableName": "chipDataRegister",
                  "documentation": ["Chip register docs"],
                  "access": "R/W"
                }
              },
              "bitfields": {}
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
        XCTAssertEqual(registerData.variableName, "chipDataRegister")
        XCTAssertEqual(registerData.documentation, "Chip register docs")
        XCTAssertEqual(registerData.access, "R/W")

        let bitfieldData = loader.supplementalData(for: bitfield)
        XCTAssertEqual(bitfieldData.variableName, "generalReceiveComplete")
        XCTAssertEqual(bitfieldData.valueType, "Bool")
        XCTAssertEqual(bitfieldData.documentation, "General bitfield docs")
        XCTAssertEqual(bitfieldData.access, .read)

        XCTAssertTrue(loader.generationLog.exported)
        XCTAssertTrue(loader.generationLog.missingRegisters.isEmpty)
        XCTAssertTrue(loader.generationLog.missingBitfields.isEmpty)
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

    private func makeTemporaryDirectory() throws -> URL {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    private func write(_ contents: String, to url: URL) throws {
        try contents.write(to: url, atomically: true, encoding: .utf8)
    }

}
