//===----------------------------------------------------------------------===//
//
// Timer0.swift
// CoreAVR
//
// Created by Swift AVR Generator on 12/11/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer0 = Timer0

public struct Timer0: Timer8Bit {
    /// TCCR0 – Timer/Counter Control Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x53)       | FOC0  | WGM00 | COM01 | COM00 | WGM01 | CS02  | CS01  | CS00  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x53)
        }
        set {
            _volatileRegisterWriteUInt8(0x53, newValue)
        }
    }
    /// FOC0 – Force Output Compare 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegister & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegister |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// COM0 – Compare Match Output Modes 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegister & 0b00110000) >> UInt8(4)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegister |= (newValue.rawValue & 0b00000011) << UInt8(4)
        }
    }
    /// ```
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |  Mode  | CS02  | CS01  | CS00  | Description                                                     |
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
    /// CS0 – Clock Selects 
    /// The three Clock Select bits select the clock source to be used by the Timer/Counter.
    @inlinable
    @inline(__always)
    public static var prescaler: Prescaling {
        get {
            let mode = (timerCounterControlRegister & 0b00000111) >> UInt8(0)
            return Prescaling.init(rawValue: mode) ?? .stopped
        }
        set {
            timerCounterControlRegister |= (newValue.rawValue & 0b00000111) << UInt8(0)
        }
    }
    /// TCNT0 – Timer/Counter 0 Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x52)       |TCNT07 |TCNT06 |TCNT05 |TCNT04 |TCNT03 |TCNT02 |TCNT01 |TCNT00 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var count: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x52)
        }
        set {
            _volatileRegisterWriteUInt8(0x52, newValue)
        }
    }
    /// TCNT0 – Timer/Counter 0 bits 
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
    /// OCR0 – Output Compare 0 Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x5C)       | OCR07 | OCR06 | OCR05 | OCR04 | OCR03 | OCR02 | OCR01 | OCR00 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |  R/W  |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var outputCompareRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x5C)
        }
        set {
            _volatileRegisterWriteUInt8(0x5C, newValue)
        }
    }
    /// OCR0 – Output Compare bits 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (outputCompareRegister & 0b11111111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            outputCompareRegister |= (newValue.rawValue & 0b11111111) << UInt8(0)
        }
    }
    /// TIMSK – Timer/Counter Interrupt Mask Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x59)       |   -   |   -   |   -   |   -   |   -   |   -   | OCIE0 | TOIE0 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |       |       |       |       |       |       |  R/W  |  R/W  |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptMaskRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x59)
        }
        set {
            _volatileRegisterWriteUInt8(0x59, newValue)
        }
    }
    /// OCIE0 – Timer/Counter0 Output Compare Match Interrupt register 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterInterruptMaskRegister & 0b00000010) >> UInt8(1)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterInterruptMaskRegister |= (newValue.rawValue & 0b00000001) << UInt8(1)
        }
    }
    /// TOIE0 – Timer/Counter0 Overflow Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var overflowInterruptEnable: Bool {
        get {
            let flag = (timerCounterInterruptMaskRegister & 0b00000001) >> UInt8(0)
            return flag == 1
        }
        set {
            timerCounterInterruptMaskRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(0)
        }
    }
    /// TIFR – Timer/Counter Interrupt Flag register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x58)       |   -   |   -   |   -   |   -   |   -   |   -   | OCF0  | TOV0  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |       |       |       |       |       |       |  R/W  |  R/W  |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptFlagregister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x58)
        }
        set {
            _volatileRegisterWriteUInt8(0x58, newValue)
        }
    }
    /// OCF0 – Output Compare Flag 0 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterInterruptFlagregister & 0b00000010) >> UInt8(1)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterInterruptFlagregister |= (newValue.rawValue & 0b00000001) << UInt8(1)
        }
    }
    /// TOV0 – Timer/Counter0 Overflow Flag 
    @inlinable
    @inline(__always)
    public static var overflowFlag: Bool {
        get {
            let flag = (timerCounterInterruptFlagregister & 0b00000001) >> UInt8(0)
            return flag == 1
        }
        set {
            timerCounterInterruptFlagregister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(0)
        }
    }
    /// SFIOR – Special Function IO Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x50)       |   -   |   -   |   -   |   -   |   -   |   -   |   -   | PSR10 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |       |       |       |       |       |       |       |  R/W  |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var specialFunctionIORegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x50)
        }
        set {
            _volatileRegisterWriteUInt8(0x50, newValue)
        }
    }
    /// PSR10 – Prescaler Reset Timer/Counter1 and Timer/Counter0 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (specialFunctionIORegister & 0b00000001) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            specialFunctionIORegister |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
}