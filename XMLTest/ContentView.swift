//
//  ContentView.swift
//  XMLTest
//
//  Created by Paul Shelley on 5/27/23.
//
import XMLCoder
import Foundation
import SwiftUI

struct ContentView: View {
    @State var urls: [URL] = []
    @State var showFileChooser = false
    
    var body: some View {
        HStack {
            Button("Select Files") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = true
                panel.canChooseDirectories = false
                if panel.runModal() == .OK {
                    self.urls = panel.urls
                }
            }
            Button {
                decodeATDF(urls: urls)
            } label: {
                Text("Do the thing")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


func decodeATDF(urls: [URL]) {
    for url in urls {
        do {
            let data = try Data(contentsOf: url)
            decodeATDF(data: data)
        } catch {
            print("Did not work.")
        }
    }
    
    let uniqueNames = listOfValues.unique()
    for name in uniqueNames {
        print(name)
    }
}

var listOfValues: [String] = []

func decodeATDF(data: Data) {
    
    struct AVRToolsDeviceFile: Codable {
        let variants: Variants
        let devices: Devices
        let modules: Modules
        let pinouts: Pinouts?
        
        enum CodingKeys: String, CodingKey {
            case variants
            case devices
            case modules
            case pinouts
        }
        
        struct Variants: Codable {
            let variant: [Variant]
            
            struct Variant: Codable {
                @Attribute var ordercode: String
                @Attribute var tempmin: String
                @Attribute var tempmax: String
                @Attribute var speedmax: String
                @Attribute var pinout: String?
                @Attribute var package: String
                @Attribute var vccmin: String
                @Attribute var vccmax: String
            }
        }
        
        struct Devices: Codable {
            let device: Device
            
            struct Device: Codable {
                @Attribute var name: String
                @Attribute var architecture: String
                @Attribute var family: String
                let addressSpaces: AddressSpaces
                let peripherals: Peripherals
                let interrupts: Interrupts
                let interfaces: Interfaces
                let propertyGroups: PropertyGroups
                
                enum CodingKeys: String, CodingKey {
                    case name
                    case architecture
                    case family
                    case addressSpaces = "address-spaces"
                    case peripherals
                    case interrupts
                    case interfaces
                    case propertyGroups = "property-groups"
                }
                
                struct AddressSpaces: Codable {
                    let addressSpace: [AddressSpace]
                    
                    enum CodingKeys: String, CodingKey {
                        case addressSpace = "address-space"
                    }

                    struct AddressSpace: Codable {
                        @Attribute var endianness: String
                        @Attribute var name: String
                        @Attribute var id: String
                        @Attribute var start: String
                        @Attribute var size: String
                        let memorySegment: [MemorySegment]
                        
                        enum CodingKeys: String, CodingKey {
                            case endianness
                            case name
                            case id
                            case start
                            case size
                            case memorySegment = "memory-segment"
                        }
                        
                        struct MemorySegment: Codable {
                            @Attribute var start: String
                            @Attribute var size: String
                            @Attribute var type: String
                            @Attribute var rw: String?
                            @Attribute var exec: String?
                            @Attribute var name: String
                            @Attribute var pagesize: String?
                            @Attribute var external: String?
                        }
                    }
                }
                
                struct Peripherals: Codable {
                    let module: [Module]
                     
                    struct Module: Codable {
                        @Attribute var name: Name
                        let instance: Instance
                        
                        enum Name: String, Codable {
                            case port = "PORT"
                            case bootLoad = "BOOT_LOAD"
                            case eusart = "EUSART"
                            case ac = "AC"
                            case dac = "DAC"
                            case cpu = "CPU"
                            case tc8 = "TC8"
                            case tc16 = "TC16"
                            case adc = "ADC"
                            case usart = "USART"
                            case spi = "SPI"
                            case wdt = "WDT"
                            case exint = "EXINT"
                            case eeprom = "EEPROM"
                            case psc = "PSC"
                            case fuse = "FUSE"
                            case lockbit = "LOCKBIT"
                            case pll = "PLL"
                            case usbDevice = "USB_DEVICE"
                            case ps2 = "PS2"
                            case twi = "TWI"
                            case usbGlobal = "USB_GLOBAL"
                            case usbHost = "USB_HOST"
                            case tc8async = "TC8_ASYNC"
                            case jtag = "JTAG"
                            case bandgap = "BANDGAP"
                            case fet = "FET"
                            case batteryProtection = "BATTERY_PROTECTION"
                            case coulombCounter = "COULOMB_COUNTER"
                            case voltageRegulator = "VOLTAGE_REGULATOR"
                            case cellBalancing = "CELL_BALANCING"
                            case chargerDetect = "CHARGER_DETECT"
                            case can = "CAN"
                            case linuart = "LINUART"
                            case tc10 = "TC10"
                            case deviceID = "DEVICEID"
                            case misc = "MISC"
                            case wakeupTimer = "WAKEUP_TIMER"
                            case trx24 = "TRX24"
                            case symcnt = "SYMCNT"
                            case flash = "FLASH"
                            case pwrctrl = "PWRCTRL"
                            case usi = "USI"
                            case lcd = "LCD"
                            case ptc = "PTC"
                            case cfd = "CFD"
                            case bod = "BOD"
                            case ccl = "CCL"
                            case clkctrl = "CLKCTRL"
                            case cpuint = "CPUINT"
                            case crcscan = "CRCSCAN"
                            case evsys = "EVSYS"
                            case gpio = "GPIO"
                            case nvmctrl = "NVMCTRL"
                            case portmux = "PORTMUX"
                            case rstctrl = "RSTCTRL"
                            case rtc = "RTC"
                            case sigrow = "SIGROW"
                            case slpctrl = "SLPCTRL"
                            case syscfg = "SYSCFG"
                            case tca = "TCA"
                            case tcb = "TCB"
                            case userrow = "USERROW"
                            case vport = "VPORT"
                            case vref = "VREF"
                        }
                        
                        struct Instance: Codable {
                            @Attribute var name: Name
                            @Attribute var caption: Caption?
                            let registerGroup: RegisterGroup?
                            let signals: Signals?
                            let parameters: Parameters?
                            
                            enum CodingKeys: String, CodingKey {
                                case name
                                case caption
                                case registerGroup = "register-group"
                                case signals
                                case parameters
                            }
                            
                            enum Name: String, Codable {
                                case portA = "PORTA"
                                case portB = "PORTB"
                                case portC = "PORTC"
                                case BootLoad = "BOOT_LOAD"
                                case eusart = "EUSART"
                                case ac = "AC"
                                case ac0 = "AC0"
                                case adc0 = "ADC0"
                                case dac = "DAC"
                                case cpu = "CPU"
                                case tc0 = "TC0"
                                case tc1 = "TC1"
                                case tc2 = "TC2"
                                case tc3 = "TC3"
                                case tc4 = "TC4"
                                case tc5 = "TC5"
                                case adc = "ADC"
                                case usart = "USART"
                                case usart0 = "USART0"
                                case spi = "SPI"
                                case spi0 = "SPI0"
                                case wdt = "WDT"
                                case exint = "EXINT"
                                case eeprom = "EEPROM"
                                case psc0 = "PSC0"
                                case fuse = "FUSE"
                                case lockbit = "LOCKBIT"
                                case pll = "PLL"
                                case usbDevice = "USB_DEVICE"
                                case ps2 = "PS2"
                                case usart1 = "USART1"
                                case twi = "TWI"
                                case twi0 = "TWI0"
                                case usbGlobal = "USB_GLOBAL"
                                case usbHost = "USB_HOST"
                                case jtag = "JTAG"
                                case bandgap = "BANDGAP"
                                case fet = "FET"
                                case vatteryProtection = "BATTERY_PROTECTION"
                                case coulombCounter = "COULOMB_COUNTER"
                                case voltageRegulator = "VOLTAGE_REGULATOR"
                                case cellBalancing = "CELL_BALANCING"
                                case chargerDetect = "CHARGER_DETECT"
                                case can = "CAN"
                                case linuart = "LINUART"
                                case psc = "PSC"
                                case deviceID = "DEVICEID"
                                case misc = "MISC"
                                case wakeupTimer = "WAKEUP_TIMER"
                                case trx24 = "TRX24"
                                case symcnt = "SYMCNT"
                                case flash = "FLASH"
                                case pwrctrl = "PWRCTRL"
                                case usi = "USI"
                                case lcd = "LCD"
                                case ptc = "PTC"
                                case cfd = "CFD"
                                case bod = "BOD"
                                case ccl = "CCL"
                                case clkctrl = "CLKCTRL"
                                case cpuint = "CPUINT"
                                case crcscan = "CRCSCAN"
                                case evsys = "EVSYS"
                                case gpio = "GPIO"
                                case nvmctrl = "NVMCTRL"
                                case portmux = "PORTMUX"
                                case rstctrl = "RSTCTRL"
                                case rtc = "RTC"
                                case sigrow = "SIGROW"
                                case slpctrl = "SLPCTRL"
                                case syscfg = "SYSCFG"
                                case tca0 = "TCA0"
                                case tcb0 = "TCB0"
                                case userrow = "USERROW"
                                case vportA = "VPORTA"
                                case vref = "VREF"
                            }
                            
                            enum Caption: String, Codable {
                                case ioPort = "I/O Port"
                                case jtagInterface = "JTAG Interface"
                                case serialPeripheralInterface = "Serial Peripheral Interface"
                                case twoWireSerialInterface = "Two Wire Serial Interface"
                                case usart = "USART"
                                case cpuRegisters = "CPU Registers"
                                case bootloader = "Bootloader"
                                case externalInterrupts = "External Interrupts"
                                case eeprom = "EEPROM"
                                case timerCounter8bit = "Timer/Counter, 8-bit"
                                case timerCounter16bit = "Timer/Counter, 16-bit"
                                case timerCounter8bitAsync = "Timer/Counter, 8-bit Async"
                                case watchdogTimer = "Watchdog Timer"
                                case analogToDigitalConverter = "Analog-to-Digital Converter"
                                case analogComparator = "Analog Comparator"
                                case controllerAreaNetwork = "Controller Area Network"
                                case fuses = "Fuses"
                                case lockbits = "Lockbits"
                                case powerStageController = "Power Stage Controller"
                                case extendedUSART = "Extended USART"
                                case digitalToAnalogConverter = "Digital-to-Analog Converter"
                                case phaseLockedLoop = "Phase Locked Loop"
                                case usbDeviceRegisters = "USB Device Registers"
                                case ps2Controller = "PS/2 Controller"
                                case usbController = "USB Controller"
                                case usbHostRegisters = "USB Host Registers"
                                case bandgap = "Bandgap"
                                case fetControl = "FET Control"
                                case batteryProtection = "Battery Protection"
                                case coulombCounter = "Coulomb Counter"
                                case voltageRegulator = "Voltage Regulator"
                                case cellBalancing = "Cell Balancing"
                                case chargerDetect = "Charger Detect"
                                case localInterconnectNetwork = "Local Interconnect Network"
                                case TimerCounter10bit = "Timer/Counter, 10-bit"
                                case deviceID = "Device ID"
                                case otherRegisters = "Other Registers"
                                case wakeupTimer = "Wakeup Timer"
                                case lowPower24GHzTransceiver = "Low-Power 2.4 GHz Transceiver"
                                case macSymbolCounter = "MAC Symbol Counter"
                                case flashController = "FLASH Controller"
                                case powerController = "Power Controller"
                                case universalSerialInterface = "Universal Serial Interface"
                                case liquidCrystalDisplay = "Liquid Crystal Display"
                                case peripheralTouchController = "Peripheral Touch Controller"
                                case clockFailureDetection = "Clock Failure Detection"
                            }
                            
                            
                            struct RegisterGroup: Codable {
                                @Attribute var name: Name
                                @Attribute var nameInModule: NameInModule // Should be the same as the Instance.Name but is not exactly
                                @Attribute var offset: String
                                @Attribute var addressSpace: String
                                @Attribute var caption: String?
                                
                                enum CodingKeys: String, CodingKey {
                                    case name
                                    case nameInModule  = "name-in-module"
                                    case offset
                                    case addressSpace = "address-space"
                                    case caption
                                }
                                
                                enum Name: String, Codable {
                                    case portA = "PORTA"
                                    case jtag = "JTAG"
                                    case spi = "SPI"
                                    case twi = "TWI"
                                    case usart0 = "USART0"
                                    case cpu = "CPU"
                                    case bootLoad = "BOOT_LOAD"
                                    case exint = "EXINT"
                                    case eeprom = "EEPROM"
                                    case tc0 = "TC0"
                                    case tc1 = "TC1"
                                    case tc2 = "TC2"
                                    case wdt = "WDT"
                                    case adc = "ADC"
                                    case ac = "AC"
                                    case can = "CAN"
                                    case fuse = "FUSE"
                                    case lockbit = "LOCKBIT"
                                    case portB = "PORTB"
                                    case psc0 = "PSC0"
                                    case eusart = "EUSART"
                                    case dac = "DAC"
                                    case usart = "USART"
                                    case pll = "PLL"
                                    case usbDevice = "USB_DEVICE"
                                    case ps2 = "PS2"
                                    case usart1 = "USART1"
                                    case usbGlobal = "USB_GLOBAL"
                                    case usbHost = "USB_HOST"
                                    case tc3 = "TC3"
                                    case bandgap = "BANDGAP"
                                    case portC = "PORTC"
                                    case fet = "FET"
                                    case batteryProtection = "BATTERY_PROTECTION"
                                    case coulombCounter = "COULOMB_COUNTER"
                                    case voltageRegulartor = "VOLTAGE_REGULATOR"
                                    case cellBallancing = "CELL_BALANCING"
                                    case chargerDetect = "CHARGER_DETECT"
                                    case linuart = "LINUART"
                                    case psc = "PSC"
                                    case tc4 = "TC4"
                                    case deviceID = "DEVICEID"
                                    case misc = "MISC"
                                    case wakeupTimer = "WAKEUP_TIMER"
                                    case tc5 = "TC5"
                                    case trx24 = "TRX24"
                                    case symcnt = "SYMCNT"
                                    case flash = "FLASH"
                                    case pwrctrl = "PWRCTRL"
                                    case tc = "TC"
                                    case usi = "USI"
                                    case lcd = "LCD"
                                    case spi0 = "SPI0"
                                    case twi0 = "TWI0"
                                    case cfd = "CFD"
                                    case ac0 = "AC0"
                                    case adc0 = "ADC0"
                                    case bod = "BOD"
                                    case ccl = "CCL"
                                    case clkctrl = "CLKCTRL"
                                    case cpuint = "CPUINT"
                                    case crcscan = "CRCSCAN"
                                    case evsys = "EVSYS"
                                    case gpoi = "GPIO"
                                    case nvmctrl = "NVMCTRL"
                                    case portmux = "PORTMUX"
                                    case rstctrl = "RSTCTRL"
                                    case rtc = "RTC"
                                    case sigrow = "SIGROW"
                                    case slpctrl = "SLPCTRL"
                                    case syscfg = "SYSCFG"
                                    case tca0 = "TCA0"
                                    case tcb0 = "TCB0"
                                    case userrow = "USERROW"
                                    case vportA = "VPORTA"
                                    case vref = "VREF"
                                }
                            }
                            
                            // Should be the same as the Instance.Name but is not exactly
                            enum NameInModule: String, Codable {
                                case portA = "PORTA"
                                case jtag = "JTAG"
                                case spi = "SPI"
                                case twi = "TWI"
                                case usart0 = "USART0"
                                case cpu = "CPU"
                                case bootLoad = "BOOT_LOAD"
                                case exint = "EXINT"
                                case eeprom = "EEPROM"
                                case tc0 = "TC0"
                                case tc1 = "TC1"
                                case tc2 = "TC2"
                                case wdt = "WDT"
                                case adc = "ADC"
                                case ac = "AC"
                                case can = "CAN"
                                case fuse = "FUSE"
                                case lockbit = "LOCKBIT"
                                case portB = "PORTB"
                                case psc0 = "PSC0"
                                case eusart = "EUSART"
                                case dac = "DAC"
                                case usart = "USART"
                                case pll = "PLL"
                                case usbDevice = "USB_DEVICE"
                                case ps2 = "PS2"
                                case usart1 = "USART1"
                                case usbGlobal = "USB_GLOBAL"
                                case usbHost = "USB_HOST"
                                case tc3 = "TC3"
                                case bandgap = "BANDGAP"
                                case portC = "PORTC"
                                case fet = "FET"
                                case batteryProtection = "BATTERY_PROTECTION"
                                case coulombCounter = "COULOMB_COUNTER"
                                case voltageRegulator = "VOLTAGE_REGULATOR"
                                case cellBalancing = "CELL_BALANCING"
                                case chargerDetect = "CHARGER_DETECT"
                                case linuart = "LINUART"
                                case psc = "PSC"
                                case tc4 = "TC4"
                                case deviceID = "DEVICEID"
                                case misc = "MISC"
                                case wakeupTimer = "WAKEUP_TIMER"
                                case tc5 = "TC5"
                                case trx24 = "TRX24"
                                case symcnt = "SYMCNT"
                                case flash = "FLASH"
                                case pwrctrl = "PWRCTRL"
                                case usi = "USI"
                                case lcd = "LCD"
                                case spi0 = "SPI0"
                                case twi0 = "TWI0"
                                case cfd = "CFD"
                                case bod = "BOD"
                                case ccl = "CCL"
                                case clkctrl = "CLKCTRL"
                                case cpuint = "CPUINT"
                                case crcscan = "CRCSCAN"
                                case evsys = "EVSYS"
                                case gpio = "GPIO"
                                case nvmctrl = "NVMCTRL"
                                case port = "PORT"
                                case portmux = "PORTMUX"
                                case rstctrl = "RSTCTRL"
                                case rtc = "RTC"
                                case sigrow = "SIGROW"
                                case slpctrl = "SLPCTRL"
                                case syscfg = "SYSCFG"
                                case tca = "TCA"
                                case tcb = "TCB"
                                case userrow = "USERROW"
                                case vport = "VPORT"
                                case vref = "VREF"
                            }
                            
                            struct Signals: Codable {
                                let signal: [Signal]
                                
                                struct Signal: Codable {
                                    @Attribute var group: String
                                    @Attribute var function: String
                                    @Attribute var pad: String
                                    @Attribute var index: String?
                                }
                            }
                            
                            struct Parameters: Codable {
                                let parameter: [Parameter]
                                
                                enum CodingKeys: String, CodingKey {
                                    case parameter = "param"
                                }
                                
                                struct Parameter: Codable {
                                    @Attribute var name: String
                                    @Attribute var value: String
                                }
                            }
                        }
                    }
                }
                
                struct Interrupts: Codable {
                    let interrupt: [Interrupt]
                    
                    struct Interrupt: Codable {
                        @Attribute var index: String
                        @Attribute var name: String
                        @Attribute var caption: String?
                    }
                }
                
                struct Interfaces: Codable {
                    let interface: [Interface]
                    
                    struct Interface: Codable {
                        @Attribute var name: String
                        @Attribute var type: String
                    }
                }
                
                struct PropertyGroups: Codable {
                    let propertyGroup: [PropertyGroup]
                    
                    enum CodingKeys: String, CodingKey {
                        case propertyGroup = "property-group"
                    }
                    
                    struct PropertyGroup: Codable {
                        @Attribute var name: String
                        let property: [Property]
                        
                        struct Property: Codable {
                            @Attribute var name: String
                            @Attribute var value: String
                        }
                    }
                }
            }
        }
        
        struct Modules: Codable {
            let module: [Module]

            struct Module: Codable {
                @Attribute var caption: String?
                @Attribute var name: String
                let registerGroup: [RegisterGroup]
                let valueGroup: [ValueGroup]

                enum CodingKeys: String, CodingKey {
                    case name
                    case caption
                    case registerGroup = "register-group"
                    case valueGroup = "value-group"
                }

                struct RegisterGroup: Codable {
                    @Attribute var name: String
                    @Attribute var caption: String?
                    let register: [Register]

                    struct Register: Codable {
                        @Attribute var name: String
                        @Attribute var offset: String
                        @Attribute var size: String
                        @Attribute var initval: String?
                        @Attribute var caption: String?
                        @Attribute var mask: String?
                        @Attribute var ocdRW: String?
                        let bitfield: [Bitfield]
                        
                        enum CodingKeys: String, CodingKey {
                            case name
                            case offset
                            case size
                            case initval
                            case caption
                            case mask
                            case ocdRW = "ocd-rw"
                            case bitfield
                        }

                        struct Bitfield: Codable {
                            @Attribute var caption: String?
                            @Attribute var mask: String
                            @Attribute var name: String
                            @Attribute var values: String?
                            @Attribute var lsb: String?
                            @Attribute var rw: String?
                        }
                    }
                }
                
                struct ValueGroup: Codable {
                    @Attribute var name: String
                    @Attribute var caption: String?
                    let value: [Value]
                    
                    struct Value: Codable {
                        @Attribute var caption: String
                        @Attribute var name: String
                        @Attribute var value: String
                    }
                }
            }
        }
        
        struct Pinouts: Codable {
            var pinout: [Pinout]
            
            struct Pinout: Codable {
                @Attribute var name: String
                @Attribute var caption: String?
                let pin: [Pin]
                
                struct Pin:Codable {
                    @Attribute var position: String
                    @Attribute var pad: String
                }
            }
        }
    }
    
    let ATDFObject = try! XMLDecoder().decode(AVRToolsDeviceFile.self, from: data)
    
    for module in ATDFObject.devices.device.peripherals.module {
        listOfValues.append(module.instance.registerGroup?.nameInModule.rawValue ?? "")
    }
//    print("ATDFObject.devices.device.name = \(ATDFObject.devices.device.peripherals.module.name)")
//    let encodedXML = try! XMLEncoder().encode(ATDFObject, withRootKey: "avr-tools-device-file")
//    print(String(data: encodedXML, encoding: .utf8)!)
}



extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
