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
            Button {
                printValues()
            } label: {
                Text("Show the Stuff")
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
}

var listOfValues: [String] = []

func printValues() {
    let uniqueNames = listOfValues.unique()
    for name in uniqueNames { print(name) }
}

func decodeATDF(data: Data) {
    
    struct AVRToolsDeviceFile: Codable {
        let variants: Variants
        let devices: Devices
        let modules: Modules
        let pinouts: Pinouts?
        
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
                @Attribute var name: String // Always unique, should stay a String?
                @Attribute var architecture: Architecture
                @Attribute var family: Family
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
                
                enum Architecture: String, Codable {
                    case avr8 = "AVR8"
                    case avr8X = "AVR8X"
                }
                
                enum Family: String, Codable {
                    case megaAVR = "megaAVR"
                    case avrMEGA = "AVR MEGA"
                }
                
                struct AddressSpaces: Codable {
                    let addressSpace: [AddressSpace]
                    
                    enum CodingKeys: String, CodingKey {
                        case addressSpace = "address-space"
                    }

                    struct AddressSpace: Codable {
                        @Attribute var endianness: Endianness
                        @Attribute var name: Name
                        @Attribute var id: ID
                        @Attribute var start: Start
                        @Attribute var size: Size
                        let memorySegment: [MemorySegment]
                        
                        enum CodingKeys: String, CodingKey {
                            case endianness
                            case name
                            case id
                            case start
                            case size
                            case memorySegment = "memory-segment"
                        }
                        
                        enum Endianness: String, Codable {
                            case little
                        }
                        
                        enum Name: String, Codable {
                            case prog
                            case signatures
                            case fuses
                            case lockbits
                            case data
                            case eeprom
                            case io
                            case osccal
                            case userSignatures = "user_signatures"
                        }
                        
                        enum ID: String, Codable { // Exactly the same as AddressSpace.Name This is duplicated but I guess it could change or be different.
                            case prog
                            case signatures
                            case fuses
                            case lockbits
                            case data
                            case eeprom
                            case io
                            case osccal
                            case userSignatures = "user_signatures"
                        }
                        
                        enum Start: String, Codable {
                            case zeroX0000 = "0x0000"
                            case zero = "0"
                            case zeroX00 = "0x00"
                            case zeroX0100 = "0x0100"
                        }
                        
                        enum Size: String, Codable {
                            case one = "1"
                            case two = "2"
                            case three = "3"
                            case four = "4"
                            case zeroX40 = "0x40"
                            case zeroX8000 = "0x8000"
                            case zeroX0003 = "0x0003"
                            case zeroX0001 = "0x0001"
                            case zeroX0400 = "0x0400"
                            case zeroX0800 = "0x0800"
                            case zeroX1000 = "0x1000"
                            case zeroX2000 = "0x2000"
                            case zeroX0300 = "0x0300"
                            case zeroX0200 = "0x0200"
                            case zeroX4000 = "0x4000"
                            case zeroX0500 = "0x0500"
                            case zeroX0002 = "0x0002"
                            case zeroX0460 = "0x0460"
                            case zeroX0100 = "0x0100"
                            case zeroX0600 = "0x0600"
                            case zeroX0860 = "0x0860"
                            case zeroX0900 = "0x0900"
                            case zeroX0b00 = "0x0b00"
                            case zeroX1100 = "0x1100"
                            case zeroX2200 = "0x2200"
                            case zeroX4200 = "0x4200"
                            case zeroX8200 = "0x8200"
                            case zeroXa000 = "0xa000"
                            case zeroX4100 = "0x4100"
                            case zeroXC000 = "0xC000"
                            case zeroX0260 = "0x0260"
                            case zeroX10000 = "0x10000"
                            case zeroX20000 = "0x20000"
                            case zeroX40000 = "0x40000"
                        }
                        
                        struct MemorySegment: Codable {
                            @Attribute var start: Start
                            @Attribute var size: Size
                            @Attribute var type: MemorySegmentType
                            @Attribute var rw: ReadWrite?
                            @Attribute var exec: Exec?
                            @Attribute var name: Name
                            @Attribute var pagesize: PageSize?
                            @Attribute var external: Bool?
                            
                            enum Start: String, Codable {
                                case zero = "0"
                                case zeroX00 = "0x00"
                                case zeroX0000 = "0x0000"
                                case zeroX7c00 = "0x7c00"
                                case zeroX7800 = "0x7800"
                                case zeroX7000 = "0x7000"
                                case zeroX6000 = "0x6000"
                                case zeroX0020 = "0x0020"
                                case zeroX0100 = "0x0100"
                                case zeroX0900 = "0x0900"
                                case zeroXfc00 = "0xfc00"
                                case zeroXf800 = "0xf800"
                                case zeroXf000 = "0xf000"
                                case zeroXe000 = "0xe000"
                                case zeroX1100 = "0x1100"
                                case zeroX1f00 = "0x1f00"
                                case zeroX1e00 = "0x1e00"
                                case zeroX1c00 = "0x1c00"
                                case zeroX1800 = "0x1800"
                                case zeroX3f00 = "0x3f00"
                                case zeroX3e00 = "0x3e00"
                                case zeroX3c00 = "0x3c00"
                                case zeroX3800 = "0x3800"
                                case zeroX3000 = "0x3000"
                                case zeroX1000 = "0x1000"
                                case zeroX2200 = "0x2200"
                                case zeroX0060 = "0x0060"
                                case zeroX7e00 = "0x7e00"
                                case zeroX0200 = "0x0200"
                                case zeroX0500 = "0x0500"
                                case zeroX9e00 = "0x9e00"
                                case zeroX9c00 = "0x9c00"
                                case zeroX9800 = "0x9800"
                                case zeroX9000 = "0x9000"
                                case zeroX1103 = "0x1103"
                                case zeroX1280 = "0x1280"
                                case zeroX128A = "0x128A"
                                case zeroX1300 = "0x1300"
                                case zeroX1400 = "0x1400"
                                case zeroX3C00 = "0x3C00"
                                case zeroX4000 = "0x4000"
                                case zeroX2800 = "0x2800"
                                case zeroX0260 = "0x0260"
                                case zeroX1fc00 = "0x1fc00"
                                case zeroX1f800 = "0x1f800"
                                case zeroX1f000 = "0x1f000"
                                case zeroX1e000 = "0x1e000"
                                case zeroX3fc00 = "0x3fc00"
                                case zeroX3f800 = "0x3f800"
                                case zeroX3f000 = "0x3f000"
                                case zeroX3e000 = "0x3e000"
                            }
                            
                            enum Size: String, Codable {
                                case one = "1"
                                case two = "2"
                                case three = "3"
                                case four = "4"
                                case zeroX03 = "0x03"
                                case zeroX3D = "0x3D"
                                case zeroX0A = "0x0A"
                                case zeroX01 = "0x01"
                                case zeroX20 = "0x20"
                                case zeroX7D = "0x7D"
                                case zeroX40 = "0x40"
                                case zeroX100 = "0x100"
                                case zeroX400 = "0x400"
                                case zeroX800 = "0x800"
                                case zeroX8000 = "0x8000"
                                case zeroX0400 = "0x0400"
                                case zeroX0800 = "0x0800"
                                case zeroX1000 = "0x1000"
                                case zeroX2000 = "0x2000"
                                case zeroX0003 = "0x0003"
                                case zeroX0001 = "0x0001"
                                case zeroX0020 = "0x0020"
                                case zeroX00e0 = "0x00e0"
                                case zeroXf700 = "0xf700"
                                case zeroXef00 = "0xef00"
                                case zeroX0100 = "0x0100"
                                case zeroX0200 = "0x0200"
                                case zeroX4000 = "0x4000"
                                case zeroXde00 = "0xde00"
                                case zeroX0002 = "0x0002"
                                case zeroX0040 = "0x0040"
                                case zeroX0500 = "0x0500"
                                case zeroX0a00 = "0x0a00"
                                case zeroX0300 = "0x0300"
                                case zeroX01e0 = "0x01e0"
                                case zeroXfb00 = "0xfb00"
                                case zeroXa000 = "0xa000"
                                case zeroX1100 = "0x1100"
                                case zeroX1800 = "0x1800"
                                case zeroXC000 = "0xC000"
                                case zeroXfda0 = "0xfda0"
                                case zeroX10000 = "0x10000"
                                case zeroX20000 = "0x20000"
                                case zeroX40000 = "0x40000"
                            }
                            
                            enum MemorySegmentType: String, Codable { // I think this is the same as another Type
                                case flash
                                case signatures
                                case fuses
                                case lockbits
                                case regs
                                case io
                                case ram
                                case eeprom
                                case osccal
                                case userSignatures = "user_signatures"
                                case other
                            }
                            
                            enum ReadWrite: String, Codable {
                                case readWrite = "RW"
                                case read = "R"
                            }
                            
                            enum Exec: String, Codable { // Should this be an Int or Bool?
                                case zero = "0"
                                case one = "1"
                            }
                            
                            enum Name: String, Codable {
                                case flash = "FLASH"
                                case bootSection1 = "BOOT_SECTION_1"
                                case bootSection2 = "BOOT_SECTION_2"
                                case bootSection3 = "BOOT_SECTION_3"
                                case bootSection4 = "BOOT_SECTION_4"
                                case signatures = "SIGNATURES"
                                case fuses = "FUSES"
                                case lockbits = "LOCKBITS"
                                case registers = "REGISTERS"
                                case mappedIO = "MAPPED_IO"
                                case iRAM = "IRAM"
                                case xRAM = "XRAM"
                                case eeprom = "EEPROM"
                                case osccal = "OSCCAL"
                                case userSignatures = "USER_SIGNATURES"
                                case io = "IO"
                                case prodSignatures = "PROD_SIGNATURES"
                                case internalSRAM = "INTERNAL_SRAM"
                                case mappedProgramMemory = "MAPPED_PROGMEM"
                                case programMemory = "PROGMEM"
                            }
                            
                            enum PageSize: String, Codable {
                                case zeroX100 = "0x100"
                                case zeroX08 = "0x08"
                                case zeroX40 = "0x40"
                                case zeroX04 = "0x04"
                                case zeroX80 = "0x80"
                                case zeroX20 = "0x20"
                            }
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
                                @Attribute var offset: Offset
                                @Attribute var addressSpace: AddressSpace
                                @Attribute var caption: Instance.Caption?
                                
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
                                
                                enum Offset: String, Codable {
                                    case hec0x00 = "0x00"
                                    case hec0 = "0"
                                    case hec0x0 = "0x0"
                                    case hec0x0680 = "0x0680"
                                    case hec0x0600 = "0x0600"
                                    case hec0x0080 = "0x0080"
                                    case hec0x01C0 = "0x01C0"
                                    case hec0x0060 = "0x0060"
                                    case hec0x0030 = "0x0030"
                                    case hec0x0110 = "0x0110"
                                    case hec0x0120 = "0x0120"
                                    case hec0x0180 = "0x0180"
                                    case hec0x1280 = "0x1280"
                                    case hec0x001C = "0x001C"
                                    case hec0x128A = "0x128A"
                                    case hec0x1000 = "0x1000"
                                    case hec0x0400 = "0x0400"
                                    case hec0x05E0 = "0x05E0"
                                    case hec0x0040 = "0x0040"
                                    case hec0x0140 = "0x0140"
                                    case hec0x1100 = "0x1100"
                                    case hec0x0050 = "0x0050"
                                    case hec0x08C0 = "0x08C0"
                                    case hec0x0F00 = "0x0F00"
                                    case hec0x0A00 = "0x0A00"
                                    case hec0x0A80 = "0x0A80"
                                    case hec0x08A0 = "0x08A0"
                                    case hec0x0800 = "0x0800"
                                    case hec0x1300 = "0x1300"
                                    case hec0x0000 = "0x0000"
                                    case hec0x00A0 = "0x00A0"
                                    case hec0x0100 = "0x0100"
                                }
                                
                                enum AddressSpace: String, Codable {
                                    case data = "data"
                                    case fuses = "fuses"
                                    case lockbits = "lockbits"
                                }
                            }
                            
                            struct Signals: Codable {
                                let signal: [Signal]
                                
                                struct Signal: Codable {
                                    @Attribute var group: Signal.Group
                                    @Attribute var function: Function
                                    @Attribute var pad: Pad
                                    @Attribute var index: Index? // TODO: This is optional because at least one file is missing an index. Is this an error that needs fixing?
                                    
                                    enum Group: String, Codable {
                                        case p = "P"
                                        case tck = "TCK"
                                        case tms = "TMS"
                                        case tdo = "TDO"
                                        case tdi = "TDI"
                                        case ss = "SS"
                                        case mosi = "MOSI"
                                        case miso = "MISO"
                                        case sck = "SCK"
                                        case sda = "SDA"
                                        case scl = "SCL"
                                        case txt = "TXD"
                                        case rxd = "RXD"
                                        case xck = "XCK"
                                        case clko = "CLKO"
                                        case ain = "AIN"
                                        case int = "INT"
                                        case t = "T"
                                        case ocb = "OCB"
                                        case oca = "OCA"
                                        case occ = "OCC"
                                        case icp = "ICP"
                                        case oc = "OC"
                                        case sclk = "SCLK"
                                        case pin = "PIN"
                                        case tosc1 = "TOSC1"
                                        case tosc2 = "TOSC2"
                                        case adc = "ADC"
                                        case pcint = "PCINT"
                                        case clk = "CLK"
                                        case xtal1 = "XTAL1"
                                        case xtal2 = "XTAL2"
                                        case ac = "AC"
                                        case tosc = "TOSC"
                                        case ain0 = "AIN0"
                                        case ain1 = "AIN1"
                                        case portA = "PORTA"
                                        case n = "N"
                                        case out = "OUT"
                                        case txcan = "TXCAN"
                                        case rxcan = "RXCAN"
                                        case rts = "RTS"
                                        case cts = "CTS"
                                        case acmp = "ACMP"
                                        case acmpn = "ACMPN"
                                        case d2a = "D2A"
                                        case t0 = "T0"
                                        case oc0a = "OC0A"
                                        case oc0b = "OC0B"
                                        case t1 = "T1"
                                        case icp1a = "ICP1A"
                                        case icp1b = "ICP1B"
                                        case oc1a = "OC1A"
                                        case oc1b = "OC1B"
                                        case txlIN = "TXLIN"
                                        case rxLIN = "RXLIN"
                                        case pscin2 = "PSCIN2"
                                        case pscout2a = "PSCOUT2A"
                                        case pscout2b = "PSCOUT2B"
                                        case pscin1 = "PSCIN1"
                                        case pscout1a = "PSCOUT1A"
                                        case pscout1b = "PSCOUT1B"
                                        case pscin0 = "PSCIN0"
                                        case pscout0a = "PSCOUT0A"
                                        case pscout0b = "PSCOUT0B"
                                        case pdi = "PDI"
                                        case pdo = "PDO"
                                        case hwb = "HWB"
                                        case _oca = "_OCA"
                                        case _ocb = "_OCB"
                                        case _ocd = "_OCD"
                                        case ocd = "OCD"
                                        case ad = "AD"
                                        case a = "A"
                                        case ale = "ALE"
                                        case rd = "RD"
                                        case wd = "WD"
                                        case oc3c = "OC3C"
                                        case wr = "WR"
                                        case seg = "SEG"
                                        case com = "COM"
                                        case di = "DI"
                                        case DO = "DO"
                                        case USCK = "USCK"
                                        case int0 = "INT0"
                                        case int1 = "INT1"
                                        case int2 = "INT2"
                                        case x = "X"
                                        case y = "Y"
                                        case adc0 = "ADC0"
                                        case adc1 = "ADC1"
                                        case adc2 = "ADC2"
                                        case adc3 = "ADC3"
                                        case adc4 = "ADC4"
                                        case adc5 = "ADC5"
                                        case adc6 = "ADC6"
                                        case adc7 = "ADC7"
                                        case sda0 = "SDA0"
                                        case SCL0 = "SCL0"
                                        case pcint27 = "PCINT27"
                                        case pcint28 = "PCINT28"
                                        case pcint29 = "PCINT29"
                                        case pcint30 = "PCINT30"
                                        case pcint31 = "PCINT31"
                                        case lut0_in = "LUT0_IN"
                                        case lut0_out = "LUT0_OUT"
                                        case lut1_in = "LUT1_IN"
                                        case lut1_out = "LUT1_OUT"
                                        case lut2_in = "LUT2_IN"
                                        case lut2_out = "LUT2_OUT"
                                        case lut3_in = "LUT3_IN"
                                        case lut3_out = "LUT3_OUT"
                                        case clki = "CLKI"
                                        case evout = "EVOUT"
                                        case reset = "RESET"
                                        case wo = "WO"
                                        case xdir = "XDIR"
                                    }
                                    
                                    enum Function: String, Codable {
                                        case DEFAULT = "default"
                                        case IOPORT = "IOPORT"
                                        case AC = "AC"
                                        case DAC = "DAC"
                                        case TC0 = "TC0"
                                        case TC1 = "TC1"
                                        case ADC = "ADC"
                                        case LIN = "LIN"
                                        case SPI = "SPI"
                                        case SPI_ALT = "SPI_ALT"
                                        case EXINT = "EXINT"
                                        case PSC = "PSC"
                                        case AC0 = "AC0"
                                        case AIN0 = "AIN0"
                                        case CCL = "CCL"
                                        case CCL_ALT = "CCL_ALT"
                                        case CLKCTRL = "CLKCTRL"
                                        case EVSYS = "EVSYS"
                                        case EVSYS_ALT = "EVSYS_ALT"
                                        case OTHER = "OTHER"
                                        case TCA = "TCA"
                                        case TCA_ALT2 = "TCA_ALT2"
                                        case TCA_ALT3 = "TCA_ALT3"
                                        case TCA_ALT5 = "TCA_ALT5"
                                        case TCB0 = "TCB0"
                                        case TCB0_ALT = "TCB0_ALT"
                                        case I2C = "I2C"
                                        case I2C_ALT = "I2C_ALT"
                                        case I2C_ALT2 = "I2C_ALT2"
                                        case USART0 = "USART0"
                                        case USART0_ALT = "USART0_ALT"
                                        case SPI_ALT2 = "SPI_ALT2"
                                        case TCA_ALT = "TCA_ALT"
                                        case TCA_ALT4 = "TCA_ALT4"
                                    }
                                    
                                    enum Pad: String, Codable {
                                        case PA0 = "PA0"
                                        case PA1 = "PA1"
                                        case PA2 = "PA2"
                                        case PA3 = "PA3"
                                        case PA4 = "PA4"
                                        case PA5 = "PA5"
                                        case PA6 = "PA6"
                                        case PA7 = "PA7"
                                        
                                        case PB0 = "PB0"
                                        case PB1 = "PB1"
                                        case PB2 = "PB2"
                                        case PB3 = "PB3"
                                        case PB4 = "PB4"
                                        case PB5 = "PB5"
                                        case PB6 = "PB6"
                                        case PB7 = "PB7"
                                        
                                        case PC0 = "PC0"
                                        case PC1 = "PC1"
                                        case PC2 = "PC2"
                                        case PC3 = "PC3"
                                        case PC4 = "PC4"
                                        case PC5 = "PC5"
                                        case PC6 = "PC6"
                                        case PC7 = "PC7"
                                        
                                        case PD0 = "PD0"
                                        case PD1 = "PD1"
                                        case PD2 = "PD2"
                                        case PD3 = "PD3"
                                        case PD4 = "PD4"
                                        case PD5 = "PD5"
                                        case PD6 = "PD6"
                                        case PD7 = "PD7"
                                        
                                        case PE0 = "PE0"
                                        case PE1 = "PE1"
                                        case PE2 = "PE2"
                                        case PE3 = "PE3"
                                        case PE4 = "PE4"
                                        case PE5 = "PE5"
                                        case PE6 = "PE6"
                                        case PE7 = "PE7"
                                        
                                        case PF0 = "PF0"
                                        case PF1 = "PF1"
                                        case PF3 = "PF3"
                                        case PF2 = "PF2"
                                        case PF4 = "PF4"
                                        case PF5 = "PF5"
                                        case PF6 = "PF6"
                                        case PF7 = "PF7"
                                        
                                        case PG0 = "PG0"
                                        case PG1 = "PG1"
                                        case PG2 = "PG2"
                                        case PG3 = "PG3"
                                        case PG4 = "PG4"
                                        case PG5 = "PG5"
                                        
                                        case PH6 = "PH6"
                                        
                                        case PJ0 = "PJ0"
                                        case PJ1 = "PJ1"
                                        case PJ2 = "PJ2"
                                        case PJ3 = "PJ3"
                                        case PJ4 = "PJ4"
                                        case PJ5 = "PJ5"
                                        case PJ6 = "PJ6"
                                        
                                        case PK0 = "PK0"
                                        case PK1 = "PK1"
                                        case PK2 = "PK2"
                                        case PK3 = "PK3"
                                        case PK4 = "PK4"
                                        case PK5 = "PK5"
                                        case PK6 = "PK6"
                                        case PK7 = "PK7"
                                        
                                        case PL1 = "PL1"
                                        case PL2 = "PL2"
                                        case PL3 = "PL3"
                                        case PL4 = "PL4"
                                        case PL5 = "PL5"
                                        
                                        case ADC6 = "ADC6"
                                        case ADC7 = "ADC7"
                                        
                                        case XTAL1 = "XTAL1"
                                        case XTAL2 = "XTAL2"
                                    }
                                    
                                    enum Index: String, Codable {
                                        case zero = "0"
                                        case one = "1"
                                        case two = "2"
                                        case three = "3"
                                        case four = "4"
                                        case five = "5"
                                        case six = "6"
                                        case seven = "7"
                                        case eight = "8"
                                        case nine = "9"
                                        case ten = "10"
                                        case eleven = "11"
                                        case twelve = "12"
                                        case thirteen = "13"
                                        case fourteen = "14"
                                        case fifteen = "15"
                                        case sixteen = "16"
                                        case seventeen = "17"
                                        case eightteen = "18"
                                        case nineteen = "19"
                                        case twenty = "20"
                                        case twentyOne = "21"
                                        case twentyTwo = "22"
                                        case twentyThree = "23"
                                        case otwentyFour = "24"
                                        case otwentyFive = "25"
                                        case otwentySix = "26"
                                        case otwentySeven = "27"
                                        case otwentyEight = "28"
                                        case otwentyNine = "29"
                                        case thirty = "30"
                                        case thirtyone = "31"
                                        case thirtyTwo = "32"
                                        case thirtyThree = "33"
                                        case zero0 = "00" // TODO: This is probably an incosistancy in naming, Should we standardize it?
                                        case zero1 = "01" // TODO: This is probably an incosistancy in naming, Should we standardize it?
                                        case zero2 = "02" // TODO: This is probably an incosistancy in naming, Should we standardize it?
                                        case zero3 = "03" // TODO: This is probably an incosistancy in naming, Should we standardize it?
                                        case zero4 = "04" // TODO: This is probably an incosistancy in naming, Should we standardize it?
                                        case zero5 = "05" // TODO: This is probably an incosistancy in naming, Should we standardize it?
                                        case zero6 = "06" // TODO: This is probably an incosistancy in naming, Should we standardize it?
                                        case zero7 = "07" // TODO: This is probably an incosistancy in naming, Should we standardize it?
                                        case zero8 = "08" // TODO: This is probably an incosistancy in naming, Should we standardize it?
                                        case zero9 = "09" // TODO: This is probably an incosistancy in naming, Should we standardize it?
                                    }
                                }
                            }
                            
                            struct Parameters: Codable {
                                let parameter: [Parameter]
                                
                                enum CodingKeys: String, CodingKey {
                                    case parameter = "param"
                                }
                                
                                struct Parameter: Codable {
                                    @Attribute var name: Name
                                    @Attribute var value: Value
                                    
                                    enum Name: String, Codable {
                                        case coreVersion = "CORE_VERSION"
                                    }
                                    
                                    enum Value: String, Codable {
                                        case v2e = "V2E"
                                        case v2 = "V2"
                                        case v3 = "V3"
                                        case v4 = "V4"
                                    }
                                }
                            }
                        }
                    }
                }
                
                struct Interrupts: Codable {
                    let interrupt: [Interrupt]
                    
                    struct Interrupt: Codable {
                        @Attribute var index: Int // TODO: This should probably be a number. Is there a nice way to have the index type be an Int and still have the simple auto fill and constraint of an enum? Also is this worth it?
                        @Attribute var name: Name
                        @Attribute var caption: Caption?
                        
                        // Note: Leaving this here for now but it probably makes sense that we use an Int and not this enum. We loose the advantage of having a constrained list, however I don't think this is that important.
                        enum Index: String, Codable {
                            case zero = "0"
                            case one = "1"
                            case two = "2"
                            case three = "3"
                            case four = "4"
                            case five = "5"
                            case six = "6"
                            case seven = "7"
                            case eight = "8"
                            case nine = "9"
                            case ten = "10"
                            case eleven = "11"
                            case twelve = "12"
                            case thirteen = "13"
                            case fourteen = "14"
                            case fifteen = "15"
                            case sisteen = "16"
                            case seventeen = "17"
                            case eightteen = "18"
                            case nineteen = "19"
                            case twenty = "20"
                            case twentyOne = "21"
                            case twentyTwo = "22"
                            case twentyThree = "23"
                            case twentyFour = "24"
                            case twentyFive = "25"
                            case twentySix = "26"
                            case twentySeven = "27"
                            case twentyEight = "28"
                            case twentyNine = "29"
                            case thirty = "30"
                            case thirtyOne = "31"
                            case thirtyTwo = "32"
                            case thirtyThree = "33"
                            case thirtyFour = "34"
                            case thirtyFive = "35"
                            case thirtySix = "36"
                            case thirtySeven = "37"
                            case thirtyEight = "38"
                            case thirtyNine = "39"
                            case forty = "40"
                            case fortyOne = "41"
                            case fortyTwo = "42"
                            case fortyThree = "43"
                            case fortyFour = "44"
                            case fortyFive = "45"
                            case fortySix = "46"
                            case fortySeven = "47"
                            case fortyEight = "48"
                            case fortyNine = "49"
                            case fifty = "50"
                            case fiftyOne = "51"
                            case fiftyTwo = "52"
                            case fiftyThree = "53"
                            case fiftyFour = "54"
                            case fiftyFive = "55"
                            case fiftySix = "56"
                            case fiftySeven = "57"
                            case fiftyEight = "58"
                            case fiftyNine = "59"
                            case sixty = "60"
                            case sixtyOne = "61"
                            case sixtyTwo = "62"
                            case sixtyThree = "63"
                            case sixtyFour = "64"
                            case sixtyFive = "65"
                            case sixtySix = "66"
                            case sixtySeven = "67"
                            case sixtyEight = "68"
                            case sixtyNine = "69"
                            case seventy = "70"
                            case seventyOne = "71"
                            case seventyTwo = "72"
                            case seventyThree = "73"
                            case seventyFour = "74"
                            case seventyFive = "75"
                            case seventySix = "76"
                            
                        }
                        
                        enum Name: String, Codable {
                            case RESET = "RESET"
                            case INT0 = "INT0"
                            case INT1 = "INT1"
                            case INT2 = "INT2"
                            case INT3 = "INT3"
                            case INT4 = "INT4"
                            case INT5 = "INT5"
                            case INT6 = "INT6"
                            case INT7 = "INT7"
                            case TIMER2_COMP = "TIMER2_COMP"
                            case TIMER2_OVF = "TIMER2_OVF"
                            case TIMER1_CAPT = "TIMER1_CAPT"
                            case TIMER1_COMPA = "TIMER1_COMPA"
                            case TIMER1_COMPB = "TIMER1_COMPB"
                            case TIMER1_COMPC = "TIMER1_COMPC"
                            case TIMER1_OVF = "TIMER1_OVF"
                            case TIMER0_COMP = "TIMER0_COMP"
                            case TIMER0_OVF = "TIMER0_OVF"
                            case CANIT = "CANIT"
                            case OVRIT = "OVRIT"
                            case SPI_STC = "SPI_STC"
                            case USART0_RX = "USART0_RX"
                            case USART0_UDRE = "USART0_UDRE"
                            case USART0_TX = "USART0_TX"
                            case ANALOG_COMP = "ANALOG_COMP"
                            case ADC = "ADC"
                            case EE_READY = "EE_READY"
                            case TIMER3_CAPT = "TIMER3_CAPT"
                            case TIMER3_COMPA = "TIMER3_COMPA"
                            case TIMER3_COMPB = "TIMER3_COMPB"
                            case TIMER3_COMPC = "TIMER3_COMPC"
                            case TIMER3_OVF = "TIMER3_OVF"
                            case USART1_RX = "USART1_RX"
                            case USART1_UDRE = "USART1_UDRE"
                            case USART1_TX = "USART1_TX"
                            case TWI = "TWI"
                            case SPM_READY = "SPM_READY"
                            case PSC2_CAPT = "PSC2_CAPT"
                            case PSC2_EC = "PSC2_EC"
                            case PSC1_CAPT = "PSC1_CAPT"
                            case PSC1_EC = "PSC1_EC"
                            case PSC0_CAPT = "PSC0_CAPT"
                            case PSC0_EC = "PSC0_EC"
                            case ANALOG_COMP_0 = "ANALOG_COMP_0"
                            case ANALOG_COMP_1 = "ANALOG_COMP_1"
                            case ANALOG_COMP_2 = "ANALOG_COMP_2"
                            case RESERVED15 = "RESERVED15"
                            case TIMER0_COMP_A = "TIMER0_COMP_A"
                            case USART_RX = "USART_RX"
                            case USART_UDRE = "USART_UDRE"
                            case USART_TX = "USART_TX"
                            case WDT = "WDT"
                            case TIMER0_COMPB = "TIMER0_COMPB"
                            case RESERVED30 = "RESERVED30"
                            case RESERVED31 = "RESERVED31"
                            case TIMER0_COMPA = "TIMER0_COMPA"
                            case PSC2_EEC = "PSC2_EEC"
                            case PSC0_EEC = "PSC0_EEC"
                            case ANALOG_COMP_3 = "ANALOG_COMP_3"
                            case PCINT0 = "PCINT0"
                            case PCINT1 = "PCINT1"
                            case USB_GEN = "USB_GEN"
                            case USB_COM = "USB_COM"
                            case TIMER2_COMPA = "TIMER2_COMPA"
                            case TIMER2_COMPB = "TIMER2_COMPB"
                            case USART_RXC = "USART_RXC"
                            case USART_TXC = "USART_TXC"
                            case EE_RDY = "EE_RDY"
                            case ANA_COMP = "ANA_COMP"
                            case SPM_RDY = "SPM_RDY"
                            case BPINT = "BPINT"
                            case VREGMON = "VREGMON"
                            case TIMER1_IC = "TIMER1_IC"
                            case TIMER0_IC = "TIMER0_IC"
                            case VADC = "VADC"
                            case CCADC_CONV = "CCADC_CONV"
                            case CCADC_REG_CUR = "CCADC_REG_CUR"
                            case CCADC_ACC = "CCADC_ACC"
                            case BGSCD = "BGSCD"
                            case CHDET = "CHDET"
                            case TWIBUSCD = "TWIBUSCD"
                            case SPM = "SPM"
                            case ANACOMP0 = "ANACOMP0"
                            case ANACOMP1 = "ANACOMP1"
                            case ANACOMP2 = "ANACOMP2"
                            case ANACOMP3 = "ANACOMP3"
                            case PSC_FAULT = "PSC_FAULT"
                            case PSC_EC = "PSC_EC"
                            case CAN_INT = "CAN_INT"
                            case CAN_TOVF = "CAN_TOVF"
                            case LIN_TC = "LIN_TC"
                            case LIN_ERR = "LIN_ERR"
                            case PCINT2 = "PCINT2"
                            case PCINT3 = "PCINT3"
                            case Reserved1 = "Reserved1"
                            case Reserved2 = "Reserved2"
                            case Reserved3 = "Reserved3"
                            case Reserved4 = "Reserved4"
                            case Reserved5 = "Reserved5"
                            case Reserved6 = "Reserved6"
                            case TIMER4_COMPA = "TIMER4_COMPA"
                            case TIMER4_COMPB = "TIMER4_COMPB"
                            case TIMER4_COMPD = "TIMER4_COMPD"
                            case TIMER4_OVF = "TIMER4_OVF"
                            case TIMER4_FPF = "TIMER4_FPF"
                            case SPM_Ready = "SPM_Ready"
                            case USART_START = "USART_START"
                            case WAKEUP = "WAKEUP"
                            case LIN_STATUS = "LIN_STATUS"
                            case LIN_ERROR = "LIN_ERROR"
                            case VADC_CONV = "VADC_CONV"
                            case VADC_ACC = "VADC_ACC"
                            case CADC_CONV = "CADC_CONV"
                            case CADC_REG_CUR = "CADC_REG_CUR"
                            case CADC_ACC = "CADC_ACC"
                            case PLL = "PLL"
                            case TIMER4_CAPT = "TIMER4_CAPT"
                            case TIMER4_COMPC = "TIMER4_COMPC"
                            case TIMER5_CAPT = "TIMER5_CAPT"
                            case TIMER5_COMPA = "TIMER5_COMPA"
                            case TIMER5_COMPB = "TIMER5_COMPB"
                            case TIMER5_COMPC = "TIMER5_COMPC"
                            case TIMER5_OVF = "TIMER5_OVF"
                            case TRX24_PLL_LOCK = "TRX24_PLL_LOCK"
                            case TRX24_PLL_UNLOCK = "TRX24_PLL_UNLOCK"
                            case TRX24_RX_START = "TRX24_RX_START"
                            case TRX24_RX_END = "TRX24_RX_END"
                            case TRX24_CCA_ED_DONE = "TRX24_CCA_ED_DONE"
                            case TRX24_XAH_AMI = "TRX24_XAH_AMI"
                            case TRX24_TX_END = "TRX24_TX_END"
                            case TRX24_AWAKE = "TRX24_AWAKE"
                            case SCNT_CMP1 = "SCNT_CMP1"
                            case SCNT_CMP2 = "SCNT_CMP2"
                            case SCNT_CMP3 = "SCNT_CMP3"
                            case SCNT_OVFL = "SCNT_OVFL"
                            case SCNT_BACKOFF = "SCNT_BACKOFF"
                            case AES_READY = "AES_READY"
                            case BAT_LOW = "BAT_LOW"
                            case TRX24_TX_START = "TRX24_TX_START"
                            case TRX24_AMI0 = "TRX24_AMI0"
                            case TRX24_AMI1 = "TRX24_AMI1"
                            case TRX24_AMI2 = "TRX24_AMI2"
                            case TRX24_AMI3 = "TRX24_AMI3"
                            case USART2_RX = "USART2_RX"
                            case USART2_UDRE = "USART2_UDRE"
                            case USART2_TX = "USART2_TX"
                            case USART3_RX = "USART3_RX"
                            case USART3_UDRE = "USART3_UDRE"
                            case USART3_TX = "USART3_TX"
                            case USART0_RXC = "USART0_RXC"
                            case USART1_RXC = "USART1_RXC"
                            case USART0_TXC = "USART0_TXC"
                            case USART1_TXC = "USART1_TXC"
                            case USI_START = "USI_START"
                            case USI_OVERFLOW = "USI_OVERFLOW"
                            case LCD = "LCD"
                            case SPI0_STC = "SPI0_STC"
                            case TWI0 = "TWI0"
                            case USART0_RXS = "USART0_RXS"
                            case USART0_START = "USART0_START"
                            case USART1_RXS = "USART1_RXS"
                            case USART1_START = "USART1_START"
                            case PCINT4 = "PCINT4"
                            case XOSCFD = "XOSCFD"
                            case PTC_EOC = "PTC_EOC"
                            case PTC_WCOMP = "PTC_WCOMP"
                            case SPI1_STC = "SPI1_STC"
                            case TWI1 = "TWI1"
                            case USART2_RXS = "USART2_RXS"
                            case USART2_START = "USART2_START"
                            case CFD = "CFD"
                            case WAKE_UP = "WAKE_UP"
                            case TIM1_COMP = "TIM1_COMP"
                            case TIM1_OVF = "TIM1_OVF"
                            case TIM0_COMPA = "TIM0_COMPA"
                            case TIM0_COMPB = "TIM0_COMPB"
                            case TIM0_OVF = "TIM0_OVF"
                            case TWI_BUS_CD = "TWI_BUS_CD"
                            case NMI = "NMI"
                            case VLM = "VLM"
                            case CNT = "CNT"
                            case PIT = "PIT"
                            case CCL = "CCL"
                            case PORT = "PORT"
                            case LUNF = "LUNF"
                            case OVF = "OVF"
                            case HUNF = "HUNF"
                            case CMP0 = "CMP0"
                            case LCMP0 = "LCMP0"
                            case CMP1 = "CMP1"
                            case LCMP1 = "LCMP1"
                            case CMP2 = "CMP2"
                            case LCMP2 = "LCMP2"
                            case INT = "INT"
                            case TWIS = "TWIS"
                            case TWIM = "TWIM"
                            case RXC = "RXC"
                            case DRE = "DRE"
                            case TXC = "TXC"
                            case AC = "AC"
                            case RESRDY = "RESRDY"
                            case WCOMP = "WCOMP"
                            case EE = "EE"
                            case NOT_USED = "NOT_USED"
                        }
                        
                        enum Caption: String, Codable {
                            case externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRReset = "External Pin, Power-on Reset, Brown-out Reset, Watchdog Reset and JTAG AVR Reset"
                            case externalInterruptRequest0 = "External Interrupt Request 0"
                            case externalInterruptRequest1 = "External Interrupt Request 1"
                            case externalInterruptRequest2 = "External Interrupt Request 2"
                            case externalInterruptRequest3 = "External Interrupt Request 3"
                            case externalInterruptRequest4 = "External Interrupt Request 4"
                            case externalInterruptRequest5 = "External Interrupt Request 5"
                            case externalInterruptRequest6 = "External Interrupt Request 6"
                            case externalInterruptRequest7 = "External Interrupt Request 7"
                            case timerCounter2CompareMatch = "Timer/Counter2 Compare Match"
                            case timerCounter2Overflow = "Timer/Counter2 Overflow"
                            case timerCounter1CaptureEvent = "Timer/Counter1 Capture Event"
                            case timerCounter1CompareMatchA = "Timer/Counter1 Compare Match A"
                            case timerCounterCompareMatchB = "Timer/Counter Compare Match B"
                            case timerCounter1CompareMatchC = "Timer/Counter1 Compare Match C"
                            case timerCounter1Overflow = "Timer/Counter 1 Overflow"
                            case timerCounter1Overflow2 = "Timer/Counter1 Overflow"
                            case timerCounter0CompareMatch = "Timer/Counter0 Compare Match"
                            case timerCounter0CompareMatch2 = "TimerCounter0 Compare Match"
                            case timerCounter0Overflow = "Timer/Counter0 Overflow"
                            case canTransferCompleteOrError = "CAN Transfer Complete or Error"
                            case canTimerOverrun = "CAN Timer Overrun"
                            case spiSerialTransferComplete = "SPI Serial Transfer Complete"
                            case usart0DataRegisterEmpty = "USART0, Data Register Empty"
                            case usart0DataRegisterEmpty2 = "USART0 Data Register Empty"
                            case usart0DataregisterEmpty3 = "USART0 Data register Empty"
                            case usart0TxComplete = "USART0, Tx Complete"
                            case usart0TxComplete2 = "USART0 Tx Complete"
                            case analogComparator = "Analog Comparator"
                            case adcConversionComplete = "ADC Conversion Complete"
                            case eepromReady = "EEPROM Ready"
                            case timerCounter3CaptureEvent = "Timer/Counter3 Capture Event"
                            case timerCounter3CompareMatchA = "Timer/Counter3 Compare Match A"
                            case timerCounter3CompareMatchB = "Timer/Counter3 Compare Match B"
                            case timerCounter3CompareMatchC = "Timer/Counter3 Compare Match C"
                            case timerCounter3Overflow = "Timer/Counter3 Overflow"
                            case usart1RxComplete = "USART1, Rx Complete"
                            case usart1RxComplete2 = "USART1 Rx Complete"
                            case usart1RXComplete3 = "USART1 RX complete"
                            case usart1TxComplete = "USART1, Tx Complete"
                            case usart1TxComplete2 = "USART1 Tx Complete"
                            case usart1TXComplete3 = "USART1 TX complete"
                            case twoWireSerialInterface = "2-wire Serial Interface"
                            case twoWireSerialInterface2 = "Two-wire Serial Interface" // Duplicate
                            case twoWireSerialInterface3 = "Two-Wire Serial Interface" // Duplicate
                            case twoWireSerialInterface4 = "2-wire Serial Interface        " // Duplicate
                            case storeProgramMemoryRead = "Store Program Memory Read"
                            case psc2CaptureEvent = "PSC2 Capture Event"
                            case psc2EndCycle = "PSC2 End Cycle"
                            case psc1CaptureEvent = "PSC1 Capture Event"
                            case psc1EndCycle = "PSC1 End Cycle"
                            case psc0CaptureEvent = "PSC0 Capture Event"
                            case psc0EndCycle = "PSC0 End Cycle"
                            case analogComparator0 = "Analog Comparator 0"
                            case analogComparator1 = "Analog Comparator 1"
                            case analogComparator2 = "Analog Comparator 2"
                            case timerCounter0CompareMatchA = "Timer/Counter0 Compare Match A"
                            case timerCounter0CompareMatchA2 = "TimerCounter0 Compare Match A" // Looks like a duplicate
                            case usartRxComplete = "USART, Rx Complete"
                            case usartRXComplete2 = "USART, RX Complete" // Looks like a duplicate
                            case usartRxComplete3 = "USART Rx Complete" // Looks like a duplicate
                            case usartDataRegisterEmpty = "USART Data Register Empty"  // Looks like a duplicate
                            case usartDataRegisterEmpty2 = "USART Data register Empty"  // Looks like a duplicate
                            case usartDataRegisterEmpty3 = "USART, Data Register Empty"  // Looks like a duplicate
                            case usartTxComplete = "USART, Tx Complete"
                            case usartTxComplete2 = "USART Tx Complete"
                            case usartTXComplete3 = "USART, TX Complete"
                            case watchdogTimeoutInterrupt = "Watchdog Timeout Interrupt"
                            case watchdogTimeOutInterrupt2 = "Watchdog Time-out Interrupt" // Looks like a duplicate
                            case watchdogTimeOutInterrupt3 = "Watchdog Time-Out Interrupt" // Looks like a duplicate
                            case timerCounter0CompareMatchB2 = "Timer Counter 0 Compare Match B" // Looks like a duplicate
                            case timerCounter0CompareMatchB3 = "TimerCounter0 Compare Match B" // Looks like a duplicate
                            case psc2EndOfEnhancedCycle = "PSC2 End Of Enhanced Cycle"
                            case psc0EndOfEnhancedCycle = "PSC0 End Of Enhanced Cycle"
                            case analogComparator3 = "Analog Comparator 3"
                            case spiSerialTransferComplet = "SPI Serial Transfer Complet"
                            case externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRResetSeeDatasheet = "External Pin,Power-on Reset,Brown-out Reset,Watchdog Reset,and JTAG AVR Reset. See Datasheet."
                            case externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRResetSeeDatasheet2 = "External Pin,Power-on Reset,Brown-out Reset,Watchdog Reset,and JTAG AVR Reset. See Datasheet.     "
                            case pinChangeInterruptRequest0 = "Pin Change Interrupt Request 0"
                            case pinChangeInterruptRequest1 = "Pin Change Interrupt Request 1"
                            case usbGeneralInterruptRequest = "USB General Interrupt Request"
                            case usbEndpointPipeInterruptCommunicationRequest = "USB Endpoint/Pipe Interrupt Communication Request"
                            case timerCounter2CaptureEvent = "Timer/Counter2 Capture Event"
                            case timerCounter2CompareMatchB = "Timer/Counter2 Compare Match B"
                            case timerCounter2CompareMatchC = "Timer/Counter2 Compare Match C"
                            case timerCounter0CompareMatchB = "Timer/Counter0 Compare Match B"
                            case usart1DataRegisterEmpty = "USART1 Data register Empty"
                            case usart1DataRegisterEmpty2 = "USART1, Data Register Empty" // Looks like a duplicate
                            case usart1DataRegisterEmpty3 = "USART1, Data register Empty" // Looks like a duplicate
                            case usart1DataRegisterEmpty4 = "USART1 Data Register Empty" // Looks like a duplicate
                            case timerCounter2CompareMatchA = "Timer/Counter2 Compare Match A"
                            case timerCounter1CompareMatchB = "Timer/Counter1 Compare Match B"
                            case timerCounter1CompareMatchB2 = "Timer/Counter1 Compare MatchB" // Looks like a duplicate
                            case externalPinPowerOnResetBrownOutResetAndWatchdogReset = "External Pin, Power-on Reset, Brown-out Reset and Watchdog Reset"
                            case externalPinPowerOnResetBrownOutResetAndWatchdogReset2 = "External Pin, Power-on Reset, Brown-out Reset  and Watchdog Reset" // Looks like a duplicate
                            case serialTransferComplete = "Serial Transfer Complete"
                            case storeProgramMemoryReady = "Store Program Memory Ready"
                            case batteryProtectionInterrupt = "Battery Protection Interrupt"
                            case voltageRegulatorMonitorInterrupt = "Voltage regulator monitor interrupt"
                            case timer1InputCapture = "Timer 1 Input capture"
                            case timer1CompareMatchA = "Timer 1 Compare Match A"
                            case timer1CompareMatchB = "Timer 1 Compare Match B"
                            case timer1Overflow = "Timer 1 overflow"
                            case timer0InputCapture = "Timer 0 Input Capture"
                            case timer0ComapreMatchA = "Timer 0 Comapre Match A"
                            case timer0CompareMatchB = "Timer 0 Compare Match B"
                            case timer0Overflow = "Timer 0 Overflow"
                            case spiSerialTransferComplete2 = "SPI Serial transfer complete" // Duplicate, Slight spelling change
                            case voltageADCConversionComplete = "Voltage ADC Conversion Complete"
                            case coulombCounterADCConversionComplete = "Coulomb Counter ADC Conversion Complete"
                            case coloumbCounterADCRegularCurrent = "Coloumb Counter ADC Regular Current"
                            case coloumbCounterADCAccumulator = "Coloumb Counter ADC Accumulator"
                            case pinChangeInterrupt0 = "Pin Change Interrupt 0"
                            case pinChangeInterrupt1 = "Pin Change Interrupt 1"
                            case bandgapBufferShortCircuitDetected = "Bandgap Buffer Short Circuit Detected"
                            case chargerDetect = "Charger Detect"
                            case twoWireBusConnectDisconnect = "Two-Wire Bus Connect/Disconnect"
                            case spmReady = "SPM Ready"
                            case pscFault = "PSC Fault"
                            case pscEndOfCycle = "PSC End of Cycle"
                            case timer1Counter1Overflow = "Timer1/Counter1 Overflow"
                            case canMOBBurstGeneralErrors = "CAN MOB, Burst, General Errors"
                            case canTimerOverflow = "CAN Timer Overflow"
                            case linTransferComplete = "LIN Transfer Complete"
                            case linError = "LIN Error"
                            case pinChangeInterruptRequest2 = "Pin Change Interrupt Request 2"
                            case pinChangeInterruptRequest3 = "Pin Change Interrupt Request 3"
                            case reserved1 = "Reserved1"
                            case reserved2 = "Reserved2"
                            case reserved3 = "Reserved3"
                            case reserved4 = "Reserved4"
                            case reserved5 = "Reserved5"
                            case reserved6 = "Reserved6"
                            case timerCounter4CompareMatchA = "Timer/Counter4 Compare Match A"
                            case timerCounter4CompareMatchB = "Timer/Counter4 Compare Match B"
                            case timerCounter4CompareMatchD = "Timer/Counter4 Compare Match D"
                            case timerCounter4Overflow = "Timer/Counter4 Overflow"
                            case timerCounter4FaultProtectionInterrupt = "Timer/Counter4 Fault Protection Interrupt"
                            case timerCouner0Overflow = "Timer/Couner0 Overflow"
                            case usartStartEdgeInterrupt = "USART Start Edge Interrupt"
                            case externalInterrupt0 = "External Interrupt 0"
                            case wakeupTimerOverflow = "Wakeup Timer Overflow"
                            case wakeupTimerOverflow2 = "Wakeup timer overflow"
                            case linStatusInterrupt = "LIN Status Interrupt"
                            case linErrorInterrupt = "LIN Error Interrupt"
                            case voltageADCInstantaneousConversionComplete = "Voltage ADC Instantaneous Conversion Complete"
                            case voltageADCAccumulatedConversionComplete = "Voltage ADC Accumulated Conversion Complete"
                            case cADCInstantaneousConversionComplete = "C-ADC Instantaneous Conversion Complete"
                            case cADCRegularCurrent = "C-ADC Regular Current"
                            case cADCAccumulatedConversionComplete = "C-ADC Accumulated Conversion Complete"
                            case pllLockChangeInterrupt = "PLL Lock Change Interrupt"
                            case timerCounter4CaptureEvent = "Timer/Counter4 Capture Event"
                            case timerCounter4CompareMatchC = "Timer/Counter4 Compare Match C"
                            case timerCounter5CaptureEvent = "Timer/Counter5 Capture Event"
                            case timerCounter5CompareMatchA = "Timer/Counter5 Compare Match A"
                            case timerCounter5CompareMatchB = "Timer/Counter5 Compare Match B"
                            case timerCounter5CompareMatchC = "Timer/Counter5 Compare Match C"
                            case timerCounter5Overflow = "Timer/Counter5 Overflow"
                            case trx24PLLLockInterrupt = "TRX24 - PLL lock interrupt"
                            case trx24PLLUnlockInterrupt = "TRX24 - PLL unlock interrupt"
                            case trx24ReceiveStartInterrupt = "TRX24 - Receive start interrupt"
                            case trx24RXEndInterrupt = "TRX24 - RX_END interrupt"
                            case trx24CCAEDDoneInterrupt = "TRX24 - CCA/ED done interrupt"
                            case trx24XAHAMI = "TRX24 - XAH - AMI"
                            case trx24TXEndInterrupt = "TRX24 - TX_END interrupt"
                            case trx24AwakeTranceiverIsReachingStateTRXOffF = "TRX24 AWAKE - tranceiver is reaching state TRX_OFF"
                            case symbolCounterCompareMatch1Interrupt = "Symbol counter - compare match 1 interrupt"
                            case symbolCounterCompareMatch2Interrupt = "Symbol counter - compare match 2 interrupt"
                            case symbolCounterCompareMatch3Interrupt = "Symbol counter - compare match 3 interrupt"
                            case symbolCounterOverflowInterrupt = "Symbol counter - overflow interrupt"
                            case symbolCounterBackoffInterrupt = "Symbol counter - backoff interrupt"
                            case aesEngineReadyInterrupt = "AES engine ready interrupt"
                            case batteryMonitorIndicatesSupplyVoltageBelowThreshold = "Battery monitor indicates supply voltage below threshold"
                            case trx24TXStartInterrupt = "TRX24 TX start interrupt"
                            case addressMatchInterruptOfAddressFilter0 = "Address match interrupt of address filter 0"
                            case addressMatchInterruptOfAddressFilter1 = "Address match interrupt of address filter 1"
                            case addressMatchInterruptOfAddressFilter2 = "Address match interrupt of address filter 2"
                            case addressMatchInterruptOfAddressFilter3 = "Address match interrupt of address filter 3"
                            case usart2RxComplete = "USART2, Rx Complete"
                            case usart2RxComplete2 = "USART2 Rx Complete"
                            case usart2DataRegisterEmpty = "USART2 Data register Empty"
                            case usart2TxComplete = "USART2, Tx Complete"
                            case usart2TxComplete2 = "USART2 Tx Complete"
                            case usart3RxComplete = "USART3, Rx Complete"
                            case usart3DataRegisterEmpty = "USART3 Data register Empty"
                            case usart3TxComplete = "USART3, Tx Complete"
                            case usiStartCondition = "USI Start Condition"
                            case usiOverflow = "USI Overflow"
                            case lcdStartOfFrame = "LCD Start of Frame"
                            case spi0SerialTransferComplete = "SPI0 Serial Transfer Complete"
                            case usart0RxComplete = "USART0, Rx Complete"
                            case usart0RxComplete2 = "USART0 Rx Complete"
                            case twoWireSerialInterface0 = "2-wire Serial Interface 0"
                            case usart0RXStartEdgeDetect = "USART0 RX start edge detect"
                            case usart1RXStartEdgeDetect = "USART1 RX start edge detect"
                            case pinChangeInterruptRequest4 = "Pin Change Interrupt Request 4"
                            case crystalFailureDetect = "Crystal failure detect"
                            case ptcEndOfConversion = "PTC end of conversion"
                            case ptcEndOfConversion2 = "PTC End of conversion"
                            case ptcWindowComparatorInterrupt = "PTC window comparator interrupt"
                            case spi1SerialTransferComplete = "SPI1 Serial Transfer Complete"
                            case twoWireSerialInterface1 = "2-wire Serial Interface 1"
                            case usart2RXStartEdgeDetect = "USART2 RX start edge detect"
                            case usart0StartFrameDetection = "USART0 Start frame detection"
                            case usart1StartFrameDetection = "USART1 Start frame detection"
                            case clockFailureDetectionInterrupt = "Clock failure detection interrupt"
                            case ptcWindowComparatorMode = "PTC Window comparator mode"
                            case twiTransferComplete = "TWI Transfer Complete"
                            case timerCounter1CompareMatch = "Timer/Counter 1 Compare Match"
                            case timerCounter0CompareAMatch = "Timer/Counter0 Compare A Match"
                            case timerCounter0CompareBMatch = "Timer/Counter0 Compare B Match"
                            case reserved = "RESERVED"
                            case externalResetPowerOnResetAndWatchdogReset = "External Reset, Power-on Reset and Watchdog Reset"
                            case timer0CompareMatch = "Timer 0 Compare Match"
                            case externalInterrupt1 = "External Interrupt 1"
                        }
                    }
                }
                
                struct Interfaces: Codable {
                    let interface: [Interface]
                    
                    struct Interface: Codable {
                        @Attribute var name: Name
                        @Attribute var type: InterfaceType
                        
                        enum Name: String, Codable {
                            case isp = "ISP"
                            case hvpp = "HVPP"
                            case jtag = "JTAG"
                            case debugWIRE = "debugWIRE"
                            case hvsp = "HVSP"
                            case updi = "UPDI"
                        }
                        
                        enum InterfaceType: String, Codable {
                            case isp
                            case hvpp
                            case megajtag
                            case dw
                            case hvsp
                            case updi
                        }
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
                @Attribute var caption: Caption?
                @Attribute var name: Name
                let registerGroup: [RegisterGroup]
                let valueGroup: [ValueGroup]

                enum CodingKeys: String, CodingKey {
                    case name
                    case caption
                    case registerGroup = "register-group"
                    case valueGroup = "value-group"
                }
                
                enum Caption: String, Codable {
                    case Fuses = "Fuses"
                    case Lockbits = "Lockbits"
                    case ioPort = "I/O Port"
                    case JTAGInterface = "JTAG Interface"
                    case SerialPeripheralInterface = "Serial Peripheral Interface"
                    case TwoWireSerialInterface = "Two Wire Serial Interface"
                    case USART = "USART"
                    case CPURegisters = "CPU Registers"
                    case Bootloader = "Bootloader"
                    case ExternalInterrupts = "External Interrupts"
                    case EEPROM = "EEPROM"
                    case TimerCounter8bit = "Timer/Counter, 8-bit"
                    case TimerCounter16bit = "Timer/Counter, 16-bit"
                    case TimerCounter8bitAsync = "Timer/Counter, 8-bit Async"
                    case WatchdogTimer = "Watchdog Timer"
                    case AnalogToDigitalConverter = "Analog-to-Digital Converter"
                    case AnalogToDigitalConverter2 = "Analog to Digital Converter"
                    case AnalogComparator = "Analog Comparator"
                    case ControllerAreaNetwork = "Controller Area Network"
                    case PowerStageController = "Power Stage Controller"
                    case ExtendedUSART = "Extended USART"
                    case DigitalToAnalogConverter = "Digital-to-Analog Converter"
                    case PhaseLockedLoop = "Phase Locked Loop"
                    case USBDeviceRegisters = "USB Device Registers"
                    case PS2Controller = "PS/2 Controller"
                    case USBController = "USB Controller"
                    case USBHostRegisters = "USB Host Registers"
                    case Bandgap = "Bandgap"
                    case FETControl = "FET Control"
                    case BatteryProtection = "Battery Protection"
                    case CoulombCounter = "Coulomb Counter"
                    case VoltageRegulator = "Voltage Regulator"
                    case CellBalancing = "Cell Balancing"
                    case ChargerDetect = "Charger Detect"
                    case LocalInterconnectNetwork = "Local Interconnect Network"
                    case TimerCounter10bit = "Timer/Counter, 10-bit"
                    case DeviceID = "Device ID"
                    case OtherRegisters = "Other Registers"
                    case WakeupTimer = "Wakeup Timer"
                    case LowPower24GHzTransceiver = "Low-Power 2.4 GHz Transceiver"
                    case MACSymbolCounter = "MAC Symbol Counter"
                    case FLASHController = "FLASH Controller"
                    case PowerController = "Power Controller"
                    case UniversalSerialInterface = "Universal Serial Interface"
                    case LiquidCrystalDisplay = "Liquid Crystal Display"
                    case ClockFailureDetection = "Clock Failure Detection"
                    case PeripheralTouchController = "Peripheral Touch Controller"
                    case BodInterface = "Bod interface"
                    case ConfigurableCustomLogic = "Configurable Custom Logic"
                    case ClockController = "Clock controller"
                    case CPU = "CPU"
                    case InterruptController = "Interrupt Controller"
                    case CRCSCAN = "CRCSCAN"
                    case EventSystem = "Event System"
                    case GeneralPurposeIO = "General Purpose IO"
                    case Lockbit = "Lockbit"
                    case NonVolatileMemoryController = "Non-volatile Memory Controller"
                    case IOPorts = "I/O Ports"
                    case PortMultiplexer = "Port Multiplexer"
                    case ResetController = "Reset controller"
                    case RealTimeCounter = "Real-Time Counter"
                    case SignatureRow = "Signature row"
                    case SleepController = "Sleep Controller"
                    case SystemConfigurationRegisters = "System Configuration Registers"
                    case sixteenBitTimerCounterTypeA = "16-bit Timer/Counter Type A"
                    case sixteenBitTimerTypeB = "16-bit Timer Type B"
                    case TwoWireInterface = "Two-Wire Interface"
                    case UniversalSynchronousAndAsynchronousReceiverAndTransmitter = "Universal Synchronous and Asynchronous Receiver and Transmitter"
                    case UserRow = "User Row"
                    case VirtualPorts = "Virtual Ports"
                    case VoltageReference = "Voltage reference"
                    case WatchDogTimer = "Watch-Dog Timer"
                }
                
                enum Name: String, Codable { // I think this might be identical to other "Name" lists
                    case fuse = "FUSE"
                    case lockbit = "LOCKBIT"
                    case port = "PORT"
                    case jtag = "JTAG"
                    case spi = "SPI"
                    case twi = "TWI"
                    case usart = "USART"
                    case cpu = "CPU"
                    case bootLoad = "BOOT_LOAD"
                    case exInt = "EXINT"
                    case eeprom = "EEPROM"
                    case tc8 = "TC8"
                    case tc16 = "TC16"
                    case tc8Async = "TC8_ASYNC"
                    case wdt = "WDT"
                    case adc = "ADC"
                    case ac = "AC"
                    case can = "CAN"
                    case psc = "PSC"
                    case eusart = "EUSART"
                    case dac = "DAC"
                    case pll = "PLL"
                    case usbDeivce = "USB_DEVICE"
                    case ps2 = "PS2"
                    case usbGlobal = "USB_GLOBAL"
                    case usbHost = "USB_HOST"
                    case bandgap = "BANDGAP"
                    case fet = "FET"
                    case batteryProtection = "BATTERY_PROTECTION"
                    case coulombCounter = "COULOMB_COUNTER"
                    case voltageRegulator = "VOLTAGE_REGULATOR"
                    case cellBallancing = "CELL_BALANCING"
                    case chargerDetect = "CHARGER_DETECT"
                    case linUART = "LINUART"
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
                    case cfd = "CFD"
                    case ptc = "PTC"
                    case bod = "BOD"
                    case ccl = "CCL"
                    case clkctrl = "CLKCTRL"
                    case cpuInt = "CPUINT"
                    case crcscan = "CRCSCAN"
                    case evsys = "EVSYS"
                    case gpio = "GPIO"
                    case nvmctrl = "NVMCTRL"
                    case portMUX = "PORTMUX"
                    case rstctrl = "RSTCTRL"
                    case rtc = "RTC"
                    case sigrow = "SIGROW"
                    case slpctrl = "SLPCTRL"
                    case syscfg = "SYSCFG"
                    case tca = "TCA"
                    case tcb = "TCB"
                    case userrow = "USERROW"
                    case vport = "VPORT"
                    case vREF = "VREF"
                }

                struct RegisterGroup: Codable {
                    @Attribute var name: Name
                    @Attribute var caption: Caption?
                    let register: [Register]
                    
                    enum Name: String, Codable { // Could be a duplicate list with another "Name"
                        case FUSE = "FUSE"
                        case LOCKBIT = "LOCKBIT"
                        case PORTA = "PORTA"
                        case PORTB = "PORTB"
                        case PORTC = "PORTC"
                        case PORTD = "PORTD"
                        case PORTE = "PORTE"
                        case PORTF = "PORTF"
                        case PORTG = "PORTG"
                        case JTAG = "JTAG"
                        case SPI = "SPI"
                        case TWI = "TWI"
                        case USART0 = "USART0"
                        case USART1 = "USART1"
                        case CPU = "CPU"
                        case BOOT_LOAD = "BOOT_LOAD"
                        case EXINT = "EXINT"
                        case EEPROM = "EEPROM"
                        case TC0 = "TC0"
                        case TC1 = "TC1"
                        case TC3 = "TC3"
                        case TC2 = "TC2"
                        case WDT = "WDT"
                        case ADC = "ADC"
                        case AC = "AC"
                        case CAN = "CAN"
                        case PSC0 = "PSC0"
                        case PSC2 = "PSC2"
                        case PSC1 = "PSC1"
                        case EUSART = "EUSART"
                        case DAC = "DAC"
                        case USART = "USART"
                        case PLL = "PLL"
                        case USB_DEVICE = "USB_DEVICE"
                        case PS2 = "PS2"
                        case USB_GLOBAL = "USB_GLOBAL"
                        case USB_HOST = "USB_HOST"
                        case BANDGAP = "BANDGAP"
                        case FET = "FET"
                        case BATTERY_PROTECTION = "BATTERY_PROTECTION"
                        case COULOMB_COUNTER = "COULOMB_COUNTER"
                        case VOLTAGE_REGULATOR = "VOLTAGE_REGULATOR"
                        case CELL_BALANCING = "CELL_BALANCING"
                        case CHARGER_DETECT = "CHARGER_DETECT"
                        case LINUART = "LINUART"
                        case PSC = "PSC"
                        case TC4 = "TC4"
                        case DEVICEID = "DEVICEID"
                        case MISC = "MISC"
                        case WAKEUP_TIMER = "WAKEUP_TIMER"
                        case USART0_SPI = "USART0_SPI"
                        case USART1_SPI = "USART1_SPI"
                        case TC5 = "TC5"
                        case TRX24 = "TRX24"
                        case SYMCNT = "SYMCNT"
                        case FLASH = "FLASH"
                        case PWRCTRL = "PWRCTRL"
                        case USI = "USI"
                        case LCD = "LCD"
                        case USART2 = "USART2"
                        case SPI0 = "SPI0"
                        case SPI1 = "SPI1"
                        case TWI0 = "TWI0"
                        case TWI1 = "TWI1"
                        case CFD = "CFD"
                        case USART3 = "USART3"
                        case PORTH = "PORTH"
                        case PORTJ = "PORTJ"
                        case PORTK = "PORTK"
                        case PORTL = "PORTL"
                        case BOD = "BOD"
                        case CCL = "CCL"
                        case CLKCTRL = "CLKCTRL"
                        case CPUINT = "CPUINT"
                        case CRCSCAN = "CRCSCAN"
                        case EVSYS = "EVSYS"
                        case GPIO = "GPIO"
                        case NVMCTRL = "NVMCTRL"
                        case PORT = "PORT"
                        case PORTMUX = "PORTMUX"
                        case RSTCTRL = "RSTCTRL"
                        case RTC = "RTC"
                        case SIGROW = "SIGROW"
                        case SLPCTRL = "SLPCTRL"
                        case SYSCFG = "SYSCFG"
                        case TCA = "TCA"
                        case TCB = "TCB"
                        case USERROW = "USERROW"
                        case VPORT = "VPORT"
                        case VREF = "VREF"
                    }
                    
                    enum Caption: String, Codable { // Probably the same as other Caption lists.
                        case Fuses = "Fuses"
                        case Lockbits = "Lockbits"
                        case IOPort = "I/O Port"
                        case JTAGInterface = "JTAG Interface"
                        case SerialPeripheralInterface = "Serial Peripheral Interface"
                        case TwoWireSerialInterface = "Two Wire Serial Interface"
                        case USART = "USART"
                        case CPURegisters = "CPU Registers"
                        case Bootloader = "Bootloader"
                        case ExternalInterrupts = "External Interrupts"
                        case EEPROM = "EEPROM"
                        case TimerCounter8bit = "Timer/Counter, 8-bit"
                        case TimerCounter16bit = "Timer/Counter, 16-bit"
                        case TimerCounter8bitAsync = "Timer/Counter, 8-bit Async"
                        case WatchdogTimer = "Watchdog Timer"
                        case AnalogToDigitalConverter = "Analog-to-Digital Converter"
                        case AnalogToDigitalConverter2 = "Analog to Digital Converter" // Duplicate
                        case AnalogComparator = "Analog Comparator"
                        case ControllerAreaNetwork = "Controller Area Network"
                        case PowerStageController = "Power Stage Controller"
                        case ExtendedUSART = "Extended USART"
                        case DigitalToAnalogConverter = "Digital-to-Analog Converter"
                        case PhaseLockedLoop = "Phase Locked Loop"
                        case USBDeviceRegisters = "USB Device Registers"
                        case PS2Controller = "PS/2 Controller"
                        case USBController = "USB Controller"
                        case USBHostRegisters = "USB Host Registers"
                        case Bandgap = "Bandgap"
                        case FETControl = "FET Control"
                        case BatteryProtection = "Battery Protection"
                        case CoulombCounter = "Coulomb Counter"
                        case VoltageRegulator = "Voltage Regulator"
                        case CellBalancing = "Cell Balancing"
                        case ChargerDetect = "Charger Detect"
                        case LocalInterconnectNetwork = "Local Interconnect Network"
                        case TimerCounter10bit = "Timer/Counter, 10-bit"
                        case DeviceID = "Device ID"
                        case OtherRegisters = "Other Registers"
                        case WakeupTimer = "Wakeup Timer"
                        case LowPower24GHzTransceiver = "Low-Power 2.4 GHz Transceiver"
                        case MACSymbolCounter = "MAC Symbol Counter"
                        case FLASHController = "FLASH Controller"
                        case PowerController = "Power Controller"
                        case UniversalSerialInterface = "Universal Serial Interface"
                        case LiquidCrystalDisplay = "Liquid Crystal Display"
                        case ClockFailureDetection = "Clock Failure Detection"
                        case BodInterface = "Bod interface"
                        case ConfigurableCustomLogic = "Configurable Custom Logic"
                        case ClockController = "Clock controller"
                        case CPU = "CPU"
                        case InterruptController = "Interrupt Controller"
                        case CRCSCAN = "CRCSCAN"
                        case EventSystem = "Event System"
                        case GeneralPurposeIO = "General Purpose IO"
                        case Lockbit = "Lockbit"
                        case NonVolatileMemoryController = "Non-volatile Memory Controller"
                        case IOPorts = "I/O Ports"
                        case PortMultiplexer = "Port Multiplexer"
                        case ResetController = "Reset controller"
                        case RealTimeCounter = "Real-Time Counter"
                        case SignatureRow = "Signature row"
                        case SleepController = "Sleep Controller"
                        case SystemConfigurationRegisters = "System Configuration Registers"
                        case sixteenBitTimerCounterTypeA = "16-bit Timer/Counter Type A"
                        case sixteenBitTimerTypeB = "16-bit Timer Type B"
                        case TwoWireInterface = "Two-Wire Interface"
                        case UniversalSynchronousAndAsynchronousReceiverAndTransmitter = "Universal Synchronous and Asynchronous Receiver and Transmitter"
                        case UserRow = "User Row"
                        case VirtualPorts = "Virtual Ports"
                        case Voltagereference = "Voltage reference"
                        case WatchDogTimer = "Watch-Dog Timer"
                    }

                    struct Register: Codable {
                        @Attribute var name: Name
                        @Attribute var offset: Offset
                        @Attribute var size: Size
                        @Attribute var initval: Initval?
                        @Attribute var caption: Caption?
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
                        
                        enum Name: String, Codable {
                            case EXTENDED
                            case HIGH
                            case LOW
                            case LOCKBIT
                            case PORTA
                            case DDRA
                            case PINA
                            case PORTB
                            case DDRB
                            case PINB
                            case PORTC
                            case DDRC
                            case PINC
                            case PORTD
                            case DDRD
                            case PIND
                            case PORTE
                            case DDRE
                            case PINE
                            case PORTF
                            case DDRF
                            case PINF
                            case PORTG
                            case DDRG
                            case PING
                            case OCDR
                            case MCUCR
                            case MCUSR
                            case SPCR
                            case SPSR
                            case SPDR
                            case TWBR
                            case TWCR
                            case TWSR
                            case TWDR
                            case TWAR
                            case UDR0
                            case UCSR0A
                            case UCSR0B
                            case UCSR0C
                            case UBRR0
                            case UDR1
                            case UCSR1A
                            case UCSR1B
                            case UCSR1C
                            case UBRR1
                            case SREG
                            case SP
                            case XMCRA
                            case XMCRB
                            case OSCCAL
                            case CLKPR
                            case SMCR
                            case RAMPZ
                            case GPIOR2
                            case GPIOR1
                            case GPIOR0
                            case SPMCSR
                            case EICRA
                            case EICRB
                            case EIMSK
                            case EIFR
                            case EEAR
                            case EEDR
                            case EECR
                            case TCCR0A
                            case TCNT0
                            case OCR0A
                            case TIMSK0
                            case TIFR0
                            case GTCCR
                            case TCCR1A
                            case TCCR1B
                            case TCCR1C
                            case TCNT1
                            case OCR1A
                            case OCR1B
                            case OCR1C
                            case ICR1
                            case TIMSK1
                            case TIFR1
                            case TCCR3A
                            case TCCR3B
                            case TCCR3C
                            case TCNT3
                            case OCR3A
                            case OCR3B
                            case OCR3C
                            case ICR3
                            case TIMSK3
                            case TIFR3
                            case TCCR2A
                            case TCNT2
                            case OCR2A
                            case TIMSK2
                            case TIFR2
                            case ASSR
                            case WDTCR
                            case ADMUX
                            case ADCSRA
                            case ADC
                            case ADCSRB
                            case DIDR0
                            case ACSR
                            case DIDR1
                            case CANGCON
                            case CANGSTA
                            case CANGIT
                            case CANGIE
                            case CANEN2
                            case CANEN1
                            case CANIE2
                            case CANIE1
                            case CANSIT2
                            case CANSIT1
                            case CANBT1
                            case CANBT2
                            case CANBT3
                            case CANTCON
                            case CANTIM
                            case CANTTC
                            case CANTEC
                            case CANREC
                            case CANHPMOB
                            case CANPAGE
                            case CANSTMOB
                            case CANCDMOB
                            case CANIDT4
                            case CANIDT3
                            case CANIDT2
                            case CANIDT1
                            case CANIDM4
                            case CANIDM3
                            case CANIDM2
                            case CANIDM1
                            case CANSTM
                            case CANMSG
                            case PICR0
                            case PFRC0B
                            case PFRC0A
                            case PCTL0
                            case PCNF0
                            case OCR0RB
                            case OCR0SB
                            case OCR0RA
                            case OCR0SA
                            case PSOC0
                            case PIM0
                            case PIFR0
                            case PICR2
                            case PFRC2B
                            case PFRC2A
                            case PCTL2
                            case PCNF2
                            case OCR2RB
                            case OCR2SB
                            case OCR2RA
                            case OCR2SA
                            case POM2
                            case PSOC2
                            case PIM2
                            case PIFR2
                            case PICR1
                            case PFRC1B
                            case PFRC1A
                            case PCTL1
                            case PSOC1
                            case GPIOR3
                            case PLLCSR
                            case PRR
                            case TCCR0B
                            case OCR0B
                            case AMP0CSR
                            case AMP1CSR
                            case WDTCSR
                            case AC0CON
                            case AC2CON
                            case EUDR
                            case EUCSRA
                            case EUCSRB
                            case EUCSRC
                            case MUBRR
                            case AC1CON
                            case DAC
                            case DACON
                            case UDR
                            case UCSRA
                            case UCSRB
                            case UCSRC
                            case UBRR
                            case PCNF1
                            case OCR1RB
                            case OCR1SB
                            case OCR1RA
                            case OCR1SA
                            case PIM1
                            case PIFR1
                            case AC3CON
                            case AC3ECON
                            case AC2ECON
                            case AC1ECON
                            case CLKCSR
                            case CLKSELR
                            case BGCCR
                            case BGCRR
                            case PCNFE2
                            case PASDLY2
                            case DACH
                            case DACL
                            case PICR2H
                            case PICR2L
                            case MUBRRH
                            case MUBRRL
                            case UBRRH
                            case UBRRL
                            case UEINT
                            case UEBCLX
                            case UEDATX
                            case UEIENX
                            case UESTA1X
                            case UESTA0X
                            case UECFG1X
                            case UECFG0X
                            case UECONX
                            case UERST
                            case UENUM
                            case UEINTX
                            case UDMFN
                            case UDFNUM
                            case UDADDR
                            case UDIEN
                            case UDINT
                            case UDCON
                            case USBCON
                            case REGCR
                            case UPOE
                            case PS2CON
                            case EIND
                            case PRR1
                            case PRR0
                            case CLKSTA
                            case CLKSEL1
                            case CLKSEL0
                            case DWDR
                            case PCMSK0
                            case PCMSK1
                            case PCIFR
                            case PCICR
                            case UCSR1D
                            case WDTCKD
                            case TWAMR
                            case UEBCHX
                            case OTGINT
                            case OTGIEN
                            case OTGCON
                            case OTGTCON
                            case USBINT
                            case USBSTA
                            case UHWCON
                            case UPERRX
                            case UPINT
                            case UPBCHX
                            case UPBCLX
                            case UPDATX
                            case UPIENX
                            case UPCFG2X
                            case UPSTAX
                            case UPCFG1X
                            case UPCFG0X
                            case UPCONX
                            case UPRST
                            case UPNUM
                            case UPINTX
                            case UPINRQX
                            case UHFLEN
                            case UHFNUM
                            case UHADDR
                            case UHIEN
                            case UHINT
                            case UHCON
                            case TCCR2B
                            case OCR2B
                            case SFIOR
                            case GICR
                            case GIFR
                            case TIMSK
                            case TIFR
                            case TCCR0
                            case TCCR2
                            case OCR2
                            case MCUCSR
                            case SPMCR
                            case VADMUX
                            case VADC
                            case VADCSR
                            case FCSR
                            case FOSCCAL
                            case OSICSR
                            case BPPLR
                            case BPCR
                            case BPHCTR
                            case BPOCTR
                            case BPSCTR
                            case BPCHCD
                            case BPDHCD
                            case BPCOCD
                            case BPDOCD
                            case BPSCD
                            case BPIFR
                            case BPIMSK
                            case CADCSRA
                            case CADCSRB
                            case CADIC
                            case CADAC3
                            case CADAC2
                            case CADAC1
                            case CADAC0
                            case CADRC
                            case ROCR
                            case ACMUX
                            case OCR0
                            case CADCSRC
                            case CADRCC
                            case CADRDC
                            case TWBCSR
                            case CBCR
                            case CHGDCSR
                            case BGCSR
                            case AMP2CSR
                            case LINCR
                            case LINSIR
                            case LINENIR
                            case LINERR
                            case LINBTR
                            case LINBRR
                            case LINDLR
                            case LINIDR
                            case LINSEL
                            case LINDAT
                            case PCMSK3
                            case PCMSK2
                            case PIFR
                            case PIM
                            case PMIC2
                            case PMIC1
                            case PMIC0
                            case PCTL
                            case POC
                            case PCNF
                            case PSYNC
                            case POCR_RB
                            case POCR2SB
                            case POCR2RA
                            case POCR2SA
                            case POCR1SB
                            case POCR1RA
                            case POCR1SA
                            case POCR0SB
                            case POCR0RA
                            case POCR0SA
                            case TCCR4A
                            case TCCR4B
                            case TCCR4C
                            case TCCR4D
                            case TCCR4E
                            case TCNT4
                            case TC4H
                            case OCR4A
                            case OCR4B
                            case OCR4C
                            case OCR4D
                            case TIMSK4
                            case TIFR4
                            case DT4
                            case DIDR2
                            case RCCTRL
                            case PLLFRQ
                            case EEARL
                            case EEARH
                            case DEVID0
                            case DEVID1
                            case DEVID2
                            case DEVID3
                            case DEVID4
                            case DEVID5
                            case DEVID6
                            case DEVID7
                            case DEVID8
                            case UCSR0D
                            case ACSRB
                            case UBRR0H
                            case UBRR0L
                            case UBRR1H
                            case UBRR1L
                            case XDIV
                            case ETIMSK
                            case ETIFR
                            case CANTIML
                            case CANTIMH
                            case CANTTCL
                            case CANTTCH
                            case CANSTML
                            case CANSTMH
                            case LINBRRL
                            case LINBRRH
                            case PBOV
                            case ADSCSRA
                            case ADSCSRB
                            case ADCRA
                            case ADCRB
                            case ADCRC
                            case ADCRD
                            case ADCRE
                            case ADIFR
                            case ADIMR
                            case CADRCL
                            case VADIC
                            case VADAC3
                            case VADAC2
                            case VADAC1
                            case VADAC0
                            case BGCSRA
                            case BGCRA
                            case BGCRB
                            case BGLR
                            case SOSCCALA
                            case SOSCCALB
                            case WDTCLR
                            case WUTCSR
                            case TCCR5A
                            case TCCR5B
                            case TCCR5C
                            case TCNT5
                            case OCR5A
                            case OCR5B
                            case OCR5C
                            case ICR5
                            case TIMSK5
                            case TIFR5
                            case ICR4
                            case PARCR
                            case MAFSA0L
                            case MAFSA0H
                            case MAFPA0L
                            case MAFPA0H
                            case MAFSA1L
                            case MAFSA1H
                            case MAFPA1L
                            case MAFPA1H
                            case MAFSA2L
                            case MAFSA2H
                            case MAFPA2L
                            case MAFPA2H
                            case MAFSA3L
                            case MAFSA3H
                            case MAFPA3L
                            case MAFPA3H
                            case MAFCR0
                            case MAFCR1
                            case AES_CTRL
                            case AES_STATUS
                            case AES_STATE
                            case AES_KEY
                            case TRX_STATUS
                            case TRX_STATE
                            case TRX_CTRL_0
                            case TRX_CTRL_1
                            case PHY_TX_PWR
                            case PHY_RSSI
                            case PHY_ED_LEVEL
                            case PHY_CC_CCA
                            case CCA_THRES
                            case RX_CTRL
                            case SFD_VALUE
                            case TRX_CTRL_2
                            case ANT_DIV
                            case IRQ_MASK
                            case IRQ_STATUS
                            case IRQ_MASK1
                            case IRQ_STATUS1
                            case VREG_CTRL
                            case BATMON
                            case XOSC_CTRL
                            case CC_CTRL_0
                            case CC_CTRL_1
                            case RX_SYN
                            case TRX_RPC
                            case XAH_CTRL_1
                            case FTN_CTRL
                            case PLL_CF
                            case PLL_DCU
                            case PART_NUM
                            case VERSION_NUM
                            case MAN_ID_0
                            case MAN_ID_1
                            case SHORT_ADDR_0
                            case SHORT_ADDR_1
                            case PAN_ID_0
                            case PAN_ID_1
                            case IEEE_ADDR_0
                            case IEEE_ADDR_1
                            case IEEE_ADDR_2
                            case IEEE_ADDR_3
                            case IEEE_ADDR_4
                            case IEEE_ADDR_5
                            case IEEE_ADDR_6
                            case IEEE_ADDR_7
                            case XAH_CTRL_0
                            case CSMA_SEED_0
                            case CSMA_SEED_1
                            case CSMA_BE
                            case TST_CTRL_DIGI
                            case TST_RX_LENGTH
                            case TRXFBST
                            case TRXFBEND
                            case SCTSTRHH
                            case SCTSTRHL
                            case SCTSTRLH
                            case SCTSTRLL
                            case SCOCR1HH
                            case SCOCR1HL
                            case SCOCR1LH
                            case SCOCR1LL
                            case SCOCR2HH
                            case SCOCR2HL
                            case SCOCR2LH
                            case SCOCR2LL
                            case SCOCR3HH
                            case SCOCR3HL
                            case SCOCR3LH
                            case SCOCR3LL
                            case SCTSRHH
                            case SCTSRHL
                            case SCTSRLH
                            case SCTSRLL
                            case SCBTSRHH
                            case SCBTSRHL
                            case SCBTSRLH
                            case SCBTSRLL
                            case SCCNTHH
                            case SCCNTHL
                            case SCCNTLH
                            case SCCNTLL
                            case SCIRQS
                            case SCIRQM
                            case SCSR
                            case SCCR1
                            case SCCR0
                            case SCCSR
                            case SCRSTRHH
                            case SCRSTRHL
                            case SCRSTRLH
                            case SCRSTRLL
                            case ADCSRC
                            case PRR2
                            case NEMCR
                            case BGCR
                            case TRXPR
                            case DRTRAM0
                            case DRTRAM1
                            case DRTRAM2
                            case DRTRAM3
                            case LLDRL
                            case LLDRH
                            case LLCR
                            case DPDS0
                            case DPDS1
                            case EMCUCR
                            case SPDR0
                            case SPSR0
                            case SPCR0
                            case USIDR
                            case USISR
                            case USICR
                            case LCDCRA
                            case LCDCRB
                            case LCDFRR
                            case LCDCCR
                            case LCDDR18
                            case LCDDR17
                            case LCDDR16
                            case LCDDR15
                            case LCDDR13
                            case LCDDR12
                            case LCDDR11
                            case LCDDR10
                            case LCDDR8
                            case LCDDR7
                            case LCDDR6
                            case LCDDR5
                            case LCDDR3
                            case LCDDR2
                            case LCDDR1
                            case LCDDR0
                            case UDR2
                            case UCSR2A
                            case UCSR2B
                            case UCSR2C
                            case UCSR2D
                            case UBRR2
                            case PCMSK4
                            case SPDR1
                            case SPSR1
                            case SPCR1
                            case TWAMR0
                            case TWBR0
                            case TWCR0
                            case TWSR0
                            case TWDR0
                            case TWAR0
                            case TWAMR1
                            case TWBR1
                            case TWCR1
                            case TWSR1
                            case TWDR1
                            case TWAR1
                            case XFDCSR
                            case ACSRA
                            case LCDDR08
                            case LCDDR07
                            case LCDDR06
                            case LCDDR05
                            case LCDDR03
                            case LCDDR02
                            case LCDDR01
                            case LCDDR00
                            case OCR1AL
                            case OCR1AH
                            case CBPTR
                            case BPOCD
                            case BPDUV
                            case BPIR
                            case CCSR
                            case UDR3
                            case UCSR3A
                            case UCSR3B
                            case UCSR3C
                            case UBRR3
                            case PORTH
                            case DDRH
                            case PINH
                            case PORTJ
                            case DDRJ
                            case PINJ
                            case PORTK
                            case DDRK
                            case PINK
                            case PORTL
                            case DDRL
                            case PINL
                            case CTRLA
                            case MUXCTRLA
                            case DACREF
                            case INTCTRL
                            case STATUS
                            case CTRLB
                            case CTRLC
                            case CTRLD
                            case CTRLE
                            case SAMPCTRL
                            case MUXPOS
                            case COMMAND
                            case EVCTRL
                            case INTFLAGS
                            case DBGCTRL
                            case TEMP
                            case RES
                            case WINLT
                            case WINHT
                            case CALIB
                            case VLMCTRLA
                            case SEQCTRL0
                            case SEQCTRL1
                            case INTCTRL0
                            case LUT0CTRLA
                            case LUT0CTRLB
                            case LUT0CTRLC
                            case TRUTH0
                            case LUT1CTRLA
                            case LUT1CTRLB
                            case LUT1CTRLC
                            case TRUTH1
                            case LUT2CTRLA
                            case LUT2CTRLB
                            case LUT2CTRLC
                            case TRUTH2
                            case LUT3CTRLA
                            case LUT3CTRLB
                            case LUT3CTRLC
                            case TRUTH3
                            case MCLKCTRLA
                            case MCLKCTRLB
                            case MCLKLOCK
                            case MCLKSTATUS
                            case OSC20MCTRLA
                            case OSC20MCALIBA
                            case OSC20MCALIBB
                            case OSC32KCTRLA
                            case XOSC32KCTRLA
                            case CCP
                            case SPL
                            case SPH
                            case LVL0PRI
                            case LVL1VEC
                            case STROBE
                            case CHANNEL0
                            case CHANNEL1
                            case CHANNEL2
                            case CHANNEL3
                            case CHANNEL4
                            case CHANNEL5
                            case USERCCLLUT0A
                            case USERCCLLUT0B
                            case USERCCLLUT1A
                            case USERCCLLUT1B
                            case USERCCLLUT2A
                            case USERCCLLUT2B
                            case USERCCLLUT3A
                            case USERCCLLUT3B
                            case USERADC0
                            case USEREVOUTA
                            case USEREVOUTB
                            case USEREVOUTC
                            case USEREVOUTD
                            case USEREVOUTE
                            case USEREVOUTF
                            case USERUSART0
                            case USERUSART1
                            case USERUSART2
                            case USERUSART3
                            case USERTCA0
                            case USERTCB0
                            case USERTCB1
                            case USERTCB2
                            case USERTCB3
                            case WDTCFG
                            case BODCFG
                            case OSCCFG
                            case SYSCFG0
                            case SYSCFG1
                            case APPEND
                            case BOOTEND
                            case DATA
                            case ADDR
                            case DIR
                            case DIRSET
                            case DIRCLR
                            case DIRTGL
                            case OUT
                            case OUTSET
                            case OUTCLR
                            case OUTTGL
                            case IN
                            case PORTCTRL
                            case PIN0CTRL
                            case PIN1CTRL
                            case PIN2CTRL
                            case PIN3CTRL
                            case PIN4CTRL
                            case PIN5CTRL
                            case PIN6CTRL
                            case PIN7CTRL
                            case EVSYSROUTEA
                            case CCLROUTEA
                            case USARTROUTEA
                            case TWISPIROUTEA
                            case TCAROUTEA
                            case TCBROUTEA
                            case RSTFR
                            case SWRR
                            case CLKSEL
                            case CNT
                            case PER
                            case CMP
                            case PITCTRLA
                            case PITSTATUS
                            case PITINTCTRL
                            case PITINTFLAGS
                            case PITDBGCTRL
                            case DEVICEID0
                            case DEVICEID1
                            case DEVICEID2
                            case SERNUM0
                            case SERNUM1
                            case SERNUM2
                            case SERNUM3
                            case SERNUM4
                            case SERNUM5
                            case SERNUM6
                            case SERNUM7
                            case SERNUM8
                            case SERNUM9
                            case OSCCAL32K
                            case OSCCAL16M0
                            case OSCCAL16M1
                            case OSCCAL20M0
                            case OSCCAL20M1
                            case TEMPSENSE0
                            case TEMPSENSE1
                            case OSC16ERR3V
                            case OSC16ERR5V
                            case OSC20ERR3V
                            case OSC20ERR5V
                            case CHECKSUM1
                            case REVID
                            case EXTBRK
                            case OCDM
                            case OCDMS
                            case CTRLECLR
                            case CTRLESET
                            case CTRLFCLR
                            case CTRLFSET
                            case CMP0
                            case CMP1
                            case CMP2
                            case PERBUF
                            case CMP0BUF
                            case CMP1BUF
                            case CMP2BUF
                            case LCNT
                            case HCNT
                            case LPER
                            case HPER
                            case LCMP0
                            case HCMP0
                            case LCMP1
                            case HCMP1
                            case LCMP2
                            case HCMP2
                            case CCMP
                            case DUALCTRL
                            case MCTRLA
                            case MCTRLB
                            case MSTATUS
                            case MBAUD
                            case MADDR
                            case MDATA
                            case SCTRLA
                            case SCTRLB
                            case SSTATUS
                            case SADDR
                            case SDATA
                            case SADDRMASK
                            case RXDATAL
                            case RXDATAH
                            case TXDATAL
                            case TXDATAH
                            case BAUD
                            case TXPLCTRL
                            case RXPLCTRL
                            case USERROW0
                            case USERROW1
                            case USERROW2
                            case USERROW3
                            case USERROW4
                            case USERROW5
                            case USERROW6
                            case USERROW7
                            case USERROW8
                            case USERROW9
                            case USERROW10
                            case USERROW11
                            case USERROW12
                            case USERROW13
                            case USERROW14
                            case USERROW15
                            case USERROW16
                            case USERROW17
                            case USERROW18
                            case USERROW19
                            case USERROW20
                            case USERROW21
                            case USERROW22
                            case USERROW23
                            case USERROW24
                            case USERROW25
                            case USERROW26
                            case USERROW27
                            case USERROW28
                            case USERROW29
                            case USERROW30
                            case USERROW31
                            case USERROW32
                            case USERROW33
                            case USERROW34
                            case USERROW35
                            case USERROW36
                            case USERROW37
                            case USERROW38
                            case USERROW39
                            case USERROW40
                            case USERROW41
                            case USERROW42
                            case USERROW43
                            case USERROW44
                            case USERROW45
                            case USERROW46
                            case USERROW47
                            case USERROW48
                            case USERROW49
                            case USERROW50
                            case USERROW51
                            case USERROW52
                            case USERROW53
                            case USERROW54
                            case USERROW55
                            case USERROW56
                            case USERROW57
                            case USERROW58
                            case USERROW59
                            case USERROW60
                            case USERROW61
                            case USERROW62
                            case USERROW63
                            case CHANNEL6
                            case CHANNEL7
                            case LCDDR19
                            case LCDDR14
                            case LCDDR09
                            case LCDDR04
                            case LCDDR9
                            case LCDDR4
                        }
                        
                        enum Offset: String, Codable { // TODO: convert HEX to Int?
                            case zeroX02 = "0x02"
                            case zeroX01 = "0x01"
                            case zeroX00 = "0x00"
                            case zeroX22 = "0x22"
                            case zeroX21 = "0x21"
                            case zeroX20 = "0x20"
                            case zeroX25 = "0x25"
                            case zeroX24 = "0x24"
                            case zeroX23 = "0x23"
                            case zeroX28 = "0x28"
                            case zeroX27 = "0x27"
                            case zeroX26 = "0x26"
                            case zeroX2B = "0x2B"
                            case zeroX2A = "0x2A"
                            case zeroX29 = "0x29"
                            case zeroX2E = "0x2E"
                            case zeroX2D = "0x2D"
                            case zeroX2C = "0x2C"
                            case zeroX31 = "0x31"
                            case zeroX30 = "0x30"
                            case zeroX2F = "0x2F"
                            case zeroX34 = "0x34"
                            case zeroX33 = "0x33"
                            case zeroX32 = "0x32"
                            case zeroX51 = "0x51"
                            case zeroX55 = "0x55"
                            case zeroX54 = "0x54"
                            case zeroX4C = "0x4C"
                            case zeroX4D = "0x4D"
                            case zeroX4E = "0x4E"
                            case zeroXB8 = "0xB8"
                            case zeroXBC = "0xBC"
                            case zeroXB9 = "0xB9"
                            case zeroXBB = "0xBB"
                            case zeroXBA = "0xBA"
                            case zeroXC6 = "0xC6"
                            case zeroXC0 = "0xC0"
                            case zeroXC1 = "0xC1"
                            case zeroXC2 = "0xC2"
                            case zeroXC4 = "0xC4"
                            case zeroXCE = "0xCE"
                            case zeroXC8 = "0xC8"
                            case zeroXC9 = "0xC9"
                            case zeroXCA = "0xCA"
                            case zeroXCC = "0xCC"
                            case zeroX5F = "0x5F"
                            case zeroX5D = "0x5D"
                            case zeroX74 = "0x74"
                            case zeroX75 = "0x75"
                            case zeroX66 = "0x66"
                            case zeroX61 = "0x61"
                            case zeroX53 = "0x53"
                            case zeroX5B = "0x5B"
                            case zeroX4B = "0x4B"
                            case zeroX4A = "0x4A"
                            case zeroX3E = "0x3E"
                            case zeroX57 = "0x57"
                            case zeroX69 = "0x69"
                            case zeroX6A = "0x6A"
                            case zeroX3D = "0x3D"
                            case zeroX3C = "0x3C"
                            case zeroX41 = "0x41"
                            case zeroX40 = "0x40"
                            case zeroX3F = "0x3F"
                            case zeroX44 = "0x44"
                            case zeroX46 = "0x46"
                            case zeroX47 = "0x47"
                            case zeroX6E = "0x6E"
                            case zeroX35 = "0x35"
                            case zeroX43 = "0x43"
                            case zeroX80 = "0x80"
                            case zeroX81 = "0x81"
                            case zeroX82 = "0x82"
                            case zeroX84 = "0x84"
                            case zeroX88 = "0x88"
                            case zeroX8A = "0x8A"
                            case zeroX8C = "0x8C"
                            case zeroX86 = "0x86"
                            case zeroX6F = "0x6F"
                            case zeroX36 = "0x36"
                            case zeroX90 = "0x90"
                            case zeroX91 = "0x91"
                            case zeroX92 = "0x92"
                            case zeroX94 = "0x94"
                            case zeroX98 = "0x98"
                            case zeroX9A = "0x9A"
                            case zeroX9C = "0x9C"
                            case zeroX96 = "0x96"
                            case zeroX71 = "0x71"
                            case zeroX38 = "0x38"
                            case zeroXB0 = "0xB0"
                            case zeroXB2 = "0xB2"
                            case zeroXB3 = "0xB3"
                            case zeroX70 = "0x70"
                            case zeroX37 = "0x37"
                            case zeroXB6 = "0xB6"
                            case zeroX60 = "0x60"
                            case zeroX7C = "0x7C"
                            case zeroX7A = "0x7A"
                            case zeroX78 = "0x78"
                            case zeroX7B = "0x7B"
                            case zeroX7E = "0x7E"
                            case zeroX50 = "0x50"
                            case zeroX7F = "0x7F"
                            case zeroXD8 = "0xD8"
                            case zeroXD9 = "0xD9"
                            case zeroXDA = "0xDA"
                            case zeroXDB = "0xDB"
                            case zeroXDC = "0xDC"
                            case zeroXDD = "0xDD"
                            case zeroXDE = "0xDE"
                            case zeroXDF = "0xDF"
                            case zeroXE0 = "0xE0"
                            case zeroXE1 = "0xE1"
                            case zeroXE2 = "0xE2"
                            case zeroXE3 = "0xE3"
                            case zeroXE4 = "0xE4"
                            case zeroXE5 = "0xE5"
                            case zeroXE6 = "0xE6"
                            case zeroXE8 = "0xE8"
                            case zeroXEA = "0xEA"
                            case zeroXEB = "0xEB"
                            case zeroXEC = "0xEC"
                            case zeroXED = "0xED"
                            case zeroXEE = "0xEE"
                            case zeroXEF = "0xEF"
                            case zeroXF0 = "0xF0"
                            case zeroXF1 = "0xF1"
                            case zeroXF2 = "0xF2"
                            case zeroXF3 = "0xF3"
                            case zeroXF4 = "0xF4"
                            case zeroXF5 = "0xF5"
                            case zeroXF6 = "0xF6"
                            case zeroXF7 = "0xF7"
                            case zeroXF8 = "0xF8"
                            case zeroXFA = "0xFA"
                            case zeroXD6 = "0xD6"
                            case zeroXD4 = "0xD4"
                            case zeroXD2 = "0xD2"
                            case zeroXD0 = "0xD0"
                            case zeroXA1 = "0xA1"
                            case zeroXA0 = "0xA0"
                            case zeroXFE = "0xFE"
                            case zeroXFD = "0xFD"
                            case zeroXFC = "0xFC"
                            case zeroXFB = "0xFB"
                            case zeroXA5 = "0xA5"
                            case zeroXA4 = "0xA4"
                            case zeroX3B = "0x3B"
                            case zeroX3A = "0x3A"
                            case zeroX39 = "0x39"
                            case zeroX49 = "0x49"
                            case zeroX64 = "0x64"
                            case zeroX45 = "0x45"
                            case zeroX48 = "0x48"
                            case zeroX76 = "0x76"
                            case zeroX77 = "0x77"
                            case zeroXAD = "0xAD"
                            case zeroXAF = "0xAF"
                            case zeroXAE = "0xAE"
                            case zeroXAB = "0xAB"
                            case zeroXAA = "0xAA"
                            case zeroXA3 = "0xA3"
                            case zeroXA2 = "0xA2"
                            case zeroX58 = "0x58"
                            case zeroX56 = "0x56"
                            case zeroX89 = "0x89"
                            case zeroX79 = "0x79"
                            case zeroX7D = "0x7D"
                            case zeroX83 = "0x83"
                            case zeroX87 = "0x87"
                            case zeroX85 = "0x85"
                            case zeroX68 = "0x68"
                            case zeroX63 = "0x63"
                            case zeroX62 = "0x62"
                            case zeroX42 = "0x42"
                            case zeroX6C = "0x6C"
                            case zeroX67 = "0x67"
                            case zeroX5A = "0x5A"
                            case zeroX59 = "0x59"
                            case zeroX6D = "0x6D"
                            case zeroXCD = "0xCD"
                            case zeroXC5 = "0xC5"
                            case zeroXE9 = "0xE9"
                            case zeroX5C = "0x5C"
                            case zeroX65 = "0x65"
                            case zeroXD1 = "0xD1"
                            case zeroX6B = "0x6B"
                            case zeroXCB = "0xCB"
                            case zeroXBD = "0xBD"
                            case zeroXF9 = "0xF9"
                            case zeroXD7 = "0xD7"
                            case zeroXAC = "0xAC"
                            case zeroXA9 = "0xA9"
                            case zeroXA8 = "0xA8"
                            case zeroXA7 = "0xA7"
                            case zeroXA6 = "0xA6"
                            case zeroX9F = "0x9F"
                            case zeroX9E = "0x9E"
                            case zeroXB1 = "0xB1"
                            case zeroXB4 = "0xB4"
                            case zeroX52 = "0x52"
                            case zeroX4F = "0x4F"
                            case zeroX4c = "0x4c"
                            case zeroX4d = "0x4d"
                            case zeroX4e = "0x4e"
                            case zeroXE7 = "0xE7"
                            case zeroXBE = "0xBE"
                            case zeroX95 = "0x95"
                            case zeroX97 = "0x97"
                            case zeroXCF = "0xCF"
                            case zeroXB7 = "0xB7"
                            case zeroXB5 = "0xB5"
                            case zeroXC3 = "0xC3"
                            case zeroXBF = "0xBF"
                            case zeroX72 = "0x72"
                            case zeroXC7 = "0xC7"
                            case zeroX8E = "0x8E"
                            case zeroX73 = "0x73"
                            case zeroX9B = "0x9B"
                            case zeroX9D = "0x9D"
                            case zeroX99 = "0x99"
                            case zeroX8B = "0x8B"
                            case zeroXdc = "0xdc"
                            case zeroXe0 = "0xe0"
                            case zeroXe1 = "0xe1"
                            case zeroXe2 = "0xe2"
                            case zeroXe3 = "0xe3"
                            case zeroXe4 = "0xe4"
                            case zeroXe5 = "0xe5"
                            case zeroXe6 = "0xe6"
                            case zeroXe7 = "0xe7"
                            case zeroXe8 = "0xe8"
                            case zeroXe9 = "0xe9"
                            case zeroXf1 = "0xf1"
                            case zeroXf6 = "0xf6"
                            case zeroXf5 = "0xf5"
                            case zeroXf4 = "0xf4"
                            case zeroXf3 = "0xf3"
                            case zeroXeb = "0xeb"
                            case zeroXf0 = "0xf0"
                            case zeroXef = "0xef"
                            case zeroXee = "0xee"
                            case zeroXed = "0xed"
                            case zeroXd1 = "0xd1"
                            case zeroXd3 = "0xd3"
                            case zeroXd2 = "0xd2"
                            case zeroXd4 = "0xd4"
                            case zeroXc0 = "0xc0"
                            case zeroXc1 = "0xc1"
                            case zeroXc2 = "0xc2"
                            case zeroXc3 = "0xc3"
                            case zeroXc4 = "0xc4"
                            case zeroXc5 = "0xc5"
                            case zeroXc6 = "0xc6"
                            case zeroXc7 = "0xc7"
                            case zeroXc8 = "0xc8"
                            case zeroXc9 = "0xc9"
                            case zeroXcA = "0xcA"
                            case zeroXd8 = "0xd8"
                            case zeroX120 = "0x120"
                            case zeroX121 = "0x121"
                            case zeroX122 = "0x122"
                            case zeroX124 = "0x124"
                            case zeroX128 = "0x128"
                            case zeroX12A = "0x12A"
                            case zeroX12C = "0x12C"
                            case zeroX126 = "0x126"
                            case zeroX138 = "0x138"
                            case zeroX10E = "0x10E"
                            case zeroX10F = "0x10F"
                            case zeroX110 = "0x110"
                            case zeroX111 = "0x111"
                            case zeroX112 = "0x112"
                            case zeroX113 = "0x113"
                            case zeroX114 = "0x114"
                            case zeroX115 = "0x115"
                            case zeroX116 = "0x116"
                            case zeroX117 = "0x117"
                            case zeroX118 = "0x118"
                            case zeroX119 = "0x119"
                            case zeroX11A = "0x11A"
                            case zeroX11B = "0x11B"
                            case zeroX11C = "0x11C"
                            case zeroX11D = "0x11D"
                            case zeroX10C = "0x10C"
                            case zeroX10D = "0x10D"
                            case zeroX13C = "0x13C"
                            case zeroX13D = "0x13D"
                            case zeroX13E = "0x13E"
                            case zeroX13F = "0x13F"
                            case zeroX141 = "0x141"
                            case zeroX142 = "0x142"
                            case zeroX143 = "0x143"
                            case zeroX144 = "0x144"
                            case zeroX145 = "0x145"
                            case zeroX146 = "0x146"
                            case zeroX147 = "0x147"
                            case zeroX148 = "0x148"
                            case zeroX149 = "0x149"
                            case zeroX14A = "0x14A"
                            case zeroX14B = "0x14B"
                            case zeroX14C = "0x14C"
                            case zeroX14D = "0x14D"
                            case zeroX14E = "0x14E"
                            case zeroX14F = "0x14F"
                            case zeroX150 = "0x150"
                            case zeroX151 = "0x151"
                            case zeroX152 = "0x152"
                            case zeroX153 = "0x153"
                            case zeroX154 = "0x154"
                            case zeroX155 = "0x155"
                            case zeroX156 = "0x156"
                            case zeroX157 = "0x157"
                            case zeroX158 = "0x158"
                            case zeroX15A = "0x15A"
                            case zeroX15B = "0x15B"
                            case zeroX15C = "0x15C"
                            case zeroX15D = "0x15D"
                            case zeroX15E = "0x15E"
                            case zeroX15F = "0x15F"
                            case zeroX160 = "0x160"
                            case zeroX161 = "0x161"
                            case zeroX162 = "0x162"
                            case zeroX163 = "0x163"
                            case zeroX164 = "0x164"
                            case zeroX165 = "0x165"
                            case zeroX166 = "0x166"
                            case zeroX167 = "0x167"
                            case zeroX168 = "0x168"
                            case zeroX169 = "0x169"
                            case zeroX16A = "0x16A"
                            case zeroX16B = "0x16B"
                            case zeroX16C = "0x16C"
                            case zeroX16D = "0x16D"
                            case zeroX16E = "0x16E"
                            case zeroX16F = "0x16F"
                            case zeroX176 = "0x176"
                            case zeroX17B = "0x17B"
                            case zeroX180 = "0x180"
                            case zeroX1FF = "0x1FF"
                            case zeroX139 = "0x139"
                            case zeroX135 = "0x135"
                            case zeroX134 = "0x134"
                            case zeroX133 = "0x133"
                            case zeroX132 = "0x132"
                            case zeroX130 = "0x130"
                            case zeroX131 = "0x131"
                            case zeroX12F = "0x12F"
                            case zeroX136 = "0x136"
                            case zeroX137 = "0x137"
                            case zeroXD3 = "0xD3"
                            case zeroX102 = "0x102"
                            case zeroX101 = "0x101"
                            case zeroX100 = "0x100"
                            case zeroX105 = "0x105"
                            case zeroX104 = "0x104"
                            case zeroX103 = "0x103"
                            case zeroX108 = "0x108"
                            case zeroX107 = "0x107"
                            case zeroX106 = "0x106"
                            case zeroX10B = "0x10B"
                            case zeroX10A = "0x10A"
                            case zeroX109 = "0x109"
                            case zeroX0 = "0x0"
                            case zeroX2 = "0x2"
                            case zeroX4 = "0x4"
                            case zeroX6 = "0x6"
                            case zeroX7 = "0x7"
                            case zeroX03 = "0x03"
                            case zeroX04 = "0x04"
                            case zeroX05 = "0x05"
                            case zeroX06 = "0x06"
                            case zeroX08 = "0x08"
                            case zeroX09 = "0x09"
                            case zeroX0A = "0x0A"
                            case zeroX0B = "0x0B"
                            case zeroX0C = "0x0C"
                            case zeroX0D = "0x0D"
                            case zeroX10 = "0x10"
                            case zeroX12 = "0x12"
                            case zeroX14 = "0x14"
                            case zeroX16 = "0x16"
                            case zeroX1 = "0x1"
                            case zeroX8 = "0x8"
                            case zeroX9 = "0x9"
                            case zeroXA = "0xA"
                            case zeroXB = "0xB"
                            case zeroX07 = "0x07"
                            case zeroX0E = "0x0E"
                            case zeroX0F = "0x0F"
                            case zeroX11 = "0x11"
                            case zeroX13 = "0x13"
                            case zeroX15 = "0x15"
                            case zeroX17 = "0x17"
                            case zeroX18 = "0x18"
                            case zeroX = "0x1C"
                            case zeroXD = "0xD"
                            case zeroXE = "0xE"
                            case zeroXF = "0xF"
                            case zeroX3 = "0x3"
                            case zeroX5 = "0x5"
                            case zeroX19 = "0x19"
                            case zeroX1A = "0x1A"
                            case zeroX1B = "0x1B"
                            case zeroXC = "0xC"
                            case zeroX1D = "0x1D"
                            case zeroX1E = "0x1E"
                            case zeroX1F = "0x1F"
                            case zeroXFF = "0xFF"
                        }
                        
                        enum Size: String, Codable { // TODO: I think this is the same as another location. // Guessing that this is one or two registers, basically 8 bit or 16 bit value?
                            case one = "1"
                            case two = "2"
                        }
                        
                        enum Initval: String, Codable {
                            case zeroXFF = "0xFF"
                            case zeroX99 = "0x99"
                            case zeroX62 = "0x62"
                            case zeroXF9 = "0xF9"
                            case zeroXDF = "0xDF"
                            case zeroXFD = "0xFD"
                            case zeroXD9 = "0xD9"
                            case zeroXF4 = "0xF4"
                            case zeroX5E = "0x5E"
                            case zeroXF3 = "0xF3"
                            case zeroX9B = "0x9B"
                            case zeroXE1 = "0xE1"
                            case zeroXDD = "0xDD"
                            case zeroXE9 = "0xE9"
                            case zeroXFB = "0xFB"
                            case zeroX52 = "0x52"
                            case zeroXD7 = "0xD7"
                            case zeroXFE = "0xFE"
                            case zeroX07 = "0x07"
                            case zeroXF7 = "0xF7"
                            case zeroXCD = "0xCD"
                            case zeroX00 = "0x00"
                            case zeroX01 = "0x01"
                            case zeroX05 = "0x05"
                            case zeroX11 = "0x11"
                            case zeroX02 = "0x02"
                            case zeroX7E = "0x7E"
                            case zeroXF6 = "0xF6"
                            case zeroXC5 = "0xC5"
                            case zeroXFFFF = "0xFFFF"
                            case zeroX0000 = "0x0000"
                            case zeroX03 = "0x03"
                        }
                        
                        enum Caption: String, Codable {
                            case PortADataRegister = "Port A Data Register"
                            case PortADataDirectionRegister = "Port A Data Direction Register"
                            case PortAInputPins = "Port A Input Pins"
                            case PortBDataRegister = "Port B Data Register"
                            case PortBDataDirectionRegister = "Port B Data Direction Register"
                            case PortBInputPins = "Port B Input Pins"
                            case PortCDataRegister = "Port C Data Register"
                            case PortCDataDirectionRegister = "Port C Data Direction Register"
                            case PortCInputPins = "Port C Input Pins"
                            case PortDDataRegister = "Port D Data Register"
                            case PortDDataDirectionRegister = "Port D Data Direction Register"
                            case PortDInputPins = "Port D Input Pins"
                            case DataRegisterPortE = "Data Register, Port E"
                            case DataDirectionRegisterPortE = "Data Direction Register, Port E"
                            case InputPinsPortE = "Input Pins, Port E"
                            case DataRegisterPortF = "Data Register, Port F"
                            case DataDirectionRegisterPortF = "Data Direction Register, Port F"
                            case InputPinsPortF = "Input Pins, Port F"
                            case DataRegisterPortG = "Data Register, Port G"
                            case DataDirectionRegisterPortG = "Data Direction Register, Port G"
                            case InputPinsPortG = "Input Pins, Port G"
                            case OnChipDebugRelatedRegisterInIOMemory = "On-Chip Debug Related Register in I/O Memory"
                            case MCUControlRegister = "MCU Control Register"
                            case MCUStatusRegister = "MCU Status Register"
                            case SPIControlRegister = "SPI Control Register"
                            case SPIStatusRegister = "SPI Status Register"
                            case SPIDataRegister = "SPI Data Register"
                            case TWIBitRateRegister = "TWI Bit Rate Register"
                            case TWIBitRateRegister2 = "TWI Bit Rate register" // Duplicate
                            case TWIControlRegister = "TWI Control Register"
                            case TWIStatusRegister = "TWI Status Register"
                            case TWIDataRegister = "TWI Data Register"
                            case TWIDataRegister2 = "TWI Data register" // Duplicate
                            case TWISlaveAddressregister = "TWI (Slave) Address register"
                            case USARTIODataRegister = "USART I/O Data Register"
                            case USARTControlAndStatusRegisterA = "USART Control and Status Register A"
                            case USARTControlAndStatusRegisterA2 = "USART Control and Status register A" // Duplicate
                            case USARTControlAndStatusRegisterB = "USART Control and Status Register B"
                            case USARTControlAndStatusRegisterC = "USART Control and Status Register C"
                            case USARTBaudRateRegisterTBytes = "USART Baud Rate Register t Bytes"
                            case StatusRegister = "Status Register"
                            case StackPointer = "Stack Pointer"
                            case StackPointer2 = "Stack Pointer " // Duplicate
                            case ExternalMemoryControlRegisterA = "External Memory Control Register A"
                            case ExternalMemoryControlRegisterB = "External Memory Control Register B"
                            case OscillatorCalibrationValue = "Oscillator Calibration Value"
                            case ClockPrescaleRegister = "Clock Prescale Register"
                            case ClockPrescaleRegister2 = "Clock prescale register" // Duplicate
                            case SleepModeControlRegister = "Sleep Mode Control Register"
                            case RAMPageZSelectRegisterNotUsed = "RAM Page Z Select Register - Not used."
                            case GeneralPurposeIORegister2 = "General Purpose I/O Register 2"
                            case GeneralPurposeIORegister22 = "General Purpose IO Register 2" // Duplicate
                            case GeneralPurposeIORegister1 = "General Purpose I/O Register 1"
                            case GeneralPurposeIORegister12 = "General Purpose IO Register 1" // Duplicate
                            case GeneralPurposeIORegister0 = "General Purpose I/O Register 0"
                            case GeneralPurposeIORegister02 = "General Purpose IO Register 0" // Duplicate
                            case StoreProgramMemoryControlRegister = "Store Program Memory Control Register"
                            case ExternalInterruptControlRegisterA = "External Interrupt Control Register A"
                            case ExternalInterruptControlRegisterB = "External Interrupt Control Register B"
                            case ExternalInterruptMaskRegister = "External Interrupt Mask Register"
                            case ExternalInterruptFlagRegister = "External Interrupt Flag Register"
                            case EEPROMReadWriteAccessBytes = "EEPROM Read/Write Access Bytes"
                            case EEPROMReadWriteAccessBytes2 = "EEPROM Read/Write Access  Bytes" // Duplicate
                            case EEPROMDataRegister = "EEPROM Data Register"
                            case EEPROMControlRegister = "EEPROM Control Register"
                            case TimerCounter0ControlRegister = "Timer/Counter 0 Control Register"
                            case TimerCounter0ControlRegister2 = "Timer/Counter0 Control Register" // Duplicate
                            case TimerCounter0 = "Timer/Counter0"
                            case TimerCounter02 = "Timer Counter 0" // Duplicate
                            case TimerCounter0OutputCompareRegister = "Timer/Counter 0 Output Compare Register"
                            case TimerCounter0OutputCompareRegister2 = "Timer/Counter0 Output Compare Register" // Duplicate
                            case TimerCounter0InterruptMaskRegister = "Timer/Counter0 Interrupt Mask Register"
                            case TimerCounter0InterruptFlagRegister = "Timer/Counter0 Interrupt Flag Register"
                            case TimerCounter0InterruptFlagRegister2 = "Timer/Counter0 Interrupt Flag register" // Duplicate
                            case GeneralTimerControlRegister = "General Timer/Control Register"
                            case TimerCounter1ControlRegisterA = "Timer/Counter1 Control Register A"
                            case TimerCounter1ControlRegisterA2 = "Timer/Counter 1 Control Register A" // Duplciate
                            case TimerCounter1ControlRegisterB = "Timer/Counter1 Control Register B"
                            case TimerCounter1ControlRegisterC = "Timer/Counter 1 Control Register C"
                            case TimerCounter1ControlRegisterC2 = "Timer/Counter1 Control Register C" // Duplicate
                            case TimerCounter1Bytes = "Timer/Counter1 Bytes"
                            case TimerCounter1Bytes2 = "Timer/Counter1  Bytes" // Duplicate
                            case TimerCounter1Bytes3 = "Timer Counter 1 Bytes" // Duplicate
                            case TimerCounter1Bytes4 = "Timer Counter 1  Bytes" // Duplicate
                            case TimerCounter1OutputCompareRegisterBytes = "Timer/Counter1 Output Compare Register Bytes"
                            case TimerCounter1OutputCompareRegisterBytes2 = "Timer/Counter1 Output Compare Register  Bytes" // Duplicate
                            case TimerCounter1InputCaptureRegisterBytes = "Timer/Counter1 Input Capture Register Bytes"
                            case TimerCounter1InputCaptureRegisterBytes2 = "Timer/Counter1 Input Capture Register  Bytes" // Duplicate
                            case TimerCounterInterruptMaskRegister = "Timer/Counter Interrupt Mask Register"
                            case TimerCounterInterruptMaskRegister2 = "Timer/Counter Interrupt Mask register" // Duplicate
                            case TimerCounterInterruptFlagRegister = "Timer/Counter Interrupt Flag Register"
                            case TimerCounterInterruptFlagRegister2 = "Timer/Counter Interrupt Flag register" // Duplicate
                            case TimerCounter3ControlRegisterA = "Timer/Counter3 Control Register A"
                            case TimerCounter3ControlRegisterB = "Timer/Counter3 Control Register B"
                            case TimerCounter3ControlRegisterC = "Timer/Counter 3 Control Register C"
                            case TimerCounter3ControlRegisterC2 = "Timer/Counter3 Control Register C" // Duplicate
                            case TimerCounter3Bytes = "Timer/Counter3 Bytes"
                            case TimerCounter3Bytes2 = "Timer/Counter3  Bytes"
                            case TimerCounter3OutputCompareRegisterBytes = "Timer/Counter3 Output Compare Register  Bytes"
                            case TimerCounter3OutputCompareRegisterBytes2 = "Timer/Counter3 Output Compare Register Bytes"
                            case TimerCounter3InputCaptureRegisterBytes = "Timer/Counter3 Input Capture Register Bytes"
                            case TimerCounter3InputCaptureRegisterBytes2 = "Timer/Counter3 Input Capture Register  Bytes" // Duplicate
                            case TimerCounter2ControlRegister = "Timer/Counter2 Control Register"
                            case TimerCounter2 = "Timer/Counter2"
                            case TimerCounter2OutputCompareRegister = "Timer/Counter2 Output Compare Register"
                            case GeneralTimerCounterControlRegister = "General Timer/Counter Control Register"
                            case GeneralTimerCounterControlRegister2 = "General Timer Counter Control register"  // Duplicate
                            case AsynchronousStatusRegister = "Asynchronous Status Register"
                            case WatchdogTimerControlRegister = "Watchdog Timer Control Register"
                            case TheADCMultiplexerSelectionRegister = "The ADC Multiplexer Selection Register"
                            case TheADCMultiplexerSelectionRegister2 = "The ADC multiplexer Selection Register" // Duplicate
                            case TheADCControlAndStatusRegister = "The ADC Control and Status register"
                            case ADCDataRegisterBytes = "ADC Data Register Bytes"
                            case ADCDataRegisterBytes2 = "ADC Data Register  Bytes" // Duplicate
                            case ADCControlAndStatusRegisterB = "ADC Control and Status Register B"
                            case ADCControlAndStatusRegisterB2 = "ADC Control and Status register B" // Duplicate
                            case DigitalInputDisableRegister1 = "Digital Input Disable Register 1"
                            case AnalogComparatorControlAndStatusRegister = "Analog Comparator Control And Status Register"
                            case CANGeneralControlRegister = "CAN General Control Register"
                            case CANGeneralStatusRegister = "CAN General Status Register"
                            case CANGeneralInterruptRegister = "CAN General Interrupt Register"
                            case CANGeneralInterruptEnableRegister = "CAN General Interrupt Enable Register"
                            case EnableMObRegister = "Enable MOb Register"
                            case EnableInterruptMObRegister = "Enable Interrupt MOb Register"
                            case CANStatusInterruptMObRegister = "CAN Status Interrupt MOb Register"
                            case BitTimingRegister1 = "Bit Timing Register 1"
                            case BitTimingRegister2 = "Bit Timing Register 2"
                            case BitTimingRegister3 = "Bit Timing Register 3"
                            case TimerControlRegister = "Timer Control Register"
                            case TimerRegister = "Timer Register"
                            case TTCTimerRegister = "TTC Timer Register"
                            case TransmitErrorCounterRegister = "Transmit Error Counter Register"
                            case ReceiveErrorCounterRegister = "Receive Error Counter Register"
                            case HighestPriorityMObRegister = "Highest Priority MOb Register"
                            case PageMObRegister = "Page MOb Register"
                            case MObStatusRegister = "MOb Status Register"
                            case MObControlAndDLCRegister = "MOb Control and DLC Register"
                            case IdentifierTagRegister4 = "Identifier Tag Register 4"
                            case IdentifierTagRegister3 = "Identifier Tag Register 3"
                            case IdentifierTagRegister2 = "Identifier Tag Register 2"
                            case IdentifierTagRegister1 = "Identifier Tag Register 1"
                            case IdentifierMaskRegister4 = "Identifier Mask Register 4"
                            case IdentifierMaskRegister3 = "Identifier Mask Register 3"
                            case IdentifierMaskRegister2 = "Identifier Mask Register 2"
                            case IdentifierMaskRegister1 = "Identifier Mask Register 1"
                            case TimeStampRegister = "Time Stamp Register"
                            case MessageDataRegister = "Message Data Register"
                            case EEPROMReadWriteAccessBytesOnlyBit108AreUsedInAT90CAN64OnlyBit98AreUsedInAT90CAN32 = "EEPROM Read/Write Access Bytes - Only bit 10..8 are used in AT90CAN64 - Only bit 9..8 are used in AT90CAN32"
                            case RAMPageZSelectRegister = "RAM Page Z Select Register"
                            case PortEDataRegister = "Port E Data Register"
                            case PortEDataDirectionRegister = "Port E Data Direction Register"
                            case PortEInputPins = "Port E Input Pins"
                            case PSC0InputCaptureRegister = "PSC 0 Input Capture Register"
                            case PSC0InputCaptureRegister2 = "PSC 0 Input Capture Register " // Duplicate
                            case PSC0InputBControl = "PSC 0 Input B Control"
                            case PSC0InputAControl = "PSC 0 Input A Control"
                            case PSC0ControlRegister = "PSC 0 Control Register"
                            case PSC0ConfigurationRegister = "PSC 0 Configuration Register"
                            case OutputCompareRBRegister = "Output Compare RB Register "
                            case OutputCompareSBRegister = "Output Compare SB Register "
                            case OutputCompareRARegister = "Output Compare RA Register "
                            case OutputCompareSARegister = "Output Compare SA Register "
                            case PSC0SynchroAndOutputConfiguration = "PSC0 Synchro and Output Configuration"
                            case PSC0InterruptMaskRegister = "PSC0 Interrupt Mask Register"
                            case PSC0InterruptFlagRegister = "PSC0 Interrupt Flag Register"
                            case PSC2InputCaptureRegister = "PSC 2 Input Capture Register"
                            case PSC2InputCaptureRegister2 = "PSC 2 Input Capture Register " // Duplicate
                            case PSC2InputBControl = "PSC 2 Input B Control"
                            case PSC2ControlRegister = "PSC 2 Control Register"
                            case PSC2ConfigurationRegister = "PSC 2 Configuration Register"
                            case PSC2OutputMatrix = "PSC 2 Output Matrix"
                            case PSC2SynchroAndOutputConfiguration = "PSC2 Synchro and Output Configuration"
                            case PSC2InterruptMaskRegister = "PSC2 Interrupt Mask Register"
                            case PSC2InterruptFlagRegister = "PSC2 Interrupt Flag Register"
                            case PSC1InputCaptureRegister = "PSC 1 Input Capture Register "
                            case PSC1InputBControl = "PSC 1 Input B Control"
                            case PSC1ControlRegister = "PSC 1 Control Register"
                            case PSC1SynchroAndOutputConfiguration = "PSC1 Synchro and Output Configuration"
                            case GeneralPurposeIORegister3 = "General Purpose IO Register 3"
                            case PLLControlAndStatusRegister = "PLL Control And Status Register"
                            case PLLControlAndStatusRegister2 = "PLL Control and Status Register" // Duplicate
                            case PowerReductionRegister = "Power Reduction Register"
                            case TimerCounterControlRegisterA = "Timer/Counter Control Register A"
                            case TimerCounterControlRegisterA2 = "Timer/Counter  Control Register A" // Duplicate
                            case TimerCounterControlRegisterB = "Timer/Counter Control Register B"
                            case DigitalInputDisableRegister0 = "Digital Input Disable Register 0"
                            case AnalogComparator0ControlRegister = "Analog Comparator 0 Control Register"
                            case AnalogComparator2ControlRegister = "Analog Comparator 2 Control Register"
                            case AnalogComparatorStatusRegister = "Analog Comparator Status Register"
                            case EUSARTIODataRegister = "EUSART I/O Data Register"
                            case EUSARTControlAndStatusRegisterA = "EUSART Control and Status Register A"
                            case EUSARTControlRegisterB = "EUSART Control Register B"
                            case EUSARTStatusRegisterC = "EUSART Status Register C"
                            case ManchesterReceiverBaudRateRegister = "Manchester Receiver Baud Rate Register"
                            case AnalogComparator1ControlRegister = "Analog Comparator 1 Control Register"
                            case DACDataRegister = "DAC Data Register"
                            case DACControlRegister = "DAC Control Register"
                            case USARTControlAnStatusRegisterB = "USART Control an Status register B"
                            case SARTControlAnStatusRegisterC = "USART Control an Status register C"
                            case USARTBaudRateRegister = "USART Baud Rate Register"
                            case OutputCompare0RBRegister = "Output Compare 0 RB Register"
                            case OutputCompare0SBRegister = "Output Compare 0 SB Register"
                            case OutputCompare0RARegister = "Output Compare 0 RA Register"
                            case OutputCompare0SARegister = "Output Compare 0 SA Register"
                            case OutputCompare2RBRegister = "Output Compare 2 RB Register"
                            case OutputCompare2SBRegister = "Output Compare 2 SB Register"
                            case OutputCompare2RARegister = "Output Compare 2 RA Register"
                            case OutputCompare2SARegister = "Output Compare 2 SA Register"
                            case PSC1ConfigurationRegister = "PSC 1 Configuration Register"
                            case PSC1InterruptMaskRegister = "PSC1 Interrupt Mask Register"
                            case PSC1InterruptFlagRegister = "PSC1 Interrupt Flag Register"
                            case AnalogComparator3ControlRegister = "Analog Comparator 3 Control Register"
                            case AnalogComparator3ControlRegister2 = "Analog Comparator3 Control Register"  // Duplicate
                            case BandGapCurrentCalibrationRegister = "BandGap Current Calibration Register"
                            case BandGapResistorCalibrationRegister = "BandGap Resistor Calibration Register"
                            case PSC2EnhancedConfigurationRegister = "PSC 2 Enhanced Configuration Register"
                            case AnalogSynchronizationDelayRegister = "Analog Synchronization Delay Register"
                            case DACDataRegisterHighByte = "DAC Data Register High Byte"
                            case DACDataRegisterLowByte = "DAC Data Register Low Byte"
                            case PSC2InputCaptureRegisterHigh = "PSC 2 Input Capture Register High"
                            case PSC2InputCaptureRegisterLow = "PSC 2 Input Capture Register Low"
                            case ManchesterReceiverBaudRateRegisterHighByte = "Manchester Receiver Baud Rate Register High Byte"
                            case ManchesterReceiverBaudRateRegisterLowByte = "Manchester Receiver Baud Rate Register Low Byte"
                            case DACDataRegisterBytes = "DAC Data Register Bytes"
                            case USARTBaudRateRegisterHighByte = "USART Baud Rate Register High Byte"
                            case USARTBaudRateRegisterLowByte = "USART Baud Rate Register Low Byte"
                            case EEPROMAddressRegisterLowBytes = "EEPROM Address Register Low Bytes"
                            case TimerCounter1OutputCompareRegisterABytes = "Timer/Counter1 Output Compare Register A Bytes"
                            case TimerCounter1OutputCompareRegisterABytes2 = "Timer/Counter1 Output Compare Register A  Bytes" // Duplicate
                            case TimerCounter1OutputCompareRegisterBBytes = "Timer/Counter1 Output Compare Register B Bytes"
                            case TimerCounter1OutputCompareRegisterBBytes2 = "Timer/Counter1 Output Compare Register B  Bytes" // Duplicate
                            case TimerCounter1OutputCompareRegisterCBytes = "Timer/Counter1 Output Compare Register C Bytes"
                            case TimerCounter1OutputCompareRegisterCBytes2 = "Timer/Counter1 Output Compare Register C  Bytes" // Duplicate
                            case TimerCounter1InterruptMaskRegister = "Timer/Counter1 Interrupt Mask Register"
                            case TimerCounter1InterruptFlagRegister = "Timer/Counter1 Interrupt Flag Register"
                            case TimerCounter1InterruptFlagRegister2 = "Timer/Counter1 Interrupt Flag register" // Duplicate
                            case PLLStatusAndControlRegister = "PLL Status and Control register"
                            case USBGeneralControlRegister = "USB General Control Register"
                            case RegulatorControlRegister = "Regulator Control Register"
                            case PS2PadEnableRegister = "PS2 Pad Enable register"
                            case ExtendedIndirectRegister = "Extended Indirect Register"
                            case PowerReductionRegister1 = "Power Reduction Register 1"
                            case PowerReductionRegister12 = "Power Reduction Register1" // Duplicate
                            case PowerReductionRegister0 = "Power Reduction Register 0"
                            case PowerReductionRegister02 = "Power Reduction Register0" // Duplicate
                            case debugWireCommunicationRegister = "debugWire communication register"
                            case PinChangeMaskRegister0 = "Pin Change Mask Register 0"
                            case PinChangeMaskRegister1 = "Pin Change Mask Register 1"
                            case PinChangeInterruptFlagRegister = "Pin Change Interrupt Flag Register"
                            case PinChangeInterruptControlRegister = "Pin Change Interrupt Control Register"
                            case USARTControlAndStatusRegisterD = "USART Control and Status Register D"
                            case USARTBaudRateRegisterBytes = "USART Baud Rate Register Bytes"
                            case USARTBaudRateRegisterBytes2 = "USART Baud Rate Register  Bytes"
                            case WatchdogTimerClockDivider = "Watchdog Timer Clock Divider"
                            case TWISlaveAddressMaskRegister = "TWI (Slave) Address Mask Register"
                            case USBHardwareConfigurationRegister = "USB Hardware Configuration Register"
                            case TimerCounter2ControlRegisterA = "Timer/Counter2 Control Register A"
                            case TimerCounter2ControlRegisterB = "Timer/Counter2 Control Register B"
                            case TimerCounter2OutputCompareRegisterB = "Timer/Counter2 Output Compare Register B"
                            case TimerCounter2OutputCompareRegisterA = "Timer/Counter2 Output Compare Register A"
                            case TimerCounter3OutputCompareRegisterABytes = "Timer/Counter3 Output Compare Register A Bytes"
                            case TimerCounter3OutputCompareRegisterABytes2 = "Timer/Counter3 Output Compare Register A  Bytes" // Duplicate
                            case TimerCounter3OutputCompareRegisterBBytes = "Timer/Counter3 Output Compare Register B Bytes"
                            case TimerCounter3OutputCompareRegisterBBytes2 = "Timer/Counter3 Output Compare Register B  Bytes" // Duplicate
                            case TimerCounter3InterruptMaskRegister = "Timer/Counter3 Interrupt Mask Register"
                            case TimerCounter3InterruptFlagRegister = "Timer/Counter3 Interrupt Flag Register"
                            case TimerCounter3InterruptFlagRegister2 = "Timer/Counter3 Interrupt Flag register" // Duplicate
                            case SpecialFunctionIORegister = "Special function I/O register"
                            case SpecialFunctionIORegister2 = "Special Function IO Register" // Duplicate
                            case GeneralInterruptControlRegister = "General Interrupt Control Register"
                            case GeneralInterruptFlagRegister = "General Interrupt Flag Register"
                            case USARTBaudRateRegisterHightByte = "USART Baud Rate Register Hight Byte"
                            case EEPROMAddressRegisterBytes = "EEPROM Address Register Bytes"
                            case EEPROMAddressRegisterBytes2 = "EEPROM Address Register  Bytes" // Duplicate
                            case MCUControlAndStatusRegister = "MCU Control And Status Register"
                            case TheVADCMultiplexerSelectionRegister = "The VADC multiplexer Selection Register"
                            case VADCDataRegisterBytes = "VADC Data Register Bytes"
                            case VADCDataRegisterBytes2 = "VADC Data Register  Bytes" // Duplicate
                            case TheVADCControlAndStatusRegister = "The VADC Control and Status register"
                            case BandgapCalibrationOfResistorLadder = "Bandgap Calibration of Resistor Ladder"
                            case BandgapCalibrationRegister = "Bandgap Calibration Register"
                            case ExternalInterruptControlRegister = "External Interrupt Control Register"
                            case DataRegisterPortB = "Data Register, Port B"
                            case DataDirectionRegisterPortB = "Data Direction Register, Port B"
                            case InputPinsPortB = "Input Pins, Port B"
                            case FETControlAndStatusRegister = "FET Control and Status Register"
                            case StoreProgramMemoryControlAndStatusRegister = "Store Program Memory Control and Status Register"
                            case FastOscillatorCalibrationValue = "Fast Oscillator Calibration Value"
                            case OscillatorSamplingInterfaceControlAndStatusRegister = "Oscillator Sampling Interface Control and Status Register"
                            case DigitalInputDisableRegister = "Digital Input Disable Register"
                            case BatteryProtectionParameterLockRegister = "Battery Protection Parameter Lock Register"
                            case BatteryProtectionControlRegister = "Battery Protection Control Register"
                            case BatteryProtectionShortCurrentTimingRegister = "Battery Protection Short-current Timing Register"
                            case BatteryProtectionOverCurrentTimingRegister = "Battery Protection Over-current Timing Register"
                            case BatteryProtectionChargeHighCurrentDetectionLevelRegister = "Battery Protection Charge-High-current Detection Level Register"
                            case BatteryProtectionDischargeHighCurrentDetectionLevelRegister = "Battery Protection Discharge-High-current Detection Level Register"
                            case BatteryProtectionChargeOverCurrentDetectionLevelRegister = "Battery Protection Charge-Over-current Detection Level Register"
                            case BatteryProtectionDischargeOverCurrentDetectionLevelRegister = "Battery Protection Discharge-Over-current Detection Level Register"
                            case BatteryProtectionShortCircuitDetectionLevelRegister = "Battery Protection Short-Circuit Detection Level Register"
                            case BatteryProtectionInterruptFlagRegister = "Battery Protection Interrupt Flag Register"
                            case BatteryProtectionInterruptMaskRegister = "Battery Protection Interrupt Mask Register"
                            case EEPROMReadWriteAccess = "EEPROM Read/Write Access"
                            case OutputCompareRegister1A = "Output Compare Register 1A"
                            case OutputCompareRegisterB = "Output Compare Register B"
                            case OutputCompareRegisterB2 = "Output compare Register B" // Duplicate
                            case TimerCounter0Bytes = "Timer Counter 0 Bytes"
                            case TimerCounter0Bytes2 = "Timer Counter 0  Bytes" // Duplicate
                            case OutputCompareRegisterA = "Output Compare Register A"
                            case OutputCompareRegisterA2 = "Output compare Register A" // Duplicate
                            case CCADCControlAndStatusRegisterA = "CC-ADC Control and Status Register A"
                            case CCADCControlAndStatusRegisterB = "CC-ADC Control and Status Register B"
                            case CCADCInstantaneousCurrent = "CC-ADC Instantaneous Current"
                            case ADCAccumulateCurrent = "ADC Accumulate Current"
                            case CCADCRegularCurrent = "CC-ADC Regular Current"
                            case RegulatorOperatingConditionRegister = "Regulator Operating Condition Register"
                            case USBSoftwareOutputEnableRegister = "USB Software Output Enable register"
                            case USBEndpointNumberInterruptRegister = "USB Endpoint Number Interrupt Register"
                            case USBEndpointByteCountRegister = "USB Endpoint Byte Count Register"
                            case USBDataEndpoint = "USB Data Endpoint"
                            case USBEndpointInterruptEnableRegister = "USB Endpoint Interrupt Enable Register"
                            case USBEndpointStatus1Register = "USB Endpoint Status 1 Register"
                            case USBEndpointStatus0Register = "USB Endpoint Status 0 Register"
                            case USBEndpointConfiguration1Register = "USB Endpoint Configuration 1 Register"
                            case USBEndpointConfiguration0Register = "USB Endpoint Configuration 0 Register"
                            case USBEndpointControlRegister = "USB Endpoint Control Register"
                            case USBEndpointResetRegister = "USB Endpoint Reset Register"
                            case USBEndpointNumber = "USB Endpoint Number"
                            case USBEndpointInterruptRegister = "USB Endpoint Interrupt Register"
                            case USBDeviceMicroFrameNumber = "USB Device Micro Frame Number"
                            case USBDeviceFrameNumberHighRegister = "USB Device Frame Number High Register"
                            case USBDeviceAddressRegister = "USB Device Address Register"
                            case USBDeviceInterruptEnableRegister = "USB Device Interrupt Enable Register"
                            case USBDeviceInterruptRegister = "USB Device Interrupt Register"
                            case USBDeviceControlRegisters = "USB Device Control Registers"
                            case AnalogComparatorInputMultiplexer = "Analog Comparator Input Multiplexer"
                            case TimerCounterControlRegister = "Timer/Counter Control Register"
                            case TimerCounterRegister = "Timer/Counter Register"
                            case OutputCompareRegister = "Output Compare Register"
                            case TimerCounter0Register = "Timer/Counter 0 Register"
                            case TimerCounter0Register2 = "Timer/Counter0 Register" // Duplicate
                            case OutputCompare0Register = "Output Compare 0 Register"
                            case CCADCControlAndStatusRegisterC = "CC-ADC Control and Status Register C"
                            case CCADCRegularChargeCurrent = "CC-ADC Regular Charge Current"
                            case CCADCRegularDischargeCurrent = "CC-ADC Regular Discharge Current"
                            case TWIBusControlAndStatusRegister = "TWI Bus Control and Status Register"
                            case PinChangeEnableMaskRegister1 = "Pin Change Enable Mask Register 1"
                            case PinChangeEnableMaskRegister0 = "Pin Change Enable Mask Register 0"
                            case TimerCounter0ControlRegisterB = "Timer/Counter0 Control Register B"
                            case TimerCounter0ControlRegisterA = "Timer/Counter 0 Control Register A"
                            case TimerCounter0ControlRegisterA2 = "Timer/Counter0 Control Register A" // Duplicate
                            case CellBalancingControlRegister = "Cell Balancing Control Register"
                            case ChargerDetectControlAndStatusRegister = "Charger Detect Control and Status Register"
                            case BandgapControlAndStatusRegister = "Bandgap Control and Status Register"
                            case OutputCompareRegister0A = "Output Compare Register 0A"
                            case CANGeneralInterruptRegisterFlags = "CAN General Interrupt Register Flags"
                            case EnableMObRegister2 = "Enable MOb Register 2"
                            case EnableMObRegister1Empty = "Enable MOb Register 1(empty)"
                            case EnableInterruptMObRegister2 = "Enable Interrupt MOb Register 2"
                            case EnableInterruptMObRegister1empty = "Enable Interrupt MOb Register 1 (empty)"
                            case CANStatusInterruptMObRegister2 = "CAN Status Interrupt MOb Register 2"
                            case CANStatusInterruptMObRegister1Empty = "CAN Status Interrupt MOb Register 1 (empty)"
                            case CANBitTimingRegister1 = "CAN Bit Timing Register 1"
                            case CANBitTimingRegister2 = "CAN Bit Timing Register 2"
                            case CANBitTimingRegister3 = "CAN Bit Timing Register 3"
                            case TimerCounter0OutputCompareRegisterA = "Timer/Counter0 Output Compare Register A"
                            case TimerCounter0OutputCompareRegisterB = "Timer/Counter0 Output Compare Register B"
                            case TimerCounter1OutputCompareRegisterA = "Timer/Counter1 Output Compare Register A"
                            case TimerCounter1OutputCompareRegisterB = "Timer/Counter1 Output Compare Register B"
                            case TimerCounter1InputCaptureRegister = "Timer/Counter1 Input Capture Register"
                            case Amplifier0ControlandStatusRegister = "Amplifier 0 Control and Status Register"
                            case Amplifier1ControlandStatusRegister = "Amplifier 1 Control and Status Register"
                            case Amplifier2ControlandStatusRegister = "Amplifier 2 Control and Status Register"
                            case LINControlRegister = "LIN Control Register"
                            case LINStatusAndInterruptRegister = "LIN Status and Interrupt Register"
                            case LINEnableInterruptRegister = "LIN Enable Interrupt Register"
                            case LINErrorRegister = "LIN Error Register"
                            case LINBitTimingRegister = "LIN Bit Timing Register"
                            case LINBaudRateRegister = "LIN Baud Rate Register"
                            case LINDataLengthRegister = "LIN Data Length Register"
                            case LINIdentifierRegister = "LIN Identifier Register"
                            case LINDataBufferSelectionRegister = "LIN Data Buffer Selection Register"
                            case LINDataRegister = "LIN Data Register"
                            case PinChangeMaskRegister3 = "Pin Change Mask Register 3"
                            case PinChangeMaskRegister2 = "Pin Change Mask Register 2"
                            case PSCInterruptFlagRegister = "PSC Interrupt Flag Register"
                            case PSCInterruptMaskRegister = "PSC Interrupt Mask Register"
                            case PSCModule2InputControlRegister = "PSC Module 2 Input Control Register"
                            case PSCModule1InputControlRegister = "PSC Module 1 Input Control Register"
                            case PSCModule0InputControlRegister = "PSC Module 0 Input Control Register"
                            case PSCControlRegister = "PSC Control Register"
                            case PSCOutputConfiguration = "PSC Output Configuration"
                            case PSCConfigurationRegister = "PSC Configuration Register"
                            case PSCSynchroConfiguration = "PSC Synchro Configuration"
                            case PSCOutputCompareRBRegister = "PSC Output Compare RB Register"
                            case PSCOutputCompareRBRegister2 = "PSC Output Compare RB Register " // Duplicate
                            case PSCModule2OutputCompareSBRegister = "PSC Module 2 Output Compare SB Register"
                            case PSCModule2OutputCompareSBRegister2 = "PSC Module 2 Output Compare SB Register " // Duplicate
                            case PSCModule2OutputCompareRARegister = "PSC Module 2 Output Compare RA Register"
                            case PSCModule2OutputCompareRARegister2 = "PSC Module 2 Output Compare RA Register " // Duplicate
                            case PSCModule2OutputCompareSARegister = "PSC Module 2 Output Compare SA Register"
                            case PSCModule2OutputCompareSARegister2 = "PSC Module 2 Output Compare SA Register " // Duplicate
                            case PSCModule1OutputCompareSBRegister = "PSC Module 1 Output Compare SB Register"
                            case PSCModule1OutputCompareSBRegister2 = "PSC Module 1 Output Compare SB Register " // Duplicate
                            case PSCModule1OutputCompareRARegister = "PSC Module 1 Output Compare RA Register"
                            case PSCModule1OutputCompareRARegister2 = "PSC Module 1 Output Compare RA Register " // Duplicate
                            case PSCModule1OutputCompareSARegister = "PSC Module 1 Output Compare SA Register"
                            case PSCModule0OutputCompareSBRegister = "PSC Module 0 Output Compare SB Register"
                            case PSCModule0OutputCompareRARegister = "PSC Module 0 Output Compare RA Register"
                            case PSCModule0OutputCompareRARegister2 = "PSC Module 0 Output Compare RA Register " // Duplicate
                            case PSCModule0OutputCompareSARegister = "PSC Module 0 Output Compare SA Register"
                            case PSCModule0OutputCompareSARegister2 = "PSC Module 0 Output Compare SA Register " // Duplicate
                            case TimerCounter4ControlRegisterA = "Timer/Counter4 Control Register A"
                            case TimerCounter4ControlRegisterB = "Timer/Counter4 Control Register B"
                            case TimerCounter4ControlRegisterC = "Timer/Counter 4 Control Register C"
                            case TimerCounter4ControlRegisterC2 = "Timer/Counter4 Control Register C" // Duplicate
                            case TimerCounter4ControlRegisterD = "Timer/Counter 4 Control Register D"
                            case TimerCounter4ControlRegisterE = "Timer/Counter 4 Control Register E"
                            case TimerCounter4LowBytes = "Timer/Counter4 Low Bytes"
                            case TimerCounter4 = "Timer/Counter4"
                            case TimerCounter4OutputCompareRegisterA = "Timer/Counter4 Output Compare Register A"
                            case TimerCounter4OutputCompareRegisterB = "Timer/Counter4 Output Compare Register B"
                            case TimerCounter4OutputCompareRegisterC = "Timer/Counter4 Output Compare Register C"
                            case TimerCounter4OutputCompareRegisterD = "Timer/Counter4 Output Compare Register D"
                            case TimerCounter4InterruptMaskRegister = "Timer/Counter4 Interrupt Mask Register"
                            case TimerCounter4InterruptFlagRegister = "Timer/Counter4 Interrupt Flag Register"
                            case TimerCounter4InterruptFlagRegister2 = "Timer/Counter4 Interrupt Flag register" // Duplicate
                            case TimerCounter4DeadTimeValue = "Timer/Counter 4 Dead Time Value"
                            case TimerCounter3OutputCompareRegisterCBytes = "Timer/Counter3 Output Compare Register C Bytes"
                            case TimerCounter3OutputCompareRegisterCBytes2 = "Timer/Counter3 Output Compare Register C  Bytes" // Duplicate
                            case TimerCounter3OutputCompareRegisterCBytes3 = "Timer/Counter3 Output compare Register C  Bytes" // Duplicate
                            case OscillatorControlRegister = "Oscillator Control Register"
                            case ExtendedZPointerRegisterForELPMSPM = "Extended Z-pointer Register for ELPM/SPM"
                            case PLLFrequencyControlRegister = "PLL Frequency Control Register"
                            case PSCOutputCompareSARegister = "PSC Output Compare SA Register "
                            case PSCOutputCompareSBRegister = "PSC Output Compare SB Register "
                            case DigitalInputDisableRegister2 = "Digital Input Disable Register 2"
                            case TheADCControlAndStatusRegisterA = "The ADC Control and Status Register A"
                            case TheADCControlAndStatusRegisterA2 = "The ADC Control and Status register A" // Duplicate
                            case TheADCControlAndStatusRegisterB = "The ADC Control and Status Register B"
                            case TheADCControlAndStatusRegisterB2 = "The ADC Control and Status register B" // Duplicate
                            case EEPROMAddressRegisterLowByte = "EEPROM Address Register Low Byte"
                            case EEPROMAddressRegisterHighByte = "EEPROM Address Register High Byte"
                            case AnalogComparatorStatusRegisterB = "Analog Comparator Status Register B"
                            case XTALDivideControlRegister = "XTAL Divide Control Register"
                            case AsynchronusStatusRegister = "Asynchronus Status Register"
                            case ExtendedTimerCounterInterruptMaskRegister = "Extended Timer/Counter Interrupt Mask Register"
                            case ExtendedTimerCounterInterruptFlagRegister = "Extended Timer/Counter Interrupt Flag register"
                            case TimerRegisterLow = "Timer Register Low"
                            case TimerRegisterHigh = "Timer Register High"
                            case TTCTimerRegisterLow = "TTC Timer Register Low"
                            case TTCTimerRegisterHigh = "TTC Timer Register High"
                            case TimeStampRegisterLow = "Time Stamp Register Low"
                            case TimeStampRegisterHigh = "Time Stamp Register High"
                            case LINBaudRateLowRegister = "LIN Baud Rate Low Register"
                            case LINBaudRateHighRegister = "LIN Baud Rate High Register"
                            case PortBOverride = "Port B Override"
                            case ADCSynchronizationControlAndStatusRegister = "ADC Synchronization Control and Status Register"
                            case ADCControlRegisterA = "ADC Control Register A"
                            case ADCControlRegisterB = "ADC Control Register B"
                            case ADCControlRegisterD = "ADC Control Register D"
                            case ADCControlRegisterE = "ADC Control Register E"
                            case ADCInterruptFlagRegister = "ADC Interrupt Flag Register"
                            case ADCInterruptMaskRegister = "ADC Interrupt Mask Register"
                            case CCADCRegulatorCurrentComparatorThresholdLevel = "CC-ADC Regulator Current Comparator Threshold Level"
                            case VADCInstantaneousConversionResult = "V-ADC Instantaneous Conversion Result"
                            case VADCAccumulatedConversionResult = "V-ADC Accumulated Conversion Result"
                            case CADCInstantaneousConversionResult = "C-ADC Instantaneous Conversion Result"
                            case CADCAccumulatedConversionResult = "C-ADC Accumulated Conversion Result"
                            case BandgapControlAndStatusRegisterA = "Bandgap Control and Status Register A"
                            case BandGapCalibrationRegisterA = "Band Gap Calibration Register A"
                            case BandGapCalibrationRegisterB = "Band Gap Calibration Register B"
                            case BandGapLockRegister = "Band Gap Lock Register"
                            case SlowOscillatorCalibrationRegisterA = "Slow Oscillator Calibration Register A"
                            case OscillatorCalibrationRegisterB = "Oscillator Calibration Register B"
                            case WatchdogTimerConfigurationLockRegister = "Watchdog Timer Configuration Lock Register"
                            case WakeUpTimerControlAndStatusRegister = "Wake-up Timer Control and Status Register"
                            case USART0IODataRegister = "USART0 I/O Data Register"
                            case USART0ControlAndStatusRegisterA = "USART0 Control and Status Register A"
                            case USART0ControlAndStatusRegisterB = "USART0 Control and Status Register B"
                            case USART0ControlAndStatusRegisterC = "USART0 Control and Status Register C"
                            case USART0BaudRateRegisterBytes = "USART0 Baud Rate Register  Bytes"
                            case USART1IODataRegister = "USART1 I/O Data Register"
                            case USART1ControlAndStatusRegisterA = "USART1 Control and Status Register A"
                            case USART1ControlAndStatusRegisterB = "USART1 Control and Status Register B"
                            case USART1ControlAndStatusRegisterC = "USART1 Control and Status Register C"
                            case USART1BaudRateRegisterBytes = "USART1 Baud Rate Register  Bytes"
                            case TWISlaveAddressRegister = "TWI (Slave) Address Register"
                            case USART0MSPIMControlAndStatusRegisterA = "USART0 MSPIM Control and Status Register A"
                            case USART0MSPIMControlAndStatusRegisterB = "USART0 MSPIM Control and Status Register B"
                            case USART0MSPIMControlAndStatusRegisterC = "USART0 MSPIM Control and Status Register C"
                            case USART1MSPIMControlAndStatusRegisterA = "USART1 MSPIM Control and Status Register A"
                            case USART1MSPIMControlAndStatusRegisterB = "USART1 MSPIM Control and Status Register B"
                            case USART1MSPIMControlAndStatusRegisterC = "USART1 MSPIM Control and Status Register C"
                            case PortAInputPinsAddress = "Port A Input Pins Address"
                            case PortBInputPinsAddress = "Port B Input Pins Address"
                            case PortCInputPinsAddress = "Port C Input Pins Address"
                            case PortDInputPinsAddress = "Port D Input Pins Address"
                            case PortEInputPinsAddress = "Port E Input Pins Address"
                            case PortFDataRegister = "Port F Data Register"
                            case PortFDataDirectionRegister = "Port F Data Direction Register"
                            case PortFInputPinsAddress = "Port F Input Pins Address"
                            case PortGDataRegister = "Port G Data Register"
                            case PortGDataDirectionRegister = "Port G Data Direction Register"
                            case PortGInputPinsAddress = "Port G Input Pins Address"
                            case TimerCounter5ControlRegisterA = "Timer/Counter5 Control Register A"
                            case TimerCounter5ControlRegisterB = "Timer/Counter5 Control Register B"
                            case TimerCounter5ControlRegisterC = "Timer/Counter5 Control Register C"
                            case TimerCounter5ControlRegisterC2 = "Timer/Counter 5 Control Register C" // Duplicate
                            case TimerCounter5Bytes = "Timer/Counter5  Bytes"
                            case TimerCounter5OutputCompareRegisterABytes = "Timer/Counter5 Output Compare Register A  Bytes"
                            case TimerCounter5OutputCompareRegisterBBytes = "Timer/Counter5 Output Compare Register B  Bytes"
                            case TimerCounter5OutputCompareRegisterCBytes = "Timer/Counter5 Output Compare Register C  Bytes"
                            case TimerCounter5InputCaptureRegisterBytes = "Timer/Counter5 Input Capture Register  Bytes"
                            case TimerCounter5InterruptMaskRegister = "Timer/Counter5 Interrupt Mask Register"
                            case TimerCounter5InterruptFlagRegister = "Timer/Counter5 Interrupt Flag Register"
                            case TimerCounter5InterruptFlagRegister2 = "Timer/Counter5 Interrupt Flag register" // Duplicate
                            case TimerCounter4Bytes = "Timer/Counter4 Bytes"
                            case TimerCounter4Bytes2 = "Timer/Counter4  Bytes" // Duplicate
                            case TimerCounter4OutputCompareRegisterABytes = "Timer/Counter4 Output Compare Register A  Bytes"
                            case TimerCounter4OutputCompareRegisterABytes2 = "Timer/Counter4 Output Compare Register A Bytes" // Duplicate
                            case TimerCounter4OutputCompareRegisterBBytes = "Timer/Counter4 Output Compare Register B  Bytes"
                            case TimerCounter4OutputCompareRegisterBBytes2 = "Timer/Counter4 Output Compare Register B Bytes" // Duplicate
                            case TimerCounter4OutputCompareRegisterCBytes = "Timer/Counter4 Output Compare Register C  Bytes"
                            case TimerCounter4InputCaptureRegisterBytes = "Timer/Counter4 Input Capture Register  Bytes"
                            case TimerCounter4InputCaptureRegisterBytes2 = "Timer/Counter4 Input Capture Register Bytes" // Duplicate
                            case PowerAmplifierRampUpDownControlRegister = "Power Amplifier Ramp up/down Control Register"
                            case TransceiverMACShortAddressRegisterForFrameFilter0LowByte = "Transceiver MAC Short Address Register for Frame Filter 0 (Low Byte)"
                            case TransceiverMACShortAddressRegisterForFrameFilter0HighByte = "Transceiver MAC Short Address Register for Frame Filter 0 (High Byte)"
                            case TransceiverPersonalAreaNetworkIDRegisterForFrameFilter0LowByte = "Transceiver Personal Area Network ID Register for Frame Filter 0 (Low Byte)"
                            case TransceiverPersonalAreaNetworkIDRegisterForFrameFilter0HighByte = "Transceiver Personal Area Network ID Register for Frame Filter 0 (High Byte)"
                            case TransceiverMACShortAddressRegisterForFrameFilter1LowByte = "Transceiver MAC Short Address Register for Frame Filter 1 (Low Byte)"
                            case TransceiverMACShortAddressRegisterForFrameFilter1HighByte = "Transceiver MAC Short Address Register for Frame Filter 1 (High Byte)"
                            case TransceiverPersonalAreaNetworkIDRegisterForFrameFilter1LowByte = "Transceiver Personal Area Network ID Register for Frame Filter 1 (Low Byte)"
                            case TransceiverPersonalAreaNetworkIDRegisterForFrameFilter1HighByte = "Transceiver Personal Area Network ID Register for Frame Filter 1 (High Byte)"
                            case TransceiverMACShortAddressRegisterForFrameFilter2LowByte = "Transceiver MAC Short Address Register for Frame Filter 2 (Low Byte)"
                            case TransceiverMACShortAddressRegisterForFrameFilter2HighByte = "Transceiver MAC Short Address Register for Frame Filter 2 (High Byte)"
                            case TransceiverPersonalAreaNetworkIDRegisterForFrameFilter2LowByte = "Transceiver Personal Area Network ID Register for Frame Filter 2 (Low Byte)"
                            case TransceiverPersonalAreaNetworkIDRegisterForFrameFilter2HighByte = "Transceiver Personal Area Network ID Register for Frame Filter 2 (High Byte)"
                            case TransceiverMACShortAddressRegisterForFrameFilter3LowByte = "Transceiver MAC Short Address Register for Frame Filter 3 (Low Byte)"
                            case TransceiverMACShortAddressRegisterForFrameFilter3HighByte = "Transceiver MAC Short Address Register for Frame Filter 3 (High Byte)"
                            case TransceiverPersonalAreaNetworkIDRegisterForFrameFilter3LowByte = "Transceiver Personal Area Network ID Register for Frame Filter 3 (Low Byte)"
                            case TransceiverPersonalAreaNetworkIDRegisterForFrameFilter3HighByte = "Transceiver Personal Area Network ID Register for Frame Filter 3 (High Byte)"
                            case MultipleAddressFilterConfigurationRegister0 = "Multiple Address Filter Configuration Register 0"
                            case MultipleAddressFilterConfigurationRegister1 = "Multiple Address Filter Configuration Register 1"
                            case AESControlRegister = "AES Control Register"
                            case AESStatusRegister = "AES Status Register"
                            case AESPlainAndCipherTextBufferRegister = "AES Plain and Cipher Text Buffer Register"
                            case AESEncryptionAndDecryptionKeyBufferRegister = "AES Encryption and Decryption Key Buffer Register"
                            case TransceiverStatusRegister = "Transceiver Status Register"
                            case TransceiverStateControlRegister = "Transceiver State Control Register"
                            case Reserved = "Reserved"
                            case TransceiverControlRegister1 = "Transceiver Control Register 1"
                            case TransceiverTransmitPowerControlRegister = "Transceiver Transmit Power Control Register"
                            case ReceiverSignalStrengthIndicatorRegister = "Receiver Signal Strength Indicator Register"
                            case TransceiverEnergyDetectionLevelRegister = "Transceiver Energy Detection Level Register"
                            case TransceiverClearChannelAssessmentCCAControlRegister = "Transceiver Clear Channel Assessment (CCA) Control Register"
                            case TransceiverCCAThresholdSettingRegister = "Transceiver CCA Threshold Setting Register"
                            case TransceiverReceiveControlRegister = "Transceiver Receive Control Register"
                            case StartOfFrameDelimiterValueRegister = "Start of Frame Delimiter Value Register"
                            case TransceiverControlRegister2 = "Transceiver Control Register 2"
                            case AntennaDiversityControlRegister = "Antenna Diversity Control Register"
                            case TransceiverInterruptEnableRegister = "Transceiver Interrupt Enable Register"
                            case TransceiverInterruptStatusRegister = "Transceiver Interrupt Status Register"
                            case TransceiverInterruptEnableRegister1 = "Transceiver Interrupt Enable Register 1"
                            case TransceiverInterruptStatusRegister1 = "Transceiver Interrupt Status Register 1"
                            case VoltageRegulatorControlAndStatusRegister = "Voltage Regulator Control and Status Register"
                            case BatteryMonitorControlAndStatusRegister = "Battery Monitor Control and Status Register"
                            case CrystalOscillatorControlRegister = "Crystal Oscillator Control Register"
                            case ChannelControlRegister0 = "Channel Control Register 0"
                            case ChannelControlRegister1 = "Channel Control Register 1"
                            case TransceiverReceiverSensitivityControlRegister = "Transceiver Receiver Sensitivity Control Register"
                            case TransceiverReducedPowerConsumptionControl = "Transceiver Reduced Power Consumption Control"
                            case TransceiverAcknowledgmentFrameControlRegister1 = "Transceiver Acknowledgment Frame Control Register 1"
                            case TransceiverFilterTuningControlRegister = "Transceiver Filter Tuning Control Register"
                            case TransceiverCenterFrequencyCalibrationControlRegister = "Transceiver Center Frequency Calibration Control Register"
                            case TransceiverDelayCellCalibrationControlRegister = "Transceiver Delay Cell Calibration Control Register"
                            case DeviceIdentificationRegisterPartNumber = "Device Identification Register (Part Number)"
                            case DeviceIdentificationRegisterVersionNumber = "Device Identification Register (Version Number)"
                            case DeviceIdentificationRegisterManufactureIDLowByte = "Device Identification Register (Manufacture ID Low Byte)"
                            case DeviceIdentificationRegisterManufactureIDHighByte = "Device Identification Register (Manufacture ID High Byte)"
                            case TransceiverMACShortAddressRegisterLowByte = "Transceiver MAC Short Address Register (Low Byte)"
                            case TransceiverMACShortAddressRegisterHighByte = "Transceiver MAC Short Address Register (High Byte)"
                            case TransceiverPersonalAreaNetworkIDRegisterLowByte = "Transceiver Personal Area Network ID Register (Low Byte)"
                            case TransceiverPersonalAreaNetworkIDRegisterHighByte = "Transceiver Personal Area Network ID Register (High Byte)"
                            case TransceiverMACIEEEAddressRegister0 = "Transceiver MAC IEEE Address Register 0"
                            case TransceiverMACIEEEAddressRegister1 = "Transceiver MAC IEEE Address Register 1"
                            case TransceiverMACIEEEAddressRegister2 = "Transceiver MAC IEEE Address Register 2"
                            case TransceiverMACIEEEAddressRegister3 = "Transceiver MAC IEEE Address Register 3"
                            case TransceiverMACIEEEAddressRegister4 = "Transceiver MAC IEEE Address Register 4"
                            case TransceiverMACIEEEAddressRegister5 = "Transceiver MAC IEEE Address Register 5"
                            case TransceiverMACIEEEAddressRegister6 = "Transceiver MAC IEEE Address Register 6"
                            case TransceiverMACIEEEAddressRegister7 = "Transceiver MAC IEEE Address Register 7"
                            case TransceiverExtendedOperatingModeControlRegister = "Transceiver Extended Operating Mode Control Register"
                            case TransceiverCSMACARandomNumberGeneratorSeedRegister = "Transceiver CSMA-CA Random Number Generator Seed Register"
                            case TransceiverAcknowledgmentFrameControlRegister2 = "Transceiver Acknowledgment Frame Control Register 2"
                            case TransceiverCSMACABackOffExponentControlRegister = "Transceiver CSMA-CA Back-off Exponent Control Register"
                            case TransceiverDigitalTestControlRegister = "Transceiver Digital Test Control Register"
                            case TransceiverReceivedFrameLengthRegister = "Transceiver Received Frame Length Register"
                            case StartOfFrameBuffer = "Start of frame buffer"
                            case EndOfFrameBuffer = "End of frame buffer"
                            case SymbolCounterTransmitFrameTimestampRegisterHHByte = "Symbol Counter Transmit Frame Timestamp Register HH-Byte"
                            case SymbolCounterTransmitFrameTimestampRegisterHLByte = "Symbol Counter Transmit Frame Timestamp Register HL-Byte"
                            case SymbolCounterTransmitFrameTimestampRegisterLHByte = "Symbol Counter Transmit Frame Timestamp Register LH-Byte"
                            case SymbolCounterTransmitFrameTimestampRegisterLLByte = "Symbol Counter Transmit Frame Timestamp Register LL-Byte"
                            case SymbolCounterOutputCompareRegister1HHByte = "Symbol Counter Output Compare Register 1 HH-Byte"
                            case SymbolCounterOutputCompareRegister1HLByte = "Symbol Counter Output Compare Register 1 HL-Byte"
                            case SymbolCounterOutputCompareRegister1LHByte = "Symbol Counter Output Compare Register 1 LH-Byte"
                            case SymbolCounterOutputCompareRegister1LLByte = "Symbol Counter Output Compare Register 1 LL-Byte"
                            case SymbolCounterOutputCompareRegister2HHByte = "Symbol Counter Output Compare Register 2 HH-Byte"
                            case SymbolCounterOutputCompareRegister2HLByte = "Symbol Counter Output Compare Register 2 HL-Byte"
                            case SymbolCounterOutputCompareRegister2LHByte = "Symbol Counter Output Compare Register 2 LH-Byte"
                            case SymbolCounterOutputCompareRegister2LLByte = "Symbol Counter Output Compare Register 2 LL-Byte"
                            case SymbolCounterOutputCompareRegister3HHByte = "Symbol Counter Output Compare Register 3 HH-Byte"
                            case SymbolCounterOutputCompareRegister3HLByte = "Symbol Counter Output Compare Register 3 HL-Byte"
                            case SymbolCounterOutputCompareRegister3LHByte = "Symbol Counter Output Compare Register 3 LH-Byte"
                            case SymbolCounterOutputCompareRegister3LLByte = "Symbol Counter Output Compare Register 3 LL-Byte"
                            case SymbolCounterFrameTimestampRegisterHHByte = "Symbol Counter Frame Timestamp Register HH-Byte"
                            case SymbolCounterFrameTimestampRegisterHLByte = "Symbol Counter Frame Timestamp Register HL-Byte"
                            case SymbolCounterFrameTimestampRegisterLHByte = "Symbol Counter Frame Timestamp Register LH-Byte"
                            case SymbolCounterFrameTimestampRegisterLLByte = "Symbol Counter Frame Timestamp Register LL-Byte"
                            case SymbolCounterBeaconTimestampRegisterHHByte = "Symbol Counter Beacon Timestamp Register HH-Byte"
                            case SymbolCounterBeaconTimestampRegisterHLByte = "Symbol Counter Beacon Timestamp Register HL-Byte"
                            case SymbolCounterBeaconTimestampRegisterLHByte = "Symbol Counter Beacon Timestamp Register LH-Byte"
                            case SymbolCounterBeaconTimestampRegisterLLByte = "Symbol Counter Beacon Timestamp Register LL-Byte"
                            case SymbolCounterRegisterHHByte = "Symbol Counter Register HH-Byte"
                            case SymbolCounterRegisterHLByte = "Symbol Counter Register HL-Byte"
                            case SymbolCounterRegisterLHByte = "Symbol Counter Register LH-Byte"
                            case SymbolCounterRegisterLLByte = "Symbol Counter Register LL-Byte"
                            case SymbolCounterInterruptStatusRegister = "Symbol Counter Interrupt Status Register"
                            case SymbolCounterInterruptMaskRegister = "Symbol Counter Interrupt Mask Register"
                            case SymbolCounterStatusRegister = "Symbol Counter Status Register"
                            case SymbolCounterControlRegister1 = "Symbol Counter Control Register 1"
                            case SymbolCounterControlRegister0 = "Symbol Counter Control Register 0"
                            case SymbolCounterCompareSourceRegister = "Symbol Counter Compare Source Register"
                            case SymbolCounterReceivedFrameTimestampRegisterHHByte = "Symbol Counter Received Frame Timestamp Register HH-Byte"
                            case SymbolCounterReceivedFrameTimestampRegisterHLByte = "Symbol Counter Received Frame Timestamp Register HL-Byte"
                            case SymbolCounterReceivedFrameTimestampRegisterLHByte = "Symbol Counter Received Frame Timestamp Register LH-Byte"
                            case SymbolCounterReceivedFrameTimestampRegisterLLByte = "Symbol Counter Received Frame Timestamp Register LL-Byte"
                            case OnChipDebugRegister = "On-Chip Debug Register"
                            case TheADCControlAndStatusRegisterC = "The ADC Control and Status Register C"
                            case PowerReductionRegister2 = "Power Reduction Register 2"
                            case PowerReductionRegister22 = "Power Reduction Register2" // Duplicate
                            case FlashExtendedModeControlRegister = "Flash Extended-Mode Control-Register"
                            case ReferenceVoltageCalibrationRegister = "Reference Voltage Calibration Register"
                            case TransceiverPinRegister = "Transceiver Pin Register"
                            case DataRetentionConfigurationRegister0 = "Data Retention Configuration Register #0"
                            case DataRetentionConfigurationRegister1 = "Data Retention Configuration Register #1"
                            case DataRetentionConfigurationRegister2 = "Data Retention Configuration Register #2"
                            case DataRetentionConfigurationRegister3 = "Data Retention Configuration Register #3"
                            case LowLeakageVoltageRegulatorDataRegisterLowByte = "Low Leakage Voltage Regulator Data Register (Low-Byte)"
                            case LowLeakageVoltageRegulatorDataRegisterHighByte = "Low Leakage Voltage Regulator Data Register (High-Byte)"
                            case LowLeakageVoltageRegulatorControlRegister = "Low Leakage Voltage Regulator Control Register"
                            case PortDriverStrengthRegister0 = "Port Driver Strength Register 0"
                            case PortDriverStrengthRegister1 = "Port Driver Strength Register 1"
                            case DataRetentionConfigurationRegisterOfSRAM0 = "Data Retention Configuration Register of SRAM 0"
                            case DataRetentionConfigurationRegisterOfSRAM1 = "Data Retention Configuration Register of SRAM 1"
                            case DataRetentionConfigurationRegisterOfSRAM2 = "Data Retention Configuration Register of SRAM 2"
                            case DataRetentionConfigurationRegisterOfSRAM3 = "Data Retention Configuration Register of SRAM 3"
                            case TimerCounte3OutputCompareRegisterBBytes = "Timer/Counte3 Output Compare Register B  Bytes"
                            case USARTBaudRateRegisterHighgByte = "USART Baud Rate Register Highg Byte"
                            case ExtendedMCUControlRegister = "Extended MCU Control Register"
                            case PinChangeEnableMask = "Pin Change Enable Mask"
                            case TimerCounter2InterruptMaskRegister = "Timer/Counter2 Interrupt Mask register"
                            case TimerCounter2InterruptFlagRegister = "Timer/Counter2 Interrupt Flag Register"
                            case PortGInputPins = "Port G Input Pins"
                            case USIDataRegister = "USI Data Register"
                            case USIStatusRegister = "USI Status Register"
                            case USIControlRegister = "USI Control Register"
                            case LCDControlRegisterA = "LCD Control Register A"
                            case LCDControlAndStatusRegisterB = "LCD Control and Status Register B"
                            case LCDFrameRateRegister = "LCD Frame Rate Register"
                            case LCDContrastControlRegister = "LCD Contrast Control Register"
                            case LCDDataRegister18 = "LCD Data Register 18"
                            case LCDDataRegister17 = "LCD Data Register 17"
                            case LCDDataRegister16 = "LCD Data Register 16"
                            case LCDDataRegister15 = "LCD Data Register 15"
                            case LCDDataRegister13 = "LCD Data Register 13"
                            case LCDDataRegister12 = "LCD Data Register 12"
                            case LCDDataRegister11 = "LCD Data Register 11"
                            case LCDDataRegister10 = "LCD Data Register 10"
                            case LCDDataRegister8 = "LCD Data Register 8"
                            case LCDDataRegister7 = "LCD Data Register 7"
                            case LCDDataRegister6 = "LCD Data Register 6"
                            case LCDDataRegister5 = "LCD Data Register 5"
                            case LCDDataRegister3 = "LCD Data Register 3"
                            case LCDDataRegister2 = "LCD Data Register 2"
                            case LCDDataRegister1 = "LCD Data Register 1"
                            case LCDDataRegister0 = "LCD Data Register 0"
                            case AnalogComparatorControlAndStatusRegisterB = "Analog Comparator Control And Status Register B"
                            case AnalogComparatorControlAndStatusRegisterB2 = "Analog Comparator Control And Status Register-B" // Duplicate
                            case PinChangeMaskRegister4 = "Pin Change Mask Register 4"
                            case ADCMultiplexerSelectionRegister = "ADC multiplexer Selection Register"
                            case ADCControlAndStatusRegisterA = "ADC Control and Status register A"
                            case XOSCFailureDetectionControlAndStatusRegister = "XOSC Failure Detection Control and Status Register"
                            case USARTIODataRegister0 = "USART I/O Data Register 0"
                            case TimerCounter4OutputCompareRegisterBytes = "Timer/Counter4 Output Compare Register Bytes"
                            case AnalogComparatorControlAndStatusRegisterA = "Analog Comparator Control And Status Register-A"
                            case LCDControlAndStatusRegisterA = "LCD Control and Status Register A"
                            case OutputCompareRegister1ALowbyte = "Output Compare Register 1A Low byte"
                            case OutputCompareRegister1AHighbyte = "Output Compare Register 1A High byte"
                            case WakeUpTimerControlRegister = "Wake-up Timer Control Register"
                            case CurrentBatteryProtectionTimingRegister = "Current Battery Protection Timing Register"
                            case BatteryProtectionOverCurrentDetectionLevelRegister = "Battery Protection OverCurrent Detection Level Register"
                            case BatteryProtectionDeepUnderVoltageRegister = "Battery Protection Deep Under Voltage Register"
                            case BatteryProtectionInterruptRegister = "Battery Protection Interrupt Register"
                            case ClockControlandStatusRegister = "Clock Control and Status Register"
                            case DataRegisterPortD = "Data Register, Port D"
                            case DataDirectionRegisterPortD = "Data Direction Register, Port D"
                            case InputPinsPortD = "Input Pins, Port D"
                            case PORTHDataRegister = "PORT H Data Register"
                            case PORTHDataDirectionRegister = "PORT H Data Direction Register"
                            case PORTHInputPins = "PORT H Input Pins"
                            case PORTJDataRegister = "PORT J Data Register"
                            case PORTJDataDirectionRegister = "PORT J Data Direction Register"
                            case PORTJInputPins = "PORT J Input Pins"
                            case PORTKDataRegister = "PORT K Data Register"
                            case PORTKDataDirectionRegister = "PORT K Data Direction Register"
                            case PORTKInputPins = "PORT K Input Pins"
                            case PORTLDataRegister = "PORT L Data Register"
                            case PORTLDataDirectionRegister = "PORT L Data Direction Register"
                            case PORTLInputPins = "PORT L Input Pins"
                            case ControlA = "Control A"
                            case MuxControlA = "Mux Control A"
                            case ReferanceScaleControl = "Referance scale control"
                            case InterruptControl = "Interrupt Control"
                            case Status = "Status"
                            case ControlB = "Control B"
                            case ControlC = "Control C"
                            case ControlD = "Control D"
                            case ControlE = "Control E"
                            case SampleControl = "Sample Control"
                            case PositiveMuxInput = "Positive mux input"
                            case Command = "Command"
                            case EventControl = "Event Control"
                            case InterruptFlags = "Interrupt Flags"
                            case DebugControl = "Debug Control"
                            case DebugControl2 = "Debug control" // Duplicate
                            case TemporaryData = "Temporary Data"
                            case ADCAccumulatorResult = "ADC Accumulator Result"
                            case WindowComparatorLowThreshold = "Window comparator low threshold"
                            case WindowComparatorHighThreshold = "Window comparator high threshold"
                            case Calibration = "Calibration"
                            case VoltageLevelMonitorControl = "Voltage level monitor Control"
                            case VoltageLevelMonitorInterruptControl = "Voltage level monitor interrupt Control"
                            case VoltageLevelMonitorInterruptFlags = "Voltage level monitor interrupt Flags"
                            case VoltageLevelMonitorStatus = "Voltage level monitor status"
                            case ControlRegisterA = "Control Register A"
                            case SequentialControl0 = "Sequential Control 0"
                            case SequentialControl1 = "Sequential Control 1"
                            case InterruptControl0 = "Interrupt Control 0"
                            case LUTControl0A = "LUT Control 0 A"
                            case LUTControl0B = "LUT Control 0 B"
                            case LUTControl0C = "LUT Control 0 C"
                            case Truth0 = "Truth 0"
                            case LUTControl1A = "LUT Control 1 A"
                            case LUTControl1B = "LUT Control 1 B"
                            case LUTControl1C = "LUT Control 1 C"
                            case Truth1 = "Truth 1"
                            case LUTControl2A = "LUT Control 2 A"
                            case LUTControl2B = "LUT Control 2 B"
                            case LUTControl2C = "LUT Control 2 C"
                            case Truth2 = "Truth 2"
                            case LUTControl3A = "LUT Control 3 A"
                            case LUTControl3B = "LUT Control 3 B"
                            case LUTControl3C = "LUT Control 3 C"
                            case Truth3 = "Truth 3"
                            case MCLKControlA = "MCLK Control A"
                            case MCLKControlB = "MCLK Control B"
                            case MCLKLock = "MCLK Lock"
                            case MCLKStatus = "MCLK Status"
                            case OSC20MControlA = "OSC20M Control A"
                            case OSC20MCalibrationA = "OSC20M Calibration A"
                            case OSC20MCalibrationB = "OSC20M Calibration B"
                            case OSC32KControlA = "OSC32K Control A"
                            case XOSC32KControlA = "XOSC32K Control A"
                            case ConfigurationChangeProtection = "Configuration Change Protection"
                            case StackPointerLow = "Stack Pointer Low"
                            case StackPointerHigh = "Stack Pointer High"
                            case InterruptLevel0Priority = "Interrupt Level 0 Priority"
                            case InterruptLevel1PriorityVector = "Interrupt Level 1 Priority Vector"
                            case ChannelStrobe = "Channel Strobe"
                            case MultiplexerChannel0 = "Multiplexer Channel 0"
                            case MultiplexerChannel1 = "Multiplexer Channel 1"
                            case MultiplexerChannel2 = "Multiplexer Channel 2"
                            case MultiplexerChannel3 = "Multiplexer Channel 3"
                            case MultiplexerChannel4 = "Multiplexer Channel 4"
                            case MultiplexerChannel5 = "Multiplexer Channel 5"
                            case UserCCLLUT0EventA = "User CCL LUT0 Event A"
                            case UserCCLLUT0EventB = "User CCL LUT0 Event B"
                            case UserCCLLUT1EventA = "User CCL LUT1 Event A"
                            case UserCCLLUT1EventB = "User CCL LUT1 Event B"
                            case UserCCLLUT2EventA = "User CCL LUT2 Event A"
                            case UserCCLLUT2EventB = "User CCL LUT2 Event B"
                            case UserCCLLUT3EventA = "User CCL LUT3 Event A"
                            case UserCCLLUT3EventB = "User CCL LUT3 Event B"
                            case UserADC0 = "User ADC0"
                            case UserEVOUTPortA = "User EVOUT Port A"
                            case UserEVOUTPortB = "User EVOUT Port B"
                            case UserEVOUTPortC = "User EVOUT Port C"
                            case UserEVOUTPortD = "User EVOUT Port D"
                            case UserEVOUTPortE = "User EVOUT Port E"
                            case UserEVOUTPortF = "User EVOUT Port F"
                            case UserUSART0 = "User USART0"
                            case UserUSART1 = "User USART1"
                            case UserUSART2 = "User USART2"
                            case UserUSART3 = "User USART3"
                            case UserTCA0 = "User TCA0"
                            case UserTCB0 = "User TCB0"
                            case UserTCB1 = "User TCB1"
                            case UserTCB2 = "User TCB2"
                            case UserTCB3 = "User TCB3"
                            case WatchdogConfiguration = "Watchdog Configuration"
                            case BODConfiguration = "BOD Configuration"
                            case OscillatorConfiguration = "Oscillator Configuration"
                            case SystemConfiguration0 = "System Configuration 0"
                            case SystemConfiguration1 = "System Configuration 1"
                            case ApplicationCodeSectionEnd = "Application Code Section End"
                            case BootSectionEnd = "Boot Section End"
                            case LockBits = "Lock Bits"
                            case Data = "Data"
                            case Address = "Address"
                            case DataDirection = "Data Direction"
                            case DataDirectionSet = "Data Direction Set"
                            case DataDirectionClear = "Data Direction Clear"
                            case DataDirectionToggle = "Data Direction Toggle"
                            case OutputValue = "Output Value"
                            case OutputValueSet = "Output Value Set"
                            case OutputValueClear = "Output Value Clear"
                            case OutputValueToggle = "Output Value Toggle"
                            case InputValue = "Input Value"
                            case PortControl = "Port Control"
                            case Pin0Control = "Pin 0 Control"
                            case Pin1Control = "Pin 1 Control"
                            case Pin2Control = "Pin 2 Control"
                            case Pin3Control = "Pin 3 Control"
                            case Pin4Control = "Pin 4 Control"
                            case Pin5Control = "Pin 5 Control"
                            case Pin6Control = "Pin 6 Control"
                            case Pin7Control = "Pin 7 Control"
                            case PortMultiplexerEVSYS = "Port Multiplexer EVSYS"
                            case PortMultiplexerCCL = "Port Multiplexer CCL"
                            case PortMultiplexerUSARTRegisterA = "Port Multiplexer USART register A"
                            case PortMultiplexerTWIAndSPI = "Port Multiplexer TWI and SPI"
                            case PortMultiplexerTCA = "Port Multiplexer TCA"
                            case PortMultiplexerTCB = "Port Multiplexer TCB"
                            case ResetFlags = "Reset Flags"
                            case SoftwareReset = "Software Reset"
                            case Temporary = "Temporary"
                            case ClockSelect = "Clock Select"
                            case Counter = "Counter"
                            case Period = "Period"
                            case Compare = "Compare"
                            case PITControlA = "PIT Control A"
                            case PITStatus = "PIT Status"
                            case PITInterruptControl = "PIT Interrupt Control"
                            case PITInterruptFlags = "PIT Interrupt Flags"
                            case PITDebugControl = "PIT Debug control"
                            case DeviceIDByte0 = "Device ID Byte 0"
                            case DeviceIDByte1 = "Device ID Byte 1"
                            case DeviceIDByte2 = "Device ID Byte 2"
                            case SerialNumberByte0 = "Serial Number Byte 0"
                            case SerialNumberByte1 = "Serial Number Byte 1"
                            case SerialNumberByte2 = "Serial Number Byte 2"
                            case SerialNumberByte3 = "Serial Number Byte 3"
                            case SerialNumberByte4 = "Serial Number Byte 4"
                            case SerialNumberByte5 = "Serial Number Byte 5"
                            case SerialNumberByte6 = "Serial Number Byte 6"
                            case SerialNumberByte7 = "Serial Number Byte 7"
                            case SerialNumberByte8 = "Serial Number Byte 8"
                            case SerialNumberByte9 = "Serial Number Byte 9"
                            case OscillatorCalibrationFor32kHzULP = "Oscillator Calibration for 32kHz ULP"
                            case OscillatorCalibration16MHzByte0 = "Oscillator Calibration 16 MHz Byte 0"
                            case OscillatorCalibration16MHzByte1 = "Oscillator Calibration 16 MHz Byte 1"
                            case OscillatorCalibration20MHzByte0 = "Oscillator Calibration 20 MHz Byte 0"
                            case OscillatorCalibration20MHzByte1 = "Oscillator Calibration 20 MHz Byte 1"
                            case TemperatureSensorCalibrationByte0 = "Temperature Sensor Calibration Byte 0"
                            case TemperatureSensorCalibrationByte1 = "Temperature Sensor Calibration Byte 1"
                            case OSC16ErrorAt3V = "OSC16 error at 3V"
                            case OSC16ErrorAt5V = "OSC16 error at 5V"
                            case OSC20ErrorAt3V = "OSC20 error at 3V"
                            case OSC20ErrorAt5V = "OSC20 error at 5V"
                            case CRCChecksumByte1 = "CRC Checksum Byte 1"
                            case Control = "Control"
                            case RevisionID = "Revision ID"
                            case ExternalBreak = "External Break"
                            case OCDMessageRegister = "OCD Message Register"
                            case OCDMessageStatus = "OCD Message Status"
                            case ControlEClear = "Control E Clear"
                            case ControlESet = "Control E Set"
                            case ControlFClear = "Control F Clear"
                            case ControlFSet = "Control F Set"
                            case DegbugControl = "Degbug Control"
                            case TemporaryDataFor16BitAccess = "Temporary data for 16-bit Access"
                            case Count = "Count"
                            case Compare0 = "Compare 0"
                            case Compare1 = "Compare 1"
                            case Compare2 = "Compare 2"
                            case PeriodBuffer = "Period Buffer"
                            case Compare0Buffer = "Compare 0 Buffer"
                            case Compare1Buffer = "Compare 1 Buffer"
                            case Compare2Buffer = "Compare 2 Buffer"
                            case LowCount = "Low Count"
                            case HighCount = "High Count"
                            case LowPeriod = "Low Period"
                            case HighPeriod = "High Period"
                            case LowCompare = "Low Compare"
                            case HighCompare = "High Compare"
                            case ControlRegisterB = "Control Register B"
                            case TemporaryValue = "Temporary Value"
                            case CompareOrCapture = "Compare or Capture"
                            case DualControl = "Dual Control"
                            case DebugControlRegister = "Debug Control Register"
                            case HostControlA = "Host Control A"
                            case HostControlB = "Host Control B"
                            case HostStatus = "Host Status"
                            case HostBaudRateControl = "Host Baud Rate Control"
                            case HostAddress = "Host Address"
                            case HostData = "Host Data"
                            case ClientControlA = "Client Control A"
                            case ClientControlB = "Client Control B"
                            case ClientStatus = "Client Status"
                            case ClientAddress = "Client Address"
                            case ClientData = "Client Data"
                            case ClientAddressMask = "Client Address Mask"
                            case ReceiveDataLowByte = "Receive Data Low Byte"
                            case ReceiveDataHighByte = "Receive Data High Byte"
                            case TransmitDataLowByte = "Transmit Data Low Byte"
                            case TransmitDataHighByte = "Transmit Data High Byte"
                            case BaudRate = "Baud Rate"
                            case IRCOMTransmitterPulseLengthControl = "IRCOM Transmitter Pulse Length Control"
                            case IRCOMReceiverPulseLengthControl = "IRCOM Receiver Pulse Length Control"
                            case UserRowByte0 = "User Row Byte 0"
                            case UserRowByte1 = "User Row Byte 1"
                            case UserRowByte2 = "User Row Byte 2"
                            case UserRowByte3 = "User Row Byte 3"
                            case UserRowByte4 = "User Row Byte 4"
                            case UserRowByte5 = "User Row Byte 5"
                            case UserRowByte6 = "User Row Byte 6"
                            case UserRowByte7 = "User Row Byte 7"
                            case UserRowByte8 = "User Row Byte 8"
                            case UserRowByte9 = "User Row Byte 9"
                            case UserRowByte10 = "User Row Byte 10"
                            case UserRowByte11 = "User Row Byte 11"
                            case UserRowByte12 = "User Row Byte 12"
                            case UserRowByte13 = "User Row Byte 13"
                            case UserRowByte14 = "User Row Byte 14"
                            case UserRowByte15 = "User Row Byte 15"
                            case UserRowByte16 = "User Row Byte 16"
                            case UserRowByte17 = "User Row Byte 17"
                            case UserRowByte18 = "User Row Byte 18"
                            case UserRowByte19 = "User Row Byte 19"
                            case UserRowByte20 = "User Row Byte 20"
                            case UserRowByte21 = "User Row Byte 21"
                            case UserRowByte22 = "User Row Byte 22"
                            case UserRowByte23 = "User Row Byte 23"
                            case UserRowByte24 = "User Row Byte 24"
                            case UserRowByte25 = "User Row Byte 25"
                            case UserRowByte26 = "User Row Byte 26"
                            case UserRowByte27 = "User Row Byte 27"
                            case UserRowByte28 = "User Row Byte 28"
                            case UserRowByte29 = "User Row Byte 29"
                            case UserRowByte30 = "User Row Byte 30"
                            case UserRowByte31 = "User Row Byte 31"
                            case UserRowByte32 = "User Row Byte 32"
                            case UserRowByte33 = "User Row Byte 33"
                            case UserRowByte34 = "User Row Byte 34"
                            case UserRowByte35 = "User Row Byte 35"
                            case UserRowByte36 = "User Row Byte 36"
                            case UserRowByte37 = "User Row Byte 37"
                            case UserRowByte38 = "User Row Byte 38"
                            case UserRowByte39 = "User Row Byte 39"
                            case UserRowByte40 = "User Row Byte 40"
                            case UserRowByte41 = "User Row Byte 41"
                            case UserRowByte42 = "User Row Byte 42"
                            case UserRowByte43 = "User Row Byte 43"
                            case UserRowByte44 = "User Row Byte 44"
                            case UserRowByte45 = "User Row Byte 45"
                            case UserRowByte46 = "User Row Byte 46"
                            case UserRowByte47 = "User Row Byte 47"
                            case UserRowByte48 = "User Row Byte 48"
                            case UserRowByte49 = "User Row Byte 49"
                            case UserRowByte50 = "User Row Byte 50"
                            case UserRowByte51 = "User Row Byte 51"
                            case UserRowByte52 = "User Row Byte 52"
                            case UserRowByte53 = "User Row Byte 53"
                            case UserRowByte54 = "User Row Byte 54"
                            case UserRowByte55 = "User Row Byte 55"
                            case UserRowByte56 = "User Row Byte 56"
                            case UserRowByte57 = "User Row Byte 57"
                            case UserRowByte58 = "User Row Byte 58"
                            case UserRowByte59 = "User Row Byte 59"
                            case UserRowByte60 = "User Row Byte 60"
                            case UserRowByte61 = "User Row Byte 61"
                            case UserRowByte62 = "User Row Byte 62"
                            case UserRowByte63 = "User Row Byte 63"
                            case MultiplexerChannel6 = "Multiplexer Channel 6"
                            case MultiplexerChannel7 = "Multiplexer Channel 7"
                            case LCDDataRegister19 = "LCD Data Register 19"
                            case LCDDataRegister14 = "LCD Data Register 14"
                            case LCDDataRegister9 = "LCD Data Register 9"
                            case LCDDataRegister4 = "LCD Data Register 4"
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
    
    print("ATDFObject.devices.device.name = \(ATDFObject.devices.device.name)")
    
//    listOfValues.append(ATDFObject.devices.device.family)
    
    for module in ATDFObject.modules.module {

//        listOfValues.append(module.caption?.rawValue ?? "")

//        guard let list = addressSpace.memorySegment else { continue }
        for group in module.registerGroup {
            for register in group.register {
                listOfValues.append(register.caption?.rawValue ?? "")
            }
            
        }
    }
    
    
    
    
//    let encodedXML = try! XMLEncoder().encode(ATDFObject, withRootKey: "avr-tools-device-file")
//    print(String(data: encodedXML, encoding: .utf8)!)
}



extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
