//
//  AVRPinouts.swift
//  XMLTest
//
//  Created by Paul Shelley on 11/4/23.
//

import Foundation
import XMLCoder

struct AVRPinouts: Codable {
    var pinout: [Pinout]
    
    struct Pinout: Codable {
        @Attribute var name: Name
        @Attribute var caption: Caption?
        let pin: [Pin]
        
        struct Name: Codable, CaseIterable {
            static let BGA49 = Name(value: "BGA_49")
            static let CBGA = Name(value: "CBGA")
            static let CBGA100 = Name(value: "CBGA100")
            static let DRQFN44 = Name(value: "DRQFN_44")
            static let DRQFN64 = Name(value: "DRQFN64")
            static let PDIP28 = Name(value: "PDIP28")
            static let PDIP40 = Name(value: "PDIP40", alternateValues: ["PDIP_40"])
            static let QFP32 = Name(value: "QFP32")
            static let QFP48 = Name(value: "QFP48")
            static let QFN28 = Name(value: "QFN28")
            static let QFN32 = Name(value: "QFN32")
            static let QFN44 = Name(value: "QFN44")
            static let QFN48 = Name(value: "QFN48")
            static let QFN64 = Name(value: "QFN64")
            static let QFNQFP44 = Name(value: "QFN_QFP_44")
            static let QUAD = Name(value: "QUAD")
            static let SSOP28 = Name(value: "SSOP28")
            static let TQFP = Name(value: "TQFP")
            static let TQFP32 = Name(value: "TQFP32")
            static let TQFP44 = Name(value: "TQFP44")
            static let TQFP64 = Name(value: "TQFP64")
            static let TQFP100 = Name(value: "TQFP100")
            static let TQFPQFN32 = Name(value: "TQFPQFN32")
            static let TQFPQFN44 = Name(value: "TQFPQFN44", alternateValues: ["TQFP_QFN_44"])
            static let TQFPQFN64 = Name(value: "TQFPQFN64")
            static let TQFPVQFN44 = Name(value: "TQFP_VQFN_44")
            static let UFBGA32 = Name(value: "UFBGA32")
            static let VFBGA49 = Name(value: "VFBGA49")
            static let VQFN32 = Name(value: "VQFN32")
            static let VQFN44 = Name(value: "VQFN44")
            static let PDIP8_SOIC8 = Name(value: "PDIP8_SOIC8")
            static let MLF20 = Name(value: "MLF20")
            static let MLF10 = Name(value: "MLF10")
            
            let rawValue: String
            private let alternateValues: [String]
            
            static let allCases: [Name] = [BGA49, CBGA, CBGA100, DRQFN44, DRQFN64, PDIP28, PDIP40, QFP32, QFP48, QFN28, QFN32, QFN44, QFN48, QFN64, QFNQFP44, QUAD, SSOP28, TQFP, TQFP32, TQFP44, TQFP64, TQFP100, TQFPQFN32, TQFPQFN44, TQFPQFN64, TQFPVQFN44, UFBGA32, VFBGA49, VQFN32, VQFN44, PDIP8_SOIC8, MLF20, MLF10]
            
            init(value: String, alternateValues: [String] = []) {
                self.rawValue = value
                self.alternateValues = alternateValues
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let string = try container.decode(String.self)
                
                if let p = Self.allCases.first(where: { $0.rawValue == string }) {
                    self = p
                } else if let p = Self.allCases.first(where: { $0.alternateValues.contains(string) }) {
                    self = p
                } else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown value '\(string)'")
                }
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(rawValue)
            }
        }
        
