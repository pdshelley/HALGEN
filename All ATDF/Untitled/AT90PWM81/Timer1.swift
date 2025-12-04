//===----------------------------------------------------------------------===//
//
// Timer1.swift
// CoreAVR
//
// Created by Swift AVR Generator on 12/04/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer1 = Timer1

public struct Timer1: Timer16Bit {
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
    public static var interruptMaskRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x21)
        }
        set {
            _volatileRegisterWriteUInt8(0x21, newValue)
        }
    }
    /// ICIE1 – Timer/Counter1 Input Capture Interrupt Enable 
    ///
    /// When this bit is written to one, and the I-flag in the Status Register is set (interrupts globally enabled), the
    /// Timer/Counter1 Input Capture interrupt is enabled. The corresponding Interrupt Vector (see “Interrupts” is executed
    /// when the ICFn Flag, located in TIFRn, is set.
    @inlinable
    @inline(__always)
    public static var inputCaptureInterruptEnable: Bool {
        get {
            let flag = (interruptMaskRegister & 0b00100000) >> UInt8(5)
            return flag == 1
        }
        set {
            interruptMaskRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(5)
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
    public static var interruptFlagRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x22)
        }
        set {
            _volatileRegisterWriteUInt8(0x22, newValue)
        }
    }
    /// ICF1 – Input Capture Flag 1 
    ///
    /// This flag is set when a capture event occurs on the ICPn pin. When the Input Capture Register (ICRn) is set by
    /// the WGM to be used as the TOP value, the ICFn Flag is set when the counter reaches the TOP value.
    /// ICFn is automatically cleared when the Input Capture Interrupt Vector is executed. Alternatively, ICFn can be
    /// cleared by writing a logic one to its bit location.
    @inlinable
    @inline(__always)
    public static var inputCaptureFlag: Bool {
        get {
            let flag = (interruptFlagRegister & 0b00100000) >> UInt8(5)
            return flag == 1
        }
        set {
            interruptFlagRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(5)
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
    public static var controlRegisterB: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x8A)
        }
        set {
            _volatileRegisterWriteUInt8(0x8A, newValue)
        }
    }
    /// ICNC1 – Input Capture 1 Noise Canceler 
    ///
    /// Setting this bit (to true) activates the Input Capture Noise Canceler. When the noise canceler is activated, the
    /// input from the Input Capture pin (ICPn) is filtered. The filter function requires four successive equal valued
    /// samples of the ICPn pin for changing its output. The Input Capture is therefore delayed by four Oscillator cycles
    /// when the noise canceler is enabled.
    @inlinable
    @inline(__always)
    public static var inputCaptureNoiseCanceler: Bool {
        get {
            let flag = (controlRegisterB & 0b10000000) >> UInt8(7)
            return flag == 1
        }
        set {
            controlRegisterB |= (newValue ? 1 : 0) & 0b00000001 << UInt8(7)
        }
    }
    /// ICES1 – Input Capture 1 Edge Select 
    ///
    /// This bit selects which edge on the Input Capture pin (ICPn) that is used to trigger a capture event. When the
    /// ICESn bit is written to zero, a falling (negative) edge is used as trigger, and when the ICESn bit is written to one,
    /// a rising (positive) edge will trigger the capture.
    /// When a capture is triggered according to the ICESn setting, the counter value is copied into the Input Capture
    /// Register (ICRn). The event will also set the Input Capture Flag (ICFn), and this can be used to cause an Input
    /// Capture Interrupt, if this interrupt is enabled.
    /// When the ICRn is used as TOP value (see description of the WGM bits located in the TCCRnA and the
    /// TCCRnB Register), the ICPn is disconnected and consequently the Input Capture function is disabled.
    @inlinable
    @inline(__always)
    public static var inputCaptureEdgeSelect: Bool {
        get {
            let flag = (controlRegisterB & 0b01000000) >> UInt8(6)
            return flag == 1
        }
        set {
            controlRegisterB |= (newValue ? 1 : 0) & 0b00000001 << UInt8(6)
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
    /// TCNT1 – Timer/Counter1 Bytes
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x5A)       |TCNT17 |TCNT16 |TCNT15 |TCNT14 |TCNT13 |TCNT12 |TCNT11 |TCNT10 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var count: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x5A)
        }
        set {
            _volatileRegisterWriteUInt8(0x5A, newValue)
        }
    }
    /// TCNT1 – Timer/Counter 1 bits 
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
    /// ICR1 – Timer/Counter1 Input Capture Register Bytes
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x8C)       | ICR17 | ICR16 | ICR15 | ICR14 | ICR13 | ICR12 | ICR11 | ICR10 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var inputCaptureRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x8C)
        }
        set {
            _volatileRegisterWriteUInt8(0x8C, newValue)
        }
    }
    /// ICR1 – Timer/Counter1 Input Capture bits 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (inputCaptureRegister & 0b11111111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            inputCaptureRegister |= (newValue.rawValue & 0b11111111) << UInt8(0)
        }
    }
}