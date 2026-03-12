//
//  AVRPinouts.swift
//  SwiftAVRGenerator
//
//  Created by HALGEN on 03/12/2026.
//

import Foundation
import XMLCoder
struct AVRPinouts: Codable {
    let pinout: [Pinout]

    enum CodingKeys: String, CodingKey {
        case pinout
    }

    struct Pinout: Codable {
        @Attribute var name: Name
        @Attribute var caption: Caption?
        let pin: [Pin]

        enum CodingKeys: String, CodingKey {
            case name
            case caption
            case pin
        }

        struct Name: ATDFStringValue {
            static let TQFP32 = Name(value: "TQFP32")
            static let QFN32 = Name(value: "QFN32")
            static let PDIP28 = Name(value: "PDIP28")
            static let PDIP40 = Name(value: "PDIP40")
            static let TQFP64 = Name(value: "TQFP64")
            static let QFN64 = Name(value: "QFN64")
            static let QFN28 = Name(value: "QFN28")
            static let SOIC14 = Name(value: "SOIC14")
            static let QFN20 = Name(value: "QFN20")
            static let QFN24 = Name(value: "QFN24")
            static let TQFP_QFN_44 = Name(value: "TQFP_QFN_44")
            static let QFN_20 = Name(value: "QFN_20")
            static let TQFPQFN32 = Name(value: "TQFPQFN32")
            static let SOIC20 = Name(value: "SOIC20")
            static let UFBGA32 = Name(value: "UFBGA32")
            static let SOIC_14 = Name(value: "SOIC_14")
            static let TQFPQFN44 = Name(value: "TQFPQFN44")
            static let TQFPQFN64 = Name(value: "TQFPQFN64")
            static let DRQFN_44 = Name(value: "DRQFN_44")
            static let SSOP28 = Name(value: "SSOP28")
            static let VQFN32 = Name(value: "VQFN32")
            static let SOT23_6 = Name(value: "SOT23_6")
            static let QFN48 = Name(value: "QFN48")
            static let QFP32 = Name(value: "QFP32")
            static let QFP48 = Name(value: "QFP48")
            static let SOIC8 = Name(value: "SOIC8")
            static let UDFN8 = Name(value: "UDFN8")
            static let SOIC_8 = Name(value: "SOIC_8")
            static let TQFP_VQFN_44 = Name(value: "TQFP_VQFN_44")
            static let DRQFN64 = Name(value: "DRQFN64")
            static let VFBGA49 = Name(value: "VFBGA49")
            static let TQFP44 = Name(value: "TQFP44")
            static let SOIC_20 = Name(value: "SOIC_20")
            static let UFBGA = Name(value: "UFBGA")
            static let BGA_16 = Name(value: "BGA_16")
            static let QFN_32 = Name(value: "QFN_32")
            static let QUAD = Name(value: "QUAD")
            static let TQFP32_QFN32 = Name(value: "TQFP32_QFN32")
            static let PDIP8_SOIC8 = Name(value: "PDIP8_SOIC8")
            static let MLF10 = Name(value: "MLF10")
            static let MLF20 = Name(value: "MLF20")
            static let QFN44 = Name(value: "QFN44")
            static let CBGA = Name(value: "CBGA")
            static let PDIP = Name(value: "PDIP")
            static let TQFP = Name(value: "TQFP")
            static let VQFN = Name(value: "VQFN")
            static let DIP = Name(value: "DIP")
            static let CQFP32TQFP32 = Name(value: "CQFP32TQFP32")
            static let QFN_QFP_44 = Name(value: "QFN_QFP_44")
            static let CBGA100 = Name(value: "CBGA100")
            static let TQFP100 = Name(value: "TQFP100")
            static let CQFP64 = Name(value: "CQFP64")
            static let VQFN44 = Name(value: "VQFN44")
            static let PDIP_40 = Name(value: "PDIP_40")
            static let WLCSP = Name(value: "WLCSP")
            static let BGA_49 = Name(value: "BGA_49")