        enum Caption: String, Codable {
            case TQFP64 = "TQFP64"
            case QFN64 = "QFN64"
            case PDIP28 = "PDIP28"
            case TQFPQFN32 = "TQFPQFN32"
            case TQFPQFN44 = "TQFPQFN44"
            case TQFPQFN442 = "TQFP_QFN_44" // Duplicate
            case PDIP40 = "PDIP40"
            case TQFP44 = "TQFP44"
            case QFN44 = "QFN44"
            case TQFP32 = "TQFP32"
            case QFN32 = "QFN32"
            case QFN28 = "QFN28"
            case UFBGA32 = "UFBGA32"
            case VQFN32 = "VQFN32"
            case TQFPQFN64 = "TQFPQFN64"
            case VFBGA49 = "VFBGA49"
            case TQFPVQFN44 = "TQFP_VQFN_44"
            case DRQFN64 = "DRQFN64"
            case VQFN44 = "VQFN44"
            case TQFP100 = "TQFP100"
            case CBGA100 = "CBGA100"
        }
        
        struct Pin:Codable {
            @Attribute var position: Position
            @Attribute var pad: Pad
            
            enum Position: String, Codable {
                case one = "1"
                case two = "2"
                case three = "3"
                case four = "4"
                case five = "5"
                case six = "6"
                case seven = "7"
                case eight = "8"
                case nine = "9"
                case ten = "10"
                case eleven = "11"
                case twelve = "12"
                case thirteen = "13"
                case fourteen = "14"
                case fifteen = "15"
                case sixteen = "16"
                case seventeen = "17"
                case eighteen = "18"
                case nineteen = "19"
                case twenty = "20"
                case twentyOne = "21"
                case twentyTwo = "22"
                case twentyThree = "23"
                case twentyFour = "24"
                case twentyFive = "25"
                case twentySix = "26"
                case twentySeven = "27"
                case twentyEight = "28"
                case twentyNine = "29"
                case thirty = "30"
                case thirtyOne = "31"
                case thirtyTwo = "32"
                case thirtyThree = "33"
                case thirtyFour = "34"
                case thirtyFive = "35"
                case thirtySix = "36"
                case thirtySeven = "37"
                case thirtyEight = "38"
                case thirtyNine = "39"
                case forty = "40"
                case fortyOne = "41"
                case fortytwo = "42"
                case fortyThree = "43"
                case fortyFour = "44"
                case fortyFive = "45"
                case fortySix = "46"
                case fortySeven = "47"
                case fortyEight = "48"
                case fortyNine = "49"
                case fifty = "50"
                case fiftyOne = "51"
                case fiftyTwo = "52"
                case fiftyThree = "53"
                case fiftyFour = "54"
                case fiftyFive = "55"
                case fiftySix = "56"
                case fiftySeven = "57"
                case fiftyEight = "58"
                case fiftyNine = "59"
                case sixty = "60"
                case sixtyOne = "61"
                case sixtyTwo = "62"
                case sixtyThree = "63"
                case sixtyFour = "64"
                case B1 = "B1"
                case B2 = "B2"
                case C1 = "C1"
                case D1 = "D1"
                case D2 = "D2"
                case E1 = "E1"
                case F1 = "F1"
                case F2 = "F2"
                case E2 = "E2"
                case F3 = "F3"
                case E3 = "E3"
                case F4 = "F4"
                case E4 = "E4"
                case F5 = "F5"
                case F6 = "F6"
                case E6 = "E6"
                case E5 = "E5"
                case D6 = "D6"
                case D5 = "D5"
                case C6 = "C6"
                case C5 = "C5"
                case B6 = "B6"
                case A6 = "A6"
                case A5 = "A5"
                case B5 = "B5"
                case A4 = "A4"
                case B4 = "B4"
                case A3 = "A3"
                case B3 = "B3"
                case A2 = "A2"
                case A1 = "A1"
                case A7 = "A7"
                case A8 = "A8"
                case B7 = "B7"
                case A9 = "A9"
                case B8 = "B8"
                case A10 = "A10"
                case B9 = "B9"
                case A11 = "A11"
                case B10 = "B10"
                case A12 = "A12"
                case A13 = "A13"
                case B11 = "B11"
                case A14 = "A14"
                case B12 = "B12"
                case A15 = "A15"
                case B13 = "B13"
                case A16 = "A16"
                case B14 = "B14"
                case A17 = "A17"
                case B15 = "B15"
                case A18 = "A18"
                case A19 = "A19"
                case B16 = "B16"
                case A20 = "A20"
                case B17 = "B17"
                case A21 = "A21"
                case B18 = "B18"
                case A22 = "A22"
                case B19 = "B19"
                case A23 = "A23"
                case B20 = "B20"
                case A24 = "A24"
                case C2 = "C2"
                case C3 = "C3"
                case C4 = "C4"
                case C7 = "C7"
                case D3 = "D3"
                case D4 = "D4"
                case D7 = "D7"
                case E7 = "E7"
                case F7 = "F7"
                case G1 = "G1"
                case G2 = "G2"
                case G3 = "G3"
                case G4 = "G4"
                case G5 = "G5"
                case G6 = "G6"
                case G7 = "G7"
                case B21 = "B21"
                case A25 = "A25"
                case B22 = "B22"
                case B23 = "B23"
                case A26 = "A26"
                case A27 = "A27"
                case B24 = "B24"
                case A28 = "A28"
                case B25 = "B25"
                case A29 = "A29"
                case B26 = "B26"
                case A30 = "A30"
                case B27 = "B27"
                case A31 = "A31"
                case B28 = "B28"
                case A32 = "A32"
                case B29 = "B29"
                case A33 = "A33"
                case A34 = "A34"
                case B30 = "B30"
                case sixtyFive = "65"
                case sixtySix = "66"
                case sixtySeven = "67"
                case sixtyEight = "68"
                case sixtyNine = "69"
                case seventy = "70"
                case seventyOne = "71"
                case seventyTwo = "72"
                case seventyThree = "73"
                case seventyFour = "74"
                case seventyFive = "75"
                case seventySix = "76"
                case seventySeven = "77"
                case seventyEight = "78"
                case seventyNine = "79"
                case eighty = "80"
                case eightyOne = "81"
                case eightyTwo = "82"
                case eightyThree = "83"
                case eightyFour = "84"
                case eightyFive = "85"
                case eightySix = "86"
                case eightySeven = "87"
                case eightyEight = "88"
                case eightyNine = "89"
                case ninety = "90"
                case ninetyOne = "91"
                case ninetyTwo = "92"
                case ninetyThree = "93"
                case ninetyFour = "94"
                case ninetyFive = "95"
                case ninetySix = "96"
                case ninetySeven = "97"
                case ninetyEight = "98"
                case ninetyNine = "99"
                case oneHundred = "100"
                case H1 = "H1"
                case J1 = "J1"
                case K1 = "K1"
                case H2 = "H2"
                case J2 = "J2"
                case K2 = "K2"
                case H3 = "H3"
                case J3 = "J3"
                case K3 = "K3"
                case H4 = "H4"
                case J4 = "J4"
                case K4 = "K4"
                case H5 = "H5"
                case J5 = "J5"
                case K5 = "K5"
                case H6 = "H6"
                case J6 = "J6"
                case K6 = "K6"
                case H7 = "H7"
                case J7 = "J7"
                case K7 = "K7"
                case C8 = "C8"
                case D8 = "D8"
                case E8 = "E8"
                case F8 = "F8"
                case G8 = "G8"
                case H8 = "H8"
                case J8 = "J8"
                case K8 = "K8"
                case C9 = "C9"
                case D9 = "D9"
                case E9 = "E9"
                case F9 = "F9"
                case G9 = "G9"
                case H9 = "H9"
                case J9 = "J9"
                case K9 = "K9"
                case C10 = "C10"
                case D10 = "D10"
                case E10 = "E10"
                case F10 = "F10"
                case G10 = "G10"
                case H10 = "H10"
                case J10 = "J10"
                case K10 = "K10"
                case fiveF = "5F"
                case H0 = "H0"
                case I1 = "I1"
                case I2 = "I2"
                case I3 = "I3"
                case I4 = "I4"
                case I5 = "I5"
                case I6 = "I6"
                case I7 = "I7"
                case I8 = "I8"
                case I9 = "I9"
                case I0 = "I0"
            }
            
