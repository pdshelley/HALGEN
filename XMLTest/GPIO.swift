//
//  GPIO.swift
//  XMLTest
//
//  Created by Paul Shelley on 7/2/23.
//

import Foundation


// TODO: Make A Generic Function where it can accept any array of anything, send it to a function that returns a string, and adds it to the middle.
func buildGPIO(file: AVRToolsDeviceFile) -> String {
    var code: String = """
    // Note: The ATMegaN8 comes in 4 different packages, a 28 pin DIP, a 28 pin QFN, a 32 pin QFP, and a 23 pin QFN. The two 32 pin chips have extra pins and thus have two extra ADC pins (ADC6 and ADC7).
    // See ATMega328p Datasheet Figure 1-1.
    struct GPIO { // TODO: I think I want to rename this struct to AVR5 or something similar. This will probably be the HAL layer for the avr5 core and I'll make a wrapper with a common HAL API that wraps this.
    """
    
    // Filter for Modules named "PORT" // TODO: Find a better way to filter.
    for module in file.modules.module {
        if module.name == .port {
            for registerGroup in module.registerGroup {
                code.append(buildPort(port: registerGroup))
            }
        }
    }
    
    code.append(buildPadsForPort(file: file))
    
    
//    for module in file.devices.device.peripherals.module {
//        if module.name == .port {
//            for instance in module.instance {
//                guard let signals = instance.signals else { break }
//                for signal in signals.signal {
//                    code.append(signal.pad.rawValue)
//                    listOfValues.append(signal.function.rawValue)
//                }
//            }
//        }
//    }
    
    code.append("""
    
    }
    """)
    
    return code
}

// TODO: Maybe make A Generic Function where it can accept any array of anything, send it to a function that returns a string, and adds it to the middle? Would need to account for line indentations
func buildPort(port: AVRToolsDeviceFile.Modules.Module.RegisterGroup) -> String {
    var code: String = """
    
    
        enum \(port.name.rawValue): Port {
    """
    
    for register in port.register {
        code.append(buildPortRegister(register: register))
    }
    
    code.append("""
        }
    """)
    
    return code
}

func buildPadsForPort(file: AVRToolsDeviceFile) -> String {
    var code: String = "\n\n"
    
    for module in file.devices.device.peripherals.module {
        if module.name == .port {
            
            for instance in module.instance {
                let portName = instance.name
                code.append("    /// \(portName)\n")
                guard let signal = instance.signals else { break }
                
                for signal in signal.signal {
                    guard let index = signal.index else { break }
                    code.append("    typealias \(signal.pad) = DigitalPin<\(portName.rawValue),Bit\(index.rawValue)>\n")
                }
                code.append("\n")
            }
        }
    }
//
//    for instance in module.instance {
//        guard let signals = instance.signals else { break }
//        for signal in signals.signal {
//            code.append("typealias \(signal.pad.rawValue.lowercased()) = DigitalPin<PortB,Bit7>\n") // TODO: Make this actually work
//            listOfValues.append(signal.function.rawValue)
//        }
//    }
    
    // Where file.modules.module.Name == .port
    // Or Where file.devices.device.Peripherals.module.name == .port
    // module.instance is an array of instances of all the ports on the chip
    // Each Instance has a Name that shouold be the port name, Instance also has a RegisterGroup.Name and RegisterGroup.NameInModule which BOTh should be the same as the Instance.Name?
    // Each Instance also has an array of Signals. Signal.Pad
    
    // for instance in module.instance { }
    
    
//
//    let port = AVRToolsDeviceFile.Modules.Module.RegisterGroup.Name // PORTB // .lowercased() portb // Make first and last letters uppercassed? or just hard code it?
//
//    let pad = AVRToolsDeviceFile.Devices.Device.Peripherals.Module.Instance.Signals.Signal.Pad // .rawValue .lowercased()
//
//    let index = AVRToolsDeviceFile.Modules.Module.RegisterGroup.Signals.Signal.Index
//
//    let text = "typealias \(pad) = DigitalPin<\(port),Bit\(index)>\n"
    
    return code
}

// TODO: implement 'size' Note: `UInt8` should be used when this is an 8 bit port. I believe that the `size` of 1 indicates 8 bit, and 2 would indicate 16 bit.
// TODO: implement 'initval' Note: This value is optional.
// TODO: implement 'caption' Note: This value is optional.
// TODO: implement 'mask' Note: This value is optional.
// TODO: implement 'ocdRW' Note: This value is optional.
// TODO: implement 'bitfield' Note: This value is an Array that might be empty.

// TODO: typealias pa0 = DigitalPin<PortA,Bit0>

