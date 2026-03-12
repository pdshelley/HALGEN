// Note: The ATMegaN8 comes in 4 different packages, a 28 pin DIP, a 28 pin QFN, a 32 pin QFP, and a 23 pin QFN. The two 32 pin chips have extra pins and thus have two extra ADC pins (ADC6 and ADC7).
// See ATMega328p Datasheet Figure 1-1.
public struct GPIO { // TODO: I think I want to rename this struct to AVR5 or something similar. This will probably be the HAL layer for the avr5 core and I'll make a wrapper with a common HAL API that wraps this.

    public enum PORTB: Port {

        /// AKA: PORTB. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTB for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 {
            get {
                _volatileRegisterReadUInt8(0x25)
            }
            set {
                _volatileRegisterWriteUInt8(0x25, newValue)
            }
        }

        /// AKA: DDRB. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 {
            get {
                _volatileRegisterReadUInt8(0x24)
            }
            set {
                _volatileRegisterWriteUInt8(0x24, newValue)
            }
        }

        /// AKA: PINB. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 {
            get {
                _volatileRegisterReadUInt8(0x23)
            }
            set {
                _volatileRegisterWriteUInt8(0x23, newValue)
            }
        }
    }

    public enum PORTC: Port {

        /// AKA: PORTC. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTC for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 {
            get {
                _volatileRegisterReadUInt8(0x28)
            }
            set {
                _volatileRegisterWriteUInt8(0x28, newValue)
            }
        }

        /// AKA: DDRC. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 {
            get {
                _volatileRegisterReadUInt8(0x27)
            }
            set {
                _volatileRegisterWriteUInt8(0x27, newValue)
            }
        }

        /// AKA: PINC. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 {
            get {
                _volatileRegisterReadUInt8(0x26)
            }
            set {
                _volatileRegisterWriteUInt8(0x26, newValue)
            }
        }
    }

    public enum PORTD: Port {

        /// AKA: PORTD. See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        // Note: Should we make an alias for this named PORTD for people that want to have "Direct Access" to ports? This is more important for registers that are used for
        // multiple things but could maintain naming consistancy.
        @inlinable
        @inline(__always)
        public static var dataRegister: UInt8 {
            get {
                _volatileRegisterReadUInt8(0x2B)
            }
            set {
                _volatileRegisterWriteUInt8(0x2B, newValue)
            }
        }

        /// AKA: DDRD. See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var dataDirection: UInt8 {
            get {
                _volatileRegisterReadUInt8(0x2A)
            }
            set {
                _volatileRegisterWriteUInt8(0x2A, newValue)
            }
        }

        /// AKA: PIND. See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
        @inlinable
        @inline(__always)
        public static var inputAddress: UInt8 {
            get {
                _volatileRegisterReadUInt8(0x29)
            }
            set {
                _volatileRegisterWriteUInt8(0x29, newValue)
            }
        }
    }

    /// PORTB
    public typealias PB0 = DigitalPin<PORTB, Bit0>
    public typealias PB1 = DigitalPin<PORTB, Bit1>
    public typealias PB2 = DigitalPin<PORTB, Bit2>
    public typealias PB3 = DigitalPin<PORTB, Bit3>
    public typealias PB4 = DigitalPin<PORTB, Bit4>
    public typealias PB5 = DigitalPin<PORTB, Bit5>
    public typealias PB6 = DigitalPin<PORTB, Bit6>
    public typealias PB7 = DigitalPin<PORTB, Bit7>

    /// PORTC
    public typealias PC0 = DigitalPin<PORTC, Bit0>
    public typealias PC1 = DigitalPin<PORTC, Bit1>
    public typealias PC2 = DigitalPin<PORTC, Bit2>
    public typealias PC3 = DigitalPin<PORTC, Bit3>
    public typealias PC4 = DigitalPin<PORTC, Bit4>
    public typealias PC5 = DigitalPin<PORTC, Bit5>
    public typealias PC6 = DigitalPin<PORTC, Bit6>

    /// PORTD
    public typealias PD0 = DigitalPin<PORTD, Bit0>
    public typealias PD1 = DigitalPin<PORTD, Bit1>
    public typealias PD2 = DigitalPin<PORTD, Bit2>
    public typealias PD3 = DigitalPin<PORTD, Bit3>
    public typealias PD4 = DigitalPin<PORTD, Bit4>
    public typealias PD5 = DigitalPin<PORTD, Bit5>
    public typealias PD6 = DigitalPin<PORTD, Bit6>
    public typealias PD7 = DigitalPin<PORTD, Bit7>


}