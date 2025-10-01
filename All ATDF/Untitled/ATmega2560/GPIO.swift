// Note: The ATMegaN8 comes in 4 different packages, a 28 pin DIP, a 28 pin QFN, a 32 pin QFP, and a 23 pin QFN. The two 32 pin chips have extra pins and thus have two extra ADC pins (ADC6 and ADC7).
// See ATMega328p Datasheet Figure 1-1.
public struct GPIO { // TODO: I think I want to rename this struct to AVR5 or something similar. This will probably be the HAL layer for the avr5 core and I'll make a wrapper with a common HAL API that wraps this.

    public enum PORTA: Port {

        /// AKA: PORTA. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTA for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x22) } set { _volatileRegisterWriteUInt8(0x22, newValue) } }

        /// AKA: DDRA. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x21) } set { _volatileRegisterWriteUInt8(0x21, newValue) } }

        /// AKA: PINA. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x20) } set { _volatileRegisterWriteUInt8(0x20, newValue) } }
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

    public enum PORTG: Port {

        /// AKA: PORTG. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTG for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x34) } set { _volatileRegisterWriteUInt8(0x34, newValue) } }

        /// AKA: DDRG. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x33) } set { _volatileRegisterWriteUInt8(0x33, newValue) } }

        /// AKA: PING. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x32) } set { _volatileRegisterWriteUInt8(0x32, newValue) } }
    }

    public enum PORTH: Port {

        /// AKA: PORTH. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTH for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x102) } set { _volatileRegisterWriteUInt8(0x102, newValue) } }

        /// AKA: DDRH. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x101) } set { _volatileRegisterWriteUInt8(0x101, newValue) } }

        /// AKA: PINH. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x100) } set { _volatileRegisterWriteUInt8(0x100, newValue) } }
    }

    public enum PORTJ: Port {

        /// AKA: PORTJ. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTJ for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x105) } set { _volatileRegisterWriteUInt8(0x105, newValue) } }

        /// AKA: DDRJ. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x104) } set { _volatileRegisterWriteUInt8(0x104, newValue) } }

        /// AKA: PINJ. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x103) } set { _volatileRegisterWriteUInt8(0x103, newValue) } }
    }

    public enum PORTK: Port {

        /// AKA: PORTK. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTK for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x108) } set { _volatileRegisterWriteUInt8(0x108, newValue) } }

        /// AKA: DDRK. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x107) } set { _volatileRegisterWriteUInt8(0x107, newValue) } }

        /// AKA: PINK. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x106) } set { _volatileRegisterWriteUInt8(0x106, newValue) } }
    }

    public enum PORTL: Port {

        /// AKA: PORTL. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTL for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 { get { _volatileRegisterReadUInt8(0x10B) } set { _volatileRegisterWriteUInt8(0x10B, newValue) } }

        /// AKA: DDRL. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 { get { _volatileRegisterReadUInt8(0x10A) } set { _volatileRegisterWriteUInt8(0x10A, newValue) } }

        /// AKA: PINL. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 { get { _volatileRegisterReadUInt8(0x109) } set { _volatileRegisterWriteUInt8(0x109, newValue) } }
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
    public typealias pg5 = DigitalPin<PORTG,Bit5>
    public typealias pg6 = DigitalPin<PORTG,Bit6>
    public typealias pg7 = DigitalPin<PORTG,Bit7>

    /// PortH
    public typealias ph0 = DigitalPin<PORTH,Bit0>
    public typealias ph1 = DigitalPin<PORTH,Bit1>
    public typealias ph2 = DigitalPin<PORTH,Bit2>
    public typealias ph3 = DigitalPin<PORTH,Bit3>
    public typealias ph4 = DigitalPin<PORTH,Bit4>
    public typealias ph5 = DigitalPin<PORTH,Bit5>
    public typealias ph6 = DigitalPin<PORTH,Bit6>
    public typealias ph7 = DigitalPin<PORTH,Bit7>

    /// PortJ
    public typealias pj0 = DigitalPin<PORTJ,Bit0>
    public typealias pj1 = DigitalPin<PORTJ,Bit1>
    public typealias pj2 = DigitalPin<PORTJ,Bit2>
    public typealias pj3 = DigitalPin<PORTJ,Bit3>
    public typealias pj4 = DigitalPin<PORTJ,Bit4>
    public typealias pj5 = DigitalPin<PORTJ,Bit5>
    public typealias pj6 = DigitalPin<PORTJ,Bit6>
    public typealias pj7 = DigitalPin<PORTJ,Bit7>

    /// PortK
    public typealias pk0 = DigitalPin<PORTK,Bit0>
    public typealias pk1 = DigitalPin<PORTK,Bit1>
    public typealias pk2 = DigitalPin<PORTK,Bit2>
    public typealias pk3 = DigitalPin<PORTK,Bit3>
    public typealias pk4 = DigitalPin<PORTK,Bit4>
    public typealias pk5 = DigitalPin<PORTK,Bit5>
    public typealias pk6 = DigitalPin<PORTK,Bit6>
    public typealias pk7 = DigitalPin<PORTK,Bit7>

    /// PortL
    public typealias pl0 = DigitalPin<PORTL,Bit0>
    public typealias pl1 = DigitalPin<PORTL,Bit1>
    public typealias pl2 = DigitalPin<PORTL,Bit2>
    public typealias pl3 = DigitalPin<PORTL,Bit3>
    public typealias pl4 = DigitalPin<PORTL,Bit4>
    public typealias pl5 = DigitalPin<PORTL,Bit5>
    public typealias pl6 = DigitalPin<PORTL,Bit6>
    public typealias pl7 = DigitalPin<PORTL,Bit7>


}