func buildPortRegister(register: AVRToolsDeviceFile.Modules.Module.RegisterGroup.Register) -> String {
    switch register.name {
    case .PORTA, .PORTB, .PORTC, .PORTD, .PORTE, .PORTF, .PORTG, .PORTH, .PORTJ, .PORTK, .PORTL:
        let variableName = "dataRegister"
        return """
    
    
            /// AKA: \(register.name.rawValue). See ATMega328p Datasheet section 14.4.2. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
            // Note: Should we make an alias for this named \(register.name.rawValue) for people that want to have "Direct Access" to ports? This is more important for registers that are used for
            // multiple things but could maintain naming consistancy.
            @inlinable
            @inline(__always)
            static var \(variableName): UInt8 { get { _rawPointerRead(address: \(register.offset.rawValue)) } set { _rawPointerWrite(address: \(register.offset.rawValue), value: newValue) } }
    """
    case .DDRA, .DDRB, .DDRC, .DDRD, .DDRE, .DDRF, .DDRG, .DDRH, .DDRJ, .DDRK, .DDRL:
        let variableName = "dataDirection"
        return """
    
    
            /// AKA: \(register.name.rawValue). See ATMega328p Datasheet section 14.4.3. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
            @inlinable
            @inline(__always)
            static var \(variableName): UInt8 { get { _rawPointerRead(address: \(register.offset.rawValue)) } set { _rawPointerWrite(address: \(register.offset.rawValue), value: newValue) } }
    """
    case .PINA, .PINB, .PINC, .PIND, .PINE, .PINF, .PING, .PINH, .PINJ, .PINK, .PINL:
        let variableName = "inputAddress"
        return """
    
    
            /// AKA: \(register.name.rawValue). See ATMega328p Datasheet section 14.4.4. // TODO: How should we make the Datasheet refrence more generic? Include more of this documentation directly in the code?
            @inlinable
            @inline(__always)
            static var \(variableName): UInt8 { get { _rawPointerRead(address: \(register.offset.rawValue)) } set { _rawPointerWrite(address: \(register.offset.rawValue), value: newValue) } }\n
    """
    default:
        return ""
    }
}

// TODO:
// NOTE: I was thinking of using a protocol if possible for this. So a pin could conform to both the 'Analog' and 'Digital' protocols.
// noodling on combined pins...
//    struct DigitAndAnalogPin {
//        var digital: DigitalPin<Port> { }
//        var pwm: PWMPin<Timer>  {}
//        ... other functions? ...
//    }
//
//    /// See ATMega328p Datasheet section 14.4.2.
//    typealias pb0 = DigitalPin<PortB,Bit0> // PCINT0/CLKO/ICP1
//    typealias pb1 = DigitalPin<PortB,Bit1> // OC1A/PCINT1
//    typealias pb2 = DigitalPin<PortB,Bit2> // SS/OC1B/PCINT2
//    typealias pb3 = DigitalPin<PortB,Bit3> // MOSI/OC2A/PCINT3
//    typealias pb4 = DigitalPin<PortB,Bit4> // MISO/PCINT4
//    typealias pb5 = DigitalPin<PortB,Bit5> // SCK/PCINT5
//    typealias pb6 = DigitalPin<PortB,Bit6> // PCINT6/XTAL1/TOSC1
//    typealias pb7 = DigitalPin<PortB,Bit7> // PCINT7/XTAL2/TOSC2
//
//    /// See ATMega328p Datasheet section 14.4.5.
//    typealias pc0 = DigitalPin<PortC,Bit0> // ADC0/PCINT8
//    typealias pc1 = DigitalPin<PortC,Bit1> // ADC1/PCINT9
//    typealias pc2 = DigitalPin<PortC,Bit2> // ADC2/PCINT10
//    typealias pc3 = DigitalPin<PortC,Bit3> // ADC3/PCINT11
//    typealias pc4 = DigitalPin<PortC,Bit4> // ADC4/SDA/PCINT12
//    typealias pc5 = DigitalPin<PortC,Bit5> // ADC5/SCL/PCINT13
//    typealias pc6 = DigitalPin<PortC,Bit6> // PCINT14/RESET
//    // Note: Port C does not use the 7th bit. See the Datasheet 14.4.5.
//
//    /// See ATMega328p Datasheet section 14.4.8.
//    typealias pd0 = DigitalPin<PortD,Bit0> // PCINT16/RXD
//    typealias pd1 = DigitalPin<PortD,Bit1> // PCINT17/TXD
//    typealias pd2 = DigitalPin<PortD,Bit2> // PCINT18/INT0
//    typealias pd3 = DigitalPin<PortD,Bit3> // PCINT19/OC2B/INT1
//    typealias pd4 = DigitalPin<PortD,Bit4> // PCINT20/XCK/T0
//    typealias pd5 = DigitalPin<PortD,Bit5> // PCINT21/OC0B/T1
//    typealias pd6 = DigitalPin<PortD,Bit6> // PCINT22/OC0A/AIN0
//    typealias pd7 = DigitalPin<PortD,Bit7> // PCINT23/AIN1






