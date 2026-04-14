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

    func testGetVariableNameRemovesDigitsFromSuggestions() {
        XCTAssertEqual(
            getVariableName(caption: "Timer/Counter1 Control Register A"),
            "timerCounterControlRegisterA"
        )
        XCTAssertEqual(
            getVariableName(caption: "ADC6 Digital input Disable"),
            "adcDigitalInputDisable"
        )
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
                  "access": "R",
                  "inline": "__always"
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
                  "access": "R/W",
                  "overrideGeneratedDocumentation": true
                }
              },
              "bitfields": {
                "RXC0": {
                  "variableName": "chipReceiveComplete",
                  "documentation": ["Chip bitfield docs"],
                  "inline": "__never",
                  "overrideGeneratedDocumentation": true
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
        XCTAssertTrue(registerData.overrideGeneratedDocumentation)

        let bitfieldData = loader.supplementalData(for: bitfield)
        XCTAssertEqual(bitfieldData.variableName, "chipReceiveComplete")
        XCTAssertEqual(bitfieldData.valueType, "Bool")
        XCTAssertEqual(bitfieldData.documentation, "Chip bitfield docs")
        XCTAssertEqual(bitfieldData.access, .read)
        XCTAssertEqual(bitfieldData.inline, "__never")
        XCTAssertTrue(bitfieldData.overrideGeneratedDocumentation)

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
                  "splitTargetLSB": "UCSZ0"
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
        XCTAssertEqual(bitfieldData.splitTargetLSB, "UCSZ0")
        XCTAssertEqual(bitfieldData.documentation, "Chip split bitfield docs")
    }

    func testBoilerplateTemplateUsesDocsOverrideDirectory() throws {
        let docsDirectory = try makeTemporaryDirectory()
        let boilerplateDirectory = docsDirectory.appendingPathComponent("boilerplate", isDirectory: true)
        try FileManager.default.createDirectory(at: boilerplateDirectory, withIntermediateDirectories: true)
        try write(
            "override {{VALUE}}",
            to: boilerplateDirectory.appendingPathComponent("Template.txt")
        )

        let rendered = BoilerplateTemplate.render(
            named: "Template.txt",
            documentationDirectory: docsDirectory,
            substitutions: ["VALUE": "content"]
        )

        XCTAssertEqual(rendered, "override content")
    }

    func testUARTNumberOfDataBitsAccessorNormalizesSplitFields() throws {
        let registerGroup = try sampleUARTRegisterGroup()
        let register = try XCTUnwrap(registerGroup.register.first(where: { $0.name == "UCSR0B" }))
        let bitfield = try XCTUnwrap(register.bitfield.first(where: { $0.name == "UCSZ02" }))

        let accessor = try XCTUnwrap(
            generateBitfieldAccessor(
                bitfield: bitfield,
                parentVariable: register,
                registerGroup: registerGroup,
                registerData: { register in
                    switch register.name {
                    case "UCSR0B":
                        return SupplementalRegisterData(
                            variableName: "controlRegisterB",
                            valueType: "UInt8",
                            defaultValue: "0",
                            documentation: "",
                            access: "R/W"
                        )
                    case "UCSR0C":
                        return SupplementalRegisterData(
                            variableName: "controlRegisterC",
                            valueType: "UInt8",
                            defaultValue: "0",
                            documentation: "",
                            access: "R/W"
                        )
                    default:
                        return SupplementalRegisterData(
                            variableName: register.name,
                            valueType: "UInt8",
                            defaultValue: "0",
                            documentation: "",
                            access: "R/W"
                        )
                    }
                },
                bitfieldData: { bitfield in
                    if bitfield.name == "UCSZ02" {
                        return SupplementalBitfieldData(
                            variableName: "numberOfDataBits",
                            valueType: "UART.NumberOfDataBits",
                            defaultValue: ".eight",
                            documentation: "",
                            access: .readWrite,
                            splitTargetLSB: "UCSZ0"
                        )
                    }

                    return SupplementalBitfieldData(
                        variableName: "numberOfDataBits",
                        valueType: "UART.NumberOfDataBits",
                        defaultValue: ".eight",
                        documentation: "",
                        access: .readWrite
                    )
                }
            )
        )

        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum UART0 {
        \(indent(accessor.description, by: 4))
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("let mode = (controlRegisterB & 0b00000100) | ((controlRegisterC & 0b00000110) >> UInt8(1))"))
        XCTAssertTrue(result.content.contains("controlRegisterC = (controlRegisterC & ~0b00000110) | ((newValue.rawValue & 0b00000011) << UInt8(1))"))
        XCTAssertTrue(result.content.contains("controlRegisterB = (controlRegisterB & ~0b00000100) | ((newValue.rawValue << UInt8(2)) & 0b00000100)"))
    }

    func testSplitAccessorSupportsLowPrimaryBitfield() throws {
        let registerGroup = try sampleTimer2RegisterGroup()
        let register = try XCTUnwrap(registerGroup.register.first(where: { $0.name == "TCCR2A" }))
        let bitfield = try XCTUnwrap(register.bitfield.first(where: { $0.name == "WGM2" }))

        let accessor = try XCTUnwrap(
            generateBitfieldAccessor(
                bitfield: bitfield,
                parentVariable: register,
                registerGroup: registerGroup,
                registerData: { register in
                    switch register.name {
                    case "TCCR2A":
                        return SupplementalRegisterData(
                            variableName: "controlRegisterA",
                            valueType: "UInt8",
                            defaultValue: "0",
                            documentation: "",
                            access: "R/W"
                        )
                    case "TCCR2B":
                        return SupplementalRegisterData(
                            variableName: "controlRegisterB",
                            valueType: "UInt8",
                            defaultValue: "0",
                            documentation: "",
                            access: "R/W"
                        )
                    default:
                        return SupplementalRegisterData(
                            variableName: register.name,
                            valueType: "UInt8",
                            defaultValue: "0",
                            documentation: "",
                            access: "R/W"
                        )
                    }
                },
                bitfieldData: { bitfield in
                    if bitfield.name == "WGM2" {
                        return SupplementalBitfieldData(
                            variableName: "waveformGenerationMode",
                            valueType: "Timer8Bit.WaveformGenerationMode",
                            defaultValue: ".normal",
                            documentation: "",
                            access: .readWrite,
                            splitTargetLSB: "WGM22"
                        )
                    }

                    return SupplementalBitfieldData(
                        variableName: "waveformGenerationMode",
                        valueType: "Timer8Bit.WaveformGenerationMode",
                        defaultValue: ".normal",
                        documentation: "",
                        access: .readWrite
                    )
                }
            )
        )

        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum Timer2 {
        \(indent(accessor.description, by: 4))
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("let mode = ((controlRegisterB & 0b00001000) >> UInt8(1)) | (controlRegisterA & 0b00000011)"))
        XCTAssertTrue(result.content.contains("controlRegisterA = (controlRegisterA & ~0b00000011) | (newValue.rawValue & 0b00000011)"))
        XCTAssertTrue(result.content.contains("controlRegisterB = (controlRegisterB & ~0b00001000) | ((newValue.rawValue & 0b00000100) << UInt8(1))"))
    }

    func testWriteOnlyBitfieldGeneratesValidComputedProperty() throws {
        let registerGroup = try sampleWriteOnlyRegisterGroup()
        let register = try XCTUnwrap(registerGroup.register.first)
        let bitfield = try XCTUnwrap(register.bitfield.first)

        let accessor = try XCTUnwrap(
            generateBitfieldAccessor(
                bitfield: bitfield,
                parentVariable: register,
                registerGroup: registerGroup,
                registerData: { register in
                    SupplementalRegisterData(
                        variableName: register.name == "TCCR0B" ? "controlRegisterB" : register.name,
                        valueType: "UInt8",
                        defaultValue: "0",
                        documentation: "",
                        access: register.rw ?? "R/W"
                    )
                },
                bitfieldData: { _ in
                    SupplementalBitfieldData(
                        variableName: "forceOutputCompareA",
                        valueType: "Bool",
                        defaultValue: "false",
                        documentation: "",
                        access: .write
                    )
                }
            )
        )

        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum Timer0 {
        \(indent(accessor.description, by: 4))
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("public static var forceOutputCompareA: Bool {"))
        XCTAssertTrue(result.content.contains("get {"))
        XCTAssertTrue(result.content.contains("set {"))
    }

    func testSingleRegisterEnumSetterClearsBitsBeforeWriting() throws {
        let registerGroup = try sampleSingleBitUARTRegisterGroup()
        let register = try XCTUnwrap(registerGroup.register.first)
        let bitfield = try XCTUnwrap(register.bitfield.first)

        let accessor = try XCTUnwrap(
            generateBitfieldAccessor(
                bitfield: bitfield,
                parentVariable: register,
                registerGroup: registerGroup,
                registerData: { _ in
                    SupplementalRegisterData(
                        variableName: "controlRegisterA",
                        valueType: "UInt8",
                        defaultValue: "0",
                        documentation: "",
                        access: "R/W"
                    )
                },
                bitfieldData: { _ in
                    SupplementalBitfieldData(
                        variableName: "asynchronousDoubleSpeedMode",
                        valueType: "UART.AsynchronousDoubleSpeedMode",
                        defaultValue: ".off",
                        documentation: "",
                        access: .readWrite
                    )
                }
            )
        )

        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum UART0 {
        \(indent(accessor.description, by: 4))
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("controlRegisterA = (controlRegisterA & ~0b00000010) | ((newValue.rawValue & 0b00000001) << UInt8(1))"))
    }

    func testBitfieldInlineDefaultsToAlwaysWhenUnspecified() throws {
        let registerGroup = try sampleSingleBitUARTRegisterGroup()
        let register = try XCTUnwrap(registerGroup.register.first)
        let bitfield = try XCTUnwrap(register.bitfield.first)

        let accessor = try XCTUnwrap(
            generateBitfieldAccessor(
                bitfield: bitfield,
                parentVariable: register,
                registerGroup: registerGroup,
                registerData: { _ in
                    SupplementalRegisterData(
                        variableName: "controlRegisterA",
                        valueType: "UInt8",
                        defaultValue: "0",
                        documentation: "",
                        access: "R/W"
                    )
                },
                bitfieldData: { _ in
                    SupplementalBitfieldData(
                        variableName: "asynchronousDoubleSpeedMode",
                        valueType: "UART.AsynchronousDoubleSpeedMode",
                        defaultValue: ".off",
                        documentation: "",
                        access: .readWrite
                    )
                }
            )
        )

        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum UART0 {
        \(indent(accessor.description, by: 4))
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("@inline(__always)"))
    }

    func testBitfieldInlineUsesOverrideValue() throws {
        let registerGroup = try sampleSingleBitUARTRegisterGroup()
        let register = try XCTUnwrap(registerGroup.register.first)
        let bitfield = try XCTUnwrap(register.bitfield.first)

        let accessor = try XCTUnwrap(
            generateBitfieldAccessor(
                bitfield: bitfield,
                parentVariable: register,
                registerGroup: registerGroup,
                registerData: { _ in
                    SupplementalRegisterData(
                        variableName: "controlRegisterA",
                        valueType: "UInt8",
                        defaultValue: "0",
                        documentation: "",
                        access: "R/W"
                    )
                },
                bitfieldData: { _ in
                    SupplementalBitfieldData(
                        variableName: "asynchronousDoubleSpeedMode",
                        valueType: "UART.AsynchronousDoubleSpeedMode",
                        defaultValue: ".off",
                        documentation: "",
                        access: .readWrite,
                        inline: "__never"
                    )
                }
            )
        )

        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum UART0 {
        \(indent(accessor.description, by: 4))
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("@inline(__never)"))
    }

    func testGenerateEnumBuildsFourBitDocumentationTableAndUsesCaptions() throws {
        let valueGroup = try sampleTimerPrescalingValueGroup()

        let generated = generateEnum(from: valueGroup, bitfieldName: "CS1", bitWidth: 4)
        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum Timer1 {
        \(indent(generated.description, by: 4))
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("| Mode | CS13 | CS12 | CS11 | CS10 | Description"))
        XCTAssertTrue(result.content.contains("|  4   |  0   |  1   |  0   |  0   | Running, CLK*2"))
        XCTAssertTrue(result.content.contains("|  10  |  1   |  0   |  1   |  0   | Running, CLK/32"))
        XCTAssertTrue(result.content.contains("|  15  |  1   |  1   |  1   |  1   | Running, CLK/1024"))
        XCTAssertTrue(result.content.contains("case running4 = 3 // Running, CLK*4"))
        XCTAssertTrue(result.content.contains("case running2 = 4 // Running, CLK*2"))
        XCTAssertTrue(result.content.contains("case running2_2 = 6 // Running, CLK/2"))
        XCTAssertTrue(result.content.contains("case running4_2 = 7 // Running, CLK/4"))
        XCTAssertTrue(result.content.contains("case runningWithoutPrescaling = 5 // Running, No Prescaling"))
    }

    func testRegisterDocumentationOverrideSuppressesGeneratedTitleAndTable() throws {
        let register = try sampleRegister()

        let members = generateRegister(
            register: register,
            registerData: { _ in
                SupplementalRegisterData(
                    variableName: "dataRegister",
                    valueType: "UInt8",
                    defaultValue: "0",
                    documentation: "Chip register docs",
                    access: "R/W",
                    overrideGeneratedDocumentation: true
                )
            },
            bitfieldData: { _ in
                SupplementalBitfieldData(
                    variableName: "rxDataAvailable",
                    valueType: "Bool",
                    defaultValue: "false",
                    documentation: "",
                    access: .read
                )
            }
        )

        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum UART0 {
        \(indent(members.description, by: 4))
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("/// Chip register docs"))
        XCTAssertFalse(result.content.contains("/// UDR0"))
        XCTAssertFalse(result.content.contains("/// | Bit"))
    }

    func testBitfieldDocumentationOverrideSuppressesGeneratedTitle() throws {
        let registerGroup = try sampleSingleBitUARTRegisterGroup()
        let register = try XCTUnwrap(registerGroup.register.first)
        let bitfield = try XCTUnwrap(register.bitfield.first)

        let accessor = try XCTUnwrap(
            generateBitfieldAccessor(
                bitfield: bitfield,
                parentVariable: register,
                registerGroup: registerGroup,
                registerData: { _ in
                    SupplementalRegisterData(
                        variableName: "controlRegisterA",
                        valueType: "UInt8",
                        defaultValue: "0",
                        documentation: "",
                        access: "R/W"
                    )
                },
                bitfieldData: { _ in
                    SupplementalBitfieldData(
                        variableName: "asynchronousDoubleSpeedMode",
                        valueType: "UART.AsynchronousDoubleSpeedMode",
                        defaultValue: ".off",
                        documentation: "Chip bitfield docs",
                        access: .readWrite,
                        overrideGeneratedDocumentation: true
                    )
                }
            )
        )

        let formatter = CodeFormatter()
        let result = formatter.format(source: """
        public enum UART0 {
        \(indent(accessor.description, by: 4))
        }
        """)

        XCTAssertTrue(result.diagnostics.isEmpty)
        XCTAssertTrue(result.content.contains("/// Chip bitfield docs"))
        XCTAssertFalse(result.content.contains("/// U2X0 - Double the USART transmission speed"))
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
        let logsString = String(decoding: logsData, as: UTF8.self)
        let logs = try JSONDecoder().decode(Logs.self, from: logsData)
        let chipLog = try XCTUnwrap(logs.chips.first(where: { $0.name == "ATmega328P" }))
        let uartLog = try XCTUnwrap(chipLog.peripherals.first(where: { $0.name == "UART" }))
        let exportedCountRange = try XCTUnwrap(logsString.range(of: "\"exportedChipCount\""))
        let skippedCountRange = try XCTUnwrap(logsString.range(of: "\"skippedChipCount\""))
        let chipsRange = try XCTUnwrap(logsString.range(of: "\"chips\""))

        XCTAssertEqual(logs.exportedChipCount, 0)
        XCTAssertEqual(logs.skippedChipCount, 1)
        XCTAssertLessThan(exportedCountRange.lowerBound, chipsRange.lowerBound)
        XCTAssertLessThan(skippedCountRange.lowerBound, chipsRange.lowerBound)
        XCTAssertFalse(chipLog.exported)
        XCTAssertTrue(uartLog.missingRegisters.contains(where: { $0.name == "UDR0" }))
        XCTAssertTrue(uartLog.missingBitfields.contains(where: { $0.name == "RXC0" }))
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

    private func sampleUARTRegisterGroup() throws -> AVRModules.Module.RegisterGroup {
        let xml = """
        <register-group name="USART0">
            <register name="UCSR0B" offset="0x0A" size="1" caption="USART Control and Status Register B" rw="R/W">
                <bitfield name="UCSZ02" mask="0x04" caption="Character Size Bit 2" rw="R/W"/>
            </register>
            <register name="UCSR0C" offset="0x0B" size="1" caption="USART Control and Status Register C" rw="R/W">
                <bitfield name="UCSZ0" mask="0x06" caption="Character Size Bits 1:0" rw="R/W"/>
            </register>
        </register-group>
        """

        return try XMLDecoder().decode(
            AVRModules.Module.RegisterGroup.self,
            from: Data(xml.utf8)
        )
    }

    private func sampleTimer2RegisterGroup() throws -> AVRModules.Module.RegisterGroup {
        let xml = """
        <register-group name="TC2">
            <register name="TCCR2A" offset="0x0A" size="1" caption="Timer/Counter2 Control Register A" rw="R/W">
                <bitfield name="WGM2" mask="0x03" caption="Waveform Generation Mode" rw="R/W"/>
            </register>
            <register name="TCCR2B" offset="0x0B" size="1" caption="Timer/Counter2 Control Register B" rw="R/W">
                <bitfield name="WGM22" mask="0x08" caption="Waveform Generation Mode" rw="R/W"/>
            </register>
        </register-group>
        """

        return try XMLDecoder().decode(
            AVRModules.Module.RegisterGroup.self,
            from: Data(xml.utf8)
        )
    }

    private func sampleWriteOnlyRegisterGroup() throws -> AVRModules.Module.RegisterGroup {
        let xml = """
        <register-group name="TC0">
            <register name="TCCR0B" offset="0x45" size="1" caption="Timer/Counter Control Register B" rw="R/W">
                <bitfield name="FOC0A" mask="0x80" caption="Force Output Compare A" rw="W"/>
            </register>
        </register-group>
        """

        return try XMLDecoder().decode(
            AVRModules.Module.RegisterGroup.self,
            from: Data(xml.utf8)
        )
    }

    private func sampleSingleBitUARTRegisterGroup() throws -> AVRModules.Module.RegisterGroup {
        let xml = """
        <register-group name="USART0">
            <register name="UCSR0A" offset="0x0B" size="1" caption="USART Control and Status Register A" rw="R/W">
                <bitfield name="U2X0" mask="0x02" caption="Double the USART transmission speed" rw="R/W"/>
            </register>
        </register-group>
        """

        return try XMLDecoder().decode(
            AVRModules.Module.RegisterGroup.self,
            from: Data(xml.utf8)
        )
    }

    private func sampleTimerPrescalingValueGroup() throws -> AVRModules.Module.ValueGroup {
        let xml = """
        <value-group name="CLK_SEL_4BIT_FAST">
            <value caption="No Clock Source (Stopped)" name="NO_CLOCK_SOURCE_STOPPED" value="0x00"/>
            <value caption="Running, CLK*16" name="RUNNING_CLK_16" value="0x01"/>
            <value caption="Running, CLK*8" name="RUNNING_CLK_8" value="0x02"/>
            <value caption="Running, CLK*4" name="RUNNING_CLK_4" value="0x03"/>
            <value caption="Running, CLK*2" name="RUNNING_CLK_2" value="0x04"/>
            <value caption="Running, No Prescaling" name="RUNNING_NO_PRESCALING" value="0x05"/>
            <value caption="Running, CLK/2" name="RUNNING_CLK_2" value="0x06"/>
            <value caption="Running, CLK/4" name="RUNNING_CLK_4" value="0x07"/>
            <value caption="Running, CLK/8" name="RUNNING_CLK_8" value="0x08"/>
            <value caption="Running, CLK/16" name="RUNNING_CLK_16" value="0x09"/>
            <value caption="Running, CLK/32" name="RUNNING_CLK_32" value="0x0A"/>
            <value caption="Running, CLK/64" name="RUNNING_CLK_64" value="0x0B"/>
            <value caption="Running, CLK/128" name="RUNNING_CLK_128" value="0x0C"/>
            <value caption="Running, CLK/256" name="RUNNING_CLK_256" value="0x0D"/>
            <value caption="Running, CLK/512" name="RUNNING_CLK_512" value="0x0E"/>
            <value caption="Running, CLK/1024" name="RUNNING_CLK_1024" value="0x0F"/>
        </value-group>
        """

        return try XMLDecoder().decode(
            AVRModules.Module.ValueGroup.self,
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
