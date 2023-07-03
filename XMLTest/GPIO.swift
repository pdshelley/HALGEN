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
    struct GPOI { // TODO: I think I want to rename this struct to AVR5 or something similar. This will probably be the HAL layer for the avr5 core and I'll make a wrapper with a common HAL API that wraps this.
    """
    
    // Filter for Modules named "PORT" // TODO: Find a better way to filter.
    for module in file.modules.module {
        if module.name == .port {
            for registerGroup in module.registerGroup {
                code.append(buildPort(port: registerGroup))
            }
        }
    }
    
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

// TODO: implement 'size' Note: `UInt8` should be used when this is an 8 bit port. I believe that the `size` of 1 indicates 8 bit, and 2 would indicate 16 bit.
// TODO: implement 'initval' Note: This value is optional.
// TODO: implement 'caption' Note: This value is optional.
// TODO: implement 'mask' Note: This value is optional.
// TODO: implement 'ocdRW' Note: This value is optional.
// TODO: implement 'bitfield' Note: This value is an Array that might be empty.
func buildPortRegister(register: AVRToolsDeviceFile.Modules.Module.RegisterGroup.Register) -> String {
    switch register.name {
    case .PORTA, .PORTB, .PORTC, .PORTD, .PORTE, .PORTF, .PORTG, .PORTH, .PORTJ, .PORTK, .PORTL:
        let variableName = "portAccessor"
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
            static var \(variableName): UInt8 { get { _rawPointerRead(address: \(register.offset.rawValue)) } set { _rawPointerWrite(address: \(register.offset.rawValue), value: newValue) } }
    """
    default:
        return ""
    }
}

