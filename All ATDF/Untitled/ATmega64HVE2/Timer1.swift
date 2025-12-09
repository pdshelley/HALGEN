//===----------------------------------------------------------------------===//
//
// Timer1.swift
// CoreAVR
//
// Created by Swift AVR Generator on 12/09/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer1 = Timer1

public struct Timer1: Timer16Bit {
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
    public static var controlRegisterB: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x81)
        }
        set {
            _volatileRegisterWriteUInt8(0x81, newValue)
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
    public static var controlRegisterA: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x80)
        }
        set {
            _volatileRegisterWriteUInt8(0x80, newValue)
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
    ///
    /// Setting this bit (to true) activates the Input Capture Noise Canceler. When the noise canceler is activated, the
    /// input from the Input Capture pin (ICPn) is filtered. The filter function requires four successive equal valued
    /// samples of the ICPn pin for changing its output. The Input Capture is therefore delayed by four Oscillator cycles
    /// when the noise canceler is enabled.
    @inlinable
    @inline(__always)
    public static var inputCaptureNoiseCanceler: Bool {
        get {
            let flag = (controlRegisterA & 0b00100000) >> UInt8(5)
            return flag == 1
        }
        set {
            controlRegisterA |= (newValue ? 1 : 0) & 0b00000001 << UInt8(5)
        }
    }
    /// ICES1 – Input Capture Edge Select 
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
            let flag = (controlRegisterA & 0b00010000) >> UInt8(4)
            return flag == 1
        }
        set {
            controlRegisterA |= (newValue ? 1 : 0) & 0b00000001 << UInt8(4)
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
    /// TCNT1 – Timer Counter 1  Bytes
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x84)       |                             TCNT1                             |
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
            atomic {
                _volatileRegisterReadUInt16(0x84)
            }
        }
        set {
            atomic {
                _volatileRegisterWriteUInt16(0x84, newValue)
            }
        }
    }
    /// OCR1A – Output Compare Register 1A
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x88)       |                             OCR1A                             |
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
            _volatileRegisterReadUInt8(0x88)
        }
        set {
            _volatileRegisterWriteUInt8(0x88, newValue)
        }
    }
    /// OCR1B – Output Compare Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x89)       |                             OCR1B                             |
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
            _volatileRegisterReadUInt8(0x89)
        }
        set {
            _volatileRegisterWriteUInt8(0x89, newValue)
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
    public static var interruptMaskRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x6F)
        }
        set {
            _volatileRegisterWriteUInt8(0x6F, newValue)
        }
    }
    /// ICIE1 – Timer/Counter n Input Capture Interrupt Enable 
    ///
    /// When this bit is written to one, and the I-flag in the Status Register is set (interrupts globally enabled), the
    /// Timer/Counter1 Input Capture interrupt is enabled. The corresponding Interrupt Vector (see “Interrupts” is executed
    /// when the ICFn Flag, located in TIFRn, is set.
    @inlinable
    @inline(__always)
    public static var inputCaptureInterruptEnable: Bool {
        get {
            let flag = (interruptMaskRegister & 0b00001000) >> UInt8(3)
            return flag == 1
        }
        set {
            interruptMaskRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(3)
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
    public static var interruptFlagRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x36)
        }
        set {
            _volatileRegisterWriteUInt8(0x36, newValue)
        }
    }
    /// ICF1 – Timer/Counter 1 Input Capture Flag 
    ///
    /// This flag is set when a capture event occurs on the ICPn pin. When the Input Capture Register (ICRn) is set by
    /// the WGM to be used as the TOP value, the ICFn Flag is set when the counter reaches the TOP value.
    /// ICFn is automatically cleared when the Input Capture Interrupt Vector is executed. Alternatively, ICFn can be
    /// cleared by writing a logic one to its bit location.
    @inlinable
    @inline(__always)
    public static var inputCaptureFlag: Bool {
        get {
            let flag = (interruptFlagRegister & 0b00001000) >> UInt8(3)
            return flag == 1
        }
        set {
            interruptFlagRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(3)
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
    public static var generalControlRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x43)
        }
        set {
            _volatileRegisterWriteUInt8(0x43, newValue)
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
    ///
    /// When this bit is one, Timer/Counter1 and Timer/Counter0 prescaler will be Reset. This bit is normally cleared
    /// immediately by hardware, except if the TSM bit is set. Note that Timer/Counter1 and Timer/Counter0 share the
    /// same prescaler and a reset of this prescaler will affect both timers.
    @inlinable
    @inline(__always)
    public static var prescalerResetSync: Bool {
        get {
            let flag = (generalControlRegister & 0b00000001) >> UInt8(0)
            return flag == 1
        }
        set {
            generalControlRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(0)
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
    public static var controlRegisterB: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x45)
        }
        set {
            _volatileRegisterWriteUInt8(0x45, newValue)
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
    public static var controlRegisterA: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x44)
        }
        set {
            _volatileRegisterWriteUInt8(0x44, newValue)
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
    ///
    /// Setting this bit (to true) activates the Input Capture Noise Canceler. When the noise canceler is activated, the
    /// input from the Input Capture pin (ICPn) is filtered. The filter function requires four successive equal valued
    /// samples of the ICPn pin for changing its output. The Input Capture is therefore delayed by four Oscillator cycles
    /// when the noise canceler is enabled.
    @inlinable
    @inline(__always)
    public static var inputCaptureNoiseCanceler: Bool {
        get {
            let flag = (controlRegisterA & 0b00100000) >> UInt8(5)
            return flag == 1
        }
        set {
            controlRegisterA |= (newValue ? 1 : 0) & 0b00000001 << UInt8(5)
        }
    }
    /// ICES0 – Input Capture Edge Select 
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
            let flag = (controlRegisterA & 0b00010000) >> UInt8(4)
            return flag == 1
        }
        set {
            controlRegisterA |= (newValue ? 1 : 0) & 0b00000001 << UInt8(4)
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
    /// WGM10 – Waveform Generation Mode 
    @inlinable
    @inline(__always)
    public static var : Timer16Bit. {
        get {
            let mode = ((controlRegisterA & 0b00000001) << 1) | (controlRegisterA & 0b00000001)
            return Timer16Bit.(rawValue: mode) ??
        }
        set {
            controlRegisterA |= ((newValue.rawValue & 0b00000001) << UInt8(0))
            controlRegisterA |= ((newValue.rawValue & 0b00000010) >> UInt8(1))
        }
    }
    /// TCNT0 – Timer Counter 0  Bytes
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x46)       |                             TCNT0                             |
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
            atomic {
                _volatileRegisterReadUInt16(0x46)
            }
        }
        set {
            atomic {
                _volatileRegisterWriteUInt16(0x46, newValue)
            }
        }
    }
    /// OCR0A – Output Compare Register 0A
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x48)       |                             OCR0A                             |
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
            _volatileRegisterReadUInt8(0x48)
        }
        set {
            _volatileRegisterWriteUInt8(0x48, newValue)
        }
    }
    /// OCR0B – Output Compare Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x49)       |                             OCR0B                             |
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
            _volatileRegisterReadUInt8(0x49)
        }
        set {
            _volatileRegisterWriteUInt8(0x49, newValue)
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
    public static var interruptMaskRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x6E)
        }
        set {
            _volatileRegisterWriteUInt8(0x6E, newValue)
        }
    }
    /// ICIE0 – Timer/Counter n Input Capture Interrupt Enable 
    ///
    /// When this bit is written to one, and the I-flag in the Status Register is set (interrupts globally enabled), the
    /// Timer/Counter1 Input Capture interrupt is enabled. The corresponding Interrupt Vector (see “Interrupts” is executed
    /// when the ICFn Flag, located in TIFRn, is set.
    @inlinable
    @inline(__always)
    public static var inputCaptureInterruptEnable: Bool {
        get {
            let flag = (interruptMaskRegister & 0b00001000) >> UInt8(3)
            return flag == 1
        }
        set {
            interruptMaskRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(3)
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
    public static var interruptFlagRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x35)
        }
        set {
            _volatileRegisterWriteUInt8(0x35, newValue)
        }
    }
    /// ICF0 – Timer/Counter 0 Input Capture Flag 
    ///
    /// This flag is set when a capture event occurs on the ICPn pin. When the Input Capture Register (ICRn) is set by
    /// the WGM to be used as the TOP value, the ICFn Flag is set when the counter reaches the TOP value.
    /// ICFn is automatically cleared when the Input Capture Interrupt Vector is executed. Alternatively, ICFn can be
    /// cleared by writing a logic one to its bit location.
    @inlinable
    @inline(__always)
    public static var inputCaptureFlag: Bool {
        get {
            let flag = (interruptFlagRegister & 0b00001000) >> UInt8(3)
            return flag == 1
        }
        set {
            interruptFlagRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(3)
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
    public static var generalControlRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x43)
        }
        set {
            _volatileRegisterWriteUInt8(0x43, newValue)
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
    ///
    /// When this bit is one, Timer/Counter1 and Timer/Counter0 prescaler will be Reset. This bit is normally cleared
    /// immediately by hardware, except if the TSM bit is set. Note that Timer/Counter1 and Timer/Counter0 share the
    /// same prescaler and a reset of this prescaler will affect both timers.
    @inlinable
    @inline(__always)
    public static var prescalerResetSync: Bool {
        get {
            let flag = (generalControlRegister & 0b00000001) >> UInt8(0)
            return flag == 1
        }
        set {
            generalControlRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(0)
        }
    }
}