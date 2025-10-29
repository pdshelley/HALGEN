//===----------------------------------------------------------------------===//
//
// Timer2.swift
// CoreAVR
//
// Created by Swift AVR Generator on 10/29/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer2 = Timer2 

public struct Timer2: Timer8Bit, AsyncTimer, InternalClockOnly {
    /// TIMSK2 – timerCounterInterruptMaskregister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x70)       |   -   |   -   |   -   |   -   |   -   |OCIE2B |OCIE2A | TOIE2 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptMaskregister: UInt8 {
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
    public static var timerCounterOutputCompareMatchBInterruptEnable: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptMaskregister & 0b00000100) >> UInt8(2)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptMaskregister |= (newValue.rawValue & 0b00000100) << UInt8(2)
        }
    }
    /// OCIE2A – Timer/Counter2 Output Compare Match A Interrupt Enable
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareMatchAInterruptEnable: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptMaskregister & 0b00000010) >> UInt8(1)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptMaskregister |= (newValue.rawValue & 0b00000010) << UInt8(1)
        }
    }
    /// TOIE2 – Timer/Counter2 Overflow Interrupt Enable
    @inlinable
    @inline(__always)
    public static var timerCounterOverflowInterruptEnable: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptMaskregister & 0b00000001) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptMaskregister |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
    /// TIFR2 – timerCounterInterruptFlagRegister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x37)       |   -   |   -   |   -   |   -   |   -   | OCF2B | OCF2A | TOV2  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptFlagRegister: UInt8 {
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
    public static var outputCompareFlagB: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptFlagRegister & 0b00000100) >> UInt8(2)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptFlagRegister |= (newValue.rawValue & 0b00000100) << UInt8(2)
        }
    }
    /// OCF2A – Output Compare Flag 2A
    @inlinable
    @inline(__always)
    public static var outputCompareFlagA: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptFlagRegister & 0b00000010) >> UInt8(1)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptFlagRegister |= (newValue.rawValue & 0b00000010) << UInt8(1)
        }
    }
    /// TOV2 – Timer/Counter2 Overflow Flag
    @inlinable
    @inline(__always)
    public static var timerCounterOverflowFlag: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterInterruptFlagRegister & 0b00000001) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterInterruptFlagRegister |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
    /// TCCR2A – timerCounterControlRegisterA
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB0)       |COM2A1 |COM2A0 |COM2B1 |COM2B0 |   -   |   -   | WGM21 | WGM20 |
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
            _volatileRegisterReadUInt8(0xB0)
        }
        set {
            _volatileRegisterWriteUInt8(0xB0, newValue)
        }
    }
    /// COM2A – Compare Output Mode bits
    @inlinable
    @inline(__always)
    public static var compareOutputModebits: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterA & 0b11000000) >> UInt8(6)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b11000000) << UInt8(6)
        }
    }
    /// COM2B – Compare Output Mode bits
    @inlinable
    @inline(__always)
    public static var compareOutputModebits: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterA & 0b00110000) >> UInt8(4)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00110000) << UInt8(4)
        }
    }
    /// WGM2 – Waveform Genration Mode
    @inlinable
    @inline(__always)
    public static var waveformGenrationMode: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterA & 0b00000011) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(0)
        }
    }
    /// TCCR2B – timerCounterControlRegisterB
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB1)       | FOC2A | FOC2B |   -   |   -   | WGM22 | CS22  | CS21  | CS20  |
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
            _volatileRegisterReadUInt8(0xB1)
        }
        set {
            _volatileRegisterWriteUInt8(0xB1, newValue)
        }
    }
    /// FOC2A – Force Output Compare A
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
    /// FOC2B – Force Output Compare B
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
    /// WGM22 – Waveform Generation Mode
    @inlinable
    @inline(__always)
    public static var waveformGenerationMode: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterB & 0b00001000) >> UInt8(3)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterB |= (newValue.rawValue & 0b00001000) << UInt8(3)
        }
    }
    /// CS2 – Clock Select bits
    @inlinable
    @inline(__always)
    public static var clockSelectbits: Timer.CompareOutputMode {
        get {
            let mode = (timerCounterControlRegisterB & 0b00000111) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            timerCounterControlRegisterB |= (newValue.rawValue & 0b00000111) << UInt8(0)
        }
    }
    /// TCNT2 – timerCounter
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB2)       |                             TCNT2                             |
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
            _volatileRegisterReadUInt8(0xB2)
        }
        set {
            _volatileRegisterWriteUInt8(0xB2, newValue)
        }
    }
    /// OCR2B – timerCounterOutputCompareRegisterB
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB4)       |                             OCR2B                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareRegisterB: UInt8 {
        get {
            _volatileRegisterReadUInt8(0xB4)
        }
        set {
            _volatileRegisterWriteUInt8(0xB4, newValue)
        }
    }
    /// OCR2A – timerCounterOutputCompareRegisterA
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB3)       |                             OCR2A                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareRegisterA: UInt8 {
        get {
            _volatileRegisterReadUInt8(0xB3)
        }
        set {
            _volatileRegisterWriteUInt8(0xB3, newValue)
        }
    }
    /// ASSR – asynchronousStatusRegister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xB6)       |   -   | EXCLK |  AS2  |TCN2UB |OCR2AUB|OCR2BUB|TCR2AUB|TCR2BUB|
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
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
    public static var enableExternalClockInput: Timer.CompareOutputMode {
        get {
            let mode = (asynchronousStatusRegister & 0b01000000) >> UInt8(6)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b01000000) << UInt8(6)
        }
    }
    /// AS2 – Asynchronous Timer/Counter2
    @inlinable
    @inline(__always)
    public static var asynchronousTimerCounter: Timer.CompareOutputMode {
        get {
            let mode = (asynchronousStatusRegister & 0b00100000) >> UInt8(5)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b00100000) << UInt8(5)
        }
    }
    /// TCN2UB – Timer/Counter2 Update Busy
    @inlinable
    @inline(__always)
    public static var timerCounterUpdateBusy: Timer.CompareOutputMode {
        get {
            let mode = (asynchronousStatusRegister & 0b00010000) >> UInt8(4)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b00010000) << UInt8(4)
        }
    }
    /// OCR2AUB – Output Compare Register2 Update Busy
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterUpdateBusy: Timer.CompareOutputMode {
        get {
            let mode = (asynchronousStatusRegister & 0b00001000) >> UInt8(3)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b00001000) << UInt8(3)
        }
    }
    /// OCR2BUB – Output Compare Register 2 Update Busy
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterUpdateBusy: Timer.CompareOutputMode {
        get {
            let mode = (asynchronousStatusRegister & 0b00000100) >> UInt8(2)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b00000100) << UInt8(2)
        }
    }
    /// TCR2AUB – Timer/Counter Control Register2 Update Busy
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegisterUpdateBusy: Timer.CompareOutputMode {
        get {
            let mode = (asynchronousStatusRegister & 0b00000010) >> UInt8(1)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b00000010) << UInt8(1)
        }
    }
    /// TCR2BUB – Timer/Counter Control Register2 Update Busy
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegisterUpdateBusy: Timer.CompareOutputMode {
        get {
            let mode = (asynchronousStatusRegister & 0b00000001) >> UInt8(0)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
    /// GTCCR – generalTimerCounterControlregister
    /// ```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x43)       |  TSM  |   -   |   -   |   -   |   -   |   -   |PSRASY |   -   |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    /// ```
    @inlinable
    @inline(__always)
    public static var generalTimerCounterControlregister: UInt8 {
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
            let mode = (generalTimerCounterControlregister & 0b10000000) >> UInt8(7)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            generalTimerCounterControlregister |= (newValue.rawValue & 0b10000000) << UInt8(7)
        }
    }
    /// PSRASY – Prescaler Reset Timer/Counter2
    @inlinable
    @inline(__always)
    public static var prescalerResetTimerCounter: Timer.CompareOutputMode {
        get {
            let mode = (generalTimerCounterControlregister & 0b00000010) >> UInt8(1)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            generalTimerCounterControlregister |= (newValue.rawValue & 0b00000010) << UInt8(1)
        }
    }
}