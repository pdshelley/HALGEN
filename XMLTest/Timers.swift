//
//  Timers.swift
//  XMLTest
//
//  Created by Paul Shelley on 7/6/23.
//

import Foundation



//func buildTimer(file: AVRToolsDeviceFile) -> String {
//    var code: String = """
//    // Note: The ATMegaN8 comes in 4 different packages, a 28 pin DIP, a 28 pin QFN, a 32 pin QFP, and a 23 pin QFN. The two 32 pin chips have extra pins and thus have two extra ADC pins (ADC6 and ADC7).
//    // See ATMega328p Datasheet Figure 1-1.
//    struct GPOI { // TODO: I think I want to rename this struct to AVR5 or something similar. This will probably be the HAL layer for the avr5 core and I'll make a wrapper with a common HAL API that wraps this.
//    """
//
//    // Filter for Modules named "PORT" // TODO: Find a better way to filter.
//    for module in file.modules.module {
//        if module.name == .port {
//            for registerGroup in module.registerGroup {
//                code.append(buildPort(port: registerGroup))
//            }
//        }
//    }
//
//    code.append("""
//
//    }
//    """)
//
//    return code
//}


func _rawPointerRead(address: UInt16) -> UInt8 { return 0 }

func _rawPointerWrite(address: UInt16, value: UInt8) { }

//===----------------------------------------------------------------------===//
//
// Timers.swift
// Swift For Arduino
//
// Created by Paul Shelley on 12/31/2022.
// Copyright © 2022 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//
//===----------------------------------------------------------------------===//
// Timers
//===----------------------------------------------------------------------===//

// Timer0 would conform to GeneralAVRTimerSettings, AVR8BitTimerSettings, HasExternalClockTimer
// Timer1 would conform to GeneralAVRTimerSettings, AVR16BitTimerSettings, HasExternalClockTimer
// Timer2 would conform to GeneralAVRTimerSettings, AVR8BitTimerSettings, InternalClockTimerOnly, and AsyncTimer
// TODO: I think Timer 0 and 1 use the prescaler with the external clock while timer 2 only uses the internal clock
// TODO: What happens with chips that have multiple Async Timers? Is this possible?
// TODO: Explore using Generics vs Protocols

