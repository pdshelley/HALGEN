//
//  AVRModules.swift
//  SwiftAVRGenerator
//
//  Created by HALGEN on 03/12/2026.
//

import Foundation
import XMLCoder
struct AVRModules: Codable {
    let module: [Module]

    enum CodingKeys: String, CodingKey {
        case module
    }

    struct Module: Codable {
        @Attribute var caption: Caption?
        @Attribute var name: Name
        @Attribute var id: ID?
        let registerGroup: [RegisterGroup]
        let valueGroup: [ValueGroup]

        enum CodingKeys: String, CodingKey {
            case caption
            case name
            case id
            case registerGroup = "register-group"
            case valueGroup = "value-group"
        }

        typealias Caption = String

        typealias Name = String

        typealias ID = String

        struct RegisterGroup: Codable {
            @Attribute var caption: Caption?
            @Attribute var name: Name
            @Attribute var size: Size?
            let register: [Register]
            let mode: [Mode]

            enum CodingKeys: String, CodingKey {
                case caption
                case name
                case size
                case register
                case mode
            }

            typealias Caption = String

            typealias Name = String

            typealias Size = String

            struct Register: Codable {
                @Attribute var name: Name
                @Attribute var offset: Offset
                @Attribute var size: Size
                @Attribute var initval: Initval?
                @Attribute var caption: Caption?
                @Attribute var mask: Mask?
                @Attribute var ocdRw: OcdRw?
                @Attribute var rw: ReadWrite?
                @Attribute var modes: Modes?
                @Attribute var bitAddressable: BitAddressable?
                let bitfield: [Bitfield]
                let mode: [Mode]

                enum CodingKeys: String, CodingKey {
                    case name
                    case offset
                    case size
                    case initval
                    case caption
                    case mask
                    case ocdRw = "ocd-rw"
                    case rw
                    case modes
                    case bitAddressable = "bit-addressable"
                    case bitfield
                    case mode
                }

                typealias Name = String

                typealias Offset = String

                typealias Size = String

                typealias Initval = String

                typealias Caption = String

                typealias Mask = String

                typealias OcdRw = String

                typealias ReadWrite = String

                typealias Modes = String

                typealias BitAddressable = String

                struct Bitfield: Codable {
                    @Attribute var caption: Caption?
                    @Attribute var mask: Mask
                    @Attribute var name: Name
                    @Attribute var values: Values?
                    @Attribute var lsb: Int?
                    @Attribute var rw: ReadWrite?
                    @Attribute var modes: Modes?

                    enum CodingKeys: String, CodingKey {
                        case caption
                        case mask
                        case name
                        case values
                        case lsb
                        case rw
                        case modes
                    }

                    typealias Caption = String

                    struct Mask: Codable {
                        let value: UInt16

                        init(from decoder: Decoder) throws {
                            let container = try decoder.singleValueContainer()
                            let stringValue = try container.decode(String.self)

                            guard stringValue.lowercased().hasPrefix("0x"),
                                  let integerValue = UInt16(stringValue.dropFirst(2), radix: 16) else {
                                throw DecodingError.dataCorruptedError(
                                    in: container,
                                    debugDescription: "Invalid hexadecimal string for bitfield mask: \(stringValue)"
                                )
                            }

                            self.value = integerValue
                        }

                        func encode(to encoder: Encoder) throws {
                            var container = encoder.singleValueContainer()
                            let encoded = String(value, radix: 16, uppercase: true)
                            try container.encode("0x\(encoded)")
                        }
                    }

                    typealias Name = String

                    typealias Values = String

                    typealias ReadWrite = String

                    typealias Modes = String
                }

                struct Mode: Codable {
                    @Attribute var name: Name
                    @Attribute var qualifier: Qualifier
                    @Attribute var value: Value

                    enum CodingKeys: String, CodingKey {
                        case name
                        case qualifier
                        case value
                    }

                    typealias Name = String

                    typealias Qualifier = String

                    typealias Value = String
                }
            }

            struct Mode: Codable {
                @Attribute var caption: Caption
                @Attribute var name: Name
                @Attribute var qualifier: Qualifier
                @Attribute var value: Value

                enum CodingKeys: String, CodingKey {
                    case caption
                    case name
                    case qualifier
                    case value
                }

                typealias Caption = String

                typealias Name = String

                typealias Qualifier = String

                typealias Value = String
            }
        }

        struct ValueGroup: Codable {
            @Attribute var name: Name
            @Attribute var caption: Caption?
            let value: [Value]

            enum CodingKeys: String, CodingKey {
                case name
                case caption
                case value
            }

            typealias Name = String

            typealias Caption = String

            struct Value: Codable {
                @Attribute var caption: Caption
                @Attribute var name: Name
                @Attribute var value: Value

                enum CodingKeys: String, CodingKey {
                    case caption
                    case name
                    case value
                }

                typealias Caption = String

                typealias Name = String

                typealias Value = String
            }
        }
    }
}
