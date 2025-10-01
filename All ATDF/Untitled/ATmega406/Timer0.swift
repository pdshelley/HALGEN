public struct Timer0: Timer8Bit, HasExternalClock {
    /// TCCR0A – timerCounterControlRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x44)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x44)
        }
        set {
            _volatileRegisterWriteUInt8(0x44, newValue)
        }
    }
    /// TCCR0B – timerCounterControlRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x45)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterControlRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x45)
        }
        set {
            _volatileRegisterWriteUInt8(0x45, newValue)
        }
    }
    /// TCNT0 – timerCounter
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x46)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounter: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x46)
        }
        set {
            _volatileRegisterWriteUInt8(0x46, newValue)
        }
    }
    /// OCR0A – outputcompareRegisterA
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x47)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var outputcompareRegisterA: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x47)
        }
        set {
            _volatileRegisterWriteUInt8(0x47, newValue)
        }
    }
    /// OCR0B – outputcompareRegisterB
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x48)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var outputcompareRegisterB: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x48)
        }
        set {
            _volatileRegisterWriteUInt8(0x48, newValue)
        }
    }
    /// TIMSK0 – timerCounterInterruptMaskRegister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x6E)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptMaskRegister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x6E)
        }
        set {
            _volatileRegisterWriteUInt8(0x6E, newValue)
        }
    }
    /// TIFR0 – timerCounterInterruptFlagregister
    ///```
    ///| Bit          |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
    ///|--------------|-------|-------|-------|-------|-------|-------|-------|-------|
    ///| (0x35)       | COM0A1| COM0A0| COM0B1| COM0B0|   -   |   -   | WGM01 | WGM00 |
    ///| Read/Write   |  R/W  |  R/W  |  R/W  |  R/W  |   R   |   R   |  R/W  |  R/W  |
    ///| InitialValue |   0   |   0   |   0   |   0   |   0   |   0   |   0   |   0   |
    ///```
    static var timerCounterInterruptFlagregister: UInt8 {
        get {
            _volatileRegisterReadUInt8(0x35)
        }
        set {
            _volatileRegisterWriteUInt8(0x35, newValue)
        }
    }
}