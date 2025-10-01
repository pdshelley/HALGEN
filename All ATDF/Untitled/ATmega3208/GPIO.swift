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

}