//protocol GeneralAVRTimerSettings {
//    // TODO: These first 4 properties are the same for all timers so they could be in a "Universal" AVRTimerSettings protocol.
//    static var timerCounterControlRegisterA: UInt8 { get set }
//    static var timerCounterControlRegisterB: UInt8 { get set }
//    static var timerInterruptMaskRegister: UInt8 { get set }
//    static var timerInterruptFlagRegister: UInt8 { get set }
//
//    enum CompareOutputModeOption: UInt8 {
//        case normal = 0
//        case toggle = 1 // TODO: Sometimes this is Reserved and does not work with some Waveform Generation Modes
//        case clear = 2
//        case set = 3
//    }
//}
//
//// TODO: Verify that this assumption is correct.
//protocol AsyncTimer {
//    // These are only used on the Async timer2?
//    static var ASSR:   UInt8 { get set } // TODO: Update this name.
//    static var GTCCR:  UInt8 { get set } // TODO: Update this name.
//}
//
//protocol AVR8BitTimerSettings {
//    // TODO: These 3 properties change type from UInt8 to UInt16 depending on if the timer is an 8 Bit timer or 16 Bit Timer. They should probably be in their own protocols.
//    static var timerCounterNumber: UInt8 { get set }
//    static var outputCompareRegisterA: UInt8 { get set }
//    static var outputCompareRegisterB: UInt8 { get set }
//
//    enum WaveformGenerationModeOption: UInt8 {
//        case normal = 0
//        case phaseCorrectPWM = 1
//        case clearTimerOnCompareMatch = 2
//        case fastPWM = 3
//
//        // Note: The difference in Modes 5 and 7 are that the Output Compare Register (OCRA or OCRB) is the "Top" where in modes 1 and 3, 255 (0xFF) is the "Top".
//        case advancedPhaseCorrectPWM = 5 // TODO: What should this be called?
//        case advancedFastPWM = 7  // TODO: What should this be called?
//    }
//
//
//}
//
//Protocol HasExternalClockTimer {
//    enum Prescaling: UInt8 {
//        case noClockSource = 0 // No Clock Source - counter is off
//        case none = 1 // clkT2S - No Prescaler
//        case eight = 2 // clkT2S/8
//        case thirtyTwo = 3 // clkT2S/32
//        case sixtyFour = 4 // clkT2S/64
//        case oneTwentyEight = 5 // clkT2S/128
//        case twoFiftySix = 6 // clkT2S/256
//        case tenTwentyFour = 7 // clkT2S/1024
//    }
//}
//
//protocol InternalClockTimerOnly {
//    enum Prescaling: UInt8 {
//        case noClockSource = 0
//        case none = 1
//        case eight = 2
//        case sixtyFour = 3
//        case twoFiftySix = 4
//        case tenTwentyFour = 5
//        case externalClockOnFallingEdge = 6
//        case externalClockOnRisingEdge = 7
//    }
//}
//
//
//protocol AVR16BitTimerSettings {
//
//    // TODO: 16 Bit timers have an extra control register C. Wave Form Generation has more modes, other settings might also be more granular.
//    static var timerCounterControlRegisterC: UInt8 { get set }
//
//    // TODO: These 3 properties change type from UInt8 to UInt16 depending on if the timer is an 8 Bit timer or 16 Bit Timer. They should probably be in their own protocols.
//    static var timerCounterNumber: UInt16 { get set }
//    static var outputCompareRegisterA: UInt16 { get set }
//    static var outputCompareRegisterB: UInt16 { get set }
//
//    enum WaveformGenerationModeOption: UInt8 {
//        case normal = 0
//        case phaseCorrectPWM8Bit = 1
//        case phaseCorrectPWM9Bit = 2
//        case phaseCorrectPWM10Bit = 3
//        case clearTimerCountOnOutputCompairRegister = 4 // TODO: I think naming needs to be updated to be similar to this on the 8 bit version.
//        case fastPWM8Bit = 5
//        case fastPWM9Bit = 6
//        case fastPWM10Bit = 7
//        case phaseAndFrequencyCorrectPWMOnInputCaptureRegister = 8 // TODO: Update the names of the 8 bit version to be similar to this
//        case phaseAndFrequencyCorrectPWMOnOutputCompairRegister = 9
//        case phaseCorrectPWMOnInputCaptureRegister = 10
//        case phaseCorrectPWMOnOutputCompairRegister = 11
//        case clearTimerCountOnInputCaptureRegister = 12
//        case fastPWMOnInputCaptureRegister = 14
//        case fastPWMOnOutputCompairRegister = 15
//    }
//}


//case timerCounter8Bit = "TC8"
//case timerCounter8BitAsync = "TC8_ASYNC"
//case timerCounter10Bit = "TC10"
//case timerCounter16Bit = "TC16"
//case timerCounter16BitTypeA = "TCA" // Unique to all megaAVR 0-series. EX: ATmega808 & ATmega4809
//case timerCounter16BitTypeB = "TCB" // Unique to all megaAVR 0-series. EX: ATmega808 & ATmega4809



// TODO: Timer1 is 16 bit and has quite a few differences. Figure out how to abstract this.
enum Timers {
    enum CompareOutputModeOption: UInt8 {
        case normal = 0
        case toggle = 1 // TODO: Sometimes this is Reserved and does not work with some Waveform Generation Modes
        case clear = 2
        case set = 3
    }
    enum WaveformGenerationModeOption: UInt8 {
        case normal = 0
        case phaseCorrectPWM = 1
        case clearTimerOnCompareMatch = 2
        case fastPWM = 3
        case advancedPhaseCorrectPWM = 5 // TODO: What should this be called?
        case advancedFastPWM = 7  // TODO: What should this be called?
    }
    enum Prescaling: UInt8 {
        case noClockSource = 0 // No Clock Source - counter is off
        case none = 1 // clkT2S - No Prescaler
        case eight = 2 // clkT2S/8
        case thirtyTwo = 3 // clkT2S/32
        case sixtyFour = 4 // clkT2S/64
        case oneTwentyEight = 5 // clkT2S/128
        case twoFiftySix = 6 // clkT2S/256
        case tenTwentyFour = 7 // clkT2S/1024
    }
}




