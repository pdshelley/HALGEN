//===----------------------------------------------------------------------===//
//
// Timer2.swift
// CoreAVR
//
// Created by Swift AVR Generator on 11/10/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer2 = Timer2

public struct Timer2: Timer8Bit, AsyncTimer, InternalClockOnly {
    /// TIMSK2 – Timer/Counter Interrupt Mask register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x70)       |   -   |   -   |   -   |   -   |   -   |OCIE2B |OCIE2A | TOIE2 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var interruptMaskRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x70)
        }
        set {
            _volatileRegisterWriteUInt8(0x70, newValue)
        }
    }
    /// OCIE2B – Timer/Counter2 Output Compare Match B Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var outputCompareMatchBInterruptEnable: Bool {
        get {
            let flag = (interruptMaskRegister & 0b00000100) >> UInt8(2)
            return flag == 1
        }
        set {
            interruptMaskRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(2)
        }
    }
    /// OCIE2A – Timer/Counter2 Output Compare Match A Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var outputCompareMatchAInterruptEnable: Bool {
        get {
            let flag = (interruptMaskRegister & 0b00000010) >> UInt8(1)
            return flag == 1
        }
        set {
            interruptMaskRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(1)
        }
    }
    /// TOIE2 – Timer/Counter2 Overflow Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var overflowInterruptEnable: Bool {
        get {
            let flag = (interruptMaskRegister & 0b00000001) >> UInt8(0)
            return flag == 1
        }
        set {
            interruptMaskRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(0)
        }
    }
    /// TIFR2 – Timer/Counter Interrupt Flag Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x37)       |   -   |   -   |   -   |   -   |   -   | OCF2B | OCF2A | TOV2  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var interruptFlagRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x37)
        }
        set {
            _volatileRegisterWriteUInt8(0x37, newValue)
        }
    }
    /// OCF2B – Output Compare Flag 2B 
    @inlinable
    @inline(__always)
    public static var outputCompareFlagB: Bool {
        get {
            let flag = (interruptFlagRegister & 0b00000100) >> UInt8(2)
            return flag == 1
        }
        set {
            interruptFlagRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(2)
        }
    }
    /// OCF2A – Output Compare Flag 2A 
    @inlinable
    @inline(__always)
    public static var outputCompareFlagA: Bool {
        get {
            let flag = (interruptFlagRegister & 0b00000010) >> UInt8(1)
            return flag == 1
        }
        set {
            interruptFlagRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(1)
        }
    }
    /// TOV2 – Timer/Counter2 Overflow Flag 
    @inlinable
    @inline(__always)
    public static var overflowFlag: Bool {
        get {
            let flag = (interruptFlagRegister & 0b00000001) >> UInt8(0)
            return flag == 1
        }
        set {
            interruptFlagRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(0)
        }
    }
    /// TCCR2A – Timer/Counter2 Control Register A
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB0)       |COM2A1 |COM2A0 |COM2B1 |COM2B0 |   -   |   -   | WGM21 | WGM20 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var controlRegisterA: UInt8 {
        get {
            _volatileRegisterReadUInt8(0xB0)
        }
        set {
            _volatileRegisterWriteUInt8(0xB0, newValue)
        }
    }
    /// COM2A – Compare Output Mode bits 
    ///
    /// These bits control the Output Compare pin (OC2A) behavior. If one or both of the COM2A1:0 bits are set, the
    /// OC2A output overrides the normal port functionality of the I/O pin it is connected to. However, note that the Data
    /// Direction Register (DDR) bit corresponding to the OC2A pin must be set in order to enable the output driver.
    /// When OC2A is connected to the pin, the function of the COM2A1:0 bits depends on the WGM22:0 bit setting.
    /// Table 1 shows the COM2A1:0 bit functionality when the WGM22:0 bits are set to a normal or CTC mode
    /// (non-PWM).
    ///
    /// Table 1. Compare Output Mode, non-PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2A1| COM2A0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC0A disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Toggle OC2A on Compare Match                                     |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2A on Compare Match                                      |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2A on Compare Match                                        |
    ///---------------------------------------------------------------------------------------------
    ///```
    ///
    /// Table 2 shows the COM2A1:0 bit functionality when the WGM21:0 bits are set to fast PWM mode.
    ///
    /// Table 2. Compare Output Mode, Fast PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2A1| COM2A0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2A disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | WGM22 = 0: Normal Port Operation, OC0A Disconnected.             |
    ///|        |       |       | WGM22 = 1: Toggle OC2A on Compare Match.                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2A on Compare Match, set OC2A at BOTTOM,                 |
    ///|        |       |       | (non-inverting mode).                                            |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2A on Compare Match, clear OC2A at BOTTOM,                 |
    ///|        |       |       | (inverting mode).                                                |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2A equals TOP and COM2A1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at BOTTOM. See ”Fast PWM Mode” in datasheet  for more details.
    ///
    /// Table 3 shows the COM2A1:0 bit functionality when the WGM22:0 bits are set to phase correct PWM mode.
    ///
    /// Table 3. Compare Output Mode, Phase Correct PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2A1| COM2A0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2A disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | WGM22 = 0: Normal Port Operation, OC0A Disconnected.             |
    ///|        |       |       | WGM22 = 1: Toggle OC2A on Compare Match.                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2A on Compare Match when up-counting.                    |
    ///|        |       |       | Set OC2A on Compare Match when down-counting.                    |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2A on Compare Match when up-counting.                      |
    ///|        |       |       | Clear OC2A on Compare Match when down-counting.                  |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2A equals TOP and COM2A1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at TOP. See ”Phase Correct PWM Mode” in datasheet for more details.
    ///
    @inlinable
    @inline(__always)
    public static var compareOutputModeA: Timer.CompareOutputMode {
        get {
            let mode = (controlRegisterA & 0b11000000) >> UInt8(6)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(6)
        }
    }
    /// COM2B – Compare Output Mode bits 
    /// See ATMega328p Datasheet Table 18-5, Table 18-6, and Table 18-7.
    ///
    /// These bits control the Output Compare pin (OC2B) behavior. If one or both of the COM2B1:0 bits are set, the
    /// OC2B output overrides the normal port functionality of the I/O pin it is connected to. However, note that the Data
    /// Direction Register (DDR) bit corresponding to the OC2B pin must be set in order to enable the output driver.
    /// When OC2B is connected to the pin, the function of the COM2B1:0 bits depends on the WGM22:0 bit setting.
    /// Table 18-5 shows the COM2B1:0 bit functionality when the WGM22:0 bits are set to a normal or CTC mode
    /// (non-PWM).
    ///
    /// Table 18-5. Compare Output Mode, non-PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2B1| COM2B0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC0B disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Toggle OC2B on Compare Match                                     |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2B on Compare Match                                      |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2B on Compare Match                                        |
    ///---------------------------------------------------------------------------------------------
    ///```
    ///
    /// Table 18-6 shows the COM2B1:0 bit functionality when the WGM22:0 bits are set to fast PWM mode.
    ///
    /// Table 18-6. Compare Output Mode, Fast PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2B1| COM2B0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2B disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Reserved                                                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2B on Compare Match, set OC2B at BOTTOM,                 |
    ///|        |       |       | (non-inverting mode).                                            |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2B on Compare Match, clear OC2B at BOTTOM,                 |
    ///|        |       |       | (inverting mode).                                                |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2B equals TOP and COM2B1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at BOTTOM. See ”Phase Correct PWM Mode” on page 157 for more
    ///       details.
    ///
    /// Table 18-7 shows the COM2B1:0 bit functionality when the WGM22:0 bits are set to phase correct PWM mode.
    ///
    /// Table 18-7. Compare Output Mode, Phase Correct PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2B1| COM2B0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2B disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Reserved                                                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2B on Compare Match when up-counting.                    |
    ///|        |       |       | Set OC2B on Compare Match when down-counting.                    |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2B on Compare Match when up-counting.                      |
    ///|        |       |       | Clear OC2B on Compare Match when down-counting.                  |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2B equals TOP and COM2B1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at TOP. See ”Phase Correct PWM Mode” on page 157 for more details.
    ///
    @inlinable
    @inline(__always)
    public static var compareOutputModeB: Timer.CompareOutputMode {
        get {
            let mode = (controlRegisterA & 0b00110000) >> UInt8(4)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(4)
        }
    }
    /// TCCR2B – Timer/Counter2 Control Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB1)       | FOC2A | FOC2B |   -   |   -   | WGM22 | CS22  | CS21  | CS20  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var controlRegisterB: UInt8 {
        get {
            _volatileRegisterReadUInt8(0xB1)
        }
        set {
            _volatileRegisterWriteUInt8(0xB1, newValue)
        }
    }
    /// FOC2A – Force Output Compare A 
    @inlinable
    @inline(__always)
    public static var forceOutputCompareA: Bool {
        get {
            let flag = (controlRegisterB & 0b10000000) >> UInt8(7)
            return flag == 1
        }
        set {
            controlRegisterB |= (newValue ? 1 : 0) & 0b00000001 << UInt8(7)
        }
    }
    /// FOC2B – Force Output Compare B 
    @inlinable
    @inline(__always)
    public static var forceOutputCompareB: Bool {
        get {
            let flag = (controlRegisterB & 0b01000000) >> UInt8(6)
            return flag == 1
        }
        set {
            controlRegisterB |= (newValue ? 1 : 0) & 0b00000001 << UInt8(6)
        }
    }
    /// WGM2 – Waveform Genration Mode 
    ///
    /// Combined with the WGM22 bit found in the TCCR2B Register, these bits control the counting sequence of the
    /// counter, the source for maximum (TOP) counter value, and what type of waveform generation to be used, see
    /// Table 18-8. Modes of operation supported by the Timer/Counter unit are: Normal mode (counter), Clear Timer
    /// on Compare Match (CTC) mode, and two types of Pulse Width Modulation (PWM) modes (see ”Modes of
    /// Operation” on page 155).
    ///
    /// Table 18-8. Waveform Generation Mode Bit Description
    ///```
    ///-----------------------------------------------------------------------------------------------------
    ///|  Mode  | WGM22 | WGM21 | WGM20 | Mode of Operation  |  TOP  | Update of OCRx at | TOV Flag Set on |
    ///-----------------------------------------------------------------------------------------------------
    ///|    0   |   0   |   0   |   0   | Normal             | 0xFF  | Immediate         | MAX             |
    ///-----------------------------------------------------------------------------------------------------
    ///|    1   |   0   |   0   |   1   | PWM, Phase Correct | 0xFF  | TOP               | BOTTOM          |
    ///-----------------------------------------------------------------------------------------------------
    ///|    2   |   0   |   1   |   0   | CTC                | OCRA  | Immediate         | MAX             |
    ///-----------------------------------------------------------------------------------------------------
    ///|    3   |   0   |   1   |   1   | Fast PWM           | 0xFF  | BOTTOM            | MAX             |
    ///-----------------------------------------------------------------------------------------------------
    ///|    4   |   1   |   0   |   0   | Reserved           |   -   |         -         |        -        |
    ///-----------------------------------------------------------------------------------------------------
    ///|    5   |   1   |   0   |   1   | PWM, Phase Correct | OCRA  | TOP               | BOTTOM          |
    ///-----------------------------------------------------------------------------------------------------
    ///|    6   |   1   |   1   |   0   | Reserved           |   -   |         -         |        -        |
    ///-----------------------------------------------------------------------------------------------------
    ///|    7   |   1   |   1   |   1   | Fast PWM           | OCRA  | BOTTOM            | TOP             |
    ///-----------------------------------------------------------------------------------------------------
    ///```
    /// Notes: 1. MAX= 0xFF
    ///      2. BOTTOM= 0x00
    ///
    @inlinable
    @inline(__always)
    public static var waveformGenerationMode: Timer8Bit.WaveformGenerationMode {
        get {
            let mode = ((controlRegisterB & 0b00001000) >> 1) | (controlRegisterA & 0b00000011)
            return Timer8Bit.WaveformGenerationMode(rawValue: mode) ?? .normal
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(0))
            controlRegisterB |= ((newValue.rawValue & 0b00000001) << UInt8(3))
        }
    }
    /// CS2 – Clock Select bits 
    /// The three Clock Select bits select the clock source to be used by the Timer/Counter, see Table 18-9 on page 165.
    ///
    /// Table 18-9. Clock Select Bit Description
    ///```
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |  Mode  | CS22  | CS21  | CS20  | Description                                                     |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    0   |   0   |   0   |   0   | No clock source (Timer/Counter stopped)                         |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    1   |   0   |   0   |   1   | clk T2S/(No prescaling)                                         |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    2   |   0   |   1   |   0   | clk T2S/8 (From prescaler)                                      |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    3   |   0   |   1   |   1   | clk T2S/32 (From prescaler)                                     |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    4   |   1   |   0   |   0   | clkI T2S/64 (From prescaler)                                    |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    5   |   1   |   0   |   1   | clkI T2S/128 (From prescaler)                                   |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    6   |   1   |   1   |   0   | clkI T2S/256 (From prescaler)                                   |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    7   |   1   |   1   |   1   | clkI T2S/1024 (From prescaler)                                  |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// ```
    /// If external pin modes are used for the Timer/Counter0, transitions on the T0 pin will clock the counter even if the
    /// pin is configured as an output. This feature allows software control of the counting.
    ///
    /// Note: In the datasheet this is called the Clock Select. Prescaler is probably more descriptive.
    @inlinable
    @inline(__always)
    public static var prescaler: InternalClockOnlyPrescaling {
        get {
            let mode = (controlRegisterB & 0b00000111) >> UInt8(0)
            return InternalClockOnlyPrescaling.init(rawValue: mode) ?? .noClockSource
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00000111) << UInt8(0)
        }
    }
    /// TCNT2 – Timer/Counter2
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB2)       |                             TCNT2                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var number: UInt8 {
        get {
            _volatileRegisterReadUInt8(0xB2)
        }
        set {
            _volatileRegisterWriteUInt8(0xB2, newValue)
        }
    }
    /// OCR2B – Timer/Counter2 Output Compare Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB4)       |                             OCR2B                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterB: UInt8 {
        get {
            _volatileRegisterReadUInt8(0xB4)
        }
        set {
            _volatileRegisterWriteUInt8(0xB4, newValue)
        }
    }
    /// OCR2A – Timer/Counter2 Output Compare Register A
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB3)       |                             OCR2A                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterA: UInt8 {
        get {
            _volatileRegisterReadUInt8(0xB3)
        }
        set {
            _volatileRegisterWriteUInt8(0xB3, newValue)
        }
    }
    /// ASSR – Asynchronous Status Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB6)       |   -   | EXCLK |  AS2  |TCN2UB |OCR2AUB|OCR2BUB|TCR2AUB|TCR2BUB|
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var asynchronousStatusRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0xB6)
        }
        set {
            _volatileRegisterWriteUInt8(0xB6, newValue)
        }
    }
    /// EXCLK – Enable External Clock Input 
    @inlinable
    @inline(__always)
    public static var enableExternalClockInput: Bool {
        get {
            let flag = (asynchronousStatusRegister & 0b01000000) >> UInt8(6)
            return flag == 1
        }
        set {
            asynchronousStatusRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(6)
        }
    }
    /// AS2 – Asynchronous Timer/Counter2 
    @inlinable
    @inline(__always)
    public static var asynchronousTimerCounter: Bool {
        get {
            let flag = (asynchronousStatusRegister & 0b00100000) >> UInt8(5)
            return flag == 1
        }
        set {
            asynchronousStatusRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(5)
        }
    }
    /// TCN2UB – Timer/Counter2 Update Busy 
    @inlinable
    @inline(__always)
    public static var updateBusy: Bool {
        get {
            let flag = (asynchronousStatusRegister & 0b00010000) >> UInt8(4)
            return flag == 1
        }
        set {
            asynchronousStatusRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(4)
        }
    }
    /// OCR2AUB – Output Compare Register2 Update Busy 
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterAUpdateBusy: Bool {
        get {
            let flag = (asynchronousStatusRegister & 0b00001000) >> UInt8(3)
            return flag == 1
        }
        set {
            asynchronousStatusRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(3)
        }
    }
    /// OCR2BUB – Output Compare Register 2 Update Busy 
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterBUpdateBusy: Bool {
        get {
            let flag = (asynchronousStatusRegister & 0b00000100) >> UInt8(2)
            return flag == 1
        }
        set {
            asynchronousStatusRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(2)
        }
    }
    /// TCR2AUB – Timer/Counter Control Register2 Update Busy 
    @inlinable
    @inline(__always)
    public static var controlRegisterAUpdateBusy: Bool {
        get {
            let flag = (asynchronousStatusRegister & 0b00000010) >> UInt8(1)
            return flag == 1
        }
        set {
            asynchronousStatusRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(1)
        }
    }
    /// TCR2BUB – Timer/Counter Control Register2 Update Busy 
    @inlinable
    @inline(__always)
    public static var controlRegisterBUpdateBusy: Bool {
        get {
            let flag = (asynchronousStatusRegister & 0b00000001) >> UInt8(0)
            return flag == 1
        }
        set {
            asynchronousStatusRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(0)
        }
    }
    /// GTCCR – General Timer Counter Control register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x43)       |  TSM  |   -   |   -   |   -   |   -   |   -   |PSRASY |   -   |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var generalControlRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x43)
        }
        set {
            _volatileRegisterWriteUInt8(0x43, newValue)
        }
    }
    /// TSM – Timer/Counter Synchronization Mode 
    @inlinable
    @inline(__always)
    public static var timerSynchronizationMode: Timer.TimerSynchronizationMode {
        get {
            let mode = (generalControlRegister & 0b10000000) >> UInt8(7)
            return Timer.TimerSynchronizationMode.init(rawValue: mode) ?? .disabled
        }
        set {
            generalControlRegister |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// PSRASY – Prescaler Reset Timer/Counter2 
    @inlinable
    @inline(__always)
    public static var prescalerReset: Bool {
        get {
            let flag = (generalControlRegister & 0b00000010) >> UInt8(1)
            return flag == 1
        }
        set {
            generalControlRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(1)
        }
    }
}