            enum Pad: String, Codable {
                case NC = "NC"
                case PE0 = "PE0"
                case PE1 = "PE1"
                case PE2 = "PE2"
                case PE3 = "PE3"
                case PE4 = "PE4"
                case PE5 = "PE5"
                case PE6 = "PE6"
                case PE7 = "PE7"
                case PB0 = "PB0"
                case PB1 = "PB1"
                case PB2 = "PB2"
                case PB3 = "PB3"
                case PB4 = "PB4"
                case PB5 = "PB5"
                case PB6 = "PB6"
                case PB7 = "PB7"
                case PG3 = "PG3"
                case PG4 = "PG4"
                case RESET = "RESET"
                case VCC = "VCC"
                case GND = "GND"
                case XTAL2 = "XTAL2"
                case XTAL1 = "XTAL1"
                case PD0 = "PD0"
                case PD1 = "PD1"
                case PD2 = "PD2"
                case PD3 = "PD3"
                case PD4 = "PD4"
                case PD5 = "PD5"
                case PD6 = "PD6"
                case PD7 = "PD7"
                case PG0 = "PG0"
                case PG1 = "PG1"
                case PC0 = "PC0"
                case PC1 = "PC1"
                case PC2 = "PC2"
                case PC3 = "PC3"
                case PC4 = "PC4"
                case PC5 = "PC5"
                case PC6 = "PC6"
                case PC7 = "PC7"
                case PG2 = "PG2"
                case PA7 = "PA7"
                case PA6 = "PA6"
                case PA5 = "PA5"
                case PA4 = "PA4"
                case PA3 = "PA3"
                case PA2 = "PA2"
                case PA1 = "PA1"
                case PA0 = "PA0"
                case PF7 = "PF7"
                case PF6 = "PF6"
                case PF5 = "PF5"
                case PF4 = "PF4"
                case PF3 = "PF3"
                case PF2 = "PF2"
                case PF1 = "PF1"
                case PF0 = "PF0"
                case AREF = "AREF"
                case AVCC = "AVCC"
                case ADC6 = "ADC6"
                case ADC7 = "ADC7"
                case UCAP = "UCAP"
                case UGND = "UGND"
                case DPlus = "D+"
                case DMinus = "D-"
                case UVCC = "UVCC"
                case AGND = "AGND"
                case DM = "DM"
                case DP = "DP"
                case VBUS = "VBUS"
                case VDD = "VDD"
                case PEN = "PEN"
                case REF = "REF"
                case LCDCAP = "LCDCAP"
                case PG5 = "PG5"
                case PH0 = "PH0"
                case PH1 = "PH1"
                case PH2 = "PH2"
                case PH3 = "PH3"
                case PH4 = "PH4"
                case PH5 = "PH5"
                case PH6 = "PH6"
                case PH7 = "PH7"
                case PL0 = "PL0"
                case PL1 = "PL1"
                case PL2 = "PL2"
                case PL3 = "PL3"
                case PL4 = "PL4"
                case PL5 = "PL5"
                case PL6 = "PL6"
                case PL7 = "PL7"
                case PJ0 = "PJ0"
                case PJ1 = "PJ1"
                case PJ2 = "PJ2"
                case PJ3 = "PJ3"
                case PJ4 = "PJ4"
                case PJ5 = "PJ5"
                case PJ6 = "PJ6"
                case PJ7 = "PJ7"
                case PK7 = "PK7"
                case PK6 = "PK6"
                case PK5 = "PK5"
                case PK4 = "PK4"
                case PK3 = "PK3"
                case PK2 = "PK2"
                case PK1 = "PK1"
                case PK0 = "PK0"
                case AVDD = "AVDD"
                case GND0 = "GND0"
                case UPDI = "UPDI"
                case VDD0 = "VDD0"
                case GND1 = "GND1"
                case VDD1 = "VDD1"
            }
        }
    }
}