//case timerCounter8Bit = "TC8"
enum Timers8Bit {
    enum CompareOutputModeOption: UInt8 {
        case normal = 0
        case toggle = 1 // TODO: Sometimes this is Reserved and does not work with some Waveform Generation Modes
        case clear = 2
        case set = 3
    }
    enum WaveformGenerationModeOption: UInt8 {
        case normal = 0
        case phaseCorrectPWM = 1
        case clearTimerOnCompareMatch = 2
        case fastPWM = 3
        case advancedPhaseCorrectPWM = 5 // TODO: What should this be called?
        case advancedFastPWM = 7  // TODO: What should this be called?
    }
    enum Prescaling: UInt8 {
        case noClockSource = 0 // No Clock Source - counter is off
        case none = 1 // clkT2S - No Prescaler
        case eight = 2 // clkT2S/8
        case thirtyTwo = 3 // clkT2S/32
        case sixtyFour = 4 // clkT2S/64
        case oneTwentyEight = 5 // clkT2S/128
        case twoFiftySix = 6 // clkT2S/256
        case tenTwentyFour = 7 // clkT2S/1024
    }
}

//case timerCounter8BitAsync = "TC8_ASYNC"
//case timerCounter10Bit = "TC10"

//case timerCounter16Bit = "TC16"
enum Timers16Bit {
    enum CompareOutputModeOption: UInt8 {
        case normal = 0
        case toggle = 1 // TODO: Sometimes this is Reserved and does not work with some Waveform Generation Modes
        case clear = 2
        case set = 3
    }
    enum WaveformGenerationModeOption: UInt8 {
        case normal = 0
        case phaseCorrectPWM8Bit = 1
        case phaseCorrectPWM9Bit = 2
        case phaseCorrectPWM10Bit = 3
        case clearTimerCountOnOutputCompairRegister = 4 // TODO: I think naming needs to be updated to be similar to this on the 8 bit version.
        case fastPWM8Bit = 5
        case fastPWM9Bit = 6
        case fastPWM10Bit = 7
        case phaseAndFrequencyCorrectPWMOnInputCaptureRegister = 8 // TODO: Update the names of the 8 bit version to be similar to this
        case phaseAndFrequencyCorrectPWMOnOutputCompairRegister = 9
        case phaseCorrectPWMOnInputCaptureRegister = 10
        case phaseCorrectPWMOnOutputCompairRegister = 11
        case clearTimerCountOnInputCaptureRegister = 12
        case fastPWMOnInputCaptureRegister = 14
        case fastPWMOnOutputCompairRegister = 15
    }
    enum Prescaling: UInt8 {
        case noClockSource = 0
        case none = 1
        case eight = 2
        case sixtyFour = 3
        case twoFiftySix = 4
        case tenTwentyFour = 5
        case externalClockOnFallingEdge = 6
        case externalClockOnRisingEdge = 7
    }
}

// TODO: Make Generic
protocol AVRTimer0 {
    static var timerCounterControlRegisterA: UInt8 { get set }
    static var timerCounterControlRegisterB: UInt8 { get set }
    static var timerCounterNumber: UInt8 { get set }
    static var outputCompareRegisterA: UInt8 { get set }
    static var outputCompareRegisterB: UInt8 { get set }
    static var timerInterruptMaskRegister: UInt8 { get set }
    static var timerInterruptFlagRegister: UInt8 { get set }
    static var asynchronousStatusRegister: UInt8 { get set }
    static var generalTimerCounterControlRegister: UInt8 { get set }
}


typealias timer0 = AVRTimer0

