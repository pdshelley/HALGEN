// Note: The ATMegaN8 comes in 4 different packages, a 28 pin DIP, a 28 pin QFN, a 32 pin QFP, and a 23 pin QFN. The two 32 pin chips have extra pins and thus have two extra ADC pins (ADC6 and ADC7).
// See ATMega328p Datasheet Figure 1-1.
public struct GPIO { // TODO: I think I want to rename this struct to AVR5 or something similar. This will probably be the HAL layer for the avr5 core and I'll make a wrapper with a common HAL API that wraps this.

    public enum PORTD: Port {

        /// AKA: PORTD. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTD for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x2B) } set { _volatileRegisterWriteUInt8(0x2B, newValue) } }

        /// AKA: DDRD. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x2A) } set { _volatileRegisterWriteUInt8(0x2A, newValue) } }

        /// AKA: PIND. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x29) } set { _volatileRegisterWriteUInt8(0x29, newValue) } }
    }

    public enum PORTB: Port {

        /// AKA: PORTB. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTB for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x25) } set { _volatileRegisterWriteUInt8(0x25, newValue) } }

        /// AKA: DDRB. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x24) } set { _volatileRegisterWriteUInt8(0x24, newValue) } }

        /// AKA: PINB. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x23) } set { _volatileRegisterWriteUInt8(0x23, newValue) } }
    }

    public enum PORTC: Port {

        /// AKA: PORTC. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTC for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x28) } set { _volatileRegisterWriteUInt8(0x28, newValue) } }

        /// AKA: DDRC. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x27) } set { _volatileRegisterWriteUInt8(0x27, newValue) } }

        /// AKA: PINC. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x26) } set { _volatileRegisterWriteUInt8(0x26, newValue) } }
    }

    public enum PORTE: Port {

        /// AKA: PORTE. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTE for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x2E) } set { _volatileRegisterWriteUInt8(0x2E, newValue) } }

        /// AKA: DDRE. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x2D) } set { _volatileRegisterWriteUInt8(0x2D, newValue) } }

        /// AKA: PINE. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x2C) } set { _volatileRegisterWriteUInt8(0x2C, newValue) } }
    }

    public enum PORTF: Port {

        /// AKA: PORTF. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTF for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x31) } set { _volatileRegisterWriteUInt8(0x31, newValue) } }

        /// AKA: DDRF. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x30) } set { _volatileRegisterWriteUInt8(0x30, newValue) } }

        /// AKA: PINF. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x2F) } set { _volatileRegisterWriteUInt8(0x2F, newValue) } }
    }

    /// PortB
    public typealias pb0 = DigitalPin<PORTB,Bit0>
    public typealias pb1 = DigitalPin<PORTB,Bit1>
    public typealias pb2 = DigitalPin<PORTB,Bit2>
    public typealias pb3 = DigitalPin<PORTB,Bit3>
    public typealias pb4 = DigitalPin<PORTB,Bit4>
    public typealias pb5 = DigitalPin<PORTB,Bit5>
    public typealias pb6 = DigitalPin<PORTB,Bit6>
    public typealias pb7 = DigitalPin<PORTB,Bit7>

    /// PortC
    public typealias pc6 = DigitalPin<PORTC,Bit6>
    public typealias pc7 = DigitalPin<PORTC,Bit7>

    /// PortD
    public typealias pd0 = DigitalPin<PORTD,Bit0>
    public typealias pd1 = DigitalPin<PORTD,Bit1>
    public typealias pd2 = DigitalPin<PORTD,Bit2>
    public typealias pd3 = DigitalPin<PORTD,Bit3>
    public typealias pd4 = DigitalPin<PORTD,Bit4>
    public typealias pd5 = DigitalPin<PORTD,Bit5>
    public typealias pd6 = DigitalPin<PORTD,Bit6>
    public typealias pd7 = DigitalPin<PORTD,Bit7>

    /// PortE
    public typealias pe2 = DigitalPin<PORTE,Bit2>
    public typealias pe6 = DigitalPin<PORTE,Bit6>

    /// PortF
    public typealias pf0 = DigitalPin<PORTF,Bit0>
    public typealias pf1 = DigitalPin<PORTF,Bit1>
    public typealias pf4 = DigitalPin<PORTF,Bit4>
    public typealias pf5 = DigitalPin<PORTF,Bit5>
    public typealias pf6 = DigitalPin<PORTF,Bit6>


}