//struct PinOuts {
//    // TODO: Physical Pins have more than one mode. We need a way to detect collisions as well as orginize the code with protocols or structs.
//    enum pdip28 {
//        typealias pin1 = pc6
//        typealias pin2 = pd0
//        typealias pin3 = pd1
//        typealias pin4 = pd2
//        typealias pin5 = pd3
//        typealias pin6 = pd4
//        // pin7 = VCC
//        // pin8 = GND
//        typealias pin9 = pb6
//        typealias pin10 = pb7
//        typealias pin11 = pd5
//        typealias pin12 = pd6
//        typealias pin13 = pd7
//        typealias pin14 = pb0
//
//        typealias pin15 = pb1
//        typealias pin16 = pb2
//        typealias pin17 = pb3
//        typealias pin18 = pb4
//        typealias pin19 = pb5
//        // pin20 AVCC
//        // pin21 AREF
//        // pin22 GND
//        typealias pin23 = pc0
//        typealias pin24 = pc1
//        typealias pin25 = pc2
//        typealias pin26 = pc3
//        typealias pin27 = pc4
//        typealias pin28 = pc5
//    }
//
//    enum mlf28 {
//        typealias pin1 = pd3
//        typealias pin2 = pd4
//        // pin3 = VCC
//        // pin4 = GND
//        typealias pin5 = pb6
//        typealias pin6 = pb7
//        typealias pin7 = pd5
//
//        typealias pin8 = pd6
//        typealias pin9 = pd7
//        typealias pin10 = pb0
//        typealias pin11 = pb1
//        typealias pin12 = pb2
//        typealias pin13 = pb3
//        typealias pin14 = pb4
//
//        typealias pin15 = pb5
//        // pin16 = AVCC
//        // pin17 = AREF
//        // pin18 = GND
//        typealias pin19 = pc0
//        typealias pin20 = pc1
//        typealias pin21 = pc2
//
//        typealias pin22 = pc3
//        typealias pin23 = pc4
//        typealias pin24 = pc5
//        typealias pin25 = pc6
//        typealias pin26 = pd0
//        typealias pin27 = pd1
//        typealias pin28 = pd2
//    }
//
//    enum tqfp32 {
//        typealias pin1 = pd3
//        typealias pin2 = pd4
//        // pin3 = VCC
//        // pin4 = GND
//        // pin5 = VCC
//        // pin6 = GND
//        typealias pin7 = pb6
//        typealias pin8 = pb7
//
//        typealias pin9 = pd5
//        typealias pin10 = pd6
//        typealias pin11 = pd7
//        typealias pin12 = pb0
//        typealias pin13 = pb1
//        typealias pin14 = pb2
//        typealias pin15 = pb3
//        typealias pin16 = pb4
//
//        typealias pin17 = pb5
//        // pin18 = AVCC
//        // pin19 = ADC6
//        // pin20 = AREF
//        // pin21 = GND
//        // pin22 = ADC7
//        typealias pin23 = pc0
//        typealias pin24 = pc1
//
//        typealias pin25 = pc2
//        typealias pin26 = pc3
//        typealias pin27 = pc4
//        typealias pin28 = pc5
//        typealias pin29 = pc6
//        typealias pin30 = pd0
//        typealias pin31 = pd1
//        typealias pin32 = pd2
//    }
//
//    enum mlf32 {
//        typealias pin1 = pd3
//        typealias pin2 = pd4
//        // pin3 = VCC
//        // pin4 = GND
//        // pin5 = VCC
//        // pin6 = GND
//        typealias pin7 = pb6
//        typealias pin8 = pb7
//
//        typealias pin9 = pd5
//        typealias pin10 = pd6
//        typealias pin11 = pd7
//        typealias pin12 = pb0
//        typealias pin13 = pb1
//        typealias pin14 = pb2
//        typealias pin15 = pb3
//        typealias pin16 = pb4
//
//        typealias pin17 = pb5
//        // pin18 = AVCC
//        // pin19 = ADC6
//        // pin20 = AREF
//        // pin21 = GND
//        // pin22 = ADC7
//        typealias pin23 = pc0
//        typealias pin24 = pc1
//
//        typealias pin25 = pc2
//        typealias pin26 = pc3
//        typealias pin27 = pc4
//        typealias pin28 = pc5
//        typealias pin29 = pc6
//        typealias pin30 = pd0
//        typealias pin31 = pd1
//        typealias pin32 = pd2
//    }
//}


