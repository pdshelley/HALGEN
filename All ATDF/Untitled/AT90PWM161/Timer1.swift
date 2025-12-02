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
    /// TIMSK1 – Timer/Counter Interrupt Mask Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x21)       |   -   |   -   | ICIE1 |   -   |   -   |   -   |   -   | TOIE1 |
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
            _volatileRegisterReadUInt16(0x21)
        }
        set {
            _volatileRegisterWriteUInt16(0x21, newValue)
        }
    }
    /// ICIE1 – Timer/Counter1 Input Capture Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (interruptMaskRegister & 0b00100000) >> UInt8(5)
            return .init(rawValue: mode) ??
        }
        set {
            interruptMaskRegister |= (newValue.rawValue & 0b00000001) << UInt8(5)
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
    ///| (0x22)       |   -   |   -   | ICF1  |   -   |   -   |   -   |   -   | TOV1  |
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
            _volatileRegisterReadUInt16(0x22)
        }
        set {
            _volatileRegisterWriteUInt16(0x22, newValue)
        }
    }
    /// ICF1 – Input Capture Flag 1 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (interruptFlagRegister & 0b00100000) >> UInt8(5)
            return .init(rawValue: mode) ??
        }
        set {
            interruptFlagRegister |= (newValue.rawValue & 0b00000001) << UInt8(5)
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
    /// TCCR1B – Timer/Counter1 Control Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x8A)       | ICNC1 | ICES1 |   -   | WGM13 |   -   | CS12  | CS11  | CS10  |
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
            _volatileRegisterReadUInt16(0x8A)
        }
        set {
            _volatileRegisterWriteUInt16(0x8A, newValue)
        }
    }
    /// ICNC1 – Input Capture 1 Noise Canceler 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterB & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// ICES1 – Input Capture 1 Edge Select 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterB & 0b01000000) >> UInt8(6)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00000001) << UInt8(6)
        }
    }
    /// WGM13 – Waveform Generation Mode 
    @inlinable
    @inline(__always)
    public static var : Timer16Bit. {
        get {
            let mode = ((controlRegisterB & 0b00010000) >> 3) | (controlRegisterB & 0b00010000)
            return Timer16Bit.(rawValue: mode) ??
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00000001) << UInt8(4))
            controlRegisterB |= ((newValue.rawValue & 0b00000010) << UInt8(3))
        }
    }
    /// ```
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |  Mode  | CS12  | CS11  | CS10  | Description                                                     |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    0   |   0   |   0   |   0   | No Clock Source (Stopped)                                       |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    1   |   0   |   0   |   1   | Running, No Prescaling                                          |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    2   |   0   |   1   |   0   | Running, CLK/8                                                  |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    3   |   0   |   1   |   1   | Running, CLK/64                                                 |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    4   |   1   |   0   |   0   | Running, CLK/256                                                |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    5   |   1   |   0   |   1   | Running, CLK/1024                                               |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    6   |   1   |   1   |   0   | External clock source. Clock on falling edge.                   |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    7   |   1   |   1   |   1   | External clock source. Clock on rising edge.                    |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// ```
    public enum Prescaling: UInt8 {
        case stopped = 0
        case runningWithoutPrescaling = 1
        case running8 = 2
        case running64 = 3
        case running256 = 4
        case running1024 = 5
        case runningExternalFallingEdge = 6
        case runningExternalRisingEdge = 7
    }
    /// CS1 – Prescaler source of Timer/Counter 1 
    /// The three Clock Select bits select the clock source to be used by the Timer/Counter.
    @inlinable
    @inline(__always)
    public static var prescaler: Prescaling {
        get {
            let mode = (controlRegisterB & 0b00000111) >> UInt8(0)
            return Prescaling.init(rawValue: mode) ?? .stopped
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00000111) << UInt8(0)
        }
    }
    /// TCNT1 – Timer/Counter1  Bytes
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x5A)       |                             TCNT1                             |
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
            _volatileRegisterReadUInt16(0x5A)
        }
        set {
            _volatileRegisterWriteUInt16(0x5A, newValue)
        }
    }
    /// ICR1 – Timer/Counter1 Input Capture Register  Bytes
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x8C)       |                             ICR1                              |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterInputCaptureRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x8C)
        }
        set {
            _volatileRegisterWriteUInt16(0x8C, newValue)
        }
    }
}