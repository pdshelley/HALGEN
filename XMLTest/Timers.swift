//
//  Timers.swift
//  XMLTest
//
//  Created by Paul Shelley on 7/6/23.
//

import Foundation

// file.devices.device.peripherals.module.name == .TC8
//
//  <module name="TC8">
//    <instance name="TC0" caption="Timer/Counter, 8-bit">
//      <register-group name="TC0" name-in-module="TC0" offset="0x00" address-space="data" caption="Timer/Counter, 8-bit"/>
//      <signals>
//        <signal group="T" function="default" pad="PD4"/>
//        <signal group="OCB" function="default" pad="PD5"/>
//        <signal group="OCA" function="default" pad="PD6"/>
//      </signals>
//    </instance>
//  </module>




// file.modules.module.name = .TC8
// 
//    <module caption="Timer/Counter, 8-bit" name="TC8">
//      <register-group caption="Timer/Counter, 8-bit" name="TC0">
//        <register caption="Timer/Counter0 Output Compare Register" name="OCR0B" offset="0x48" size="1" mask="0xFF"/>
//        <register caption="Timer/Counter0 Output Compare Register" name="OCR0A" offset="0x47" size="1" mask="0xFF"/>
//        <register caption="Timer/Counter0" name="TCNT0" offset="0x46" size="1" mask="0xFF"/>
//        <register caption="Timer/Counter Control Register B" name="TCCR0B" offset="0x45" size="1">
//          <bitfield caption="Force Output Compare A" mask="0x80" name="FOC0A"/>
//          <bitfield caption="Force Output Compare B" mask="0x40" name="FOC0B"/>
//          <bitfield mask="0x08" name="WGM02"/>
//          <bitfield caption="Clock Select" mask="0x07" name="CS0" values="CLK_SEL_3BIT_EXT"/>
//        </register>
//        <register caption="Timer/Counter  Control Register A" name="TCCR0A" offset="0x44" size="1">
//          <bitfield caption="Compare Output Mode, Phase Correct PWM Mode" mask="0xC0" name="COM0A"/>
//          <bitfield caption="Compare Output Mode, Fast PWm" mask="0x30" name="COM0B"/>
//          <bitfield caption="Waveform Generation Mode" mask="0x03" name="WGM0"/>
//        </register>
//        <register caption="Timer/Counter0 Interrupt Mask Register" name="TIMSK0" offset="0x6E" size="1">
//          <bitfield caption="Timer/Counter0 Output Compare Match B Interrupt Enable" mask="0x04" name="OCIE0B"/>
//          <bitfield caption="Timer/Counter0 Output Compare Match A Interrupt Enable" mask="0x02" name="OCIE0A"/>
//          <bitfield caption="Timer/Counter0 Overflow Interrupt Enable" mask="0x01" name="TOIE0"/>
//        </register>
//        <register caption="Timer/Counter0 Interrupt Flag register" name="TIFR0" offset="0x35" size="1" ocd-rw="R">
//          <bitfield caption="Timer/Counter0 Output Compare Flag 0B" mask="0x04" name="OCF0B"/>
//          <bitfield caption="Timer/Counter0 Output Compare Flag 0A" mask="0x02" name="OCF0A"/>
//          <bitfield caption="Timer/Counter0 Overflow Flag" mask="0x01" name="TOV0"/>
//        </register>
//        <register caption="General Timer/Counter Control Register" name="GTCCR" offset="0x43" size="1">
//          <bitfield caption="Timer/Counter Synchronization Mode" mask="0x80" name="TSM"/>
//          <bitfield caption="Prescaler Reset Timer/Counter1 and Timer/Counter0" mask="0x01" name="PSRSYNC"/>
//        </register>
//      </register-group>
//      <value-group name="CLK_SEL_3BIT_EXT">
//        <value caption="No Clock Source (Stopped)" name="NO_CLOCK_SOURCE_STOPPED" value="0x00"/>
//        <value caption="Running, No Prescaling" name="RUNNING_NO_PRESCALING" value="0x01"/>
//        <value caption="Running, CLK/8" name="RUNNING_CLK_8" value="0x02"/>
//        <value caption="Running, CLK/64" name="RUNNING_CLK_64" value="0x03"/>
//        <value caption="Running, CLK/256" name="RUNNING_CLK_256" value="0x04"/>
//        <value caption="Running, CLK/1024" name="RUNNING_CLK_1024" value="0x05"/>
//        <value caption="Running, ExtClk Tn Falling Edge" name="RUNNING_EXTCLK_TN_FALLING_EDGE" value="0x06"/>
//        <value caption="Running, ExtClk Tn Rising Edge" name="RUNNING_EXTCLK_TN_RISING_EDGE" value="0x07"/>
//      </value-group>
//    </module>


func buildTimer(file: AVRToolsDeviceFile) -> String {
    var code: String = ""
    
    
    
    
    // Filter for Modules named "PORT" // TODO: Find a better way to filter.
    for module in file.modules.module {
        if module.name == .tc8 {
            for registerGroup in module.registerGroup {
                code.append(buildPort(port: registerGroup))
            }
        }
    }
    
    return code
}

