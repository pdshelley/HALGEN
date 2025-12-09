//===----------------------------------------------------------------------===//
//
// Timer2.swift
// CoreAVR
//
// Created by Swift AVR Generator on 12/09/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer2 = Timer2

public struct Timer2: Timer8Bit, AsyncTimer {
    /// TIMSK – Timer/Counter Interrupt Mask register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x59)       | OCIE2 | TOIE2 |   -   |   -   |   -   |   -   |   -   |   -   |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |       |  R/W  |       |       |       |       |       |       |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptMaskregister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x59)
        }
        set {
            _volatileRegisterWriteUInt8(0x59, newValue)
        }
    }
    /// OCIE2 – Timer/Counter2 Output Compare Match Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterInterruptMaskregister & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterInterruptMaskregister |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// TOIE2 – Timer/Counter2 Overflow Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var overflowInterruptEnable: Bool {
        get {
            let flag = (timerCounterInterruptMaskregister & 0b01000000) >> UInt8(6)
            return flag == 1
        }
        set {
            timerCounterInterruptMaskregister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(6)
        }
    }
    /// TIFR – Timer/Counter Interrupt Flag Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x58)       | OCF2  | TOV2  |   -   |   -   |   -   |   -   |   -   |   -   |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |       |  R/W  |       |       |       |       |       |       |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptFlagRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x58)
        }
        set {
            _volatileRegisterWriteUInt8(0x58, newValue)
        }
    }
    /// OCF2 – Output Compare Flag 2 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterInterruptFlagRegister & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterInterruptFlagRegister |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// TOV2 – Timer/Counter2 Overflow Flag 
    @inlinable
    @inline(__always)
    public static var overflowFlag: Bool {
        get {
            let flag = (timerCounterInterruptFlagRegister & 0b01000000) >> UInt8(6)
            return flag == 1
        }
        set {
            timerCounterInterruptFlagRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(6)
        }
    }
    /// TCCR2 – Timer/Counter2 Control Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x45)       | FOC2  | WGM20 | COM21 | COM20 | WGM21 | CS22  | CS21  | CS20  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |       |  R/W  |       |       |  R/W  |  R/W  |  R/W  |  R/W  |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x45)
        }
        set {
            _volatileRegisterWriteUInt8(0x45, newValue)
        }
    }
    /// FOC2 – Force Output Compare 
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
    /// COM2 – Compare Output Mode bits 
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
    /// |  Mode  | CS22  | CS21  | CS20  | Description                                                     |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    0   |   0   |   0   |   0   | No Clock Source (Stopped)                                       |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    1   |   0   |   0   |   1   | Running, No Prescaling                                          |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    2   |   0   |   1   |   0   | Running, CLK/8                                                  |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    3   |   0   |   1   |   1   | Running, CLK/32                                                 |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    4   |   1   |   0   |   0   | Running, CLK/64                                                 |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    5   |   1   |   0   |   1   | Running, CLK/128                                                |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    6   |   1   |   1   |   0   | Running, CLK/256                                                |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// |    7   |   1   |   1   |   1   | Running, CLK/1024                                               |
    /// |--------|-------|-------|-------|-----------------------------------------------------------------|
    /// ```
    public enum Prescaling: UInt8 {
        case stopped = 0
        case runningWithoutPrescaling = 1
        case running8 = 2
        case running32 = 3
        case running64 = 4
        case running128 = 5
        case running256 = 6
        case running1024 = 7
    }
    /// CS2 – Clock Select bits 
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
    /// TCNT2 – Timer/Counter2
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x44)       |                             TCNT2                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |                              R/W                              |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var count: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x44)
        }
        set {
            _volatileRegisterWriteUInt8(0x44, newValue)
        }
    }
    /// OCR2 – Timer/Counter2 Output Compare Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x43)       |                             OCR2                              |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |                                                               |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x43)
        }
        set {
            _volatileRegisterWriteUInt8(0x43, newValue)
        }
    }
    /// ASSR – Asynchronous Status Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x42)       |   -   |   -   |   -   |   -   |  AS2  |TCN2UB |OCR2UB |TCR2UB |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   R   |   R   |   R   |   R   |  R/W  |   R   |       |       |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var asynchronousStatusRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x42)
        }
        set {
            _volatileRegisterWriteUInt8(0x42, newValue)
        }
    }
    /// AS2 – Asynchronous Timer/counter2 
    @inlinable
    @inline(__always)
    public static var asynchronousTimerCounter: Bool {
        get {
            let flag = (asynchronousStatusRegister & 0b00001000) >> UInt8(3)
            return flag == 1
        }
        set {
            asynchronousStatusRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(3)
        }
    }
    /// TCN2UB – Timer/Counter2 Update Busy 
    @inlinable
    @inline(__always)
    public static var updateBusy: Bool {
        get {
            let flag = (asynchronousStatusRegister & 0b00000100) >> UInt8(2)
            return flag == 1
        }
        set {
            asynchronousStatusRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(2)
        }
    }
    /// OCR2UB – Output Compare Register2 Update Busy 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (asynchronousStatusRegister & 0b00000010) >> UInt8(1)
            return .init(rawValue: mode) ??
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b00000001) << UInt8(1)
        }
    }
    /// TCR2UB – Timer/counter Control Register2 Update Busy 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (asynchronousStatusRegister & 0b00000001) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
}