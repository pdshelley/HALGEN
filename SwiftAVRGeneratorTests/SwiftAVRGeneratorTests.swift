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

    func testPeripheralInstanceIndexUsesTrailingNumericSuffix() {
        XCTAssertNil(trailingNumericSuffix(in: "SPI"))
        XCTAssertEqual(trailingNumericSuffix(in: "SPI1"), "1")
        XCTAssertEqual(trailingNumericSuffix(in: "USART12"), "12")

        XCTAssertEqual(peripheralInstanceIndex(for: "SPI"), "0")
        XCTAssertEqual(peripheralInstanceIndex(for: "SPI1"), "1")
        XCTAssertEqual(peripheralInstanceIndex(for: "USART12"), "12")
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

    func testBoardConfigurationUsesChipOverridesBeforeATDFDefaults() throws {
        let docsDirectory = try makeTemporaryDirectory()
        try write(
            """
            {
              "registers": [],
              "bitfields": []
            }
            """,
            to: docsDirectory.appendingPathComponent("general.json")
        )
        try write(
            """
            {
              "chip": "ATmega328P",
              "datasheet": "Test Datasheet",
              "board": {
                "ramSize": 4096,
                "flashSize": 65536,
                "eepromSize": 2048,
                "baud": 57600,
                "cpuFrequency": 8000000
              },
              "registers": {},
              "bitfields": {}
            }
            """,
            to: docsDirectory.appendingPathComponent("ATmega328P.json")
        )

        let loader = ChipDocumentationLoader()
        loader.directory = docsDirectory

        XCTAssertTrue(loader.loadGeneral())
        XCTAssertTrue(loader.load(chipName: "ATmega328P"))

        let atdfData = try Data(contentsOf: atdfURL(named: "ATmega328P"))
        let device = try XMLDecoder().decode(AVRToolsDeviceFile.self, from: atdfData)
        let configuration = loader.boardConfiguration(for: device)

        XCTAssertEqual(configuration.ramSize, 4096)
        XCTAssertEqual(configuration.flashSize, 65536)
        XCTAssertEqual(configuration.eepromSize, 2048)
        XCTAssertEqual(configuration.baud, 57600)
        XCTAssertEqual(configuration.cpuFrequency, 8000000)
    }

    func testBoardConfigurationFallsBackToATDFAndDefaults() throws {
        let loader = ChipDocumentationLoader()
        loader.directory = repositoryRootURL().appendingPathComponent("docs", isDirectory: true)

        XCTAssertTrue(loader.loadGeneral())
        XCTAssertFalse(loader.load(chipName: "ATtiny85"))

        let atdfData = try Data(contentsOf: atdfURL(named: "ATtiny85"))
        let device = try XMLDecoder().decode(AVRToolsDeviceFile.self, from: atdfData)
        let configuration = loader.boardConfiguration(for: device)

        XCTAssertEqual(configuration.ramSize, 512)
        XCTAssertEqual(configuration.flashSize, 8192)
        XCTAssertEqual(configuration.eepromSize, 512)
        XCTAssertEqual(configuration.baud, 115200)
        XCTAssertEqual(configuration.cpuFrequency, 10000000)
    }

    func testMemorySegmentSizePrefersExactNameOverEarlierTypeMatch() throws {
        let device = try makeDevice(
            withMemorySegmentsXML: """
            <address-space endianness="little" name="prog" id="prog" start="0x0000" size="0x0200">
                <memory-segment start="0x0100" size="0x0010" type="flash" rw="RW" exec="1" name="BOOT_SECTION_1"/>
                <memory-segment start="0x0000" size="0x0100" type="flash" rw="RW" exec="1" name="FLASH"/>
            </address-space>
            """
        )

        XCTAssertEqual(device.memorySegmentSize(named: "FLASH", type: "flash"), 0x0100)
    }

    func testMemorySegmentSizePrefersInternalRAMWhenNameFallbackIsNeeded() throws {
        let device = try makeDevice(
            withMemorySegmentsXML: """
            <address-space endianness="little" name="data" id="data" start="0x0000" size="0x1000">
                <memory-segment start="0x0200" size="0x0800" type="ram" name="XRAM" external="true"/>
                <memory-segment start="0x0100" size="0x0100" type="ram" name="SRAM" external="false"/>
            </address-space>
            """
        )

        XCTAssertEqual(device.memorySegmentSize(named: "IRAM", type: "ram"), 0x0100)
    }

    func testMemorySegmentSizeUsesLargestFlashSegmentForTypeFallback() throws {
        let device = try makeDevice(
            withMemorySegmentsXML: """
            <address-space endianness="little" name="prog" id="prog" start="0x0000" size="0x0200">
                <memory-segment start="0x0100" size="0x0010" type="flash" rw="RW" exec="1" name="BOOT_SECTION_1"/>
                <memory-segment start="0x0000" size="0x0100" type="flash" rw="RW" exec="1" name="APP_FLASH"/>
            </address-space>
            """
        )

        XCTAssertEqual(device.memorySegmentSize(named: "FLASH", type: "flash"), 0x0100)
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
        try writeMinimalBoilerplateTemplates(to: docsDirectory)

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

    func testExportAllWritesCoreAVRPackageShape() throws {
        let outputDirectory = try makeTemporaryDirectory()

        exportAll(
            fromURLs: [atdfURL(named: "ATmega328P")],
            toURL: outputDirectory,
            docURL: repositoryRootURL().appendingPathComponent("docs", isDirectory: true)
        )

        let chipOutputDirectory = outputDirectory.appendingPathComponent("ATmega328P", isDirectory: true)
        let sourceDirectory = chipOutputDirectory.appendingPathComponent("Sources/CoreAVR", isDirectory: true)
        let swift4pURL = chipOutputDirectory.appendingPathComponent("CoreAVR.swift4p")
        let boardIncludeURL = chipOutputDirectory.appendingPathComponent("board.include")
        let readmeURL = chipOutputDirectory.appendingPathComponent("README.md")

        XCTAssertTrue(FileManager.default.fileExists(atPath: chipOutputDirectory.appendingPathComponent("Package.swift").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: chipOutputDirectory.appendingPathComponent("CoreAVR.h").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: chipOutputDirectory.appendingPathComponent("module.modulemap").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: sourceDirectory.appendingPathComponent("CoreAVR.swift").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: sourceDirectory.appendingPathComponent("DigitalValue.swift").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: sourceDirectory.appendingPathComponent("Utilities.swift").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: sourceDirectory.appendingPathComponent("module/GPIO.swift").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: sourceDirectory.appendingPathComponent("module/UART/UART0.swift").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: sourceDirectory.appendingPathComponent("module/Timer/Timer1.swift").path))

        XCTAssertFalse(FileManager.default.fileExists(atPath: chipOutputDirectory.appendingPathComponent(".project/board.include").path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: sourceDirectory.appendingPathComponent("module/CPUCore.swift").path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: sourceDirectory.appendingPathComponent("module/Interrupts.swift").path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: sourceDirectory.appendingPathComponent("module/EEPROM.swift").path))

        let swift4p = try String(contentsOf: swift4pURL, encoding: .utf8)
        XCTAssertTrue(swift4p.contains("- Sources/CoreAVR/module/GPIO.swift"))
        XCTAssertTrue(swift4p.contains("- Sources/CoreAVR/module/UART/UART0.swift"))
        XCTAssertFalse(swift4p.contains("CPUCore.swift"))
        XCTAssertFalse(swift4p.contains(".project/board.include"))

        let boardInclude = try String(contentsOf: boardIncludeURL, encoding: .utf8)
        XCTAssertTrue(boardInclude.contains("RAM_SIZE=2048"))
        XCTAssertTrue(boardInclude.contains("FLASH_SIZE=32768"))
        XCTAssertTrue(boardInclude.contains("BAUD=115200"))
        XCTAssertTrue(boardInclude.contains("CPU_FREQUENCY=16000000"))
        XCTAssertTrue(boardInclude.contains("MCUMACRO=__AVR_ATmega328P__"))
        XCTAssertTrue(boardInclude.contains("CORE=avr5"))

        let tinyDocsDirectory = repositoryRootURL().appendingPathComponent("docs", isDirectory: true)
        let tinyLoader = ChipDocumentationLoader()
        tinyLoader.directory = tinyDocsDirectory
        XCTAssertTrue(tinyLoader.loadGeneral())
        XCTAssertTrue(tinyLoader.load(chipName: "ATtiny15"))
        let tinyData = try Data(contentsOf: atdfURL(named: "ATtiny15"))
        let tinyDevice = try XMLDecoder().decode(AVRToolsDeviceFile.self, from: tinyData)
        let tinyCore = GeneratedAVRCore(
            name: tinyDevice.devices.device.name,
            atdfFileName: "ATtiny15.atdf",
            device: tinyDevice,
            boardConfiguration: tinyLoader.boardConfiguration(for: tinyDevice),
            files: [],
            log: tinyLoader.generationLog
        )
        let tinyBoardInclude = try XCTUnwrap(
            CoreAVRPackageSupport.files(for: tinyCore, documentationDirectory: tinyDocsDirectory)
                .first(where: { $0.relativePath == "board.include" })?
                .content
        )

        XCTAssertTrue(tinyBoardInclude.contains("RAM_SIZE=64"))
        XCTAssertTrue(tinyBoardInclude.contains("FLASH_SIZE=1024"))

        let readme = try String(contentsOf: readmeURL, encoding: .utf8)
        XCTAssertTrue(readme.contains("Generated by HALGEN from `ATmega328P.atdf`."))
        XCTAssertTrue(readme.contains("CPUCore, Interrupts, EEPROM"))
    }

    func testSPIGeneratorGeneratesATmega328PConvenienceAPI() throws {
        let device = try loadDevice(named: "ATmega328P")
        let loader = makeRepositoryDocsLoader()
        let generator = SPIGenerator()

        XCTAssertTrue(loader.loadGeneral())
        XCTAssertTrue(loader.load(chipName: "ATmega328P"))

        let files = loader.withPeripheralContext(named: generator.logName) {
            generator.generate(device: device, documentation: loader)
        }

        XCTAssertTrue(loader.generationLog.exported)
        XCTAssertEqual(Set(files.map(\.fileName)), ["SPI.swift", "SPI0.swift"])

        let spiFile = try XCTUnwrap(files.first(where: { $0.fileName == "SPI.swift" }))
        let spi0File = try XCTUnwrap(files.first(where: { $0.fileName == "SPI0.swift" }))

        XCTAssertTrue(spiFile.content.contains("public protocol SPIPort"))
        XCTAssertTrue(spiFile.content.contains("static var mode: SPI.Mode"))
        XCTAssertTrue(spiFile.content.contains("static var clockRateSelect: SPI.ClockRateSelect"))
        XCTAssertTrue(spiFile.content.contains("static func transfer(_ byte: UInt8) -> UInt8"))

        XCTAssertTrue(spi0File.content.contains("public struct SPI0: SPIPort"))
        XCTAssertTrue(spi0File.content.contains("public static var controlRegister: UInt8"))
        XCTAssertTrue(spi0File.content.contains("public static var statusRegister: UInt8"))
        XCTAssertTrue(spi0File.content.contains("public static var dataRegister: UInt8"))
        XCTAssertTrue(spi0File.content.contains("public static var interruptFlag: Bool"))
        XCTAssertFalse(spi0File.content.contains("public static var spiClockRateSelects"))

        let ssDirectionRange = try XCTUnwrap(spi0File.content.range(of: "GPIO.pb2.setDataDirection(.output) // SS"))
        let sckDirectionRange = try XCTUnwrap(spi0File.content.range(of: "GPIO.pb5.setDataDirection(.output) // SCK"))
        let mosiDirectionRange = try XCTUnwrap(spi0File.content.range(of: "GPIO.pb3.setDataDirection(.output) // MOSI"))
        let misoDirectionRange = try XCTUnwrap(spi0File.content.range(of: "GPIO.pb4.setDataDirection(.input) // MISO"))
        let masterModeRange = try XCTUnwrap(spi0File.content.range(of: "masterSlaveSelect = true"))

        XCTAssertLessThan(ssDirectionRange.lowerBound, masterModeRange.lowerBound)
        XCTAssertLessThan(sckDirectionRange.lowerBound, masterModeRange.lowerBound)
        XCTAssertLessThan(mosiDirectionRange.lowerBound, masterModeRange.lowerBound)
        XCTAssertLessThan(misoDirectionRange.lowerBound, masterModeRange.lowerBound)
    }

    func testSPIGeneratorGeneratesSettersForClassicSPIFlagsWhenSupplementalAccessAllowsWrite() throws {
        let device = try loadDevice(named: "ATmega328P")
        let loader = makeRepositoryDocsLoader()
        let generator = SPIGenerator()

        XCTAssertTrue(loader.loadGeneral())
        XCTAssertTrue(loader.load(chipName: "ATmega328P"))

        let files = loader.withPeripheralContext(named: generator.logName) {
            generator.generate(device: device, documentation: loader)
        }

        let spi0File = try XCTUnwrap(files.first(where: { $0.fileName == "SPI0.swift" }))

        XCTAssertTrue(spi0File.content.contains(
            """
            public static var interruptFlag: Bool {
                get {
                    let flag = (statusRegister & 0b10000000) >> UInt8(7)
                    return flag == 1
                }
                set {
            """
        ))
        XCTAssertTrue(spi0File.content.contains(
            """
            public static var writeCollisionFlag: Bool {
                get {
                    let flag = (statusRegister & 0b01000000) >> UInt8(6)
                    return flag == 1
                }
                set {
            """
        ))
    }

    func testSPIGeneratorDeduplicatesATmega328PBSPI0Registers() throws {
        let device = try loadDevice(named: "ATmega328PB")
        let loader = makeRepositoryDocsLoader()
        let generator = SPIGenerator()

        XCTAssertTrue(loader.loadGeneral())
        XCTAssertFalse(loader.load(chipName: "ATmega328PB"))

        let files = loader.withPeripheralContext(named: generator.logName) {
            generator.generate(device: device, documentation: loader)
        }

        XCTAssertTrue(loader.generationLog.exported)
        XCTAssertEqual(Set(files.map(\.fileName)), ["SPI.swift", "SPI0.swift", "SPI1.swift"])

        let spi0File = try XCTUnwrap(files.first(where: { $0.fileName == "SPI0.swift" }))
        let spi1File = try XCTUnwrap(files.first(where: { $0.fileName == "SPI1.swift" }))

        XCTAssertTrue(spi1File.content.contains("public struct SPI1: SPIPort"))
        XCTAssertEqual(occurrences(of: "public static var controlRegister: UInt8", in: spi0File.content), 1)
        XCTAssertEqual(occurrences(of: "public static var statusRegister: UInt8", in: spi0File.content), 1)
        XCTAssertEqual(occurrences(of: "public static var dataRegister: UInt8", in: spi0File.content), 1)
    }

    func testSPIGeneratorPrefersUnsuffixedRegistersForPlainSPIGroup() throws {
        let device = try loadDevice(named: "ATmega324P")
        let loader = makeRepositoryDocsLoader()
        let generator = SPIGenerator()

        XCTAssertTrue(loader.loadGeneral())
        XCTAssertFalse(loader.load(chipName: "ATmega324P"))

        let files = loader.withPeripheralContext(named: generator.logName) {
            generator.generate(device: device, documentation: loader)
        }

        XCTAssertTrue(loader.generationLog.exported)
        XCTAssertEqual(Set(files.map(\.fileName)), ["SPI.swift", "SPI0.swift"])

        let spi0File = try XCTUnwrap(files.first(where: { $0.fileName == "SPI0.swift" }))

        XCTAssertEqual(occurrences(of: "public static var controlRegister: UInt8", in: spi0File.content), 1)
        XCTAssertEqual(occurrences(of: "public static var statusRegister: UInt8", in: spi0File.content), 1)
        XCTAssertEqual(occurrences(of: "public static var dataRegister: UInt8", in: spi0File.content), 1)
        XCTAssertFalse(spi0File.content.contains("public static var spiClockRateSelect"))
    }

    func testTwoWireInterfaceGeneratorGeneratesATmega328PConvenienceAPI() throws {
        let device = try loadDevice(named: "ATmega328P")
        let loader = makeRepositoryDocsLoader()
        let generator = TwoWireInterfaceGenerator()

        XCTAssertTrue(loader.loadGeneral())
        XCTAssertTrue(loader.load(chipName: "ATmega328P"))

        let files = loader.withPeripheralContext(named: generator.logName) {
            generator.generate(device: device, documentation: loader)
        }

        XCTAssertTrue(loader.generationLog.exported)
        XCTAssertEqual(Set(files.map(\.fileName)), ["TwoWireInterface.swift", "TwoWireInterface0.swift"])

        let sharedFile = try XCTUnwrap(files.first(where: { $0.fileName == "TwoWireInterface.swift" }))
        let twi0File = try XCTUnwrap(files.first(where: { $0.fileName == "TwoWireInterface0.swift" }))

        XCTAssertTrue(sharedFile.content.contains("public enum TwoWire"))
        XCTAssertTrue(sharedFile.content.contains("public protocol TwoWireInterfacePort"))
        XCTAssertTrue(sharedFile.content.contains("static var TWIBitRateRegister: PortDataType"))
        XCTAssertTrue(sharedFile.content.contains("static var TWIControlRegister: UInt8"))
        XCTAssertTrue(sharedFile.content.contains("static var TWIStatusRegister: UInt8"))
        XCTAssertTrue(sharedFile.content.contains("static var TWIDataRegister: UInt8"))
        XCTAssertTrue(sharedFile.content.contains("static var TWISlaveAddressRegister: UInt8"))
        XCTAssertTrue(sharedFile.content.contains("static var TWISlaveAddressMaskRegister: UInt8"))
        XCTAssertTrue(sharedFile.content.contains("static var interruptFlag: Bool"))
        XCTAssertTrue(sharedFile.content.contains("static var prescaler: TwoWire.Prescaler"))
        XCTAssertTrue(sharedFile.content.contains("static var generalCallRecognitionEnable: Bool"))
        XCTAssertTrue(sharedFile.content.contains("static var slaveAddressMask: UInt8"))
        XCTAssertTrue(sharedFile.content.contains("case one = 1"))
        XCTAssertTrue(sharedFile.content.contains("case sixtyFour = 4"))
        XCTAssertFalse(sharedFile.content.contains("TwoWireInterfaceAddressMaskPort"))
        XCTAssertFalse(sharedFile.content.contains("static var bitRateRegister"))
        XCTAssertFalse(sharedFile.content.contains("static var controlRegister"))
        XCTAssertFalse(sharedFile.content.contains("static var statusRegister"))
        XCTAssertFalse(sharedFile.content.contains("static var dataRegister"))
        XCTAssertFalse(sharedFile.content.contains("static var slaveAddressRegister"))
        XCTAssertFalse(sharedFile.content.contains("static var slaveAddressMaskRegister"))

        XCTAssertTrue(twi0File.content.contains("public typealias TwoWireInterface = TwoWireInterface0"))
        XCTAssertTrue(twi0File.content.contains("public struct TwoWireInterface0: TwoWireInterfacePort"))
        XCTAssertTrue(twi0File.content.contains("public static var TWIBitRateRegister: UInt8"))
        XCTAssertTrue(twi0File.content.contains("public static var TWIControlRegister: UInt8"))
        XCTAssertTrue(twi0File.content.contains("public static var TWIStatusRegister: UInt8"))
        XCTAssertTrue(twi0File.content.contains("public static var TWIDataRegister: UInt8"))
        XCTAssertTrue(twi0File.content.contains("public static var TWISlaveAddressRegister: UInt8"))
        XCTAssertTrue(twi0File.content.contains("public static var TWISlaveAddressMaskRegister: UInt8"))
        XCTAssertFalse(twi0File.content.contains("public typealias twowireinterface0"))
    }

    func testTwoWireInterfaceGeneratorGeneratesMultipleClassicInstances() throws {
        let device = try loadDevice(named: "ATmega328PB")
        let loader = makeRepositoryDocsLoader()
        let generator = TwoWireInterfaceGenerator()

        XCTAssertTrue(loader.loadGeneral())
        XCTAssertFalse(loader.load(chipName: "ATmega328PB"))

        let files = loader.withPeripheralContext(named: generator.logName) {
            generator.generate(device: device, documentation: loader)
        }

        XCTAssertTrue(loader.generationLog.exported)
        XCTAssertEqual(
            Set(files.map(\.fileName)),
            ["TwoWireInterface.swift", "TwoWireInterface0.swift", "TwoWireInterface1.swift"]
        )

        let twi1File = try XCTUnwrap(files.first(where: { $0.fileName == "TwoWireInterface1.swift" }))

        XCTAssertFalse(twi1File.content.contains("public typealias TwoWireInterface = TwoWireInterface1"))
        XCTAssertTrue(twi1File.content.contains("public struct TwoWireInterface1: TwoWireInterfacePort"))
        XCTAssertEqual(occurrences(of: "public static var TWIBitRateRegister: UInt8", in: twi1File.content), 1)
        XCTAssertEqual(occurrences(of: "public static var TWIControlRegister: UInt8", in: twi1File.content), 1)
        XCTAssertEqual(occurrences(of: "public static var TWIStatusRegister: UInt8", in: twi1File.content), 1)
        XCTAssertEqual(occurrences(of: "public static var TWIDataRegister: UInt8", in: twi1File.content), 1)
        XCTAssertEqual(occurrences(of: "public static var TWISlaveAddressRegister: UInt8", in: twi1File.content), 1)
        XCTAssertEqual(occurrences(of: "public static var TWISlaveAddressMaskRegister: UInt8", in: twi1File.content), 1)
    }

    func testTwoWireInterfaceGeneratorSkipsNonClassicTWIModules() throws {
        let classicGenerator = TwoWireInterfaceGenerator()

        XCTAssertFalse(classicGenerator.supports(device: try loadDevice(named: "ATtiny816")))
        XCTAssertFalse(classicGenerator.supports(device: try loadDevice(named: "ATtiny1634")))
    }

    private func repositoryRootURL() -> URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    private func atdfURL(named chipName: String) -> URL {
        repositoryRootURL().appendingPathComponent("atdf/\(chipName).atdf")
    }

    private func makeDevice(withMemorySegmentsXML addressSpacesXML: String) throws -> AVRToolsDeviceFile {
        let xml = """
        <avr-tools-device-file>
            <variants>
                <variant ordercode="TEST" tempmin="0" tempmax="0" speedmax="1" package="TEST" vccmin="1.8" vccmax="5.5"/>
            </variants>
            <devices>
                <device name="TestDevice" architecture="AVR8" family="test">
                    <peripherals />
                    <address-spaces>
        \(indent(addressSpacesXML, by: 6))
                    </address-spaces>
                    <interfaces />
                    <property-groups />
                    <interrupts />
                </device>
            </devices>
            <modules />
        </avr-tools-device-file>
        """

        return try XMLDecoder().decode(AVRToolsDeviceFile.self, from: Data(xml.utf8))
    }

    private func loadDevice(named chipName: String) throws -> AVRToolsDeviceFile {
        let data = try Data(contentsOf: atdfURL(named: chipName))
        return try XMLDecoder().decode(AVRToolsDeviceFile.self, from: data)
    }

    private func makeRepositoryDocsLoader() -> ChipDocumentationLoader {
        let loader = ChipDocumentationLoader()
        loader.directory = repositoryRootURL().appendingPathComponent("docs")
        return loader
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

    private func writeMinimalBoilerplateTemplates(to docsDirectory: URL) throws {
        let boilerplateDirectory = docsDirectory.appendingPathComponent("boilerplate", isDirectory: true)
        try FileManager.default.createDirectory(at: boilerplateDirectory, withIntermediateDirectories: true)
        try write("", to: boilerplateDirectory.appendingPathComponent("UART.swift.template"))
        try write("", to: boilerplateDirectory.appendingPathComponent("SPI.swift.template"))
        try write("", to: boilerplateDirectory.appendingPathComponent("Timers.swift.template"))
        try write("", to: boilerplateDirectory.appendingPathComponent("TwoWireInterface.swift.template"))
        try write("{{STRUCT_DECLARATION}}", to: boilerplateDirectory.appendingPathComponent("AnalogToDigitalConverter.swift.template"))
    }

    private func occurrences(of substring: String, in string: String) -> Int {
        var count = 0
        var searchRange = string.startIndex..<string.endIndex

        while let range = string.range(of: substring, range: searchRange) {
            count += 1
            searchRange = range.upperBound..<string.endIndex
        }

        return count
    }

}