            let rawValue: String
            let alternateValues: [String]

            static let allCases: [Name] = [
                        TQFP32,
                        QFN32,
                        PDIP28,
                        PDIP40,
                        TQFP64,
                        QFN64,
                        QFN28,
                        SOIC14,
                        QFN20,
                        QFN24,
                        TQFP_QFN_44,
                        QFN_20,
                        TQFPQFN32,
                        SOIC20,
                        UFBGA32,
                        SOIC_14,
                        TQFPQFN44,
                        TQFPQFN64,
                        DRQFN_44,
                        SSOP28,
                        VQFN32,
                        SOT23_6,
                        QFN48,
                        QFP32,
                        QFP48,
                        SOIC8,
                        UDFN8,
                        SOIC_8,
                        TQFP_VQFN_44,
                        DRQFN64,
                        VFBGA49,
                        TQFP44,
                        SOIC_20,
                        UFBGA,
                        BGA_16,
                        QFN_32,
                        QUAD,
                        TQFP32_QFN32,
                        PDIP8_SOIC8,
                        MLF10,
                        MLF20,
                        QFN44,
                        CBGA,
                        PDIP,
                        TQFP,
                        VQFN,
                        DIP,
                        CQFP32TQFP32,
                        QFN_QFP_44,
                        CBGA100,
                        TQFP100,
                        CQFP64,
                        VQFN44,
                        PDIP_40,
                        WLCSP,
                        BGA_49
                    ]

            init(value: String, alternateValues: [String] = []) {
                self.rawValue = value
                self.alternateValues = alternateValues
            }
        }

        struct Caption: ATDFStringValue {
            static let TQFP32 = Caption(value: "TQFP32")
            static let PDIP28 = Caption(value: "PDIP28")
            static let PDIP40 = Caption(value: "PDIP40")
            static let TQFP64 = Caption(value: "TQFP64")
            static let QFN64 = Caption(value: "QFN64")
            static let QFN32 = Caption(value: "QFN32")
            static let QFN28 = Caption(value: "QFN28")
            static let TQFP_QFN_44 = Caption(value: "TQFP_QFN_44", alternateValues: ["TQFPQFN44", "TQFP_VQFN_44"])
            static let TQFPQFN32 = Caption(value: "TQFPQFN32")
            static let UFBGA32 = Caption(value: "UFBGA32")
            static let TQFPQFN64 = Caption(value: "TQFPQFN64")
            static let VQFN32 = Caption(value: "VQFN32")
            static let DRQFN64 = Caption(value: "DRQFN64")
            static let VFBGA49 = Caption(value: "VFBGA49")
            static let TQFP44 = Caption(value: "TQFP44")
            static let QFN44 = Caption(value: "QFN44")
            static let CQFP32TQFP32 = Caption(value: "CQFP32TQFP32")
            static let CBGA100 = Caption(value: "CBGA100")
            static let TQFP100 = Caption(value: "TQFP100")
            static let VQFN44 = Caption(value: "VQFN44")
            static let sixtyFour = Caption(value: "64")

            let rawValue: String
            let alternateValues: [String]

            static let allCases: [Caption] = [
                        TQFP32,
                        PDIP28,
                        PDIP40,
                        TQFP64,
                        QFN64,
                        QFN32,
                        QFN28,
                        TQFP_QFN_44,
                        TQFPQFN32,
                        UFBGA32,
                        TQFPQFN64,
                        VQFN32,
                        DRQFN64,
                        VFBGA49,
                        TQFP44,
                        QFN44,
                        CQFP32TQFP32,
                        CBGA100,
                        TQFP100,
                        VQFN44,
                        sixtyFour
                    ]

            init(value: String, alternateValues: [String] = []) {
                self.rawValue = value
                self.alternateValues = alternateValues
            }
        }

        struct Pin: Codable {
            @Attribute var position: Position
            @Attribute var pad: Pad

            enum CodingKeys: String, CodingKey {
                case position
                case pad
            }

