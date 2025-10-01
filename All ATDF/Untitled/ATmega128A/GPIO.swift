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

    public enum PORTE: Port {

        /// AKA: PORTE. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTE for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x23) } set { _volatileRegisterWriteUInt8(0x23, newValue) } }

        /// AKA: DDRE. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x22) } set { _volatileRegisterWriteUInt8(0x22, newValue) } }

        /// AKA: PINE. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x21) } set { _volatileRegisterWriteUInt8(0x21, newValue) } }
    }

    public enum PORTF: Port {

        /// AKA: PORTF. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTF for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x62) } set { _volatileRegisterWriteUInt8(0x62, newValue) } }

        /// AKA: DDRF. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x61) } set { _volatileRegisterWriteUInt8(0x61, newValue) } }

        /// AKA: PINF. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x20) } set { _volatileRegisterWriteUInt8(0x20, newValue) } }
    }

    public enum PORTG: Port {

        /// AKA: PORTG. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTG for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x65) } set { _volatileRegisterWriteUInt8(0x65, newValue) } }

        /// AKA: DDRG. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x64) } set { _volatileRegisterWriteUInt8(0x64, newValue) } }

        /// AKA: PING. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x63) } set { _volatileRegisterWriteUInt8(0x63, newValue) } }
    }

    /// PortA
    public typealias pa0 = DigitalPin<PORTA,Bit0>
    public typealias pa1 = DigitalPin<PORTA,Bit1>
    public typealias pa2 = DigitalPin<PORTA,Bit2>
    public typealias pa3 = DigitalPin<PORTA,Bit3>
    public typealias pa4 = DigitalPin<PORTA,Bit4>
    public typealias pa5 = DigitalPin<PORTA,Bit5>
    public typealias pa6 = DigitalPin<PORTA,Bit6>
    public typealias pa7 = DigitalPin<PORTA,Bit7>

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
    public typealias pc0 = DigitalPin<PORTC,Bit0>
    public typealias pc1 = DigitalPin<PORTC,Bit1>
    public typealias pc2 = DigitalPin<PORTC,Bit2>
    public typealias pc3 = DigitalPin<PORTC,Bit3>
    public typealias pc4 = DigitalPin<PORTC,Bit4>
    public typealias pc5 = DigitalPin<PORTC,Bit5>
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
    public typealias pe0 = DigitalPin<PORTE,Bit0>
    public typealias pe1 = DigitalPin<PORTE,Bit1>
    public typealias pe2 = DigitalPin<PORTE,Bit2>
    public typealias pe3 = DigitalPin<PORTE,Bit3>
    public typealias pe4 = DigitalPin<PORTE,Bit4>
    public typealias pe5 = DigitalPin<PORTE,Bit5>
    public typealias pe6 = DigitalPin<PORTE,Bit6>
    public typealias pe7 = DigitalPin<PORTE,Bit7>

    /// PortF
    public typealias pf0 = DigitalPin<PORTF,Bit0>
    public typealias pf1 = DigitalPin<PORTF,Bit1>
    public typealias pf2 = DigitalPin<PORTF,Bit2>
    public typealias pf3 = DigitalPin<PORTF,Bit3>
    public typealias pf4 = DigitalPin<PORTF,Bit4>
    public typealias pf5 = DigitalPin<PORTF,Bit5>
    public typealias pf6 = DigitalPin<PORTF,Bit6>
    public typealias pf7 = DigitalPin<PORTF,Bit7>

    /// PortG
    public typealias pg0 = DigitalPin<PORTG,Bit0>
    public typealias pg1 = DigitalPin<PORTG,Bit1>
    public typealias pg2 = DigitalPin<PORTG,Bit2>
    public typealias pg3 = DigitalPin<PORTG,Bit3>
    public typealias pg4 = DigitalPin<PORTG,Bit4>


}