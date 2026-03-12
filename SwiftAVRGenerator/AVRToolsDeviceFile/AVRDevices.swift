//
//  AVRDevices.swift
//  SwiftAVRGenerator
//
//  Created by HALGEN on 03/12/2026.
//

import Foundation
import XMLCoder
struct AVRDevices: Codable {
    let device: Device

    enum CodingKeys: String, CodingKey {
        case device
    }

    struct Device: Codable {
        @Attribute var name: String
        @Attribute var architecture: Architecture
        @Attribute var family: Family
        let propertyGroups: PropertyGroups
        let addressSpaces: AddressSpaces
        let interrupts: Interrupts
        let peripherals: Peripherals
        let interfaces: Interfaces
        let parameters: Parameters?

        enum CodingKeys: String, CodingKey {
            case name
            case architecture
            case family
            case propertyGroups = "property-groups"
            case addressSpaces = "address-spaces"
            case interrupts
            case peripherals
            case interfaces
            case parameters
        }

        struct Architecture: ATDFStringValue {
            static let AVR8 = Architecture(value: "AVR8")
            static let avr8 = AVR8
            static let AVR8X = Architecture(value: "AVR8X")
            static let avr8x = AVR8X
            static let AVR8L = Architecture(value: "AVR8L")
            static let avr8l = AVR8L

            let rawValue: String
            let alternateValues: [String]

            static let allCases: [Architecture] = [
                        AVR8,
                        AVR8X,
                        AVR8L
                    ]

            init(value: String, alternateValues: [String] = []) {
                self.rawValue = value
                self.alternateValues = alternateValues
            }
        }

        struct Family: ATDFStringValue {
            static let megaAVR = Family(value: "megaAVR")
            static let Megaavr = megaAVR
            static let tinyAVR = Family(value: "tinyAVR")
            static let Tinyavr = tinyAVR
            static let avrTINY = Family(value: "AVR TINY")
            static let avrTiny = avrTINY
            static let AVRTINY = avrTINY
            static let tinyAVR2 = Family(value: "tinyAVR 2")
            static let Tinyavr2 = tinyAVR2
            static let avrMEGA = Family(value: "AVR MEGA")
            static let avrMega = avrMEGA
            static let AVRMEGA = avrMEGA

            let rawValue: String
            let alternateValues: [String]

            static let allCases: [Family] = [
                        megaAVR,
                        tinyAVR,
                        avrTINY,
                        tinyAVR2,
                        avrMEGA
                    ]

            init(value: String, alternateValues: [String] = []) {
                self.rawValue = value
                self.alternateValues = alternateValues
            }
        }

        struct PropertyGroups: Codable {
            let propertyGroup: [PropertyGroup]

            enum CodingKeys: String, CodingKey {
                case propertyGroup = "property-group"
            }

            struct PropertyGroup: Codable {
                @Attribute var name: String
                let property: [Property]

                enum CodingKeys: String, CodingKey {
                    case name
                    case property
                }

                struct Property: Codable {
                    @Attribute var name: String
                    @Attribute var value: String
                    @Attribute var caption: Caption?

                    enum CodingKeys: String, CodingKey {
                        case name
                        case value
                        case caption
                    }

                    struct Caption: ATDFStringValue {
                        static let ioregSignatureForChangeProtect = Caption(value: "IOREG signature for Change Protect")
                        static let IOREGSignatureForChangeProtect = ioregSignatureForChangeProtect
                        static let spmSignatureForChangeProtect = Caption(value: "SPM signature for Change Protect")
                        static let SPMSignatureForChangeProtect = spmSignatureForChangeProtect

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Caption] = [
                                    ioregSignatureForChangeProtect,
                                    spmSignatureForChangeProtect
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }
                }
            }
        }

        struct AddressSpaces: Codable {
            let addressSpace: [AddressSpace]

            enum CodingKeys: String, CodingKey {
                case addressSpace = "address-space"
            }

            struct AddressSpace: Codable {
                @Attribute var endianness: Endianness
                @Attribute var name: Name
                @Attribute var id: ID
                @Attribute var start: Start
                @Attribute var size: Size
                let memorySegment: [MemorySegment]

                enum CodingKeys: String, CodingKey {
                    case endianness
                    case name
                    case id
                    case start
                    case size
                    case memorySegment = "memory-segment"
                }