            struct Position: ATDFStringValue {
                static let five = Position(value: "5")
                static let one = Position(value: "1")
                static let two = Position(value: "2")
                static let four = Position(value: "4")
                static let eight = Position(value: "8")
                static let three = Position(value: "3")
                static let six = Position(value: "6")
                static let seven = Position(value: "7")
                static let eleven = Position(value: "11")
                static let fourteen = Position(value: "14")
                static let twelve = Position(value: "12")
                static let thirteen = Position(value: "13")
                static let nine = Position(value: "9")
                static let ten = Position(value: "10")
                static let fifteen = Position(value: "15")
                static let sixteen = Position(value: "16")
                static let twenty = Position(value: "20")
                static let seventeen = Position(value: "17")
                static let eighteen = Position(value: "18")
                static let nineteen = Position(value: "19")
                static let twentyOne = Position(value: "21")
                static let twentyTwo = Position(value: "22")
                static let twentyThree = Position(value: "23")
                static let twentyFour = Position(value: "24")
                static let twentyFive = Position(value: "25")
                static let twentySix = Position(value: "26")
                static let twentySeven = Position(value: "27")
                static let twentyEight = Position(value: "28")
                static let thirty = Position(value: "30")
                static let thirtyOne = Position(value: "31")
                static let thirtyTwo = Position(value: "32")
                static let twentyNine = Position(value: "29")
                static let thirtyThree = Position(value: "33")
                static let thirtyFour = Position(value: "34")
                static let thirtyFive = Position(value: "35")
                static let thirtySix = Position(value: "36")
                static let thirtySeven = Position(value: "37")
                static let thirtyEight = Position(value: "38")
                static let thirtyNine = Position(value: "39")
                static let forty = Position(value: "40")
                static let fortyOne = Position(value: "41")
                static let fortyTwo = Position(value: "42")
                static let fortyThree = Position(value: "43")
                static let fortyFour = Position(value: "44")
                static let fortyFive = Position(value: "45")
                static let fortySix = Position(value: "46")
                static let fortySeven = Position(value: "47")
                static let fortyEight = Position(value: "48")
                static let fortyNine = Position(value: "49")
                static let fifty = Position(value: "50")
                static let fiftyOne = Position(value: "51")
                static let fiftyTwo = Position(value: "52")
                static let fiftyThree = Position(value: "53")
                static let fiftyFour = Position(value: "54")
                static let fiftyFive = Position(value: "55")
                static let fiftySix = Position(value: "56")
                static let fiftySeven = Position(value: "57")
                static let fiftyEight = Position(value: "58")
                static let fiftyNine = Position(value: "59")
                static let sixty = Position(value: "60")
                static let sixtyOne = Position(value: "61")
                static let sixtyTwo = Position(value: "62")
                static let sixtyThree = Position(value: "63")
                static let sixtyFour = Position(value: "64")
                static let A3 = Position(value: "A3")
                static let B2 = Position(value: "B2")
                static let B4 = Position(value: "B4")
                static let A2 = Position(value: "A2")
                static let A4 = Position(value: "A4")
                static let B1 = Position(value: "B1")
                static let B3 = Position(value: "B3")
                static let A1 = Position(value: "A1")
                static let A5 = Position(value: "A5")
                static let B6 = Position(value: "B6")
                static let A6 = Position(value: "A6")
                static let B5 = Position(value: "B5")
                static let C1 = Position(value: "C1")
                static let D2 = Position(value: "D2")
                static let D1 = Position(value: "D1")
                static let C5 = Position(value: "C5")
                static let D6 = Position(value: "D6")
                static let C6 = Position(value: "C6")
                static let D5 = Position(value: "D5")
                static let E1 = Position(value: "E1")
                static let E2 = Position(value: "E2")
                static let E3 = Position(value: "E3")
                static let E4 = Position(value: "E4")
                static let E5 = Position(value: "E5")
                static let E6 = Position(value: "E6")
                static let F1 = Position(value: "F1")
                static let F2 = Position(value: "F2")
                static let F3 = Position(value: "F3")
                static let F4 = Position(value: "F4")
                static let F6 = Position(value: "F6")
                static let A7 = Position(value: "A7")
                static let B7 = Position(value: "B7")
                static let F5 = Position(value: "F5")
                static let C2 = Position(value: "C2")
                static let C3 = Position(value: "C3")
                static let D4 = Position(value: "D4")
                static let C4 = Position(value: "C4")
                static let D3 = Position(value: "D3")
                static let A10 = Position(value: "A10")
                static let B10 = Position(value: "B10")
                static let A8 = Position(value: "A8")
                static let A9 = Position(value: "A9")
                static let B8 = Position(value: "B8")
                static let B9 = Position(value: "B9")
                static let A11 = Position(value: "A11")
                static let A12 = Position(value: "A12")
                static let A13 = Position(value: "A13")
                static let A14 = Position(value: "A14")
                static let A15 = Position(value: "A15")
                static let A16 = Position(value: "A16")
                static let A17 = Position(value: "A17")
                static let A18 = Position(value: "A18")
                static let A19 = Position(value: "A19")
                static let A20 = Position(value: "A20")
                static let A21 = Position(value: "A21")
                static let A22 = Position(value: "A22")
                static let A23 = Position(value: "A23")
                static let A24 = Position(value: "A24")
                static let B11 = Position(value: "B11")
                static let B12 = Position(value: "B12")
                static let B13 = Position(value: "B13")
                static let B14 = Position(value: "B14")
                static let B15 = Position(value: "B15")
                static let B16 = Position(value: "B16")
                static let B17 = Position(value: "B17")
                static let B18 = Position(value: "B18")
                static let B19 = Position(value: "B19")
                static let B20 = Position(value: "B20")
                static let C7 = Position(value: "C7")
                static let D7 = Position(value: "D7")
                static let E7 = Position(value: "E7")
                static let F7 = Position(value: "F7")
                static let G1 = Position(value: "G1")
                static let G2 = Position(value: "G2")
                static let G3 = Position(value: "G3")
                static let G4 = Position(value: "G4")
                static let G5 = Position(value: "G5")
                static let G6 = Position(value: "G6")
                static let G7 = Position(value: "G7")
                static let oneHundred = Position(value: "100")
                static let A25 = Position(value: "A25")
                static let A26 = Position(value: "A26")
                static let A27 = Position(value: "A27")
                static let A28 = Position(value: "A28")
                static let A29 = Position(value: "A29")
                static let A30 = Position(value: "A30")
                static let A31 = Position(value: "A31")
                static let A32 = Position(value: "A32")
                static let A33 = Position(value: "A33")
                static let A34 = Position(value: "A34")
                static let B21 = Position(value: "B21")
                static let B22 = Position(value: "B22")
                static let B23 = Position(value: "B23")
                static let B24 = Position(value: "B24")
                static let B25 = Position(value: "B25")
                static let B26 = Position(value: "B26")
                static let B27 = Position(value: "B27")
                static let B28 = Position(value: "B28")
                static let B29 = Position(value: "B29")
                static let B30 = Position(value: "B30")
                static let C10 = Position(value: "C10")
                static let D10 = Position(value: "D10")
                static let E10 = Position(value: "E10")
                static let F10 = Position(value: "F10")
                static let G10 = Position(value: "G10")
                static let J10 = Position(value: "J10")
                static let sixtyFive = Position(value: "65")
                static let sixtySix = Position(value: "66")
                static let sixtySeven = Position(value: "67")
                static let sixtyEight = Position(value: "68")
                static let sixtyNine = Position(value: "69")
                static let seventy = Position(value: "70")
                static let seventyOne = Position(value: "71")
                static let seventyTwo = Position(value: "72")
                static let seventyThree = Position(value: "73")
                static let seventyFour = Position(value: "74")
                static let seventyFive = Position(value: "75")
                static let seventySix = Position(value: "76")
                static let seventySeven = Position(value: "77")
                static let seventyEight = Position(value: "78")
                static let seventyNine = Position(value: "79")
                static let eighty = Position(value: "80")
                static let eightyOne = Position(value: "81")
                static let eightyTwo = Position(value: "82")
                static let eightyThree = Position(value: "83")
                static let eightyFour = Position(value: "84")
                static let eightyFive = Position(value: "85")
                static let eightySix = Position(value: "86")
                static let eightySeven = Position(value: "87")
                static let eightyEight = Position(value: "88")
                static let eightyNine = Position(value: "89")
                static let ninety = Position(value: "90")
                static let ninetyOne = Position(value: "91")
                static let ninetyTwo = Position(value: "92")
                static let ninetyThree = Position(value: "93")
                static let ninetyFour = Position(value: "94")
                static let ninetyFive = Position(value: "95")
                static let ninetySix = Position(value: "96")
                static let ninetySeven = Position(value: "97")
                static let ninetyEight = Position(value: "98")
                static let ninetyNine = Position(value: "99")
                static let C8 = Position(value: "C8")
                static let C9 = Position(value: "C9")
                static let D8 = Position(value: "D8")
                static let D9 = Position(value: "D9")
                static let E8 = Position(value: "E8")
                static let E9 = Position(value: "E9")
                static let F8 = Position(value: "F8")
                static let F9 = Position(value: "F9")
                static let G8 = Position(value: "G8")
                static let G9 = Position(value: "G9")
                static let H1 = Position(value: "H1")
                static let H2 = Position(value: "H2")
                static let H3 = Position(value: "H3")
                static let H4 = Position(value: "H4")
                static let H5 = Position(value: "H5")
                static let H6 = Position(value: "H6")
                static let H7 = Position(value: "H7")
                static let H8 = Position(value: "H8")
                static let H9 = Position(value: "H9")
                static let J1 = Position(value: "J1")
                static let J2 = Position(value: "J2")
                static let J3 = Position(value: "J3")
                static let J4 = Position(value: "J4")
                static let J5 = Position(value: "J5")
                static let J6 = Position(value: "J6")
                static let J7 = Position(value: "J7")
                static let J8 = Position(value: "J8")
                static let J9 = Position(value: "J9")
                static let H10 = Position(value: "H10")
                static let K10 = Position(value: "K10")
                static let K1 = Position(value: "K1")
                static let K2 = Position(value: "K2")
                static let K3 = Position(value: "K3")
                static let K4 = Position(value: "K4")
                static let K5 = Position(value: "K5")
                static let K6 = Position(value: "K6")
                static let K7 = Position(value: "K7")
                static let K8 = Position(value: "K8")
                static let K9 = Position(value: "K9")
                static let value5f = Position(value: "5F")
                static let H0 = Position(value: "H0")
                static let I0 = Position(value: "I0")
                static let I1 = Position(value: "I1")
                static let I2 = Position(value: "I2")
                static let I3 = Position(value: "I3")
                static let I4 = Position(value: "I4")
                static let I5 = Position(value: "I5")
                static let I6 = Position(value: "I6")
                static let I7 = Position(value: "I7")
                static let I8 = Position(value: "I8")
                static let I9 = Position(value: "I9")