// Note: These are only here for being able to build as these symbols are not linked like they would be in a true HAL project.
func _volatileRegisterReadUInt8(_: UInt16) -> UInt8 { return 0 }

func _volatileRegisterWriteUInt8(_: UInt16, _: UInt8) { }

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
            _volatileRegisterReadUInt8(0x44)
        }
        set {
            _volatileRegisterWriteUInt8(0x44, newValue)
        }
    }
    static var timerCounterControlRegisterB: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x45)
        }
        set {
            _volatileRegisterWriteUInt8(0x45, newValue)
        }
    }
    static var timerCounterNumber: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x46)
        }
        set {
            _volatileRegisterWriteUInt8(0x46, newValue)
        }
    }
    static var outputCompareRegisterA: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x47)
        }
        set {
            _volatileRegisterWriteUInt8(0x47, newValue)
        }
    }
    static var outputCompareRegisterB: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x48)
        }
        set {
            _volatileRegisterWriteUInt8(0x48, newValue)
        }
    }
    static var timerInterruptMaskRegister: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x6E)
        }
        set {
            _volatileRegisterWriteUInt8(0x6E, newValue)
        }
    }
    static var timerInterruptFlagRegister: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x35)
        }
        set {
            _volatileRegisterWriteUInt8(0x35, newValue)
        }
    }
    static var asynchronousStatusRegister: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0xB6) // TODO: is this register address shared by all timers?
        }
        set {
            _volatileRegisterWriteUInt8(0xB6, newValue) // TODO: is this register address shared by all timers?
        }
    }
    static var generalTimerCounterControlRegister: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x43)
        }
        set {
            _volatileRegisterWriteUInt8(0x43, newValue)
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
            _volatileRegisterReadUInt8(0x80)
        }
        set {
            _volatileRegisterWriteUInt8(0x80, newValue)
        }
    }
    static var timerCounterControlRegisterB: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x81)
        }
        set {
            _volatileRegisterWriteUInt8(0x81, newValue)
        }
    }
    static var timerCounterControlRegisterC: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x82)
        }
        set {
            _volatileRegisterWriteUInt8(0x82, newValue)
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
            return _volatileRegisterReadUInt8(0x84)
        }
        set {
            _volatileRegisterWriteUInt8(0x84, newValue)
        }
    }
    static var TCNT1H: UInt8 { //TCNT1H
        get {
            return _volatileRegisterReadUInt8(0x85)
        }
        set {
            _volatileRegisterWriteUInt8(0x85, newValue)
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
            return _volatileRegisterReadUInt8(0x88)
        }
        set {
            _volatileRegisterWriteUInt8(0x88, newValue)
        }
    }
    static var OCR1AH: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x89)
        }
        set {
            _volatileRegisterWriteUInt8(0x89, newValue)
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
            return _volatileRegisterReadUInt8(0x8A)
        }
        set {
            _volatileRegisterWriteUInt8(0x8A, newValue)
        }
    }
    static var OCR1BH: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x8B)
        }
        set {
            _volatileRegisterWriteUInt8(0x8B, newValue)
        }
    }
    static var timerInterruptMaskRegister: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x6F)
        }
        set {
            _volatileRegisterWriteUInt8(0x6F, newValue)
        }
    }
    static var timerInterruptFlagRegister: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x36)
        }
        set {
            _volatileRegisterWriteUInt8(0x36, newValue)
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
    static var TCCR2A: UInt8 { get { _volatileRegisterReadUInt8(0xB0) } set { _volatileRegisterWriteUInt8(0xB0, newValue) } }
    static var TCCR2B: UInt8 { get { _volatileRegisterReadUInt8(0xB1) } set { _volatileRegisterWriteUInt8(0xB1, newValue) } }
    static var TCNT2: UInt8 { get { _volatileRegisterReadUInt8(0xB2) } set { _volatileRegisterWriteUInt8(0xB2, newValue) } }
    static var OCR2A: UInt8 { get { _volatileRegisterReadUInt8(0xB3) } set { _volatileRegisterWriteUInt8(0xB3, newValue) } }
    static var OCR2B: UInt8 { get { _volatileRegisterReadUInt8(0xB4) } set { _volatileRegisterWriteUInt8(0xB4, newValue) } }
    static var TIMSK2: UInt8 { get { _volatileRegisterReadUInt8(0x70) } set { _volatileRegisterWriteUInt8(0x70, newValue) } }
    static var TIFR2: UInt8 { get { _volatileRegisterReadUInt8(0x37) } set { _volatileRegisterWriteUInt8(0x37, newValue) } }
    static var ASSR: UInt8 { get { _volatileRegisterReadUInt8(0xB6) } set { _volatileRegisterWriteUInt8(0xB6, newValue) } }
    static var GTCCR: UInt8 { get { _volatileRegisterReadUInt8(0x43) } set { _volatileRegisterWriteUInt8(0x43, newValue) } }
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






