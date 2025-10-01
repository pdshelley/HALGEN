// Note: The ATMegaN8 comes in 4 different packages, a 28 pin DIP, a 28 pin QFN, a 32 pin QFP, and a 23 pin QFN. The two 32 pin chips have extra pins and thus have two extra ADC pins (ADC6 and ADC7).
// See ATMega328p Datasheet Figure 1-1.
public struct GPIO { // TODO: I think I want to rename this struct to AVR5 or something similar. This will probably be the HAL layer for the avr5 core and I'll make a wrapper with a common HAL API that wraps this.

    public enum PORTA: Port {

        /// AKA: PORTA. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTA for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x3B) } set { _volatileRegisterWriteUInt8(0x3B, newValue) } }

        /// AKA: DDRA. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x3A) } set { _volatileRegisterWriteUInt8(0x3A, newValue) } }

        /// AKA: PINA. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x39) } set { _volatileRegisterWriteUInt8(0x39, newValue) } }
    }

    public enum PORTB: Port {

        /// AKA: PORTB. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTB for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x38) } set { _volatileRegisterWriteUInt8(0x38, newValue) } }

        /// AKA: DDRB. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x37) } set { _volatileRegisterWriteUInt8(0x37, newValue) } }

        /// AKA: PINB. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x36) } set { _volatileRegisterWriteUInt8(0x36, newValue) } }
    }

    public enum PORTC: Port {

        /// AKA: PORTC. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTC for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x35) } set { _volatileRegisterWriteUInt8(0x35, newValue) } }

        /// AKA: DDRC. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x34) } set { _volatileRegisterWriteUInt8(0x34, newValue) } }

        /// AKA: PINC. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x33) } set { _volatileRegisterWriteUInt8(0x33, newValue) } }
    }

    public enum PORTD: Port {

        /// AKA: PORTD. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTD for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x32) } set { _volatileRegisterWriteUInt8(0x32, newValue) } }

        /// AKA: DDRD. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x31) } set { _volatileRegisterWriteUInt8(0x31, newValue) } }

        /// AKA: PIND. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x30) } set { _volatileRegisterWriteUInt8(0x30, newValue) } }
    }

    /// PortA

}