                let rawValue: String
                let alternateValues: [String]

                static let allCases: [Position] = [
                            five,
                            one,
                            two,
                            four,
                            eight,
                            three,
                            six,
                            seven,
                            eleven,
                            fourteen,
                            twelve,
                            thirteen,
                            nine,
                            ten,
                            fifteen,
                            sixteen,
                            twenty,
                            seventeen,
                            eighteen,
                            nineteen,
                            twentyOne,
                            twentyTwo,
                            twentyThree,
                            twentyFour,
                            twentyFive,
                            twentySix,
                            twentySeven,
                            twentyEight,
                            thirty,
                            thirtyOne,
                            thirtyTwo,
                            twentyNine,
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
                            fortyFive,
                            fortySix,
                            fortySeven,
                            fortyEight,
                            fortyNine,
                            fifty,
                            fiftyOne,
                            fiftyTwo,
                            fiftyThree,
                            fiftyFour,
                            fiftyFive,
                            fiftySix,
                            fiftySeven,
                            fiftyEight,
                            fiftyNine,
                            sixty,
                            sixtyOne,
                            sixtyTwo,
                            sixtyThree,
                            sixtyFour,
                            A3,
                            B2,
                            B4,
                            A2,
                            A4,
                            B1,
                            B3,
                            A1,
                            A5,
                            B6,
                            A6,
                            B5,
                            C1,
                            D2,
                            D1,
                            C5,
                            D6,
                            C6,
                            D5,
                            E1,
                            E2,
                            E3,
                            E4,
                            E5,
                            E6,
                            F1,
                            F2,
                            F3,
                            F4,
                            F6,
                            A7,
                            B7,
                            F5,
                            C2,
                            C3,
                            D4,
                            C4,
                            D3,
                            A10,
                            B10,
                            A8,
                            A9,
                            B8,
                            B9,
                            A11,
                            A12,
                            A13,
                            A14,
                            A15,
                            A16,
                            A17,
                            A18,
                            A19,
                            A20,
                            A21,
                            A22,
                            A23,
                            A24,
                            B11,
                            B12,
                            B13,
                            B14,
                            B15,
                            B16,
                            B17,
                            B18,
                            B19,
                            B20,
                            C7,
                            D7,
                            E7,
                            F7,
                            G1,
                            G2,
                            G3,
                            G4,
                            G5,
                            G6,
                            G7,
                            oneHundred,
                            A25,
                            A26,
                            A27,
                            A28,
                            A29,
                            A30,
                            A31,
                            A32,
                            A33,
                            A34,
                            B21,
                            B22,
                            B23,
                            B24,
                            B25,
                            B26,
                            B27,
                            B28,
                            B29,
                            B30,
                            C10,
                            D10,
                            E10,
                            F10,
                            G10,
                            J10,
                            sixtyFive,
                            sixtySix,
                            sixtySeven,
                            sixtyEight,
                            sixtyNine,
                            seventy,
                            seventyOne,
                            seventyTwo,
                            seventyThree,
                            seventyFour,
                            seventyFive,
                            seventySix,
                            seventySeven,
                            seventyEight,
                            seventyNine,
                            eighty,
                            eightyOne,
                            eightyTwo,
                            eightyThree,
                            eightyFour,
                            eightyFive,
                            eightySix,
                            eightySeven,
                            eightyEight,
                            eightyNine,
                            ninety,
                            ninetyOne,
                            ninetyTwo,
                            ninetyThree,
                            ninetyFour,
                            ninetyFive,
                            ninetySix,
                            ninetySeven,
                            ninetyEight,
                            ninetyNine,
                            C8,
                            C9,
                            D8,
                            D9,
                            E8,
                            E9,
                            F8,
                            F9,
                            G8,
                            G9,
                            H1,
                            H2,
                            H3,
                            H4,
                            H5,
                            H6,
                            H7,
                            H8,
                            H9,
                            J1,
                            J2,
                            J3,
                            J4,
                            J5,
                            J6,
                            J7,
                            J8,
                            J9,
                            H10,
                            K10,
                            K1,
                            K2,
                            K3,
                            K4,
                            K5,
                            K6,
                            K7,
                            K8,
                            K9,
                            value5f,
                            H0,
                            I0,
                            I1,
                            I2,
                            I3,
                            I4,
                            I5,
                            I6,
                            I7,
                            I8,
                            I9
                        ]

