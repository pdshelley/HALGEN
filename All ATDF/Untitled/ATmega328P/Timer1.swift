//===----------------------------------------------------------------------===//
//
// Timer1.swift
// CoreAVR
//
// Created by Swift AVR Generator on 10/29/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer1 = Timer1 

public struct Timer1: Timer16Bit, HasExternalClock {
    /// TIMSK1 – timerCounterInterruptMaskRegister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x6F)       |   -   |   -   | ICIE1 |   -   |   -   |OCIE1B |OCIE1A | TOIE1 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptMaskRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x6F)
        }
        set {
            _volatileRegisterWriteUInt16(0x6F, newValue)
        }
    }
    /// ICIE1 – Timer/Counter1 Input Capture Interrupt Enable
    @inlinable
    @inline(__always)
    public static var timerCounterInputCaptureInterruptEnable: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptMaskRegister & 0b00100000) >> UInt8(5)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptMaskRegister |= (newValue.rawValue & 0b00100000) << UInt8(5)
        }
    }
    /// OCIE1B – Timer/Counter1 Output CompareB Match Interrupt Enable
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareBMatchInterruptEnable: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptMaskRegister & 0b00000100) >> UInt8(2)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptMaskRegister |= (newValue.rawValue & 0b00000100) << UInt8(2)
        }
    }
    /// OCIE1A – Timer/Counter1 Output CompareA Match Interrupt Enable
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareAMatchInterruptEnable: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptMaskRegister & 0b00000010) >> UInt8(1)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptMaskRegister |= (newValue.rawValue & 0b00000010) << UInt8(1)
        }
    }
    /// TOIE1 – Timer/Counter1 Overflow Interrupt Enable
    @inlinable
    @inline(__always)
    public static var timerCounterOverflowInterruptEnable: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptMaskRegister & 0b00000001) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptMaskRegister |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
    /// TIFR1 – timerCounterInterruptFlagregister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x36)       |   -   |   -   | ICF1  |   -   |   -   | OCF1B | OCF1A | TOV1  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptFlagregister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x36)
        }
        set {
            _volatileRegisterWriteUInt16(0x36, newValue)
        }
    }
    /// ICF1 – Input Capture Flag 1
    @inlinable
    @inline(__always)
    public static var inputCaptureFlag: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptFlagregister & 0b00100000) >> UInt8(5)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptFlagregister |= (newValue.rawValue & 0b00100000) << UInt8(5)
        }
    }
    /// OCF1B – Output Compare Flag 1B
    @inlinable
    @inline(__always)
    public static var outputCompareFlagB: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptFlagregister & 0b00000100) >> UInt8(2)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptFlagregister |= (newValue.rawValue & 0b00000100) << UInt8(2)
        }
    }
    /// OCF1A – Output Compare Flag 1A
    @inlinable
    @inline(__always)
    public static var outputCompareFlagA: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptFlagregister & 0b00000010) >> UInt8(1)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptFlagregister |= (newValue.rawValue & 0b00000010) << UInt8(1)
        }
    }
    /// TOV1 – Timer/Counter1 Overflow Flag
    @inlinable
    @inline(__always)
    public static var timerCounterOverflowFlag: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptFlagregister & 0b00000001) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptFlagregister |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
    /// TCCR1A – timerCounterControlRegisterA
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x80)       |COM1A1 |COM1A0 |COM1B1 |COM1B0 |   -   |   -   | WGM11 | WGM10 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x80)
        }
        set {
            _volatileRegisterWriteUInt16(0x80, newValue)
        }
    }
    /// COM1A – Compare Output Mode 1A, bits
    @inlinable
    @inline(__always)
    public static var compareOutputModeA, bits: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterA & 0b11000000) >> UInt8(6)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b11000000) << UInt8(6)
        }
    }
    /// COM1B – Compare Output Mode 1B, bits
    @inlinable
    @inline(__always)
    public static var compareOutputModeB, bits: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterA & 0b00110000) >> UInt8(4)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00110000) << UInt8(4)
        }
    }
    /// WGM1 – Waveform Generation Mode
    @inlinable
    @inline(__always)
    public static var waveformGenerationMode: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterA & 0b00000011) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(0)
        }
    }
    /// TCCR1B – timerCounterControlRegisterB
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x81)       | ICNC1 | ICES1 |   -   | WGM11 | WGM10 | CS12  | CS11  | CS10  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x81)
        }
        set {
            _volatileRegisterWriteUInt16(0x81, newValue)
        }
    }
    /// ICNC1 – Input Capture 1 Noise Canceler
    @inlinable
    @inline(__always)
    public static var inputCaptureNoiseCanceler: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterB & 0b10000000) >> UInt8(7)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterB |= (newValue.rawValue & 0b10000000) << UInt8(7)
        }
    }
    /// ICES1 – Input Capture 1 Edge Select
    @inlinable
    @inline(__always)
    public static var inputCaptureEdgeSelect: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterB & 0b01000000) >> UInt8(6)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterB |= (newValue.rawValue & 0b01000000) << UInt8(6)
        }
    }
    /// WGM1 – Waveform Generation Mode
    @inlinable
    @inline(__always)
    public static var waveformGenerationMode: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterB & 0b00011000) >> UInt8(3)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterB |= (newValue.rawValue & 0b00011000) << UInt8(3)
        }
    }
    /// CS1 – Prescaler source of Timer/Counter 1
    @inlinable
    @inline(__always)
    public static var prescalersourceofTimerCounter: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterB & 0b00000111) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterB |= (newValue.rawValue & 0b00000111) << UInt8(0)
        }
    }
    /// TCCR1C – timerCounterControlRegisterC
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x82)       | FOC1A | FOC1B |   -   |   -   |   -   |   -   |   -   |   -   |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegisterC: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x82)
        }
        set {
            _volatileRegisterWriteUInt16(0x82, newValue)
        }
    }
    /// FOC1A – 
    @inlinable
    @inline(__always)
    public static var : Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterC & 0b10000000) >> UInt8(7)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterC |= (newValue.rawValue & 0b10000000) << UInt8(7)
        }
    }
    /// FOC1B – 
    @inlinable
    @inline(__always)
    public static var : Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterC & 0b01000000) >> UInt8(6)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterC |= (newValue.rawValue & 0b01000000) << UInt8(6)
        }
    }
    /// TCNT1 – timerCounterBytes
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x84)       |                             TCNT1                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x84)
        }
        set {
            _volatileRegisterWriteUInt16(0x84, newValue)
        }
    }
    /// OCR1A – timerCounterOutputCompareRegisterBytes
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x88)       |                             OCR1A                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x88)
        }
        set {
            _volatileRegisterWriteUInt16(0x88, newValue)
        }
    }
    /// OCR1B – timerCounterOutputCompareRegisterBytes
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x8A)       |                             OCR1B                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x8A)
        }
        set {
            _volatileRegisterWriteUInt16(0x8A, newValue)
        }
    }
    /// ICR1 – timerCounterInputCaptureRegisterBytes
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x86)       |                             ICR1                              |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterInputCaptureRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x86)
        }
        set {
            _volatileRegisterWriteUInt16(0x86, newValue)
        }
    }
    /// GTCCR – generalTimerCounterControlRegister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x43)       |  TSM  |   -   |   -   |   -   |   -   |   -   |   -   |PSRSYNC|
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var generalTimerCounterControlRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x43)
        }
        set {
            _volatileRegisterWriteUInt16(0x43, newValue)
        }
    }
    /// TSM – Timer/Counter Synchronization Mode
    @inlinable
    @inline(__always)
    public static var timerCounterSynchronizationMode: Timer.CompareOutputMode {
        get {
            let mode = (generalTimerCounterControlRegister & 0b10000000) >> UInt8(7)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            generalTimerCounterControlRegister |= (newValue.rawValue & 0b10000000) << UInt8(7)
        }
    }
    /// PSRSYNC – Prescaler Reset Timer/Counter1 and Timer/Counter0
    @inlinable
    @inline(__always)
    public static var prescalerResetTimerCounterandTimerCounter: Timer.CompareOutputMode {
        get {
            let mode = (generalTimerCounterControlRegister & 0b00000001) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            generalTimerCounterControlRegister |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
}