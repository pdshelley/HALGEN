//===----------------------------------------------------------------------===//
//
// Timer0.swift
// CoreAVR
//
// Created by Swift AVR Generator on 10/29/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer0 = Timer0 

public struct Timer0: Timer8Bit, HasExternalClock {
    /// OCR0B – timerCounterOutputCompareRegister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x48)       |                             OCR0B                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x48)
        }
        set {
            _volatileRegisterWriteUInt8(0x48, newValue)
        }
    }
    /// OCR0A – timerCounterOutputCompareRegister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x47)       |                             OCR0A                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x47)
        }
        set {
            _volatileRegisterWriteUInt8(0x47, newValue)
        }
    }
    /// TCNT0 – timerCounter
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x46)       |                             TCNT0                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounter: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x46)
        }
        set {
            _volatileRegisterWriteUInt8(0x46, newValue)
        }
    }
    /// TCCR0B – timerCounterControlRegisterB
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x45)       | FOC0A | FOC0B |   -   |   -   | WGM02 | CS02  | CS01  | CS00  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegisterB: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x45)
        }
        set {
            _volatileRegisterWriteUInt8(0x45, newValue)
        }
    }
    /// FOC0A – Force Output Compare A
    @inlinable
    @inline(__always)
    public static var forceOutputCompareA: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterB & 0b10000000) >> UInt8(7)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterB |= (newValue.rawValue & 0b10000000) << UInt8(7)
        }
    }
    /// FOC0B – Force Output Compare B
    @inlinable
    @inline(__always)
    public static var forceOutputCompareB: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterB & 0b01000000) >> UInt8(6)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterB |= (newValue.rawValue & 0b01000000) << UInt8(6)
        }
    }
    /// WGM02 – 
    @inlinable
    @inline(__always)
    public static var : Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterB & 0b00001000) >> UInt8(3)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterB |= (newValue.rawValue & 0b00001000) << UInt8(3)
        }
    }
    /// CS0 – Clock Select
    @inlinable
    @inline(__always)
    public static var clockSelect: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterB & 0b00000111) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterB |= (newValue.rawValue & 0b00000111) << UInt8(0)
        }
    }
    /// TCCR0A – timerCounterControlRegisterA
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x44)       |COM0A1 |COM0A0 |COM0B1 |COM0B0 |   -   |   -   | WGM01 | WGM00 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegisterA: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x44)
        }
        set {
            _volatileRegisterWriteUInt8(0x44, newValue)
        }
    }
    /// COM0A – Compare Output Mode, Phase Correct PWM Mode
    @inlinable
    @inline(__always)
    public static var compareOutputMode, PhaseCorrectPWMMode: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterA & 0b11000000) >> UInt8(6)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b11000000) << UInt8(6)
        }
    }
    /// COM0B – Compare Output Mode, Fast PWm
    @inlinable
    @inline(__always)
    public static var compareOutputMode, FastPWm: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterA & 0b00110000) >> UInt8(4)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00110000) << UInt8(4)
        }
    }
    /// WGM0 – Waveform Generation Mode
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
    /// TIMSK0 – timerCounterInterruptMaskRegister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x6E)       |   -   |   -   |   -   |   -   |   -   |OCIE0B |OCIE0A | TOIE0 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptMaskRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x6E)
        }
        set {
            _volatileRegisterWriteUInt8(0x6E, newValue)
        }
    }
    /// OCIE0B – Timer/Counter0 Output Compare Match B Interrupt Enable
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareMatchBInterruptEnable: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptMaskRegister & 0b00000100) >> UInt8(2)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptMaskRegister |= (newValue.rawValue & 0b00000100) << UInt8(2)
        }
    }
    /// OCIE0A – Timer/Counter0 Output Compare Match A Interrupt Enable
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareMatchAInterruptEnable: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptMaskRegister & 0b00000010) >> UInt8(1)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptMaskRegister |= (newValue.rawValue & 0b00000010) << UInt8(1)
        }
    }
    /// TOIE0 – Timer/Counter0 Overflow Interrupt Enable
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
    /// TIFR0 – timerCounterInterruptFlagregister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x35)       |   -   |   -   |   -   |   -   |   -   | OCF0B | OCF0A | TOV0  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptFlagregister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x35)
        }
        set {
            _volatileRegisterWriteUInt8(0x35, newValue)
        }
    }
    /// OCF0B – Timer/Counter0 Output Compare Flag 0B
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareFlagB: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptFlagregister & 0b00000100) >> UInt8(2)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptFlagregister |= (newValue.rawValue & 0b00000100) << UInt8(2)
        }
    }
    /// OCF0A – Timer/Counter0 Output Compare Flag 0A
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareFlagA: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptFlagregister & 0b00000010) >> UInt8(1)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptFlagregister |= (newValue.rawValue & 0b00000010) << UInt8(1)
        }
    }
    /// TOV0 – Timer/Counter0 Overflow Flag
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
    public static var generalTimerCounterControlRegister: UInt8 {
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