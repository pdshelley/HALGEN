// Note: The ATMegaN8 comes in 4 different packages, a 28 pin DIP, a 28 pin QFN, a 32 pin QFP, and a 23 pin QFN. The two 32 pin chips have extra pins and thus have two extra ADC pins (ADC6 and ADC7).
// See ATMega328p Datasheet Figure 1-1.
public struct GPIO { // TODO: I think I want to rename this struct to AVR5 or something similar. This will probably be the HAL layer for the avr5 core and I'll make a wrapper with a common HAL API that wraps this.

    public enum PORT: Port {    }

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

    /// PortF
    public typealias pf0 = DigitalPin<PORTF,Bit0>
    public typealias pf1 = DigitalPin<PORTF,Bit1>
    public typealias pf2 = DigitalPin<PORTF,Bit2>
    public typealias pf3 = DigitalPin<PORTF,Bit3>
    public typealias pf4 = DigitalPin<PORTF,Bit4>
    public typealias pf5 = DigitalPin<PORTF,Bit5>
    public typealias pf6 = DigitalPin<PORTF,Bit6>


}