struct Timer0: AVRTimer0 {
    static var timerCounterControlRegisterA: UInt8 {
        get {
            _rawPointerRead(address: 0x44)
        }
        set {
            _rawPointerWrite(address: 0x44, value: newValue)
        }
    }
    static var timerCounterControlRegisterB: UInt8 {
        get {
            _rawPointerRead(address: 0x45)
        }
        set {
            _rawPointerWrite(address: 0x45, value: newValue)
        }
    }
    static var timerCounterNumber: UInt8 {
        get {
            return _rawPointerRead(address: 0x46)
        }
        set {
            _rawPointerWrite(address: 0x46, value: newValue)
        }
    }
    static var outputCompareRegisterA: UInt8 {
        get {
            return _rawPointerRead(address: 0x47)
        }
        set {
            _rawPointerWrite(address: 0x47, value: newValue)
        }
    }
    static var outputCompareRegisterB: UInt8 {
        get {
            return _rawPointerRead(address: 0x48)
        }
        set {
            _rawPointerWrite(address: 0x48, value: newValue)
        }
    }
    static var timerInterruptMaskRegister: UInt8 {
        get {
            return _rawPointerRead(address: 0x6E)
        }
        set {
            _rawPointerWrite(address: 0x6E, value: newValue)
        }
    }
    static var timerInterruptFlagRegister: UInt8 {
        get {
            return _rawPointerRead(address: 0x35)
        }
        set {
            _rawPointerWrite(address: 0x35, value: newValue)
        }
    }
    static var asynchronousStatusRegister: UInt8 {
        get {
            return _rawPointerRead(address: 0xB6) // TODO: is this register address shared by all timers?
        }
        set {
            _rawPointerWrite(address: 0xB6, value: newValue) // TODO: is this register address shared by all timers?
        }
    }
    static var generalTimerCounterControlRegister: UInt8 {
        get {
            return _rawPointerRead(address: 0x43)
        }
        set {
            _rawPointerWrite(address: 0x43, value: newValue)
        }
    }
}


extension AVRTimer0 {
    static var CompareOutputModeA: Timers.CompareOutputModeOption {
        get {
            let mode = (timerCounterControlRegisterA & 0b11000000) >> UInt8(6)
            return Timers.CompareOutputModeOption.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(6)
        }
    }
    static var CompareOutputModeB: Timers.CompareOutputModeOption {
        get {
            let mode = (timerCounterControlRegisterA & 0b00110000) >> 4
            return Timers.CompareOutputModeOption.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(4)
        }
    }
    static var prescalor: Timers.Prescaling {
        get {
            let mode = timerCounterControlRegisterA & 0b00000111
            return Timers.Prescaling.init(rawValue: mode) ?? .noClockSource
        }
        set {
            timerCounterControlRegisterB |= newValue.rawValue & 0b00000111
        }
    }
    static var waveformGenerationMode: Timers.WaveformGenerationModeOption {
        get {
            let mode = ((timerCounterControlRegisterB & 0b00001000) >> 1) | (timerCounterControlRegisterA & 0b00000011)
            return Timers.WaveformGenerationModeOption.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00000011)
            timerCounterControlRegisterB |= ((newValue.rawValue & 0b00000100) << UInt8(1))
        }
    }
}

protocol AVRTimer1 {
    // TODO: These first 4 properties are the same for all timers so they could be in a "Universal" AVRTimerSettings protocol.
    static var timerCounterControlRegisterA: UInt8 { get set }
    static var timerCounterControlRegisterB: UInt8 { get set }
    static var timerInterruptMaskRegister: UInt8 { get set }
    static var timerInterruptFlagRegister: UInt8 { get set }
    
    // TODO: 16 Bit timers have an extra control register C. Wave Form Generation has more modes, other settings might also be more granular.
    static var timerCounterControlRegisterC: UInt8 { get set }
    
    // TODO: These 3 properties change type from UInt8 to UInt16 depending on if the timer is an 8 Bit timer or 16 Bit Timer. They should probably be in their own protocols.
    static var timerCounterNumber: UInt16 { get set }
    static var outputCompareRegisterA: UInt16 { get set }
    static var outputCompareRegisterB: UInt16 { get set }
}


typealias timer1 = AVRTimer1


