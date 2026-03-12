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
        let peripherals: Peripherals
        let addressSpaces: AddressSpaces
        let interfaces: Interfaces
        let propertyGroups: PropertyGroups
        let interrupts: Interrupts
        let parameters: Parameters?

        enum CodingKeys: String, CodingKey {
            case name
            case architecture
            case family
            case peripherals
            case addressSpaces = "address-spaces"
            case interfaces
            case propertyGroups = "property-groups"
            case interrupts
            case parameters
        }

        typealias Architecture = String

        typealias Family = String

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

                typealias Name = String

                typealias ID = String

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

                    typealias Name = String

                    typealias Caption = String

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

                        typealias Name = String

                        typealias NameInModule = String

                        typealias Offset = String

                        typealias AddressSpace = String

                        typealias Caption = String
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

                            typealias Group = String

                            typealias Function = String

                            typealias Pad = String

                            typealias Index = String

                            typealias Field = String
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

                            typealias Name = String

                            typealias Value = String
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

                typealias Endianness = String

                typealias Name = String

                typealias ID = String

                typealias Start = String

                typealias Size = String

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

                    typealias Start = String

                    typealias Size = String

                    typealias Kind = String

                    typealias ReadWrite = String

                    typealias Exec = String

                    typealias Name = String

                    typealias Pagesize = String
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

                typealias Name = String

                typealias Kind = String

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

                        typealias Name = String

                        typealias Value = String
                    }
                }
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

                    typealias Caption = String
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

                typealias Index = String

                typealias Name = String

                typealias Caption = String

                typealias ModuleInstance = String
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

                typealias Name = String

                typealias Value = String
            }
        }
    }
}
