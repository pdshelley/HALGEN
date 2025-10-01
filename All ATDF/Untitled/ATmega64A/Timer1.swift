public struct Timer1: Timer8Bit, HasExternalClock {
    /// TIMSK – timerCounterInterruptMaskRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x57)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptMaskRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x57)
        }
        set {
            _volatileRegisterWriteUInt16(0x57, newValue)
        }
    }
    /// ETIMSK – extendedTimerCounterInterruptMaskRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x7D)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var extendedTimerCounterInterruptMaskRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x7D)
        }
        set {
            _volatileRegisterWriteUInt16(0x7D, newValue)
        }
    }
    /// TIFR – timerCounterInterruptFlagregister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x56)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptFlagregister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x56)
        }
        set {
            _volatileRegisterWriteUInt16(0x56, newValue)
        }
    }
    /// ETIFR – extendedTimerCounterInterruptFlagregister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x7C)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var extendedTimerCounterInterruptFlagregister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x7C)
        }
        set {
            _volatileRegisterWriteUInt16(0x7C, newValue)
        }
    }
    /// SFIOR – specialFunctionIORegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x40)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var specialFunctionIORegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x40)
        }
        set {
            _volatileRegisterWriteUInt16(0x40, newValue)
        }
    }
    /// TCCR1A – timerCounterControlRegisterA
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x4F)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x4F)
        }
        set {
            _volatileRegisterWriteUInt16(0x4F, newValue)
        }
    }
    /// TCCR1B – timerCounterControlRegisterB
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x4E)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x4E)
        }
        set {
            _volatileRegisterWriteUInt16(0x4E, newValue)
        }
    }
    /// TCCR1C – timerCounterControlRegisterC
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x7A)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterC: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x7A)
        }
        set {
            _volatileRegisterWriteUInt16(0x7A, newValue)
        }
    }
    /// TCNT1 – timerCounterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x4C)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x4C)
        }
        set {
            _volatileRegisterWriteUInt16(0x4C, newValue)
        }
    }
    /// OCR1A – timerCounterOutputCompareRegisterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x4A)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x4A)
        }
        set {
            _volatileRegisterWriteUInt16(0x4A, newValue)
        }
    }
    /// OCR1B – timerCounterOutputCompareRegisterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x48)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x48)
        }
        set {
            _volatileRegisterWriteUInt16(0x48, newValue)
        }
    }
    /// OCR1C – timerCounterOutputCompareRegisterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x78)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x78)
        }
        set {
            _volatileRegisterWriteUInt16(0x78, newValue)
        }
    }
    /// ICR1 – timerCounterInputCaptureRegisterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x46)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInputCaptureRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x46)
        }
        set {
            _volatileRegisterWriteUInt16(0x46, newValue)
        }
    }
    /// ETIMSK – extendedTimerCounterInterruptMaskRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x7D)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var extendedTimerCounterInterruptMaskRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x7D)
        }
        set {
            _volatileRegisterWriteUInt16(0x7D, newValue)
        }
    }
    /// ETIFR – extendedTimerCounterInterruptFlagregister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x7C)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var extendedTimerCounterInterruptFlagregister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x7C)
        }
        set {
            _volatileRegisterWriteUInt16(0x7C, newValue)
        }
    }
    /// SFIOR – specialFunctionIORegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x40)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var specialFunctionIORegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x40)
        }
        set {
            _volatileRegisterWriteUInt16(0x40, newValue)
        }
    }
    /// TCCR3A – timerCounterControlRegisterA
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x8B)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterA: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x8B)
        }
        set {
            _volatileRegisterWriteUInt16(0x8B, newValue)
        }
    }
    /// TCCR3B – timerCounterControlRegisterB
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x8A)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterB: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x8A)
        }
        set {
            _volatileRegisterWriteUInt16(0x8A, newValue)
        }
    }
    /// TCCR3C – timerCounterControlRegisterC
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x8C)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegisterC: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x8C)
        }
        set {
            _volatileRegisterWriteUInt16(0x8C, newValue)
        }
    }
    /// TCNT3 – timerCounterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x88)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x88)
        }
        set {
            _volatileRegisterWriteUInt16(0x88, newValue)
        }
    }
    /// OCR3A – timerCounterOutputCompareRegisterABytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x86)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterABytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x86)
        }
        set {
            _volatileRegisterWriteUInt16(0x86, newValue)
        }
    }
    /// OCR3B – timerCounterOutputCompareRegisterBBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x84)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegisterBBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x84)
        }
        set {
            _volatileRegisterWriteUInt16(0x84, newValue)
        }
    }
    /// OCR3C – timerCounterOutputcompareRegisterCBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x82)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputcompareRegisterCBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x82)
        }
        set {
            _volatileRegisterWriteUInt16(0x82, newValue)
        }
    }
    /// ICR3 – timerCounterInputCaptureRegisterBytes
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x80)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInputCaptureRegisterBytes: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x80)
        }
        set {
            _volatileRegisterWriteUInt16(0x80, newValue)
        }
    }
}