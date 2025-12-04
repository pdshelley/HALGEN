//===----------------------------------------------------------------------===//
//
// Timer4.swift
// CoreAVR
//
// Created by Swift AVR Generator on 12/04/2025.
// Copyright © 2025 Paul Shelley. All rights reserved.
//
//===----------------------------------------------------------------------===//


public typealias timer4 = Timer4

public struct Timer4: Timer10Bit {
    /// TCCR4A – Timer/Counter4 Control Register A
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xC0)       |COM4A1 |COM4A0 |COM4B1 |COM4B0 | FOC4A | FOC4B | PWM4A | PWM4B |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var controlRegisterA:  {
        get {
            _volatileRegisterRead(0xC0)
        }
        set {
            _volatileRegisterWrite(0xC0, newValue)
        }
    }
    /// COM4A – Compare Output Mode 1A, bits 
    ///
    /// These bits control the Output Compare pin (OC2A) behavior. If one or both of the COM2A1:0 bits are set, the
    /// OC2A output overrides the normal port functionality of the I/O pin it is connected to. However, note that the Data
    /// Direction Register (DDR) bit corresponding to the OC2A pin must be set in order to enable the output driver.
    /// When OC2A is connected to the pin, the function of the COM2A1:0 bits depends on the WGM22:0 bit setting.
    /// Table 1 shows the COM2A1:0 bit functionality when the WGM22:0 bits are set to a normal or CTC mode
    /// (non-PWM).
    ///
    /// Table 1. Compare Output Mode, non-PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2A1| COM2A0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC0A disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Toggle OC2A on Compare Match                                     |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2A on Compare Match                                      |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2A on Compare Match                                        |
    ///---------------------------------------------------------------------------------------------
    ///```
    ///
    /// Table 2 shows the COM2A1:0 bit functionality when the WGM21:0 bits are set to fast PWM mode.
    ///
    /// Table 2. Compare Output Mode, Fast PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2A1| COM2A0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2A disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | WGM22 = 0: Normal Port Operation, OC0A Disconnected.             |
    ///|        |       |       | WGM22 = 1: Toggle OC2A on Compare Match.                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2A on Compare Match, set OC2A at BOTTOM,                 |
    ///|        |       |       | (non-inverting mode).                                            |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2A on Compare Match, clear OC2A at BOTTOM,                 |
    ///|        |       |       | (inverting mode).                                                |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2A equals TOP and COM2A1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at BOTTOM. See ”Fast PWM Mode” in datasheet  for more details.
    ///
    /// Table 3 shows the COM2A1:0 bit functionality when the WGM22:0 bits are set to phase correct PWM mode.
    ///
    /// Table 3. Compare Output Mode, Phase Correct PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2A1| COM2A0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2A disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | WGM22 = 0: Normal Port Operation, OC0A Disconnected.             |
    ///|        |       |       | WGM22 = 1: Toggle OC2A on Compare Match.                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2A on Compare Match when up-counting.                    |
    ///|        |       |       | Set OC2A on Compare Match when down-counting.                    |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2A on Compare Match when up-counting.                      |
    ///|        |       |       | Clear OC2A on Compare Match when down-counting.                  |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2A equals TOP and COM2A1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at TOP. See ”Phase Correct PWM Mode” in datasheet for more details.
    ///
    @inlinable
    @inline(__always)
    public static var compareOutputModeA: Timer.CompareOutputMode {
        get {
            let mode = (controlRegisterA & 0b11000000) >> UInt8(6)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(6)
        }
    }
    /// COM4B – Compare Output Mode 4B, bits 
    /// See ATMega328p Datasheet Table 18-5, Table 18-6, and Table 18-7.
    ///
    /// These bits control the Output Compare pin (OC2B) behavior. If one or both of the COM2B1:0 bits are set, the
    /// OC2B output overrides the normal port functionality of the I/O pin it is connected to. However, note that the Data
    /// Direction Register (DDR) bit corresponding to the OC2B pin must be set in order to enable the output driver.
    /// When OC2B is connected to the pin, the function of the COM2B1:0 bits depends on the WGM22:0 bit setting.
    /// Table 18-5 shows the COM2B1:0 bit functionality when the WGM22:0 bits are set to a normal or CTC mode
    /// (non-PWM).
    ///
    /// Table 18-5. Compare Output Mode, non-PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2B1| COM2B0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC0B disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Toggle OC2B on Compare Match                                     |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2B on Compare Match                                      |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2B on Compare Match                                        |
    ///---------------------------------------------------------------------------------------------
    ///```
    ///
    /// Table 18-6 shows the COM2B1:0 bit functionality when the WGM22:0 bits are set to fast PWM mode.
    ///
    /// Table 18-6. Compare Output Mode, Fast PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2B1| COM2B0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2B disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Reserved                                                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2B on Compare Match, set OC2B at BOTTOM,                 |
    ///|        |       |       | (non-inverting mode).                                            |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2B on Compare Match, clear OC2B at BOTTOM,                 |
    ///|        |       |       | (inverting mode).                                                |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2B equals TOP and COM2B1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at BOTTOM. See ”Phase Correct PWM Mode” on page 157 for more
    ///       details.
    ///
    /// Table 18-7 shows the COM2B1:0 bit functionality when the WGM22:0 bits are set to phase correct PWM mode.
    ///
    /// Table 18-7. Compare Output Mode, Phase Correct PWM Mode
    ///```
    ///---------------------------------------------------------------------------------------------
    ///|  Mode  | COM2B1| COM2B0| Description                                                      |
    ///---------------------------------------------------------------------------------------------
    ///| normal |   0   |   0   | Normal port operation, OC2B disconnected.                        |
    ///---------------------------------------------------------------------------------------------
    ///| toggle |   0   |   1   | Reserved                                                         |
    ///---------------------------------------------------------------------------------------------
    ///| clear  |   1   |   0   | Clear OC2B on Compare Match when up-counting.                    |
    ///|        |       |       | Set OC2B on Compare Match when down-counting.                    |
    ///---------------------------------------------------------------------------------------------
    ///| set    |   1   |   1   | Set OC2B on Compare Match when up-counting.                      |
    ///|        |       |       | Clear OC2B on Compare Match when down-counting.                  |
    ///---------------------------------------------------------------------------------------------
    ///```
    /// Note: 1. A special case occurs when OCR2B equals TOP and COM2B1 is set. In this case, the Compare Match is
    ///       ignored, but the set or clear is done at TOP. See ”Phase Correct PWM Mode” on page 157 for more details.
    ///
    @inlinable
    @inline(__always)
    public static var compareOutputModeB: Timer.CompareOutputMode {
        get {
            let mode = (controlRegisterA & 0b00110000) >> UInt8(4)
            return Timer.CompareOutputMode.init(rawValue: mode) ?? .normal
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000011) << UInt8(4)
        }
    }
    /// FOC4A – Force Output Compare Match 4A 
    ///
    /// The FOC2A bit is only active when the WGM bits specify a non-PWM mode.
    /// However, for ensuring compatibility with future devices, this bit must be set to zero when TCCR2B is written
    /// when operating in PWM mode. When writing a logical one to the FOC2A bit, an immediate Compare Match is
    /// forced on the Waveform Generation unit. The OC2A output is changed according to its COM2A1:0 bits setting.
    /// Note that the FOC2A bit is implemented as a strobe. Therefore it is the value present in the COM2A1:0 bits that
    /// determines the effect of the forced compare.
    /// A FOC2A strobe will not generate any interrupt, nor will it clear the timer in CTC mode using OCR2A as TOP.
    /// The FOC2A bit is always read as zero.
    @inlinable
    @inline(__always)
    public static var forceOutputCompareA: Bool {
        get {
            let flag = (controlRegisterA & 0b00001000) >> UInt8(3)
            return flag == 1
        }
        set {
            controlRegisterA |= (newValue ? 1 : 0) & 0b00000001 << UInt8(3)
        }
    }
    /// FOC4B – Force Output Compare Match 4B 
    ///
    /// The FOC2B bit is only active when the WGM bits specify a non-PWM mode.
    /// However, for ensuring compatibility with future devices, this bit must be set to zero when TCCR2B is written
    /// when operating in PWM mode. When writing a logical one to the FOC2B bit, an immediate Compare Match is
    /// forced on the Waveform Generation unit. The OC2B output is changed according to its COM2B1:0 bits setting.
    /// Note that the FOC2B bit is implemented as a strobe. Therefore it is the value present in the COM2B1:0 bits that
    /// determines the effect of the forced compare.
    /// A FOC2B strobe will not generate any interrupt, nor will it clear the timer in CTC mode using OCR2B as TOP.
    /// The FOC2B bit is always read as zero.
    @inlinable
    @inline(__always)
    public static var forceOutputCompareB: Bool {
        get {
            let flag = (controlRegisterA & 0b00000100) >> UInt8(2)
            return flag == 1
        }
        set {
            controlRegisterA |= (newValue ? 1 : 0) & 0b00000001 << UInt8(2)
        }
    }
    /// PWM4A –  
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b00000010) >> UInt8(1)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(1)
        }
    }
    /// PWM4B –  
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterA & 0b00000001) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterA |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
    /// TCCR4B – Timer/Counter4 Control Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xC1)       | PWM4X | PSR4  |DTPS41 |DTPS40 | CS43  | CS42  | CS41  | CS40  |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var controlRegisterB:  {
        get {
            _volatileRegisterRead(0xC1)
        }
        set {
            _volatileRegisterWrite(0xC1, newValue)
        }
    }
    /// PWM4X – PWM Inversion Mode 
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
    /// PSR4 – Prescaler Reset Timer/Counter 4 
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
    /// DTPS4 – Dead Time Prescaler Bits 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (controlRegisterB & 0b00110000) >> UInt8(4)
            return .init(rawValue: mode) ??
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00000011) << UInt8(4)
        }
    }
    /// CS4 – Clock Select Bits 
    /// The three Clock Select bits select the clock source to be used by the Timer/Counter.
    @inlinable
    @inline(__always)
    public static var prescaler: Prescaling {
        get {
            let mode = (controlRegisterB & 0b00001111) >> UInt8(0)
            return Prescaling.init(rawValue: mode) ?? .stopped
        }
        set {
            controlRegisterB |= (newValue.rawValue & 0b00001111) << UInt8(0)
        }
    }
    /// TCCR4C – Timer/Counter 4 Control Register C
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xC2)       |COM4A1S|COM4A0S|COM4B1S|COM4B0S|COM4D1 |COM4D0 | FOC4D | PWM4D |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegisterC:  {
        get {
            _volatileRegisterRead(0xC2)
        }
        set {
            _volatileRegisterWrite(0xC2, newValue)
        }
    }
    /// COM4A1S – Comparator A Output Mode 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterC & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterC |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// COM4A0S – Comparator A Output Mode 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterC & 0b01000000) >> UInt8(6)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterC |= (newValue.rawValue & 0b00000001) << UInt8(6)
        }
    }
    /// COM4B1S – Comparator B Output Mode 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterC & 0b00100000) >> UInt8(5)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterC |= (newValue.rawValue & 0b00000001) << UInt8(5)
        }
    }
    /// COM4B0S – Comparator B Output Mode 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterC & 0b00010000) >> UInt8(4)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterC |= (newValue.rawValue & 0b00000001) << UInt8(4)
        }
    }
    /// COM4D – Comparator D Output Mode 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterC & 0b00001100) >> UInt8(2)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterC |= (newValue.rawValue & 0b00000011) << UInt8(2)
        }
    }
    /// FOC4D – Force Output Compare Match 4D 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterC & 0b00000010) >> UInt8(1)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterC |= (newValue.rawValue & 0b00000001) << UInt8(1)
        }
    }
    /// PWM4D – Pulse Width Modulator D Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterC & 0b00000001) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterC |= (newValue.rawValue & 0b00000001) << UInt8(0)
        }
    }
    /// TCCR4D – Timer/Counter 4 Control Register D
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xC3)       | FPIE4 | FPEN4 | FPNC4 | FPES4 | FPAC4 | FPF4  | WGM41 | WGM40 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegisterD:  {
        get {
            _volatileRegisterRead(0xC3)
        }
        set {
            _volatileRegisterWrite(0xC3, newValue)
        }
    }
    /// FPIE4 – Fault Protection Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterD & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterD |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// FPEN4 – Fault Protection Mode Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterD & 0b01000000) >> UInt8(6)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterD |= (newValue.rawValue & 0b00000001) << UInt8(6)
        }
    }
    /// FPNC4 – Fault Protection Noise Canceler 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterD & 0b00100000) >> UInt8(5)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterD |= (newValue.rawValue & 0b00000001) << UInt8(5)
        }
    }
    /// FPES4 – Fault Protection Edge Select 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterD & 0b00010000) >> UInt8(4)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterD |= (newValue.rawValue & 0b00000001) << UInt8(4)
        }
    }
    /// FPAC4 – Fault Protection Analog Comparator Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterD & 0b00001000) >> UInt8(3)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterD |= (newValue.rawValue & 0b00000001) << UInt8(3)
        }
    }
    /// FPF4 – Fault Protection Interrupt Flag 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterD & 0b00000100) >> UInt8(2)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterD |= (newValue.rawValue & 0b00000001) << UInt8(2)
        }
    }
    /// WGM0 – Waveform Generation Mode 
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
    public static var waveformGenerationMode: Timer10Bit.WaveformGenerationMode {
        get {
            let mode = ((timerCounterControlRegisterD & 0b00000011) << 2) | (controlRegisterA & 0b00000011)
            return Timer10Bit.WaveformGenerationMode(rawValue: mode) ?? .normal
        }
        set {
            controlRegisterA |= ((newValue.rawValue & 0b00000011) << UInt8(0))
            timerCounterControlRegisterD |= ((newValue.rawValue & 0b00001100) >> UInt8(2))
        }
    }
    /// TCCR4E – Timer/Counter 4 Control Register E
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xC4)       |TLOCK4 | ENHC4 |OC4OE5 |OC4OE4 |OC4OE3 |OC4OE2 |OC4OE1 |OC4OE0 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterControlRegisterE:  {
        get {
            _volatileRegisterRead(0xC4)
        }
        set {
            _volatileRegisterWrite(0xC4, newValue)
        }
    }
    /// TLOCK4 – Register Update Lock 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterE & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterE |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// ENHC4 – Enhanced Compare/PWM Mode 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterE & 0b01000000) >> UInt8(6)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterE |= (newValue.rawValue & 0b00000001) << UInt8(6)
        }
    }
    /// OC4OE – Output Compare Override Enable bit 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterControlRegisterE & 0b00111111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterControlRegisterE |= (newValue.rawValue & 0b00111111) << UInt8(0)
        }
    }
    /// TCNT4 – Timer/Counter4 Low Bytes
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xBE)       |                             TCNT4                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var count:  {
        get {
            _volatileRegisterRead(0xBE)
        }
        set {
            _volatileRegisterWrite(0xBE, newValue)
        }
    }
    /// TC4H – Timer/Counter4
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xBF)       |                             TC4H                              |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounter:  {
        get {
            _volatileRegisterRead(0xBF)
        }
        set {
            _volatileRegisterWrite(0xBF, newValue)
        }
    }
    /// OCR4A – Timer/Counter4 Output Compare Register A
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xCF)       |                             OCR4A                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterA:  {
        get {
            _volatileRegisterRead(0xCF)
        }
        set {
            _volatileRegisterWrite(0xCF, newValue)
        }
    }
    /// OCR4B – Timer/Counter4 Output Compare Register B
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xD0)       |                             OCR4B                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var outputCompareRegisterB:  {
        get {
            _volatileRegisterRead(0xD0)
        }
        set {
            _volatileRegisterWrite(0xD0, newValue)
        }
    }
    /// OCR4C – Timer/Counter4 Output Compare Register C
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xD1)       |                             OCR4C                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareRegisterC:  {
        get {
            _volatileRegisterRead(0xD1)
        }
        set {
            _volatileRegisterWrite(0xD1, newValue)
        }
    }
    /// OCR4D – Timer/Counter4 Output Compare Register D
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xD2)       |                             OCR4D                             |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterOutputCompareRegisterD:  {
        get {
            _volatileRegisterRead(0xD2)
        }
        set {
            _volatileRegisterWrite(0xD2, newValue)
        }
    }
    /// TIMSK4 – Timer/Counter4 Interrupt Mask Register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x72)       |OCIE4D |OCIE4A |OCIE4B |   -   |   -   | TOIE4 |   -   |   -   |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var interruptMaskRegister:  {
        get {
            _volatileRegisterRead(0x72)
        }
        set {
            _volatileRegisterWrite(0x72, newValue)
        }
    }
    /// OCIE4D – Timer/Counter4 Output Compare D Match Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (interruptMaskRegister & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            interruptMaskRegister |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// OCIE4A – Timer/Counter4 Output Compare A Match Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var outputCompareMatchAInterruptEnable: Bool {
        get {
            let flag = (interruptMaskRegister & 0b01000000) >> UInt8(6)
            return flag == 1
        }
        set {
            interruptMaskRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(6)
        }
    }
    /// OCIE4B – Timer/Counter4 Output Compare B Match Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var outputCompareMatchBInterruptEnable: Bool {
        get {
            let flag = (interruptMaskRegister & 0b00100000) >> UInt8(5)
            return flag == 1
        }
        set {
            interruptMaskRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(5)
        }
    }
    /// TOIE4 – Timer/Counter4 Overflow Interrupt Enable 
    @inlinable
    @inline(__always)
    public static var overflowInterruptEnable: Bool {
        get {
            let flag = (interruptMaskRegister & 0b00000100) >> UInt8(2)
            return flag == 1
        }
        set {
            interruptMaskRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(2)
        }
    }
    /// TIFR4 – Timer/Counter4 Interrupt Flag register
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0x39)       | OCF4D | OCF4A | OCF4B |   -   |   -   | TOV4  |   -   |   -   |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var interruptFlagRegister:  {
        get {
            _volatileRegisterRead(0x39)
        }
        set {
            _volatileRegisterWrite(0x39, newValue)
        }
    }
    /// OCF4D – Output Compare Flag 4D 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (interruptFlagRegister & 0b10000000) >> UInt8(7)
            return .init(rawValue: mode) ??
        }
        set {
            interruptFlagRegister |= (newValue.rawValue & 0b00000001) << UInt8(7)
        }
    }
    /// OCF4A – Output Compare Flag 4A 
    @inlinable
    @inline(__always)
    public static var outputCompareFlagA: Bool {
        get {
            let flag = (interruptFlagRegister & 0b01000000) >> UInt8(6)
            return flag == 1
        }
        set {
            interruptFlagRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(6)
        }
    }
    /// OCF4B – Output Compare Flag 4B 
    @inlinable
    @inline(__always)
    public static var outputCompareFlagB: Bool {
        get {
            let flag = (interruptFlagRegister & 0b00100000) >> UInt8(5)
            return flag == 1
        }
        set {
            interruptFlagRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(5)
        }
    }
    /// TOV4 – Timer/Counter4 Overflow Flag 
    @inlinable
    @inline(__always)
    public static var overflowFlag: Bool {
        get {
            let flag = (interruptFlagRegister & 0b00000100) >> UInt8(2)
            return flag == 1
        }
        set {
            interruptFlagRegister |= (newValue ? 1 : 0) & 0b00000001 << UInt8(2)
        }
    }
    /// DT4 – Timer/Counter 4 Dead Time Value
    ///```
    ///--------------------------------------------------------------------------------
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///--------------------------------------------------------------------------------
    ///| (0xD4)       | DT4L7 | DT4L6 | DT4L5 | DT4L4 | DT4L3 | DT4L2 | DT4L1 | DT4L0 |
    ///--------------------------------------------------------------------------------
    ///| Read/Write   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |   ?   |
    ///--------------------------------------------------------------------------------
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///--------------------------------------------------------------------------------
    ///```
    @inlinable
    @inline(__always)
    public static var timerCounterDeadTimeValue:  {
        get {
            _volatileRegisterRead(0xD4)
        }
        set {
            _volatileRegisterWrite(0xD4, newValue)
        }
    }
    /// DT4L – Timer/Counter 4 Dead Time Value Bits 
    @inlinable
    @inline(__always)
    public static var :  {
        get {
            let mode = (timerCounterDeadTimeValue & 0b11111111) >> UInt8(0)
            return .init(rawValue: mode) ??
        }
        set {
            timerCounterDeadTimeValue |= (newValue.rawValue & 0b11111111) << UInt8(0)
        }
    }
}