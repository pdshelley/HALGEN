public struct Timer4: Timer8Bit, HasExternalClock {
    /// TCCR5A – timerCounterControlRegisterA
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x120)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x120)
        }
        set {
            _volatileRegisterWriteUInt16(0x120, newValue)
        }
    }
    /// TCCR5B – timerCounterControlRegisterB
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x121)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x121)
        }
        set {
            _volatileRegisterWriteUInt16(0x121, newValue)
        }
    }
    /// TCCR5C – timerCounterControlRegisterC
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x122)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterC: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x122)
        }
        set {
            _volatileRegisterWriteUInt16(0x122, newValue)
        }
    }
    /// TCNT5 – timerCounterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x124)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x124)
        }
        set {
            _volatileRegisterWriteUInt16(0x124, newValue)
        }
    }
    /// OCR5A – timerCounterOutputCompareRegisterABytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x128)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterABytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x128)
        }
        set {
            _volatileRegisterWriteUInt16(0x128, newValue)
        }
    }
    /// OCR5B – timerCounterOutputCompareRegisterBBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x12A)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterBBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x12A)
        }
        set {
            _volatileRegisterWriteUInt16(0x12A, newValue)
        }
    }
    /// OCR5C – timerCounterOutputCompareRegisterCBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x12C)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterCBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x12C)
        }
        set {
            _volatileRegisterWriteUInt16(0x12C, newValue)
        }
    }
    /// ICR5 – timerCounterInputCaptureRegisterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x126)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInputCaptureRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x126)
        }
        set {
            _volatileRegisterWriteUInt16(0x126, newValue)
        }
    }
    /// TIMSK5 – timerCounterInterruptMaskRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x73)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptMaskRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x73)
        }
        set {
            _volatileRegisterWriteUInt16(0x73, newValue)
        }
    }
    /// TIFR5 – timerCounterInterruptFlagRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x3A)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptFlagRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x3A)
        }
        set {
            _volatileRegisterWriteUInt16(0x3A, newValue)
        }
    }
    /// TCCR4A – timerCounterControlRegisterA
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0xA0)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0xA0)
        }
        set {
            _volatileRegisterWriteUInt16(0xA0, newValue)
        }
    }
    /// TCCR4B – timerCounterControlRegisterB
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0xA1)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0xA1)
        }
        set {
            _volatileRegisterWriteUInt16(0xA1, newValue)
        }
    }
    /// TCCR4C – timerCounterControlRegisterC
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0xA2)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterC: UInt16 {
        get {
            _volatileRegisterReadUInt16(0xA2)
        }
        set {
            _volatileRegisterWriteUInt16(0xA2, newValue)
        }
    }
    /// TCNT4 – timerCounterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0xA4)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0xA4)
        }
        set {
            _volatileRegisterWriteUInt16(0xA4, newValue)
        }
    }
    /// OCR4A – timerCounterOutputCompareRegisterABytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0xA8)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterABytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0xA8)
        }
        set {
            _volatileRegisterWriteUInt16(0xA8, newValue)
        }
    }
    /// OCR4B – timerCounterOutputCompareRegisterBBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0xAA)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterBBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0xAA)
        }
        set {
            _volatileRegisterWriteUInt16(0xAA, newValue)
        }
    }
    /// OCR4C – timerCounterOutputCompareRegisterCBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0xAC)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterCBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0xAC)
        }
        set {
            _volatileRegisterWriteUInt16(0xAC, newValue)
        }
    }
    /// ICR4 – timerCounterInputCaptureRegisterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0xA6)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInputCaptureRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0xA6)
        }
        set {
            _volatileRegisterWriteUInt16(0xA6, newValue)
        }
    }
    /// TIMSK4 – timerCounterInterruptMaskRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x72)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptMaskRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x72)
        }
        set {
            _volatileRegisterWriteUInt16(0x72, newValue)
        }
    }
    /// TIFR4 – timerCounterInterruptFlagRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x39)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptFlagRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x39)
        }
        set {
            _volatileRegisterWriteUInt16(0x39, newValue)
        }
    }
    /// TCCR3A – timerCounterControlRegisterA
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x90)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x90)
        }
        set {
            _volatileRegisterWriteUInt16(0x90, newValue)
        }
    }
    /// TCCR3B – timerCounterControlRegisterB
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x91)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x91)
        }
        set {
            _volatileRegisterWriteUInt16(0x91, newValue)
        }
    }
    /// TCCR3C – timerCounterControlRegisterC
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x92)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterC: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x92)
        }
        set {
            _volatileRegisterWriteUInt16(0x92, newValue)
        }
    }
    /// TCNT3 – timerCounterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x94)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x94)
        }
        set {
            _volatileRegisterWriteUInt16(0x94, newValue)
        }
    }
    /// OCR3A – timerCounterOutputCompareRegisterABytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x98)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterABytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x98)
        }
        set {
            _volatileRegisterWriteUInt16(0x98, newValue)
        }
    }
    /// OCR3B – timerCounterOutputCompareRegisterBBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x9A)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterBBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x9A)
        }
        set {
            _volatileRegisterWriteUInt16(0x9A, newValue)
        }
    }
    /// OCR3C – timerCounterOutputCompareRegisterCBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x9C)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterCBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x9C)
        }
        set {
            _volatileRegisterWriteUInt16(0x9C, newValue)
        }
    }
    /// ICR3 – timerCounterInputCaptureRegisterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x96)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInputCaptureRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x96)
        }
        set {
            _volatileRegisterWriteUInt16(0x96, newValue)
        }
    }
    /// TIMSK3 – timerCounterInterruptMaskRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x71)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptMaskRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x71)
        }
        set {
            _volatileRegisterWriteUInt16(0x71, newValue)
        }
    }
    /// TIFR3 – timerCounterInterruptFlagRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x38)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptFlagRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x38)
        }
        set {
            _volatileRegisterWriteUInt16(0x38, newValue)
        }
    }
    /// TCCR1A – timerCounterControlRegisterA
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x80)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x80)
        }
        set {
            _volatileRegisterWriteUInt16(0x80, newValue)
        }
    }
    /// TCCR1B – timerCounterControlRegisterB
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x81)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x81)
        }
        set {
            _volatileRegisterWriteUInt16(0x81, newValue)
        }
    }
    /// TCCR1C – timerCounterControlRegisterC
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x82)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterC: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x82)
        }
        set {
            _volatileRegisterWriteUInt16(0x82, newValue)
        }
    }
    /// TCNT1 – timerCounterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x84)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x84)
        }
        set {
            _volatileRegisterWriteUInt16(0x84, newValue)
        }
    }
    /// OCR1A – timerCounterOutputCompareRegisterABytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x88)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterABytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x88)
        }
        set {
            _volatileRegisterWriteUInt16(0x88, newValue)
        }
    }
    /// OCR1B – timerCounterOutputCompareRegisterBBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x8A)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterBBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x8A)
        }
        set {
            _volatileRegisterWriteUInt16(0x8A, newValue)
        }
    }
    /// OCR1C – timerCounterOutputCompareRegisterCBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x8C)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterCBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x8C)
        }
        set {
            _volatileRegisterWriteUInt16(0x8C, newValue)
        }
    }
    /// ICR1 – timerCounterInputCaptureRegisterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x86)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInputCaptureRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x86)
        }
        set {
            _volatileRegisterWriteUInt16(0x86, newValue)
        }
    }
    /// TIMSK1 – timerCounterInterruptMaskRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x6F)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptMaskRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x6F)
        }
        set {
            _volatileRegisterWriteUInt16(0x6F, newValue)
        }
    }
    /// TIFR1 – timerCounterInterruptFlagRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x36)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptFlagRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x36)
        }
        set {
            _volatileRegisterWriteUInt16(0x36, newValue)
        }
    }
}