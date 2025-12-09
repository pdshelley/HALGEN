//===----------------------------------------------------------------------===//
//
// Timer0.swift
// CoreAVR
//
// Created by Swift AVR Generator on 12/09/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer0 = Timer0

public struct Timer0: Timer8Bit, AsyncTimer {
    /// TCCR0 – Timer/Counter Control Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x53)       | FOC0  | WGM00 | COM01 | COM00 | WGM01 | CS02  | CS01  | CS00  |
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
    /// TCNT0 – Timer/Counter Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x52)       |                             TCNT0                             |
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
            _volatileRegisterReadUInt8(0x52)
        }
        set {
            _volatileRegisterWriteUInt8(0x52, newValue)
        }
    }
    /// OCR0 – Output Compare Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x51)       |                             OCR0                              |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |                                                               |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var outputCompareRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x51)
        }
        set {
            _volatileRegisterWriteUInt8(0x51, newValue)
        }
    }
    /// ASSR – Asynchronus Status Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x50)       |   -   |   -   |   -   |   -   |  AS0  |TCN0UB |OCR0UB |TCR0UB |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   R   |   R   |   R   |   R   |       |       |       |       |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var asynchronousStatusRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x50)
        }
        set {
            _volatileRegisterWriteUInt8(0x50, newValue)
        }
    }
    /// AS0 – Asynchronus Timer/Counter 0 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (asynchronousStatusRegister & 0b00001000) >> UInt8(3)
            return .init(rawValue: mode) ??
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b00000001) << UInt8(3)
        }
    }
    /// TCN0UB – Timer/Counter0 Update Busy 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (asynchronousStatusRegister & 0b00000100) >> UInt8(2)
            return .init(rawValue: mode) ??
        }
        set {
            asynchronousStatusRegister |= (newValue.rawValue & 0b00000001) << UInt8(2)
        }
    }
    /// OCR0UB – Output Compare register 0 Busy 
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
    /// TCR0UB – Timer/Counter Control Register 0 Update Busy 
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
    /// TIMSK – Timer/Counter Interrupt Mask Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x57)       |   -   |   -   |   -   |   -   |   -   |   -   | OCIE0 | TOIE0 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |       |       |       |       |       |       |       |  R/W  |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptMaskRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x57)
        }
        set {
            _volatileRegisterWriteUInt8(0x57, newValue)
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
    ///| (0x56)       |   -   |   -   |   -   |   -   |   -   |   -   | OCF0  | TOV0  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |       |       |       |       |       |       |       |  R/W  |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterInterruptFlagregister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x56)
        }
        set {
            _volatileRegisterWriteUInt8(0x56, newValue)
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
    ///| (0x40)       |  TSM  |   -   |   -   |   -   |   -   |   -   | PSR0  |   -   |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |  R/W  |       |       |       |       |       |       |       |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var specialFunctionIORegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x40)
        }
        set {
            _volatileRegisterWriteUInt8(0x40, newValue)
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
            let mode = (specialFunctionIORegister & 0b10000000) >> UInt8(7)
            return Timer.TimerSynchronizationMode.init(rawValue: mode) ?? .disabled
        }
        set {
            specialFunctionIORegister |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// PSR0 – Prescaler Reset Timer/Counter0 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (specialFunctionIORegister & 0b00000010) >> UInt8(1)
            return .init(rawValue: mode) ??
        }
        set {
            specialFunctionIORegister |= (newValue.rawValue & 0b00000001) << UInt8(1)
        }
    }
}