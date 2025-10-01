public struct Timer0: Timer8Bit, HasExternalClock {
    /// TCCR0 – timerCounterControlRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x53)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x53)
        }
        set {
            _volatileRegisterWriteUInt8(0x53, newValue)
        }
    }
    /// TCNT0 – timerCounterRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x52)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x52)
        }
        set {
            _volatileRegisterWriteUInt8(0x52, newValue)
        }
    }
    /// OCR0 – timerCounterOutputCompareRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x51)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterOutputCompareRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x51)
        }
        set {
            _volatileRegisterWriteUInt8(0x51, newValue)
        }
    }
    /// TIMSK – timerCounterInterruptMaskRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x59)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptMaskRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x59)
        }
        set {
            _volatileRegisterWriteUInt8(0x59, newValue)
        }
    }
    /// TIFR – timerCounterInterruptFlagregister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x58)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptFlagregister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x58)
        }
        set {
            _volatileRegisterWriteUInt8(0x58, newValue)
        }
    }
}