/// Timer 2 implementation for ATmega48A/PA/88A/PA/168A/PA/328/P
// NOTE: PRTIM2 needs to be written to zero to enable Timer/Counter2 module. See Datasheet section 18.2
struct Timer1: AVRTimer1 {
    static var timerCounterControlRegisterA: UInt8 {
        get {
            _rawPointerRead(address: 0x80)
        }
        set {
            _rawPointerWrite(address: 0x80, value: newValue)
        }
    }
    static var timerCounterControlRegisterB: UInt8 {
        get {
            _rawPointerRead(address: 0x81)
        }
        set {
            _rawPointerWrite(address: 0x81, value: newValue)
        }
    }
    static var timerCounterControlRegisterC: UInt8 {
        get {
            _rawPointerRead(address: 0x82)
        }
        set {
            _rawPointerWrite(address: 0x82, value: newValue)
        }
    }
    static var timerCounterNumber: UInt16 {
        get {
            return (UInt16(TCNT1H) << 8) | UInt16(TCNT1L)
        }
        set {
            TCNT1H = UInt8((newValue & 0b1111111100000000) >> 8)
            TCNT1L = UInt8(newValue & 0b11111111)
        }
    }
    static var TCNT1L: UInt8 { //TCNT1L
        get {
            return _rawPointerRead(address: 0x84)
        }
        set {
            _rawPointerWrite(address: 0x84, value: newValue)
        }
    }
    static var TCNT1H: UInt8 { //TCNT1H
        get {
            return _rawPointerRead(address: 0x85)
        }
        set {
            _rawPointerWrite(address: 0x85, value: newValue)
        }
    }
    static var outputCompareRegisterA: UInt16 {
        get {
            return (UInt16(OCR1AH) << 8) | UInt16(OCR1AL)
        }
        set {
            OCR1AH = UInt8((newValue & 0b1111111100000000) >> 8)
            OCR1AL = UInt8(newValue & 0b11111111)
        }
    }
    static var OCR1AL: UInt8 {
        get {
            return _rawPointerRead(address: 0x88)
        }
        set {
            _rawPointerWrite(address: 0x88, value: newValue)
        }
    }
    static var OCR1AH: UInt8 {
        get {
            return _rawPointerRead(address: 0x89)
        }
        set {
            _rawPointerWrite(address: 0x89, value: newValue)
        }
    }
    static var outputCompareRegisterB: UInt16 {
        get {
            return (UInt16(OCR1BH) << 8) | UInt16(OCR1BL)
        }
        set {
            OCR1BH = UInt8((newValue & 0b1111111100000000) >> 8)
            OCR1BL = UInt8(newValue & 0b11111111)
        }
    }
    static var OCR1BL: UInt8 {
        get {
            return _rawPointerRead(address: 0x8A)
        }
        set {
            _rawPointerWrite(address: 0x8A, value: newValue)
        }
    }
    static var OCR1BH: UInt8 {
        get {
            return _rawPointerRead(address: 0x8B)
        }
        set {
            _rawPointerWrite(address: 0x8B, value: newValue)
        }
    }
    static var timerInterruptMaskRegister: UInt8 {
        get {
            return _rawPointerRead(address: 0x6F)
        }
        set {
            _rawPointerWrite(address: 0x6F, value: newValue)
        }
    }
    static var timerInterruptFlagRegister: UInt8 {
        get {
            return _rawPointerRead(address: 0x36)
        }
        set {
            _rawPointerWrite(address: 0x36, value: newValue)
        }
    }
}

extension AVRTimer1 {
    static var CompareOutputModeA: Timers16Bit.CompareOutputModeOption {
        get {
            let mode = (timerCounterControlRegisterA & 0b11000000) >> UInt8(6)
            return Timers16Bit.CompareOutputModeOption.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(6)
        }
    }
    static var CompareOutputModeB: Timers16Bit.CompareOutputModeOption {
        get {
            let mode = (timerCounterControlRegisterA & 0b00110000) >> 4
            return Timers16Bit.CompareOutputModeOption.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(4)
        }
    }
    static var prescalor: Timers16Bit.Prescaling {
        get {
            let mode = timerCounterControlRegisterA & 0b00000111
            return Timers16Bit.Prescaling.init(rawValue: mode) ?? .noClockSource
        }
        set {
            timerCounterControlRegisterB |= newValue.rawValue & 0b00000111
        }
    }
    static var waveformGenerationMode: Timers16Bit.WaveformGenerationModeOption {
        get {
            let mode = ((timerCounterControlRegisterB & 0b00001000) >> 1) | (timerCounterControlRegisterA & 0b00000011)
            return Timers16Bit.WaveformGenerationModeOption.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00000011)
            timerCounterControlRegisterB |= ((newValue.rawValue & 0b00000100) << UInt16(1))
        }
    }
}


typealias timer2 = Timer2