                init(value: String, alternateValues: [String] = []) {
                    self.rawValue = value
                    self.alternateValues = alternateValues
                }
            }

            struct Pad: ATDFStringValue {
                static let GND = Pad(value: "GND")
                static let VCC = Pad(value: "VCC")
                static let PB1 = Pad(value: "PB1")
                static let PB2 = Pad(value: "PB2")
                static let PB3 = Pad(value: "PB3")
                static let PB0 = Pad(value: "PB0")
                static let PB4 = Pad(value: "PB4")
                static let PB5 = Pad(value: "PB5")
                static let PC0 = Pad(value: "PC0")
                static let PC1 = Pad(value: "PC1")
                static let PC2 = Pad(value: "PC2")
                static let PC3 = Pad(value: "PC3")
                static let PD0 = Pad(value: "PD0")
                static let PD1 = Pad(value: "PD1")
                static let PD2 = Pad(value: "PD2")
                static let PD3 = Pad(value: "PD3")
                static let PD4 = Pad(value: "PD4")
                static let PD5 = Pad(value: "PD5")
                static let PD6 = Pad(value: "PD6")
                static let PD7 = Pad(value: "PD7")
                static let PB6 = Pad(value: "PB6")
                static let PB7 = Pad(value: "PB7")
                static let PC4 = Pad(value: "PC4")
                static let PC5 = Pad(value: "PC5")
                static let AVCC = Pad(value: "AVCC")
                static let PC6 = Pad(value: "PC6")
                static let PA1 = Pad(value: "PA1")
                static let PA2 = Pad(value: "PA2")
                static let PA0 = Pad(value: "PA0")
                static let PA3 = Pad(value: "PA3")
                static let PA6 = Pad(value: "PA6")
                static let PA7 = Pad(value: "PA7")
                static let PA4 = Pad(value: "PA4")
                static let PA5 = Pad(value: "PA5")
                static let AREF = Pad(value: "AREF")
                static let PC7 = Pad(value: "PC7")
                static let XTAL1 = Pad(value: "XTAL1")
                static let XTAL2 = Pad(value: "XTAL2")
                static let PE2 = Pad(value: "PE2")
                static let PE0 = Pad(value: "PE0")
                static let PE1 = Pad(value: "PE1")
                static let PF0 = Pad(value: "PF0")
                static let PF1 = Pad(value: "PF1")
                static let PF6 = Pad(value: "PF6")
                static let RESET = Pad(value: "RESET")
                static let PF4 = Pad(value: "PF4")
                static let PF5 = Pad(value: "PF5")
                static let PE3 = Pad(value: "PE3")
                static let PF3 = Pad(value: "PF3")
                static let PF2 = Pad(value: "PF2")
                static let PE6 = Pad(value: "PE6")
                static let PF7 = Pad(value: "PF7")
                static let PE4 = Pad(value: "PE4")
                static let PE5 = Pad(value: "PE5")
                static let PE7 = Pad(value: "PE7")
                static let PG0 = Pad(value: "PG0")
                static let PG1 = Pad(value: "PG1")
                static let PG2 = Pad(value: "PG2")
                static let PG3 = Pad(value: "PG3")
                static let PG4 = Pad(value: "PG4")
                static let VDD = Pad(value: "VDD")
                static let ADC6 = Pad(value: "ADC6")
                static let ADC7 = Pad(value: "ADC7")
                static let PG5 = Pad(value: "PG5")
                static let GND1 = Pad(value: "GND1")
                static let LCDCAP = Pad(value: "LCDCAP")
                static let AGND = Pad(value: "AGND")
                static let AVDD = Pad(value: "AVDD")
                static let GND0 = Pad(value: "GND0")
                static let UPDI = Pad(value: "UPDI")
                static let VDD0 = Pad(value: "VDD0")
                static let REF = Pad(value: "REF")
                static let VDD1 = Pad(value: "VDD1")
                static let UCAP = Pad(value: "UCAP")
                static let UGND = Pad(value: "UGND")
                static let UVCC = Pad(value: "UVCC")
                static let PH0 = Pad(value: "PH0")
                static let PH1 = Pad(value: "PH1")
                static let PH2 = Pad(value: "PH2")
                static let PH3 = Pad(value: "PH3")
                static let PH4 = Pad(value: "PH4")
                static let PH5 = Pad(value: "PH5")
                static let PH6 = Pad(value: "PH6")
                static let PH7 = Pad(value: "PH7")
                static let PJ0 = Pad(value: "PJ0")
                static let PJ1 = Pad(value: "PJ1")
                static let PJ2 = Pad(value: "PJ2")
                static let PJ3 = Pad(value: "PJ3")
                static let PJ4 = Pad(value: "PJ4")
                static let PJ5 = Pad(value: "PJ5")
                static let PJ6 = Pad(value: "PJ6")
                static let PJ7 = Pad(value: "PJ7")
                static let PK0 = Pad(value: "PK0")
                static let PK1 = Pad(value: "PK1")
                static let PK2 = Pad(value: "PK2")
                static let PK3 = Pad(value: "PK3")
                static let PK4 = Pad(value: "PK4")
                static let PK5 = Pad(value: "PK5")
                static let PK6 = Pad(value: "PK6")
                static let PK7 = Pad(value: "PK7")
                static let PL0 = Pad(value: "PL0")
                static let PL1 = Pad(value: "PL1")
                static let PL2 = Pad(value: "PL2")
                static let PL3 = Pad(value: "PL3")
                static let PL4 = Pad(value: "PL4")
                static let PL5 = Pad(value: "PL5")
                static let PL6 = Pad(value: "PL6")
                static let PL7 = Pad(value: "PL7")
                static let NC = Pad(value: "NC")
                static let PEN = Pad(value: "PEN")
                static let VBUS = Pad(value: "VBUS")
                static let DM = Pad(value: "DM")
                static let DP = Pad(value: "DP")
                static let d = Pad(value: "D+")
                static let dAlt2 = Pad(value: "D-")