                struct Endianness: ATDFStringValue {
                    static let little = Endianness(value: "little")
                    static let Little = little

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Endianness] = [
                                little
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Name: ATDFStringValue {
                    static let data = Name(value: "data")
                    static let Data = data
                    static let prog = Name(value: "prog")
                    static let Prog = prog
                    static let signatures = Name(value: "signatures")
                    static let Signatures = signatures
                    static let lockbits = Name(value: "lockbits")
                    static let Lockbits = lockbits
                    static let fuses = Name(value: "fuses")
                    static let Fuses = fuses
                    static let eeprom = Name(value: "eeprom")
                    static let Eeprom = eeprom
                    static let io = Name(value: "io")
                    static let Io = io
                    static let osccal = Name(value: "osccal")
                    static let Osccal = osccal
                    static let user_signatures = Name(value: "user_signatures")
                    static let userSignatures = user_signatures
                    static let UserSignatures = user_signatures

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Name] = [
                                data,
                                prog,
                                signatures,
                                lockbits,
                                fuses,
                                eeprom,
                                io,
                                osccal,
                                user_signatures
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct ID: ATDFStringValue {
                    static let data = ID(value: "data")
                    static let Data = data
                    static let prog = ID(value: "prog")
                    static let Prog = prog
                    static let signatures = ID(value: "signatures")
                    static let Signatures = signatures
                    static let lockbits = ID(value: "lockbits")
                    static let Lockbits = lockbits
                    static let fuses = ID(value: "fuses")
                    static let Fuses = fuses
                    static let eeprom = ID(value: "eeprom")
                    static let Eeprom = eeprom
                    static let io = ID(value: "io")
                    static let Io = io
                    static let osccal = ID(value: "osccal")
                    static let Osccal = osccal
                    static let user_signatures = ID(value: "user_signatures")
                    static let userSignatures = user_signatures
                    static let UserSignatures = user_signatures

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [ID] = [
                                data,
                                prog,
                                signatures,
                                lockbits,
                                fuses,
                                eeprom,
                                io,
                                osccal,
                                user_signatures
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Start: ATDFStringValue {
                    static let zero = Start(value: "0")
                    static let value0 = zero
                    static let zeroX0000 = Start(value: "0x0000")
                    static let value0x0000 = zeroX0000
                    static let zeroX00 = Start(value: "0x00")
                    static let value0x00 = zeroX00
                    static let zeroX0100 = Start(value: "0x0100")
                    static let value0x0100 = zeroX0100
                    static let zeroX = zeroX0000

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Start] = [
                                zero,
                                zeroX0000,
                                zeroX00,
                                zeroX0100
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Size: ATDFStringValue {
                    static let zeroX0001 = Size(value: "0x0001")
                    static let value0x0001 = zeroX0001
                    static let three = Size(value: "3")
                    static let value3 = three
                    static let zeroX40 = Size(value: "0x40")
                    static let value0x40 = zeroX40
                    static let zeroX0003 = Size(value: "0x0003")
                    static let value0x0003 = zeroX0003
                    static let one = Size(value: "1")
                    static let value1 = one
                    static let zeroX10000 = Size(value: "0x10000")
                    static let value0x10000 = zeroX10000
                    static let zeroX0200 = Size(value: "0x0200")
                    static let value0x0200 = zeroX0200
                    static let zeroX0400 = Size(value: "0x0400")
                    static let value0x0400 = zeroX0400
                    static let zeroX4000 = Size(value: "0x4000")
                    static let value0x4000 = zeroX4000
                    static let zeroX1000 = Size(value: "0x1000")
                    static let value0x1000 = zeroX1000
                    static let zeroX2000 = Size(value: "0x2000")
                    static let value0x2000 = zeroX2000
                    static let zeroX0800 = Size(value: "0x0800")
                    static let value0x0800 = zeroX0800
                    static let zeroX8000 = Size(value: "0x8000")
                    static let value0x8000 = zeroX8000
                    static let zeroX0900 = Size(value: "0x0900")
                    static let value0x0900 = zeroX0900
                    static let zeroX0300 = Size(value: "0x0300")
                    static let value0x0300 = zeroX0300
                    static let zeroX0500 = Size(value: "0x0500")
                    static let value0x0500 = zeroX0500
                    static let zeroX1100 = Size(value: "0x1100")
                    static let value0x1100 = zeroX1100
                    static let zeroX0002 = Size(value: "0x0002")
                    static let value0x0002 = zeroX0002
                    static let zeroX0100 = Size(value: "0x0100")
                    static let value0x0100 = zeroX0100
                    static let four = Size(value: "4")
                    static let value4 = four
                    static let zeroX20000 = Size(value: "0x20000")
                    static let value0x20000 = zeroX20000
                    static let two = Size(value: "2")
                    static let value2 = two
                    static let zeroX0040 = Size(value: "0x0040")
                    static let value0x0040 = zeroX0040
                    static let zeroX0080 = Size(value: "0x0080")
                    static let value0x0080 = zeroX0080
                    static let zeroX00e0 = Size(value: "0x00e0")
                    static let zeroX00E0 = zeroX00e0
                    static let value0x00e0 = zeroX00e0
                    static let zeroXC000 = Size(value: "0xC000")
                    static let zeroXc000 = zeroXC000
                    static let value0xC000 = zeroXC000
                    static let zeroX0160 = Size(value: "0x0160")
                    static let value0x0160 = zeroX0160
                    static let zeroX9000 = Size(value: "0x9000")
                    static let value0x9000 = zeroX9000
                    static let zeroX0260 = Size(value: "0x0260")
                    static let value0x0260 = zeroX0260
                    static let zeroXA000 = Size(value: "0xA000")
                    static let zeroXa000 = zeroXA000
                    static let value0xA000 = zeroXA000
                    static let zeroX4200 = Size(value: "0x4200")
                    static let value0x4200 = zeroX4200
                    static let zeroX40000 = Size(value: "0x40000")
                    static let value0x40000 = zeroX40000
                    static let zeroX0460 = Size(value: "0x0460")
                    static let value0x0460 = zeroX0460
                    static let zeroX4400 = Size(value: "0x4400")
                    static let value0x4400 = zeroX4400
                    static let zeroX8800 = Size(value: "0x8800")
                    static let value0x8800 = zeroX8800
                    static let zeroX00a0 = Size(value: "0x00a0")
                    static let zeroX00A0 = zeroX00a0
                    static let value0x00a0 = zeroX00a0
                    static let zeroX0860 = Size(value: "0x0860")
                    static let value0x0860 = zeroX0860
                    static let zeroX2200 = Size(value: "0x2200")
                    static let value0x2200 = zeroX2200
                    static let zeroX4100 = Size(value: "0x4100")
                    static let value0x4100 = zeroX4100
                    static let zeroX8200 = Size(value: "0x8200")
                    static let value0x8200 = zeroX8200
                    static let zeroX0600 = Size(value: "0x0600")
                    static let value0x0600 = zeroX0600
                    static let zeroX0b00 = Size(value: "0x0b00")
                    static let zeroX0B00 = zeroX0b00
                    static let value0x0b00 = zeroX0b00
                    static let zeroX4800 = Size(value: "0x4800")
                    static let value0x4800 = zeroX4800
                    static let zeroX5000 = Size(value: "0x5000")
                    static let value0x5000 = zeroX5000
                    static let zeroXa000Alt2 = Size(value: "0xa000")
                    static let value0xa000 = zeroXa000Alt2
                    static let zeroX = zeroX0001

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Size] = [
                                zeroX0001,
                                three,
                                zeroX40,
                                zeroX0003,
                                one,
                                zeroX10000,
                                zeroX0200,
                                zeroX0400,
                                zeroX4000,
                                zeroX1000,
                                zeroX2000,
                                zeroX0800,
                                zeroX8000,
                                zeroX0900,
                                zeroX0300,
                                zeroX0500,
                                zeroX1100,
                                zeroX0002,
                                zeroX0100,
                                four,
                                zeroX20000,
                                two,
                                zeroX0040,
                                zeroX0080,
                                zeroX00e0,
                                zeroXC000,
                                zeroX0160,
                                zeroX9000,
                                zeroX0260,
                                zeroXA000,
                                zeroX4200,
                                zeroX40000,
                                zeroX0460,
                                zeroX4400,
                                zeroX8800,
                                zeroX00a0,
                                zeroX0860,
                                zeroX2200,
                                zeroX4100,
                                zeroX8200,
                                zeroX0600,
                                zeroX0b00,
                                zeroX4800,
                                zeroX5000,
                                zeroXa000Alt2
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct MemorySegment: Codable {
                    @Attribute var start: Start
                    @Attribute var size: Size
                    @Attribute var type: Kind
                    @Attribute var rw: ReadWrite?
                    @Attribute var exec: Exec?
                    @Attribute var name: Name
                    @Attribute var pagesize: Pagesize?
                    @Attribute var external: Bool?

                    enum CodingKeys: String, CodingKey {
                        case start
                        case size
                        case type
                        case rw
                        case exec
                        case name
                        case pagesize
                        case external
                    }

                    struct Start: ATDFStringValue {
                        static let zero = Start(value: "0")
                        static let value0 = zero
                        static let zeroX0000 = Start(value: "0x0000")
                        static let value0x0000 = zeroX0000
                        static let zeroX0020 = Start(value: "0x0020")
                        static let value0x0020 = zeroX0020
                        static let zeroX0100 = Start(value: "0x0100")
                        static let value0x0100 = zeroX0100
                        static let zeroX00 = Start(value: "0x00")
                        static let value0x00 = zeroX00
                        static let zeroX1100 = Start(value: "0x1100")
                        static let value0x1100 = zeroX1100
                        static let zeroX1103 = Start(value: "0x1103")
                        static let value0x1103 = zeroX1103
                        static let zeroX1280 = Start(value: "0x1280")
                        static let value0x1280 = zeroX1280
                        static let zeroX128A = Start(value: "0x128A")
                        static let zeroX128a = zeroX128A
                        static let value0x128A = zeroX128A
                        static let zeroX1300 = Start(value: "0x1300")
                        static let value0x1300 = zeroX1300
                        static let zeroX1400 = Start(value: "0x1400")
                        static let value0x1400 = zeroX1400
                        static let zeroX8000 = Start(value: "0x8000")
                        static let value0x8000 = zeroX8000
                        static let zeroX3800 = Start(value: "0x3800")
                        static let value0x3800 = zeroX3800
                        static let zeroX7000 = Start(value: "0x7000")
                        static let value0x7000 = zeroX7000
                        static let zeroX7800 = Start(value: "0x7800")
                        static let value0x7800 = zeroX7800
                        static let zeroX7c00 = Start(value: "0x7c00")
                        static let zeroX7C00 = zeroX7c00
                        static let value0x7c00 = zeroX7c00
                        static let zeroX7e00 = Start(value: "0x7e00")
                        static let zeroX7E00 = zeroX7e00
                        static let value0x7e00 = zeroX7e00
                        static let zeroX0060 = Start(value: "0x0060")
                        static let value0x0060 = zeroX0060
                        static let zeroXe000 = Start(value: "0xe000")
                        static let zeroXE000 = zeroXe000
                        static let value0xe000 = zeroXe000
                        static let zeroXf000 = Start(value: "0xf000")
                        static let zeroXF000 = zeroXf000
                        static let value0xf000 = zeroXf000
                        static let zeroXf800 = Start(value: "0xf800")
                        static let zeroXF800 = zeroXf800
                        static let value0xf800 = zeroXf800
                        static let zeroXfc00 = Start(value: "0xfc00")
                        static let zeroXFC00 = zeroXfc00
                        static let value0xfc00 = zeroXfc00
                        static let zeroX3c00 = Start(value: "0x3c00")
                        static let zeroX3C00 = zeroX3c00
                        static let value0x3c00 = zeroX3c00
                        static let zeroX3e00 = Start(value: "0x3e00")
                        static let zeroX3E00 = zeroX3e00
                        static let value0x3e00 = zeroX3e00
                        static let zeroX3f00 = Start(value: "0x3f00")
                        static let zeroX3F00 = zeroX3f00
                        static let value0x3f00 = zeroX3f00
                        static let zeroX1800 = Start(value: "0x1800")
                        static let value0x1800 = zeroX1800
                        static let zeroX1c00 = Start(value: "0x1c00")
                        static let zeroX1C00 = zeroX1c00
                        static let value0x1c00 = zeroX1c00
                        static let zeroX1e00 = Start(value: "0x1e00")
                        static let zeroX1E00 = zeroX1e00
                        static let value0x1e00 = zeroX1e00
                        static let zeroX4000 = Start(value: "0x4000")
                        static let value0x4000 = zeroX4000
                        static let zeroX1f00 = Start(value: "0x1f00")
                        static let zeroX1F00 = zeroX1f00
                        static let value0x1f00 = zeroX1f00
                        static let zeroX3F00Alt2 = Start(value: "0x3F00")
                        static let value0x3F00 = zeroX3F00Alt2
                        static let zeroX1e000 = Start(value: "0x1e000")
                        static let zeroX1E000 = zeroX1e000
                        static let value0x1e000 = zeroX1e000
                        static let zeroX1f000 = Start(value: "0x1f000")
                        static let zeroX1F000 = zeroX1f000
                        static let value0x1f000 = zeroX1f000
                        static let zeroX1f800 = Start(value: "0x1f800")
                        static let zeroX1F800 = zeroX1f800
                        static let value0x1f800 = zeroX1f800
                        static let zeroX1fc00 = Start(value: "0x1fc00")
                        static let zeroX1FC00 = zeroX1fc00
                        static let value0x1fc00 = zeroX1fc00
                        static let zeroX0200 = Start(value: "0x0200")
                        static let value0x0200 = zeroX0200
                        static let zeroX3F80 = Start(value: "0x3F80")
                        static let zeroX3f80 = zeroX3F80
                        static let value0x3F80 = zeroX3F80
                        static let zeroX3000 = Start(value: "0x3000")
                        static let value0x3000 = zeroX3000
                        static let zeroX2200 = Start(value: "0x2200")
                        static let value0x2200 = zeroX2200
                        static let zeroX3E00Alt2 = Start(value: "0x3E00")
                        static let value0x3E00 = zeroX3E00Alt2
                        static let zeroX0040 = Start(value: "0x0040")
                        static let value0x0040 = zeroX0040
                        static let zeroX3C00Alt2 = Start(value: "0x3C00")
                        static let value0x3C00 = zeroX3C00Alt2
                        static let zeroX3F40 = Start(value: "0x3F40")
                        static let zeroX3f40 = zeroX3F40
                        static let value0x3F40 = zeroX3F40
                        static let zeroX3FC0 = Start(value: "0x3FC0")
                        static let zeroX3fc0 = zeroX3FC0
                        static let value0x3FC0 = zeroX3FC0
                        static let zeroX3e000 = Start(value: "0x3e000")
                        static let zeroX3E000 = zeroX3e000
                        static let value0x3e000 = zeroX3e000
                        static let zeroX3f000 = Start(value: "0x3f000")
                        static let zeroX3F000 = zeroX3f000
                        static let value0x3f000 = zeroX3f000
                        static let zeroX3f800 = Start(value: "0x3f800")
                        static let zeroX3F800 = zeroX3f800
                        static let value0x3f800 = zeroX3f800
                        static let zeroX3fc00 = Start(value: "0x3fc00")
                        static let zeroX3FC00 = zeroX3fc00
                        static let value0x3fc00 = zeroX3fc00
                        static let zeroX3400 = Start(value: "0x3400")
                        static let value0x3400 = zeroX3400
                        static let zeroX1000 = Start(value: "0x1000")
                        static let value0x1000 = zeroX1000
                        static let zeroX2800 = Start(value: "0x2800")
                        static let value0x2800 = zeroX2800
                        static let zeroX0260 = Start(value: "0x0260")
                        static let value0x0260 = zeroX0260
                        static let zeroX0500 = Start(value: "0x0500")
                        static let value0x0500 = zeroX0500
                        static let zeroX0900 = Start(value: "0x0900")
                        static let value0x0900 = zeroX0900
                        static let zeroX6000 = Start(value: "0x6000")
                        static let value0x6000 = zeroX6000
                        static let zeroX9000 = Start(value: "0x9000")
                        static let value0x9000 = zeroX9000
                        static let zeroX9800 = Start(value: "0x9800")
                        static let value0x9800 = zeroX9800
                        static let zeroX9c00 = Start(value: "0x9c00")
                        static let zeroX9C00 = zeroX9c00
                        static let value0x9c00 = zeroX9c00
                        static let zeroX9e00 = Start(value: "0x9e00")
                        static let zeroX9E00 = zeroX9e00
                        static let value0x9e00 = zeroX9e00
                        static let zeroX = zeroX0000

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Start] = [
                                    zero,
                                    zeroX0000,
                                    zeroX0020,
                                    zeroX0100,
                                    zeroX00,
                                    zeroX1100,
                                    zeroX1103,
                                    zeroX1280,
                                    zeroX128A,
                                    zeroX1300,
                                    zeroX1400,
                                    zeroX8000,
                                    zeroX3800,
                                    zeroX7000,
                                    zeroX7800,
                                    zeroX7c00,
                                    zeroX7e00,
                                    zeroX0060,
                                    zeroXe000,
                                    zeroXf000,
                                    zeroXf800,
                                    zeroXfc00,
                                    zeroX3c00,
                                    zeroX3e00,
                                    zeroX3f00,
                                    zeroX1800,
                                    zeroX1c00,
                                    zeroX1e00,
                                    zeroX4000,
                                    zeroX1f00,
                                    zeroX3F00Alt2,
                                    zeroX1e000,
                                    zeroX1f000,
                                    zeroX1f800,
                                    zeroX1fc00,
                                    zeroX0200,
                                    zeroX3F80,
                                    zeroX3000,
                                    zeroX2200,
                                    zeroX3E00Alt2,
                                    zeroX0040,
                                    zeroX3C00Alt2,
                                    zeroX3F40,
                                    zeroX3FC0,
                                    zeroX3e000,
                                    zeroX3f000,
                                    zeroX3f800,
                                    zeroX3fc00,
                                    zeroX3400,
                                    zeroX1000,
                                    zeroX2800,
                                    zeroX0260,
                                    zeroX0500,
                                    zeroX0900,
                                    zeroX6000,
                                    zeroX9000,
                                    zeroX9800,
                                    zeroX9c00,
                                    zeroX9e00
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Size: ATDFStringValue {
                        static let zeroX0400 = Size(value: "0x0400")
                        static let value0x0400 = zeroX0400
                        static let zeroX0800 = Size(value: "0x0800")
                        static let value0x0800 = zeroX0800
                        static let zeroX0001 = Size(value: "0x0001")
                        static let value0x0001 = zeroX0001
                        static let zeroX1000 = Size(value: "0x1000")
                        static let value0x1000 = zeroX1000
                        static let three = Size(value: "3")
                        static let value3 = three
                        static let zeroX0020 = Size(value: "0x0020")
                        static let value0x0020 = zeroX0020
                        static let zeroX0200 = Size(value: "0x0200")
                        static let value0x0200 = zeroX0200
                        static let zeroX0003 = Size(value: "0x0003")
                        static let value0x0003 = zeroX0003
                        static let one = Size(value: "1")
                        static let value1 = one
                        static let zeroX00e0 = Size(value: "0x00e0")
                        static let zeroX00E0 = zeroX00e0
                        static let value0x00e0 = zeroX00e0
                        static let zeroX2000 = Size(value: "0x2000")
                        static let value0x2000 = zeroX2000
                        static let zeroX0100 = Size(value: "0x0100")
                        static let value0x0100 = zeroX0100
                        static let zeroX4000 = Size(value: "0x4000")
                        static let value0x4000 = zeroX4000
                        static let zeroX8000 = Size(value: "0x8000")
                        static let value0x8000 = zeroX8000
                        static let zeroX1100 = Size(value: "0x1100")
                        static let value0x1100 = zeroX1100
                        static let zeroX01 = Size(value: "0x01")
                        static let value0x01 = zeroX01
                        static let zeroX03 = Size(value: "0x03")
                        static let value0x03 = zeroX03
                        static let zeroX0A = Size(value: "0x0A")
                        static let zeroX0a = zeroX0A
                        static let value0x0A = zeroX0A
                        static let zeroX20 = Size(value: "0x20")
                        static let value0x20 = zeroX20
                        static let zeroX0040 = Size(value: "0x0040")
                        static let value0x0040 = zeroX0040
                        static let zeroX0002 = Size(value: "0x0002")
                        static let value0x0002 = zeroX0002
                        static let zeroX3D = Size(value: "0x3D")
                        static let zeroX3d = zeroX3D
                        static let value0x3D = zeroX3D
                        static let zeroX100 = Size(value: "0x100")
                        static let value0x100 = zeroX100
                        static let zeroX10000 = Size(value: "0x10000")
                        static let value0x10000 = zeroX10000
                        static let zeroX80 = Size(value: "0x80")
                        static let value0x80 = zeroX80
                        static let zeroX800 = Size(value: "0x800")
                        static let value0x800 = zeroX800
                        static let zeroX40 = Size(value: "0x40")
                        static let value0x40 = zeroX40
                        static let zeroX0080 = Size(value: "0x0080")
                        static let value0x0080 = zeroX0080
                        static let four = Size(value: "4")
                        static let value4 = four
                        static let zeroX20000 = Size(value: "0x20000")
                        static let value0x20000 = zeroX20000
                        static let zeroX01e0 = Size(value: "0x01e0")
                        static let zeroX01E0 = zeroX01e0
                        static let value0x01e0 = zeroX01e0
                        static let two = Size(value: "2")
                        static let value2 = two
                        static let zeroXde00 = Size(value: "0xde00")
                        static let zeroXDE00 = zeroXde00
                        static let value0xde00 = zeroXde00
                        static let zeroX200 = Size(value: "0x200")
                        static let value0x200 = zeroX200
                        static let zeroX0004 = Size(value: "0x0004")
                        static let value0x0004 = zeroX0004
                        static let zeroX400 = Size(value: "0x400")
                        static let value0x400 = zeroX400
                        static let zeroXef00 = Size(value: "0xef00")
                        static let zeroXEF00 = zeroXef00
                        static let value0xef00 = zeroXef00
                        static let zeroX0300 = Size(value: "0x0300")
                        static let value0x0300 = zeroX0300
                        static let zeroX40000 = Size(value: "0x40000")
                        static let value0x40000 = zeroX40000
                        static let zeroXC000 = Size(value: "0xC000")
                        static let zeroXc000 = zeroXC000
                        static let value0xC000 = zeroXC000
                        static let zeroX7D = Size(value: "0x7D")
                        static let zeroX7d = zeroX7D
                        static let value0x7D = zeroX7D
                        static let zeroXC00 = Size(value: "0xC00")
                        static let zeroXc00 = zeroXC00
                        static let value0xC00 = zeroXC00
                        static let zeroX1800 = Size(value: "0x1800")
                        static let value0x1800 = zeroX1800
                        static let zeroX0500 = Size(value: "0x0500")
                        static let value0x0500 = zeroX0500
                        static let zeroX0a00 = Size(value: "0x0a00")
                        static let zeroX0A00 = zeroX0a00
                        static let value0x0a00 = zeroX0a00
                        static let zeroXa000 = Size(value: "0xa000")
                        static let zeroXA000 = zeroXa000
                        static let value0xa000 = zeroXa000
                        static let zeroXf700 = Size(value: "0xf700")
                        static let zeroXF700 = zeroXf700
                        static let value0xf700 = zeroXf700
                        static let zeroXfb00 = Size(value: "0xfb00")
                        static let zeroXFB00 = zeroXfb00
                        static let value0xfb00 = zeroXfb00
                        static let zeroXfda0 = Size(value: "0xfda0")
                        static let zeroXFDA0 = zeroXfda0
                        static let value0xfda0 = zeroXfda0
                        static let zeroX = zeroX0400

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Size] = [
                                    zeroX0400,
                                    zeroX0800,
                                    zeroX0001,
                                    zeroX1000,
                                    three,
                                    zeroX0020,
                                    zeroX0200,
                                    zeroX0003,
                                    one,
                                    zeroX00e0,
                                    zeroX2000,
                                    zeroX0100,
                                    zeroX4000,
                                    zeroX8000,
                                    zeroX1100,
                                    zeroX01,
                                    zeroX03,
                                    zeroX0A,
                                    zeroX20,
                                    zeroX0040,
                                    zeroX0002,
                                    zeroX3D,
                                    zeroX100,
                                    zeroX10000,
                                    zeroX80,
                                    zeroX800,
                                    zeroX40,
                                    zeroX0080,
                                    four,
                                    zeroX20000,
                                    zeroX01e0,
                                    two,
                                    zeroXde00,
                                    zeroX200,
                                    zeroX0004,
                                    zeroX400,
                                    zeroXef00,
                                    zeroX0300,
                                    zeroX40000,
                                    zeroXC000,
                                    zeroX7D,
                                    zeroXC00,
                                    zeroX1800,
                                    zeroX0500,
                                    zeroX0a00,
                                    zeroXa000,
                                    zeroXf700,
                                    zeroXfb00,
                                    zeroXfda0
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Kind: ATDFStringValue {
                        static let flash = Kind(value: "flash")
                        static let Flash = flash
                        static let signatures = Kind(value: "signatures")
                        static let Signatures = signatures
                        static let ram = Kind(value: "ram")
                        static let Ram = ram
                        static let lockbits = Kind(value: "lockbits")
                        static let Lockbits = lockbits
                        static let fuses = Kind(value: "fuses")
                        static let Fuses = fuses
                        static let io = Kind(value: "io")
                        static let Io = io
                        static let eeprom = Kind(value: "eeprom")
                        static let Eeprom = eeprom
                        static let regs = Kind(value: "regs")
                        static let Regs = regs
                        static let osccal = Kind(value: "osccal")
                        static let Osccal = osccal
                        static let user_signatures = Kind(value: "user_signatures")
                        static let userSignatures = user_signatures
                        static let UserSignatures = user_signatures
                        static let other = Kind(value: "other")
                        static let Other = other
                        static let sysreg = Kind(value: "sysreg")
                        static let Sysreg = sysreg

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Kind] = [
                                    flash,
                                    signatures,
                                    ram,
                                    lockbits,
                                    fuses,
                                    io,
                                    eeprom,
                                    regs,
                                    osccal,
                                    user_signatures,
                                    other,
                                    sysreg
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct ReadWrite: ATDFStringValue {
                        static let RW = ReadWrite(value: "RW")
                        static let rw = RW
                        static let R = ReadWrite(value: "R")
                        static let r = R

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [ReadWrite] = [
                                    RW,
                                    R
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Exec: ATDFStringValue {
                        static let zero = Exec(value: "0")
                        static let value0 = zero
                        static let one = Exec(value: "1")
                        static let value1 = one

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Exec] = [
                                    zero,
                                    one
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Name: ATDFStringValue {
                        static let SIGNATURES = Name(value: "SIGNATURES")
                        static let signatures = SIGNATURES
                        static let LOCKBITS = Name(value: "LOCKBITS")
                        static let lockbits = LOCKBITS
                        static let FUSES = Name(value: "FUSES")
                        static let fuses = FUSES
                        static let EEPROM = Name(value: "EEPROM")
                        static let eeprom = EEPROM
                        static let FLASH = Name(value: "FLASH")
                        static let flash = FLASH
                        static let REGISTERS = Name(value: "REGISTERS")
                        static let registers = REGISTERS
                        static let MAPPED_IO = Name(value: "MAPPED_IO")
                        static let mappedIO = MAPPED_IO
                        static let mappedIo = MAPPED_IO
                        static let MAPPEDIO = MAPPED_IO
                        static let IRAM = Name(value: "IRAM")
                        static let iram = IRAM
                        static let OSCCAL = Name(value: "OSCCAL")
                        static let osccal = OSCCAL
                        static let BOOT_SECTION_1 = Name(value: "BOOT_SECTION_1")
                        static let bootSection1 = BOOT_SECTION_1
                        static let BOOTSECTION1 = BOOT_SECTION_1
                        static let BOOT_SECTION_2 = Name(value: "BOOT_SECTION_2")
                        static let bootSection2 = BOOT_SECTION_2
                        static let BOOTSECTION2 = BOOT_SECTION_2
                        static let BOOT_SECTION_3 = Name(value: "BOOT_SECTION_3")
                        static let bootSection3 = BOOT_SECTION_3
                        static let BOOTSECTION3 = BOOT_SECTION_3
                        static let BOOT_SECTION_4 = Name(value: "BOOT_SECTION_4")
                        static let bootSection4 = BOOT_SECTION_4
                        static let BOOTSECTION4 = BOOT_SECTION_4
                        static let IO = Name(value: "IO")
                        static let io = IO
                        static let USER_SIGNATURES = Name(value: "USER_SIGNATURES")
                        static let userSignatures = USER_SIGNATURES
                        static let USERSIGNATURES = USER_SIGNATURES
                        static let PROD_SIGNATURES = Name(value: "PROD_SIGNATURES")
                        static let prodSignatures = PROD_SIGNATURES
                        static let PRODSIGNATURES = PROD_SIGNATURES
                        static let MAPPED_PROGMEM = Name(value: "MAPPED_PROGMEM")
                        static let mappedProgmem = MAPPED_PROGMEM
                        static let MAPPEDPROGMEM = MAPPED_PROGMEM
                        static let INTERNAL_SRAM = Name(value: "INTERNAL_SRAM")
                        static let internalSRAM = INTERNAL_SRAM
                        static let internalSram = INTERNAL_SRAM
                        static let INTERNALSRAM = INTERNAL_SRAM
                        static let PROGMEM = Name(value: "PROGMEM")
                        static let progmem = PROGMEM
                        static let XRAM = Name(value: "XRAM")
                        static let xram = XRAM
                        static let MAPPED_CONFIGURATION_BITS = Name(value: "MAPPED_CONFIGURATION_BITS")
                        static let mappedConfigurationBITS = MAPPED_CONFIGURATION_BITS
                        static let mappedConfigurationBits = MAPPED_CONFIGURATION_BITS
                        static let MAPPEDCONFIGURATIONBITS = MAPPED_CONFIGURATION_BITS
                        static let MAPPED_CALIBRATION_BITS = Name(value: "MAPPED_CALIBRATION_BITS")
                        static let mappedCalibrationBITS = MAPPED_CALIBRATION_BITS
                        static let mappedCalibrationBits = MAPPED_CALIBRATION_BITS
                        static let MAPPEDCALIBRATIONBITS = MAPPED_CALIBRATION_BITS
                        static let MAPPED_DEVICE_ID_BITS = Name(value: "MAPPED_DEVICE_ID_BITS")
                        static let mappedDeviceIDBITS = MAPPED_DEVICE_ID_BITS
                        static let mappedDeviceIdBits = MAPPED_DEVICE_ID_BITS
                        static let MAPPEDDEVICEIDBITS = MAPPED_DEVICE_ID_BITS
                        static let MAPPED_NVM_LOCK_BITS = Name(value: "MAPPED_NVM_LOCK_BITS")
                        static let mappedNVMLOCKBITS = MAPPED_NVM_LOCK_BITS
                        static let mappedNvmLockBits = MAPPED_NVM_LOCK_BITS
                        static let MAPPEDNVMLOCKBITS = MAPPED_NVM_LOCK_BITS
                        static let MAPPED_FLASH = Name(value: "MAPPED_FLASH")
                        static let mappedFlash = MAPPED_FLASH
                        static let MAPPEDFLASH = MAPPED_FLASH
                        static let SRAM = Name(value: "SRAM")
                        static let sram = SRAM

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Name] = [
                                    SIGNATURES,
                                    LOCKBITS,
                                    FUSES,
                                    EEPROM,
                                    FLASH,
                                    REGISTERS,
                                    MAPPED_IO,
                                    IRAM,
                                    OSCCAL,
                                    BOOT_SECTION_1,
                                    BOOT_SECTION_2,
                                    BOOT_SECTION_3,
                                    BOOT_SECTION_4,
                                    IO,
                                    USER_SIGNATURES,
                                    PROD_SIGNATURES,
                                    MAPPED_PROGMEM,
                                    INTERNAL_SRAM,
                                    PROGMEM,
                                    XRAM,
                                    MAPPED_CONFIGURATION_BITS,
                                    MAPPED_CALIBRATION_BITS,
                                    MAPPED_DEVICE_ID_BITS,
                                    MAPPED_NVM_LOCK_BITS,
                                    MAPPED_FLASH,
                                    SRAM
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Pagesize: ATDFStringValue {
                        static let zeroX80 = Pagesize(value: "0x80")
                        static let value0x80 = zeroX80
                        static let zeroX40 = Pagesize(value: "0x40")
                        static let value0x40 = zeroX40
                        static let zeroX100 = Pagesize(value: "0x100")
                        static let value0x100 = zeroX100
                        static let zeroX20 = Pagesize(value: "0x20")
                        static let value0x20 = zeroX20
                        static let zeroX04 = Pagesize(value: "0x04")
                        static let value0x04 = zeroX04
                        static let zeroX08 = Pagesize(value: "0x08")
                        static let value0x08 = zeroX08
                        static let zeroX02 = Pagesize(value: "0x02")
                        static let value0x02 = zeroX02
                        static let zeroX10 = Pagesize(value: "0x10")
                        static let value0x10 = zeroX10
                        static let zeroX = zeroX80

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Pagesize] = [
                                    zeroX80,
                                    zeroX40,
                                    zeroX100,
                                    zeroX20,
                                    zeroX04,
                                    zeroX08,
                                    zeroX02,
                                    zeroX10
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }
                }
            }
        }

        struct Interrupts: Codable {
            let interrupt: [Interrupt]

            enum CodingKeys: String, CodingKey {
                case interrupt
            }

            struct Interrupt: Codable {
                @Attribute var index: Index
                @Attribute var name: Name
                @Attribute var caption: Caption?
                @Attribute var moduleInstance: ModuleInstance?

                enum CodingKeys: String, CodingKey {
                    case index
                    case name
                    case caption
                    case moduleInstance = "module-instance"
                }

                struct Index: ATDFStringValue {
                    static let ten = Index(value: "10")
                    static let value10 = ten
                    static let eleven = Index(value: "11")
                    static let value11 = eleven
                    static let eight = Index(value: "8")
                    static let value8 = eight
                    static let twelve = Index(value: "12")
                    static let value12 = twelve
                    static let seven = Index(value: "7")
                    static let value7 = seven
                    static let nine = Index(value: "9")
                    static let value9 = nine
                    static let one = Index(value: "1")
                    static let value1 = one
                    static let two = Index(value: "2")
                    static let value2 = two
                    static let three = Index(value: "3")
                    static let value3 = three
                    static let six = Index(value: "6")
                    static let value6 = six
                    static let four = Index(value: "4")
                    static let value4 = four
                    static let thirteen = Index(value: "13")
                    static let value13 = thirteen
                    static let five = Index(value: "5")
                    static let value5 = five
                    static let fourteen = Index(value: "14")
                    static let value14 = fourteen
                    static let sixteen = Index(value: "16")
                    static let value16 = sixteen
                    static let fifteen = Index(value: "15")
                    static let value15 = fifteen
                    static let seventeen = Index(value: "17")
                    static let value17 = seventeen
                    static let eighteen = Index(value: "18")
                    static let value18 = eighteen
                    static let nineteen = Index(value: "19")
                    static let value19 = nineteen
                    static let twenty = Index(value: "20")
                    static let value20 = twenty
                    static let zero = Index(value: "0")
                    static let value0 = zero
                    static let twentyOne = Index(value: "21")
                    static let value21 = twentyOne
                    static let twentyTwo = Index(value: "22")
                    static let value22 = twentyTwo
                    static let twentyFour = Index(value: "24")
                    static let value24 = twentyFour
                    static let twentyThree = Index(value: "23")
                    static let value23 = twentyThree
                    static let twentyFive = Index(value: "25")
                    static let value25 = twentyFive
                    static let twentySix = Index(value: "26")
                    static let value26 = twentySix
                    static let twentySeven = Index(value: "27")
                    static let value27 = twentySeven
                    static let twentyEight = Index(value: "28")
                    static let value28 = twentyEight
                    static let twentyNine = Index(value: "29")
                    static let value29 = twentyNine
                    static let thirty = Index(value: "30")
                    static let value30 = thirty
                    static let thirtyOne = Index(value: "31")
                    static let value31 = thirtyOne
                    static let thirtyTwo = Index(value: "32")
                    static let value32 = thirtyTwo
                    static let thirtyThree = Index(value: "33")
                    static let value33 = thirtyThree
                    static let thirtyFour = Index(value: "34")
                    static let value34 = thirtyFour
                    static let thirtyFive = Index(value: "35")
                    static let value35 = thirtyFive
                    static let thirtySix = Index(value: "36")
                    static let value36 = thirtySix
                    static let thirtySeven = Index(value: "37")
                    static let value37 = thirtySeven
                    static let thirtyEight = Index(value: "38")
                    static let value38 = thirtyEight
                    static let thirtyNine = Index(value: "39")
                    static let value39 = thirtyNine
                    static let forty = Index(value: "40")
                    static let value40 = forty
                    static let fortyOne = Index(value: "41")
                    static let value41 = fortyOne
                    static let fortyTwo = Index(value: "42")
                    static let value42 = fortyTwo
                    static let fortyThree = Index(value: "43")
                    static let value43 = fortyThree
                    static let fortyFour = Index(value: "44")
                    static let value44 = fortyFour
                    static let fifty = Index(value: "50")
                    static let value50 = fifty
                    static let fortyFive = Index(value: "45")
                    static let value45 = fortyFive
                    static let fortySix = Index(value: "46")
                    static let value46 = fortySix
                    static let fortySeven = Index(value: "47")
                    static let value47 = fortySeven
                    static let fortyEight = Index(value: "48")
                    static let value48 = fortyEight
                    static let fortyNine = Index(value: "49")
                    static let value49 = fortyNine
                    static let fiftySeven = Index(value: "57")
                    static let value57 = fiftySeven
                    static let fiftyEight = Index(value: "58")
                    static let value58 = fiftyEight
                    static let fiftyNine = Index(value: "59")
                    static let value59 = fiftyNine
                    static let sixty = Index(value: "60")
                    static let value60 = sixty
                    static let sixtyOne = Index(value: "61")
                    static let value61 = sixtyOne
                    static let sixtyTwo = Index(value: "62")
                    static let value62 = sixtyTwo
                    static let sixtyThree = Index(value: "63")
                    static let value63 = sixtyThree
                    static let sixtyFour = Index(value: "64")
                    static let value64 = sixtyFour
                    static let sixtyFive = Index(value: "65")
                    static let value65 = sixtyFive
                    static let sixtySix = Index(value: "66")
                    static let value66 = sixtySix
                    static let sixtySeven = Index(value: "67")
                    static let value67 = sixtySeven
                    static let sixtyEight = Index(value: "68")
                    static let value68 = sixtyEight
                    static let sixtyNine = Index(value: "69")
                    static let value69 = sixtyNine
                    static let seventy = Index(value: "70")
                    static let value70 = seventy
                    static let seventyOne = Index(value: "71")
                    static let value71 = seventyOne
                    static let fiftyOne = Index(value: "51")
                    static let value51 = fiftyOne
                    static let fiftyTwo = Index(value: "52")
                    static let value52 = fiftyTwo
                    static let fiftyThree = Index(value: "53")
                    static let value53 = fiftyThree
                    static let fiftyFour = Index(value: "54")
                    static let value54 = fiftyFour
                    static let fiftyFive = Index(value: "55")
                    static let value55 = fiftyFive
                    static let fiftySix = Index(value: "56")
                    static let value56 = fiftySix
                    static let seventyTwo = Index(value: "72")
                    static let value72 = seventyTwo
                    static let seventyThree = Index(value: "73")
                    static let value73 = seventyThree
                    static let seventyFour = Index(value: "74")
                    static let value74 = seventyFour
                    static let seventyFive = Index(value: "75")
                    static let value75 = seventyFive
                    static let seventySix = Index(value: "76")
                    static let value76 = seventySix

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Index] = [
                                ten,
                                eleven,
                                eight,
                                twelve,
                                seven,
                                nine,
                                one,
                                two,
                                three,
                                six,
                                four,
                                thirteen,
                                five,
                                fourteen,
                                sixteen,
                                fifteen,
                                seventeen,
                                eighteen,
                                nineteen,
                                twenty,
                                zero,
                                twentyOne,
                                twentyTwo,
                                twentyFour,
                                twentyThree,
                                twentyFive,
                                twentySix,
                                twentySeven,
                                twentyEight,
                                twentyNine,
                                thirty,
                                thirtyOne,
                                thirtyTwo,
                                thirtyThree,
                                thirtyFour,
                                thirtyFive,
                                thirtySix,
                                thirtySeven,
                                thirtyEight,
                                thirtyNine,
                                forty,
                                fortyOne,
                                fortyTwo,
                                fortyThree,
                                fortyFour,
                                fifty,
                                fortyFive,
                                fortySix,
                                fortySeven,
                                fortyEight,
                                fortyNine,
                                fiftySeven,
                                fiftyEight,
                                fiftyNine,
                                sixty,
                                sixtyOne,
                                sixtyTwo,
                                sixtyThree,
                                sixtyFour,
                                sixtyFive,
                                sixtySix,
                                sixtySeven,
                                sixtyEight,
                                sixtyNine,
                                seventy,
                                seventyOne,
                                fiftyOne,
                                fiftyTwo,
                                fiftyThree,
                                fiftyFour,
                                fiftyFive,
                                fiftySix,
                                seventyTwo,
                                seventyThree,
                                seventyFour,
                                seventyFive,
                                seventySix
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Name: ATDFStringValue {
                    static let RESET = Name(value: "RESET")
                    static let reset = RESET
                    static let INT0 = Name(value: "INT0")
                    static let int0 = INT0
                    static let TIMER0_OVF = Name(value: "TIMER0_OVF")
                    static let timer0OVF = TIMER0_OVF
                    static let timer0Ovf = TIMER0_OVF
                    static let TIMER0OVF = TIMER0_OVF
                    static let TIMER1_OVF = Name(value: "TIMER1_OVF")
                    static let timer1OVF = TIMER1_OVF
                    static let timer1Ovf = TIMER1_OVF
                    static let TIMER1OVF = TIMER1_OVF
                    static let PORT = Name(value: "PORT")
                    static let port = PORT
                    static let ADC = Name(value: "ADC")
                    static let adc = ADC
                    static let TIMER1_COMPA = Name(value: "TIMER1_COMPA")
                    static let timer1Compa = TIMER1_COMPA
                    static let TIMER1COMPA = TIMER1_COMPA
                    static let TIMER1_COMPB = Name(value: "TIMER1_COMPB")
                    static let timer1Compb = TIMER1_COMPB
                    static let TIMER1COMPB = TIMER1_COMPB
                    static let TIMER1_CAPT = Name(value: "TIMER1_CAPT")
                    static let timer1CAPT = TIMER1_CAPT
                    static let timer1Capt = TIMER1_CAPT
                    static let TIMER1CAPT = TIMER1_CAPT
                    static let PCINT0 = Name(value: "PCINT0")
                    static let pcint0 = PCINT0
                    static let SPI_STC = Name(value: "SPI_STC")
                    static let spiSTC = SPI_STC
                    static let spiStc = SPI_STC
                    static let SPISTC = SPI_STC
                    static let INT = Name(value: "INT")
                    static let int = INT
                    static let EE_READY = Name(value: "EE_READY")
                    static let eeReady = EE_READY
                    static let EEREADY = EE_READY
                    static let PCINT1 = Name(value: "PCINT1")
                    static let pcint1 = PCINT1
                    static let WDT = Name(value: "WDT")
                    static let wdt = WDT
                    static let INT1 = Name(value: "INT1")
                    static let int1 = INT1
                    static let ANALOG_COMP = Name(value: "ANALOG_COMP")
                    static let analogCOMP = ANALOG_COMP
                    static let analogComp = ANALOG_COMP
                    static let ANALOGCOMP = ANALOG_COMP
                    static let TIMER2_OVF = Name(value: "TIMER2_OVF")
                    static let timer2OVF = TIMER2_OVF
                    static let timer2Ovf = TIMER2_OVF
                    static let TIMER2OVF = TIMER2_OVF
                    static let SPM_READY = Name(value: "SPM_READY")
                    static let spmReady = SPM_READY
                    static let SPMREADY = SPM_READY
                    static let TIMER0_COMPB = Name(value: "TIMER0_COMPB")
                    static let timer0Compb = TIMER0_COMPB
                    static let TIMER0COMPB = TIMER0_COMPB
                    static let TIMER0_COMPA = Name(value: "TIMER0_COMPA")
                    static let timer0Compa = TIMER0_COMPA
                    static let TIMER0COMPA = TIMER0_COMPA
                    static let DRE = Name(value: "DRE")
                    static let dre = DRE
                    static let RXC = Name(value: "RXC")
                    static let rxc = RXC
                    static let TXC = Name(value: "TXC")
                    static let txc = TXC
                    static let INT2 = Name(value: "INT2")
                    static let int2 = INT2
                    static let USART0_TX = Name(value: "USART0_TX")
                    static let usart0TX = USART0_TX
                    static let usart0Tx = USART0_TX
                    static let USART0TX = USART0_TX
                    static let TWI = Name(value: "TWI")
                    static let twi = TWI
                    static let PCINT2 = Name(value: "PCINT2")
                    static let pcint2 = PCINT2
                    static let OVF = Name(value: "OVF")
                    static let ovf = OVF
                    static let USART0_UDRE = Name(value: "USART0_UDRE")
                    static let usart0UDRE = USART0_UDRE
                    static let usart0Udre = USART0_UDRE
                    static let USART0UDRE = USART0_UDRE
                    static let USART0_RX = Name(value: "USART0_RX")
                    static let usart0RX = USART0_RX
                    static let usart0Rx = USART0_RX
                    static let USART0RX = USART0_RX
                    static let AC = Name(value: "AC")
                    static let ac = AC
                    static let VLM = Name(value: "VLM")
                    static let vlm = VLM
                    static let TIMER2_COMP = Name(value: "TIMER2_COMP")
                    static let timer2COMP = TIMER2_COMP
                    static let timer2Comp = TIMER2_COMP
                    static let TIMER2COMP = TIMER2_COMP
                    static let USI_START = Name(value: "USI_START")
                    static let usiStart = USI_START
                    static let USISTART = USI_START
                    static let RESRDY = Name(value: "RESRDY")
                    static let resrdy = RESRDY
                    static let TIMER2_COMPA = Name(value: "TIMER2_COMPA")
                    static let timer2Compa = TIMER2_COMPA
                    static let TIMER2COMPA = TIMER2_COMPA
                    static let TIMER2_COMPB = Name(value: "TIMER2_COMPB")
                    static let timer2Compb = TIMER2_COMPB
                    static let TIMER2COMPB = TIMER2_COMPB
                    static let TIMER0_COMP = Name(value: "TIMER0_COMP")
                    static let timer0COMP = TIMER0_COMP
                    static let timer0Comp = TIMER0_COMP
                    static let TIMER0COMP = TIMER0_COMP
                    static let USART_UDRE = Name(value: "USART_UDRE")
                    static let usartUDRE = USART_UDRE
                    static let usartUdre = USART_UDRE
                    static let USARTUDRE = USART_UDRE
                    static let USART1_UDRE = Name(value: "USART1_UDRE")
                    static let usart1UDRE = USART1_UDRE
                    static let usart1Udre = USART1_UDRE
                    static let USART1UDRE = USART1_UDRE
                    static let INT3 = Name(value: "INT3")
                    static let int3 = INT3
                    static let USART1_RX = Name(value: "USART1_RX")
                    static let usart1RX = USART1_RX
                    static let usart1Rx = USART1_RX
                    static let USART1RX = USART1_RX
                    static let USART1_TX = Name(value: "USART1_TX")
                    static let usart1TX = USART1_TX
                    static let usart1Tx = USART1_TX
                    static let USART1TX = USART1_TX
                    static let ANA_COMP = Name(value: "ANA_COMP")
                    static let anaCOMP = ANA_COMP
                    static let anaComp = ANA_COMP
                    static let ANACOMP = ANA_COMP
                    static let LCMP0 = Name(value: "LCMP0")
                    static let lcmp0 = LCMP0
                    static let LCMP1 = Name(value: "LCMP1")
                    static let lcmp1 = LCMP1
                    static let LCMP2 = Name(value: "LCMP2")
                    static let lcmp2 = LCMP2
                    static let CMP0 = Name(value: "CMP0")
                    static let cmp0 = CMP0
                    static let CMP1 = Name(value: "CMP1")
                    static let cmp1 = CMP1
                    static let CMP2 = Name(value: "CMP2")
                    static let cmp2 = CMP2
                    static let HUNF = Name(value: "HUNF")
                    static let hunf = HUNF
                    static let LUNF = Name(value: "LUNF")
                    static let lunf = LUNF
                    static let TWIM = Name(value: "TWIM")
                    static let twim = TWIM
                    static let TWIS = Name(value: "TWIS")
                    static let twis = TWIS
                    static let CNT = Name(value: "CNT")
                    static let cnt = CNT
                    static let NMI = Name(value: "NMI")
                    static let nmi = NMI
                    static let PIT = Name(value: "PIT")
                    static let pit = PIT
                    static let EE = Name(value: "EE")
                    static let ee = EE
                    static let USART_RX = Name(value: "USART_RX")
                    static let usartRX = USART_RX
                    static let usartRx = USART_RX
                    static let USARTRX = USART_RX
                    static let USI_OVERFLOW = Name(value: "USI_OVERFLOW")
                    static let usiOverflow = USI_OVERFLOW
                    static let USIOVERFLOW = USI_OVERFLOW
                    static let WCOMP = Name(value: "WCOMP")
                    static let wcomp = WCOMP
                    static let PCINT3 = Name(value: "PCINT3")
                    static let pcint3 = PCINT3
                    static let EE_RDY = Name(value: "EE_RDY")
                    static let eeRDY = EE_RDY
                    static let eeRdy = EE_RDY
                    static let EERDY = EE_RDY
                    static let TIMER1_COMPC = Name(value: "TIMER1_COMPC")
                    static let timer1Compc = TIMER1_COMPC
                    static let TIMER1COMPC = TIMER1_COMPC
                    static let TIMER3_COMPA = Name(value: "TIMER3_COMPA")
                    static let timer3Compa = TIMER3_COMPA
                    static let TIMER3COMPA = TIMER3_COMPA
                    static let TIMER3_COMPB = Name(value: "TIMER3_COMPB")
                    static let timer3Compb = TIMER3_COMPB
                    static let TIMER3COMPB = TIMER3_COMPB
                    static let TIMER3_CAPT = Name(value: "TIMER3_CAPT")
                    static let timer3CAPT = TIMER3_CAPT
                    static let timer3Capt = TIMER3_CAPT
                    static let TIMER3CAPT = TIMER3_CAPT
                    static let TIMER3_OVF = Name(value: "TIMER3_OVF")
                    static let timer3OVF = TIMER3_OVF
                    static let timer3Ovf = TIMER3_OVF
                    static let TIMER3OVF = TIMER3_OVF
                    static let INT6 = Name(value: "INT6")
                    static let int6 = INT6
                    static let USART_TX = Name(value: "USART_TX")
                    static let usartTX = USART_TX
                    static let usartTx = USART_TX
                    static let USARTTX = USART_TX
                    static let INT4 = Name(value: "INT4")
                    static let int4 = INT4
                    static let INT5 = Name(value: "INT5")
                    static let int5 = INT5
                    static let INT7 = Name(value: "INT7")
                    static let int7 = INT7
                    static let TIMER3_COMPC = Name(value: "TIMER3_COMPC")
                    static let timer3Compc = TIMER3_COMPC
                    static let TIMER3COMPC = TIMER3_COMPC
                    static let USI_OVF = Name(value: "USI_OVF")
                    static let usiOVF = USI_OVF
                    static let usiOvf = USI_OVF
                    static let USIOVF = USI_OVF
                    static let CCL = Name(value: "CCL")
                    static let ccl = CCL
                    static let TIM0_COMPA = Name(value: "TIM0_COMPA")
                    static let tim0Compa = TIM0_COMPA
                    static let TIM0COMPA = TIM0_COMPA
                    static let TIM0_COMPB = Name(value: "TIM0_COMPB")
                    static let tim0Compb = TIM0_COMPB
                    static let TIM0COMPB = TIM0_COMPB
                    static let TIM0_OVF = Name(value: "TIM0_OVF")
                    static let tim0OVF = TIM0_OVF
                    static let tim0Ovf = TIM0_OVF
                    static let TIM0OVF = TIM0_OVF
                    static let SPM_Ready = Name(value: "SPM_Ready")
                    static let SPMReady = SPM_Ready
                    static let LCD = Name(value: "LCD")
                    static let lcd = LCD
                    static let TIMER4_COMPA = Name(value: "TIMER4_COMPA")
                    static let timer4Compa = TIMER4_COMPA
                    static let TIMER4COMPA = TIMER4_COMPA
                    static let TIMER4_COMPB = Name(value: "TIMER4_COMPB")
                    static let timer4Compb = TIMER4_COMPB
                    static let TIMER4COMPB = TIMER4_COMPB
                    static let TIMER4_OVF = Name(value: "TIMER4_OVF")
                    static let timer4OVF = TIMER4_OVF
                    static let timer4Ovf = TIMER4_OVF
                    static let TIMER4OVF = TIMER4_OVF
                    static let TIMER4_CAPT = Name(value: "TIMER4_CAPT")
                    static let timer4CAPT = TIMER4_CAPT
                    static let timer4Capt = TIMER4_CAPT
                    static let TIMER4CAPT = TIMER4_CAPT
                    static let TRIG = Name(value: "TRIG")
                    static let trig = TRIG
                    static let TIMER4_COMPC = Name(value: "TIMER4_COMPC")
                    static let timer4Compc = TIMER4_COMPC
                    static let TIMER4COMPC = TIMER4_COMPC
                    static let TIMER5_COMPA = Name(value: "TIMER5_COMPA")
                    static let timer5Compa = TIMER5_COMPA
                    static let TIMER5COMPA = TIMER5_COMPA
                    static let TIMER5_COMPB = Name(value: "TIMER5_COMPB")
                    static let timer5Compb = TIMER5_COMPB
                    static let TIMER5COMPB = TIMER5_COMPB
                    static let TIMER5_COMPC = Name(value: "TIMER5_COMPC")
                    static let timer5Compc = TIMER5_COMPC
                    static let TIMER5COMPC = TIMER5_COMPC
                    static let TIMER5_CAPT = Name(value: "TIMER5_CAPT")
                    static let timer5CAPT = TIMER5_CAPT
                    static let timer5Capt = TIMER5_CAPT
                    static let TIMER5CAPT = TIMER5_CAPT
                    static let TIMER5_OVF = Name(value: "TIMER5_OVF")
                    static let timer5OVF = TIMER5_OVF
                    static let timer5Ovf = TIMER5_OVF
                    static let TIMER5OVF = TIMER5_OVF
                    static let SAMPRDY = Name(value: "SAMPRDY")
                    static let samprdy = SAMPRDY
                    static let ERROR = Name(value: "ERROR")
                    static let error = ERROR
                    static let TIM1_OVF = Name(value: "TIM1_OVF")
                    static let tim1OVF = TIM1_OVF
                    static let tim1Ovf = TIM1_OVF
                    static let TIM1OVF = TIM1_OVF
                    static let USB_COM = Name(value: "USB_COM")
                    static let usbCOM = USB_COM
                    static let usbCom = USB_COM
                    static let USBCOM = USB_COM
                    static let USB_GEN = Name(value: "USB_GEN")
                    static let usbGEN = USB_GEN
                    static let usbGen = USB_GEN
                    static let USBGEN = USB_GEN
                    static let TIM1_COMPA = Name(value: "TIM1_COMPA")
                    static let tim1Compa = TIM1_COMPA
                    static let TIM1COMPA = TIM1_COMPA
                    static let TIM1_COMPB = Name(value: "TIM1_COMPB")
                    static let tim1Compb = TIM1_COMPB
                    static let TIM1COMPB = TIM1_COMPB
                    static let TIM1_CAPT = Name(value: "TIM1_CAPT")
                    static let tim1CAPT = TIM1_CAPT
                    static let tim1Capt = TIM1_CAPT
                    static let TIM1CAPT = TIM1_CAPT
                    static let SPM_RDY = Name(value: "SPM_RDY")
                    static let spmRDY = SPM_RDY
                    static let spmRdy = SPM_RDY
                    static let SPMRDY = SPM_RDY
                    static let ANALOG_COMP_1 = Name(value: "ANALOG_COMP_1")
                    static let analogCOMP1 = ANALOG_COMP_1
                    static let analogComp1 = ANALOG_COMP_1
                    static let ANALOGCOMP1 = ANALOG_COMP_1
                    static let ANALOG_COMP_2 = Name(value: "ANALOG_COMP_2")
                    static let analogCOMP2 = ANALOG_COMP_2
                    static let analogComp2 = ANALOG_COMP_2
                    static let ANALOGCOMP2 = ANALOG_COMP_2
                    static let PSC0_CAPT = Name(value: "PSC0_CAPT")
                    static let psc0CAPT = PSC0_CAPT
                    static let psc0Capt = PSC0_CAPT
                    static let PSC0CAPT = PSC0_CAPT
                    static let PSC2_CAPT = Name(value: "PSC2_CAPT")
                    static let psc2CAPT = PSC2_CAPT
                    static let psc2Capt = PSC2_CAPT
                    static let PSC2CAPT = PSC2_CAPT
                    static let USART_RXC = Name(value: "USART_RXC")
                    static let usartRXC = USART_RXC
                    static let usartRxc = USART_RXC
                    static let USARTRXC = USART_RXC
                    static let USART_TXC = Name(value: "USART_TXC")
                    static let usartTXC = USART_TXC
                    static let usartTxc = USART_TXC
                    static let USARTTXC = USART_TXC
                    static let LIN_ERR = Name(value: "LIN_ERR")
                    static let linERR = LIN_ERR
                    static let linErr = LIN_ERR
                    static let LINERR = LIN_ERR
                    static let PSC0_EC = Name(value: "PSC0_EC")
                    static let psc0EC = PSC0_EC
                    static let psc0Ec = PSC0_EC
                    static let PSC0EC = PSC0_EC
                    static let PSC2_EC = Name(value: "PSC2_EC")
                    static let psc2EC = PSC2_EC
                    static let psc2Ec = PSC2_EC
                    static let PSC2EC = PSC2_EC
                    static let LIN_TC = Name(value: "LIN_TC")
                    static let linTC = LIN_TC
                    static let linTc = LIN_TC
                    static let LINTC = LIN_TC
                    static let TRX24_PLL_UNLOCK = Name(value: "TRX24_PLL_UNLOCK")
                    static let trx24PLLUnlock = TRX24_PLL_UNLOCK
                    static let trx24PllUnlock = TRX24_PLL_UNLOCK
                    static let TRX24PLLUNLOCK = TRX24_PLL_UNLOCK
                    static let TRX24_CCA_ED_DONE = Name(value: "TRX24_CCA_ED_DONE")
                    static let trx24CCAEDDONE = TRX24_CCA_ED_DONE
                    static let trx24CcaEdDone = TRX24_CCA_ED_DONE
                    static let TRX24CCAEDDONE = TRX24_CCA_ED_DONE
                    static let TRX24_PLL_LOCK = Name(value: "TRX24_PLL_LOCK")
                    static let trx24PLLLOCK = TRX24_PLL_LOCK
                    static let trx24PllLock = TRX24_PLL_LOCK
                    static let TRX24PLLLOCK = TRX24_PLL_LOCK
                    static let TRX24_RX_START = Name(value: "TRX24_RX_START")
                    static let trx24RXStart = TRX24_RX_START
                    static let trx24RxStart = TRX24_RX_START
                    static let TRX24RXSTART = TRX24_RX_START
                    static let SCNT_BACKOFF = Name(value: "SCNT_BACKOFF")
                    static let scntBackoff = SCNT_BACKOFF
                    static let SCNTBACKOFF = SCNT_BACKOFF
                    static let CCADC_REG_CUR = Name(value: "CCADC_REG_CUR")
                    static let ccadcREGCUR = CCADC_REG_CUR
                    static let ccadcRegCur = CCADC_REG_CUR
                    static let CCADCREGCUR = CCADC_REG_CUR
                    static let TRX24_XAH_AMI = Name(value: "TRX24_XAH_AMI")
                    static let trx24XAHAMI = TRX24_XAH_AMI
                    static let trx24XahAmi = TRX24_XAH_AMI
                    static let TRX24XAHAMI = TRX24_XAH_AMI
                    static let TRX24_AWAKE = Name(value: "TRX24_AWAKE")
                    static let trx24Awake = TRX24_AWAKE
                    static let TRX24AWAKE = TRX24_AWAKE
                    static let USART2_UDRE = Name(value: "USART2_UDRE")
                    static let usart2UDRE = USART2_UDRE
                    static let usart2Udre = USART2_UDRE
                    static let USART2UDRE = USART2_UDRE
                    static let TRX24_RX_END = Name(value: "TRX24_RX_END")
                    static let trx24RXEND = TRX24_RX_END
                    static let trx24RxEnd = TRX24_RX_END
                    static let TRX24RXEND = TRX24_RX_END
                    static let TRX24_TX_END = Name(value: "TRX24_TX_END")
                    static let trx24TXEND = TRX24_TX_END
                    static let trx24TxEnd = TRX24_TX_END
                    static let TRX24TXEND = TRX24_TX_END
                    static let CCADC_CONV = Name(value: "CCADC_CONV")
                    static let ccadcCONV = CCADC_CONV
                    static let ccadcConv = CCADC_CONV
                    static let CCADCCONV = CCADC_CONV
                    static let AES_READY = Name(value: "AES_READY")
                    static let aesReady = AES_READY
                    static let AESREADY = AES_READY
                    static let CCADC_ACC = Name(value: "CCADC_ACC")
                    static let ccadcACC = CCADC_ACC
                    static let ccadcAcc = CCADC_ACC
                    static let CCADCACC = CCADC_ACC
                    static let SCNT_CMP1 = Name(value: "SCNT_CMP1")
                    static let scntCMP1 = SCNT_CMP1
                    static let scntCmp1 = SCNT_CMP1
                    static let SCNTCMP1 = SCNT_CMP1
                    static let SCNT_CMP2 = Name(value: "SCNT_CMP2")
                    static let scntCMP2 = SCNT_CMP2
                    static let scntCmp2 = SCNT_CMP2
                    static let SCNTCMP2 = SCNT_CMP2
                    static let SCNT_CMP3 = Name(value: "SCNT_CMP3")
                    static let scntCMP3 = SCNT_CMP3
                    static let scntCmp3 = SCNT_CMP3
                    static let SCNTCMP3 = SCNT_CMP3
                    static let SCNT_OVFL = Name(value: "SCNT_OVFL")
                    static let scntOVFL = SCNT_OVFL
                    static let scntOvfl = SCNT_OVFL
                    static let SCNTOVFL = SCNT_OVFL
                    static let TIMER0_IC = Name(value: "TIMER0_IC")
                    static let timer0IC = TIMER0_IC
                    static let timer0Ic = TIMER0_IC
                    static let TIMER0IC = TIMER0_IC
                    static let TIMER1_IC = Name(value: "TIMER1_IC")
                    static let timer1IC = TIMER1_IC
                    static let timer1Ic = TIMER1_IC
                    static let TIMER1IC = TIMER1_IC
                    static let USART2_RX = Name(value: "USART2_RX")
                    static let usart2RX = USART2_RX
                    static let usart2Rx = USART2_RX
                    static let USART2RX = USART2_RX
                    static let USART2_TX = Name(value: "USART2_TX")
                    static let usart2TX = USART2_TX
                    static let usart2Tx = USART2_TX
                    static let USART2TX = USART2_TX
                    static let NOT_USED = Name(value: "NOT_USED")
                    static let notUSED = NOT_USED
                    static let notUsed = NOT_USED
                    static let NOTUSED = NOT_USED
                    static let BAT_LOW = Name(value: "BAT_LOW")
                    static let batLOW = BAT_LOW
                    static let batLow = BAT_LOW
                    static let BATLOW = BAT_LOW
                    static let USI_STR = Name(value: "USI_STR")
                    static let usiSTR = USI_STR
                    static let usiStr = USI_STR
                    static let USISTR = USI_STR
                    static let BPINT = Name(value: "BPINT")
                    static let bpint = BPINT
                    static let PCINT = Name(value: "PCINT")
                    static let pcint = PCINT
                    static let VADC = Name(value: "VADC")
                    static let vadc = VADC
                    static let FAULT_PROTECTION = Name(value: "FAULT_PROTECTION")
                    static let faultProtection = FAULT_PROTECTION
                    static let FAULTPROTECTION = FAULT_PROTECTION
                    static let TRX24_TX_START = Name(value: "TRX24_TX_START")
                    static let trx24TXStart = TRX24_TX_START
                    static let trx24TxStart = TRX24_TX_START
                    static let TRX24TXSTART = TRX24_TX_START
                    static let TIMER1_COMPD = Name(value: "TIMER1_COMPD")
                    static let timer1Compd = TIMER1_COMPD
                    static let TIMER1COMPD = TIMER1_COMPD
                    static let ANALOG_COMP_0 = Name(value: "ANALOG_COMP_0")
                    static let analogCOMP0 = ANALOG_COMP_0
                    static let analogComp0 = ANALOG_COMP_0
                    static let ANALOGCOMP0 = ANALOG_COMP_0
                    static let RESERVED15 = Name(value: "RESERVED15")
                    static let reserved15 = RESERVED15
                    static let RESERVED30 = Name(value: "RESERVED30")
                    static let reserved30 = RESERVED30
                    static let RESERVED31 = Name(value: "RESERVED31")
                    static let reserved31 = RESERVED31
                    static let TIMER0_CAPT = Name(value: "TIMER0_CAPT")
                    static let timer0CAPT = TIMER0_CAPT
                    static let timer0Capt = TIMER0_CAPT
                    static let TIMER0CAPT = TIMER0_CAPT
                    static let USART3_UDRE = Name(value: "USART3_UDRE")
                    static let usart3UDRE = USART3_UDRE
                    static let usart3Udre = USART3_UDRE
                    static let USART3UDRE = USART3_UDRE
                    static let TRX24_AMI0 = Name(value: "TRX24_AMI0")
                    static let trx24AMI0 = TRX24_AMI0
                    static let trx24Ami0 = TRX24_AMI0
                    static let TRX24AMI0 = TRX24_AMI0
                    static let TRX24_AMI1 = Name(value: "TRX24_AMI1")
                    static let trx24AMI1 = TRX24_AMI1
                    static let trx24Ami1 = TRX24_AMI1
                    static let TRX24AMI1 = TRX24_AMI1
                    static let TRX24_AMI2 = Name(value: "TRX24_AMI2")
                    static let trx24AMI2 = TRX24_AMI2
                    static let trx24Ami2 = TRX24_AMI2
                    static let TRX24AMI2 = TRX24_AMI2
                    static let TRX24_AMI3 = Name(value: "TRX24_AMI3")
                    static let trx24AMI3 = TRX24_AMI3
                    static let trx24Ami3 = TRX24_AMI3
                    static let TRX24AMI3 = TRX24_AMI3
                    static let ANACOMP0 = Name(value: "ANACOMP0")
                    static let anacomp0 = ANACOMP0
                    static let ANACOMP1 = Name(value: "ANACOMP1")
                    static let anacomp1 = ANACOMP1
                    static let ANACOMP2 = Name(value: "ANACOMP2")
                    static let anacomp2 = ANACOMP2
                    static let ANACOMP3 = Name(value: "ANACOMP3")
                    static let anacomp3 = ANACOMP3
                    static let PSC1_CAPT = Name(value: "PSC1_CAPT")
                    static let psc1CAPT = PSC1_CAPT
                    static let psc1Capt = PSC1_CAPT
                    static let PSC1CAPT = PSC1_CAPT
                    static let PSC_FAULT = Name(value: "PSC_FAULT")
                    static let pscFault = PSC_FAULT
                    static let PSCFAULT = PSC_FAULT
                    static let TIM0_CAPT = Name(value: "TIM0_CAPT")
                    static let tim0CAPT = TIM0_CAPT
                    static let tim0Capt = TIM0_CAPT
                    static let TIM0CAPT = TIM0_CAPT
                    static let TWI_SLAVE = Name(value: "TWI_SLAVE")
                    static let twiSlave = TWI_SLAVE
                    static let TWISLAVE = TWI_SLAVE
                    static let USART3_RX = Name(value: "USART3_RX")
                    static let usart3RX = USART3_RX
                    static let usart3Rx = USART3_RX
                    static let USART3RX = USART3_RX
                    static let USART3_TX = Name(value: "USART3_TX")
                    static let usart3TX = USART3_TX
                    static let usart3Tx = USART3_TX
                    static let USART3TX = USART3_TX
                    static let VREGMON = Name(value: "VREGMON")
                    static let vregmon = VREGMON
                    static let CAN_TOVF = Name(value: "CAN_TOVF")
                    static let canTOVF = CAN_TOVF
                    static let canTovf = CAN_TOVF
                    static let CANTOVF = CAN_TOVF
                    static let EXT_INT0 = Name(value: "EXT_INT0")
                    static let extINT0 = EXT_INT0
                    static let extInt0 = EXT_INT0
                    static let EXTINT0 = EXT_INT0
                    static let CAN_INT = Name(value: "CAN_INT")
                    static let canINT = CAN_INT
                    static let canInt = CAN_INT
                    static let CANINT = CAN_INT
                    static let PSC1_EC = Name(value: "PSC1_EC")
                    static let psc1EC = PSC1_EC
                    static let psc1Ec = PSC1_EC
                    static let PSC1EC = PSC1_EC
                    static let PSC_EC = Name(value: "PSC_EC")
                    static let pscEC = PSC_EC
                    static let pscEc = PSC_EC
                    static let PSCEC = PSC_EC
                    static let USART0_START = Name(value: "USART0_START")
                    static let usart0Start = USART0_START
                    static let USART0START = USART0_START
                    static let USART1_START = Name(value: "USART1_START")
                    static let usart1Start = USART1_START
                    static let USART1START = USART1_START
                    static let SPM = Name(value: "SPM")
                    static let spm = SPM
                    static let USART_START = Name(value: "USART_START")
                    static let usartStart = USART_START
                    static let USARTSTART = USART_START
                    static let TWIBUSCD = Name(value: "TWIBUSCD")
                    static let twibuscd = TWIBUSCD
                    static let IO_PINS = Name(value: "IO_PINS")
                    static let ioPINS = IO_PINS
                    static let ioPins = IO_PINS
                    static let IOPINS = IO_PINS
                    static let BGSCD = Name(value: "BGSCD")
                    static let bgscd = BGSCD
                    static let CHDET = Name(value: "CHDET")
                    static let chdet = CHDET
                    static let QTRIP = Name(value: "QTRIP")
                    static let qtrip = QTRIP
                    static let SPI = Name(value: "SPI")
                    static let spi = SPI
                    static let EEPROM_Ready = Name(value: "EEPROM_Ready")
                    static let eepromReady = EEPROM_Ready
                    static let EEPROMReady = EEPROM_Ready
                    static let WDT_OVERFLOW = Name(value: "WDT_OVERFLOW")
                    static let wdtOverflow = WDT_OVERFLOW
                    static let WDTOVERFLOW = WDT_OVERFLOW
                    static let TIMER0_COMP_A = Name(value: "TIMER0_COMP_A")
                    static let timer0COMPA = TIMER0_COMP_A
                    static let timer0CompA = TIMER0_COMP_A
                    static let CANIT = Name(value: "CANIT")
                    static let canit = CANIT
                    static let OVRIT = Name(value: "OVRIT")
                    static let ovrit = OVRIT
                    static let TIMER4_COMPD = Name(value: "TIMER4_COMPD")
                    static let timer4Compd = TIMER4_COMPD
                    static let TIMER4COMPD = TIMER4_COMPD
                    static let ANALOG_COMP_3 = Name(value: "ANALOG_COMP_3")
                    static let analogCOMP3 = ANALOG_COMP_3
                    static let analogComp3 = ANALOG_COMP_3
                    static let ANALOGCOMP3 = ANALOG_COMP_3
                    static let TIMER2_CAPT = Name(value: "TIMER2_CAPT")
                    static let timer2CAPT = TIMER2_CAPT
                    static let timer2Capt = TIMER2_CAPT
                    static let TIMER2CAPT = TIMER2_CAPT
                    static let Reserved1 = Name(value: "Reserved1")
                    static let reserved1 = Reserved1
                    static let Reserved2 = Name(value: "Reserved2")
                    static let reserved2 = Reserved2
                    static let Reserved3 = Name(value: "Reserved3")
                    static let reserved3 = Reserved3
                    static let Reserved4 = Name(value: "Reserved4")
                    static let reserved4 = Reserved4
                    static let Reserved5 = Name(value: "Reserved5")
                    static let reserved5 = Reserved5
                    static let Reserved6 = Name(value: "Reserved6")
                    static let reserved6 = Reserved6
                    static let TIMER4_FPF = Name(value: "TIMER4_FPF")
                    static let timer4FPF = TIMER4_FPF
                    static let timer4Fpf = TIMER4_FPF
                    static let TIMER4FPF = TIMER4_FPF
                    static let USART0_RXC = Name(value: "USART0_RXC")
                    static let usart0RXC = USART0_RXC
                    static let usart0Rxc = USART0_RXC
                    static let USART0RXC = USART0_RXC
                    static let USART0_RXS = Name(value: "USART0_RXS")
                    static let usart0RXS = USART0_RXS
                    static let usart0Rxs = USART0_RXS
                    static let USART0RXS = USART0_RXS
                    static let USART0_TXC = Name(value: "USART0_TXC")
                    static let usart0TXC = USART0_TXC
                    static let usart0Txc = USART0_TXC
                    static let USART0TXC = USART0_TXC
                    static let USART1_RXC = Name(value: "USART1_RXC")
                    static let usart1RXC = USART1_RXC
                    static let usart1Rxc = USART1_RXC
                    static let USART1RXC = USART1_RXC
                    static let USART1_RXS = Name(value: "USART1_RXS")
                    static let usart1RXS = USART1_RXS
                    static let usart1Rxs = USART1_RXS
                    static let USART1RXS = USART1_RXS
                    static let USART1_TXC = Name(value: "USART1_TXC")
                    static let usart1TXC = USART1_TXC
                    static let usart1Txc = USART1_TXC
                    static let USART1TXC = USART1_TXC
                    static let ANA_COMP0 = Name(value: "ANA_COMP0")
                    static let anaCOMP0 = ANA_COMP0
                    static let anaComp0 = ANA_COMP0
                    static let ANA_COMP1 = Name(value: "ANA_COMP1")
                    static let anaCOMP1 = ANA_COMP1
                    static let anaComp1 = ANA_COMP1
                    static let PTC_WCOMP = Name(value: "PTC_WCOMP")
                    static let ptcWcomp = PTC_WCOMP
                    static let PTCWCOMP = PTC_WCOMP
                    static let USART_DRE = Name(value: "USART_DRE")
                    static let usartDRE = USART_DRE
                    static let usartDre = USART_DRE
                    static let USARTDRE = USART_DRE
                    static let USART_RXS = Name(value: "USART_RXS")
                    static let usartRXS = USART_RXS
                    static let usartRxs = USART_RXS
                    static let USARTRXS = USART_RXS
                    static let PSC0_EEC = Name(value: "PSC0_EEC")
                    static let psc0EEC = PSC0_EEC
                    static let psc0Eec = PSC0_EEC
                    static let PSC0EEC = PSC0_EEC
                    static let PSC2_EEC = Name(value: "PSC2_EEC")
                    static let psc2EEC = PSC2_EEC
                    static let psc2Eec = PSC2_EEC
                    static let PSC2EEC = PSC2_EEC
                    static let SPI0_STC = Name(value: "SPI0_STC")
                    static let spi0STC = SPI0_STC
                    static let spi0Stc = SPI0_STC
                    static let SPI0STC = SPI0_STC
                    static let SPI1_STC = Name(value: "SPI1_STC")
                    static let spi1STC = SPI1_STC
                    static let spi1Stc = SPI1_STC
                    static let SPI1STC = SPI1_STC
                    static let PCINT_A = Name(value: "PCINT_A")
                    static let pcintA = PCINT_A
                    static let PCINTA = PCINT_A
                    static let PCINT_B = Name(value: "PCINT_B")
                    static let pcintB = PCINT_B
                    static let PCINTB = PCINT_B
                    static let PCINT_D = Name(value: "PCINT_D")
                    static let pcintD = PCINT_D
                    static let PCINTD = PCINT_D
                    static let PTC_EOC = Name(value: "PTC_EOC")
                    static let ptcEOC = PTC_EOC
                    static let ptcEoc = PTC_EOC
                    static let PTCEOC = PTC_EOC
                    static let TWI0 = Name(value: "TWI0")
                    static let twi0 = TWI0
                    static let TWI1 = Name(value: "TWI1")
                    static let twi1 = TWI1
                    static let USART2_START = Name(value: "USART2_START")
                    static let usart2Start = USART2_START
                    static let USART2START = USART2_START
                    static let TIMER0_OVF0 = Name(value: "TIMER0_OVF0")
                    static let timer0OVF0 = TIMER0_OVF0
                    static let timer0Ovf0 = TIMER0_OVF0
                    static let TIMER0OVF0 = TIMER0_OVF0
                    static let TIMER1_CMPA = Name(value: "TIMER1_CMPA")
                    static let timer1CMPA = TIMER1_CMPA
                    static let timer1Cmpa = TIMER1_CMPA
                    static let TIMER1CMPA = TIMER1_CMPA
                    static let TIMER1_CMPB = Name(value: "TIMER1_CMPB")
                    static let timer1CMPB = TIMER1_CMPB
                    static let timer1Cmpb = TIMER1_CMPB
                    static let TIMER1CMPB = TIMER1_CMPB
                    static let TIMER1_COMP = Name(value: "TIMER1_COMP")
                    static let timer1COMP = TIMER1_COMP
                    static let timer1Comp = TIMER1_COMP
                    static let TIMER1COMP = TIMER1_COMP
                    static let TIMER1_OVF1 = Name(value: "TIMER1_OVF1")
                    static let timer1OVF1 = TIMER1_OVF1
                    static let timer1Ovf1 = TIMER1_OVF1
                    static let TIMER1OVF1 = TIMER1_OVF1
                    static let CADC_REG_CUR = Name(value: "CADC_REG_CUR")
                    static let cadcREGCUR = CADC_REG_CUR
                    static let cadcRegCur = CADC_REG_CUR
                    static let CADCREGCUR = CADC_REG_CUR
                    static let LIN_STATUS = Name(value: "LIN_STATUS")
                    static let linStatus = LIN_STATUS
                    static let LINSTATUS = LIN_STATUS
                    static let USART0_DRE = Name(value: "USART0_DRE")
                    static let usart0DRE = USART0_DRE
                    static let usart0Dre = USART0_DRE
                    static let USART0DRE = USART0_DRE
                    static let USART1_DRE = Name(value: "USART1_DRE")
                    static let usart1DRE = USART1_DRE
                    static let usart1Dre = USART1_DRE
                    static let USART1DRE = USART1_DRE
                    static let USART2_RXS = Name(value: "USART2_RXS")
                    static let usart2RXS = USART2_RXS
                    static let usart2Rxs = USART2_RXS
                    static let USART2RXS = USART2_RXS
                    static let ADC_READY = Name(value: "ADC_READY")
                    static let adcReady = ADC_READY
                    static let ADCREADY = ADC_READY
                    static let CADC_CONV = Name(value: "CADC_CONV")
                    static let cadcCONV = CADC_CONV
                    static let cadcConv = CADC_CONV
                    static let CADCCONV = CADC_CONV
                    static let LIN_ERROR = Name(value: "LIN_ERROR")
                    static let linError = LIN_ERROR
                    static let LINERROR = LIN_ERROR
                    static let TIM1_COMP = Name(value: "TIM1_COMP")
                    static let tim1COMP = TIM1_COMP
                    static let tim1Comp = TIM1_COMP
                    static let TIM1COMP = TIM1_COMP
                    static let VADC_CONV = Name(value: "VADC_CONV")
                    static let vadcCONV = VADC_CONV
                    static let vadcConv = VADC_CONV
                    static let VADCCONV = VADC_CONV
                    static let TWI_BUS_CD = Name(value: "TWI_BUS_CD")
                    static let twiBUSCD = TWI_BUS_CD
                    static let twiBusCd = TWI_BUS_CD
                    static let CADC_ACC = Name(value: "CADC_ACC")
                    static let cadcACC = CADC_ACC
                    static let cadcAcc = CADC_ACC
                    static let CADCACC = CADC_ACC
                    static let USI_STRT = Name(value: "USI_STRT")
                    static let usiSTRT = USI_STRT
                    static let usiStrt = USI_STRT
                    static let USISTRT = USI_STRT
                    static let VADC_ACC = Name(value: "VADC_ACC")
                    static let vadcACC = VADC_ACC
                    static let vadcAcc = VADC_ACC
                    static let VADCACC = VADC_ACC
                    static let PCINT4 = Name(value: "PCINT4")
                    static let pcint4 = PCINT4
                    static let WAKEUP = Name(value: "WAKEUP")
                    static let wakeup = WAKEUP
                    static let XOSCFD = Name(value: "XOSCFD")
                    static let xoscfd = XOSCFD
                    static let ADC_ADC = Name(value: "ADC_ADC")
                    static let adcADC = ADC_ADC
                    static let adcAdc = ADC_ADC
                    static let ADCADC = ADC_ADC
                    static let WAKE_UP = Name(value: "WAKE_UP")
                    static let wakeUP = WAKE_UP
                    static let wakeUp = WAKE_UP
                    static let CFD = Name(value: "CFD")
                    static let cfd = CFD
                    static let PLL = Name(value: "PLL")
                    static let pll = PLL

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Name] = [
                                RESET,
                                INT0,
                                TIMER0_OVF,
                                TIMER1_OVF,
                                PORT,
                                ADC,
                                TIMER1_COMPA,
                                TIMER1_COMPB,
                                TIMER1_CAPT,
                                PCINT0,
                                SPI_STC,
                                INT,
                                EE_READY,
                                PCINT1,
                                WDT,
                                INT1,
                                ANALOG_COMP,
                                TIMER2_OVF,
                                SPM_READY,
                                TIMER0_COMPB,
                                TIMER0_COMPA,
                                DRE,
                                RXC,
                                TXC,
                                INT2,
                                USART0_TX,
                                TWI,
                                PCINT2,
                                OVF,
                                USART0_UDRE,
                                USART0_RX,
                                AC,
                                VLM,
                                TIMER2_COMP,
                                USI_START,
                                RESRDY,
                                TIMER2_COMPA,
                                TIMER2_COMPB,
                                TIMER0_COMP,
                                USART_UDRE,
                                USART1_UDRE,
                                INT3,
                                USART1_RX,
                                USART1_TX,
                                ANA_COMP,
                                LCMP0,
                                LCMP1,
                                LCMP2,
                                CMP0,
                                CMP1,
                                CMP2,
                                HUNF,
                                LUNF,
                                TWIM,
                                TWIS,
                                CNT,
                                NMI,
                                PIT,
                                EE,
                                USART_RX,
                                USI_OVERFLOW,
                                WCOMP,
                                PCINT3,
                                EE_RDY,
                                TIMER1_COMPC,
                                TIMER3_COMPA,
                                TIMER3_COMPB,
                                TIMER3_CAPT,
                                TIMER3_OVF,
                                INT6,
                                USART_TX,
                                INT4,
                                INT5,
                                INT7,
                                TIMER3_COMPC,
                                USI_OVF,
                                CCL,
                                TIM0_COMPA,
                                TIM0_COMPB,
                                TIM0_OVF,
                                SPM_Ready,
                                LCD,
                                TIMER4_COMPA,
                                TIMER4_COMPB,
                                TIMER4_OVF,
                                TIMER4_CAPT,
                                TRIG,
                                TIMER4_COMPC,
                                TIMER5_COMPA,
                                TIMER5_COMPB,
                                TIMER5_COMPC,
                                TIMER5_CAPT,
                                TIMER5_OVF,
                                SAMPRDY,
                                ERROR,
                                TIM1_OVF,
                                USB_COM,
                                USB_GEN,
                                TIM1_COMPA,
                                TIM1_COMPB,
                                TIM1_CAPT,
                                SPM_RDY,
                                ANALOG_COMP_1,
                                ANALOG_COMP_2,
                                PSC0_CAPT,
                                PSC2_CAPT,
                                USART_RXC,
                                USART_TXC,
                                LIN_ERR,
                                PSC0_EC,
                                PSC2_EC,
                                LIN_TC,
                                TRX24_PLL_UNLOCK,
                                TRX24_CCA_ED_DONE,
                                TRX24_PLL_LOCK,
                                TRX24_RX_START,
                                SCNT_BACKOFF,
                                CCADC_REG_CUR,
                                TRX24_XAH_AMI,
                                TRX24_AWAKE,
                                USART2_UDRE,
                                TRX24_RX_END,
                                TRX24_TX_END,
                                CCADC_CONV,
                                AES_READY,
                                CCADC_ACC,
                                SCNT_CMP1,
                                SCNT_CMP2,
                                SCNT_CMP3,
                                SCNT_OVFL,
                                TIMER0_IC,
                                TIMER1_IC,
                                USART2_RX,
                                USART2_TX,
                                NOT_USED,
                                BAT_LOW,
                                USI_STR,
                                BPINT,
                                PCINT,
                                VADC,
                                FAULT_PROTECTION,
                                TRX24_TX_START,
                                TIMER1_COMPD,
                                ANALOG_COMP_0,
                                RESERVED15,
                                RESERVED30,
                                RESERVED31,
                                TIMER0_CAPT,
                                USART3_UDRE,
                                TRX24_AMI0,
                                TRX24_AMI1,
                                TRX24_AMI2,
                                TRX24_AMI3,
                                ANACOMP0,
                                ANACOMP1,
                                ANACOMP2,
                                ANACOMP3,
                                PSC1_CAPT,
                                PSC_FAULT,
                                TIM0_CAPT,
                                TWI_SLAVE,
                                USART3_RX,
                                USART3_TX,
                                VREGMON,
                                CAN_TOVF,
                                EXT_INT0,
                                CAN_INT,
                                PSC1_EC,
                                PSC_EC,
                                USART0_START,
                                USART1_START,
                                SPM,
                                USART_START,
                                TWIBUSCD,
                                IO_PINS,
                                BGSCD,
                                CHDET,
                                QTRIP,
                                SPI,
                                EEPROM_Ready,
                                WDT_OVERFLOW,
                                TIMER0_COMP_A,
                                CANIT,
                                OVRIT,
                                TIMER4_COMPD,
                                ANALOG_COMP_3,
                                TIMER2_CAPT,
                                Reserved1,
                                Reserved2,
                                Reserved3,
                                Reserved4,
                                Reserved5,
                                Reserved6,
                                TIMER4_FPF,
                                USART0_RXC,
                                USART0_RXS,
                                USART0_TXC,
                                USART1_RXC,
                                USART1_RXS,
                                USART1_TXC,
                                ANA_COMP0,
                                ANA_COMP1,
                                PTC_WCOMP,
                                USART_DRE,
                                USART_RXS,
                                PSC0_EEC,
                                PSC2_EEC,
                                SPI0_STC,
                                SPI1_STC,
                                PCINT_A,
                                PCINT_B,
                                PCINT_D,
                                PTC_EOC,
                                TWI0,
                                TWI1,
                                USART2_START,
                                TIMER0_OVF0,
                                TIMER1_CMPA,
                                TIMER1_CMPB,
                                TIMER1_COMP,
                                TIMER1_OVF1,
                                CADC_REG_CUR,
                                LIN_STATUS,
                                USART0_DRE,
                                USART1_DRE,
                                USART2_RXS,
                                ADC_READY,
                                CADC_CONV,
                                LIN_ERROR,
                                TIM1_COMP,
                                VADC_CONV,
                                TWI_BUS_CD,
                                CADC_ACC,
                                USI_STRT,
                                VADC_ACC,
                                PCINT4,
                                WAKEUP,
                                XOSCFD,
                                ADC_ADC,
                                WAKE_UP,
                                CFD,
                                PLL
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Caption: ATDFStringValue {
                    static let externalInterruptRequest0 = Caption(value: "External Interrupt Request 0")
                    static let ExternalInterruptRequest0 = externalInterruptRequest0
                    static let eepromReady = Caption(value: "EEPROM Ready")
                    static let EEPROMReady = eepromReady
                    static let timerCounter0Overflow = Caption(value: "Timer/Counter0 Overflow")
                    static let TimerCounter0Overflow = timerCounter0Overflow
                    static let adcConversionComplete = Caption(value: "ADC Conversion Complete", alternateValues: ["ADC Conversion complete"])
                    static let ADCConversionComplete = adcConversionComplete
                    static let timerCounter1Overflow = Caption(value: "Timer/Counter1 Overflow", alternateValues: ["Timer/Counter 1 Overflow"])
                    static let TimerCounter1Overflow = timerCounter1Overflow
                    static let analogComparator = Caption(value: "Analog Comparator", alternateValues: ["Analog comparator"])
                    static let AnalogComparator = analogComparator
                    static let pinChangeInterruptRequest0 = Caption(value: "Pin Change Interrupt Request 0", alternateValues: ["Pin change Interrupt Request 0"])
                    static let PinChangeInterruptRequest0 = pinChangeInterruptRequest0
                    static let timerCounter1CaptureEvent = Caption(value: "Timer/Counter1 Capture Event")
                    static let TimerCounter1CaptureEvent = timerCounter1CaptureEvent
                    static let timerCounter1CompareMatchA = Caption(value: "Timer/Counter1 Compare Match A", alternateValues: [" Timer/Counter1 Compare Match A"])
                    static let TimerCounter1CompareMatchA = timerCounter1CompareMatchA
                    static let spiSerialTransferComplete = Caption(value: "SPI Serial Transfer Complete", alternateValues: ["SPI Serial Transfer Complet", "SPI Serial transfer complete"])
                    static let SPISerialTransferComplete = spiSerialTransferComplete
                    static let storeProgramMemoryRead = Caption(value: "Store Program Memory Read", alternateValues: ["Store Program Memory Ready"])
                    static let StoreProgramMemoryRead = storeProgramMemoryRead
                    static let pinChangeInterruptRequest1 = Caption(value: "Pin Change Interrupt Request 1")
                    static let PinChangeInterruptRequest1 = pinChangeInterruptRequest1
                    static let externalInterruptRequest1 = Caption(value: "External Interrupt Request 1")
                    static let ExternalInterruptRequest1 = externalInterruptRequest1
                    static let timerCounter2Overflow = Caption(value: "Timer/Counter2 Overflow")
                    static let TimerCounter2Overflow = timerCounter2Overflow
                    static let timerCounter1CompareMatchB = Caption(value: "Timer/Counter1 Compare Match B", alternateValues: [" Timer/Counter1 Compare Match B", "Timer/Counter 1 Compare Match", "Timer/Counter1 Compare Match", "Timer/Counter1 Compare MatchB"])
                    static let TimerCounter1CompareMatchB = timerCounter1CompareMatchB
                    static let externalInterruptRequest2 = Caption(value: "External Interrupt Request 2")
                    static let ExternalInterruptRequest2 = externalInterruptRequest2
                    static let usart0TxComplete = Caption(value: "USART0, Tx Complete", alternateValues: ["USART0 Tx Complete"])
                    static let USART0TxComplete = usart0TxComplete
                    static let timerCounter0CompareMatchA = Caption(value: "Timer/Counter0 Compare Match A", alternateValues: ["TimerCounter0 Compare Match A"])
                    static let TimerCounter0CompareMatchA = timerCounter0CompareMatchA
                    static let externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRResetSeeDatasheet = Caption(value: "External Pin,Power-on Reset,Brown-out Reset,Watchdog Reset,and JTAG AVR Reset. See Datasheet.     ", alternateValues: ["External Pin, Power-on Reset, Brown-out Reset,Watchdog Reset", "External Pin,Power-on Reset,Brown-out Reset,Watchdog Reset,and JTAG AVR Reset. See Datasheet."])
                    static let externalPinPowerOnResetBrownOutResetWatchdogResetAndJtagAvrResetSeeDatasheet = externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRResetSeeDatasheet
                    static let ExternalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRResetSeeDatasheet = externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRResetSeeDatasheet
                    static let timerCounter2CompareMatchA = Caption(value: "Timer/Counter2 Compare Match A")
                    static let TimerCounter2CompareMatchA = timerCounter2CompareMatchA
                    static let timerCounter0CompareMatchB = Caption(value: "Timer/Counter0 Compare Match B", alternateValues: ["Timer Counter 0 Compare Match B", "TimerCounter0 Compare Match B"])
                    static let TimerCounter0CompareMatchB = timerCounter0CompareMatchB
                    static let watchdogTimeOutInterrupt = Caption(value: "Watchdog Time-out Interrupt", alternateValues: ["Watchdog Time-Out Interrupt", "Watchdog Timeout Interrupt"])
                    static let WatchdogTimeOutInterrupt = watchdogTimeOutInterrupt
                    static let timerCounterCompareMatchB = Caption(value: "Timer/Counter Compare Match B")
                    static let TimerCounterCompareMatchB = timerCounterCompareMatchB
                    static let usart0RxComplete = Caption(value: "USART0, Rx Complete", alternateValues: ["USART0 Rx Complete"])
                    static let USART0RxComplete = usart0RxComplete
                    static let usiOverflow = Caption(value: "USI Overflow")
                    static let USIOverflow = usiOverflow
                    static let pinChangeInterruptRequest2 = Caption(value: "Pin Change Interrupt Request 2")
                    static let PinChangeInterruptRequest2 = pinChangeInterruptRequest2
                    static let timerCounter2CompareMatch = Caption(value: "Timer/Counter2 Compare Match")
                    static let TimerCounter2CompareMatch = timerCounter2CompareMatch
                    static let externalInterruptRequest3 = Caption(value: "External Interrupt Request 3")
                    static let ExternalInterruptRequest3 = externalInterruptRequest3
                    static let timerCounter0CompareMatch = Caption(value: "Timer/Counter0 Compare Match", alternateValues: ["TimerCounter0 Compare Match"])
                    static let TimerCounter0CompareMatch = timerCounter0CompareMatch
                    static let usart0DataRegisterEmpty = Caption(value: "USART0 Data register Empty", alternateValues: ["USART0 Data Register Empty", "USART0, Data Register Empty"])
                    static let USART0DataRegisterEmpty = usart0DataRegisterEmpty
                    static let timerCounter2CompareMatchB = Caption(value: "Timer/Counter2 Compare Match B")
                    static let TimerCounter2CompareMatchB = timerCounter2CompareMatchB
                    static let usiStartCondition = Caption(value: "USI Start Condition")
                    static let USIStartCondition = usiStartCondition
                    static let value2WireSerialInterface = Caption(value: "2-wire Serial Interface", alternateValues: ["2-wire Serial Interface        "])
                    static let pinChangeInterruptRequest3 = Caption(value: "Pin Change Interrupt Request 3")
                    static let PinChangeInterruptRequest3 = pinChangeInterruptRequest3
                    static let usart1RxComplete = Caption(value: "USART1, Rx Complete", alternateValues: ["USART1 RX complete", "USART1 Rx Complete"])
                    static let USART1RxComplete = usart1RxComplete
                    static let usart1TxComplete = Caption(value: "USART1, Tx Complete", alternateValues: ["USART1 TX complete", "USART1 Tx Complete"])
                    static let USART1TxComplete = usart1TxComplete
                    static let externalPinPowerOnResetBrownOutResetAndWatchdogReset = Caption(value: "External Pin, Power-on Reset, Brown-out Reset and Watchdog Reset", alternateValues: ["External Pin, Power-on Reset, Brown-out Reset  and Watchdog Reset"])
                    static let ExternalPinPowerOnResetBrownOutResetAndWatchdogReset = externalPinPowerOnResetBrownOutResetAndWatchdogReset
                    static let timerCounter3CompareMatchA = Caption(value: "Timer/Counter3 Compare Match A")
                    static let TimerCounter3CompareMatchA = timerCounter3CompareMatchA
                    static let timerCounter3CompareMatchB = Caption(value: "Timer/Counter3 Compare Match B")
                    static let TimerCounter3CompareMatchB = timerCounter3CompareMatchB
                    static let externalInterruptRequest6 = Caption(value: "External Interrupt Request 6")
                    static let ExternalInterruptRequest6 = externalInterruptRequest6
                    static let timerCounter3CaptureEvent = Caption(value: "Timer/Counter3 Capture Event")
                    static let TimerCounter3CaptureEvent = timerCounter3CaptureEvent
                    static let timerCounter3Overflow = Caption(value: "Timer/Counter3 Overflow")
                    static let TimerCounter3Overflow = timerCounter3Overflow
                    static let usartRxComplete = Caption(value: "USART, Rx Complete", alternateValues: ["USART RX Complete", "USART Rx Complete", "USART, RX Complete"])
                    static let USARTRxComplete = usartRxComplete
                    static let externalInterruptRequest4 = Caption(value: "External Interrupt Request 4")
                    static let ExternalInterruptRequest4 = externalInterruptRequest4
                    static let externalInterruptRequest5 = Caption(value: "External Interrupt Request 5")
                    static let ExternalInterruptRequest5 = externalInterruptRequest5
                    static let externalInterruptRequest7 = Caption(value: "External Interrupt Request 7")
                    static let ExternalInterruptRequest7 = externalInterruptRequest7
                    static let externalResetPowerOnResetAndWatchdogReset = Caption(value: "External Reset, Power-on Reset and Watchdog Reset")
                    static let ExternalResetPowerOnResetAndWatchdogReset = externalResetPowerOnResetAndWatchdogReset
                    static let timerCounter1CompareMatchC = Caption(value: "Timer/Counter1 Compare Match C")
                    static let TimerCounter1CompareMatchC = timerCounter1CompareMatchC
                    static let timerCounter3CompareMatchC = Caption(value: "Timer/Counter3 Compare Match C")
                    static let TimerCounter3CompareMatchC = timerCounter3CompareMatchC
                    static let twoWireSerialInterface = Caption(value: "Two-wire Serial Interface", alternateValues: ["Two-Wire Serial Interface"])
                    static let TwoWireSerialInterface = twoWireSerialInterface
                    static let externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRReset = Caption(value: "External Pin, Power-on Reset, Brown-out Reset, Watchdog Reset and JTAG AVR Reset")
                    static let externalPinPowerOnResetBrownOutResetWatchdogResetAndJtagAvrReset = externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRReset
                    static let ExternalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRReset = externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRReset
                    static let usart1DataRegisterEmpty = Caption(value: "USART1 Data register Empty", alternateValues: ["USART1 Data Register Empty", "USART1, Data Register Empty", "USART1, Data register Empty"])
                    static let USART1DataRegisterEmpty = usart1DataRegisterEmpty
                    static let usartTxComplete = Caption(value: "USART Tx Complete", alternateValues: ["USART, TX Complete", "USART, Tx Complete"])
                    static let USARTTxComplete = usartTxComplete
                    static let watchdogTimeOut = Caption(value: "Watchdog Time-out", alternateValues: ["Watchdog Time-Out"])
                    static let WatchdogTimeOut = watchdogTimeOut
                    static let usartDataRegisterEmpty = Caption(value: "USART, Data Register Empty", alternateValues: ["USART Data Register Empty", "USART Data register Empty", "USART Data register empty"])
                    static let USARTDataRegisterEmpty = usartDataRegisterEmpty
                    static let externalInterrupt0 = Caption(value: "External Interrupt 0")
                    static let ExternalInterrupt0 = externalInterrupt0
                    static let lcdStartOfFrame = Caption(value: "LCD Start of Frame")
                    static let LCDStartOfFrame = lcdStartOfFrame
                    static let timerCounter4CompareMatchA = Caption(value: "Timer/Counter4 Compare Match A")
                    static let TimerCounter4CompareMatchA = timerCounter4CompareMatchA
                    static let timerCounter4CompareMatchB = Caption(value: "Timer/Counter4 Compare Match B")
                    static let TimerCounter4CompareMatchB = timerCounter4CompareMatchB
                    static let timerCounter4Overflow = Caption(value: "Timer/Counter4 Overflow")
                    static let TimerCounter4Overflow = timerCounter4Overflow
                    static let analogComparator1 = Caption(value: "Analog Comparator 1")
                    static let AnalogComparator1 = analogComparator1
                    static let timerCounter4CaptureEvent = Caption(value: "Timer/Counter4 Capture Event")
                    static let TimerCounter4CaptureEvent = timerCounter4CaptureEvent
                    static let analogComparator0 = Caption(value: "Analog Comparator 0")
                    static let AnalogComparator0 = analogComparator0
                    static let analogComparator2 = Caption(value: "Analog Comparator 2")
                    static let AnalogComparator2 = analogComparator2
                    static let timerCounter1CompareMatch1A = Caption(value: "Timer/Counter1 Compare Match 1A")
                    static let timerCounter1CompareMatch1a = timerCounter1CompareMatch1A
                    static let TimerCounter1CompareMatch1A = timerCounter1CompareMatch1A
                    static let timerCounter4CompareMatchC = Caption(value: "Timer/Counter4 Compare Match C")
                    static let TimerCounter4CompareMatchC = timerCounter4CompareMatchC
                    static let timerCounter5CompareMatchA = Caption(value: "Timer/Counter5 Compare Match A")
                    static let TimerCounter5CompareMatchA = timerCounter5CompareMatchA
                    static let timerCounter5CompareMatchB = Caption(value: "Timer/Counter5 Compare Match B")
                    static let TimerCounter5CompareMatchB = timerCounter5CompareMatchB
                    static let timerCounter5CompareMatchC = Caption(value: "Timer/Counter5 Compare Match C")
                    static let TimerCounter5CompareMatchC = timerCounter5CompareMatchC
                    static let timerCounter5CaptureEvent = Caption(value: "Timer/Counter5 Capture Event")
                    static let TimerCounter5CaptureEvent = timerCounter5CaptureEvent
                    static let timerCounter5Overflow = Caption(value: "Timer/Counter5 Overflow")
                    static let TimerCounter5Overflow = timerCounter5Overflow
                    static let usbEndpointPipeInterruptCommunicationRequest = Caption(value: "USB Endpoint/Pipe Interrupt Communication Request")
                    static let USBEndpointPipeInterruptCommunicationRequest = usbEndpointPipeInterruptCommunicationRequest
                    static let usbGeneralInterruptRequest = Caption(value: "USB General Interrupt Request")
                    static let USBGeneralInterruptRequest = usbGeneralInterruptRequest
                    static let usiStart = Caption(value: "USI START", alternateValues: ["USI Start"])
                    static let USISTART = usiStart
                    static let timerCounter1CompareMatch1B = Caption(value: "Timer/Counter1 Compare Match 1B")
                    static let timerCounter1CompareMatch1b = timerCounter1CompareMatch1B
                    static let TimerCounter1CompareMatch1B = timerCounter1CompareMatch1B
                    static let timerCounterCompareMatchA = Caption(value: "Timer/Counter Compare Match A")
                    static let TimerCounterCompareMatchA = timerCounterCompareMatchA
                    static let linTransferComplete = Caption(value: "LIN Transfer Complete")
                    static let LINTransferComplete = linTransferComplete
                    static let analogComparator3 = Caption(value: "Analog Comparator 3")
                    static let AnalogComparator3 = analogComparator3
                    static let psc0CaptureEvent = Caption(value: "PSC0 Capture Event")
                    static let PSC0CaptureEvent = psc0CaptureEvent
                    static let psc2CaptureEvent = Caption(value: "PSC2 Capture Event")
                    static let PSC2CaptureEvent = psc2CaptureEvent
                    static let psc0EndCycle = Caption(value: "PSC0 End Cycle")
                    static let PSC0EndCycle = psc0EndCycle
                    static let psc2EndCycle = Caption(value: "PSC2 End Cycle")
                    static let PSC2EndCycle = psc2EndCycle
                    static let linError = Caption(value: "LIN Error")
                    static let LINError = linError
                    static let batteryMonitorIndicatesSupplyVoltageBelowThreshold = Caption(value: "Battery monitor indicates supply voltage below threshold")
                    static let BatteryMonitorIndicatesSupplyVoltageBelowThreshold = batteryMonitorIndicatesSupplyVoltageBelowThreshold
                    static let trx24AwakeTransceiverIsReachingStateTRXOFF = Caption(value: "TRX24 AWAKE - transceiver is reaching state TRX_OFF")
                    static let trx24AwakeTransceiverIsReachingStateTrxOff = trx24AwakeTransceiverIsReachingStateTRXOFF
                    static let TRX24AWAKETransceiverIsReachingStateTRXOFF = trx24AwakeTransceiverIsReachingStateTRXOFF
                    static let coulombCounterADCConversionComplete = Caption(value: "Coulomb Counter ADC Conversion Complete")
                    static let coulombCounterAdcConversionComplete = coulombCounterADCConversionComplete
                    static let CoulombCounterADCConversionComplete = coulombCounterADCConversionComplete
                    static let symbolCounterCompareMatch1Interrupt = Caption(value: "Symbol counter - compare match 1 interrupt")
                    static let SymbolCounterCompareMatch1Interrupt = symbolCounterCompareMatch1Interrupt
                    static let symbolCounterCompareMatch2Interrupt = Caption(value: "Symbol counter - compare match 2 interrupt")
                    static let SymbolCounterCompareMatch2Interrupt = symbolCounterCompareMatch2Interrupt
                    static let symbolCounterCompareMatch3Interrupt = Caption(value: "Symbol counter - compare match 3 interrupt")
                    static let SymbolCounterCompareMatch3Interrupt = symbolCounterCompareMatch3Interrupt
                    static let coloumbCounterADCRegularCurrent = Caption(value: "Coloumb Counter ADC Regular Current")
                    static let coloumbCounterAdcRegularCurrent = coloumbCounterADCRegularCurrent
                    static let ColoumbCounterADCRegularCurrent = coloumbCounterADCRegularCurrent
                    static let symbolCounterOverflowInterrupt = Caption(value: "Symbol counter - overflow interrupt")
                    static let SymbolCounterOverflowInterrupt = symbolCounterOverflowInterrupt
                    static let symbolCounterBackoffInterrupt = Caption(value: "Symbol counter - backoff interrupt")
                    static let SymbolCounterBackoffInterrupt = symbolCounterBackoffInterrupt
                    static let coloumbCounterADCAccumulator = Caption(value: "Coloumb Counter ADC Accumulator")
                    static let coloumbCounterAdcAccumulator = coloumbCounterADCAccumulator
                    static let ColoumbCounterADCAccumulator = coloumbCounterADCAccumulator
                    static let voltageADCConversionComplete = Caption(value: "Voltage ADC Conversion Complete")
                    static let voltageAdcConversionComplete = voltageADCConversionComplete
                    static let VoltageADCConversionComplete = voltageADCConversionComplete
                    static let batteryProtectionInterrupt = Caption(value: "Battery Protection Interrupt")
                    static let BatteryProtectionInterrupt = batteryProtectionInterrupt
                    static let trx24ReceiveStartInterrupt = Caption(value: "TRX24 - Receive start interrupt")
                    static let TRX24ReceiveStartInterrupt = trx24ReceiveStartInterrupt
                    static let timerCounter2CaptureEvent = Caption(value: "Timer/Counter2 Capture Event")
                    static let TimerCounter2CaptureEvent = timerCounter2CaptureEvent
                    static let aesEngineReadyInterrupt = Caption(value: "AES engine ready interrupt")
                    static let AESEngineReadyInterrupt = aesEngineReadyInterrupt
                    static let usart2DataRegisterEmpty = Caption(value: "USART2 Data register Empty")
                    static let USART2DataRegisterEmpty = usart2DataRegisterEmpty
                    static let trx24PLLUnlockInterrupt = Caption(value: "TRX24 - PLL unlock interrupt")
                    static let trx24PllUnlockInterrupt = trx24PLLUnlockInterrupt
                    static let TRX24PLLUnlockInterrupt = trx24PLLUnlockInterrupt
                    static let trx24CCAEDDoneInterrupt = Caption(value: "TRX24 - CCA/ED done interrupt")
                    static let trx24CcaEdDoneInterrupt = trx24CCAEDDoneInterrupt
                    static let TRX24CCAEDDoneInterrupt = trx24CCAEDDoneInterrupt
                    static let serialTransferComplete = Caption(value: "Serial Transfer Complete")
                    static let SerialTransferComplete = serialTransferComplete
                    static let trx24PLLLockInterrupt = Caption(value: "TRX24 - PLL lock interrupt")
                    static let trx24PllLockInterrupt = trx24PLLLockInterrupt
                    static let TRX24PLLLockInterrupt = trx24PLLLockInterrupt
                    static let timer0CompareMatchA = Caption(value: "Timer 0 Compare Match A")
                    static let Timer0CompareMatchA = timer0CompareMatchA
                    static let timer0CompareMatchB = Caption(value: "Timer 0 Compare Match B")
                    static let Timer0CompareMatchB = timer0CompareMatchB
                    static let timer1CompareMatchA = Caption(value: "Timer 1 Compare Match A")
                    static let Timer1CompareMatchA = timer1CompareMatchA
                    static let timer1CompareMatchB = Caption(value: "Timer 1 Compare Match B")
                    static let Timer1CompareMatchB = timer1CompareMatchB
                    static let trx24RXENDInterrupt = Caption(value: "TRX24 - RX_END interrupt")
                    static let trx24RxEndInterrupt = trx24RXENDInterrupt
                    static let TRX24RXENDInterrupt = trx24RXENDInterrupt
                    static let trx24TXENDInterrupt = Caption(value: "TRX24 - TX_END interrupt")
                    static let trx24TxEndInterrupt = trx24TXENDInterrupt
                    static let TRX24TXENDInterrupt = trx24TXENDInterrupt
                    static let externalInterrupt1 = Caption(value: "External Interrupt 1")
                    static let ExternalInterrupt1 = externalInterrupt1
                    static let timer0InputCapture = Caption(value: "Timer 0 Input Capture")
                    static let Timer0InputCapture = timer0InputCapture
                    static let timer1InputCapture = Caption(value: "Timer 1 Input capture")
                    static let Timer1InputCapture = timer1InputCapture
                    static let timer0Overflow = Caption(value: "Timer 0 Overflow")
                    static let Timer0Overflow = timer0Overflow
                    static let timer1Overflow = Caption(value: "Timer 1 overflow")
                    static let Timer1Overflow = timer1Overflow
                    static let trx24XAHAMI = Caption(value: "TRX24 - XAH - AMI")
                    static let trx24XahAmi = trx24XAHAMI
                    static let TRX24XAHAMI = trx24XAHAMI
                    static let RESERVED = Caption(value: "RESERVED")
                    static let reserved = RESERVED
                    static let addressMatchInterruptOfAddressFilter0 = Caption(value: "Address match interrupt of address filter 0")
                    static let AddressMatchInterruptOfAddressFilter0 = addressMatchInterruptOfAddressFilter0
                    static let addressMatchInterruptOfAddressFilter1 = Caption(value: "Address match interrupt of address filter 1")
                    static let AddressMatchInterruptOfAddressFilter1 = addressMatchInterruptOfAddressFilter1
                    static let addressMatchInterruptOfAddressFilter2 = Caption(value: "Address match interrupt of address filter 2")
                    static let AddressMatchInterruptOfAddressFilter2 = addressMatchInterruptOfAddressFilter2
                    static let addressMatchInterruptOfAddressFilter3 = Caption(value: "Address match interrupt of address filter 3")
                    static let AddressMatchInterruptOfAddressFilter3 = addressMatchInterruptOfAddressFilter3
                    static let voltageRegulatorMonitorInterrupt = Caption(value: "Voltage regulator monitor interrupt")
                    static let VoltageRegulatorMonitorInterrupt = voltageRegulatorMonitorInterrupt
                    static let timerCounter1FaultProtection = Caption(value: "Timer/Counter1 Fault Protection")
                    static let TimerCounter1FaultProtection = timerCounter1FaultProtection
                    static let timerCounter1CompareMatchD = Caption(value: "Timer/Counter1 Compare Match D")
                    static let TimerCounter1CompareMatchD = timerCounter1CompareMatchD
                    static let timerCounter0InputCapture = Caption(value: "Timer/Counter0 Input Capture")
                    static let TimerCounter0InputCapture = timerCounter0InputCapture
                    static let canMOBBurstGeneralErrors = Caption(value: "CAN MOB, Burst, General Errors")
                    static let canMobBurstGeneralErrors = canMOBBurstGeneralErrors
                    static let CANMOBBurstGeneralErrors = canMOBBurstGeneralErrors
                    static let usart3DataRegisterEmpty = Caption(value: "USART3 Data register Empty")
                    static let USART3DataRegisterEmpty = usart3DataRegisterEmpty
                    static let timer1Counter1Overflow = Caption(value: "Timer1/Counter1 Overflow")
                    static let Timer1Counter1Overflow = timer1Counter1Overflow
                    static let vccVoltageLevelMonitor = Caption(value: "Vcc Voltage Level Monitor")
                    static let VccVoltageLevelMonitor = vccVoltageLevelMonitor
                    static let trx24TXStartInterrupt = Caption(value: "TRX24 TX start interrupt")
                    static let trx24TxStartInterrupt = trx24TXStartInterrupt
                    static let TRX24TXStartInterrupt = trx24TXStartInterrupt
                    static let timerCouner0Overflow = Caption(value: "Timer/Couner0 Overflow")
                    static let TimerCouner0Overflow = timerCouner0Overflow
                    static let pinChangeInterrupt0 = Caption(value: "Pin Change Interrupt 0")
                    static let PinChangeInterrupt0 = pinChangeInterrupt0
                    static let pinChangeInterrupt1 = Caption(value: "Pin Change Interrupt 1")
                    static let PinChangeInterrupt1 = pinChangeInterrupt1
                    static let pinChangeInterrupt = Caption(value: "Pin Change Interrupt")
                    static let PinChangeInterrupt = pinChangeInterrupt
                    static let canTimerOverflow = Caption(value: "CAN Timer Overflow")
                    static let CANTimerOverflow = canTimerOverflow
                    static let psc1CaptureEvent = Caption(value: "PSC1 Capture Event")
                    static let PSC1CaptureEvent = psc1CaptureEvent
                    static let usart2RxComplete = Caption(value: "USART2, Rx Complete", alternateValues: ["USART2 Rx Complete"])
                    static let USART2RxComplete = usart2RxComplete
                    static let usart2TxComplete = Caption(value: "USART2, Tx Complete", alternateValues: ["USART2 Tx Complete"])
                    static let USART2TxComplete = usart2TxComplete
                    static let usart3RxComplete = Caption(value: "USART3, Rx Complete")
                    static let USART3RxComplete = usart3RxComplete
                    static let usart3TxComplete = Caption(value: "USART3, Tx Complete")
                    static let USART3TxComplete = usart3TxComplete
                    static let pscEndOfCycle = Caption(value: "PSC End of Cycle")
                    static let PSCEndOfCycle = pscEndOfCycle
                    static let psc1EndCycle = Caption(value: "PSC1 End Cycle")
                    static let PSC1EndCycle = psc1EndCycle
                    static let pscFault = Caption(value: "PSC Fault")
                    static let PSCFault = pscFault
                    static let twoWireBusConnectDisconnect = Caption(value: "Two-Wire Bus Connect/Disconnect")
                    static let TwoWireBusConnectDisconnect = twoWireBusConnectDisconnect
                    static let timerCounter2CompareMatchC = Caption(value: "Timer/Counter2 Compare Match C")
                    static let TimerCounter2CompareMatchC = timerCounter2CompareMatchC
                    static let spmReady = Caption(value: "SPM Ready")
                    static let SPMReady = spmReady
                    static let bandgapBufferShortCircuitDetected = Caption(value: "Bandgap Buffer Short Circuit Detected")
                    static let BandgapBufferShortCircuitDetected = bandgapBufferShortCircuitDetected
                    static let serialPeripheralInterface = Caption(value: "Serial Peripheral Interface")
                    static let SerialPeripheralInterface = serialPeripheralInterface
                    static let chargerDetect = Caption(value: "Charger Detect")
                    static let ChargerDetect = chargerDetect
                    static let touchSensing = Caption(value: "Touch Sensing")
                    static let TouchSensing = touchSensing
                    static let usart0Start = Caption(value: "USART0, Start")
                    static let USART0Start = usart0Start
                    static let usart1Start = Caption(value: "USART1, Start")
                    static let USART1Start = usart1Start
                    static let canTransferCompleteOrError = Caption(value: "CAN Transfer Complete or Error")
                    static let CANTransferCompleteOrError = canTransferCompleteOrError
                    static let usartStartEdgeInterrupt = Caption(value: "USART Start Edge Interrupt")
                    static let USARTStartEdgeInterrupt = usartStartEdgeInterrupt
                    static let watchdogTimerOverflow = Caption(value: "Watchdog Timer Overflow")
                    static let WatchdogTimerOverflow = watchdogTimerOverflow
                    static let adcConversionReady = Caption(value: "ADC Conversion ready", alternateValues: ["ADC Conversion Ready"])
                    static let ADCConversionReady = adcConversionReady
                    static let canTimerOverrun = Caption(value: "CAN Timer Overrun")
                    static let CANTimerOverrun = canTimerOverrun
                    static let timerCounter4FaultProtectionInterrupt = Caption(value: "Timer/Counter4 Fault Protection Interrupt")
                    static let TimerCounter4FaultProtectionInterrupt = timerCounter4FaultProtectionInterrupt
                    static let timerCounter0CompareMatch0A = Caption(value: "Timer/Counter0 Compare Match 0A")
                    static let timerCounter0CompareMatch0a = timerCounter0CompareMatch0A
                    static let TimerCounter0CompareMatch0A = timerCounter0CompareMatch0A
                    static let spi1SerialTransferComplete = Caption(value: "SPI1 Serial Transfer Complete")
                    static let SPI1SerialTransferComplete = spi1SerialTransferComplete
                    static let usiStartConditionDetection = Caption(value: "USI Start Condition Detection")
                    static let USIStartConditionDetection = usiStartConditionDetection
                    static let pinChangeInterruptRequestA = Caption(value: "Pin Change Interrupt Request A")
                    static let PinChangeInterruptRequestA = pinChangeInterruptRequestA
                    static let pinChangeInterruptRequestB = Caption(value: "Pin Change Interrupt Request B")
                    static let PinChangeInterruptRequestB = pinChangeInterruptRequestB
                    static let pinChangeInterruptRequestD = Caption(value: "Pin Change Interrupt Request D")
                    static let PinChangeInterruptRequestD = pinChangeInterruptRequestD
                    static let timerCounter4CompareMatchD = Caption(value: "Timer/Counter4 Compare Match D")
                    static let TimerCounter4CompareMatchD = timerCounter4CompareMatchD
                    static let timerCounter1InputCapture = Caption(value: "Timer/Counter1 Input Capture")
                    static let TimerCounter1InputCapture = timerCounter1InputCapture
                    static let usart0RXStartEdgeDetect = Caption(value: "USART0 RX start edge detect")
                    static let usart0RxStartEdgeDetect = usart0RXStartEdgeDetect
                    static let USART0RXStartEdgeDetect = usart0RXStartEdgeDetect
                    static let usart1RXStartEdgeDetect = Caption(value: "USART1 RX start edge detect")
                    static let usart1RxStartEdgeDetect = usart1RXStartEdgeDetect
                    static let USART1RXStartEdgeDetect = usart1RXStartEdgeDetect
                    static let usart2RXStartEdgeDetect = Caption(value: "USART2 RX start edge detect")
                    static let usart2RxStartEdgeDetect = usart2RXStartEdgeDetect
                    static let USART2RXStartEdgeDetect = usart2RXStartEdgeDetect
                    static let psc0EndOfEnhancedCycle = Caption(value: "PSC0 End Of Enhanced Cycle")
                    static let PSC0EndOfEnhancedCycle = psc0EndOfEnhancedCycle
                    static let psc2EndOfEnhancedCycle = Caption(value: "PSC2 End Of Enhanced Cycle")
                    static let PSC2EndOfEnhancedCycle = psc2EndOfEnhancedCycle
                    static let conversionComplete = Caption(value: "Conversion Complete")
                    static let ConversionComplete = conversionComplete
                    static let usiCounterOverflow = Caption(value: "USI Counter Overflow")
                    static let USICounterOverflow = usiCounterOverflow
                    static let twoWireInterface = Caption(value: "Two-Wire Interface")
                    static let TwoWireInterface = twoWireInterface
                    static let usartRXStart = Caption(value: "USART RX Start")
                    static let usartRxStart = usartRXStart
                    static let USARTRXStart = usartRXStart
                    static let Reserved1 = Caption(value: "Reserved1")
                    static let reserved1 = Reserved1
                    static let Reserved2 = Caption(value: "Reserved2")
                    static let reserved2 = Reserved2
                    static let Reserved3 = Caption(value: "Reserved3")
                    static let reserved3 = Reserved3
                    static let Reserved4 = Caption(value: "Reserved4")
                    static let reserved4 = Reserved4
                    static let Reserved5 = Caption(value: "Reserved5")
                    static let reserved5 = Reserved5
                    static let Reserved6 = Caption(value: "Reserved6")
                    static let reserved6 = Reserved6
                    static let voltageADCInstantaneousConversionComplete = Caption(value: "Voltage ADC Instantaneous Conversion Complete")
                    static let voltageAdcInstantaneousConversionComplete = voltageADCInstantaneousConversionComplete
                    static let VoltageADCInstantaneousConversionComplete = voltageADCInstantaneousConversionComplete
                    static let voltageADCAccumulatedConversionComplete = Caption(value: "Voltage ADC Accumulated Conversion Complete")
                    static let voltageAdcAccumulatedConversionComplete = voltageADCAccumulatedConversionComplete
                    static let VoltageADCAccumulatedConversionComplete = voltageADCAccumulatedConversionComplete
                    static let cADCInstantaneousConversionComplete = Caption(value: "C-ADC Instantaneous Conversion Complete")
                    static let cAdcInstantaneousConversionComplete = cADCInstantaneousConversionComplete
                    static let CADCInstantaneousConversionComplete = cADCInstantaneousConversionComplete
                    static let cADCAccumulatedConversionComplete = Caption(value: "C-ADC Accumulated Conversion Complete")
                    static let cAdcAccumulatedConversionComplete = cADCAccumulatedConversionComplete
                    static let CADCAccumulatedConversionComplete = cADCAccumulatedConversionComplete
                    static let clockFailureDetectionInterrupt = Caption(value: "Clock failure detection interrupt")
                    static let ClockFailureDetectionInterrupt = clockFailureDetectionInterrupt
                    static let ptcWindowComparatorInterrupt = Caption(value: "PTC window comparator interrupt")
                    static let PTCWindowComparatorInterrupt = ptcWindowComparatorInterrupt
                    static let spi0SerialTransferComplete = Caption(value: "SPI0 Serial Transfer Complete")
                    static let SPI0SerialTransferComplete = spi0SerialTransferComplete
                    static let pinChangeInterruptRequest4 = Caption(value: "Pin Change Interrupt Request 4")
                    static let PinChangeInterruptRequest4 = pinChangeInterruptRequest4
                    static let timerCounter0CompareAMatch = Caption(value: "Timer/Counter0 Compare A Match")
                    static let TimerCounter0CompareAMatch = timerCounter0CompareAMatch
                    static let timerCounter0CompareBMatch = Caption(value: "Timer/Counter0 Compare B Match")
                    static let TimerCounter0CompareBMatch = timerCounter0CompareBMatch
                    static let usart0StartFrameDetection = Caption(value: "USART0 Start frame detection")
                    static let USART0StartFrameDetection = usart0StartFrameDetection
                    static let usart1StartFrameDetection = Caption(value: "USART1 Start frame detection")
                    static let USART1StartFrameDetection = usart1StartFrameDetection
                    static let ptcWindowComparatorMode = Caption(value: "PTC Window comparator mode")
                    static let PTCWindowComparatorMode = ptcWindowComparatorMode
                    static let pllLockChangeInterrupt = Caption(value: "PLL Lock Change Interrupt")
                    static let PLLLockChangeInterrupt = pllLockChangeInterrupt
                    static let value2WireSerialInterface0 = Caption(value: "2-wire Serial Interface 0")
                    static let value2WireSerialInterface1 = Caption(value: "2-wire Serial Interface 1")
                    static let crystalFailureDetect = Caption(value: "Crystal failure detect")
                    static let CrystalFailureDetect = crystalFailureDetect
                    static let twiTransferComplete = Caption(value: "TWI Transfer Complete")
                    static let TWITransferComplete = twiTransferComplete
                    static let wakeupTimerOverflow = Caption(value: "Wakeup Timer Overflow", alternateValues: ["Wakeup timer overflow"])
                    static let WakeupTimerOverflow = wakeupTimerOverflow
                    static let linStatusInterrupt = Caption(value: "LIN Status Interrupt")
                    static let LINStatusInterrupt = linStatusInterrupt
                    static let cADCRegularCurrent = Caption(value: "C-ADC Regular Current")
                    static let cAdcRegularCurrent = cADCRegularCurrent
                    static let CADCRegularCurrent = cADCRegularCurrent
                    static let ptcEndOfConversion = Caption(value: "PTC end of conversion", alternateValues: ["PTC End of conversion"])
                    static let PTCEndOfConversion = ptcEndOfConversion
                    static let timer0CompareMatch = Caption(value: "Timer 0 Compare Match")
                    static let Timer0CompareMatch = timer0CompareMatch
                    static let linErrorInterrupt = Caption(value: "LIN Error Interrupt")
                    static let LINErrorInterrupt = linErrorInterrupt
                    static let usartStart = Caption(value: "USART, Start")
                    static let USARTStart = usartStart

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Caption] = [
                                externalInterruptRequest0,
                                eepromReady,
                                timerCounter0Overflow,
                                adcConversionComplete,
                                timerCounter1Overflow,
                                analogComparator,
                                pinChangeInterruptRequest0,
                                timerCounter1CaptureEvent,
                                timerCounter1CompareMatchA,
                                spiSerialTransferComplete,
                                storeProgramMemoryRead,
                                pinChangeInterruptRequest1,
                                externalInterruptRequest1,
                                timerCounter2Overflow,
                                timerCounter1CompareMatchB,
                                externalInterruptRequest2,
                                usart0TxComplete,
                                timerCounter0CompareMatchA,
                                externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRResetSeeDatasheet,
                                timerCounter2CompareMatchA,
                                timerCounter0CompareMatchB,
                                watchdogTimeOutInterrupt,
                                timerCounterCompareMatchB,
                                usart0RxComplete,
                                usiOverflow,
                                pinChangeInterruptRequest2,
                                timerCounter2CompareMatch,
                                externalInterruptRequest3,
                                timerCounter0CompareMatch,
                                usart0DataRegisterEmpty,
                                timerCounter2CompareMatchB,
                                usiStartCondition,
                                value2WireSerialInterface,
                                pinChangeInterruptRequest3,
                                usart1RxComplete,
                                usart1TxComplete,
                                externalPinPowerOnResetBrownOutResetAndWatchdogReset,
                                timerCounter3CompareMatchA,
                                timerCounter3CompareMatchB,
                                externalInterruptRequest6,
                                timerCounter3CaptureEvent,
                                timerCounter3Overflow,
                                usartRxComplete,
                                externalInterruptRequest4,
                                externalInterruptRequest5,
                                externalInterruptRequest7,
                                externalResetPowerOnResetAndWatchdogReset,
                                timerCounter1CompareMatchC,
                                timerCounter3CompareMatchC,
                                twoWireSerialInterface,
                                externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRReset,
                                usart1DataRegisterEmpty,
                                usartTxComplete,
                                watchdogTimeOut,
                                usartDataRegisterEmpty,
                                externalInterrupt0,
                                lcdStartOfFrame,
                                timerCounter4CompareMatchA,
                                timerCounter4CompareMatchB,
                                timerCounter4Overflow,
                                analogComparator1,
                                timerCounter4CaptureEvent,
                                analogComparator0,
                                analogComparator2,
                                timerCounter1CompareMatch1A,
                                timerCounter4CompareMatchC,
                                timerCounter5CompareMatchA,
                                timerCounter5CompareMatchB,
                                timerCounter5CompareMatchC,
                                timerCounter5CaptureEvent,
                                timerCounter5Overflow,
                                usbEndpointPipeInterruptCommunicationRequest,
                                usbGeneralInterruptRequest,
                                usiStart,
                                timerCounter1CompareMatch1B,
                                timerCounterCompareMatchA,
                                linTransferComplete,
                                analogComparator3,
                                psc0CaptureEvent,
                                psc2CaptureEvent,
                                psc0EndCycle,
                                psc2EndCycle,
                                linError,
                                batteryMonitorIndicatesSupplyVoltageBelowThreshold,
                                trx24AwakeTransceiverIsReachingStateTRXOFF,
                                coulombCounterADCConversionComplete,
                                symbolCounterCompareMatch1Interrupt,
                                symbolCounterCompareMatch2Interrupt,
                                symbolCounterCompareMatch3Interrupt,
                                coloumbCounterADCRegularCurrent,
                                symbolCounterOverflowInterrupt,
                                symbolCounterBackoffInterrupt,
                                coloumbCounterADCAccumulator,
                                voltageADCConversionComplete,
                                batteryProtectionInterrupt,
                                trx24ReceiveStartInterrupt,
                                timerCounter2CaptureEvent,
                                aesEngineReadyInterrupt,
                                usart2DataRegisterEmpty,
                                trx24PLLUnlockInterrupt,
                                trx24CCAEDDoneInterrupt,
                                serialTransferComplete,
                                trx24PLLLockInterrupt,
                                timer0CompareMatchA,
                                timer0CompareMatchB,
                                timer1CompareMatchA,
                                timer1CompareMatchB,
                                trx24RXENDInterrupt,
                                trx24TXENDInterrupt,
                                externalInterrupt1,
                                timer0InputCapture,
                                timer1InputCapture,
                                timer0Overflow,
                                timer1Overflow,
                                trx24XAHAMI,
                                RESERVED,
                                addressMatchInterruptOfAddressFilter0,
                                addressMatchInterruptOfAddressFilter1,
                                addressMatchInterruptOfAddressFilter2,
                                addressMatchInterruptOfAddressFilter3,
                                voltageRegulatorMonitorInterrupt,
                                timerCounter1FaultProtection,
                                timerCounter1CompareMatchD,
                                timerCounter0InputCapture,
                                canMOBBurstGeneralErrors,
                                usart3DataRegisterEmpty,
                                timer1Counter1Overflow,
                                vccVoltageLevelMonitor,
                                trx24TXStartInterrupt,
                                timerCouner0Overflow,
                                pinChangeInterrupt0,
                                pinChangeInterrupt1,
                                pinChangeInterrupt,
                                canTimerOverflow,
                                psc1CaptureEvent,
                                usart2RxComplete,
                                usart2TxComplete,
                                usart3RxComplete,
                                usart3TxComplete,
                                pscEndOfCycle,
                                psc1EndCycle,
                                pscFault,
                                twoWireBusConnectDisconnect,
                                timerCounter2CompareMatchC,
                                spmReady,
                                bandgapBufferShortCircuitDetected,
                                serialPeripheralInterface,
                                chargerDetect,
                                touchSensing,
                                usart0Start,
                                usart1Start,
                                canTransferCompleteOrError,
                                usartStartEdgeInterrupt,
                                watchdogTimerOverflow,
                                adcConversionReady,
                                canTimerOverrun,
                                timerCounter4FaultProtectionInterrupt,
                                timerCounter0CompareMatch0A,
                                spi1SerialTransferComplete,
                                usiStartConditionDetection,
                                pinChangeInterruptRequestA,
                                pinChangeInterruptRequestB,
                                pinChangeInterruptRequestD,
                                timerCounter4CompareMatchD,
                                timerCounter1InputCapture,
                                usart0RXStartEdgeDetect,
                                usart1RXStartEdgeDetect,
                                usart2RXStartEdgeDetect,
                                psc0EndOfEnhancedCycle,
                                psc2EndOfEnhancedCycle,
                                conversionComplete,
                                usiCounterOverflow,
                                twoWireInterface,
                                usartRXStart,
                                Reserved1,
                                Reserved2,
                                Reserved3,
                                Reserved4,
                                Reserved5,
                                Reserved6,
                                voltageADCInstantaneousConversionComplete,
                                voltageADCAccumulatedConversionComplete,
                                cADCInstantaneousConversionComplete,
                                cADCAccumulatedConversionComplete,
                                clockFailureDetectionInterrupt,
                                ptcWindowComparatorInterrupt,
                                spi0SerialTransferComplete,
                                pinChangeInterruptRequest4,
                                timerCounter0CompareAMatch,
                                timerCounter0CompareBMatch,
                                usart0StartFrameDetection,
                                usart1StartFrameDetection,
                                ptcWindowComparatorMode,
                                pllLockChangeInterrupt,
                                value2WireSerialInterface0,
                                value2WireSerialInterface1,
                                crystalFailureDetect,
                                twiTransferComplete,
                                wakeupTimerOverflow,
                                linStatusInterrupt,
                                cADCRegularCurrent,
                                ptcEndOfConversion,
                                timer0CompareMatch,
                                linErrorInterrupt,
                                usartStart
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct ModuleInstance: ATDFStringValue {
                    static let TCA0 = ModuleInstance(value: "TCA0")
                    static let tca0 = TCA0
                    static let USART0 = ModuleInstance(value: "USART0")
                    static let usart0 = USART0
                    static let ADC0 = ModuleInstance(value: "ADC0")
                    static let adc0 = ADC0
                    static let TWI0 = ModuleInstance(value: "TWI0")
                    static let twi0 = TWI0
                    static let RTC = ModuleInstance(value: "RTC")
                    static let rtc = RTC
                    static let USART1 = ModuleInstance(value: "USART1")
                    static let usart1 = USART1
                    static let CRCSCAN = ModuleInstance(value: "CRCSCAN")
                    static let crcscan = CRCSCAN
                    static let NVMCTRL = ModuleInstance(value: "NVMCTRL")
                    static let nvmctrl = NVMCTRL
                    static let PORTA = ModuleInstance(value: "PORTA")
                    static let porta = PORTA
                    static let SPI0 = ModuleInstance(value: "SPI0")
                    static let spi0 = SPI0
                    static let TCB0 = ModuleInstance(value: "TCB0")
                    static let tcb0 = TCB0
                    static let AC0 = ModuleInstance(value: "AC0")
                    static let ac0 = AC0
                    static let BOD = ModuleInstance(value: "BOD")
                    static let bod = BOD
                    static let PORTB = ModuleInstance(value: "PORTB")
                    static let portb = PORTB
                    static let PORTC = ModuleInstance(value: "PORTC")
                    static let portc = PORTC
                    static let TCD0 = ModuleInstance(value: "TCD0")
                    static let tcd0 = TCD0
                    static let TCB1 = ModuleInstance(value: "TCB1")
                    static let tcb1 = TCB1
                    static let USART2 = ModuleInstance(value: "USART2")
                    static let usart2 = USART2
                    static let CCL = ModuleInstance(value: "CCL")
                    static let ccl = CCL
                    static let USART3 = ModuleInstance(value: "USART3")
                    static let usart3 = USART3
                    static let ADC1 = ModuleInstance(value: "ADC1")
                    static let adc1 = ADC1
                    static let PORTD = ModuleInstance(value: "PORTD")
                    static let portd = PORTD
                    static let PORTE = ModuleInstance(value: "PORTE")
                    static let porte = PORTE
                    static let PORTF = ModuleInstance(value: "PORTF")
                    static let portf = PORTF
                    static let TCB2 = ModuleInstance(value: "TCB2")
                    static let tcb2 = TCB2
                    static let AC1 = ModuleInstance(value: "AC1")
                    static let ac1 = AC1
                    static let AC2 = ModuleInstance(value: "AC2")
                    static let ac2 = AC2
                    static let TCB3 = ModuleInstance(value: "TCB3")
                    static let tcb3 = TCB3

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [ModuleInstance] = [
                                TCA0,
                                USART0,
                                ADC0,
                                TWI0,
                                RTC,
                                USART1,
                                CRCSCAN,
                                NVMCTRL,
                                PORTA,
                                SPI0,
                                TCB0,
                                AC0,
                                BOD,
                                PORTB,
                                PORTC,
                                TCD0,
                                TCB1,
                                USART2,
                                CCL,
                                USART3,
                                ADC1,
                                PORTD,
                                PORTE,
                                PORTF,
                                TCB2,
                                AC1,
                                AC2,
                                TCB3
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }
            }
        }

        struct Peripherals: Codable {
            let module: [Module]

            enum CodingKeys: String, CodingKey {
                case module
            }

            struct Module: Codable {
                @Attribute var name: Name
                @Attribute var id: ID?
                let instance: [Instance]

                enum CodingKeys: String, CodingKey {
                    case name
                    case id
                    case instance
                }

                struct Name: ATDFStringValue {
                    static let LOCKBIT = Name(value: "LOCKBIT")
                    static let lockbit = LOCKBIT
                    static let FUSE = Name(value: "FUSE")
                    static let fuse = FUSE
                    static let PORT = Name(value: "PORT")
                    static let port = PORT
                    static let CPU = Name(value: "CPU")
                    static let cpu = CPU
                    static let WDT = Name(value: "WDT")
                    static let wdt = WDT
                    static let AC = Name(value: "AC")
                    static let ac = AC
                    static let ADC = Name(value: "ADC")
                    static let adc = ADC
                    static let SPI = Name(value: "SPI")
                    static let spi = SPI
                    static let EXINT = Name(value: "EXINT")
                    static let exint = EXINT
                    static let USART = Name(value: "USART")
                    static let usart = USART
                    static let EEPROM = Name(value: "EEPROM")
                    static let eeprom = EEPROM
                    static let TC16 = Name(value: "TC16")
                    static let tc16 = TC16
                    static let TC8 = Name(value: "TC8")
                    static let tc8 = TC8
                    static let TWI = Name(value: "TWI")
                    static let twi = TWI
                    static let BOOT_LOAD = Name(value: "BOOT_LOAD")
                    static let bootLOAD = BOOT_LOAD
                    static let bootLoad = BOOT_LOAD
                    static let BOOTLOAD = BOOT_LOAD
                    static let TC8_ASYNC = Name(value: "TC8_ASYNC")
                    static let tc8Async = TC8_ASYNC
                    static let TC8ASYNC = TC8_ASYNC
                    static let JTAG = Name(value: "JTAG")
                    static let jtag = JTAG
                    static let USI = Name(value: "USI")
                    static let usi = USI
                    static let CLKCTRL = Name(value: "CLKCTRL")
                    static let clkctrl = CLKCTRL
                    static let CRCSCAN = Name(value: "CRCSCAN")
                    static let crcscan = CRCSCAN
                    static let NVMCTRL = Name(value: "NVMCTRL")
                    static let nvmctrl = NVMCTRL
                    static let PORTMUX = Name(value: "PORTMUX")
                    static let portmux = PORTMUX
                    static let RSTCTRL = Name(value: "RSTCTRL")
                    static let rstctrl = RSTCTRL
                    static let SLPCTRL = Name(value: "SLPCTRL")
                    static let slpctrl = SLPCTRL
                    static let USERROW = Name(value: "USERROW")
                    static let userrow = USERROW
                    static let CPUINT = Name(value: "CPUINT")
                    static let cpuint = CPUINT
                    static let SIGROW = Name(value: "SIGROW")
                    static let sigrow = SIGROW
                    static let SYSCFG = Name(value: "SYSCFG")
                    static let syscfg = SYSCFG
                    static let EVSYS = Name(value: "EVSYS")
                    static let evsys = EVSYS
                    static let VPORT = Name(value: "VPORT")
                    static let vport = VPORT
                    static let GPIO = Name(value: "GPIO")
                    static let gpio = GPIO
                    static let VREF = Name(value: "VREF")
                    static let vref = VREF
                    static let BOD = Name(value: "BOD")
                    static let bod = BOD
                    static let CCL = Name(value: "CCL")
                    static let ccl = CCL
                    static let RTC = Name(value: "RTC")
                    static let rtc = RTC
                    static let TCA = Name(value: "TCA")
                    static let tca = TCA
                    static let TCB = Name(value: "TCB")
                    static let tcb = TCB
                    static let DAC = Name(value: "DAC")
                    static let dac = DAC
                    static let LCD = Name(value: "LCD")
                    static let lcd = LCD
                    static let TCD = Name(value: "TCD")
                    static let tcd = TCD
                    static let PSC = Name(value: "PSC")
                    static let psc = PSC
                    static let USB_DEVICE = Name(value: "USB_DEVICE")
                    static let usbDevice = USB_DEVICE
                    static let USBDEVICE = USB_DEVICE
                    static let PLL = Name(value: "PLL")
                    static let pll = PLL
                    static let PTC = Name(value: "PTC")
                    static let ptc = PTC
                    static let LINUART = Name(value: "LINUART")
                    static let linuart = LINUART
                    static let CAN = Name(value: "CAN")
                    static let can = CAN
                    static let BANDGAP = Name(value: "BANDGAP")
                    static let bandgap = BANDGAP
                    static let BATTERY_PROTECTION = Name(value: "BATTERY_PROTECTION")
                    static let batteryProtection = BATTERY_PROTECTION
                    static let BATTERYPROTECTION = BATTERY_PROTECTION
                    static let COULOMB_COUNTER = Name(value: "COULOMB_COUNTER")
                    static let coulombCounter = COULOMB_COUNTER
                    static let COULOMBCOUNTER = COULOMB_COUNTER
                    static let PWRCTRL = Name(value: "PWRCTRL")
                    static let pwrctrl = PWRCTRL
                    static let SYMCNT = Name(value: "SYMCNT")
                    static let symcnt = SYMCNT
                    static let FLASH = Name(value: "FLASH")
                    static let flash = FLASH
                    static let TRX24 = Name(value: "TRX24")
                    static let trx24 = TRX24
                    static let FET = Name(value: "FET")
                    static let fet = FET
                    static let VOLTAGE_REGULATOR = Name(value: "VOLTAGE_REGULATOR")
                    static let voltageRegulator = VOLTAGE_REGULATOR
                    static let VOLTAGEREGULATOR = VOLTAGE_REGULATOR
                    static let CELL_BALANCING = Name(value: "CELL_BALANCING")
                    static let cellBalancing = CELL_BALANCING
                    static let CELLBALANCING = CELL_BALANCING
                    static let EUSART = Name(value: "EUSART")
                    static let eusart = EUSART
                    static let MISC = Name(value: "MISC")
                    static let misc = MISC
                    static let CHARGER_DETECT = Name(value: "CHARGER_DETECT")
                    static let chargerDetect = CHARGER_DETECT
                    static let CHARGERDETECT = CHARGER_DETECT
                    static let USB_GLOBAL = Name(value: "USB_GLOBAL")
                    static let usbGlobal = USB_GLOBAL
                    static let USBGLOBAL = USB_GLOBAL
                    static let DEVICEID = Name(value: "DEVICEID")
                    static let deviceid = DEVICEID
                    static let USB_HOST = Name(value: "USB_HOST")
                    static let usbHOST = USB_HOST
                    static let usbHost = USB_HOST
                    static let USBHOST = USB_HOST
                    static let TOCPM = Name(value: "TOCPM")
                    static let tocpm = TOCPM
                    static let CURRENT_SOURCE = Name(value: "CURRENT_SOURCE")
                    static let currentSource = CURRENT_SOURCE
                    static let CURRENTSOURCE = CURRENT_SOURCE
                    static let WAKEUP_TIMER = Name(value: "WAKEUP_TIMER")
                    static let wakeupTimer = WAKEUP_TIMER
                    static let WAKEUPTIMER = WAKEUP_TIMER
                    static let TC10 = Name(value: "TC10")
                    static let tc10 = TC10
                    static let CFD = Name(value: "CFD")
                    static let cfd = CFD
                    static let PS2 = Name(value: "PS2")
                    static let ps2 = PS2

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Name] = [
                                LOCKBIT,
                                FUSE,
                                PORT,
                                CPU,
                                WDT,
                                AC,
                                ADC,
                                SPI,
                                EXINT,
                                USART,
                                EEPROM,
                                TC16,
                                TC8,
                                TWI,
                                BOOT_LOAD,
                                TC8_ASYNC,
                                JTAG,
                                USI,
                                CLKCTRL,
                                CRCSCAN,
                                NVMCTRL,
                                PORTMUX,
                                RSTCTRL,
                                SLPCTRL,
                                USERROW,
                                CPUINT,
                                SIGROW,
                                SYSCFG,
                                EVSYS,
                                VPORT,
                                GPIO,
                                VREF,
                                BOD,
                                CCL,
                                RTC,
                                TCA,
                                TCB,
                                DAC,
                                LCD,
                                TCD,
                                PSC,
                                USB_DEVICE,
                                PLL,
                                PTC,
                                LINUART,
                                CAN,
                                BANDGAP,
                                BATTERY_PROTECTION,
                                COULOMB_COUNTER,
                                PWRCTRL,
                                SYMCNT,
                                FLASH,
                                TRX24,
                                FET,
                                VOLTAGE_REGULATOR,
                                CELL_BALANCING,
                                EUSART,
                                MISC,
                                CHARGER_DETECT,
                                USB_GLOBAL,
                                DEVICEID,
                                USB_HOST,
                                TOCPM,
                                CURRENT_SOURCE,
                                WAKEUP_TIMER,
                                TC10,
                                CFD,
                                PS2
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct ID: ATDFStringValue {
                    static let avrtiny2 = ID(value: "avrtiny2")
                    static let Avrtiny2 = avrtiny2
                    static let I2601 = ID(value: "I2601")
                    static let i2601 = I2601
                    static let I2103 = ID(value: "I2103")
                    static let i2103 = I2103
                    static let I2605 = ID(value: "I2605")
                    static let i2605 = I2605
                    static let I2600 = ID(value: "I2600")
                    static let i2600 = I2600
                    static let I2604 = ID(value: "I2604")
                    static let i2604 = I2604
                    static let I2100 = ID(value: "I2100")
                    static let i2100 = I2100
                    static let I2104 = ID(value: "I2104")
                    static let i2104 = I2104
                    static let I2106 = ID(value: "I2106")
                    static let i2106 = I2106
                    static let I2107 = ID(value: "I2107")
                    static let i2107 = I2107
                    static let I2108 = ID(value: "I2108")
                    static let i2108 = I2108
                    static let I2109 = ID(value: "I2109")
                    static let i2109 = I2109
                    static let I2110 = ID(value: "I2110")
                    static let i2110 = I2110
                    static let I2111 = ID(value: "I2111")
                    static let i2111 = I2111
                    static let I2112 = ID(value: "I2112")
                    static let i2112 = I2112
                    static let I2114 = ID(value: "I2114")
                    static let i2114 = I2114
                    static let I2116 = ID(value: "I2116")
                    static let i2116 = I2116
                    static let I2117 = ID(value: "I2117")
                    static let i2117 = I2117
                    static let I2119 = ID(value: "I2119")
                    static let i2119 = I2119
                    static let I2122 = ID(value: "I2122")
                    static let i2122 = I2122
                    static let I2127 = ID(value: "I2127")
                    static let i2127 = I2127
                    static let I2128 = ID(value: "I2128")
                    static let i2128 = I2128
                    static let I2132 = ID(value: "I2132")
                    static let i2132 = I2132
                    static let I2606 = ID(value: "I2606")
                    static let i2606 = I2606
                    static let I2602 = ID(value: "I2602")
                    static let i2602 = I2602
                    static let gpio_ports_avr_v1 = ID(value: "gpio_ports_avr_v1")
                    static let gpioPortsAvrV1 = gpio_ports_avr_v1
                    static let GpioPortsAvrV1 = gpio_ports_avr_v1
                    static let I2603 = ID(value: "I2603")
                    static let i2603 = I2603
                    static let I2121 = ID(value: "I2121")
                    static let i2121 = I2121
                    static let I2129 = ID(value: "I2129")
                    static let i2129 = I2129
                    static let rst_integration_avr_v1 = ID(value: "rst_integration_avr_v1")
                    static let rstIntegrationAvrV1 = rst_integration_avr_v1
                    static let RstIntegrationAvrV1 = rst_integration_avr_v1
                    static let clk_sleep_ctrl_avr_v1 = ID(value: "clk_sleep_ctrl_avr_v1")
                    static let clkSleepCtrlAvrV1 = clk_sleep_ctrl_avr_v1
                    static let ClkSleepCtrlAvrV1 = clk_sleep_ctrl_avr_v1
                    static let wdt_windowed_avr_v1 = ID(value: "wdt_windowed_avr_v1")
                    static let wdtWindowedAvrV1 = wdt_windowed_avr_v1
                    static let WdtWindowedAvrV1 = wdt_windowed_avr_v1
                    static let adc_12b_diff_ctrl_v2 = ID(value: "adc_12b_diff_ctrl_v2")
                    static let adc12bDiffCtrlV2 = adc_12b_diff_ctrl_v2
                    static let Adc12bDiffCtrlV2 = adc_12b_diff_ctrl_v2
                    static let cmp_control_avr_v3 = ID(value: "cmp_control_avr_v3")
                    static let cmpControlAvrV3 = cmp_control_avr_v3
                    static let CmpControlAvrV3 = cmp_control_avr_v3
                    static let tmr_16b_capture_v1 = ID(value: "tmr_16b_capture_v1")
                    static let tmr16bCaptureV1 = tmr_16b_capture_v1
                    static let Tmr16bCaptureV1 = tmr_16b_capture_v1
                    static let bor_lvd_ctrl_avr_v1 = ID(value: "bor_lvd_ctrl_avr_v1")
                    static let borLvdCtrlAvrV1 = bor_lvd_ctrl_avr_v1
                    static let BorLvdCtrlAvrV1 = bor_lvd_ctrl_avr_v1
                    static let math_pdi_crc_avr_v1 = ID(value: "math_pdi_crc_avr_v1")
                    static let mathPdiCrcAvrV1 = math_pdi_crc_avr_v1
                    static let MathPdiCrcAvrV1 = math_pdi_crc_avr_v1
                    static let uart_autobd_v4 = ID(value: "uart_autobd_v4")
                    static let uartAutobdV4 = uart_autobd_v4
                    static let UartAutobdV4 = uart_autobd_v4
                    static let i2c_8bit_avr_v1 = ID(value: "i2c_8bit_avr_v1")
                    static let i2c8bitAvrV1 = i2c_8bit_avr_v1
                    static let I2c8bitAvrV1 = i2c_8bit_avr_v1
                    static let nvm_ctrl_avr_v2 = ID(value: "nvm_ctrl_avr_v2")
                    static let nvmCtrlAvrV2 = nvm_ctrl_avr_v2
                    static let NvmCtrlAvrV2 = nvm_ctrl_avr_v2
                    static let tmr_16b_pwm_v1 = ID(value: "tmr_16b_pwm_v1")
                    static let tmr16bPwmV1 = tmr_16b_pwm_v1
                    static let Tmr16bPwmV1 = tmr_16b_pwm_v1
                    static let tmr_16b_rtc_v1 = ID(value: "tmr_16b_rtc_v1")
                    static let tmr16bRtcV1 = tmr_16b_rtc_v1
                    static let Tmr16bRtcV1 = tmr_16b_rtc_v1
                    static let int_8bit_v3 = ID(value: "int_8bit_v3")
                    static let int8bitV3 = int_8bit_v3
                    static let Int8bitV3 = int_8bit_v3
                    static let spi_8bit_v2 = ID(value: "spi_8bit_v2")
                    static let spi8bitV2 = spi_8bit_v2
                    static let Spi8bitV2 = spi_8bit_v2
                    static let cla_ccl_v1 = ID(value: "cla_ccl_v1")
                    static let claCclV1 = cla_ccl_v1
                    static let ClaCclV1 = cla_ccl_v1
                    static let cpu_avr_v2 = ID(value: "cpu_avr_v2")
                    static let cpuAvrV2 = cpu_avr_v2
                    static let CpuAvrV2 = cpu_avr_v2
                    static let ev_ctrl_v1 = ID(value: "ev_ctrl_v1")
                    static let evCtrlV1 = ev_ctrl_v1
                    static let EvCtrlV1 = ev_ctrl_v1
                    static let I2120 = ID(value: "I2120")
                    static let i2120 = I2120
                    static let I2113 = ID(value: "I2113")
                    static let i2113 = I2113
                    static let I2118 = ID(value: "I2118")
                    static let i2118 = I2118

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [ID] = [
                                avrtiny2,
                                I2601,
                                I2103,
                                I2605,
                                I2600,
                                I2604,
                                I2100,
                                I2104,
                                I2106,
                                I2107,
                                I2108,
                                I2109,
                                I2110,
                                I2111,
                                I2112,
                                I2114,
                                I2116,
                                I2117,
                                I2119,
                                I2122,
                                I2127,
                                I2128,
                                I2132,
                                I2606,
                                I2602,
                                gpio_ports_avr_v1,
                                I2603,
                                I2121,
                                I2129,
                                rst_integration_avr_v1,
                                clk_sleep_ctrl_avr_v1,
                                wdt_windowed_avr_v1,
                                adc_12b_diff_ctrl_v2,
                                cmp_control_avr_v3,
                                tmr_16b_capture_v1,
                                bor_lvd_ctrl_avr_v1,
                                math_pdi_crc_avr_v1,
                                uart_autobd_v4,
                                i2c_8bit_avr_v1,
                                nvm_ctrl_avr_v2,
                                tmr_16b_pwm_v1,
                                tmr_16b_rtc_v1,
                                int_8bit_v3,
                                spi_8bit_v2,
                                cla_ccl_v1,
                                cpu_avr_v2,
                                ev_ctrl_v1,
                                I2120,
                                I2113,
                                I2118
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Instance: Codable {
                    @Attribute var name: Name
                    @Attribute var caption: Caption?
                    let registerGroup: RegisterGroup?
                    let signals: Signals?
                    let parameters: Parameters?

                    enum CodingKeys: String, CodingKey {
                        case name
                        case caption
                        case registerGroup = "register-group"
                        case signals
                        case parameters
                    }

                    struct Name: ATDFStringValue {
                        static let LOCKBIT = Name(value: "LOCKBIT")
                        static let lockbit = LOCKBIT
                        static let FUSE = Name(value: "FUSE")
                        static let fuse = FUSE
                        static let CPU = Name(value: "CPU")
                        static let cpu = CPU
                        static let WDT = Name(value: "WDT")
                        static let wdt = WDT
                        static let PORTB = Name(value: "PORTB")
                        static let portb = PORTB
                        static let EXINT = Name(value: "EXINT")
                        static let exint = EXINT
                        static let TC0 = Name(value: "TC0")
                        static let tc0 = TC0
                        static let PORTC = Name(value: "PORTC")
                        static let portc = PORTC
                        static let PORTA = Name(value: "PORTA")
                        static let porta = PORTA
                        static let AC = Name(value: "AC")
                        static let ac = AC
                        static let EEPROM = Name(value: "EEPROM")
                        static let eeprom = EEPROM
                        static let TC1 = Name(value: "TC1")
                        static let tc1 = TC1
                        static let ADC = Name(value: "ADC")
                        static let adc = ADC
                        static let USART0 = Name(value: "USART0")
                        static let usart0 = USART0
                        static let PORTD = Name(value: "PORTD")
                        static let portd = PORTD
                        static let SPI = Name(value: "SPI")
                        static let spi = SPI
                        static let BOOT_LOAD = Name(value: "BOOT_LOAD")
                        static let bootLOAD = BOOT_LOAD
                        static let bootLoad = BOOT_LOAD
                        static let BOOTLOAD = BOOT_LOAD
                        static let TC2 = Name(value: "TC2")
                        static let tc2 = TC2
                        static let PORTE = Name(value: "PORTE")
                        static let porte = PORTE
                        static let JTAG = Name(value: "JTAG")
                        static let jtag = JTAG
                        static let TWI = Name(value: "TWI")
                        static let twi = TWI
                        static let USART1 = Name(value: "USART1")
                        static let usart1 = USART1
                        static let PORTF = Name(value: "PORTF")
                        static let portf = PORTF
                        static let USI = Name(value: "USI")
                        static let usi = USI
                        static let PORTG = Name(value: "PORTG")
                        static let portg = PORTG
                        static let SPI0 = Name(value: "SPI0")
                        static let spi0 = SPI0
                        static let TWI0 = Name(value: "TWI0")
                        static let twi0 = TWI0
                        static let CLKCTRL = Name(value: "CLKCTRL")
                        static let clkctrl = CLKCTRL
                        static let CRCSCAN = Name(value: "CRCSCAN")
                        static let crcscan = CRCSCAN
                        static let NVMCTRL = Name(value: "NVMCTRL")
                        static let nvmctrl = NVMCTRL
                        static let PORTMUX = Name(value: "PORTMUX")
                        static let portmux = PORTMUX
                        static let RSTCTRL = Name(value: "RSTCTRL")
                        static let rstctrl = RSTCTRL
                        static let SLPCTRL = Name(value: "SLPCTRL")
                        static let slpctrl = SLPCTRL
                        static let USERROW = Name(value: "USERROW")
                        static let userrow = USERROW
                        static let CPUINT = Name(value: "CPUINT")
                        static let cpuint = CPUINT
                        static let SIGROW = Name(value: "SIGROW")
                        static let sigrow = SIGROW
                        static let SYSCFG = Name(value: "SYSCFG")
                        static let syscfg = SYSCFG
                        static let VPORTA = Name(value: "VPORTA")
                        static let vporta = VPORTA
                        static let VPORTB = Name(value: "VPORTB")
                        static let vportb = VPORTB
                        static let VPORTC = Name(value: "VPORTC")
                        static let vportc = VPORTC
                        static let EVSYS = Name(value: "EVSYS")
                        static let evsys = EVSYS
                        static let ADC0 = Name(value: "ADC0")
                        static let adc0 = ADC0
                        static let GPIO = Name(value: "GPIO")
                        static let gpio = GPIO
                        static let TCA0 = Name(value: "TCA0")
                        static let tca0 = TCA0
                        static let TCB0 = Name(value: "TCB0")
                        static let tcb0 = TCB0
                        static let VREF = Name(value: "VREF")
                        static let vref = VREF
                        static let AC0 = Name(value: "AC0")
                        static let ac0 = AC0
                        static let BOD = Name(value: "BOD")
                        static let bod = BOD
                        static let CCL = Name(value: "CCL")
                        static let ccl = CCL
                        static let RTC = Name(value: "RTC")
                        static let rtc = RTC
                        static let TC3 = Name(value: "TC3")
                        static let tc3 = TC3
                        static let TCB1 = Name(value: "TCB1")
                        static let tcb1 = TCB1
                        static let USART = Name(value: "USART")
                        static let usart = USART
                        static let PORTH = Name(value: "PORTH")
                        static let porth = PORTH
                        static let PORTJ = Name(value: "PORTJ")
                        static let portj = PORTJ
                        static let LCD = Name(value: "LCD")
                        static let lcd = LCD
                        static let TC4 = Name(value: "TC4")
                        static let tc4 = TC4
                        static let DAC0 = Name(value: "DAC0")
                        static let dac0 = DAC0
                        static let TCD0 = Name(value: "TCD0")
                        static let tcd0 = TCD0
                        static let DAC = Name(value: "DAC")
                        static let dac = DAC
                        static let USART2 = Name(value: "USART2")
                        static let usart2 = USART2
                        static let TC5 = Name(value: "TC5")
                        static let tc5 = TC5
                        static let USB_DEVICE = Name(value: "USB_DEVICE")
                        static let usbDevice = USB_DEVICE
                        static let USBDEVICE = USB_DEVICE
                        static let PLL = Name(value: "PLL")
                        static let pll = PLL
                        static let PTC = Name(value: "PTC")
                        static let ptc = PTC
                        static let LINUART = Name(value: "LINUART")
                        static let linuart = LINUART
                        static let CAN = Name(value: "CAN")
                        static let can = CAN
                        static let BANDGAP = Name(value: "BANDGAP")
                        static let bandgap = BANDGAP
                        static let VPORTD = Name(value: "VPORTD")
                        static let vportd = VPORTD
                        static let VPORTE = Name(value: "VPORTE")
                        static let vporte = VPORTE
                        static let VPORTF = Name(value: "VPORTF")
                        static let vportf = VPORTF
                        static let PSC0 = Name(value: "PSC0")
                        static let psc0 = PSC0
                        static let PSC2 = Name(value: "PSC2")
                        static let psc2 = PSC2
                        static let TCB2 = Name(value: "TCB2")
                        static let tcb2 = TCB2
                        static let BATTERY_PROTECTION = Name(value: "BATTERY_PROTECTION")
                        static let batteryProtection = BATTERY_PROTECTION
                        static let BATTERYPROTECTION = BATTERY_PROTECTION
                        static let COULOMB_COUNTER = Name(value: "COULOMB_COUNTER")
                        static let coulombCounter = COULOMB_COUNTER
                        static let COULOMBCOUNTER = COULOMB_COUNTER
                        static let USART0_SPI = Name(value: "USART0_SPI")
                        static let usart0SPI = USART0_SPI
                        static let usart0Spi = USART0_SPI
                        static let USART0SPI = USART0_SPI
                        static let USART1_SPI = Name(value: "USART1_SPI")
                        static let usart1SPI = USART1_SPI
                        static let usart1Spi = USART1_SPI
                        static let USART1SPI = USART1_SPI
                        static let PWRCTRL = Name(value: "PWRCTRL")
                        static let pwrctrl = PWRCTRL
                        static let SYMCNT = Name(value: "SYMCNT")
                        static let symcnt = SYMCNT
                        static let USART3 = Name(value: "USART3")
                        static let usart3 = USART3
                        static let FLASH = Name(value: "FLASH")
                        static let flash = FLASH
                        static let TRX24 = Name(value: "TRX24")
                        static let trx24 = TRX24
                        static let FET = Name(value: "FET")
                        static let fet = FET
                        static let VOLTAGE_REGULATOR = Name(value: "VOLTAGE_REGULATOR")
                        static let voltageRegulator = VOLTAGE_REGULATOR
                        static let VOLTAGEREGULATOR = VOLTAGE_REGULATOR
                        static let CELL_BALANCING = Name(value: "CELL_BALANCING")
                        static let cellBalancing = CELL_BALANCING
                        static let CELLBALANCING = CELL_BALANCING
                        static let EUSART = Name(value: "EUSART")
                        static let eusart = EUSART
                        static let ADC1 = Name(value: "ADC1")
                        static let adc1 = ADC1
                        static let DAC1 = Name(value: "DAC1")
                        static let dac1 = DAC1
                        static let DAC2 = Name(value: "DAC2")
                        static let dac2 = DAC2
                        static let MISC = Name(value: "MISC")
                        static let misc = MISC
                        static let AC1 = Name(value: "AC1")
                        static let ac1 = AC1
                        static let AC2 = Name(value: "AC2")
                        static let ac2 = AC2
                        static let CHARGER_DETECT = Name(value: "CHARGER_DETECT")
                        static let chargerDetect = CHARGER_DETECT
                        static let CHARGERDETECT = CHARGER_DETECT
                        static let USB_GLOBAL = Name(value: "USB_GLOBAL")
                        static let usbGlobal = USB_GLOBAL
                        static let USBGLOBAL = USB_GLOBAL
                        static let PSC1 = Name(value: "PSC1")
                        static let psc1 = PSC1
                        static let TCB3 = Name(value: "TCB3")
                        static let tcb3 = TCB3
                        static let PSC = Name(value: "PSC")
                        static let psc = PSC
                        static let DEVICEID = Name(value: "DEVICEID")
                        static let deviceid = DEVICEID
                        static let USB_HOST = Name(value: "USB_HOST")
                        static let usbHOST = USB_HOST
                        static let usbHost = USB_HOST
                        static let USBHOST = USB_HOST
                        static let PORTK = Name(value: "PORTK")
                        static let portk = PORTK
                        static let PORTL = Name(value: "PORTL")
                        static let portl = PORTL
                        static let TOCPM = Name(value: "TOCPM")
                        static let tocpm = TOCPM
                        static let CURRENT_SOURCE = Name(value: "CURRENT_SOURCE")
                        static let currentSource = CURRENT_SOURCE
                        static let CURRENTSOURCE = CURRENT_SOURCE
                        static let WAKEUP_TIMER = Name(value: "WAKEUP_TIMER")
                        static let wakeupTimer = WAKEUP_TIMER
                        static let WAKEUPTIMER = WAKEUP_TIMER
                        static let SPI1 = Name(value: "SPI1")
                        static let spi1 = SPI1
                        static let TWI1 = Name(value: "TWI1")
                        static let twi1 = TWI1
                        static let CFD = Name(value: "CFD")
                        static let cfd = CFD
                        static let PS2 = Name(value: "PS2")
                        static let ps2 = PS2

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Name] = [
                                    LOCKBIT,
                                    FUSE,
                                    CPU,
                                    WDT,
                                    PORTB,
                                    EXINT,
                                    TC0,
                                    PORTC,
                                    PORTA,
                                    AC,
                                    EEPROM,
                                    TC1,
                                    ADC,
                                    USART0,
                                    PORTD,
                                    SPI,
                                    BOOT_LOAD,
                                    TC2,
                                    PORTE,
                                    JTAG,
                                    TWI,
                                    USART1,
                                    PORTF,
                                    USI,
                                    PORTG,
                                    SPI0,
                                    TWI0,
                                    CLKCTRL,
                                    CRCSCAN,
                                    NVMCTRL,
                                    PORTMUX,
                                    RSTCTRL,
                                    SLPCTRL,
                                    USERROW,
                                    CPUINT,
                                    SIGROW,
                                    SYSCFG,
                                    VPORTA,
                                    VPORTB,
                                    VPORTC,
                                    EVSYS,
                                    ADC0,
                                    GPIO,
                                    TCA0,
                                    TCB0,
                                    VREF,
                                    AC0,
                                    BOD,
                                    CCL,
                                    RTC,
                                    TC3,
                                    TCB1,
                                    USART,
                                    PORTH,
                                    PORTJ,
                                    LCD,
                                    TC4,
                                    DAC0,
                                    TCD0,
                                    DAC,
                                    USART2,
                                    TC5,
                                    USB_DEVICE,
                                    PLL,
                                    PTC,
                                    LINUART,
                                    CAN,
                                    BANDGAP,
                                    VPORTD,
                                    VPORTE,
                                    VPORTF,
                                    PSC0,
                                    PSC2,
                                    TCB2,
                                    BATTERY_PROTECTION,
                                    COULOMB_COUNTER,
                                    USART0_SPI,
                                    USART1_SPI,
                                    PWRCTRL,
                                    SYMCNT,
                                    USART3,
                                    FLASH,
                                    TRX24,
                                    FET,
                                    VOLTAGE_REGULATOR,
                                    CELL_BALANCING,
                                    EUSART,
                                    ADC1,
                                    DAC1,
                                    DAC2,
                                    MISC,
                                    AC1,
                                    AC2,
                                    CHARGER_DETECT,
                                    USB_GLOBAL,
                                    PSC1,
                                    TCB3,
                                    PSC,
                                    DEVICEID,
                                    USB_HOST,
                                    PORTK,
                                    PORTL,
                                    TOCPM,
                                    CURRENT_SOURCE,
                                    WAKEUP_TIMER,
                                    SPI1,
                                    TWI1,
                                    CFD,
                                    PS2
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Caption: ATDFStringValue {
                        static let iOPort = Caption(value: "I/O Port")
                        static let IOPort = iOPort
                        static let timerCounter16Bit = Caption(value: "Timer/Counter, 16-bit")
                        static let TimerCounter16Bit = timerCounter16Bit
                        static let externalInterrupts = Caption(value: "External Interrupts")
                        static let ExternalInterrupts = externalInterrupts
                        static let watchdogTimer = Caption(value: "Watchdog Timer")
                        static let WatchdogTimer = watchdogTimer
                        static let cpuRegisters = Caption(value: "CPU Registers")
                        static let CPURegisters = cpuRegisters
                        static let Lockbits = Caption(value: "Lockbits")
                        static let lockbits = Lockbits
                        static let Fuses = Caption(value: "Fuses")
                        static let fuses = Fuses
                        static let USART = Caption(value: "USART")
                        static let usart = USART
                        static let analogComparator = Caption(value: "Analog Comparator")
                        static let AnalogComparator = analogComparator
                        static let timerCounter8Bit = Caption(value: "Timer/Counter, 8-bit")
                        static let TimerCounter8Bit = timerCounter8Bit
                        static let EEPROM = Caption(value: "EEPROM")
                        static let eeprom = EEPROM
                        static let analogToDigitalConverter = Caption(value: "Analog-to-Digital Converter")
                        static let AnalogToDigitalConverter = analogToDigitalConverter
                        static let serialPeripheralInterface = Caption(value: "Serial Peripheral Interface")
                        static let SerialPeripheralInterface = serialPeripheralInterface
                        static let Bootloader = Caption(value: "Bootloader")
                        static let bootloader = Bootloader
                        static let timerCounter8BitAsync = Caption(value: "Timer/Counter, 8-bit Async")
                        static let TimerCounter8BitAsync = timerCounter8BitAsync
                        static let twoWireSerialInterface = Caption(value: "Two Wire Serial Interface")
                        static let TwoWireSerialInterface = twoWireSerialInterface
                        static let jtagInterface = Caption(value: "JTAG Interface")
                        static let JTAGInterface = jtagInterface
                        static let universalSerialInterface = Caption(value: "Universal Serial Interface")
                        static let UniversalSerialInterface = universalSerialInterface
                        static let powerStageController = Caption(value: "Power Stage Controller")
                        static let PowerStageController = powerStageController
                        static let liquidCrystalDisplay = Caption(value: "Liquid Crystal Display")
                        static let LiquidCrystalDisplay = liquidCrystalDisplay
                        static let digitalToAnalogConverter = Caption(value: "Digital-to-Analog Converter")
                        static let DigitalToAnalogConverter = digitalToAnalogConverter
                        static let usbDeviceRegisters = Caption(value: "USB Device Registers")
                        static let USBDeviceRegisters = usbDeviceRegisters
                        static let phaseLockedLoop = Caption(value: "Phase Locked Loop")
                        static let PhaseLockedLoop = phaseLockedLoop
                        static let localInterconnectNetwork = Caption(value: "Local Interconnect Network")
                        static let LocalInterconnectNetwork = localInterconnectNetwork
                        static let controllerAreaNetwork = Caption(value: "Controller Area Network")
                        static let ControllerAreaNetwork = controllerAreaNetwork
                        static let Bandgap = Caption(value: "Bandgap")
                        static let bandgap = Bandgap
                        static let lowPower24GhzTransceiver = Caption(value: "Low-Power 2.4 GHz Transceiver")
                        static let lowPower24GHzTransceiver = lowPower24GhzTransceiver
                        static let LowPower24GhzTransceiver = lowPower24GhzTransceiver
                        static let batteryProtection = Caption(value: "Battery Protection")
                        static let BatteryProtection = batteryProtection
                        static let macSymbolCounter = Caption(value: "MAC Symbol Counter")
                        static let MACSymbolCounter = macSymbolCounter
                        static let flashController = Caption(value: "FLASH Controller")
                        static let FLASHController = flashController
                        static let powerController = Caption(value: "Power Controller")
                        static let PowerController = powerController
                        static let coulombCounter = Caption(value: "Coulomb Counter")
                        static let CoulombCounter = coulombCounter
                        static let fetControl = Caption(value: "FET Control")
                        static let FETControl = fetControl
                        static let voltageRegulator = Caption(value: "Voltage Regulator")
                        static let VoltageRegulator = voltageRegulator
                        static let otherRegisters = Caption(value: "Other Registers")
                        static let OtherRegisters = otherRegisters
                        static let cellBalancing = Caption(value: "Cell Balancing")
                        static let CellBalancing = cellBalancing
                        static let extendedUsart = Caption(value: "Extended USART")
                        static let ExtendedUSART = extendedUsart
                        static let chargerDetect = Caption(value: "Charger Detect")
                        static let ChargerDetect = chargerDetect
                        static let usbController = Caption(value: "USB Controller")
                        static let USBController = usbController
                        static let timerCounterOutputComparePin = Caption(value: "Timer/Counter Output Compare Pin")
                        static let TimerCounterOutputComparePin = timerCounterOutputComparePin
                        static let usbHostRegisters = Caption(value: "USB Host Registers")
                        static let USBHostRegisters = usbHostRegisters
                        static let deviceID = Caption(value: "Device ID")
                        static let deviceId = deviceID
                        static let DeviceID = deviceID
                        static let timerCounter10Bit = Caption(value: "Timer/Counter, 10-bit")
                        static let TimerCounter10Bit = timerCounter10Bit
                        static let currentSource = Caption(value: "Current Source")
                        static let CurrentSource = currentSource
                        static let ps2Controller = Caption(value: "PS/2 Controller")
                        static let PS2Controller = ps2Controller
                        static let wakeupTimer = Caption(value: "Wakeup Timer")
                        static let WakeupTimer = wakeupTimer
                        static let peripheralTouchController = Caption(value: "Peripheral Touch Controller")
                        static let PeripheralTouchController = peripheralTouchController
                        static let clockFailureDetection = Caption(value: "Clock Failure Detection")
                        static let ClockFailureDetection = clockFailureDetection

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Caption] = [
                                    iOPort,
                                    timerCounter16Bit,
                                    externalInterrupts,
                                    watchdogTimer,
                                    cpuRegisters,
                                    Lockbits,
                                    Fuses,
                                    USART,
                                    analogComparator,
                                    timerCounter8Bit,
                                    EEPROM,
                                    analogToDigitalConverter,
                                    serialPeripheralInterface,
                                    Bootloader,
                                    timerCounter8BitAsync,
                                    twoWireSerialInterface,
                                    jtagInterface,
                                    universalSerialInterface,
                                    powerStageController,
                                    liquidCrystalDisplay,
                                    digitalToAnalogConverter,
                                    usbDeviceRegisters,
                                    phaseLockedLoop,
                                    localInterconnectNetwork,
                                    controllerAreaNetwork,
                                    Bandgap,
                                    lowPower24GhzTransceiver,
                                    batteryProtection,
                                    macSymbolCounter,
                                    flashController,
                                    powerController,
                                    coulombCounter,
                                    fetControl,
                                    voltageRegulator,
                                    otherRegisters,
                                    cellBalancing,
                                    extendedUsart,
                                    chargerDetect,
                                    usbController,
                                    timerCounterOutputComparePin,
                                    usbHostRegisters,
                                    deviceID,
                                    timerCounter10Bit,
                                    currentSource,
                                    ps2Controller,
                                    wakeupTimer,
                                    peripheralTouchController,
                                    clockFailureDetection
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct RegisterGroup: Codable {
                        @Attribute var name: Name
                        @Attribute var nameInModule: NameInModule
                        @Attribute var offset: Offset
                        @Attribute var addressSpace: AddressSpace
                        @Attribute var caption: Caption?

                        enum CodingKeys: String, CodingKey {
                            case name
                            case nameInModule = "name-in-module"
                            case offset
                            case addressSpace = "address-space"
                            case caption
                        }

                        struct Name: ATDFStringValue {
                            static let LOCKBIT = Name(value: "LOCKBIT")
                            static let lockbit = LOCKBIT
                            static let FUSE = Name(value: "FUSE")
                            static let fuse = FUSE
                            static let CPU = Name(value: "CPU")
                            static let cpu = CPU
                            static let WDT = Name(value: "WDT")
                            static let wdt = WDT
                            static let PORTB = Name(value: "PORTB")
                            static let portb = PORTB
                            static let EXINT = Name(value: "EXINT")
                            static let exint = EXINT
                            static let TC0 = Name(value: "TC0")
                            static let tc0 = TC0
                            static let PORTC = Name(value: "PORTC")
                            static let portc = PORTC
                            static let PORTA = Name(value: "PORTA")
                            static let porta = PORTA
                            static let AC = Name(value: "AC")
                            static let ac = AC
                            static let EEPROM = Name(value: "EEPROM")
                            static let eeprom = EEPROM
                            static let TC1 = Name(value: "TC1")
                            static let tc1 = TC1
                            static let ADC = Name(value: "ADC")
                            static let adc = ADC
                            static let USART0 = Name(value: "USART0")
                            static let usart0 = USART0
                            static let PORTD = Name(value: "PORTD")
                            static let portd = PORTD
                            static let SPI = Name(value: "SPI")
                            static let spi = SPI
                            static let BOOT_LOAD = Name(value: "BOOT_LOAD")
                            static let bootLOAD = BOOT_LOAD
                            static let bootLoad = BOOT_LOAD
                            static let BOOTLOAD = BOOT_LOAD
                            static let TC2 = Name(value: "TC2")
                            static let tc2 = TC2
                            static let PORTE = Name(value: "PORTE")
                            static let porte = PORTE
                            static let JTAG = Name(value: "JTAG")
                            static let jtag = JTAG
                            static let TWI = Name(value: "TWI")
                            static let twi = TWI
                            static let USART1 = Name(value: "USART1")
                            static let usart1 = USART1
                            static let PORTF = Name(value: "PORTF")
                            static let portf = PORTF
                            static let USI = Name(value: "USI")
                            static let usi = USI
                            static let PORTG = Name(value: "PORTG")
                            static let portg = PORTG
                            static let SPI0 = Name(value: "SPI0")
                            static let spi0 = SPI0
                            static let TWI0 = Name(value: "TWI0")
                            static let twi0 = TWI0
                            static let CLKCTRL = Name(value: "CLKCTRL")
                            static let clkctrl = CLKCTRL
                            static let CRCSCAN = Name(value: "CRCSCAN")
                            static let crcscan = CRCSCAN
                            static let NVMCTRL = Name(value: "NVMCTRL")
                            static let nvmctrl = NVMCTRL
                            static let PORTMUX = Name(value: "PORTMUX")
                            static let portmux = PORTMUX
                            static let RSTCTRL = Name(value: "RSTCTRL")
                            static let rstctrl = RSTCTRL
                            static let SLPCTRL = Name(value: "SLPCTRL")
                            static let slpctrl = SLPCTRL
                            static let USERROW = Name(value: "USERROW")
                            static let userrow = USERROW
                            static let CPUINT = Name(value: "CPUINT")
                            static let cpuint = CPUINT
                            static let SIGROW = Name(value: "SIGROW")
                            static let sigrow = SIGROW
                            static let SYSCFG = Name(value: "SYSCFG")
                            static let syscfg = SYSCFG
                            static let VPORTA = Name(value: "VPORTA")
                            static let vporta = VPORTA
                            static let VPORTB = Name(value: "VPORTB")
                            static let vportb = VPORTB
                            static let VPORTC = Name(value: "VPORTC")
                            static let vportc = VPORTC
                            static let EVSYS = Name(value: "EVSYS")
                            static let evsys = EVSYS
                            static let ADC0 = Name(value: "ADC0")
                            static let adc0 = ADC0
                            static let GPIO = Name(value: "GPIO")
                            static let gpio = GPIO
                            static let TCA0 = Name(value: "TCA0")
                            static let tca0 = TCA0
                            static let TCB0 = Name(value: "TCB0")
                            static let tcb0 = TCB0
                            static let VREF = Name(value: "VREF")
                            static let vref = VREF
                            static let AC0 = Name(value: "AC0")
                            static let ac0 = AC0
                            static let BOD = Name(value: "BOD")
                            static let bod = BOD
                            static let CCL = Name(value: "CCL")
                            static let ccl = CCL
                            static let RTC = Name(value: "RTC")
                            static let rtc = RTC
                            static let TC3 = Name(value: "TC3")
                            static let tc3 = TC3
                            static let TCB1 = Name(value: "TCB1")
                            static let tcb1 = TCB1
                            static let USART = Name(value: "USART")
                            static let usart = USART
                            static let PORTH = Name(value: "PORTH")
                            static let porth = PORTH
                            static let PORTJ = Name(value: "PORTJ")
                            static let portj = PORTJ
                            static let LCD = Name(value: "LCD")
                            static let lcd = LCD
                            static let TC4 = Name(value: "TC4")
                            static let tc4 = TC4
                            static let DAC0 = Name(value: "DAC0")
                            static let dac0 = DAC0
                            static let TCD0 = Name(value: "TCD0")
                            static let tcd0 = TCD0
                            static let DAC = Name(value: "DAC")
                            static let dac = DAC
                            static let USART2 = Name(value: "USART2")
                            static let usart2 = USART2
                            static let TC5 = Name(value: "TC5")
                            static let tc5 = TC5
                            static let USB_DEVICE = Name(value: "USB_DEVICE")
                            static let usbDevice = USB_DEVICE
                            static let USBDEVICE = USB_DEVICE
                            static let PLL = Name(value: "PLL")
                            static let pll = PLL
                            static let LINUART = Name(value: "LINUART")
                            static let linuart = LINUART
                            static let CAN = Name(value: "CAN")
                            static let can = CAN
                            static let BANDGAP = Name(value: "BANDGAP")
                            static let bandgap = BANDGAP
                            static let VPORTD = Name(value: "VPORTD")
                            static let vportd = VPORTD
                            static let VPORTE = Name(value: "VPORTE")
                            static let vporte = VPORTE
                            static let VPORTF = Name(value: "VPORTF")
                            static let vportf = VPORTF
                            static let PSC0 = Name(value: "PSC0")
                            static let psc0 = PSC0
                            static let PSC2 = Name(value: "PSC2")
                            static let psc2 = PSC2
                            static let TCB2 = Name(value: "TCB2")
                            static let tcb2 = TCB2
                            static let BATTERY_PROTECTION = Name(value: "BATTERY_PROTECTION")
                            static let batteryProtection = BATTERY_PROTECTION
                            static let BATTERYPROTECTION = BATTERY_PROTECTION
                            static let COULOMB_COUNTER = Name(value: "COULOMB_COUNTER")
                            static let coulombCounter = COULOMB_COUNTER
                            static let COULOMBCOUNTER = COULOMB_COUNTER
                            static let USART0_SPI = Name(value: "USART0_SPI")
                            static let usart0SPI = USART0_SPI
                            static let usart0Spi = USART0_SPI
                            static let USART0SPI = USART0_SPI
                            static let USART1_SPI = Name(value: "USART1_SPI")
                            static let usart1SPI = USART1_SPI
                            static let usart1Spi = USART1_SPI
                            static let USART1SPI = USART1_SPI
                            static let PWRCTRL = Name(value: "PWRCTRL")
                            static let pwrctrl = PWRCTRL
                            static let SYMCNT = Name(value: "SYMCNT")
                            static let symcnt = SYMCNT
                            static let USART3 = Name(value: "USART3")
                            static let usart3 = USART3
                            static let FLASH = Name(value: "FLASH")
                            static let flash = FLASH
                            static let TRX24 = Name(value: "TRX24")
                            static let trx24 = TRX24
                            static let FET = Name(value: "FET")
                            static let fet = FET
                            static let VOLTAGE_REGULATOR = Name(value: "VOLTAGE_REGULATOR")
                            static let voltageRegulator = VOLTAGE_REGULATOR
                            static let VOLTAGEREGULATOR = VOLTAGE_REGULATOR
                            static let CELL_BALANCING = Name(value: "CELL_BALANCING")
                            static let cellBalancing = CELL_BALANCING
                            static let CELLBALANCING = CELL_BALANCING
                            static let EUSART = Name(value: "EUSART")
                            static let eusart = EUSART
                            static let ADC1 = Name(value: "ADC1")
                            static let adc1 = ADC1
                            static let DAC1 = Name(value: "DAC1")
                            static let dac1 = DAC1
                            static let DAC2 = Name(value: "DAC2")
                            static let dac2 = DAC2
                            static let MISC = Name(value: "MISC")
                            static let misc = MISC
                            static let AC1 = Name(value: "AC1")
                            static let ac1 = AC1
                            static let AC2 = Name(value: "AC2")
                            static let ac2 = AC2
                            static let CHARGER_DETECT = Name(value: "CHARGER_DETECT")
                            static let chargerDetect = CHARGER_DETECT
                            static let CHARGERDETECT = CHARGER_DETECT
                            static let USB_GLOBAL = Name(value: "USB_GLOBAL")
                            static let usbGlobal = USB_GLOBAL
                            static let USBGLOBAL = USB_GLOBAL
                            static let PSC1 = Name(value: "PSC1")
                            static let psc1 = PSC1
                            static let TCB3 = Name(value: "TCB3")
                            static let tcb3 = TCB3
                            static let PSC = Name(value: "PSC")
                            static let psc = PSC
                            static let DEVICEID = Name(value: "DEVICEID")
                            static let deviceid = DEVICEID
                            static let USB_HOST = Name(value: "USB_HOST")
                            static let usbHOST = USB_HOST
                            static let usbHost = USB_HOST
                            static let USBHOST = USB_HOST
                            static let PORTK = Name(value: "PORTK")
                            static let portk = PORTK
                            static let PORTL = Name(value: "PORTL")
                            static let portl = PORTL
                            static let TOCPM = Name(value: "TOCPM")
                            static let tocpm = TOCPM
                            static let CURRENT_SOURCE = Name(value: "CURRENT_SOURCE")
                            static let currentSource = CURRENT_SOURCE
                            static let CURRENTSOURCE = CURRENT_SOURCE
                            static let WAKEUP_TIMER = Name(value: "WAKEUP_TIMER")
                            static let wakeupTimer = WAKEUP_TIMER
                            static let WAKEUPTIMER = WAKEUP_TIMER
                            static let SPI1 = Name(value: "SPI1")
                            static let spi1 = SPI1
                            static let TWI1 = Name(value: "TWI1")
                            static let twi1 = TWI1
                            static let CFD = Name(value: "CFD")
                            static let cfd = CFD
                            static let PS2 = Name(value: "PS2")
                            static let ps2 = PS2
                            static let TC = Name(value: "TC")
                            static let tc = TC

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [Name] = [
                                        LOCKBIT,
                                        FUSE,
                                        CPU,
                                        WDT,
                                        PORTB,
                                        EXINT,
                                        TC0,
                                        PORTC,
                                        PORTA,
                                        AC,
                                        EEPROM,
                                        TC1,
                                        ADC,
                                        USART0,
                                        PORTD,
                                        SPI,
                                        BOOT_LOAD,
                                        TC2,
                                        PORTE,
                                        JTAG,
                                        TWI,
                                        USART1,
                                        PORTF,
                                        USI,
                                        PORTG,
                                        SPI0,
                                        TWI0,
                                        CLKCTRL,
                                        CRCSCAN,
                                        NVMCTRL,
                                        PORTMUX,
                                        RSTCTRL,
                                        SLPCTRL,
                                        USERROW,
                                        CPUINT,
                                        SIGROW,
                                        SYSCFG,
                                        VPORTA,
                                        VPORTB,
                                        VPORTC,
                                        EVSYS,
                                        ADC0,
                                        GPIO,
                                        TCA0,
                                        TCB0,
                                        VREF,
                                        AC0,
                                        BOD,
                                        CCL,
                                        RTC,
                                        TC3,
                                        TCB1,
                                        USART,
                                        PORTH,
                                        PORTJ,
                                        LCD,
                                        TC4,
                                        DAC0,
                                        TCD0,
                                        DAC,
                                        USART2,
                                        TC5,
                                        USB_DEVICE,
                                        PLL,
                                        LINUART,
                                        CAN,
                                        BANDGAP,
                                        VPORTD,
                                        VPORTE,
                                        VPORTF,
                                        PSC0,
                                        PSC2,
                                        TCB2,
                                        BATTERY_PROTECTION,
                                        COULOMB_COUNTER,
                                        USART0_SPI,
                                        USART1_SPI,
                                        PWRCTRL,
                                        SYMCNT,
                                        USART3,
                                        FLASH,
                                        TRX24,
                                        FET,
                                        VOLTAGE_REGULATOR,
                                        CELL_BALANCING,
                                        EUSART,
                                        ADC1,
                                        DAC1,
                                        DAC2,
                                        MISC,
                                        AC1,
                                        AC2,
                                        CHARGER_DETECT,
                                        USB_GLOBAL,
                                        PSC1,
                                        TCB3,
                                        PSC,
                                        DEVICEID,
                                        USB_HOST,
                                        PORTK,
                                        PORTL,
                                        TOCPM,
                                        CURRENT_SOURCE,
                                        WAKEUP_TIMER,
                                        SPI1,
                                        TWI1,
                                        CFD,
                                        PS2,
                                        TC
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }

                        struct NameInModule: ATDFStringValue {
                            static let AC = NameInModule(value: "AC")
                            static let ac = AC
                            static let LOCKBIT = NameInModule(value: "LOCKBIT")
                            static let lockbit = LOCKBIT
                            static let FUSE = NameInModule(value: "FUSE")
                            static let fuse = FUSE
                            static let CPU = NameInModule(value: "CPU")
                            static let cpu = CPU
                            static let WDT = NameInModule(value: "WDT")
                            static let wdt = WDT
                            static let ADC = NameInModule(value: "ADC")
                            static let adc = ADC
                            static let SPI = NameInModule(value: "SPI")
                            static let spi = SPI
                            static let EXINT = NameInModule(value: "EXINT")
                            static let exint = EXINT
                            static let PORTB = NameInModule(value: "PORTB")
                            static let portb = PORTB
                            static let TC0 = NameInModule(value: "TC0")
                            static let tc0 = TC0
                            static let EEPROM = NameInModule(value: "EEPROM")
                            static let eeprom = EEPROM
                            static let VPORT = NameInModule(value: "VPORT")
                            static let vport = VPORT
                            static let TC1 = NameInModule(value: "TC1")
                            static let tc1 = TC1
                            static let PORT = NameInModule(value: "PORT")
                            static let port = PORT
                            static let PORTC = NameInModule(value: "PORTC")
                            static let portc = PORTC
                            static let PORTD = NameInModule(value: "PORTD")
                            static let portd = PORTD
                            static let TWI = NameInModule(value: "TWI")
                            static let twi = TWI
                            static let BOOT_LOAD = NameInModule(value: "BOOT_LOAD")
                            static let bootLOAD = BOOT_LOAD
                            static let bootLoad = BOOT_LOAD
                            static let BOOTLOAD = BOOT_LOAD
                            static let PORTA = NameInModule(value: "PORTA")
                            static let porta = PORTA
                            static let TC2 = NameInModule(value: "TC2")
                            static let tc2 = TC2
                            static let USART = NameInModule(value: "USART")
                            static let usart = USART
                            static let USART0 = NameInModule(value: "USART0")
                            static let usart0 = USART0
                            static let TCB = NameInModule(value: "TCB")
                            static let tcb = TCB
                            static let PORTE = NameInModule(value: "PORTE")
                            static let porte = PORTE
                            static let JTAG = NameInModule(value: "JTAG")
                            static let jtag = JTAG
                            static let PORTF = NameInModule(value: "PORTF")
                            static let portf = PORTF
                            static let USI = NameInModule(value: "USI")
                            static let usi = USI
                            static let PORTG = NameInModule(value: "PORTG")
                            static let portg = PORTG
                            static let USART1 = NameInModule(value: "USART1")
                            static let usart1 = USART1
                            static let CLKCTRL = NameInModule(value: "CLKCTRL")
                            static let clkctrl = CLKCTRL
                            static let CRCSCAN = NameInModule(value: "CRCSCAN")
                            static let crcscan = CRCSCAN
                            static let NVMCTRL = NameInModule(value: "NVMCTRL")
                            static let nvmctrl = NVMCTRL
                            static let PORTMUX = NameInModule(value: "PORTMUX")
                            static let portmux = PORTMUX
                            static let RSTCTRL = NameInModule(value: "RSTCTRL")
                            static let rstctrl = RSTCTRL
                            static let SLPCTRL = NameInModule(value: "SLPCTRL")
                            static let slpctrl = SLPCTRL
                            static let USERROW = NameInModule(value: "USERROW")
                            static let userrow = USERROW
                            static let CPUINT = NameInModule(value: "CPUINT")
                            static let cpuint = CPUINT
                            static let SIGROW = NameInModule(value: "SIGROW")
                            static let sigrow = SIGROW
                            static let SYSCFG = NameInModule(value: "SYSCFG")
                            static let syscfg = SYSCFG
                            static let EVSYS = NameInModule(value: "EVSYS")
                            static let evsys = EVSYS
                            static let GPIO = NameInModule(value: "GPIO")
                            static let gpio = GPIO
                            static let VREF = NameInModule(value: "VREF")
                            static let vref = VREF
                            static let BOD = NameInModule(value: "BOD")
                            static let bod = BOD
                            static let CCL = NameInModule(value: "CCL")
                            static let ccl = CCL
                            static let RTC = NameInModule(value: "RTC")
                            static let rtc = RTC
                            static let TCA = NameInModule(value: "TCA")
                            static let tca = TCA
                            static let DAC = NameInModule(value: "DAC")
                            static let dac = DAC
                            static let TC3 = NameInModule(value: "TC3")
                            static let tc3 = TC3
                            static let PORTH = NameInModule(value: "PORTH")
                            static let porth = PORTH
                            static let PORTJ = NameInModule(value: "PORTJ")
                            static let portj = PORTJ
                            static let LCD = NameInModule(value: "LCD")
                            static let lcd = LCD
                            static let TC4 = NameInModule(value: "TC4")
                            static let tc4 = TC4
                            static let TCD = NameInModule(value: "TCD")
                            static let tcd = TCD
                            static let TC5 = NameInModule(value: "TC5")
                            static let tc5 = TC5
                            static let USB_DEVICE = NameInModule(value: "USB_DEVICE")
                            static let usbDevice = USB_DEVICE
                            static let USBDEVICE = USB_DEVICE
                            static let PLL = NameInModule(value: "PLL")
                            static let pll = PLL
                            static let LINUART = NameInModule(value: "LINUART")
                            static let linuart = LINUART
                            static let CAN = NameInModule(value: "CAN")
                            static let can = CAN
                            static let BANDGAP = NameInModule(value: "BANDGAP")
                            static let bandgap = BANDGAP
                            static let PSC0 = NameInModule(value: "PSC0")
                            static let psc0 = PSC0
                            static let PSC2 = NameInModule(value: "PSC2")
                            static let psc2 = PSC2
                            static let BATTERY_PROTECTION = NameInModule(value: "BATTERY_PROTECTION")
                            static let batteryProtection = BATTERY_PROTECTION
                            static let BATTERYPROTECTION = BATTERY_PROTECTION
                            static let COULOMB_COUNTER = NameInModule(value: "COULOMB_COUNTER")
                            static let coulombCounter = COULOMB_COUNTER
                            static let COULOMBCOUNTER = COULOMB_COUNTER
                            static let USART0_SPI = NameInModule(value: "USART0_SPI")
                            static let usart0SPI = USART0_SPI
                            static let usart0Spi = USART0_SPI
                            static let USART0SPI = USART0_SPI
                            static let USART1_SPI = NameInModule(value: "USART1_SPI")
                            static let usart1SPI = USART1_SPI
                            static let usart1Spi = USART1_SPI
                            static let USART1SPI = USART1_SPI
                            static let PWRCTRL = NameInModule(value: "PWRCTRL")
                            static let pwrctrl = PWRCTRL
                            static let SYMCNT = NameInModule(value: "SYMCNT")
                            static let symcnt = SYMCNT
                            static let FLASH = NameInModule(value: "FLASH")
                            static let flash = FLASH
                            static let TRX24 = NameInModule(value: "TRX24")
                            static let trx24 = TRX24
                            static let FET = NameInModule(value: "FET")
                            static let fet = FET
                            static let VOLTAGE_REGULATOR = NameInModule(value: "VOLTAGE_REGULATOR")
                            static let voltageRegulator = VOLTAGE_REGULATOR
                            static let VOLTAGEREGULATOR = VOLTAGE_REGULATOR
                            static let CELL_BALANCING = NameInModule(value: "CELL_BALANCING")
                            static let cellBalancing = CELL_BALANCING
                            static let CELLBALANCING = CELL_BALANCING
                            static let EUSART = NameInModule(value: "EUSART")
                            static let eusart = EUSART
                            static let MISC = NameInModule(value: "MISC")
                            static let misc = MISC
                            static let CHARGER_DETECT = NameInModule(value: "CHARGER_DETECT")
                            static let chargerDetect = CHARGER_DETECT
                            static let CHARGERDETECT = CHARGER_DETECT
                            static let USB_GLOBAL = NameInModule(value: "USB_GLOBAL")
                            static let usbGlobal = USB_GLOBAL
                            static let USBGLOBAL = USB_GLOBAL
                            static let USART2 = NameInModule(value: "USART2")
                            static let usart2 = USART2
                            static let PSC1 = NameInModule(value: "PSC1")
                            static let psc1 = PSC1
                            static let PSC = NameInModule(value: "PSC")
                            static let psc = PSC
                            static let DEVICEID = NameInModule(value: "DEVICEID")
                            static let deviceid = DEVICEID
                            static let USB_HOST = NameInModule(value: "USB_HOST")
                            static let usbHOST = USB_HOST
                            static let usbHost = USB_HOST
                            static let USBHOST = USB_HOST
                            static let USART3 = NameInModule(value: "USART3")
                            static let usart3 = USART3
                            static let PORTK = NameInModule(value: "PORTK")
                            static let portk = PORTK
                            static let PORTL = NameInModule(value: "PORTL")
                            static let portl = PORTL
                            static let TOCPM = NameInModule(value: "TOCPM")
                            static let tocpm = TOCPM
                            static let CURRENT_SOURCE = NameInModule(value: "CURRENT_SOURCE")
                            static let currentSource = CURRENT_SOURCE
                            static let CURRENTSOURCE = CURRENT_SOURCE
                            static let WAKEUP_TIMER = NameInModule(value: "WAKEUP_TIMER")
                            static let wakeupTimer = WAKEUP_TIMER
                            static let WAKEUPTIMER = WAKEUP_TIMER
                            static let SPI0 = NameInModule(value: "SPI0")
                            static let spi0 = SPI0
                            static let SPI1 = NameInModule(value: "SPI1")
                            static let spi1 = SPI1
                            static let TWI0 = NameInModule(value: "TWI0")
                            static let twi0 = TWI0
                            static let TWI1 = NameInModule(value: "TWI1")
                            static let twi1 = TWI1
                            static let CFD = NameInModule(value: "CFD")
                            static let cfd = CFD
                            static let PS2 = NameInModule(value: "PS2")
                            static let ps2 = PS2

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [NameInModule] = [
                                        AC,
                                        LOCKBIT,
                                        FUSE,
                                        CPU,
                                        WDT,
                                        ADC,
                                        SPI,
                                        EXINT,
                                        PORTB,
                                        TC0,
                                        EEPROM,
                                        VPORT,
                                        TC1,
                                        PORT,
                                        PORTC,
                                        PORTD,
                                        TWI,
                                        BOOT_LOAD,
                                        PORTA,
                                        TC2,
                                        USART,
                                        USART0,
                                        TCB,
                                        PORTE,
                                        JTAG,
                                        PORTF,
                                        USI,
                                        PORTG,
                                        USART1,
                                        CLKCTRL,
                                        CRCSCAN,
                                        NVMCTRL,
                                        PORTMUX,
                                        RSTCTRL,
                                        SLPCTRL,
                                        USERROW,
                                        CPUINT,
                                        SIGROW,
                                        SYSCFG,
                                        EVSYS,
                                        GPIO,
                                        VREF,
                                        BOD,
                                        CCL,
                                        RTC,
                                        TCA,
                                        DAC,
                                        TC3,
                                        PORTH,
                                        PORTJ,
                                        LCD,
                                        TC4,
                                        TCD,
                                        TC5,
                                        USB_DEVICE,
                                        PLL,
                                        LINUART,
                                        CAN,
                                        BANDGAP,
                                        PSC0,
                                        PSC2,
                                        BATTERY_PROTECTION,
                                        COULOMB_COUNTER,
                                        USART0_SPI,
                                        USART1_SPI,
                                        PWRCTRL,
                                        SYMCNT,
                                        FLASH,
                                        TRX24,
                                        FET,
                                        VOLTAGE_REGULATOR,
                                        CELL_BALANCING,
                                        EUSART,
                                        MISC,
                                        CHARGER_DETECT,
                                        USB_GLOBAL,
                                        USART2,
                                        PSC1,
                                        PSC,
                                        DEVICEID,
                                        USB_HOST,
                                        USART3,
                                        PORTK,
                                        PORTL,
                                        TOCPM,
                                        CURRENT_SOURCE,
                                        WAKEUP_TIMER,
                                        SPI0,
                                        SPI1,
                                        TWI0,
                                        TWI1,
                                        CFD,
                                        PS2
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }

                        struct Offset: ATDFStringValue {
                            static let zeroX00 = Offset(value: "0x00")
                            static let value0x00 = zeroX00
                            static let zero = Offset(value: "0")
                            static let value0 = zero
                            static let zeroX0000 = Offset(value: "0x0000")
                            static let value0x0000 = zeroX0000
                            static let zeroX0004 = Offset(value: "0x0004")
                            static let value0x0004 = zeroX0004
                            static let zeroX0008 = Offset(value: "0x0008")
                            static let value0x0008 = zeroX0008
                            static let zeroX001C = Offset(value: "0x001C")
                            static let zeroX001c = zeroX001C
                            static let value0x001C = zeroX001C
                            static let zeroX0030 = Offset(value: "0x0030")
                            static let value0x0030 = zeroX0030
                            static let zeroX0040 = Offset(value: "0x0040")
                            static let value0x0040 = zeroX0040
                            static let zeroX0050 = Offset(value: "0x0050")
                            static let value0x0050 = zeroX0050
                            static let zeroX0060 = Offset(value: "0x0060")
                            static let value0x0060 = zeroX0060
                            static let zeroX0080 = Offset(value: "0x0080")
                            static let value0x0080 = zeroX0080
                            static let zeroX00A0 = Offset(value: "0x00A0")
                            static let zeroX00a0 = zeroX00A0
                            static let value0x00A0 = zeroX00A0
                            static let zeroX0100 = Offset(value: "0x0100")
                            static let value0x0100 = zeroX0100
                            static let zeroX0110 = Offset(value: "0x0110")
                            static let value0x0110 = zeroX0110
                            static let zeroX0120 = Offset(value: "0x0120")
                            static let value0x0120 = zeroX0120
                            static let zeroX0140 = Offset(value: "0x0140")
                            static let value0x0140 = zeroX0140
                            static let zeroX0180 = Offset(value: "0x0180")
                            static let value0x0180 = zeroX0180
                            static let zeroX01C0 = Offset(value: "0x01C0")
                            static let zeroX01c0 = zeroX01C0
                            static let value0x01C0 = zeroX01C0
                            static let zeroX0400 = Offset(value: "0x0400")
                            static let value0x0400 = zeroX0400
                            static let zeroX0600 = Offset(value: "0x0600")
                            static let value0x0600 = zeroX0600
                            static let zeroX0800 = Offset(value: "0x0800")
                            static let value0x0800 = zeroX0800
                            static let zeroX0820 = Offset(value: "0x0820")
                            static let value0x0820 = zeroX0820
                            static let zeroX0A00 = Offset(value: "0x0A00")
                            static let zeroX0a00 = zeroX0A00
                            static let value0x0A00 = zeroX0A00
                            static let zeroX0F00 = Offset(value: "0x0F00")
                            static let zeroX0f00 = zeroX0F00
                            static let value0x0F00 = zeroX0F00
                            static let zeroX1000 = Offset(value: "0x1000")
                            static let value0x1000 = zeroX1000
                            static let zeroX1100 = Offset(value: "0x1100")
                            static let value0x1100 = zeroX1100
                            static let zeroX1280 = Offset(value: "0x1280")
                            static let value0x1280 = zeroX1280
                            static let zeroX128A = Offset(value: "0x128A")
                            static let zeroX128a = zeroX128A
                            static let value0x128A = zeroX128A
                            static let zeroX1300 = Offset(value: "0x1300")
                            static let value0x1300 = zeroX1300
                            static let zeroX0420 = Offset(value: "0x0420")
                            static let value0x0420 = zeroX0420
                            static let zeroX0680 = Offset(value: "0x0680")
                            static let value0x0680 = zeroX0680
                            static let zeroX0440 = Offset(value: "0x0440")
                            static let value0x0440 = zeroX0440
                            static let zeroX0A80 = Offset(value: "0x0A80")
                            static let zeroX0a80 = zeroX0A80
                            static let value0x0A80 = zeroX0A80
                            static let zeroX0200 = Offset(value: "0x0200")
                            static let value0x0200 = zeroX0200
                            static let zeroX0810 = Offset(value: "0x0810")
                            static let value0x0810 = zeroX0810
                            static let zeroX0A40 = Offset(value: "0x0A40")
                            static let zeroX0a40 = zeroX0A40
                            static let value0x0A40 = zeroX0A40
                            static let zeroX05E0 = Offset(value: "0x05E0")
                            static let zeroX05e0 = zeroX05E0
                            static let value0x05E0 = zeroX05E0
                            static let zeroX08A0 = Offset(value: "0x08A0")
                            static let zeroX08a0 = zeroX08A0
                            static let value0x08A0 = zeroX08A0
                            static let zeroX08C0 = Offset(value: "0x08C0")
                            static let zeroX08c0 = zeroX08C0
                            static let value0x08C0 = zeroX08C0
                            static let zeroX0A90 = Offset(value: "0x0A90")
                            static let zeroX0a90 = zeroX0A90
                            static let value0x0A90 = zeroX0A90
                            static let zeroX0670 = Offset(value: "0x0670")
                            static let value0x0670 = zeroX0670
                            static let zeroX000C = Offset(value: "0x000C")
                            static let zeroX000c = zeroX000C
                            static let value0x000C = zeroX000C
                            static let zeroX0010 = Offset(value: "0x0010")
                            static let value0x0010 = zeroX0010
                            static let zeroX0014 = Offset(value: "0x0014")
                            static let value0x0014 = zeroX0014
                            static let zeroX0460 = Offset(value: "0x0460")
                            static let value0x0460 = zeroX0460
                            static let zeroX0480 = Offset(value: "0x0480")
                            static let value0x0480 = zeroX0480
                            static let zeroX04A0 = Offset(value: "0x04A0")
                            static let zeroX04a0 = zeroX04A0
                            static let value0x04A0 = zeroX04A0
                            static let zeroX0840 = Offset(value: "0x0840")
                            static let value0x0840 = zeroX0840
                            static let zeroX0AA0 = Offset(value: "0x0AA0")
                            static let zeroX0aa0 = zeroX0AA0
                            static let value0x0AA0 = zeroX0AA0
                            static let zeroX0640 = Offset(value: "0x0640")
                            static let value0x0640 = zeroX0640
                            static let zeroX0688 = Offset(value: "0x0688")
                            static let value0x0688 = zeroX0688
                            static let zeroX0690 = Offset(value: "0x0690")
                            static let value0x0690 = zeroX0690
                            static let zeroX06A0 = Offset(value: "0x06A0")
                            static let zeroX06a0 = zeroX06A0
                            static let value0x06A0 = zeroX06A0
                            static let zeroX06A8 = Offset(value: "0x06A8")
                            static let zeroX06a8 = zeroX06A8
                            static let value0x06A8 = zeroX06A8
                            static let zeroX06B0 = Offset(value: "0x06B0")
                            static let zeroX06b0 = zeroX06B0
                            static let value0x06B0 = zeroX06B0
                            static let zeroX0A50 = Offset(value: "0x0A50")
                            static let zeroX0a50 = zeroX0A50
                            static let value0x0A50 = zeroX0A50
                            static let zeroX0860 = Offset(value: "0x0860")
                            static let value0x0860 = zeroX0860
                            static let zeroX0AB0 = Offset(value: "0x0AB0")
                            static let zeroX0ab0 = zeroX0AB0
                            static let value0x0AB0 = zeroX0AB0
                            static let zeroX0 = Offset(value: "0x0")
                            static let value0x0 = zeroX0
                            static let zeroX = zeroX00

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [Offset] = [
                                        zeroX00,
                                        zero,
                                        zeroX0000,
                                        zeroX0004,
                                        zeroX0008,
                                        zeroX001C,
                                        zeroX0030,
                                        zeroX0040,
                                        zeroX0050,
                                        zeroX0060,
                                        zeroX0080,
                                        zeroX00A0,
                                        zeroX0100,
                                        zeroX0110,
                                        zeroX0120,
                                        zeroX0140,
                                        zeroX0180,
                                        zeroX01C0,
                                        zeroX0400,
                                        zeroX0600,
                                        zeroX0800,
                                        zeroX0820,
                                        zeroX0A00,
                                        zeroX0F00,
                                        zeroX1000,
                                        zeroX1100,
                                        zeroX1280,
                                        zeroX128A,
                                        zeroX1300,
                                        zeroX0420,
                                        zeroX0680,
                                        zeroX0440,
                                        zeroX0A80,
                                        zeroX0200,
                                        zeroX0810,
                                        zeroX0A40,
                                        zeroX05E0,
                                        zeroX08A0,
                                        zeroX08C0,
                                        zeroX0A90,
                                        zeroX0670,
                                        zeroX000C,
                                        zeroX0010,
                                        zeroX0014,
                                        zeroX0460,
                                        zeroX0480,
                                        zeroX04A0,
                                        zeroX0840,
                                        zeroX0AA0,
                                        zeroX0640,
                                        zeroX0688,
                                        zeroX0690,
                                        zeroX06A0,
                                        zeroX06A8,
                                        zeroX06B0,
                                        zeroX0A50,
                                        zeroX0860,
                                        zeroX0AB0,
                                        zeroX0
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }

                        struct AddressSpace: ATDFStringValue {
                            static let data = AddressSpace(value: "data")
                            static let Data = data
                            static let lockbits = AddressSpace(value: "lockbits")
                            static let Lockbits = lockbits
                            static let fuses = AddressSpace(value: "fuses")
                            static let Fuses = fuses

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [AddressSpace] = [
                                        data,
                                        lockbits,
                                        fuses
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }

                        struct Caption: ATDFStringValue {
                            static let iOPort = Caption(value: "I/O Port")
                            static let IOPort = iOPort
                            static let timerCounter16Bit = Caption(value: "Timer/Counter, 16-bit")
                            static let TimerCounter16Bit = timerCounter16Bit
                            static let externalInterrupts = Caption(value: "External Interrupts")
                            static let ExternalInterrupts = externalInterrupts
                            static let watchdogTimer = Caption(value: "Watchdog Timer")
                            static let WatchdogTimer = watchdogTimer
                            static let cpuRegisters = Caption(value: "CPU Registers")
                            static let CPURegisters = cpuRegisters
                            static let Lockbits = Caption(value: "Lockbits")
                            static let lockbits = Lockbits
                            static let Fuses = Caption(value: "Fuses")
                            static let fuses = Fuses
                            static let USART = Caption(value: "USART")
                            static let usart = USART
                            static let analogComparator = Caption(value: "Analog Comparator")
                            static let AnalogComparator = analogComparator
                            static let timerCounter8Bit = Caption(value: "Timer/Counter, 8-bit")
                            static let TimerCounter8Bit = timerCounter8Bit
                            static let EEPROM = Caption(value: "EEPROM")
                            static let eeprom = EEPROM
                            static let analogToDigitalConverter = Caption(value: "Analog-to-Digital Converter")
                            static let AnalogToDigitalConverter = analogToDigitalConverter
                            static let serialPeripheralInterface = Caption(value: "Serial Peripheral Interface")
                            static let SerialPeripheralInterface = serialPeripheralInterface
                            static let Bootloader = Caption(value: "Bootloader")
                            static let bootloader = Bootloader
                            static let timerCounter8BitAsync = Caption(value: "Timer/Counter, 8-bit Async")
                            static let TimerCounter8BitAsync = timerCounter8BitAsync
                            static let twoWireSerialInterface = Caption(value: "Two Wire Serial Interface")
                            static let TwoWireSerialInterface = twoWireSerialInterface
                            static let jtagInterface = Caption(value: "JTAG Interface")
                            static let JTAGInterface = jtagInterface
                            static let universalSerialInterface = Caption(value: "Universal Serial Interface")
                            static let UniversalSerialInterface = universalSerialInterface
                            static let powerStageController = Caption(value: "Power Stage Controller")
                            static let PowerStageController = powerStageController
                            static let liquidCrystalDisplay = Caption(value: "Liquid Crystal Display")
                            static let LiquidCrystalDisplay = liquidCrystalDisplay
                            static let digitalToAnalogConverter = Caption(value: "Digital-to-Analog Converter")
                            static let DigitalToAnalogConverter = digitalToAnalogConverter
                            static let usbDeviceRegisters = Caption(value: "USB Device Registers")
                            static let USBDeviceRegisters = usbDeviceRegisters
                            static let phaseLockedLoop = Caption(value: "Phase Locked Loop")
                            static let PhaseLockedLoop = phaseLockedLoop
                            static let localInterconnectNetwork = Caption(value: "Local Interconnect Network")
                            static let LocalInterconnectNetwork = localInterconnectNetwork
                            static let controllerAreaNetwork = Caption(value: "Controller Area Network")
                            static let ControllerAreaNetwork = controllerAreaNetwork
                            static let Bandgap = Caption(value: "Bandgap")
                            static let bandgap = Bandgap
                            static let lowPower24GhzTransceiver = Caption(value: "Low-Power 2.4 GHz Transceiver")
                            static let lowPower24GHzTransceiver = lowPower24GhzTransceiver
                            static let LowPower24GhzTransceiver = lowPower24GhzTransceiver
                            static let batteryProtection = Caption(value: "Battery Protection")
                            static let BatteryProtection = batteryProtection
                            static let macSymbolCounter = Caption(value: "MAC Symbol Counter")
                            static let MACSymbolCounter = macSymbolCounter
                            static let flashController = Caption(value: "FLASH Controller")
                            static let FLASHController = flashController
                            static let powerController = Caption(value: "Power Controller")
                            static let PowerController = powerController
                            static let coulombCounter = Caption(value: "Coulomb Counter")
                            static let CoulombCounter = coulombCounter
                            static let fetControl = Caption(value: "FET Control")
                            static let FETControl = fetControl
                            static let voltageRegulator = Caption(value: "Voltage Regulator")
                            static let VoltageRegulator = voltageRegulator
                            static let otherRegisters = Caption(value: "Other Registers")
                            static let OtherRegisters = otherRegisters
                            static let cellBalancing = Caption(value: "Cell Balancing")
                            static let CellBalancing = cellBalancing
                            static let extendedUsart = Caption(value: "Extended USART")
                            static let ExtendedUSART = extendedUsart
                            static let chargerDetect = Caption(value: "Charger Detect")
                            static let ChargerDetect = chargerDetect
                            static let usbController = Caption(value: "USB Controller")
                            static let USBController = usbController
                            static let timerCounterOutputComparePin = Caption(value: "Timer/Counter Output Compare Pin")
                            static let TimerCounterOutputComparePin = timerCounterOutputComparePin
                            static let usbHostRegisters = Caption(value: "USB Host Registers")
                            static let USBHostRegisters = usbHostRegisters
                            static let deviceID = Caption(value: "Device ID")
                            static let deviceId = deviceID
                            static let DeviceID = deviceID
                            static let timerCounter10Bit = Caption(value: "Timer/Counter, 10-bit")
                            static let TimerCounter10Bit = timerCounter10Bit
                            static let currentSource = Caption(value: "Current Source")
                            static let CurrentSource = currentSource
                            static let ps2Controller = Caption(value: "PS/2 Controller")
                            static let PS2Controller = ps2Controller
                            static let wakeupTimer = Caption(value: "Wakeup Timer")
                            static let WakeupTimer = wakeupTimer
                            static let clockFailureDetection = Caption(value: "Clock Failure Detection")
                            static let ClockFailureDetection = clockFailureDetection

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [Caption] = [
                                        iOPort,
                                        timerCounter16Bit,
                                        externalInterrupts,
                                        watchdogTimer,
                                        cpuRegisters,
                                        Lockbits,
                                        Fuses,
                                        USART,
                                        analogComparator,
                                        timerCounter8Bit,
                                        EEPROM,
                                        analogToDigitalConverter,
                                        serialPeripheralInterface,
                                        Bootloader,
                                        timerCounter8BitAsync,
                                        twoWireSerialInterface,
                                        jtagInterface,
                                        universalSerialInterface,
                                        powerStageController,
                                        liquidCrystalDisplay,
                                        digitalToAnalogConverter,
                                        usbDeviceRegisters,
                                        phaseLockedLoop,
                                        localInterconnectNetwork,
                                        controllerAreaNetwork,
                                        Bandgap,
                                        lowPower24GhzTransceiver,
                                        batteryProtection,
                                        macSymbolCounter,
                                        flashController,
                                        powerController,
                                        coulombCounter,
                                        fetControl,
                                        voltageRegulator,
                                        otherRegisters,
                                        cellBalancing,
                                        extendedUsart,
                                        chargerDetect,
                                        usbController,
                                        timerCounterOutputComparePin,
                                        usbHostRegisters,
                                        deviceID,
                                        timerCounter10Bit,
                                        currentSource,
                                        ps2Controller,
                                        wakeupTimer,
                                        clockFailureDetection
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }
                    }

                    struct Signals: Codable {
                        let signal: [Signal]

                        enum CodingKeys: String, CodingKey {
                            case signal
                        }

                        struct Signal: Codable {
                            @Attribute var group: Group
                            @Attribute var function: Function?
                            @Attribute var pad: Pad
                            @Attribute var index: Index?
                            @Attribute var field: Field?

                            enum CodingKeys: String, CodingKey {
                                case group
                                case function
                                case pad
                                case index
                                case field
                            }

                            struct Group: ATDFStringValue {
                                static let P = Group(value: "P")
                                static let p = P
                                static let PCINT = Group(value: "PCINT")
                                static let pcint = PCINT
                                static let PIN = Group(value: "PIN")
                                static let pin = PIN
                                static let AIN = Group(value: "AIN")
                                static let ain = AIN
                                static let ADC = Group(value: "ADC")
                                static let adc = ADC
                                static let WO = Group(value: "WO")
                                static let wo = WO
                                static let INT = Group(value: "INT")
                                static let int = INT
                                static let RXD = Group(value: "RXD")
                                static let rxd = RXD
                                static let TXD = Group(value: "TXD")
                                static let txd = TXD
                                static let SEG = Group(value: "SEG")
                                static let seg = SEG
                                static let XCK = Group(value: "XCK")
                                static let xck = XCK
                                static let OCA = Group(value: "OCA")
                                static let oca = OCA
                                static let EVAPA = Group(value: "EVAPA")
                                static let evapa = EVAPA
                                static let EVSPA = Group(value: "EVSPA")
                                static let evspa = EVSPA
                                static let OCB = Group(value: "OCB")
                                static let ocb = OCB
                                static let MISO = Group(value: "MISO")
                                static let miso = MISO
                                static let MOSI = Group(value: "MOSI")
                                static let mosi = MOSI
                                static let T = Group(value: "T")
                                static let t = T
                                static let EVOUT = Group(value: "EVOUT")
                                static let evout = EVOUT
                                static let SS = Group(value: "SS")
                                static let ss = SS
                                static let SCK = Group(value: "SCK")
                                static let sck = SCK
                                static let SDA = Group(value: "SDA")
                                static let sda = SDA
                                static let SCL = Group(value: "SCL")
                                static let scl = SCL
                                static let Y = Group(value: "Y")
                                static let y = Y
                                static let LUT0_IN = Group(value: "LUT0_IN")
                                static let lut0IN = LUT0_IN
                                static let lut0In = LUT0_IN
                                static let LUT0IN = LUT0_IN
                                static let XDIR = Group(value: "XDIR")
                                static let xdir = XDIR
                                static let EVAPB = Group(value: "EVAPB")
                                static let evapb = EVAPB
                                static let EVSPB = Group(value: "EVSPB")
                                static let evspb = EVSPB
                                static let X = Group(value: "X")
                                static let x = X
                                static let N = Group(value: "N")
                                static let n = N
                                static let ICP = Group(value: "ICP")
                                static let icp = ICP
                                static let LUT0_OUT = Group(value: "LUT0_OUT")
                                static let lut0OUT = LUT0_OUT
                                static let lut0Out = LUT0_OUT
                                static let LUT0OUT = LUT0_OUT
                                static let LUT1_OUT = Group(value: "LUT1_OUT")
                                static let lut1OUT = LUT1_OUT
                                static let lut1Out = LUT1_OUT
                                static let LUT1OUT = LUT1_OUT
                                static let OUT = Group(value: "OUT")
                                static let out = OUT
                                static let LUT1_IN = Group(value: "LUT1_IN")
                                static let lut1IN = LUT1_IN
                                static let lut1In = LUT1_IN
                                static let LUT1IN = LUT1_IN
                                static let EVAPC = Group(value: "EVAPC")
                                static let evapc = EVAPC
                                static let EVSPC = Group(value: "EVSPC")
                                static let evspc = EVSPC
                                static let LUT2_IN = Group(value: "LUT2_IN")
                                static let lut2IN = LUT2_IN
                                static let lut2In = LUT2_IN
                                static let LUT2IN = LUT2_IN
                                static let TOSC1 = Group(value: "TOSC1")
                                static let tosc1 = TOSC1
                                static let TOSC2 = Group(value: "TOSC2")
                                static let tosc2 = TOSC2
                                static let TOSC = Group(value: "TOSC")
                                static let tosc = TOSC
                                static let CLKO = Group(value: "CLKO")
                                static let clko = CLKO
                                static let LUT3_IN = Group(value: "LUT3_IN")
                                static let lut3IN = LUT3_IN
                                static let lut3In = LUT3_IN
                                static let LUT3IN = LUT3_IN
                                static let TOCC = Group(value: "TOCC")
                                static let tocc = TOCC
                                static let RESET = Group(value: "RESET")
                                static let reset = RESET
                                static let CLKI = Group(value: "CLKI")
                                static let clki = CLKI
                                static let BREAK = Group(value: "BREAK")
                                static let `break` = BREAK
                                static let TCK = Group(value: "TCK")
                                static let tck = TCK
                                static let TDI = Group(value: "TDI")
                                static let tdi = TDI
                                static let TDO = Group(value: "TDO")
                                static let tdo = TDO
                                static let TMS = Group(value: "TMS")
                                static let tms = TMS
                                static let COM = Group(value: "COM")
                                static let com = COM
                                static let AD = Group(value: "AD")
                                static let ad = AD
                                static let A = Group(value: "A")
                                static let a = A
                                static let UPDI = Group(value: "UPDI")
                                static let updi = UPDI
                                static let OCC = Group(value: "OCC")
                                static let occ = OCC
                                static let LUT2_OUT = Group(value: "LUT2_OUT")
                                static let lut2OUT = LUT2_OUT
                                static let lut2Out = LUT2_OUT
                                static let LUT2OUT = LUT2_OUT
                                static let LUT3_OUT = Group(value: "LUT3_OUT")
                                static let lut3OUT = LUT3_OUT
                                static let lut3Out = LUT3_OUT
                                static let LUT3OUT = LUT3_OUT
                                static let CLK = Group(value: "CLK")
                                static let clk = CLK
                                static let ACMPN = Group(value: "ACMPN")
                                static let acmpn = ACMPN
                                static let ACMP = Group(value: "ACMP")
                                static let acmp = ACMP
                                static let T0 = Group(value: "T0")
                                static let t0 = T0
                                static let USCK = Group(value: "USCK")
                                static let usck = USCK
                                static let DI = Group(value: "DI")
                                static let di = DI
                                static let DO = Group(value: "DO")
                                static let `do` = DO
                                static let OC = Group(value: "OC")
                                static let oc = OC
                                static let XTAL1 = Group(value: "XTAL1")
                                static let xtal1 = XTAL1
                                static let XTAL2 = Group(value: "XTAL2")
                                static let xtal2 = XTAL2
                                static let DS = Group(value: "DS")
                                static let ds = DS
                                static let OC0A = Group(value: "OC0A")
                                static let oc0a = OC0A
                                static let OC0B = Group(value: "OC0B")
                                static let oc0b = OC0B
                                static let OC1A = Group(value: "OC1A")
                                static let oc1a = OC1A
                                static let OC1B = Group(value: "OC1B")
                                static let oc1b = OC1B
                                static let T1 = Group(value: "T1")
                                static let t1 = T1
                                static let WOA = Group(value: "WOA")
                                static let woa = WOA
                                static let WOB = Group(value: "WOB")
                                static let wob = WOB
                                static let AREF = Group(value: "AREF")
                                static let aref = AREF
                                static let RESET_ALT = Group(value: "RESET_ALT")
                                static let resetALT = RESET_ALT
                                static let resetAlt = RESET_ALT
                                static let RESETALT = RESET_ALT
                                static let PORTA = Group(value: "PORTA")
                                static let porta = PORTA
                                static let PORTB = Group(value: "PORTB")
                                static let portb = PORTB
                                static let PORTC = Group(value: "PORTC")
                                static let portc = PORTC
                                static let PORTD = Group(value: "PORTD")
                                static let portd = PORTD
                                static let WOC = Group(value: "WOC")
                                static let woc = WOC
                                static let WOD = Group(value: "WOD")
                                static let wod = WOD
                                static let PORTE = Group(value: "PORTE")
                                static let porte = PORTE
                                static let PDI = Group(value: "PDI")
                                static let pdi = PDI
                                static let PDO = Group(value: "PDO")
                                static let pdo = PDO
                                static let OC1AINV = Group(value: "OC1AINV")
                                static let oc1ainv = OC1AINV
                                static let OC1BINV = Group(value: "OC1BINV")
                                static let oc1binv = OC1BINV
                                static let ICP1A = Group(value: "ICP1A")
                                static let icp1a = ICP1A
                                static let ICP1B = Group(value: "ICP1B")
                                static let icp1b = ICP1B
                                static let RXLIN = Group(value: "RXLIN")
                                static let rxlin = RXLIN
                                static let TXLIN = Group(value: "TXLIN")
                                static let txlin = TXLIN
                                static let ICP0 = Group(value: "ICP0")
                                static let icp0 = ICP0
                                static let D2A = Group(value: "D2A")
                                static let d2a = D2A
                                static let T2 = Group(value: "T2")
                                static let t2 = T2
                                static let AIN0 = Group(value: "AIN0")
                                static let ain0 = AIN0
                                static let AIN1 = Group(value: "AIN1")
                                static let ain1 = AIN1
                                static let ICP1 = Group(value: "ICP1")
                                static let icp1 = ICP1
                                static let ALE = Group(value: "ALE")
                                static let ale = ALE
                                static let CTS = Group(value: "CTS")
                                static let cts = CTS
                                static let RTS = Group(value: "RTS")
                                static let rts = RTS
                                static let AC = Group(value: "AC")
                                static let ac = AC
                                static let RD = Group(value: "RD")
                                static let rd = RD
                                static let PSCOUT0A = Group(value: "PSCOUT0A")
                                static let pscout0a = PSCOUT0A
                                static let PSCOUT0B = Group(value: "PSCOUT0B")
                                static let pscout0b = PSCOUT0B
                                static let PSCOUT1A = Group(value: "PSCOUT1A")
                                static let pscout1a = PSCOUT1A
                                static let PSCOUT1B = Group(value: "PSCOUT1B")
                                static let pscout1b = PSCOUT1B
                                static let PSCOUT2A = Group(value: "PSCOUT2A")
                                static let pscout2a = PSCOUT2A
                                static let PSCOUT2B = Group(value: "PSCOUT2B")
                                static let pscout2b = PSCOUT2B
                                static let BREAK_ALT = Group(value: "BREAK_ALT")
                                static let breakALT = BREAK_ALT
                                static let breakAlt = BREAK_ALT
                                static let BREAKALT = BREAK_ALT
                                static let PSCIN0 = Group(value: "PSCIN0")
                                static let pscin0 = PSCIN0
                                static let PSCIN1 = Group(value: "PSCIN1")
                                static let pscin1 = PSCIN1
                                static let PSCIN2 = Group(value: "PSCIN2")
                                static let pscin2 = PSCIN2
                                static let WR = Group(value: "WR")
                                static let wr = WR
                                static let OC1DINV = Group(value: "OC1DINV")
                                static let oc1dinv = OC1DINV
                                static let RXCAN = Group(value: "RXCAN")
                                static let rxcan = RXCAN
                                static let TXCAN = Group(value: "TXCAN")
                                static let txcan = TXCAN
                                static let OC1D = Group(value: "OC1D")
                                static let oc1d = OC1D
                                static let SCLK = Group(value: "SCLK")
                                static let sclk = SCLK
                                static let sclAlt2 = Group(value: "SCL ")
                                static let PCINT0 = Group(value: "PCINT0")
                                static let pcint0 = PCINT0
                                static let PCINT1 = Group(value: "PCINT1")
                                static let pcint1 = PCINT1
                                static let PCINT2 = Group(value: "PCINT2")
                                static let pcint2 = PCINT2
                                static let PCINT3 = Group(value: "PCINT3")
                                static let pcint3 = PCINT3
                                static let PCINT4 = Group(value: "PCINT4")
                                static let pcint4 = PCINT4
                                static let PCINT5 = Group(value: "PCINT5")
                                static let pcint5 = PCINT5
                                static let ACO0 = Group(value: "ACO0")
                                static let aco0 = ACO0
                                static let ACO1 = Group(value: "ACO1")
                                static let aco1 = ACO1
                                static let ICP2 = Group(value: "ICP2")
                                static let icp2 = ICP2
                                static let OC3C = Group(value: "OC3C")
                                static let oc3c = OC3C
                                static let ACO = Group(value: "ACO")
                                static let aco = ACO
                                static let HWB = Group(value: "HWB")
                                static let hwb = HWB
                                static let OCD = Group(value: "OCD")
                                static let ocd = OCD
                                static let _OCA = Group(value: "_OCA")
                                static let _OCB = Group(value: "_OCB")
                                static let _OCD = Group(value: "_OCD")
                                static let PCINT27 = Group(value: "PCINT27")
                                static let pcint27 = PCINT27
                                static let PCINT28 = Group(value: "PCINT28")
                                static let pcint28 = PCINT28
                                static let PCINT29 = Group(value: "PCINT29")
                                static let pcint29 = PCINT29
                                static let PCINT30 = Group(value: "PCINT30")
                                static let pcint30 = PCINT30
                                static let PCINT31 = Group(value: "PCINT31")
                                static let pcint31 = PCINT31
                                static let ADC0 = Group(value: "ADC0")
                                static let adc0 = ADC0
                                static let ADC1 = Group(value: "ADC1")
                                static let adc1 = ADC1
                                static let ADC2 = Group(value: "ADC2")
                                static let adc2 = ADC2
                                static let ADC3 = Group(value: "ADC3")
                                static let adc3 = ADC3
                                static let ADC4 = Group(value: "ADC4")
                                static let adc4 = ADC4
                                static let ADC5 = Group(value: "ADC5")
                                static let adc5 = ADC5
                                static let ADC6 = Group(value: "ADC6")
                                static let adc6 = ADC6
                                static let ADC7 = Group(value: "ADC7")
                                static let adc7 = ADC7
                                static let INT0 = Group(value: "INT0")
                                static let int0 = INT0
                                static let INT1 = Group(value: "INT1")
                                static let int1 = INT1
                                static let INT2 = Group(value: "INT2")
                                static let int2 = INT2
                                static let SCL0 = Group(value: "SCL0")
                                static let scl0 = SCL0
                                static let SCL1 = Group(value: "SCL1")
                                static let scl1 = SCL1
                                static let SDA0 = Group(value: "SDA0")
                                static let sda0 = SDA0
                                static let SDA1 = Group(value: "SDA1")
                                static let sda1 = SDA1
                                static let WD = Group(value: "WD")
                                static let wd = WD

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Group] = [
                                            P,
                                            PCINT,
                                            PIN,
                                            AIN,
                                            ADC,
                                            WO,
                                            INT,
                                            RXD,
                                            TXD,
                                            SEG,
                                            XCK,
                                            OCA,
                                            EVAPA,
                                            EVSPA,
                                            OCB,
                                            MISO,
                                            MOSI,
                                            T,
                                            EVOUT,
                                            SS,
                                            SCK,
                                            SDA,
                                            SCL,
                                            Y,
                                            LUT0_IN,
                                            XDIR,
                                            EVAPB,
                                            EVSPB,
                                            X,
                                            N,
                                            ICP,
                                            LUT0_OUT,
                                            LUT1_OUT,
                                            OUT,
                                            LUT1_IN,
                                            EVAPC,
                                            EVSPC,
                                            LUT2_IN,
                                            TOSC1,
                                            TOSC2,
                                            TOSC,
                                            CLKO,
                                            LUT3_IN,
                                            TOCC,
                                            RESET,
                                            CLKI,
                                            BREAK,
                                            TCK,
                                            TDI,
                                            TDO,
                                            TMS,
                                            COM,
                                            AD,
                                            A,
                                            UPDI,
                                            OCC,
                                            LUT2_OUT,
                                            LUT3_OUT,
                                            CLK,
                                            ACMPN,
                                            ACMP,
                                            T0,
                                            USCK,
                                            DI,
                                            DO,
                                            OC,
                                            XTAL1,
                                            XTAL2,
                                            DS,
                                            OC0A,
                                            OC0B,
                                            OC1A,
                                            OC1B,
                                            T1,
                                            WOA,
                                            WOB,
                                            AREF,
                                            RESET_ALT,
                                            PORTA,
                                            PORTB,
                                            PORTC,
                                            PORTD,
                                            WOC,
                                            WOD,
                                            PORTE,
                                            PDI,
                                            PDO,
                                            OC1AINV,
                                            OC1BINV,
                                            ICP1A,
                                            ICP1B,
                                            RXLIN,
                                            TXLIN,
                                            ICP0,
                                            D2A,
                                            T2,
                                            AIN0,
                                            AIN1,
                                            ICP1,
                                            ALE,
                                            CTS,
                                            RTS,
                                            AC,
                                            RD,
                                            PSCOUT0A,
                                            PSCOUT0B,
                                            PSCOUT1A,
                                            PSCOUT1B,
                                            PSCOUT2A,
                                            PSCOUT2B,
                                            BREAK_ALT,
                                            PSCIN0,
                                            PSCIN1,
                                            PSCIN2,
                                            WR,
                                            OC1DINV,
                                            RXCAN,
                                            TXCAN,
                                            OC1D,
                                            SCLK,
                                            sclAlt2,
                                            PCINT0,
                                            PCINT1,
                                            PCINT2,
                                            PCINT3,
                                            PCINT4,
                                            PCINT5,
                                            ACO0,
                                            ACO1,
                                            ICP2,
                                            OC3C,
                                            ACO,
                                            HWB,
                                            OCD,
                                            _OCA,
                                            _OCB,
                                            _OCD,
                                            PCINT27,
                                            PCINT28,
                                            PCINT29,
                                            PCINT30,
                                            PCINT31,
                                            ADC0,
                                            ADC1,
                                            ADC2,
                                            ADC3,
                                            ADC4,
                                            ADC5,
                                            ADC6,
                                            ADC7,
                                            INT0,
                                            INT1,
                                            INT2,
                                            SCL0,
                                            SCL1,
                                            SDA0,
                                            SDA1,
                                            WD
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }

                            struct Function: ATDFStringValue {
                                static let `default` = Function(value: "default")
                                static let Default = `default`
                                static let IOPORT = Function(value: "IOPORT")
                                static let ioport = IOPORT
                                static let AIN0 = Function(value: "AIN0")
                                static let ain0 = AIN0
                                static let CCL = Function(value: "CCL")
                                static let ccl = CCL
                                static let EVSINCH0 = Function(value: "EVSINCH0")
                                static let evsinch0 = EVSINCH0
                                static let AC0 = Function(value: "AC0")
                                static let ac0 = AC0
                                static let EVAINCH0 = Function(value: "EVAINCH0")
                                static let evainch0 = EVAINCH0
                                static let EXINT = Function(value: "EXINT")
                                static let exint = EXINT
                                static let USART0 = Function(value: "USART0")
                                static let usart0 = USART0
                                static let ADC = Function(value: "ADC")
                                static let adc = ADC
                                static let EXTINT = Function(value: "EXTINT")
                                static let extint = EXTINT
                                static let CLKCTRL = Function(value: "CLKCTRL")
                                static let clkctrl = CLKCTRL
                                static let TCA0 = Function(value: "TCA0")
                                static let tca0 = TCA0
                                static let USART0_ALT = Function(value: "USART0_ALT")
                                static let usart0ALT = USART0_ALT
                                static let usart0Alt = USART0_ALT
                                static let USART0ALT = USART0_ALT
                                static let EVSYS = Function(value: "EVSYS")
                                static let evsys = EVSYS
                                static let SPI = Function(value: "SPI")
                                static let spi = SPI
                                static let EVAINCH1 = Function(value: "EVAINCH1")
                                static let evainch1 = EVAINCH1
                                static let EVSINCH1 = Function(value: "EVSINCH1")
                                static let evsinch1 = EVSINCH1
                                static let TCA = Function(value: "TCA")
                                static let tca = TCA
                                static let CCL_IN = Function(value: "CCL_IN")
                                static let cclIN = CCL_IN
                                static let cclIn = CCL_IN
                                static let CCLIN = CCL_IN
                                static let OTHER = Function(value: "OTHER")
                                static let other = OTHER
                                static let SPI0 = Function(value: "SPI0")
                                static let spi0 = SPI0
                                static let PTC_X = Function(value: "PTC_X")
                                static let ptcX = PTC_X
                                static let PTCX = PTC_X
                                static let PTC_Y = Function(value: "PTC_Y")
                                static let ptcY = PTC_Y
                                static let PTCY = PTC_Y
                                static let USART1 = Function(value: "USART1")
                                static let usart1 = USART1
                                static let TCA0_ALT = Function(value: "TCA0_ALT")
                                static let tca0ALT = TCA0_ALT
                                static let tca0Alt = TCA0_ALT
                                static let TCA0ALT = TCA0_ALT
                                static let PORTA = Function(value: "PORTA")
                                static let porta = PORTA
                                static let PORTB = Function(value: "PORTB")
                                static let portb = PORTB
                                static let SPI0_ALT = Function(value: "SPI0_ALT")
                                static let spi0ALT = SPI0_ALT
                                static let spi0Alt = SPI0_ALT
                                static let SPI0ALT = SPI0_ALT
                                static let EVAINCH2 = Function(value: "EVAINCH2")
                                static let evainch2 = EVAINCH2
                                static let SPI_ALT = Function(value: "SPI_ALT")
                                static let spiALT = SPI_ALT
                                static let spiAlt = SPI_ALT
                                static let SPIALT = SPI_ALT
                                static let CCL_ALT = Function(value: "CCL_ALT")
                                static let cclALT = CCL_ALT
                                static let cclAlt = CCL_ALT
                                static let CCLALT = CCL_ALT
                                static let TWI0 = Function(value: "TWI0")
                                static let twi0 = TWI0
                                static let TCA_ALT3 = Function(value: "TCA_ALT3")
                                static let tcaALT3 = TCA_ALT3
                                static let tcaAlt3 = TCA_ALT3
                                static let TCAALT3 = TCA_ALT3
                                static let TCA_ALT5 = Function(value: "TCA_ALT5")
                                static let tcaALT5 = TCA_ALT5
                                static let tcaAlt5 = TCA_ALT5
                                static let TCAALT5 = TCA_ALT5
                                static let AC = Function(value: "AC")
                                static let ac = AC
                                static let OC = Function(value: "OC")
                                static let oc = OC
                                static let TCB0 = Function(value: "TCB0")
                                static let tcb0 = TCB0
                                static let TCA_ALT = Function(value: "TCA_ALT")
                                static let tcaALT = TCA_ALT
                                static let tcaAlt = TCA_ALT
                                static let TCAALT = TCA_ALT
                                static let AIN1 = Function(value: "AIN1")
                                static let ain1 = AIN1
                                static let TCD0 = Function(value: "TCD0")
                                static let tcd0 = TCD0
                                static let T1 = Function(value: "T1")
                                static let t1 = T1
                                static let TCA_ALT2 = Function(value: "TCA_ALT2")
                                static let tcaALT2 = TCA_ALT2
                                static let tcaAlt2 = TCA_ALT2
                                static let TCAALT2 = TCA_ALT2
                                static let I2C = Function(value: "I2C")
                                static let i2c = I2C
                                static let PSC = Function(value: "PSC")
                                static let psc = PSC
                                static let USART0_ALT1 = Function(value: "USART0_ALT1")
                                static let usart0ALT1 = USART0_ALT1
                                static let usart0Alt1 = USART0_ALT1
                                static let USART0ALT1 = USART0_ALT1
                                static let USART1_ALT = Function(value: "USART1_ALT")
                                static let usart1ALT = USART1_ALT
                                static let usart1Alt = USART1_ALT
                                static let USART1ALT = USART1_ALT
                                static let SPI_ALT1 = Function(value: "SPI_ALT1")
                                static let spiALT1 = SPI_ALT1
                                static let spiAlt1 = SPI_ALT1
                                static let SPIALT1 = SPI_ALT1
                                static let USART2 = Function(value: "USART2")
                                static let usart2 = USART2
                                static let AC1 = Function(value: "AC1")
                                static let ac1 = AC1
                                static let TC1 = Function(value: "TC1")
                                static let tc1 = TC1
                                static let CCL_ALT1 = Function(value: "CCL_ALT1")
                                static let cclALT1 = CCL_ALT1
                                static let cclAlt1 = CCL_ALT1
                                static let CCLALT1 = CCL_ALT1
                                static let AC2 = Function(value: "AC2")
                                static let ac2 = AC2
                                static let ACIN = Function(value: "ACIN")
                                static let acin = ACIN
                                static let TCB1 = Function(value: "TCB1")
                                static let tcb1 = TCB1
                                static let USART2_ALT1 = Function(value: "USART2_ALT1")
                                static let usart2ALT1 = USART2_ALT1
                                static let usart2Alt1 = USART2_ALT1
                                static let USART2ALT1 = USART2_ALT1
                                static let TCA_ALT1 = Function(value: "TCA_ALT1")
                                static let tcaALT1 = TCA_ALT1
                                static let tcaAlt1 = TCA_ALT1
                                static let TCAALT1 = TCA_ALT1
                                static let TWI0_ALT = Function(value: "TWI0_ALT")
                                static let twi0ALT = TWI0_ALT
                                static let twi0Alt = TWI0_ALT
                                static let TWI0ALT = TWI0_ALT
                                static let T0 = Function(value: "T0")
                                static let t0 = T0
                                static let TCB0_ALT = Function(value: "TCB0_ALT")
                                static let tcb0ALT = TCB0_ALT
                                static let tcb0Alt = TCB0_ALT
                                static let TCB0ALT = TCB0_ALT
                                static let EVSYS_ALT1 = Function(value: "EVSYS_ALT1")
                                static let evsysALT1 = EVSYS_ALT1
                                static let evsysAlt1 = EVSYS_ALT1
                                static let EVSYSALT1 = EVSYS_ALT1
                                static let USART = Function(value: "USART")
                                static let usart = USART
                                static let TC0 = Function(value: "TC0")
                                static let tc0 = TC0
                                static let CS = Function(value: "CS")
                                static let cs = CS
                                static let USART1_ALT1 = Function(value: "USART1_ALT1")
                                static let usart1ALT1 = USART1_ALT1
                                static let usart1Alt1 = USART1_ALT1
                                static let USART1ALT1 = USART1_ALT1
                                static let EVSYS_ALT = Function(value: "EVSYS_ALT")
                                static let evsysALT = EVSYS_ALT
                                static let evsysAlt = EVSYS_ALT
                                static let EVSYSALT = EVSYS_ALT
                                static let I2C_ALT1 = Function(value: "I2C_ALT1")
                                static let i2cALT1 = I2C_ALT1
                                static let i2cAlt1 = I2C_ALT1
                                static let I2CALT1 = I2C_ALT1
                                static let I2C_ALT2 = Function(value: "I2C_ALT2")
                                static let i2cALT2 = I2C_ALT2
                                static let i2cAlt2 = I2C_ALT2
                                static let I2CALT2 = I2C_ALT2
                                static let SPI_ALT2 = Function(value: "SPI_ALT2")
                                static let spiALT2 = SPI_ALT2
                                static let spiAlt2 = SPI_ALT2
                                static let SPIALT2 = SPI_ALT2
                                static let TCA_ALT4 = Function(value: "TCA_ALT4")
                                static let tcaALT4 = TCA_ALT4
                                static let tcaAlt4 = TCA_ALT4
                                static let TCAALT4 = TCA_ALT4
                                static let USART3 = Function(value: "USART3")
                                static let usart3 = USART3
                                static let PTC_DS = Function(value: "PTC_DS")
                                static let ptcDS = PTC_DS
                                static let ptcDs = PTC_DS
                                static let PTCDS = PTC_DS
                                static let TWI = Function(value: "TWI")
                                static let twi = TWI
                                static let USI_ALT = Function(value: "USI_ALT")
                                static let usiALT = USI_ALT
                                static let usiAlt = USI_ALT
                                static let USIALT = USI_ALT
                                static let BREAK = Function(value: "BREAK")
                                static let `break` = BREAK
                                static let USI = Function(value: "USI")
                                static let usi = USI
                                static let DAC0 = Function(value: "DAC0")
                                static let dac0 = DAC0
                                static let LIN = Function(value: "LIN")
                                static let lin = LIN
                                static let PDI = Function(value: "PDI")
                                static let pdi = PDI
                                static let AREF = Function(value: "AREF")
                                static let aref = AREF
                                static let USART3_ALT1 = Function(value: "USART3_ALT1")
                                static let usart3ALT1 = USART3_ALT1
                                static let usart3Alt1 = USART3_ALT1
                                static let USART3ALT1 = USART3_ALT1
                                static let TCB0_ALT1 = Function(value: "TCB0_ALT1")
                                static let tcb0ALT1 = TCB0_ALT1
                                static let tcb0Alt1 = TCB0_ALT1
                                static let TCB0ALT1 = TCB0_ALT1
                                static let TCB1_ALT1 = Function(value: "TCB1_ALT1")
                                static let tcb1ALT1 = TCB1_ALT1
                                static let tcb1Alt1 = TCB1_ALT1
                                static let TCB1ALT1 = TCB1_ALT1
                                static let TCB2 = Function(value: "TCB2")
                                static let tcb2 = TCB2
                                static let DEF = Function(value: "DEF")
                                static let def = DEF
                                static let BREAK_ALT = Function(value: "BREAK_ALT")
                                static let breakALT = BREAK_ALT
                                static let breakAlt = BREAK_ALT
                                static let BREAKALT = BREAK_ALT
                                static let USART_ALT = Function(value: "USART_ALT")
                                static let usartALT = USART_ALT
                                static let usartAlt = USART_ALT
                                static let USARTALT = USART_ALT
                                static let TCB1_ALT = Function(value: "TCB1_ALT")
                                static let tcb1ALT = TCB1_ALT
                                static let tcb1Alt = TCB1_ALT
                                static let TCB1ALT = TCB1_ALT
                                static let ACOUT = Function(value: "ACOUT")
                                static let acout = ACOUT
                                static let DAC = Function(value: "DAC")
                                static let dac = DAC
                                static let TCB2_ALT1 = Function(value: "TCB2_ALT1")
                                static let tcb2ALT1 = TCB2_ALT1
                                static let tcb2Alt1 = TCB2_ALT1
                                static let TCB2ALT1 = TCB2_ALT1
                                static let TCB3_ALT1 = Function(value: "TCB3_ALT1")
                                static let tcb3ALT1 = TCB3_ALT1
                                static let tcb3Alt1 = TCB3_ALT1
                                static let TCB3ALT1 = TCB3_ALT1
                                static let ACIN0 = Function(value: "ACIN0")
                                static let acin0 = ACIN0
                                static let ACIN1 = Function(value: "ACIN1")
                                static let acin1 = ACIN1
                                static let TCB3 = Function(value: "TCB3")
                                static let tcb3 = TCB3
                                static let ALT = Function(value: "ALT")
                                static let alt = ALT
                                static let ICP = Function(value: "ICP")
                                static let icp = ICP

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Function] = [
                                            `default`,
                                            IOPORT,
                                            AIN0,
                                            CCL,
                                            EVSINCH0,
                                            AC0,
                                            EVAINCH0,
                                            EXINT,
                                            USART0,
                                            ADC,
                                            EXTINT,
                                            CLKCTRL,
                                            TCA0,
                                            USART0_ALT,
                                            EVSYS,
                                            SPI,
                                            EVAINCH1,
                                            EVSINCH1,
                                            TCA,
                                            CCL_IN,
                                            OTHER,
                                            SPI0,
                                            PTC_X,
                                            PTC_Y,
                                            USART1,
                                            TCA0_ALT,
                                            PORTA,
                                            PORTB,
                                            SPI0_ALT,
                                            EVAINCH2,
                                            SPI_ALT,
                                            CCL_ALT,
                                            TWI0,
                                            TCA_ALT3,
                                            TCA_ALT5,
                                            AC,
                                            OC,
                                            TCB0,
                                            TCA_ALT,
                                            AIN1,
                                            TCD0,
                                            T1,
                                            TCA_ALT2,
                                            I2C,
                                            PSC,
                                            USART0_ALT1,
                                            USART1_ALT,
                                            SPI_ALT1,
                                            USART2,
                                            AC1,
                                            TC1,
                                            CCL_ALT1,
                                            AC2,
                                            ACIN,
                                            TCB1,
                                            USART2_ALT1,
                                            TCA_ALT1,
                                            TWI0_ALT,
                                            T0,
                                            TCB0_ALT,
                                            EVSYS_ALT1,
                                            USART,
                                            TC0,
                                            CS,
                                            USART1_ALT1,
                                            EVSYS_ALT,
                                            I2C_ALT1,
                                            I2C_ALT2,
                                            SPI_ALT2,
                                            TCA_ALT4,
                                            USART3,
                                            PTC_DS,
                                            TWI,
                                            USI_ALT,
                                            BREAK,
                                            USI,
                                            DAC0,
                                            LIN,
                                            PDI,
                                            AREF,
                                            USART3_ALT1,
                                            TCB0_ALT1,
                                            TCB1_ALT1,
                                            TCB2,
                                            DEF,
                                            BREAK_ALT,
                                            USART_ALT,
                                            TCB1_ALT,
                                            ACOUT,
                                            DAC,
                                            TCB2_ALT1,
                                            TCB3_ALT1,
                                            ACIN0,
                                            ACIN1,
                                            TCB3,
                                            ALT,
                                            ICP
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }

                            struct Pad: ATDFStringValue {
                                static let PB2 = Pad(value: "PB2")
                                static let pb2 = PB2
                                static let PB0 = Pad(value: "PB0")
                                static let pb0 = PB0
                                static let PB1 = Pad(value: "PB1")
                                static let pb1 = PB1
                                static let PA2 = Pad(value: "PA2")
                                static let pa2 = PA2
                                static let PA3 = Pad(value: "PA3")
                                static let pa3 = PA3
                                static let PB3 = Pad(value: "PB3")
                                static let pb3 = PB3
                                static let PA1 = Pad(value: "PA1")
                                static let pa1 = PA1
                                static let PA7 = Pad(value: "PA7")
                                static let pa7 = PA7
                                static let PA4 = Pad(value: "PA4")
                                static let pa4 = PA4
                                static let PA5 = Pad(value: "PA5")
                                static let pa5 = PA5
                                static let PA0 = Pad(value: "PA0")
                                static let pa0 = PA0
                                static let PB4 = Pad(value: "PB4")
                                static let pb4 = PB4
                                static let PA6 = Pad(value: "PA6")
                                static let pa6 = PA6
                                static let PB5 = Pad(value: "PB5")
                                static let pb5 = PB5
                                static let PC1 = Pad(value: "PC1")
                                static let pc1 = PC1
                                static let PC2 = Pad(value: "PC2")
                                static let pc2 = PC2
                                static let PC3 = Pad(value: "PC3")
                                static let pc3 = PC3
                                static let PC0 = Pad(value: "PC0")
                                static let pc0 = PC0
                                static let PB7 = Pad(value: "PB7")
                                static let pb7 = PB7
                                static let PD3 = Pad(value: "PD3")
                                static let pd3 = PD3
                                static let PC4 = Pad(value: "PC4")
                                static let pc4 = PC4
                                static let PD2 = Pad(value: "PD2")
                                static let pd2 = PD2
                                static let PB6 = Pad(value: "PB6")
                                static let pb6 = PB6
                                static let PD6 = Pad(value: "PD6")
                                static let pd6 = PD6
                                static let PD4 = Pad(value: "PD4")
                                static let pd4 = PD4
                                static let PC5 = Pad(value: "PC5")
                                static let pc5 = PC5
                                static let PD5 = Pad(value: "PD5")
                                static let pd5 = PD5
                                static let PD1 = Pad(value: "PD1")
                                static let pd1 = PD1
                                static let PD0 = Pad(value: "PD0")
                                static let pd0 = PD0
                                static let PD7 = Pad(value: "PD7")
                                static let pd7 = PD7
                                static let PC6 = Pad(value: "PC6")
                                static let pc6 = PC6
                                static let PE2 = Pad(value: "PE2")
                                static let pe2 = PE2
                                static let PC7 = Pad(value: "PC7")
                                static let pc7 = PC7
                                static let PF4 = Pad(value: "PF4")
                                static let pf4 = PF4
                                static let PF5 = Pad(value: "PF5")
                                static let pf5 = PF5
                                static let PE0 = Pad(value: "PE0")
                                static let pe0 = PE0
                                static let PE1 = Pad(value: "PE1")
                                static let pe1 = PE1
                                static let PF6 = Pad(value: "PF6")
                                static let pf6 = PF6
                                static let PE3 = Pad(value: "PE3")
                                static let pe3 = PE3
                                static let PF2 = Pad(value: "PF2")
                                static let pf2 = PF2
                                static let PF3 = Pad(value: "PF3")
                                static let pf3 = PF3
                                static let PF0 = Pad(value: "PF0")
                                static let pf0 = PF0
                                static let PF1 = Pad(value: "PF1")
                                static let pf1 = PF1
                                static let PE6 = Pad(value: "PE6")
                                static let pe6 = PE6
                                static let PE7 = Pad(value: "PE7")
                                static let pe7 = PE7
                                static let PF7 = Pad(value: "PF7")
                                static let pf7 = PF7
                                static let PE5 = Pad(value: "PE5")
                                static let pe5 = PE5
                                static let PE4 = Pad(value: "PE4")
                                static let pe4 = PE4
                                static let PG3 = Pad(value: "PG3")
                                static let pg3 = PG3
                                static let PG4 = Pad(value: "PG4")
                                static let pg4 = PG4
                                static let PG2 = Pad(value: "PG2")
                                static let pg2 = PG2
                                static let PG1 = Pad(value: "PG1")
                                static let pg1 = PG1
                                static let PG0 = Pad(value: "PG0")
                                static let pg0 = PG0
                                static let PG5 = Pad(value: "PG5")
                                static let pg5 = PG5
                                static let XTAL1 = Pad(value: "XTAL1")
                                static let xtal1 = XTAL1
                                static let XTAL2 = Pad(value: "XTAL2")
                                static let xtal2 = XTAL2
                                static let PJ0 = Pad(value: "PJ0")
                                static let pj0 = PJ0
                                static let PJ1 = Pad(value: "PJ1")
                                static let pj1 = PJ1
                                static let PJ2 = Pad(value: "PJ2")
                                static let pj2 = PJ2
                                static let PK0 = Pad(value: "PK0")
                                static let pk0 = PK0
                                static let PK1 = Pad(value: "PK1")
                                static let pk1 = PK1
                                static let PK2 = Pad(value: "PK2")
                                static let pk2 = PK2
                                static let PK3 = Pad(value: "PK3")
                                static let pk3 = PK3
                                static let PK4 = Pad(value: "PK4")
                                static let pk4 = PK4
                                static let PK5 = Pad(value: "PK5")
                                static let pk5 = PK5
                                static let PK6 = Pad(value: "PK6")
                                static let pk6 = PK6
                                static let PK7 = Pad(value: "PK7")
                                static let pk7 = PK7
                                static let PH0 = Pad(value: "PH0")
                                static let ph0 = PH0
                                static let PH1 = Pad(value: "PH1")
                                static let ph1 = PH1
                                static let PH2 = Pad(value: "PH2")
                                static let ph2 = PH2
                                static let PH3 = Pad(value: "PH3")
                                static let ph3 = PH3
                                static let PH4 = Pad(value: "PH4")
                                static let ph4 = PH4
                                static let PH5 = Pad(value: "PH5")
                                static let ph5 = PH5
                                static let PH6 = Pad(value: "PH6")
                                static let ph6 = PH6
                                static let PJ3 = Pad(value: "PJ3")
                                static let pj3 = PJ3
                                static let PJ4 = Pad(value: "PJ4")
                                static let pj4 = PJ4
                                static let PJ5 = Pad(value: "PJ5")
                                static let pj5 = PJ5
                                static let PJ6 = Pad(value: "PJ6")
                                static let pj6 = PJ6
                                static let PL0 = Pad(value: "PL0")
                                static let pl0 = PL0
                                static let PL1 = Pad(value: "PL1")
                                static let pl1 = PL1
                                static let PL2 = Pad(value: "PL2")
                                static let pl2 = PL2
                                static let PL3 = Pad(value: "PL3")
                                static let pl3 = PL3
                                static let PL4 = Pad(value: "PL4")
                                static let pl4 = PL4
                                static let PL5 = Pad(value: "PL5")
                                static let pl5 = PL5
                                static let PH7 = Pad(value: "PH7")
                                static let ph7 = PH7
                                static let PJ7 = Pad(value: "PJ7")
                                static let pj7 = PJ7
                                static let PL6 = Pad(value: "PL6")
                                static let pl6 = PL6
                                static let PL7 = Pad(value: "PL7")
                                static let pl7 = PL7
                                static let ADC6 = Pad(value: "ADC6")
                                static let adc6 = ADC6
                                static let ADC7 = Pad(value: "ADC7")
                                static let adc7 = ADC7
                                static let PBH7 = Pad(value: "PBH7")
                                static let pbh7 = PBH7

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Pad] = [
                                            PB2,
                                            PB0,
                                            PB1,
                                            PA2,
                                            PA3,
                                            PB3,
                                            PA1,
                                            PA7,
                                            PA4,
                                            PA5,
                                            PA0,
                                            PB4,
                                            PA6,
                                            PB5,
                                            PC1,
                                            PC2,
                                            PC3,
                                            PC0,
                                            PB7,
                                            PD3,
                                            PC4,
                                            PD2,
                                            PB6,
                                            PD6,
                                            PD4,
                                            PC5,
                                            PD5,
                                            PD1,
                                            PD0,
                                            PD7,
                                            PC6,
                                            PE2,
                                            PC7,
                                            PF4,
                                            PF5,
                                            PE0,
                                            PE1,
                                            PF6,
                                            PE3,
                                            PF2,
                                            PF3,
                                            PF0,
                                            PF1,
                                            PE6,
                                            PE7,
                                            PF7,
                                            PE5,
                                            PE4,
                                            PG3,
                                            PG4,
                                            PG2,
                                            PG1,
                                            PG0,
                                            PG5,
                                            XTAL1,
                                            XTAL2,
                                            PJ0,
                                            PJ1,
                                            PJ2,
                                            PK0,
                                            PK1,
                                            PK2,
                                            PK3,
                                            PK4,
                                            PK5,
                                            PK6,
                                            PK7,
                                            PH0,
                                            PH1,
                                            PH2,
                                            PH3,
                                            PH4,
                                            PH5,
                                            PH6,
                                            PJ3,
                                            PJ4,
                                            PJ5,
                                            PJ6,
                                            PL0,
                                            PL1,
                                            PL2,
                                            PL3,
                                            PL4,
                                            PL5,
                                            PH7,
                                            PJ7,
                                            PL6,
                                            PL7,
                                            ADC6,
                                            ADC7,
                                            PBH7
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }

                            struct Index: ATDFStringValue {
                                static let zero = Index(value: "0")
                                static let value0 = zero
                                static let one = Index(value: "1")
                                static let value1 = one
                                static let two = Index(value: "2")
                                static let value2 = two
                                static let three = Index(value: "3")
                                static let value3 = three
                                static let four = Index(value: "4")
                                static let value4 = four
                                static let five = Index(value: "5")
                                static let value5 = five
                                static let six = Index(value: "6")
                                static let value6 = six
                                static let seven = Index(value: "7")
                                static let value7 = seven
                                static let ten = Index(value: "10")
                                static let value10 = ten
                                static let eight = Index(value: "8")
                                static let value8 = eight
                                static let nine = Index(value: "9")
                                static let value9 = nine
                                static let eleven = Index(value: "11")
                                static let value11 = eleven
                                static let twelve = Index(value: "12")
                                static let value12 = twelve
                                static let thirteen = Index(value: "13")
                                static let value13 = thirteen
                                static let fourteen = Index(value: "14")
                                static let value14 = fourteen
                                static let fifteen = Index(value: "15")
                                static let value15 = fifteen
                                static let sixteen = Index(value: "16")
                                static let value16 = sixteen
                                static let seventeen = Index(value: "17")
                                static let value17 = seventeen
                                static let eighteen = Index(value: "18")
                                static let value18 = eighteen
                                static let nineteen = Index(value: "19")
                                static let value19 = nineteen
                                static let twenty = Index(value: "20")
                                static let value20 = twenty
                                static let twentyOne = Index(value: "21")
                                static let value21 = twentyOne
                                static let twentyTwo = Index(value: "22")
                                static let value22 = twentyTwo
                                static let twentyThree = Index(value: "23")
                                static let value23 = twentyThree
                                static let twentyFour = Index(value: "24")
                                static let value24 = twentyFour
                                static let twentyFive = Index(value: "25")
                                static let value25 = twentyFive
                                static let twentySix = Index(value: "26")
                                static let value26 = twentySix
                                static let twentySeven = Index(value: "27")
                                static let value27 = twentySeven
                                static let twentyEight = Index(value: "28")
                                static let value28 = twentyEight
                                static let twentyNine = Index(value: "29")
                                static let value29 = twentyNine
                                static let thirty = Index(value: "30")
                                static let value30 = thirty
                                static let thirtyOne = Index(value: "31")
                                static let value31 = thirtyOne
                                static let zeroAlt2 = Index(value: "00")
                                static let value00 = zeroAlt2
                                static let oneAlt2 = Index(value: "01")
                                static let value01 = oneAlt2
                                static let twoAlt2 = Index(value: "02")
                                static let value02 = twoAlt2
                                static let threeAlt2 = Index(value: "03")
                                static let value03 = threeAlt2
                                static let fourAlt2 = Index(value: "04")
                                static let value04 = fourAlt2
                                static let fiveAlt2 = Index(value: "05")
                                static let value05 = fiveAlt2
                                static let sixAlt2 = Index(value: "06")
                                static let value06 = sixAlt2
                                static let sevenAlt2 = Index(value: "07")
                                static let value07 = sevenAlt2
                                static let eightAlt2 = Index(value: "08")
                                static let value08 = eightAlt2
                                static let nineAlt2 = Index(value: "09")
                                static let value09 = nineAlt2
                                static let thirtyTwo = Index(value: "32")
                                static let value32 = thirtyTwo
                                static let thirtyThree = Index(value: "33")
                                static let value33 = thirtyThree

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Index] = [
                                            zero,
                                            one,
                                            two,
                                            three,
                                            four,
                                            five,
                                            six,
                                            seven,
                                            ten,
                                            eight,
                                            nine,
                                            eleven,
                                            twelve,
                                            thirteen,
                                            fourteen,
                                            fifteen,
                                            sixteen,
                                            seventeen,
                                            eighteen,
                                            nineteen,
                                            twenty,
                                            twentyOne,
                                            twentyTwo,
                                            twentyThree,
                                            twentyFour,
                                            twentyFive,
                                            twentySix,
                                            twentySeven,
                                            twentyEight,
                                            twentyNine,
                                            thirty,
                                            thirtyOne,
                                            zeroAlt2,
                                            oneAlt2,
                                            twoAlt2,
                                            threeAlt2,
                                            fourAlt2,
                                            fiveAlt2,
                                            sixAlt2,
                                            sevenAlt2,
                                            eightAlt2,
                                            nineAlt2,
                                            thirtyTwo,
                                            thirtyThree
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }

                            struct Field: ATDFStringValue {
                                static let portmuxTcarouteaTCA0 = Field(value: "PORTMUX.TCAROUTEA.TCA0")
                                static let portmuxTcarouteaTca0 = portmuxTcarouteaTCA0
                                static let PORTMUXTCAROUTEATCA0 = portmuxTcarouteaTCA0
                                static let evsysSyncch0Syncch0 = Field(value: "EVSYS.SYNCCH0.SYNCCH0")
                                static let EVSYSSYNCCH0SYNCCH0 = evsysSyncch0Syncch0
                                static let evsysAsyncch0Asyncch0 = Field(value: "EVSYS.ASYNCCH0.ASYNCCH0")
                                static let EVSYSASYNCCH0ASYNCCH0 = evsysAsyncch0Asyncch0
                                static let portmuxCtrlbUsart0 = Field(value: "PORTMUX.CTRLB.USART0")
                                static let PORTMUXCTRLBUSART0 = portmuxCtrlbUsart0
                                static let portmuxUsartrouteaUsart0 = Field(value: "PORTMUX.USARTROUTEA.USART0")
                                static let PORTMUXUSARTROUTEAUSART0 = portmuxUsartrouteaUsart0
                                static let portmuxCtrlbSPI0 = Field(value: "PORTMUX.CTRLB.SPI0")
                                static let portmuxCtrlbSpi0 = portmuxCtrlbSPI0
                                static let PORTMUXCTRLBSPI0 = portmuxCtrlbSPI0
                                static let portmuxUsartrouteaUsart1 = Field(value: "PORTMUX.USARTROUTEA.USART1")
                                static let PORTMUXUSARTROUTEAUSART1 = portmuxUsartrouteaUsart1
                                static let evsysAsyncch1Asyncch1 = Field(value: "EVSYS.ASYNCCH1.ASYNCCH1")
                                static let EVSYSASYNCCH1ASYNCCH1 = evsysAsyncch1Asyncch1
                                static let evsysSyncch1Syncch1 = Field(value: "EVSYS.SYNCCH1.SYNCCH1")
                                static let EVSYSSYNCCH1SYNCCH1 = evsysSyncch1Syncch1
                                static let portmuxTwispirouteaSPI0 = Field(value: "PORTMUX.TWISPIROUTEA.SPI0")
                                static let portmuxTwispirouteaSpi0 = portmuxTwispirouteaSPI0
                                static let PORTMUXTWISPIROUTEASPI0 = portmuxTwispirouteaSPI0
                                static let portmuxSpirouteaSPI0 = Field(value: "PORTMUX.SPIROUTEA.SPI0")
                                static let portmuxSpirouteaSpi0 = portmuxSpirouteaSPI0
                                static let PORTMUXSPIROUTEASPI0 = portmuxSpirouteaSPI0
                                static let portmuxCtrlbTWI0 = Field(value: "PORTMUX.CTRLB.TWI0")
                                static let portmuxCtrlbTwi0 = portmuxCtrlbTWI0
                                static let PORTMUXCTRLBTWI0 = portmuxCtrlbTWI0
                                static let evsysAsyncch2Asyncch2 = Field(value: "EVSYS.ASYNCCH2.ASYNCCH2")
                                static let EVSYSASYNCCH2ASYNCCH2 = evsysAsyncch2Asyncch2
                                static let portmuxUsartrouteaUsart2 = Field(value: "PORTMUX.USARTROUTEA.USART2")
                                static let PORTMUXUSARTROUTEAUSART2 = portmuxUsartrouteaUsart2
                                static let portmuxCtrlcTCA00 = Field(value: "PORTMUX.CTRLC.TCA00")
                                static let portmuxCtrlcTca00 = portmuxCtrlcTCA00
                                static let PORTMUXCTRLCTCA00 = portmuxCtrlcTCA00
                                static let portmuxTwispirouteaTWI0 = Field(value: "PORTMUX.TWISPIROUTEA.TWI0")
                                static let portmuxTwispirouteaTwi0 = portmuxTwispirouteaTWI0
                                static let PORTMUXTWISPIROUTEATWI0 = portmuxTwispirouteaTWI0
                                static let portmuxCclrouteaLUT0 = Field(value: "PORTMUX.CCLROUTEA.LUT0")
                                static let portmuxCclrouteaLut0 = portmuxCclrouteaLUT0
                                static let PORTMUXCCLROUTEALUT0 = portmuxCclrouteaLUT0
                                static let portmuxCclrouteaLUT1 = Field(value: "PORTMUX.CCLROUTEA.LUT1")
                                static let portmuxCclrouteaLut1 = portmuxCclrouteaLUT1
                                static let PORTMUXCCLROUTEALUT1 = portmuxCclrouteaLUT1
                                static let portmuxCclrouteaLUT2 = Field(value: "PORTMUX.CCLROUTEA.LUT2")
                                static let portmuxCclrouteaLut2 = portmuxCclrouteaLUT2
                                static let PORTMUXCCLROUTEALUT2 = portmuxCclrouteaLUT2
                                static let portmuxCclrouteaLUT3 = Field(value: "PORTMUX.CCLROUTEA.LUT3")
                                static let portmuxCclrouteaLut3 = portmuxCclrouteaLUT3
                                static let PORTMUXCCLROUTEALUT3 = portmuxCclrouteaLUT3
                                static let portmuxTcbrouteaTCB0 = Field(value: "PORTMUX.TCBROUTEA.TCB0")
                                static let portmuxTcbrouteaTcb0 = portmuxTcbrouteaTCB0
                                static let PORTMUXTCBROUTEATCB0 = portmuxTcbrouteaTCB0
                                static let portmuxCtrlcTCA01 = Field(value: "PORTMUX.CTRLC.TCA01")
                                static let portmuxCtrlcTca01 = portmuxCtrlcTCA01
                                static let PORTMUXCTRLCTCA01 = portmuxCtrlcTCA01
                                static let portmuxCtrlcTCA02 = Field(value: "PORTMUX.CTRLC.TCA02")
                                static let portmuxCtrlcTca02 = portmuxCtrlcTCA02
                                static let PORTMUXCTRLCTCA02 = portmuxCtrlcTCA02
                                static let portmuxCtrlcTCA03 = Field(value: "PORTMUX.CTRLC.TCA03")
                                static let portmuxCtrlcTca03 = portmuxCtrlcTCA03
                                static let PORTMUXCTRLCTCA03 = portmuxCtrlcTCA03
                                static let portmuxCtrlaLUT0 = Field(value: "PORTMUX.CTRLA.LUT0")
                                static let portmuxCtrlaLut0 = portmuxCtrlaLUT0
                                static let PORTMUXCTRLALUT0 = portmuxCtrlaLUT0
                                static let portmuxCtrlaLUT1 = Field(value: "PORTMUX.CTRLA.LUT1")
                                static let portmuxCtrlaLut1 = portmuxCtrlaLUT1
                                static let PORTMUXCTRLALUT1 = portmuxCtrlaLUT1
                                static let portmuxCtrldTCB0 = Field(value: "PORTMUX.CTRLD.TCB0")
                                static let portmuxCtrldTcb0 = portmuxCtrldTCB0
                                static let PORTMUXCTRLDTCB0 = portmuxCtrldTCB0
                                static let portmuxEvsysrouteaEvouta = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTA")
                                static let PORTMUXEVSYSROUTEAEVOUTA = portmuxEvsysrouteaEvouta
                                static let portmuxTcbrouteaTCB1 = Field(value: "PORTMUX.TCBROUTEA.TCB1")
                                static let portmuxTcbrouteaTcb1 = portmuxTcbrouteaTCB1
                                static let PORTMUXTCBROUTEATCB1 = portmuxTcbrouteaTCB1
                                static let USIPOS = Field(value: "USIPOS")
                                static let usipos = USIPOS
                                static let portmuxCtrlcTCA04 = Field(value: "PORTMUX.CTRLC.TCA04")
                                static let portmuxCtrlcTca04 = portmuxCtrlcTCA04
                                static let PORTMUXCTRLCTCA04 = portmuxCtrlcTCA04
                                static let portmuxCtrlcTCA05 = Field(value: "PORTMUX.CTRLC.TCA05")
                                static let portmuxCtrlcTca05 = portmuxCtrlcTCA05
                                static let PORTMUXCTRLCTCA05 = portmuxCtrlcTCA05
                                static let portmuxCtrlaEvout0 = Field(value: "PORTMUX.CTRLA.EVOUT0")
                                static let PORTMUXCTRLAEVOUT0 = portmuxCtrlaEvout0
                                static let portmuxUsartrouteaUsart3 = Field(value: "PORTMUX.USARTROUTEA.USART3")
                                static let PORTMUXUSARTROUTEAUSART3 = portmuxUsartrouteaUsart3
                                static let portmuxCtrlaEvout1 = Field(value: "PORTMUX.CTRLA.EVOUT1")
                                static let PORTMUXCTRLAEVOUT1 = portmuxCtrlaEvout1
                                static let portmuxCtrlaExtbrk = Field(value: "PORTMUX.CTRLA.EXTBRK")
                                static let PORTMUXCTRLAEXTBRK = portmuxCtrlaExtbrk
                                static let portmuxEvsysrouteaEvoutb = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTB")
                                static let PORTMUXEVSYSROUTEAEVOUTB = portmuxEvsysrouteaEvoutb
                                static let SPIMAP = Field(value: "SPIMAP")
                                static let spimap = SPIMAP
                                static let portmuxEvsysrouteaEvoutc = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTC")
                                static let PORTMUXEVSYSROUTEAEVOUTC = portmuxEvsysrouteaEvoutc
                                static let portmuxCtrlaEvout2 = Field(value: "PORTMUX.CTRLA.EVOUT2")
                                static let PORTMUXCTRLAEVOUT2 = portmuxCtrlaEvout2
                                static let portmuxTcbrouteaTCB2 = Field(value: "PORTMUX.TCBROUTEA.TCB2")
                                static let portmuxTcbrouteaTcb2 = portmuxTcbrouteaTCB2
                                static let PORTMUXTCBROUTEATCB2 = portmuxTcbrouteaTCB2
                                static let U0MAP = Field(value: "U0MAP")
                                static let u0map = U0MAP
                                static let portmuxEvsysrouteaEvout0 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT0")
                                static let PORTMUXEVSYSROUTEAEVOUT0 = portmuxEvsysrouteaEvout0
                                static let portmuxEvsysrouteaEvout3 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT3")
                                static let PORTMUXEVSYSROUTEAEVOUT3 = portmuxEvsysrouteaEvout3
                                static let portmuxEvsysrouteaEvoutd = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTD")
                                static let PORTMUXEVSYSROUTEAEVOUTD = portmuxEvsysrouteaEvoutd
                                static let portmuxTcbrouteaTCB3 = Field(value: "PORTMUX.TCBROUTEA.TCB3")
                                static let portmuxTcbrouteaTcb3 = portmuxTcbrouteaTCB3
                                static let PORTMUXTCBROUTEATCB3 = portmuxTcbrouteaTCB3
                                static let REMAP = Field(value: "REMAP")
                                static let remap = REMAP
                                static let portmuxCtrldTCB1 = Field(value: "PORTMUX.CTRLD.TCB1")
                                static let portmuxCtrldTcb1 = portmuxCtrldTCB1
                                static let PORTMUXCTRLDTCB1 = portmuxCtrldTCB1
                                static let portmuxEvsysrouteaEvout2 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT2")
                                static let PORTMUXEVSYSROUTEAEVOUT2 = portmuxEvsysrouteaEvout2
                                static let portmuxEvsysrouteaEvout5 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT5")
                                static let PORTMUXEVSYSROUTEAEVOUT5 = portmuxEvsysrouteaEvout5
                                static let portmuxEvsysrouteaEvoutf = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTF")
                                static let PORTMUXEVSYSROUTEAEVOUTF = portmuxEvsysrouteaEvoutf
                                static let portmuxEvsysrouteaEvout1 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT1")
                                static let PORTMUXEVSYSROUTEAEVOUT1 = portmuxEvsysrouteaEvout1
                                static let portmuxEvsysrouteaEvout4 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT4")
                                static let PORTMUXEVSYSROUTEAEVOUT4 = portmuxEvsysrouteaEvout4
                                static let portmuxEvsysrouteaEvoute = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTE")
                                static let PORTMUXEVSYSROUTEAEVOUTE = portmuxEvsysrouteaEvoute

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Field] = [
                                            portmuxTcarouteaTCA0,
                                            evsysSyncch0Syncch0,
                                            evsysAsyncch0Asyncch0,
                                            portmuxCtrlbUsart0,
                                            portmuxUsartrouteaUsart0,
                                            portmuxCtrlbSPI0,
                                            portmuxUsartrouteaUsart1,
                                            evsysAsyncch1Asyncch1,
                                            evsysSyncch1Syncch1,
                                            portmuxTwispirouteaSPI0,
                                            portmuxSpirouteaSPI0,
                                            portmuxCtrlbTWI0,
                                            evsysAsyncch2Asyncch2,
                                            portmuxUsartrouteaUsart2,
                                            portmuxCtrlcTCA00,
                                            portmuxTwispirouteaTWI0,
                                            portmuxCclrouteaLUT0,
                                            portmuxCclrouteaLUT1,
                                            portmuxCclrouteaLUT2,
                                            portmuxCclrouteaLUT3,
                                            portmuxTcbrouteaTCB0,
                                            portmuxCtrlcTCA01,
                                            portmuxCtrlcTCA02,
                                            portmuxCtrlcTCA03,
                                            portmuxCtrlaLUT0,
                                            portmuxCtrlaLUT1,
                                            portmuxCtrldTCB0,
                                            portmuxEvsysrouteaEvouta,
                                            portmuxTcbrouteaTCB1,
                                            USIPOS,
                                            portmuxCtrlcTCA04,
                                            portmuxCtrlcTCA05,
                                            portmuxCtrlaEvout0,
                                            portmuxUsartrouteaUsart3,
                                            portmuxCtrlaEvout1,
                                            portmuxCtrlaExtbrk,
                                            portmuxEvsysrouteaEvoutb,
                                            SPIMAP,
                                            portmuxEvsysrouteaEvoutc,
                                            portmuxCtrlaEvout2,
                                            portmuxTcbrouteaTCB2,
                                            U0MAP,
                                            portmuxEvsysrouteaEvout0,
                                            portmuxEvsysrouteaEvout3,
                                            portmuxEvsysrouteaEvoutd,
                                            portmuxTcbrouteaTCB3,
                                            REMAP,
                                            portmuxCtrldTCB1,
                                            portmuxEvsysrouteaEvout2,
                                            portmuxEvsysrouteaEvout5,
                                            portmuxEvsysrouteaEvoutf,
                                            portmuxEvsysrouteaEvout1,
                                            portmuxEvsysrouteaEvout4,
                                            portmuxEvsysrouteaEvoute
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }
                        }
                    }

                    struct Parameters: Codable {
                        let param: [Param]

                        enum CodingKeys: String, CodingKey {
                            case param
                        }

                        struct Param: Codable {
                            @Attribute var name: Name
                            @Attribute var value: Value

                            enum CodingKeys: String, CodingKey {
                                case name
                                case value
                            }

                            struct Name: ATDFStringValue {
                                static let CORE_VERSION = Name(value: "CORE_VERSION")
                                static let coreVersion = CORE_VERSION
                                static let COREVERSION = CORE_VERSION
                                static let NEW_INSTRUCTIONS = Name(value: "NEW_INSTRUCTIONS")
                                static let newInstructions = NEW_INSTRUCTIONS
                                static let NEWINSTRUCTIONS = NEW_INSTRUCTIONS

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Name] = [
                                            CORE_VERSION,
                                            NEW_INSTRUCTIONS
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }

                            struct Value: ATDFStringValue {
                                static let V2E = Value(value: "V2E")
                                static let v2e = V2E
                                static let V4 = Value(value: "V4")
                                static let v4 = V4
                                static let V2 = Value(value: "V2")
                                static let v2 = V2
                                static let lpmRdZ = Value(value: "lpm rd,z+")
                                static let LpmRdZ = lpmRdZ
                                static let V3 = Value(value: "V3")
                                static let v3 = V3
                                static let AVR8L_0 = Value(value: "AVR8L_0")
                                static let avr8l0 = AVR8L_0
                                static let AVR8L0 = AVR8L_0
                                static let V0E = Value(value: "V0E")
                                static let v0e = V0E
                                static let lpmRdZAlt2 = Value(value: "lpm rd,z")
                                static let V1 = Value(value: "V1")
                                static let v1 = V1

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Value] = [
                                            V2E,
                                            V4,
                                            V2,
                                            lpmRdZ,
                                            V3,
                                            AVR8L_0,
                                            V0E,
                                            lpmRdZAlt2,
                                            V1
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }
                        }
                    }
                }
            }
        }

        struct Interfaces: Codable {
            let interface: [Interface]

            enum CodingKeys: String, CodingKey {
                case interface
            }

            struct Interface: Codable {
                @Attribute var name: Name
                @Attribute var type: Kind
                let parameters: Parameters?

                enum CodingKeys: String, CodingKey {
                    case name
                    case type
                    case parameters
                }

                struct Name: ATDFStringValue {
                    static let ISP = Name(value: "ISP")
                    static let isp = ISP
                    static let HVPP = Name(value: "HVPP")
                    static let hvpp = HVPP
                    static let JTAG = Name(value: "JTAG")
                    static let jtag = JTAG
                    static let debugWIRE = Name(value: "debugWIRE")
                    static let Debugwire = debugWIRE
                    static let UPDI = Name(value: "UPDI")
                    static let updi = UPDI
                    static let HVSP = Name(value: "HVSP")
                    static let hvsp = HVSP
                    static let TPI = Name(value: "TPI")
                    static let tpi = TPI

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Name] = [
                                ISP,
                                HVPP,
                                JTAG,
                                debugWIRE,
                                UPDI,
                                HVSP,
                                TPI
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Kind: ATDFStringValue {
                    static let isp = Kind(value: "isp")
                    static let Isp = isp
                    static let hvpp = Kind(value: "hvpp")
                    static let Hvpp = hvpp
                    static let megajtag = Kind(value: "megajtag")
                    static let Megajtag = megajtag
                    static let dw = Kind(value: "dw")
                    static let Dw = dw
                    static let updi = Kind(value: "updi")
                    static let Updi = updi
                    static let hvsp = Kind(value: "hvsp")
                    static let Hvsp = hvsp
                    static let tpi = Kind(value: "tpi")
                    static let Tpi = tpi

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Kind] = [
                                isp,
                                hvpp,
                                megajtag,
                                dw,
                                updi,
                                hvsp,
                                tpi
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Parameters: Codable {
                    let param: Param

                    enum CodingKeys: String, CodingKey {
                        case param
                    }

                    struct Param: Codable {
                        @Attribute var name: Name
                        @Attribute var value: Value

                        enum CodingKeys: String, CodingKey {
                            case name
                            case value
                        }

                        struct Name: ATDFStringValue {
                            static let SUPPORTS_EEPROM_ERASE = Name(value: "SUPPORTS_EEPROM_ERASE")
                            static let supportsEepromErase = SUPPORTS_EEPROM_ERASE
                            static let SUPPORTSEEPROMERASE = SUPPORTS_EEPROM_ERASE

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [Name] = [
                                        SUPPORTS_EEPROM_ERASE
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }

                        struct Value: ATDFStringValue {
                            static let zero = Value(value: "0")
                            static let value0 = zero

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [Value] = [
                                        zero
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }
                    }
                }
            }
        }

        struct Parameters: Codable {
            let param: Param

            enum CodingKeys: String, CodingKey {
                case param
            }

            struct Param: Codable {
                @Attribute var name: Name
                @Attribute var value: Value

                enum CodingKeys: String, CodingKey {
                    case name
                    case value
                }

                struct Name: ATDFStringValue {
                    static let SUPPORTS_EEPROM_ERASE = Name(value: "SUPPORTS_EEPROM_ERASE")
                    static let supportsEepromErase = SUPPORTS_EEPROM_ERASE
                    static let SUPPORTSEEPROMERASE = SUPPORTS_EEPROM_ERASE

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Name] = [
                                SUPPORTS_EEPROM_ERASE
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Value: ATDFStringValue {
                    static let one = Value(value: "1")
                    static let value1 = one

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Value] = [
                                one
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }
            }
        }
    }
}
