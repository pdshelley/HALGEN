//===----------------------------------------------------------------------===//
//
// Timer1.swift
// CoreAVR
//
// Created by Swift AVR Generator on 12/02/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer1 = Timer1

public struct Timer1: Timer16Bit, HasExternalClock {
    /// TCCR1B – Timer/Counter1 Control Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x81)       |   -   |   -   |   -   |   -   |   -   |  CS2  |  CS1  |  CS0  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var controlRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x81)
        }
        set {
            _volatileRegisterWriteUInt16(0x81, newValue)
        }
    }
    /// CS – Clock Select1 bis 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterB & 0b00000111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00000111) << UInt8(0)
        }
    }
    /// TCCR1A – Timer/Counter 1 Control Register A
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x80)       | TCW1  | ICEN1 | ICNC1 | ICES1 | ICS1  |   -   |   -   | WGM10 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var controlRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x80)
        }
        set {
            _volatileRegisterWriteUInt16(0x80, newValue)
        }
    }
    /// TCW1 – Timer/Counter Width 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// ICEN1 – Input Capture Mode Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b01000000) >> UInt8(6)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(6)
        }
    }
    /// ICNC1 – Input Capture Noise Canceler 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b00100000) >> UInt8(5)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(5)
        }
    }
    /// ICES1 – Input Capture Edge Select 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b00010000) >> UInt8(4)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(4)
        }
    }
    /// ICS1 – Input Capture Select 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b00001000) >> UInt8(3)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(3)
        }
    }
    /// WGM1 – Waveform Generation Mode 
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
    public static var waveformGenerationMode: Timer16Bit.WaveformGenerationMode {
        get {
            let mode = ((controlRegisterB & 0b00011000) >> 2) | (controlRegisterA & 0b00000001)
            return Timer16Bit.WaveformGenerationMode(rawValue: mode) ?? .normal
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(0))
            controlRegisterB |= ((newValue.rawValue & 0b00000110) << UInt8(2))
        }
    }
    /// TCNT1 – Timer Counter 1 Bytes
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x84)       |TCNT17 |TCNT16 |TCNT15 |TCNT14 |TCNT13 |TCNT12 |TCNT11 |TCNT10 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var count: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x84)
        }
        set {
            _volatileRegisterWriteUInt16(0x84, newValue)
        }
    }
    /// TCNT1 – Timer Counter 1 bits 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (count & 0b11111111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            count |= (newValue.rawValue & 0b11111111) << UInt8(0)
        }
    }
    /// OCR1A – Output Compare Register 1A
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x88)       |OCR1A7 |OCR1A6 |OCR1A5 |OCR1A4 |OCR1A3 |OCR1A2 |OCR1A1 |OCR1A0 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x88)
        }
        set {
            _volatileRegisterWriteUInt16(0x88, newValue)
        }
    }
    /// OCR1A – Output Compare 1 A bits 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (outputCompareRegisterA & 0b11111111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            outputCompareRegisterA |= (newValue.rawValue & 0b11111111) << UInt8(0)
        }
    }
    /// OCR1B – Output Compare Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x89)       |OCR1B7 |OCR1B6 |OCR1B5 |OCR1B4 |OCR1B3 |OCR1B2 |OCR1B1 |OCR1B0 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x89)
        }
        set {
            _volatileRegisterWriteUInt16(0x89, newValue)
        }
    }
    /// OCR1B – Output Compare 1 B bits 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (outputCompareRegisterB & 0b11111111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            outputCompareRegisterB |= (newValue.rawValue & 0b11111111) << UInt8(0)
        }
    }
    /// TIMSK1 – Timer/Counter Interrupt Mask Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x6F)       |   -   |   -   |   -   |   -   | ICIE1 |OCIE1B |OCIE1A | TOIE1 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var interruptMaskRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x6F)
        }
        set {
            _volatileRegisterWriteUInt16(0x6F, newValue)
        }
    }
    /// ICIE1 – Timer/Counter n Input Capture Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (interruptMaskRegister & 0b00001000) >> UInt8(3)
            return .init(rawValue: mode) ??
        }
        set {
            interruptMaskRegister |= (newValue.rawValue & 0b00000001) << UInt8(3)
        }
    }
    /// OCIE1B – Timer/Counter1 Output Compare B Interrupt Enable 
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
    /// OCIE1A – Timer/Counter1 Output Compare A Interrupt Enable 
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
    /// TOIE1 – Timer/Counter1 Overflow Interrupt Enable 
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
    /// TIFR1 – Timer/Counter Interrupt Flag register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x36)       |   -   |   -   |   -   |   -   | ICF1  | OCF1B | OCF1A | TOV1  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var interruptFlagRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x36)
        }
        set {
            _volatileRegisterWriteUInt16(0x36, newValue)
        }
    }
    /// ICF1 – Timer/Counter 1 Input Capture Flag 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (interruptFlagRegister & 0b00001000) >> UInt8(3)
            return .init(rawValue: mode) ??
        }
        set {
            interruptFlagRegister |= (newValue.rawValue & 0b00000001) << UInt8(3)
        }
    }
    /// OCF1B – Timer/Counter1 Output Compare Flag B 
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
    /// OCF1A – Timer/Counter1 Output Compare Flag A 
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
    /// TOV1 – Timer/Counter1 Overflow Flag 
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
    /// GTCCR – General Timer/Counter Control Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x43)       |  TSM  |   -   |   -   |   -   |   -   |   -   |   -   |PSRSYNC|
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var generalControlRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x43)
        }
        set {
            _volatileRegisterWriteUInt16(0x43, newValue)
        }
    }
    /// TSM – Timer/Counter Synchronization Mode 
    ///
    /// Writing the TSM bit to one activates the Timer/Counter Synchronization mode. In this mode, the value that is
    /// written to the PSRASY and PSRSYNC bits is kept, hence keeping the corresponding prescaler reset signals
    /// asserted. This ensures that the corresponding Timer/Counters are halted and can be configured to the same
    /// value without the risk of one of them advancing during configuration. When the TSM bit is written to zero, the
    /// PSRASY and PSRSYNC bits are cleared by hardware, and the Timer/Counters start counting simultaneously.
    ///
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
    /// PSRSYNC – Prescaler Reset 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (generalControlRegister & 0b00000001) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            generalControlRegister |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
    /// TCCR0B – Timer/Counter0 Control Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x45)       |   -   |   -   |   -   |   -   |   -   | CS02  | CS01  | CS00  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var controlRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x45)
        }
        set {
            _volatileRegisterWriteUInt16(0x45, newValue)
        }
    }
    /// CS02 – Clock Select0 bit 2 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterB & 0b00000100) >> UInt8(2)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00000001) << UInt8(2)
        }
    }
    /// CS01 – Clock Select0 bit 1 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterB & 0b00000010) >> UInt8(1)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00000001) << UInt8(1)
        }
    }
    /// CS00 – Clock Select0 bit 0 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterB & 0b00000001) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
    /// TCCR0A – Timer/Counter 0 Control Register A
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x44)       | TCW0  | ICEN0 | ICNC0 | ICES0 | ICS0  |   -   |   -   | WGM00 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var controlRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x44)
        }
        set {
            _volatileRegisterWriteUInt16(0x44, newValue)
        }
    }
    /// TCW0 – Timer/Counter Width 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// ICEN0 – Input Capture Mode Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b01000000) >> UInt8(6)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(6)
        }
    }
    /// ICNC0 – Input Capture Noise Canceler 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b00100000) >> UInt8(5)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(5)
        }
    }
    /// ICES0 – Input Capture Edge Select 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b00010000) >> UInt8(4)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(4)
        }
    }
    /// ICS0 – Input Capture Select 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b00001000) >> UInt8(3)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(3)
        }
    }
    /// TCNT0 – Timer Counter 0 Bytes
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x46)       |TCNT07 |TCNT06 |TCNT05 |TCNT04 |TCNT03 |TCNT02 |TCNT01 |TCNT00 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var count: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x46)
        }
        set {
            _volatileRegisterWriteUInt16(0x46, newValue)
        }
    }
    /// TCNT0 – Timer Counter 0 bits 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (count & 0b11111111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            count |= (newValue.rawValue & 0b11111111) << UInt8(0)
        }
    }
    /// OCR0A – Output Compare Register A
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x48)       |OCR0A7 |OCR0A6 |OCR0A5 |OCR0A4 |OCR0A3 |OCR0A2 |OCR0A1 |OCR0A0 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x48)
        }
        set {
            _volatileRegisterWriteUInt16(0x48, newValue)
        }
    }
    /// OCR0A – Output Compare 0 A bits 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (outputCompareRegisterA & 0b11111111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            outputCompareRegisterA |= (newValue.rawValue & 0b11111111) << UInt8(0)
        }
    }
    /// OCR0B – Output Compare Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x49)       |OCR0B7 |OCR0B6 |OCR0B5 |OCR0B4 |OCR0B3 |OCR0B2 |OCR0B1 |OCR0B0 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x49)
        }
        set {
            _volatileRegisterWriteUInt16(0x49, newValue)
        }
    }
    /// OCR0B – Output Compare 0 B bits 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (outputCompareRegisterB & 0b11111111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            outputCompareRegisterB |= (newValue.rawValue & 0b11111111) << UInt8(0)
        }
    }
    /// TIMSK0 – Timer/Counter Interrupt Mask Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x6E)       |   -   |   -   |   -   |   -   | ICIE0 |OCIE0B |OCIE0A | TOIE0 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var interruptMaskRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x6E)
        }
        set {
            _volatileRegisterWriteUInt16(0x6E, newValue)
        }
    }
    /// ICIE0 – Timer/Counter n Input Capture Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (interruptMaskRegister & 0b00001000) >> UInt8(3)
            return .init(rawValue: mode) ??
        }
        set {
            interruptMaskRegister |= (newValue.rawValue & 0b00000001) << UInt8(3)
        }
    }
    /// OCIE0B – Timer/Counter0 Output Compare B Interrupt Enable 
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
    /// OCIE0A – Timer/Counter0 Output Compare A Interrupt Enable 
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
    /// TOIE0 – Timer/Counter0 Overflow Interrupt Enable 
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
    /// TIFR0 – Timer/Counter Interrupt Flag register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x35)       |   -   |   -   |   -   |   -   | ICF0  | OCF0B | OCF0A | TOV0  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var interruptFlagRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x35)
        }
        set {
            _volatileRegisterWriteUInt16(0x35, newValue)
        }
    }
    /// ICF0 – Timer/Counter 0 Input Capture Flag 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (interruptFlagRegister & 0b00001000) >> UInt8(3)
            return .init(rawValue: mode) ??
        }
        set {
            interruptFlagRegister |= (newValue.rawValue & 0b00000001) << UInt8(3)
        }
    }
    /// OCF0B – Timer/Counter0 Output Compare Flag B 
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
    /// OCF0A – Timer/Counter0 Output Compare Flag A 
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
    /// TOV0 – Timer/Counter0 Overflow Flag 
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
    /// GTCCR – General Timer/Counter Control Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x43)       |  TSM  |   -   |   -   |   -   |   -   |   -   |   -   |PSRSYNC|
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var generalControlRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x43)
        }
        set {
            _volatileRegisterWriteUInt16(0x43, newValue)
        }
    }
    /// TSM – Timer/Counter Synchronization Mode 
    ///
    /// Writing the TSM bit to one activates the Timer/Counter Synchronization mode. In this mode, the value that is
    /// written to the PSRASY and PSRSYNC bits is kept, hence keeping the corresponding prescaler reset signals
    /// asserted. This ensures that the corresponding Timer/Counters are halted and can be configured to the same
    /// value without the risk of one of them advancing during configuration. When the TSM bit is written to zero, the
    /// PSRASY and PSRSYNC bits are cleared by hardware, and the Timer/Counters start counting simultaneously.
    ///
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
    /// PSRSYNC – Prescaler Reset 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (generalControlRegister & 0b00000001) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            generalControlRegister |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
}