                let rawValue: String
                let alternateValues: [String]

                static let allCases: [Pad] = [
                            GND,
                            VCC,
                            PB1,
                            PB2,
                            PB3,
                            PB0,
                            PB4,
                            PB5,
                            PC0,
                            PC1,
                            PC2,
                            PC3,
                            PD0,
                            PD1,
                            PD2,
                            PD3,
                            PD4,
                            PD5,
                            PD6,
                            PD7,
                            PB6,
                            PB7,
                            PC4,
                            PC5,
                            AVCC,
                            PC6,
                            PA1,
                            PA2,
                            PA0,
                            PA3,
                            PA6,
                            PA7,
                            PA4,
                            PA5,
                            AREF,
                            PC7,
                            XTAL1,
                            XTAL2,
                            PE2,
                            PE0,
                            PE1,
                            PF0,
                            PF1,
                            PF6,
                            RESET,
                            PF4,
                            PF5,
                            PE3,
                            PF3,
                            PF2,
                            PE6,
                            PF7,
                            PE4,
                            PE5,
                            PE7,
                            PG0,
                            PG1,
                            PG2,
                            PG3,
                            PG4,
                            VDD,
                            ADC6,
                            ADC7,
                            PG5,
                            GND1,
                            LCDCAP,
                            AGND,
                            AVDD,
                            GND0,
                            UPDI,
                            VDD0,
                            REF,
                            VDD1,
                            UCAP,
                            UGND,
                            UVCC,
                            PH0,
                            PH1,
                            PH2,
                            PH3,
                            PH4,
                            PH5,
                            PH6,
                            PH7,
                            PJ0,
                            PJ1,
                            PJ2,
                            PJ3,
                            PJ4,
                            PJ5,
                            PJ6,
                            PJ7,
                            PK0,
                            PK1,
                            PK2,
                            PK3,
                            PK4,
                            PK5,
                            PK6,
                            PK7,
                            PL0,
                            PL1,
                            PL2,
                            PL3,
                            PL4,
                            PL5,
                            PL6,
                            PL7,
                            NC,
                            PEN,
                            VBUS,
                            DM,
                            DP,
                            d,
                            dAlt2
                        ]

                init(value: String, alternateValues: [String] = []) {
                    self.rawValue = value
                    self.alternateValues = alternateValues
                }
            }
        }
    }
}
