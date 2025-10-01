public struct Timer1: Timer8Bit, HasExternalClock {
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
    /// OCR1AL – outputCompareRegisterALowbyte
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x88)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var outputCompareRegisterALowbyte: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x88)
        }
        set {
            _volatileRegisterWriteUInt16(0x88, newValue)
        }
    }
    /// OCR1AH – outputCompareRegisterAHighbyte
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x89)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var outputCompareRegisterAHighbyte: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x89)
        }
        set {
            _volatileRegisterWriteUInt16(0x89, newValue)
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
    /// TIFR1 – timerCounterInterruptFlagregister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x36)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptFlagregister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x36)
        }
        set {
            _volatileRegisterWriteUInt16(0x36, newValue)
        }
    }
    /// GTCCR – generalTimerCounterControlRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x43)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var generalTimerCounterControlRegister: UInt16 {
        get {
            _volatileRegisterReadUInt16(0x43)
        }
        set {
            _volatileRegisterWriteUInt16(0x43, newValue)
        }
    }
}