/// Timer 2 implementation for ATmega48A/PA/88A/PA/168A/PA/328/P
// NOTE: PRTIM2 needs to be written to zero to enable Timer/Counter2 module. See Datasheet section 18.2
struct Timer2: TimerPort {
    static var TCCR2A: UInt8 { get { _rawPointerRead(address: 0xB0) } set { _rawPointerWrite(address: 0xB0, value: newValue) } }
    static var TCCR2B: UInt8 { get { _rawPointerRead(address: 0xB1) } set { _rawPointerWrite(address: 0xB1, value: newValue) } }
    static var TCNT2: UInt8 { get { _rawPointerRead(address: 0xB2) } set { _rawPointerWrite(address: 0xB2, value: newValue) } }
    static var OCR2A: UInt8 { get { _rawPointerRead(address: 0xB3) } set { _rawPointerWrite(address: 0xB3, value: newValue) } }
    static var OCR2B: UInt8 { get { _rawPointerRead(address: 0xB4) } set { _rawPointerWrite(address: 0xB4, value: newValue) } }
    static var TIMSK2: UInt8 { get { _rawPointerRead(address: 0x70) } set { _rawPointerWrite(address: 0x70, value: newValue) } }
    static var TIFR2: UInt8 { get { _rawPointerRead(address: 0x37) } set { _rawPointerWrite(address: 0x37, value: newValue) } }
    static var ASSR: UInt8 { get { _rawPointerRead(address: 0xB6) } set { _rawPointerWrite(address: 0xB6, value: newValue) } }
    static var GTCCR: UInt8 { get { _rawPointerRead(address: 0x43) } set { _rawPointerWrite(address: 0x43, value: newValue) } }
}

protocol TimerPort {
    static var TCCR2A: UInt8 { get set }
    static var TCCR2B: UInt8 { get set }
    static var TCNT2:  UInt8 { get set }
    static var OCR2A:  UInt8 { get set }
    static var OCR2B:  UInt8 { get set }
    static var TIMSK2: UInt8 { get set }
    static var TIFR2:  UInt8 { get set }
    static var ASSR:   UInt8 { get set }
    static var GTCCR:  UInt8 { get set }
}

extension TimerPort {
    static var outputCompareRegisterA: UInt8 {
        get {
            return OCR2A
        }
        set {
            OCR2A = newValue
        }
    }
    static var outputCompareRegisterB: UInt8 {
        get {
            return OCR2B
        }
        set {
            OCR2B = newValue
        }
    }
    static var timerCounterNumber: UInt8 {
        get {
            return TCNT2
        }
        set {
            TCNT2 = newValue
        }
    }
    static var timerInterruptFlagRegister: UInt8 {
        get {
            return TIFR2
        }
        set {
            TIFR2 = newValue
        }
    }
    static var timerInterruptMaskRegister: UInt8 {
        get {
            return TIMSK2
        }
        set {
            TIMSK2 = newValue
        }
    }
    static var asynchronousStatusRegister: UInt8 {
        get {
            return ASSR
        }
        set {
            ASSR = newValue
        }
    }
    static var generalTimerCounterControlRegister: UInt8 {
        get {
            return GTCCR
        }
        set {
            GTCCR = newValue
        }
    }
    static var CompareOutputModeA: Timers.CompareOutputModeOption {
        get {
            let mode = (TCCR2A & 0b11000000) >> UInt8(6)
            return Timers.CompareOutputModeOption.init(rawValue: mode) ?? .normal
        }
        set {
            TCCR2A |= (newValue.rawValue & 0b00000011) << UInt8(6)
        }
    }
    static var CompareOutputModeB: Timers.CompareOutputModeOption {
        get {
            let mode = (TCCR2A & 0b00110000) >> 4
            return Timers.CompareOutputModeOption.init(rawValue: mode) ?? .normal
        }
        set {
            TCCR2A |= (newValue.rawValue & 0b00000011) << UInt8(4)
        }
    }
    static var prescalor: Timers.Prescaling {
        get {
            let mode = TCCR2B & 0b00000111
            return Timers.Prescaling.init(rawValue: mode) ?? .noClockSource
        }
        set {
            TCCR2B |= newValue.rawValue & 0b00000111
        }
    }
    static var waveformGenerationMode: Timers.WaveformGenerationModeOption {
        get {
            let mode = ((TCCR2B & 0b00001000) >> 1) | (TCCR2A & 0b00000011)
            return Timers.WaveformGenerationModeOption.init(rawValue: mode) ?? .normal
        }
        set {
            TCCR2A |= (newValue.rawValue & 0b00000011)
            TCCR2B |= ((newValue.rawValue & 0b00000100) << UInt8(1))
        }
    }
}






