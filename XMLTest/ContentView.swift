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
                        @Attribute var caption: String?
                        
                        // Note: Leavign this here for now but it probably makes sense that we use an Int and not this enum. We loose the advantage of having a constrained list, however I don't think this is that important.
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
    
    print("ATDFObject.devices.device.name = \(ATDFObject.devices.device.name)")
    
    for interupt in ATDFObject.devices.device.interrupts.interrupt {
        
        listOfValues.append(interupt.name.rawValue)

//        guard let list = module.instance.parameters?.parameter else { continue }
//        for param in list {
//            listOfValues.append(param.value.rawValue)
//        }
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
