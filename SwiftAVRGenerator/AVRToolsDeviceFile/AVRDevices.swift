//
//  AVRDevices.swift
//  SwiftAVRGenerator
//
//  Created by HALGEN on 03/12/2026.
//

import Foundation
import XMLCoder
struct AVRDevices: Codable {
    let device: Device

    enum CodingKeys: String, CodingKey {
        case device
    }

    struct Device: Codable {
        @Attribute var name: String
        @Attribute var architecture: Architecture
        @Attribute var family: Family
        let peripherals: Peripherals
        let addressSpaces: AddressSpaces
        let interfaces: Interfaces
        let propertyGroups: PropertyGroups
        let interrupts: Interrupts
        let parameters: Parameters?

        enum CodingKeys: String, CodingKey {
            case name
            case architecture
            case family
            case peripherals
            case addressSpaces = "address-spaces"
            case interfaces
            case propertyGroups = "property-groups"
            case interrupts
            case parameters
        }

        struct Architecture: ATDFStringValue {
            static let AVR8 = Architecture(value: "AVR8")
            static let AVR8X = Architecture(value: "AVR8X")
            static let AVR8L = Architecture(value: "AVR8L")

            let rawValue: String
            let alternateValues: [String]

            static let allCases: [Architecture] = [
                        AVR8,
                        AVR8X,
                        AVR8L
                    ]

            init(value: String, alternateValues: [String] = []) {
                self.rawValue = value
                self.alternateValues = alternateValues
            }
        }

        struct Family: ATDFStringValue {
            static let megaAVR = Family(value: "megaAVR")
            static let tinyAVR = Family(value: "tinyAVR")
            static let avrTINY = Family(value: "AVR TINY")
            static let tinyAVR2 = Family(value: "tinyAVR 2")
            static let avrMEGA = Family(value: "AVR MEGA")

            let rawValue: String
            let alternateValues: [String]

            static let allCases: [Family] = [
                        megaAVR,
                        tinyAVR,
                        avrTINY,
                        tinyAVR2,
                        avrMEGA
                    ]

            init(value: String, alternateValues: [String] = []) {
                self.rawValue = value
                self.alternateValues = alternateValues
            }
        }

        struct Peripherals: Codable {
            let module: [Module]

            enum CodingKeys: String, CodingKey {
                case module
            }

            struct Module: Codable {
                @Attribute var name: Name
                @Attribute var id: ID?
                let instance: [Instance]

                enum CodingKeys: String, CodingKey {
                    case name
                    case id
                    case instance
                }

                struct Name: ATDFStringValue {
                    static let LOCKBIT = Name(value: "LOCKBIT")
                    static let FUSE = Name(value: "FUSE")
                    static let PORT = Name(value: "PORT")
                    static let CPU = Name(value: "CPU")
                    static let WDT = Name(value: "WDT")
                    static let AC = Name(value: "AC")
                    static let ADC = Name(value: "ADC")
                    static let SPI = Name(value: "SPI")
                    static let EXINT = Name(value: "EXINT")
                    static let USART = Name(value: "USART")
                    static let EEPROM = Name(value: "EEPROM")
                    static let TC16 = Name(value: "TC16")
                    static let TC8 = Name(value: "TC8")
                    static let TWI = Name(value: "TWI")
                    static let BOOT_LOAD = Name(value: "BOOT_LOAD")
                    static let TC8_ASYNC = Name(value: "TC8_ASYNC")
                    static let JTAG = Name(value: "JTAG")
                    static let USI = Name(value: "USI")
                    static let CLKCTRL = Name(value: "CLKCTRL")
                    static let CRCSCAN = Name(value: "CRCSCAN")
                    static let NVMCTRL = Name(value: "NVMCTRL")
                    static let PORTMUX = Name(value: "PORTMUX")
                    static let RSTCTRL = Name(value: "RSTCTRL")
                    static let SLPCTRL = Name(value: "SLPCTRL")
                    static let USERROW = Name(value: "USERROW")
                    static let CPUINT = Name(value: "CPUINT")
                    static let SIGROW = Name(value: "SIGROW")
                    static let SYSCFG = Name(value: "SYSCFG")
                    static let EVSYS = Name(value: "EVSYS")
                    static let VPORT = Name(value: "VPORT")
                    static let GPIO = Name(value: "GPIO")
                    static let VREF = Name(value: "VREF")
                    static let BOD = Name(value: "BOD")
                    static let CCL = Name(value: "CCL")
                    static let RTC = Name(value: "RTC")
                    static let TCA = Name(value: "TCA")
                    static let TCB = Name(value: "TCB")
                    static let DAC = Name(value: "DAC")
                    static let LCD = Name(value: "LCD")
                    static let TCD = Name(value: "TCD")
                    static let PSC = Name(value: "PSC")
                    static let USB_DEVICE = Name(value: "USB_DEVICE")
                    static let PLL = Name(value: "PLL")
                    static let PTC = Name(value: "PTC")
                    static let LINUART = Name(value: "LINUART")
                    static let CAN = Name(value: "CAN")
                    static let BANDGAP = Name(value: "BANDGAP")
                    static let BATTERY_PROTECTION = Name(value: "BATTERY_PROTECTION")
                    static let COULOMB_COUNTER = Name(value: "COULOMB_COUNTER")
                    static let PWRCTRL = Name(value: "PWRCTRL")
                    static let SYMCNT = Name(value: "SYMCNT")
                    static let FLASH = Name(value: "FLASH")
                    static let TRX24 = Name(value: "TRX24")
                    static let FET = Name(value: "FET")
                    static let VOLTAGE_REGULATOR = Name(value: "VOLTAGE_REGULATOR")
                    static let CELL_BALANCING = Name(value: "CELL_BALANCING")
                    static let EUSART = Name(value: "EUSART")
                    static let MISC = Name(value: "MISC")
                    static let CHARGER_DETECT = Name(value: "CHARGER_DETECT")
                    static let USB_GLOBAL = Name(value: "USB_GLOBAL")
                    static let DEVICEID = Name(value: "DEVICEID")
                    static let USB_HOST = Name(value: "USB_HOST")
                    static let TOCPM = Name(value: "TOCPM")
                    static let CURRENT_SOURCE = Name(value: "CURRENT_SOURCE")
                    static let WAKEUP_TIMER = Name(value: "WAKEUP_TIMER")
                    static let TC10 = Name(value: "TC10")
                    static let CFD = Name(value: "CFD")
                    static let PS2 = Name(value: "PS2")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Name] = [
                                LOCKBIT,
                                FUSE,
                                PORT,
                                CPU,
                                WDT,
                                AC,
                                ADC,
                                SPI,
                                EXINT,
                                USART,
                                EEPROM,
                                TC16,
                                TC8,
                                TWI,
                                BOOT_LOAD,
                                TC8_ASYNC,
                                JTAG,
                                USI,
                                CLKCTRL,
                                CRCSCAN,
                                NVMCTRL,
                                PORTMUX,
                                RSTCTRL,
                                SLPCTRL,
                                USERROW,
                                CPUINT,
                                SIGROW,
                                SYSCFG,
                                EVSYS,
                                VPORT,
                                GPIO,
                                VREF,
                                BOD,
                                CCL,
                                RTC,
                                TCA,
                                TCB,
                                DAC,
                                LCD,
                                TCD,
                                PSC,
                                USB_DEVICE,
                                PLL,
                                PTC,
                                LINUART,
                                CAN,
                                BANDGAP,
                                BATTERY_PROTECTION,
                                COULOMB_COUNTER,
                                PWRCTRL,
                                SYMCNT,
                                FLASH,
                                TRX24,
                                FET,
                                VOLTAGE_REGULATOR,
                                CELL_BALANCING,
                                EUSART,
                                MISC,
                                CHARGER_DETECT,
                                USB_GLOBAL,
                                DEVICEID,
                                USB_HOST,
                                TOCPM,
                                CURRENT_SOURCE,
                                WAKEUP_TIMER,
                                TC10,
                                CFD,
                                PS2
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct ID: ATDFStringValue {
                    static let avrtiny2 = ID(value: "avrtiny2")
                    static let I2601 = ID(value: "I2601")
                    static let I2103 = ID(value: "I2103")
                    static let I2605 = ID(value: "I2605")
                    static let I2600 = ID(value: "I2600")
                    static let I2604 = ID(value: "I2604")
                    static let I2100 = ID(value: "I2100")
                    static let I2104 = ID(value: "I2104")
                    static let I2106 = ID(value: "I2106")
                    static let I2107 = ID(value: "I2107")
                    static let I2108 = ID(value: "I2108")
                    static let I2109 = ID(value: "I2109")
                    static let I2110 = ID(value: "I2110")
                    static let I2111 = ID(value: "I2111")
                    static let I2112 = ID(value: "I2112")
                    static let I2114 = ID(value: "I2114")
                    static let I2116 = ID(value: "I2116")
                    static let I2117 = ID(value: "I2117")
                    static let I2119 = ID(value: "I2119")
                    static let I2122 = ID(value: "I2122")
                    static let I2127 = ID(value: "I2127")
                    static let I2128 = ID(value: "I2128")
                    static let I2132 = ID(value: "I2132")
                    static let I2606 = ID(value: "I2606")
                    static let I2602 = ID(value: "I2602")
                    static let gpio_ports_avr_v1 = ID(value: "gpio_ports_avr_v1")
                    static let I2603 = ID(value: "I2603")
                    static let I2121 = ID(value: "I2121")
                    static let I2129 = ID(value: "I2129")
                    static let rst_integration_avr_v1 = ID(value: "rst_integration_avr_v1")
                    static let clk_sleep_ctrl_avr_v1 = ID(value: "clk_sleep_ctrl_avr_v1")
                    static let wdt_windowed_avr_v1 = ID(value: "wdt_windowed_avr_v1")
                    static let adc_12b_diff_ctrl_v2 = ID(value: "adc_12b_diff_ctrl_v2")
                    static let cmp_control_avr_v3 = ID(value: "cmp_control_avr_v3")
                    static let tmr_16b_capture_v1 = ID(value: "tmr_16b_capture_v1")
                    static let bor_lvd_ctrl_avr_v1 = ID(value: "bor_lvd_ctrl_avr_v1")
                    static let math_pdi_crc_avr_v1 = ID(value: "math_pdi_crc_avr_v1")
                    static let uart_autobd_v4 = ID(value: "uart_autobd_v4")
                    static let i2c_8bit_avr_v1 = ID(value: "i2c_8bit_avr_v1")
                    static let nvm_ctrl_avr_v2 = ID(value: "nvm_ctrl_avr_v2")
                    static let tmr_16b_pwm_v1 = ID(value: "tmr_16b_pwm_v1")
                    static let tmr_16b_rtc_v1 = ID(value: "tmr_16b_rtc_v1")
                    static let int_8bit_v3 = ID(value: "int_8bit_v3")
                    static let spi_8bit_v2 = ID(value: "spi_8bit_v2")
                    static let cla_ccl_v1 = ID(value: "cla_ccl_v1")
                    static let cpu_avr_v2 = ID(value: "cpu_avr_v2")
                    static let ev_ctrl_v1 = ID(value: "ev_ctrl_v1")
                    static let I2120 = ID(value: "I2120")
                    static let I2113 = ID(value: "I2113")
                    static let I2118 = ID(value: "I2118")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [ID] = [
                                avrtiny2,
                                I2601,
                                I2103,
                                I2605,
                                I2600,
                                I2604,
                                I2100,
                                I2104,
                                I2106,
                                I2107,
                                I2108,
                                I2109,
                                I2110,
                                I2111,
                                I2112,
                                I2114,
                                I2116,
                                I2117,
                                I2119,
                                I2122,
                                I2127,
                                I2128,
                                I2132,
                                I2606,
                                I2602,
                                gpio_ports_avr_v1,
                                I2603,
                                I2121,
                                I2129,
                                rst_integration_avr_v1,
                                clk_sleep_ctrl_avr_v1,
                                wdt_windowed_avr_v1,
                                adc_12b_diff_ctrl_v2,
                                cmp_control_avr_v3,
                                tmr_16b_capture_v1,
                                bor_lvd_ctrl_avr_v1,
                                math_pdi_crc_avr_v1,
                                uart_autobd_v4,
                                i2c_8bit_avr_v1,
                                nvm_ctrl_avr_v2,
                                tmr_16b_pwm_v1,
                                tmr_16b_rtc_v1,
                                int_8bit_v3,
                                spi_8bit_v2,
                                cla_ccl_v1,
                                cpu_avr_v2,
                                ev_ctrl_v1,
                                I2120,
                                I2113,
                                I2118
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
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

                    struct Name: ATDFStringValue {
                        static let LOCKBIT = Name(value: "LOCKBIT")
                        static let FUSE = Name(value: "FUSE")
                        static let CPU = Name(value: "CPU")
                        static let WDT = Name(value: "WDT")
                        static let PORTB = Name(value: "PORTB")
                        static let EXINT = Name(value: "EXINT")
                        static let TC0 = Name(value: "TC0")
                        static let PORTC = Name(value: "PORTC")
                        static let PORTA = Name(value: "PORTA")
                        static let AC = Name(value: "AC")
                        static let EEPROM = Name(value: "EEPROM")
                        static let TC1 = Name(value: "TC1")
                        static let ADC = Name(value: "ADC")
                        static let USART0 = Name(value: "USART0")
                        static let PORTD = Name(value: "PORTD")
                        static let SPI = Name(value: "SPI")
                        static let BOOT_LOAD = Name(value: "BOOT_LOAD")
                        static let TC2 = Name(value: "TC2")
                        static let PORTE = Name(value: "PORTE")
                        static let JTAG = Name(value: "JTAG")
                        static let TWI = Name(value: "TWI")
                        static let USART1 = Name(value: "USART1")
                        static let PORTF = Name(value: "PORTF")
                        static let USI = Name(value: "USI")
                        static let PORTG = Name(value: "PORTG")
                        static let SPI0 = Name(value: "SPI0")
                        static let TWI0 = Name(value: "TWI0")
                        static let CLKCTRL = Name(value: "CLKCTRL")
                        static let CRCSCAN = Name(value: "CRCSCAN")
                        static let NVMCTRL = Name(value: "NVMCTRL")
                        static let PORTMUX = Name(value: "PORTMUX")
                        static let RSTCTRL = Name(value: "RSTCTRL")
                        static let SLPCTRL = Name(value: "SLPCTRL")
                        static let USERROW = Name(value: "USERROW")
                        static let CPUINT = Name(value: "CPUINT")
                        static let SIGROW = Name(value: "SIGROW")
                        static let SYSCFG = Name(value: "SYSCFG")
                        static let VPORTA = Name(value: "VPORTA")
                        static let VPORTB = Name(value: "VPORTB")
                        static let VPORTC = Name(value: "VPORTC")
                        static let EVSYS = Name(value: "EVSYS")
                        static let ADC0 = Name(value: "ADC0")
                        static let GPIO = Name(value: "GPIO")
                        static let TCA0 = Name(value: "TCA0")
                        static let TCB0 = Name(value: "TCB0")
                        static let VREF = Name(value: "VREF")
                        static let AC0 = Name(value: "AC0")
                        static let BOD = Name(value: "BOD")
                        static let CCL = Name(value: "CCL")
                        static let RTC = Name(value: "RTC")
                        static let TC3 = Name(value: "TC3")
                        static let TCB1 = Name(value: "TCB1")
                        static let USART = Name(value: "USART")
                        static let PORTH = Name(value: "PORTH")
                        static let PORTJ = Name(value: "PORTJ")
                        static let LCD = Name(value: "LCD")
                        static let TC4 = Name(value: "TC4")
                        static let DAC0 = Name(value: "DAC0")
                        static let TCD0 = Name(value: "TCD0")
                        static let DAC = Name(value: "DAC")
                        static let USART2 = Name(value: "USART2")
                        static let TC5 = Name(value: "TC5")
                        static let USB_DEVICE = Name(value: "USB_DEVICE")
                        static let PLL = Name(value: "PLL")
                        static let PTC = Name(value: "PTC")
                        static let LINUART = Name(value: "LINUART")
                        static let CAN = Name(value: "CAN")
                        static let BANDGAP = Name(value: "BANDGAP")
                        static let VPORTD = Name(value: "VPORTD")
                        static let VPORTE = Name(value: "VPORTE")
                        static let VPORTF = Name(value: "VPORTF")
                        static let PSC0 = Name(value: "PSC0")
                        static let PSC2 = Name(value: "PSC2")
                        static let TCB2 = Name(value: "TCB2")
                        static let BATTERY_PROTECTION = Name(value: "BATTERY_PROTECTION")
                        static let COULOMB_COUNTER = Name(value: "COULOMB_COUNTER")
                        static let USART0_SPI = Name(value: "USART0_SPI")
                        static let USART1_SPI = Name(value: "USART1_SPI")
                        static let PWRCTRL = Name(value: "PWRCTRL")
                        static let SYMCNT = Name(value: "SYMCNT")
                        static let USART3 = Name(value: "USART3")
                        static let FLASH = Name(value: "FLASH")
                        static let TRX24 = Name(value: "TRX24")
                        static let FET = Name(value: "FET")
                        static let VOLTAGE_REGULATOR = Name(value: "VOLTAGE_REGULATOR")
                        static let CELL_BALANCING = Name(value: "CELL_BALANCING")
                        static let EUSART = Name(value: "EUSART")
                        static let ADC1 = Name(value: "ADC1")
                        static let DAC1 = Name(value: "DAC1")
                        static let DAC2 = Name(value: "DAC2")
                        static let MISC = Name(value: "MISC")
                        static let AC1 = Name(value: "AC1")
                        static let AC2 = Name(value: "AC2")
                        static let CHARGER_DETECT = Name(value: "CHARGER_DETECT")
                        static let USB_GLOBAL = Name(value: "USB_GLOBAL")
                        static let PSC1 = Name(value: "PSC1")
                        static let TCB3 = Name(value: "TCB3")
                        static let PSC = Name(value: "PSC")
                        static let DEVICEID = Name(value: "DEVICEID")
                        static let USB_HOST = Name(value: "USB_HOST")
                        static let PORTK = Name(value: "PORTK")
                        static let PORTL = Name(value: "PORTL")
                        static let TOCPM = Name(value: "TOCPM")
                        static let CURRENT_SOURCE = Name(value: "CURRENT_SOURCE")
                        static let WAKEUP_TIMER = Name(value: "WAKEUP_TIMER")
                        static let SPI1 = Name(value: "SPI1")
                        static let TWI1 = Name(value: "TWI1")
                        static let CFD = Name(value: "CFD")
                        static let PS2 = Name(value: "PS2")

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Name] = [
                                    LOCKBIT,
                                    FUSE,
                                    CPU,
                                    WDT,
                                    PORTB,
                                    EXINT,
                                    TC0,
                                    PORTC,
                                    PORTA,
                                    AC,
                                    EEPROM,
                                    TC1,
                                    ADC,
                                    USART0,
                                    PORTD,
                                    SPI,
                                    BOOT_LOAD,
                                    TC2,
                                    PORTE,
                                    JTAG,
                                    TWI,
                                    USART1,
                                    PORTF,
                                    USI,
                                    PORTG,
                                    SPI0,
                                    TWI0,
                                    CLKCTRL,
                                    CRCSCAN,
                                    NVMCTRL,
                                    PORTMUX,
                                    RSTCTRL,
                                    SLPCTRL,
                                    USERROW,
                                    CPUINT,
                                    SIGROW,
                                    SYSCFG,
                                    VPORTA,
                                    VPORTB,
                                    VPORTC,
                                    EVSYS,
                                    ADC0,
                                    GPIO,
                                    TCA0,
                                    TCB0,
                                    VREF,
                                    AC0,
                                    BOD,
                                    CCL,
                                    RTC,
                                    TC3,
                                    TCB1,
                                    USART,
                                    PORTH,
                                    PORTJ,
                                    LCD,
                                    TC4,
                                    DAC0,
                                    TCD0,
                                    DAC,
                                    USART2,
                                    TC5,
                                    USB_DEVICE,
                                    PLL,
                                    PTC,
                                    LINUART,
                                    CAN,
                                    BANDGAP,
                                    VPORTD,
                                    VPORTE,
                                    VPORTF,
                                    PSC0,
                                    PSC2,
                                    TCB2,
                                    BATTERY_PROTECTION,
                                    COULOMB_COUNTER,
                                    USART0_SPI,
                                    USART1_SPI,
                                    PWRCTRL,
                                    SYMCNT,
                                    USART3,
                                    FLASH,
                                    TRX24,
                                    FET,
                                    VOLTAGE_REGULATOR,
                                    CELL_BALANCING,
                                    EUSART,
                                    ADC1,
                                    DAC1,
                                    DAC2,
                                    MISC,
                                    AC1,
                                    AC2,
                                    CHARGER_DETECT,
                                    USB_GLOBAL,
                                    PSC1,
                                    TCB3,
                                    PSC,
                                    DEVICEID,
                                    USB_HOST,
                                    PORTK,
                                    PORTL,
                                    TOCPM,
                                    CURRENT_SOURCE,
                                    WAKEUP_TIMER,
                                    SPI1,
                                    TWI1,
                                    CFD,
                                    PS2
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Caption: ATDFStringValue {
                        static let iOPort = Caption(value: "I/O Port")
                        static let timerCounter16Bit = Caption(value: "Timer/Counter, 16-bit")
                        static let externalInterrupts = Caption(value: "External Interrupts")
                        static let watchdogTimer = Caption(value: "Watchdog Timer")
                        static let cpuRegisters = Caption(value: "CPU Registers")
                        static let Lockbits = Caption(value: "Lockbits")
                        static let Fuses = Caption(value: "Fuses")
                        static let USART = Caption(value: "USART")
                        static let analogComparator = Caption(value: "Analog Comparator")
                        static let timerCounter8Bit = Caption(value: "Timer/Counter, 8-bit")
                        static let EEPROM = Caption(value: "EEPROM")
                        static let analogToDigitalConverter = Caption(value: "Analog-to-Digital Converter")
                        static let serialPeripheralInterface = Caption(value: "Serial Peripheral Interface")
                        static let Bootloader = Caption(value: "Bootloader")
                        static let timerCounter8BitAsync = Caption(value: "Timer/Counter, 8-bit Async")
                        static let twoWireSerialInterface = Caption(value: "Two Wire Serial Interface")
                        static let jtagInterface = Caption(value: "JTAG Interface")
                        static let universalSerialInterface = Caption(value: "Universal Serial Interface")
                        static let powerStageController = Caption(value: "Power Stage Controller")
                        static let liquidCrystalDisplay = Caption(value: "Liquid Crystal Display")
                        static let digitalToAnalogConverter = Caption(value: "Digital-to-Analog Converter")
                        static let usbDeviceRegisters = Caption(value: "USB Device Registers")
                        static let phaseLockedLoop = Caption(value: "Phase Locked Loop")
                        static let localInterconnectNetwork = Caption(value: "Local Interconnect Network")
                        static let controllerAreaNetwork = Caption(value: "Controller Area Network")
                        static let Bandgap = Caption(value: "Bandgap")
                        static let lowPower24GhzTransceiver = Caption(value: "Low-Power 2.4 GHz Transceiver")
                        static let batteryProtection = Caption(value: "Battery Protection")
                        static let macSymbolCounter = Caption(value: "MAC Symbol Counter")
                        static let flashController = Caption(value: "FLASH Controller")
                        static let powerController = Caption(value: "Power Controller")
                        static let coulombCounter = Caption(value: "Coulomb Counter")
                        static let fetControl = Caption(value: "FET Control")
                        static let voltageRegulator = Caption(value: "Voltage Regulator")
                        static let otherRegisters = Caption(value: "Other Registers")
                        static let cellBalancing = Caption(value: "Cell Balancing")
                        static let extendedUsart = Caption(value: "Extended USART")
                        static let chargerDetect = Caption(value: "Charger Detect")
                        static let usbController = Caption(value: "USB Controller")
                        static let timerCounterOutputComparePin = Caption(value: "Timer/Counter Output Compare Pin")
                        static let usbHostRegisters = Caption(value: "USB Host Registers")
                        static let deviceID = Caption(value: "Device ID")
                        static let timerCounter10Bit = Caption(value: "Timer/Counter, 10-bit")
                        static let currentSource = Caption(value: "Current Source")
                        static let ps2Controller = Caption(value: "PS/2 Controller")
                        static let wakeupTimer = Caption(value: "Wakeup Timer")
                        static let peripheralTouchController = Caption(value: "Peripheral Touch Controller")
                        static let clockFailureDetection = Caption(value: "Clock Failure Detection")

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Caption] = [
                                    iOPort,
                                    timerCounter16Bit,
                                    externalInterrupts,
                                    watchdogTimer,
                                    cpuRegisters,
                                    Lockbits,
                                    Fuses,
                                    USART,
                                    analogComparator,
                                    timerCounter8Bit,
                                    EEPROM,
                                    analogToDigitalConverter,
                                    serialPeripheralInterface,
                                    Bootloader,
                                    timerCounter8BitAsync,
                                    twoWireSerialInterface,
                                    jtagInterface,
                                    universalSerialInterface,
                                    powerStageController,
                                    liquidCrystalDisplay,
                                    digitalToAnalogConverter,
                                    usbDeviceRegisters,
                                    phaseLockedLoop,
                                    localInterconnectNetwork,
                                    controllerAreaNetwork,
                                    Bandgap,
                                    lowPower24GhzTransceiver,
                                    batteryProtection,
                                    macSymbolCounter,
                                    flashController,
                                    powerController,
                                    coulombCounter,
                                    fetControl,
                                    voltageRegulator,
                                    otherRegisters,
                                    cellBalancing,
                                    extendedUsart,
                                    chargerDetect,
                                    usbController,
                                    timerCounterOutputComparePin,
                                    usbHostRegisters,
                                    deviceID,
                                    timerCounter10Bit,
                                    currentSource,
                                    ps2Controller,
                                    wakeupTimer,
                                    peripheralTouchController,
                                    clockFailureDetection
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct RegisterGroup: Codable {
                        @Attribute var name: Name
                        @Attribute var nameInModule: NameInModule
                        @Attribute var offset: Offset
                        @Attribute var addressSpace: AddressSpace
                        @Attribute var caption: Caption?

                        enum CodingKeys: String, CodingKey {
                            case name
                            case nameInModule = "name-in-module"
                            case offset
                            case addressSpace = "address-space"
                            case caption
                        }

                        struct Name: ATDFStringValue {
                            static let LOCKBIT = Name(value: "LOCKBIT")
                            static let FUSE = Name(value: "FUSE")
                            static let CPU = Name(value: "CPU")
                            static let WDT = Name(value: "WDT")
                            static let PORTB = Name(value: "PORTB")
                            static let EXINT = Name(value: "EXINT")
                            static let TC0 = Name(value: "TC0")
                            static let PORTC = Name(value: "PORTC")
                            static let PORTA = Name(value: "PORTA")
                            static let AC = Name(value: "AC")
                            static let EEPROM = Name(value: "EEPROM")
                            static let TC1 = Name(value: "TC1")
                            static let ADC = Name(value: "ADC")
                            static let USART0 = Name(value: "USART0")
                            static let PORTD = Name(value: "PORTD")
                            static let SPI = Name(value: "SPI")
                            static let BOOT_LOAD = Name(value: "BOOT_LOAD")
                            static let TC2 = Name(value: "TC2")
                            static let PORTE = Name(value: "PORTE")
                            static let JTAG = Name(value: "JTAG")
                            static let TWI = Name(value: "TWI")
                            static let USART1 = Name(value: "USART1")
                            static let PORTF = Name(value: "PORTF")
                            static let USI = Name(value: "USI")
                            static let PORTG = Name(value: "PORTG")
                            static let SPI0 = Name(value: "SPI0")
                            static let TWI0 = Name(value: "TWI0")
                            static let CLKCTRL = Name(value: "CLKCTRL")
                            static let CRCSCAN = Name(value: "CRCSCAN")
                            static let NVMCTRL = Name(value: "NVMCTRL")
                            static let PORTMUX = Name(value: "PORTMUX")
                            static let RSTCTRL = Name(value: "RSTCTRL")
                            static let SLPCTRL = Name(value: "SLPCTRL")
                            static let USERROW = Name(value: "USERROW")
                            static let CPUINT = Name(value: "CPUINT")
                            static let SIGROW = Name(value: "SIGROW")
                            static let SYSCFG = Name(value: "SYSCFG")
                            static let VPORTA = Name(value: "VPORTA")
                            static let VPORTB = Name(value: "VPORTB")
                            static let VPORTC = Name(value: "VPORTC")
                            static let EVSYS = Name(value: "EVSYS")
                            static let ADC0 = Name(value: "ADC0")
                            static let GPIO = Name(value: "GPIO")
                            static let TCA0 = Name(value: "TCA0")
                            static let TCB0 = Name(value: "TCB0")
                            static let VREF = Name(value: "VREF")
                            static let AC0 = Name(value: "AC0")
                            static let BOD = Name(value: "BOD")
                            static let CCL = Name(value: "CCL")
                            static let RTC = Name(value: "RTC")
                            static let TC3 = Name(value: "TC3")
                            static let TCB1 = Name(value: "TCB1")
                            static let USART = Name(value: "USART")
                            static let PORTH = Name(value: "PORTH")
                            static let PORTJ = Name(value: "PORTJ")
                            static let LCD = Name(value: "LCD")
                            static let TC4 = Name(value: "TC4")
                            static let DAC0 = Name(value: "DAC0")
                            static let TCD0 = Name(value: "TCD0")
                            static let DAC = Name(value: "DAC")
                            static let USART2 = Name(value: "USART2")
                            static let TC5 = Name(value: "TC5")
                            static let USB_DEVICE = Name(value: "USB_DEVICE")
                            static let PLL = Name(value: "PLL")
                            static let LINUART = Name(value: "LINUART")
                            static let CAN = Name(value: "CAN")
                            static let BANDGAP = Name(value: "BANDGAP")
                            static let VPORTD = Name(value: "VPORTD")
                            static let VPORTE = Name(value: "VPORTE")
                            static let VPORTF = Name(value: "VPORTF")
                            static let PSC0 = Name(value: "PSC0")
                            static let PSC2 = Name(value: "PSC2")
                            static let TCB2 = Name(value: "TCB2")
                            static let BATTERY_PROTECTION = Name(value: "BATTERY_PROTECTION")
                            static let COULOMB_COUNTER = Name(value: "COULOMB_COUNTER")
                            static let USART0_SPI = Name(value: "USART0_SPI")
                            static let USART1_SPI = Name(value: "USART1_SPI")
                            static let PWRCTRL = Name(value: "PWRCTRL")
                            static let SYMCNT = Name(value: "SYMCNT")
                            static let USART3 = Name(value: "USART3")
                            static let FLASH = Name(value: "FLASH")
                            static let TRX24 = Name(value: "TRX24")
                            static let FET = Name(value: "FET")
                            static let VOLTAGE_REGULATOR = Name(value: "VOLTAGE_REGULATOR")
                            static let CELL_BALANCING = Name(value: "CELL_BALANCING")
                            static let EUSART = Name(value: "EUSART")
                            static let ADC1 = Name(value: "ADC1")
                            static let DAC1 = Name(value: "DAC1")
                            static let DAC2 = Name(value: "DAC2")
                            static let MISC = Name(value: "MISC")
                            static let AC1 = Name(value: "AC1")
                            static let AC2 = Name(value: "AC2")
                            static let CHARGER_DETECT = Name(value: "CHARGER_DETECT")
                            static let USB_GLOBAL = Name(value: "USB_GLOBAL")
                            static let PSC1 = Name(value: "PSC1")
                            static let TCB3 = Name(value: "TCB3")
                            static let PSC = Name(value: "PSC")
                            static let DEVICEID = Name(value: "DEVICEID")
                            static let USB_HOST = Name(value: "USB_HOST")
                            static let PORTK = Name(value: "PORTK")
                            static let PORTL = Name(value: "PORTL")
                            static let TOCPM = Name(value: "TOCPM")
                            static let CURRENT_SOURCE = Name(value: "CURRENT_SOURCE")
                            static let WAKEUP_TIMER = Name(value: "WAKEUP_TIMER")
                            static let SPI1 = Name(value: "SPI1")
                            static let TWI1 = Name(value: "TWI1")
                            static let CFD = Name(value: "CFD")
                            static let PS2 = Name(value: "PS2")
                            static let TC = Name(value: "TC")

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [Name] = [
                                        LOCKBIT,
                                        FUSE,
                                        CPU,
                                        WDT,
                                        PORTB,
                                        EXINT,
                                        TC0,
                                        PORTC,
                                        PORTA,
                                        AC,
                                        EEPROM,
                                        TC1,
                                        ADC,
                                        USART0,
                                        PORTD,
                                        SPI,
                                        BOOT_LOAD,
                                        TC2,
                                        PORTE,
                                        JTAG,
                                        TWI,
                                        USART1,
                                        PORTF,
                                        USI,
                                        PORTG,
                                        SPI0,
                                        TWI0,
                                        CLKCTRL,
                                        CRCSCAN,
                                        NVMCTRL,
                                        PORTMUX,
                                        RSTCTRL,
                                        SLPCTRL,
                                        USERROW,
                                        CPUINT,
                                        SIGROW,
                                        SYSCFG,
                                        VPORTA,
                                        VPORTB,
                                        VPORTC,
                                        EVSYS,
                                        ADC0,
                                        GPIO,
                                        TCA0,
                                        TCB0,
                                        VREF,
                                        AC0,
                                        BOD,
                                        CCL,
                                        RTC,
                                        TC3,
                                        TCB1,
                                        USART,
                                        PORTH,
                                        PORTJ,
                                        LCD,
                                        TC4,
                                        DAC0,
                                        TCD0,
                                        DAC,
                                        USART2,
                                        TC5,
                                        USB_DEVICE,
                                        PLL,
                                        LINUART,
                                        CAN,
                                        BANDGAP,
                                        VPORTD,
                                        VPORTE,
                                        VPORTF,
                                        PSC0,
                                        PSC2,
                                        TCB2,
                                        BATTERY_PROTECTION,
                                        COULOMB_COUNTER,
                                        USART0_SPI,
                                        USART1_SPI,
                                        PWRCTRL,
                                        SYMCNT,
                                        USART3,
                                        FLASH,
                                        TRX24,
                                        FET,
                                        VOLTAGE_REGULATOR,
                                        CELL_BALANCING,
                                        EUSART,
                                        ADC1,
                                        DAC1,
                                        DAC2,
                                        MISC,
                                        AC1,
                                        AC2,
                                        CHARGER_DETECT,
                                        USB_GLOBAL,
                                        PSC1,
                                        TCB3,
                                        PSC,
                                        DEVICEID,
                                        USB_HOST,
                                        PORTK,
                                        PORTL,
                                        TOCPM,
                                        CURRENT_SOURCE,
                                        WAKEUP_TIMER,
                                        SPI1,
                                        TWI1,
                                        CFD,
                                        PS2,
                                        TC
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }

                        struct NameInModule: ATDFStringValue {
                            static let AC = NameInModule(value: "AC")
                            static let LOCKBIT = NameInModule(value: "LOCKBIT")
                            static let FUSE = NameInModule(value: "FUSE")
                            static let CPU = NameInModule(value: "CPU")
                            static let WDT = NameInModule(value: "WDT")
                            static let ADC = NameInModule(value: "ADC")
                            static let SPI = NameInModule(value: "SPI")
                            static let EXINT = NameInModule(value: "EXINT")
                            static let PORTB = NameInModule(value: "PORTB")
                            static let TC0 = NameInModule(value: "TC0")
                            static let EEPROM = NameInModule(value: "EEPROM")
                            static let VPORT = NameInModule(value: "VPORT")
                            static let TC1 = NameInModule(value: "TC1")
                            static let PORT = NameInModule(value: "PORT")
                            static let PORTC = NameInModule(value: "PORTC")
                            static let PORTD = NameInModule(value: "PORTD")
                            static let TWI = NameInModule(value: "TWI")
                            static let BOOT_LOAD = NameInModule(value: "BOOT_LOAD")
                            static let PORTA = NameInModule(value: "PORTA")
                            static let TC2 = NameInModule(value: "TC2")
                            static let USART = NameInModule(value: "USART")
                            static let USART0 = NameInModule(value: "USART0")
                            static let TCB = NameInModule(value: "TCB")
                            static let PORTE = NameInModule(value: "PORTE")
                            static let JTAG = NameInModule(value: "JTAG")
                            static let PORTF = NameInModule(value: "PORTF")
                            static let USI = NameInModule(value: "USI")
                            static let PORTG = NameInModule(value: "PORTG")
                            static let USART1 = NameInModule(value: "USART1")
                            static let CLKCTRL = NameInModule(value: "CLKCTRL")
                            static let CRCSCAN = NameInModule(value: "CRCSCAN")
                            static let NVMCTRL = NameInModule(value: "NVMCTRL")
                            static let PORTMUX = NameInModule(value: "PORTMUX")
                            static let RSTCTRL = NameInModule(value: "RSTCTRL")
                            static let SLPCTRL = NameInModule(value: "SLPCTRL")
                            static let USERROW = NameInModule(value: "USERROW")
                            static let CPUINT = NameInModule(value: "CPUINT")
                            static let SIGROW = NameInModule(value: "SIGROW")
                            static let SYSCFG = NameInModule(value: "SYSCFG")
                            static let EVSYS = NameInModule(value: "EVSYS")
                            static let GPIO = NameInModule(value: "GPIO")
                            static let VREF = NameInModule(value: "VREF")
                            static let BOD = NameInModule(value: "BOD")
                            static let CCL = NameInModule(value: "CCL")
                            static let RTC = NameInModule(value: "RTC")
                            static let TCA = NameInModule(value: "TCA")
                            static let DAC = NameInModule(value: "DAC")
                            static let TC3 = NameInModule(value: "TC3")
                            static let PORTH = NameInModule(value: "PORTH")
                            static let PORTJ = NameInModule(value: "PORTJ")
                            static let LCD = NameInModule(value: "LCD")
                            static let TC4 = NameInModule(value: "TC4")
                            static let TCD = NameInModule(value: "TCD")
                            static let TC5 = NameInModule(value: "TC5")
                            static let USB_DEVICE = NameInModule(value: "USB_DEVICE")
                            static let PLL = NameInModule(value: "PLL")
                            static let LINUART = NameInModule(value: "LINUART")
                            static let CAN = NameInModule(value: "CAN")
                            static let BANDGAP = NameInModule(value: "BANDGAP")
                            static let PSC0 = NameInModule(value: "PSC0")
                            static let PSC2 = NameInModule(value: "PSC2")
                            static let BATTERY_PROTECTION = NameInModule(value: "BATTERY_PROTECTION")
                            static let COULOMB_COUNTER = NameInModule(value: "COULOMB_COUNTER")
                            static let USART0_SPI = NameInModule(value: "USART0_SPI")
                            static let USART1_SPI = NameInModule(value: "USART1_SPI")
                            static let PWRCTRL = NameInModule(value: "PWRCTRL")
                            static let SYMCNT = NameInModule(value: "SYMCNT")
                            static let FLASH = NameInModule(value: "FLASH")
                            static let TRX24 = NameInModule(value: "TRX24")
                            static let FET = NameInModule(value: "FET")
                            static let VOLTAGE_REGULATOR = NameInModule(value: "VOLTAGE_REGULATOR")
                            static let CELL_BALANCING = NameInModule(value: "CELL_BALANCING")
                            static let EUSART = NameInModule(value: "EUSART")
                            static let MISC = NameInModule(value: "MISC")
                            static let CHARGER_DETECT = NameInModule(value: "CHARGER_DETECT")
                            static let USB_GLOBAL = NameInModule(value: "USB_GLOBAL")
                            static let USART2 = NameInModule(value: "USART2")
                            static let PSC1 = NameInModule(value: "PSC1")
                            static let PSC = NameInModule(value: "PSC")
                            static let DEVICEID = NameInModule(value: "DEVICEID")
                            static let USB_HOST = NameInModule(value: "USB_HOST")
                            static let USART3 = NameInModule(value: "USART3")
                            static let PORTK = NameInModule(value: "PORTK")
                            static let PORTL = NameInModule(value: "PORTL")
                            static let TOCPM = NameInModule(value: "TOCPM")
                            static let CURRENT_SOURCE = NameInModule(value: "CURRENT_SOURCE")
                            static let WAKEUP_TIMER = NameInModule(value: "WAKEUP_TIMER")
                            static let SPI0 = NameInModule(value: "SPI0")
                            static let SPI1 = NameInModule(value: "SPI1")
                            static let TWI0 = NameInModule(value: "TWI0")
                            static let TWI1 = NameInModule(value: "TWI1")
                            static let CFD = NameInModule(value: "CFD")
                            static let PS2 = NameInModule(value: "PS2")

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [NameInModule] = [
                                        AC,
                                        LOCKBIT,
                                        FUSE,
                                        CPU,
                                        WDT,
                                        ADC,
                                        SPI,
                                        EXINT,
                                        PORTB,
                                        TC0,
                                        EEPROM,
                                        VPORT,
                                        TC1,
                                        PORT,
                                        PORTC,
                                        PORTD,
                                        TWI,
                                        BOOT_LOAD,
                                        PORTA,
                                        TC2,
                                        USART,
                                        USART0,
                                        TCB,
                                        PORTE,
                                        JTAG,
                                        PORTF,
                                        USI,
                                        PORTG,
                                        USART1,
                                        CLKCTRL,
                                        CRCSCAN,
                                        NVMCTRL,
                                        PORTMUX,
                                        RSTCTRL,
                                        SLPCTRL,
                                        USERROW,
                                        CPUINT,
                                        SIGROW,
                                        SYSCFG,
                                        EVSYS,
                                        GPIO,
                                        VREF,
                                        BOD,
                                        CCL,
                                        RTC,
                                        TCA,
                                        DAC,
                                        TC3,
                                        PORTH,
                                        PORTJ,
                                        LCD,
                                        TC4,
                                        TCD,
                                        TC5,
                                        USB_DEVICE,
                                        PLL,
                                        LINUART,
                                        CAN,
                                        BANDGAP,
                                        PSC0,
                                        PSC2,
                                        BATTERY_PROTECTION,
                                        COULOMB_COUNTER,
                                        USART0_SPI,
                                        USART1_SPI,
                                        PWRCTRL,
                                        SYMCNT,
                                        FLASH,
                                        TRX24,
                                        FET,
                                        VOLTAGE_REGULATOR,
                                        CELL_BALANCING,
                                        EUSART,
                                        MISC,
                                        CHARGER_DETECT,
                                        USB_GLOBAL,
                                        USART2,
                                        PSC1,
                                        PSC,
                                        DEVICEID,
                                        USB_HOST,
                                        USART3,
                                        PORTK,
                                        PORTL,
                                        TOCPM,
                                        CURRENT_SOURCE,
                                        WAKEUP_TIMER,
                                        SPI0,
                                        SPI1,
                                        TWI0,
                                        TWI1,
                                        CFD,
                                        PS2
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }

                        struct Offset: ATDFStringValue {
                            static let zeroX00 = Offset(value: "0x00")
                            static let zero = Offset(value: "0")
                            static let zeroX0000 = Offset(value: "0x0000")
                            static let zeroX0004 = Offset(value: "0x0004")
                            static let zeroX0008 = Offset(value: "0x0008")
                            static let zeroX001C = Offset(value: "0x001C")
                            static let zeroX0030 = Offset(value: "0x0030")
                            static let zeroX0040 = Offset(value: "0x0040")
                            static let zeroX0050 = Offset(value: "0x0050")
                            static let zeroX0060 = Offset(value: "0x0060")
                            static let zeroX0080 = Offset(value: "0x0080")
                            static let zeroX00A0 = Offset(value: "0x00A0")
                            static let zeroX0100 = Offset(value: "0x0100")
                            static let zeroX0110 = Offset(value: "0x0110")
                            static let zeroX0120 = Offset(value: "0x0120")
                            static let zeroX0140 = Offset(value: "0x0140")
                            static let zeroX0180 = Offset(value: "0x0180")
                            static let zeroX01C0 = Offset(value: "0x01C0")
                            static let zeroX0400 = Offset(value: "0x0400")
                            static let zeroX0600 = Offset(value: "0x0600")
                            static let zeroX0800 = Offset(value: "0x0800")
                            static let zeroX0820 = Offset(value: "0x0820")
                            static let zeroX0A00 = Offset(value: "0x0A00")
                            static let zeroX0F00 = Offset(value: "0x0F00")
                            static let zeroX1000 = Offset(value: "0x1000")
                            static let zeroX1100 = Offset(value: "0x1100")
                            static let zeroX1280 = Offset(value: "0x1280")
                            static let zeroX128A = Offset(value: "0x128A")
                            static let zeroX1300 = Offset(value: "0x1300")
                            static let zeroX0420 = Offset(value: "0x0420")
                            static let zeroX0680 = Offset(value: "0x0680")
                            static let zeroX0440 = Offset(value: "0x0440")
                            static let zeroX0A80 = Offset(value: "0x0A80")
                            static let zeroX0200 = Offset(value: "0x0200")
                            static let zeroX0810 = Offset(value: "0x0810")
                            static let zeroX0A40 = Offset(value: "0x0A40")
                            static let zeroX05E0 = Offset(value: "0x05E0")
                            static let zeroX08A0 = Offset(value: "0x08A0")
                            static let zeroX08C0 = Offset(value: "0x08C0")
                            static let zeroX0A90 = Offset(value: "0x0A90")
                            static let zeroX0670 = Offset(value: "0x0670")
                            static let zeroX000C = Offset(value: "0x000C")
                            static let zeroX0010 = Offset(value: "0x0010")
                            static let zeroX0014 = Offset(value: "0x0014")
                            static let zeroX0460 = Offset(value: "0x0460")
                            static let zeroX0480 = Offset(value: "0x0480")
                            static let zeroX04A0 = Offset(value: "0x04A0")
                            static let zeroX0840 = Offset(value: "0x0840")
                            static let zeroX0AA0 = Offset(value: "0x0AA0")
                            static let zeroX0640 = Offset(value: "0x0640")
                            static let zeroX0688 = Offset(value: "0x0688")
                            static let zeroX0690 = Offset(value: "0x0690")
                            static let zeroX06A0 = Offset(value: "0x06A0")
                            static let zeroX06A8 = Offset(value: "0x06A8")
                            static let zeroX06B0 = Offset(value: "0x06B0")
                            static let zeroX0A50 = Offset(value: "0x0A50")
                            static let zeroX0860 = Offset(value: "0x0860")
                            static let zeroX0AB0 = Offset(value: "0x0AB0")
                            static let zeroX0 = Offset(value: "0x0")

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [Offset] = [
                                        zeroX00,
                                        zero,
                                        zeroX0000,
                                        zeroX0004,
                                        zeroX0008,
                                        zeroX001C,
                                        zeroX0030,
                                        zeroX0040,
                                        zeroX0050,
                                        zeroX0060,
                                        zeroX0080,
                                        zeroX00A0,
                                        zeroX0100,
                                        zeroX0110,
                                        zeroX0120,
                                        zeroX0140,
                                        zeroX0180,
                                        zeroX01C0,
                                        zeroX0400,
                                        zeroX0600,
                                        zeroX0800,
                                        zeroX0820,
                                        zeroX0A00,
                                        zeroX0F00,
                                        zeroX1000,
                                        zeroX1100,
                                        zeroX1280,
                                        zeroX128A,
                                        zeroX1300,
                                        zeroX0420,
                                        zeroX0680,
                                        zeroX0440,
                                        zeroX0A80,
                                        zeroX0200,
                                        zeroX0810,
                                        zeroX0A40,
                                        zeroX05E0,
                                        zeroX08A0,
                                        zeroX08C0,
                                        zeroX0A90,
                                        zeroX0670,
                                        zeroX000C,
                                        zeroX0010,
                                        zeroX0014,
                                        zeroX0460,
                                        zeroX0480,
                                        zeroX04A0,
                                        zeroX0840,
                                        zeroX0AA0,
                                        zeroX0640,
                                        zeroX0688,
                                        zeroX0690,
                                        zeroX06A0,
                                        zeroX06A8,
                                        zeroX06B0,
                                        zeroX0A50,
                                        zeroX0860,
                                        zeroX0AB0,
                                        zeroX0
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }

                        struct AddressSpace: ATDFStringValue {
                            static let data = AddressSpace(value: "data")
                            static let lockbits = AddressSpace(value: "lockbits")
                            static let fuses = AddressSpace(value: "fuses")

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [AddressSpace] = [
                                        data,
                                        lockbits,
                                        fuses
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }

                        struct Caption: ATDFStringValue {
                            static let iOPort = Caption(value: "I/O Port")
                            static let timerCounter16Bit = Caption(value: "Timer/Counter, 16-bit")
                            static let externalInterrupts = Caption(value: "External Interrupts")
                            static let watchdogTimer = Caption(value: "Watchdog Timer")
                            static let cpuRegisters = Caption(value: "CPU Registers")
                            static let Lockbits = Caption(value: "Lockbits")
                            static let Fuses = Caption(value: "Fuses")
                            static let USART = Caption(value: "USART")
                            static let analogComparator = Caption(value: "Analog Comparator")
                            static let timerCounter8Bit = Caption(value: "Timer/Counter, 8-bit")
                            static let EEPROM = Caption(value: "EEPROM")
                            static let analogToDigitalConverter = Caption(value: "Analog-to-Digital Converter")
                            static let serialPeripheralInterface = Caption(value: "Serial Peripheral Interface")
                            static let Bootloader = Caption(value: "Bootloader")
                            static let timerCounter8BitAsync = Caption(value: "Timer/Counter, 8-bit Async")
                            static let twoWireSerialInterface = Caption(value: "Two Wire Serial Interface")
                            static let jtagInterface = Caption(value: "JTAG Interface")
                            static let universalSerialInterface = Caption(value: "Universal Serial Interface")
                            static let powerStageController = Caption(value: "Power Stage Controller")
                            static let liquidCrystalDisplay = Caption(value: "Liquid Crystal Display")
                            static let digitalToAnalogConverter = Caption(value: "Digital-to-Analog Converter")
                            static let usbDeviceRegisters = Caption(value: "USB Device Registers")
                            static let phaseLockedLoop = Caption(value: "Phase Locked Loop")
                            static let localInterconnectNetwork = Caption(value: "Local Interconnect Network")
                            static let controllerAreaNetwork = Caption(value: "Controller Area Network")
                            static let Bandgap = Caption(value: "Bandgap")
                            static let lowPower24GhzTransceiver = Caption(value: "Low-Power 2.4 GHz Transceiver")
                            static let batteryProtection = Caption(value: "Battery Protection")
                            static let macSymbolCounter = Caption(value: "MAC Symbol Counter")
                            static let flashController = Caption(value: "FLASH Controller")
                            static let powerController = Caption(value: "Power Controller")
                            static let coulombCounter = Caption(value: "Coulomb Counter")
                            static let fetControl = Caption(value: "FET Control")
                            static let voltageRegulator = Caption(value: "Voltage Regulator")
                            static let otherRegisters = Caption(value: "Other Registers")
                            static let cellBalancing = Caption(value: "Cell Balancing")
                            static let extendedUsart = Caption(value: "Extended USART")
                            static let chargerDetect = Caption(value: "Charger Detect")
                            static let usbController = Caption(value: "USB Controller")
                            static let timerCounterOutputComparePin = Caption(value: "Timer/Counter Output Compare Pin")
                            static let usbHostRegisters = Caption(value: "USB Host Registers")
                            static let deviceID = Caption(value: "Device ID")
                            static let timerCounter10Bit = Caption(value: "Timer/Counter, 10-bit")
                            static let currentSource = Caption(value: "Current Source")
                            static let ps2Controller = Caption(value: "PS/2 Controller")
                            static let wakeupTimer = Caption(value: "Wakeup Timer")
                            static let clockFailureDetection = Caption(value: "Clock Failure Detection")

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [Caption] = [
                                        iOPort,
                                        timerCounter16Bit,
                                        externalInterrupts,
                                        watchdogTimer,
                                        cpuRegisters,
                                        Lockbits,
                                        Fuses,
                                        USART,
                                        analogComparator,
                                        timerCounter8Bit,
                                        EEPROM,
                                        analogToDigitalConverter,
                                        serialPeripheralInterface,
                                        Bootloader,
                                        timerCounter8BitAsync,
                                        twoWireSerialInterface,
                                        jtagInterface,
                                        universalSerialInterface,
                                        powerStageController,
                                        liquidCrystalDisplay,
                                        digitalToAnalogConverter,
                                        usbDeviceRegisters,
                                        phaseLockedLoop,
                                        localInterconnectNetwork,
                                        controllerAreaNetwork,
                                        Bandgap,
                                        lowPower24GhzTransceiver,
                                        batteryProtection,
                                        macSymbolCounter,
                                        flashController,
                                        powerController,
                                        coulombCounter,
                                        fetControl,
                                        voltageRegulator,
                                        otherRegisters,
                                        cellBalancing,
                                        extendedUsart,
                                        chargerDetect,
                                        usbController,
                                        timerCounterOutputComparePin,
                                        usbHostRegisters,
                                        deviceID,
                                        timerCounter10Bit,
                                        currentSource,
                                        ps2Controller,
                                        wakeupTimer,
                                        clockFailureDetection
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }
                    }

                    struct Signals: Codable {
                        let signal: [Signal]

                        enum CodingKeys: String, CodingKey {
                            case signal
                        }

                        struct Signal: Codable {
                            @Attribute var group: Group
                            @Attribute var function: Function?
                            @Attribute var pad: Pad
                            @Attribute var index: Index?
                            @Attribute var field: Field?

                            enum CodingKeys: String, CodingKey {
                                case group
                                case function
                                case pad
                                case index
                                case field
                            }

                            struct Group: ATDFStringValue {
                                static let P = Group(value: "P")
                                static let PCINT = Group(value: "PCINT")
                                static let PIN = Group(value: "PIN")
                                static let AIN = Group(value: "AIN")
                                static let ADC = Group(value: "ADC")
                                static let WO = Group(value: "WO")
                                static let INT = Group(value: "INT")
                                static let RXD = Group(value: "RXD")
                                static let TXD = Group(value: "TXD")
                                static let SEG = Group(value: "SEG")
                                static let XCK = Group(value: "XCK")
                                static let OCA = Group(value: "OCA")
                                static let EVAPA = Group(value: "EVAPA")
                                static let EVSPA = Group(value: "EVSPA")
                                static let OCB = Group(value: "OCB")
                                static let MISO = Group(value: "MISO")
                                static let MOSI = Group(value: "MOSI")
                                static let T = Group(value: "T")
                                static let EVOUT = Group(value: "EVOUT")
                                static let SS = Group(value: "SS")
                                static let SCK = Group(value: "SCK")
                                static let SDA = Group(value: "SDA")
                                static let SCL = Group(value: "SCL")
                                static let Y = Group(value: "Y")
                                static let LUT0_IN = Group(value: "LUT0_IN")
                                static let XDIR = Group(value: "XDIR")
                                static let EVAPB = Group(value: "EVAPB")
                                static let EVSPB = Group(value: "EVSPB")
                                static let X = Group(value: "X")
                                static let N = Group(value: "N")
                                static let ICP = Group(value: "ICP")
                                static let LUT0_OUT = Group(value: "LUT0_OUT")
                                static let LUT1_OUT = Group(value: "LUT1_OUT")
                                static let OUT = Group(value: "OUT")
                                static let LUT1_IN = Group(value: "LUT1_IN")
                                static let EVAPC = Group(value: "EVAPC")
                                static let EVSPC = Group(value: "EVSPC")
                                static let LUT2_IN = Group(value: "LUT2_IN")
                                static let TOSC1 = Group(value: "TOSC1")
                                static let TOSC2 = Group(value: "TOSC2")
                                static let TOSC = Group(value: "TOSC")
                                static let CLKO = Group(value: "CLKO")
                                static let LUT3_IN = Group(value: "LUT3_IN")
                                static let TOCC = Group(value: "TOCC")
                                static let RESET = Group(value: "RESET")
                                static let CLKI = Group(value: "CLKI")
                                static let BREAK = Group(value: "BREAK")
                                static let TCK = Group(value: "TCK")
                                static let TDI = Group(value: "TDI")
                                static let TDO = Group(value: "TDO")
                                static let TMS = Group(value: "TMS")
                                static let COM = Group(value: "COM")
                                static let AD = Group(value: "AD")
                                static let A = Group(value: "A")
                                static let UPDI = Group(value: "UPDI")
                                static let OCC = Group(value: "OCC")
                                static let LUT2_OUT = Group(value: "LUT2_OUT")
                                static let LUT3_OUT = Group(value: "LUT3_OUT")
                                static let CLK = Group(value: "CLK")
                                static let ACMPN = Group(value: "ACMPN")
                                static let ACMP = Group(value: "ACMP")
                                static let T0 = Group(value: "T0")
                                static let USCK = Group(value: "USCK")
                                static let DI = Group(value: "DI")
                                static let DO = Group(value: "DO")
                                static let OC = Group(value: "OC")
                                static let XTAL1 = Group(value: "XTAL1")
                                static let XTAL2 = Group(value: "XTAL2")
                                static let DS = Group(value: "DS")
                                static let OC0A = Group(value: "OC0A")
                                static let OC0B = Group(value: "OC0B")
                                static let OC1A = Group(value: "OC1A")
                                static let OC1B = Group(value: "OC1B")
                                static let T1 = Group(value: "T1")
                                static let WOA = Group(value: "WOA")
                                static let WOB = Group(value: "WOB")
                                static let AREF = Group(value: "AREF")
                                static let RESET_ALT = Group(value: "RESET_ALT")
                                static let PORTA = Group(value: "PORTA")
                                static let PORTB = Group(value: "PORTB")
                                static let PORTC = Group(value: "PORTC")
                                static let PORTD = Group(value: "PORTD")
                                static let WOC = Group(value: "WOC")
                                static let WOD = Group(value: "WOD")
                                static let PORTE = Group(value: "PORTE")
                                static let PDI = Group(value: "PDI")
                                static let PDO = Group(value: "PDO")
                                static let OC1AINV = Group(value: "OC1AINV")
                                static let OC1BINV = Group(value: "OC1BINV")
                                static let ICP1A = Group(value: "ICP1A")
                                static let ICP1B = Group(value: "ICP1B")
                                static let RXLIN = Group(value: "RXLIN")
                                static let TXLIN = Group(value: "TXLIN")
                                static let ICP0 = Group(value: "ICP0")
                                static let D2A = Group(value: "D2A")
                                static let T2 = Group(value: "T2")
                                static let AIN0 = Group(value: "AIN0")
                                static let AIN1 = Group(value: "AIN1")
                                static let ICP1 = Group(value: "ICP1")
                                static let ALE = Group(value: "ALE")
                                static let CTS = Group(value: "CTS")
                                static let RTS = Group(value: "RTS")
                                static let AC = Group(value: "AC")
                                static let RD = Group(value: "RD")
                                static let PSCOUT0A = Group(value: "PSCOUT0A")
                                static let PSCOUT0B = Group(value: "PSCOUT0B")
                                static let PSCOUT1A = Group(value: "PSCOUT1A")
                                static let PSCOUT1B = Group(value: "PSCOUT1B")
                                static let PSCOUT2A = Group(value: "PSCOUT2A")
                                static let PSCOUT2B = Group(value: "PSCOUT2B")
                                static let BREAK_ALT = Group(value: "BREAK_ALT")
                                static let PSCIN0 = Group(value: "PSCIN0")
                                static let PSCIN1 = Group(value: "PSCIN1")
                                static let PSCIN2 = Group(value: "PSCIN2")
                                static let WR = Group(value: "WR")
                                static let OC1DINV = Group(value: "OC1DINV")
                                static let RXCAN = Group(value: "RXCAN")
                                static let TXCAN = Group(value: "TXCAN")
                                static let OC1D = Group(value: "OC1D")
                                static let SCLK = Group(value: "SCLK")
                                static let scl = Group(value: "SCL ")
                                static let PCINT0 = Group(value: "PCINT0")
                                static let PCINT1 = Group(value: "PCINT1")
                                static let PCINT2 = Group(value: "PCINT2")
                                static let PCINT3 = Group(value: "PCINT3")
                                static let PCINT4 = Group(value: "PCINT4")
                                static let PCINT5 = Group(value: "PCINT5")
                                static let ACO0 = Group(value: "ACO0")
                                static let ACO1 = Group(value: "ACO1")
                                static let ICP2 = Group(value: "ICP2")
                                static let OC3C = Group(value: "OC3C")
                                static let ACO = Group(value: "ACO")
                                static let HWB = Group(value: "HWB")
                                static let OCD = Group(value: "OCD")
                                static let _OCA = Group(value: "_OCA")
                                static let _OCB = Group(value: "_OCB")
                                static let _OCD = Group(value: "_OCD")
                                static let PCINT27 = Group(value: "PCINT27")
                                static let PCINT28 = Group(value: "PCINT28")
                                static let PCINT29 = Group(value: "PCINT29")
                                static let PCINT30 = Group(value: "PCINT30")
                                static let PCINT31 = Group(value: "PCINT31")
                                static let ADC0 = Group(value: "ADC0")
                                static let ADC1 = Group(value: "ADC1")
                                static let ADC2 = Group(value: "ADC2")
                                static let ADC3 = Group(value: "ADC3")
                                static let ADC4 = Group(value: "ADC4")
                                static let ADC5 = Group(value: "ADC5")
                                static let ADC6 = Group(value: "ADC6")
                                static let ADC7 = Group(value: "ADC7")
                                static let INT0 = Group(value: "INT0")
                                static let INT1 = Group(value: "INT1")
                                static let INT2 = Group(value: "INT2")
                                static let SCL0 = Group(value: "SCL0")
                                static let SCL1 = Group(value: "SCL1")
                                static let SDA0 = Group(value: "SDA0")
                                static let SDA1 = Group(value: "SDA1")
                                static let WD = Group(value: "WD")

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Group] = [
                                            P,
                                            PCINT,
                                            PIN,
                                            AIN,
                                            ADC,
                                            WO,
                                            INT,
                                            RXD,
                                            TXD,
                                            SEG,
                                            XCK,
                                            OCA,
                                            EVAPA,
                                            EVSPA,
                                            OCB,
                                            MISO,
                                            MOSI,
                                            T,
                                            EVOUT,
                                            SS,
                                            SCK,
                                            SDA,
                                            SCL,
                                            Y,
                                            LUT0_IN,
                                            XDIR,
                                            EVAPB,
                                            EVSPB,
                                            X,
                                            N,
                                            ICP,
                                            LUT0_OUT,
                                            LUT1_OUT,
                                            OUT,
                                            LUT1_IN,
                                            EVAPC,
                                            EVSPC,
                                            LUT2_IN,
                                            TOSC1,
                                            TOSC2,
                                            TOSC,
                                            CLKO,
                                            LUT3_IN,
                                            TOCC,
                                            RESET,
                                            CLKI,
                                            BREAK,
                                            TCK,
                                            TDI,
                                            TDO,
                                            TMS,
                                            COM,
                                            AD,
                                            A,
                                            UPDI,
                                            OCC,
                                            LUT2_OUT,
                                            LUT3_OUT,
                                            CLK,
                                            ACMPN,
                                            ACMP,
                                            T0,
                                            USCK,
                                            DI,
                                            DO,
                                            OC,
                                            XTAL1,
                                            XTAL2,
                                            DS,
                                            OC0A,
                                            OC0B,
                                            OC1A,
                                            OC1B,
                                            T1,
                                            WOA,
                                            WOB,
                                            AREF,
                                            RESET_ALT,
                                            PORTA,
                                            PORTB,
                                            PORTC,
                                            PORTD,
                                            WOC,
                                            WOD,
                                            PORTE,
                                            PDI,
                                            PDO,
                                            OC1AINV,
                                            OC1BINV,
                                            ICP1A,
                                            ICP1B,
                                            RXLIN,
                                            TXLIN,
                                            ICP0,
                                            D2A,
                                            T2,
                                            AIN0,
                                            AIN1,
                                            ICP1,
                                            ALE,
                                            CTS,
                                            RTS,
                                            AC,
                                            RD,
                                            PSCOUT0A,
                                            PSCOUT0B,
                                            PSCOUT1A,
                                            PSCOUT1B,
                                            PSCOUT2A,
                                            PSCOUT2B,
                                            BREAK_ALT,
                                            PSCIN0,
                                            PSCIN1,
                                            PSCIN2,
                                            WR,
                                            OC1DINV,
                                            RXCAN,
                                            TXCAN,
                                            OC1D,
                                            SCLK,
                                            scl,
                                            PCINT0,
                                            PCINT1,
                                            PCINT2,
                                            PCINT3,
                                            PCINT4,
                                            PCINT5,
                                            ACO0,
                                            ACO1,
                                            ICP2,
                                            OC3C,
                                            ACO,
                                            HWB,
                                            OCD,
                                            _OCA,
                                            _OCB,
                                            _OCD,
                                            PCINT27,
                                            PCINT28,
                                            PCINT29,
                                            PCINT30,
                                            PCINT31,
                                            ADC0,
                                            ADC1,
                                            ADC2,
                                            ADC3,
                                            ADC4,
                                            ADC5,
                                            ADC6,
                                            ADC7,
                                            INT0,
                                            INT1,
                                            INT2,
                                            SCL0,
                                            SCL1,
                                            SDA0,
                                            SDA1,
                                            WD
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }

                            struct Function: ATDFStringValue {
                                static let `default` = Function(value: "default")
                                static let IOPORT = Function(value: "IOPORT")
                                static let AIN0 = Function(value: "AIN0")
                                static let CCL = Function(value: "CCL")
                                static let EVSINCH0 = Function(value: "EVSINCH0")
                                static let AC0 = Function(value: "AC0")
                                static let EVAINCH0 = Function(value: "EVAINCH0")
                                static let EXINT = Function(value: "EXINT")
                                static let USART0 = Function(value: "USART0")
                                static let ADC = Function(value: "ADC")
                                static let EXTINT = Function(value: "EXTINT")
                                static let CLKCTRL = Function(value: "CLKCTRL")
                                static let TCA0 = Function(value: "TCA0")
                                static let USART0_ALT = Function(value: "USART0_ALT")
                                static let EVSYS = Function(value: "EVSYS")
                                static let SPI = Function(value: "SPI")
                                static let EVAINCH1 = Function(value: "EVAINCH1")
                                static let EVSINCH1 = Function(value: "EVSINCH1")
                                static let TCA = Function(value: "TCA")
                                static let CCL_IN = Function(value: "CCL_IN")
                                static let OTHER = Function(value: "OTHER")
                                static let SPI0 = Function(value: "SPI0")
                                static let PTC_X = Function(value: "PTC_X")
                                static let PTC_Y = Function(value: "PTC_Y")
                                static let USART1 = Function(value: "USART1")
                                static let TCA0_ALT = Function(value: "TCA0_ALT")
                                static let PORTA = Function(value: "PORTA")
                                static let PORTB = Function(value: "PORTB")
                                static let SPI0_ALT = Function(value: "SPI0_ALT")
                                static let EVAINCH2 = Function(value: "EVAINCH2")
                                static let SPI_ALT = Function(value: "SPI_ALT")
                                static let CCL_ALT = Function(value: "CCL_ALT")
                                static let TWI0 = Function(value: "TWI0")
                                static let TCA_ALT3 = Function(value: "TCA_ALT3")
                                static let TCA_ALT5 = Function(value: "TCA_ALT5")
                                static let AC = Function(value: "AC")
                                static let OC = Function(value: "OC")
                                static let TCB0 = Function(value: "TCB0")
                                static let TCA_ALT = Function(value: "TCA_ALT")
                                static let AIN1 = Function(value: "AIN1")
                                static let TCD0 = Function(value: "TCD0")
                                static let T1 = Function(value: "T1")
                                static let TCA_ALT2 = Function(value: "TCA_ALT2")
                                static let I2C = Function(value: "I2C")
                                static let PSC = Function(value: "PSC")
                                static let USART0_ALT1 = Function(value: "USART0_ALT1")
                                static let USART1_ALT = Function(value: "USART1_ALT")
                                static let SPI_ALT1 = Function(value: "SPI_ALT1")
                                static let USART2 = Function(value: "USART2")
                                static let AC1 = Function(value: "AC1")
                                static let TC1 = Function(value: "TC1")
                                static let CCL_ALT1 = Function(value: "CCL_ALT1")
                                static let AC2 = Function(value: "AC2")
                                static let ACIN = Function(value: "ACIN")
                                static let TCB1 = Function(value: "TCB1")
                                static let USART2_ALT1 = Function(value: "USART2_ALT1")
                                static let TCA_ALT1 = Function(value: "TCA_ALT1")
                                static let TWI0_ALT = Function(value: "TWI0_ALT")
                                static let T0 = Function(value: "T0")
                                static let TCB0_ALT = Function(value: "TCB0_ALT")
                                static let EVSYS_ALT1 = Function(value: "EVSYS_ALT1")
                                static let USART = Function(value: "USART")
                                static let TC0 = Function(value: "TC0")
                                static let CS = Function(value: "CS")
                                static let USART1_ALT1 = Function(value: "USART1_ALT1")
                                static let EVSYS_ALT = Function(value: "EVSYS_ALT")
                                static let I2C_ALT1 = Function(value: "I2C_ALT1")
                                static let I2C_ALT2 = Function(value: "I2C_ALT2")
                                static let SPI_ALT2 = Function(value: "SPI_ALT2")
                                static let TCA_ALT4 = Function(value: "TCA_ALT4")
                                static let USART3 = Function(value: "USART3")
                                static let PTC_DS = Function(value: "PTC_DS")
                                static let TWI = Function(value: "TWI")
                                static let USI_ALT = Function(value: "USI_ALT")
                                static let BREAK = Function(value: "BREAK")
                                static let USI = Function(value: "USI")
                                static let DAC0 = Function(value: "DAC0")
                                static let LIN = Function(value: "LIN")
                                static let PDI = Function(value: "PDI")
                                static let AREF = Function(value: "AREF")
                                static let USART3_ALT1 = Function(value: "USART3_ALT1")
                                static let TCB0_ALT1 = Function(value: "TCB0_ALT1")
                                static let TCB1_ALT1 = Function(value: "TCB1_ALT1")
                                static let TCB2 = Function(value: "TCB2")
                                static let DEF = Function(value: "DEF")
                                static let BREAK_ALT = Function(value: "BREAK_ALT")
                                static let USART_ALT = Function(value: "USART_ALT")
                                static let TCB1_ALT = Function(value: "TCB1_ALT")
                                static let ACOUT = Function(value: "ACOUT")
                                static let DAC = Function(value: "DAC")
                                static let TCB2_ALT1 = Function(value: "TCB2_ALT1")
                                static let TCB3_ALT1 = Function(value: "TCB3_ALT1")
                                static let ACIN0 = Function(value: "ACIN0")
                                static let ACIN1 = Function(value: "ACIN1")
                                static let TCB3 = Function(value: "TCB3")
                                static let ALT = Function(value: "ALT")
                                static let ICP = Function(value: "ICP")

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Function] = [
                                            `default`,
                                            IOPORT,
                                            AIN0,
                                            CCL,
                                            EVSINCH0,
                                            AC0,
                                            EVAINCH0,
                                            EXINT,
                                            USART0,
                                            ADC,
                                            EXTINT,
                                            CLKCTRL,
                                            TCA0,
                                            USART0_ALT,
                                            EVSYS,
                                            SPI,
                                            EVAINCH1,
                                            EVSINCH1,
                                            TCA,
                                            CCL_IN,
                                            OTHER,
                                            SPI0,
                                            PTC_X,
                                            PTC_Y,
                                            USART1,
                                            TCA0_ALT,
                                            PORTA,
                                            PORTB,
                                            SPI0_ALT,
                                            EVAINCH2,
                                            SPI_ALT,
                                            CCL_ALT,
                                            TWI0,
                                            TCA_ALT3,
                                            TCA_ALT5,
                                            AC,
                                            OC,
                                            TCB0,
                                            TCA_ALT,
                                            AIN1,
                                            TCD0,
                                            T1,
                                            TCA_ALT2,
                                            I2C,
                                            PSC,
                                            USART0_ALT1,
                                            USART1_ALT,
                                            SPI_ALT1,
                                            USART2,
                                            AC1,
                                            TC1,
                                            CCL_ALT1,
                                            AC2,
                                            ACIN,
                                            TCB1,
                                            USART2_ALT1,
                                            TCA_ALT1,
                                            TWI0_ALT,
                                            T0,
                                            TCB0_ALT,
                                            EVSYS_ALT1,
                                            USART,
                                            TC0,
                                            CS,
                                            USART1_ALT1,
                                            EVSYS_ALT,
                                            I2C_ALT1,
                                            I2C_ALT2,
                                            SPI_ALT2,
                                            TCA_ALT4,
                                            USART3,
                                            PTC_DS,
                                            TWI,
                                            USI_ALT,
                                            BREAK,
                                            USI,
                                            DAC0,
                                            LIN,
                                            PDI,
                                            AREF,
                                            USART3_ALT1,
                                            TCB0_ALT1,
                                            TCB1_ALT1,
                                            TCB2,
                                            DEF,
                                            BREAK_ALT,
                                            USART_ALT,
                                            TCB1_ALT,
                                            ACOUT,
                                            DAC,
                                            TCB2_ALT1,
                                            TCB3_ALT1,
                                            ACIN0,
                                            ACIN1,
                                            TCB3,
                                            ALT,
                                            ICP
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }

                            struct Pad: ATDFStringValue {
                                static let PB2 = Pad(value: "PB2")
                                static let PB0 = Pad(value: "PB0")
                                static let PB1 = Pad(value: "PB1")
                                static let PA2 = Pad(value: "PA2")
                                static let PA3 = Pad(value: "PA3")
                                static let PB3 = Pad(value: "PB3")
                                static let PA1 = Pad(value: "PA1")
                                static let PA7 = Pad(value: "PA7")
                                static let PA4 = Pad(value: "PA4")
                                static let PA5 = Pad(value: "PA5")
                                static let PA0 = Pad(value: "PA0")
                                static let PB4 = Pad(value: "PB4")
                                static let PA6 = Pad(value: "PA6")
                                static let PB5 = Pad(value: "PB5")
                                static let PC1 = Pad(value: "PC1")
                                static let PC2 = Pad(value: "PC2")
                                static let PC3 = Pad(value: "PC3")
                                static let PC0 = Pad(value: "PC0")
                                static let PB7 = Pad(value: "PB7")
                                static let PD3 = Pad(value: "PD3")
                                static let PC4 = Pad(value: "PC4")
                                static let PD2 = Pad(value: "PD2")
                                static let PB6 = Pad(value: "PB6")
                                static let PD6 = Pad(value: "PD6")
                                static let PD4 = Pad(value: "PD4")
                                static let PC5 = Pad(value: "PC5")
                                static let PD5 = Pad(value: "PD5")
                                static let PD1 = Pad(value: "PD1")
                                static let PD0 = Pad(value: "PD0")
                                static let PD7 = Pad(value: "PD7")
                                static let PC6 = Pad(value: "PC6")
                                static let PE2 = Pad(value: "PE2")
                                static let PC7 = Pad(value: "PC7")
                                static let PF4 = Pad(value: "PF4")
                                static let PF5 = Pad(value: "PF5")
                                static let PE0 = Pad(value: "PE0")
                                static let PE1 = Pad(value: "PE1")
                                static let PF6 = Pad(value: "PF6")
                                static let PE3 = Pad(value: "PE3")
                                static let PF2 = Pad(value: "PF2")
                                static let PF3 = Pad(value: "PF3")
                                static let PF0 = Pad(value: "PF0")
                                static let PF1 = Pad(value: "PF1")
                                static let PE6 = Pad(value: "PE6")
                                static let PE7 = Pad(value: "PE7")
                                static let PF7 = Pad(value: "PF7")
                                static let PE5 = Pad(value: "PE5")
                                static let PE4 = Pad(value: "PE4")
                                static let PG3 = Pad(value: "PG3")
                                static let PG4 = Pad(value: "PG4")
                                static let PG2 = Pad(value: "PG2")
                                static let PG1 = Pad(value: "PG1")
                                static let PG0 = Pad(value: "PG0")
                                static let PG5 = Pad(value: "PG5")
                                static let XTAL1 = Pad(value: "XTAL1")
                                static let XTAL2 = Pad(value: "XTAL2")
                                static let PJ0 = Pad(value: "PJ0")
                                static let PJ1 = Pad(value: "PJ1")
                                static let PJ2 = Pad(value: "PJ2")
                                static let PK0 = Pad(value: "PK0")
                                static let PK1 = Pad(value: "PK1")
                                static let PK2 = Pad(value: "PK2")
                                static let PK3 = Pad(value: "PK3")
                                static let PK4 = Pad(value: "PK4")
                                static let PK5 = Pad(value: "PK5")
                                static let PK6 = Pad(value: "PK6")
                                static let PK7 = Pad(value: "PK7")
                                static let PH0 = Pad(value: "PH0")
                                static let PH1 = Pad(value: "PH1")
                                static let PH2 = Pad(value: "PH2")
                                static let PH3 = Pad(value: "PH3")
                                static let PH4 = Pad(value: "PH4")
                                static let PH5 = Pad(value: "PH5")
                                static let PH6 = Pad(value: "PH6")
                                static let PJ3 = Pad(value: "PJ3")
                                static let PJ4 = Pad(value: "PJ4")
                                static let PJ5 = Pad(value: "PJ5")
                                static let PJ6 = Pad(value: "PJ6")
                                static let PL0 = Pad(value: "PL0")
                                static let PL1 = Pad(value: "PL1")
                                static let PL2 = Pad(value: "PL2")
                                static let PL3 = Pad(value: "PL3")
                                static let PL4 = Pad(value: "PL4")
                                static let PL5 = Pad(value: "PL5")
                                static let PH7 = Pad(value: "PH7")
                                static let PJ7 = Pad(value: "PJ7")
                                static let PL6 = Pad(value: "PL6")
                                static let PL7 = Pad(value: "PL7")
                                static let ADC6 = Pad(value: "ADC6")
                                static let ADC7 = Pad(value: "ADC7")
                                static let PBH7 = Pad(value: "PBH7")

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Pad] = [
                                            PB2,
                                            PB0,
                                            PB1,
                                            PA2,
                                            PA3,
                                            PB3,
                                            PA1,
                                            PA7,
                                            PA4,
                                            PA5,
                                            PA0,
                                            PB4,
                                            PA6,
                                            PB5,
                                            PC1,
                                            PC2,
                                            PC3,
                                            PC0,
                                            PB7,
                                            PD3,
                                            PC4,
                                            PD2,
                                            PB6,
                                            PD6,
                                            PD4,
                                            PC5,
                                            PD5,
                                            PD1,
                                            PD0,
                                            PD7,
                                            PC6,
                                            PE2,
                                            PC7,
                                            PF4,
                                            PF5,
                                            PE0,
                                            PE1,
                                            PF6,
                                            PE3,
                                            PF2,
                                            PF3,
                                            PF0,
                                            PF1,
                                            PE6,
                                            PE7,
                                            PF7,
                                            PE5,
                                            PE4,
                                            PG3,
                                            PG4,
                                            PG2,
                                            PG1,
                                            PG0,
                                            PG5,
                                            XTAL1,
                                            XTAL2,
                                            PJ0,
                                            PJ1,
                                            PJ2,
                                            PK0,
                                            PK1,
                                            PK2,
                                            PK3,
                                            PK4,
                                            PK5,
                                            PK6,
                                            PK7,
                                            PH0,
                                            PH1,
                                            PH2,
                                            PH3,
                                            PH4,
                                            PH5,
                                            PH6,
                                            PJ3,
                                            PJ4,
                                            PJ5,
                                            PJ6,
                                            PL0,
                                            PL1,
                                            PL2,
                                            PL3,
                                            PL4,
                                            PL5,
                                            PH7,
                                            PJ7,
                                            PL6,
                                            PL7,
                                            ADC6,
                                            ADC7,
                                            PBH7
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }

                            struct Index: ATDFStringValue {
                                static let zero = Index(value: "0")
                                static let one = Index(value: "1")
                                static let two = Index(value: "2")
                                static let three = Index(value: "3")
                                static let four = Index(value: "4")
                                static let five = Index(value: "5")
                                static let six = Index(value: "6")
                                static let seven = Index(value: "7")
                                static let ten = Index(value: "10")
                                static let eight = Index(value: "8")
                                static let nine = Index(value: "9")
                                static let eleven = Index(value: "11")
                                static let twelve = Index(value: "12")
                                static let thirteen = Index(value: "13")
                                static let fourteen = Index(value: "14")
                                static let fifteen = Index(value: "15")
                                static let sixteen = Index(value: "16")
                                static let seventeen = Index(value: "17")
                                static let eighteen = Index(value: "18")
                                static let nineteen = Index(value: "19")
                                static let twenty = Index(value: "20")
                                static let twentyOne = Index(value: "21")
                                static let twentyTwo = Index(value: "22")
                                static let twentyThree = Index(value: "23")
                                static let twentyFour = Index(value: "24")
                                static let twentyFive = Index(value: "25")
                                static let twentySix = Index(value: "26")
                                static let twentySeven = Index(value: "27")
                                static let twentyEight = Index(value: "28")
                                static let twentyNine = Index(value: "29")
                                static let thirty = Index(value: "30")
                                static let thirtyOne = Index(value: "31")
                                static let zeroAlt2 = Index(value: "00")
                                static let oneAlt2 = Index(value: "01")
                                static let twoAlt2 = Index(value: "02")
                                static let threeAlt2 = Index(value: "03")
                                static let fourAlt2 = Index(value: "04")
                                static let fiveAlt2 = Index(value: "05")
                                static let sixAlt2 = Index(value: "06")
                                static let sevenAlt2 = Index(value: "07")
                                static let eightAlt2 = Index(value: "08")
                                static let nineAlt2 = Index(value: "09")
                                static let thirtyTwo = Index(value: "32")
                                static let thirtyThree = Index(value: "33")

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Index] = [
                                            zero,
                                            one,
                                            two,
                                            three,
                                            four,
                                            five,
                                            six,
                                            seven,
                                            ten,
                                            eight,
                                            nine,
                                            eleven,
                                            twelve,
                                            thirteen,
                                            fourteen,
                                            fifteen,
                                            sixteen,
                                            seventeen,
                                            eighteen,
                                            nineteen,
                                            twenty,
                                            twentyOne,
                                            twentyTwo,
                                            twentyThree,
                                            twentyFour,
                                            twentyFive,
                                            twentySix,
                                            twentySeven,
                                            twentyEight,
                                            twentyNine,
                                            thirty,
                                            thirtyOne,
                                            zeroAlt2,
                                            oneAlt2,
                                            twoAlt2,
                                            threeAlt2,
                                            fourAlt2,
                                            fiveAlt2,
                                            sixAlt2,
                                            sevenAlt2,
                                            eightAlt2,
                                            nineAlt2,
                                            thirtyTwo,
                                            thirtyThree
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }

                            struct Field: ATDFStringValue {
                                static let portmuxTcarouteaTCA0 = Field(value: "PORTMUX.TCAROUTEA.TCA0")
                                static let evsysSyncch0Syncch0 = Field(value: "EVSYS.SYNCCH0.SYNCCH0")
                                static let evsysAsyncch0Asyncch0 = Field(value: "EVSYS.ASYNCCH0.ASYNCCH0")
                                static let portmuxCtrlbUsart0 = Field(value: "PORTMUX.CTRLB.USART0")
                                static let portmuxUsartrouteaUsart0 = Field(value: "PORTMUX.USARTROUTEA.USART0")
                                static let portmuxCtrlbSPI0 = Field(value: "PORTMUX.CTRLB.SPI0")
                                static let portmuxUsartrouteaUsart1 = Field(value: "PORTMUX.USARTROUTEA.USART1")
                                static let evsysAsyncch1Asyncch1 = Field(value: "EVSYS.ASYNCCH1.ASYNCCH1")
                                static let evsysSyncch1Syncch1 = Field(value: "EVSYS.SYNCCH1.SYNCCH1")
                                static let portmuxTwispirouteaSPI0 = Field(value: "PORTMUX.TWISPIROUTEA.SPI0")
                                static let portmuxSpirouteaSPI0 = Field(value: "PORTMUX.SPIROUTEA.SPI0")
                                static let portmuxCtrlbTWI0 = Field(value: "PORTMUX.CTRLB.TWI0")
                                static let evsysAsyncch2Asyncch2 = Field(value: "EVSYS.ASYNCCH2.ASYNCCH2")
                                static let portmuxUsartrouteaUsart2 = Field(value: "PORTMUX.USARTROUTEA.USART2")
                                static let portmuxCtrlcTCA00 = Field(value: "PORTMUX.CTRLC.TCA00")
                                static let portmuxTwispirouteaTWI0 = Field(value: "PORTMUX.TWISPIROUTEA.TWI0")
                                static let portmuxCclrouteaLUT0 = Field(value: "PORTMUX.CCLROUTEA.LUT0")
                                static let portmuxCclrouteaLUT1 = Field(value: "PORTMUX.CCLROUTEA.LUT1")
                                static let portmuxCclrouteaLUT2 = Field(value: "PORTMUX.CCLROUTEA.LUT2")
                                static let portmuxCclrouteaLUT3 = Field(value: "PORTMUX.CCLROUTEA.LUT3")
                                static let portmuxTcbrouteaTCB0 = Field(value: "PORTMUX.TCBROUTEA.TCB0")
                                static let portmuxCtrlcTCA01 = Field(value: "PORTMUX.CTRLC.TCA01")
                                static let portmuxCtrlcTCA02 = Field(value: "PORTMUX.CTRLC.TCA02")
                                static let portmuxCtrlcTCA03 = Field(value: "PORTMUX.CTRLC.TCA03")
                                static let portmuxCtrlaLUT0 = Field(value: "PORTMUX.CTRLA.LUT0")
                                static let portmuxCtrlaLUT1 = Field(value: "PORTMUX.CTRLA.LUT1")
                                static let portmuxCtrldTCB0 = Field(value: "PORTMUX.CTRLD.TCB0")
                                static let portmuxEvsysrouteaEvouta = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTA")
                                static let portmuxTcbrouteaTCB1 = Field(value: "PORTMUX.TCBROUTEA.TCB1")
                                static let USIPOS = Field(value: "USIPOS")
                                static let portmuxCtrlcTCA04 = Field(value: "PORTMUX.CTRLC.TCA04")
                                static let portmuxCtrlcTCA05 = Field(value: "PORTMUX.CTRLC.TCA05")
                                static let portmuxCtrlaEvout0 = Field(value: "PORTMUX.CTRLA.EVOUT0")
                                static let portmuxUsartrouteaUsart3 = Field(value: "PORTMUX.USARTROUTEA.USART3")
                                static let portmuxCtrlaEvout1 = Field(value: "PORTMUX.CTRLA.EVOUT1")
                                static let portmuxCtrlaExtbrk = Field(value: "PORTMUX.CTRLA.EXTBRK")
                                static let portmuxEvsysrouteaEvoutb = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTB")
                                static let SPIMAP = Field(value: "SPIMAP")
                                static let portmuxEvsysrouteaEvoutc = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTC")
                                static let portmuxCtrlaEvout2 = Field(value: "PORTMUX.CTRLA.EVOUT2")
                                static let portmuxTcbrouteaTCB2 = Field(value: "PORTMUX.TCBROUTEA.TCB2")
                                static let U0MAP = Field(value: "U0MAP")
                                static let portmuxEvsysrouteaEvout0 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT0")
                                static let portmuxEvsysrouteaEvout3 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT3")
                                static let portmuxEvsysrouteaEvoutd = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTD")
                                static let portmuxTcbrouteaTCB3 = Field(value: "PORTMUX.TCBROUTEA.TCB3")
                                static let REMAP = Field(value: "REMAP")
                                static let portmuxCtrldTCB1 = Field(value: "PORTMUX.CTRLD.TCB1")
                                static let portmuxEvsysrouteaEvout2 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT2")
                                static let portmuxEvsysrouteaEvout5 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT5")
                                static let portmuxEvsysrouteaEvoutf = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTF")
                                static let portmuxEvsysrouteaEvout1 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT1")
                                static let portmuxEvsysrouteaEvout4 = Field(value: "PORTMUX.EVSYSROUTEA.EVOUT4")
                                static let portmuxEvsysrouteaEvoute = Field(value: "PORTMUX.EVSYSROUTEA.EVOUTE")

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Field] = [
                                            portmuxTcarouteaTCA0,
                                            evsysSyncch0Syncch0,
                                            evsysAsyncch0Asyncch0,
                                            portmuxCtrlbUsart0,
                                            portmuxUsartrouteaUsart0,
                                            portmuxCtrlbSPI0,
                                            portmuxUsartrouteaUsart1,
                                            evsysAsyncch1Asyncch1,
                                            evsysSyncch1Syncch1,
                                            portmuxTwispirouteaSPI0,
                                            portmuxSpirouteaSPI0,
                                            portmuxCtrlbTWI0,
                                            evsysAsyncch2Asyncch2,
                                            portmuxUsartrouteaUsart2,
                                            portmuxCtrlcTCA00,
                                            portmuxTwispirouteaTWI0,
                                            portmuxCclrouteaLUT0,
                                            portmuxCclrouteaLUT1,
                                            portmuxCclrouteaLUT2,
                                            portmuxCclrouteaLUT3,
                                            portmuxTcbrouteaTCB0,
                                            portmuxCtrlcTCA01,
                                            portmuxCtrlcTCA02,
                                            portmuxCtrlcTCA03,
                                            portmuxCtrlaLUT0,
                                            portmuxCtrlaLUT1,
                                            portmuxCtrldTCB0,
                                            portmuxEvsysrouteaEvouta,
                                            portmuxTcbrouteaTCB1,
                                            USIPOS,
                                            portmuxCtrlcTCA04,
                                            portmuxCtrlcTCA05,
                                            portmuxCtrlaEvout0,
                                            portmuxUsartrouteaUsart3,
                                            portmuxCtrlaEvout1,
                                            portmuxCtrlaExtbrk,
                                            portmuxEvsysrouteaEvoutb,
                                            SPIMAP,
                                            portmuxEvsysrouteaEvoutc,
                                            portmuxCtrlaEvout2,
                                            portmuxTcbrouteaTCB2,
                                            U0MAP,
                                            portmuxEvsysrouteaEvout0,
                                            portmuxEvsysrouteaEvout3,
                                            portmuxEvsysrouteaEvoutd,
                                            portmuxTcbrouteaTCB3,
                                            REMAP,
                                            portmuxCtrldTCB1,
                                            portmuxEvsysrouteaEvout2,
                                            portmuxEvsysrouteaEvout5,
                                            portmuxEvsysrouteaEvoutf,
                                            portmuxEvsysrouteaEvout1,
                                            portmuxEvsysrouteaEvout4,
                                            portmuxEvsysrouteaEvoute
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }
                        }
                    }

                    struct Parameters: Codable {
                        let param: [Param]

                        enum CodingKeys: String, CodingKey {
                            case param
                        }

                        struct Param: Codable {
                            @Attribute var name: Name
                            @Attribute var value: Value

                            enum CodingKeys: String, CodingKey {
                                case name
                                case value
                            }

                            struct Name: ATDFStringValue {
                                static let CORE_VERSION = Name(value: "CORE_VERSION")
                                static let NEW_INSTRUCTIONS = Name(value: "NEW_INSTRUCTIONS")

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Name] = [
                                            CORE_VERSION,
                                            NEW_INSTRUCTIONS
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }

                            struct Value: ATDFStringValue {
                                static let V2E = Value(value: "V2E")
                                static let V4 = Value(value: "V4")
                                static let V2 = Value(value: "V2")
                                static let lpmRdZ = Value(value: "lpm rd,z+")
                                static let V3 = Value(value: "V3")
                                static let AVR8L_0 = Value(value: "AVR8L_0")
                                static let V0E = Value(value: "V0E")
                                static let lpmRdZAlt2 = Value(value: "lpm rd,z")
                                static let V1 = Value(value: "V1")

                                let rawValue: String
                                let alternateValues: [String]

                                static let allCases: [Value] = [
                                            V2E,
                                            V4,
                                            V2,
                                            lpmRdZ,
                                            V3,
                                            AVR8L_0,
                                            V0E,
                                            lpmRdZAlt2,
                                            V1
                                        ]

                                init(value: String, alternateValues: [String] = []) {
                                    self.rawValue = value
                                    self.alternateValues = alternateValues
                                }
                            }
                        }
                    }
                }
            }
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

                struct Endianness: ATDFStringValue {
                    static let little = Endianness(value: "little")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Endianness] = [
                                little
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Name: ATDFStringValue {
                    static let data = Name(value: "data")
                    static let prog = Name(value: "prog")
                    static let signatures = Name(value: "signatures")
                    static let lockbits = Name(value: "lockbits")
                    static let fuses = Name(value: "fuses")
                    static let eeprom = Name(value: "eeprom")
                    static let io = Name(value: "io")
                    static let osccal = Name(value: "osccal")
                    static let user_signatures = Name(value: "user_signatures")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Name] = [
                                data,
                                prog,
                                signatures,
                                lockbits,
                                fuses,
                                eeprom,
                                io,
                                osccal,
                                user_signatures
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct ID: ATDFStringValue {
                    static let data = ID(value: "data")
                    static let prog = ID(value: "prog")
                    static let signatures = ID(value: "signatures")
                    static let lockbits = ID(value: "lockbits")
                    static let fuses = ID(value: "fuses")
                    static let eeprom = ID(value: "eeprom")
                    static let io = ID(value: "io")
                    static let osccal = ID(value: "osccal")
                    static let user_signatures = ID(value: "user_signatures")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [ID] = [
                                data,
                                prog,
                                signatures,
                                lockbits,
                                fuses,
                                eeprom,
                                io,
                                osccal,
                                user_signatures
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Start: ATDFStringValue {
                    static let zero = Start(value: "0")
                    static let zeroX0000 = Start(value: "0x0000")
                    static let zeroX00 = Start(value: "0x00")
                    static let zeroX0100 = Start(value: "0x0100")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Start] = [
                                zero,
                                zeroX0000,
                                zeroX00,
                                zeroX0100
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Size: ATDFStringValue {
                    static let zeroX0001 = Size(value: "0x0001")
                    static let three = Size(value: "3")
                    static let zeroX40 = Size(value: "0x40")
                    static let zeroX0003 = Size(value: "0x0003")
                    static let one = Size(value: "1")
                    static let zeroX10000 = Size(value: "0x10000")
                    static let zeroX0200 = Size(value: "0x0200")
                    static let zeroX0400 = Size(value: "0x0400")
                    static let zeroX4000 = Size(value: "0x4000")
                    static let zeroX1000 = Size(value: "0x1000")
                    static let zeroX2000 = Size(value: "0x2000")
                    static let zeroX0800 = Size(value: "0x0800")
                    static let zeroX8000 = Size(value: "0x8000")
                    static let zeroX0900 = Size(value: "0x0900")
                    static let zeroX0300 = Size(value: "0x0300")
                    static let zeroX0500 = Size(value: "0x0500")
                    static let zeroX1100 = Size(value: "0x1100")
                    static let zeroX0002 = Size(value: "0x0002")
                    static let zeroX0100 = Size(value: "0x0100")
                    static let four = Size(value: "4")
                    static let zeroX20000 = Size(value: "0x20000")
                    static let two = Size(value: "2")
                    static let zeroX0040 = Size(value: "0x0040")
                    static let zeroX0080 = Size(value: "0x0080")
                    static let zeroX00e0 = Size(value: "0x00e0")
                    static let zeroXC000 = Size(value: "0xC000")
                    static let zeroX0160 = Size(value: "0x0160")
                    static let zeroX9000 = Size(value: "0x9000")
                    static let zeroX0260 = Size(value: "0x0260")
                    static let zeroXA000 = Size(value: "0xA000")
                    static let zeroX4200 = Size(value: "0x4200")
                    static let zeroX40000 = Size(value: "0x40000")
                    static let zeroX0460 = Size(value: "0x0460")
                    static let zeroX4400 = Size(value: "0x4400")
                    static let zeroX8800 = Size(value: "0x8800")
                    static let zeroX00a0 = Size(value: "0x00a0")
                    static let zeroX0860 = Size(value: "0x0860")
                    static let zeroX2200 = Size(value: "0x2200")
                    static let zeroX4100 = Size(value: "0x4100")
                    static let zeroX8200 = Size(value: "0x8200")
                    static let zeroX0600 = Size(value: "0x0600")
                    static let zeroX0b00 = Size(value: "0x0b00")
                    static let zeroX4800 = Size(value: "0x4800")
                    static let zeroX5000 = Size(value: "0x5000")
                    static let zeroXa000 = Size(value: "0xa000")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Size] = [
                                zeroX0001,
                                three,
                                zeroX40,
                                zeroX0003,
                                one,
                                zeroX10000,
                                zeroX0200,
                                zeroX0400,
                                zeroX4000,
                                zeroX1000,
                                zeroX2000,
                                zeroX0800,
                                zeroX8000,
                                zeroX0900,
                                zeroX0300,
                                zeroX0500,
                                zeroX1100,
                                zeroX0002,
                                zeroX0100,
                                four,
                                zeroX20000,
                                two,
                                zeroX0040,
                                zeroX0080,
                                zeroX00e0,
                                zeroXC000,
                                zeroX0160,
                                zeroX9000,
                                zeroX0260,
                                zeroXA000,
                                zeroX4200,
                                zeroX40000,
                                zeroX0460,
                                zeroX4400,
                                zeroX8800,
                                zeroX00a0,
                                zeroX0860,
                                zeroX2200,
                                zeroX4100,
                                zeroX8200,
                                zeroX0600,
                                zeroX0b00,
                                zeroX4800,
                                zeroX5000,
                                zeroXa000
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct MemorySegment: Codable {
                    @Attribute var start: Start
                    @Attribute var size: Size
                    @Attribute var type: Kind
                    @Attribute var rw: ReadWrite?
                    @Attribute var exec: Exec?
                    @Attribute var name: Name
                    @Attribute var pagesize: Pagesize?
                    @Attribute var external: Bool?

                    enum CodingKeys: String, CodingKey {
                        case start
                        case size
                        case type
                        case rw
                        case exec
                        case name
                        case pagesize
                        case external
                    }

                    struct Start: ATDFStringValue {
                        static let zero = Start(value: "0")
                        static let zeroX0000 = Start(value: "0x0000")
                        static let zeroX0020 = Start(value: "0x0020")
                        static let zeroX0100 = Start(value: "0x0100")
                        static let zeroX00 = Start(value: "0x00")
                        static let zeroX1100 = Start(value: "0x1100")
                        static let zeroX1103 = Start(value: "0x1103")
                        static let zeroX1280 = Start(value: "0x1280")
                        static let zeroX128A = Start(value: "0x128A")
                        static let zeroX1300 = Start(value: "0x1300")
                        static let zeroX1400 = Start(value: "0x1400")
                        static let zeroX8000 = Start(value: "0x8000")
                        static let zeroX3800 = Start(value: "0x3800")
                        static let zeroX7000 = Start(value: "0x7000")
                        static let zeroX7800 = Start(value: "0x7800")
                        static let zeroX7c00 = Start(value: "0x7c00")
                        static let zeroX7e00 = Start(value: "0x7e00")
                        static let zeroX0060 = Start(value: "0x0060")
                        static let zeroXe000 = Start(value: "0xe000")
                        static let zeroXf000 = Start(value: "0xf000")
                        static let zeroXf800 = Start(value: "0xf800")
                        static let zeroXfc00 = Start(value: "0xfc00")
                        static let zeroX3c00 = Start(value: "0x3c00")
                        static let zeroX3e00 = Start(value: "0x3e00")
                        static let zeroX3f00 = Start(value: "0x3f00")
                        static let zeroX1800 = Start(value: "0x1800")
                        static let zeroX1c00 = Start(value: "0x1c00")
                        static let zeroX1e00 = Start(value: "0x1e00")
                        static let zeroX4000 = Start(value: "0x4000")
                        static let zeroX1f00 = Start(value: "0x1f00")
                        static let zeroX3F00 = Start(value: "0x3F00")
                        static let zeroX1e000 = Start(value: "0x1e000")
                        static let zeroX1f000 = Start(value: "0x1f000")
                        static let zeroX1f800 = Start(value: "0x1f800")
                        static let zeroX1fc00 = Start(value: "0x1fc00")
                        static let zeroX0200 = Start(value: "0x0200")
                        static let zeroX3F80 = Start(value: "0x3F80")
                        static let zeroX3000 = Start(value: "0x3000")
                        static let zeroX2200 = Start(value: "0x2200")
                        static let zeroX3E00 = Start(value: "0x3E00")
                        static let zeroX0040 = Start(value: "0x0040")
                        static let zeroX3C00 = Start(value: "0x3C00")
                        static let zeroX3F40 = Start(value: "0x3F40")
                        static let zeroX3FC0 = Start(value: "0x3FC0")
                        static let zeroX3e000 = Start(value: "0x3e000")
                        static let zeroX3f000 = Start(value: "0x3f000")
                        static let zeroX3f800 = Start(value: "0x3f800")
                        static let zeroX3fc00 = Start(value: "0x3fc00")
                        static let zeroX3400 = Start(value: "0x3400")
                        static let zeroX1000 = Start(value: "0x1000")
                        static let zeroX2800 = Start(value: "0x2800")
                        static let zeroX0260 = Start(value: "0x0260")
                        static let zeroX0500 = Start(value: "0x0500")
                        static let zeroX0900 = Start(value: "0x0900")
                        static let zeroX6000 = Start(value: "0x6000")
                        static let zeroX9000 = Start(value: "0x9000")
                        static let zeroX9800 = Start(value: "0x9800")
                        static let zeroX9c00 = Start(value: "0x9c00")
                        static let zeroX9e00 = Start(value: "0x9e00")

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Start] = [
                                    zero,
                                    zeroX0000,
                                    zeroX0020,
                                    zeroX0100,
                                    zeroX00,
                                    zeroX1100,
                                    zeroX1103,
                                    zeroX1280,
                                    zeroX128A,
                                    zeroX1300,
                                    zeroX1400,
                                    zeroX8000,
                                    zeroX3800,
                                    zeroX7000,
                                    zeroX7800,
                                    zeroX7c00,
                                    zeroX7e00,
                                    zeroX0060,
                                    zeroXe000,
                                    zeroXf000,
                                    zeroXf800,
                                    zeroXfc00,
                                    zeroX3c00,
                                    zeroX3e00,
                                    zeroX3f00,
                                    zeroX1800,
                                    zeroX1c00,
                                    zeroX1e00,
                                    zeroX4000,
                                    zeroX1f00,
                                    zeroX3F00,
                                    zeroX1e000,
                                    zeroX1f000,
                                    zeroX1f800,
                                    zeroX1fc00,
                                    zeroX0200,
                                    zeroX3F80,
                                    zeroX3000,
                                    zeroX2200,
                                    zeroX3E00,
                                    zeroX0040,
                                    zeroX3C00,
                                    zeroX3F40,
                                    zeroX3FC0,
                                    zeroX3e000,
                                    zeroX3f000,
                                    zeroX3f800,
                                    zeroX3fc00,
                                    zeroX3400,
                                    zeroX1000,
                                    zeroX2800,
                                    zeroX0260,
                                    zeroX0500,
                                    zeroX0900,
                                    zeroX6000,
                                    zeroX9000,
                                    zeroX9800,
                                    zeroX9c00,
                                    zeroX9e00
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Size: ATDFStringValue {
                        static let zeroX0400 = Size(value: "0x0400")
                        static let zeroX0800 = Size(value: "0x0800")
                        static let zeroX0001 = Size(value: "0x0001")
                        static let zeroX1000 = Size(value: "0x1000")
                        static let three = Size(value: "3")
                        static let zeroX0020 = Size(value: "0x0020")
                        static let zeroX0200 = Size(value: "0x0200")
                        static let zeroX0003 = Size(value: "0x0003")
                        static let one = Size(value: "1")
                        static let zeroX00e0 = Size(value: "0x00e0")
                        static let zeroX2000 = Size(value: "0x2000")
                        static let zeroX0100 = Size(value: "0x0100")
                        static let zeroX4000 = Size(value: "0x4000")
                        static let zeroX8000 = Size(value: "0x8000")
                        static let zeroX1100 = Size(value: "0x1100")
                        static let zeroX01 = Size(value: "0x01")
                        static let zeroX03 = Size(value: "0x03")
                        static let zeroX0A = Size(value: "0x0A")
                        static let zeroX20 = Size(value: "0x20")
                        static let zeroX0040 = Size(value: "0x0040")
                        static let zeroX0002 = Size(value: "0x0002")
                        static let zeroX3D = Size(value: "0x3D")
                        static let zeroX100 = Size(value: "0x100")
                        static let zeroX10000 = Size(value: "0x10000")
                        static let zeroX80 = Size(value: "0x80")
                        static let zeroX800 = Size(value: "0x800")
                        static let zeroX40 = Size(value: "0x40")
                        static let zeroX0080 = Size(value: "0x0080")
                        static let four = Size(value: "4")
                        static let zeroX20000 = Size(value: "0x20000")
                        static let zeroX01e0 = Size(value: "0x01e0")
                        static let two = Size(value: "2")
                        static let zeroXde00 = Size(value: "0xde00")
                        static let zeroX200 = Size(value: "0x200")
                        static let zeroX0004 = Size(value: "0x0004")
                        static let zeroX400 = Size(value: "0x400")
                        static let zeroXef00 = Size(value: "0xef00")
                        static let zeroX0300 = Size(value: "0x0300")
                        static let zeroX40000 = Size(value: "0x40000")
                        static let zeroXC000 = Size(value: "0xC000")
                        static let zeroX7D = Size(value: "0x7D")
                        static let zeroXC00 = Size(value: "0xC00")
                        static let zeroX1800 = Size(value: "0x1800")
                        static let zeroX0500 = Size(value: "0x0500")
                        static let zeroX0a00 = Size(value: "0x0a00")
                        static let zeroXa000 = Size(value: "0xa000")
                        static let zeroXf700 = Size(value: "0xf700")
                        static let zeroXfb00 = Size(value: "0xfb00")
                        static let zeroXfda0 = Size(value: "0xfda0")

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Size] = [
                                    zeroX0400,
                                    zeroX0800,
                                    zeroX0001,
                                    zeroX1000,
                                    three,
                                    zeroX0020,
                                    zeroX0200,
                                    zeroX0003,
                                    one,
                                    zeroX00e0,
                                    zeroX2000,
                                    zeroX0100,
                                    zeroX4000,
                                    zeroX8000,
                                    zeroX1100,
                                    zeroX01,
                                    zeroX03,
                                    zeroX0A,
                                    zeroX20,
                                    zeroX0040,
                                    zeroX0002,
                                    zeroX3D,
                                    zeroX100,
                                    zeroX10000,
                                    zeroX80,
                                    zeroX800,
                                    zeroX40,
                                    zeroX0080,
                                    four,
                                    zeroX20000,
                                    zeroX01e0,
                                    two,
                                    zeroXde00,
                                    zeroX200,
                                    zeroX0004,
                                    zeroX400,
                                    zeroXef00,
                                    zeroX0300,
                                    zeroX40000,
                                    zeroXC000,
                                    zeroX7D,
                                    zeroXC00,
                                    zeroX1800,
                                    zeroX0500,
                                    zeroX0a00,
                                    zeroXa000,
                                    zeroXf700,
                                    zeroXfb00,
                                    zeroXfda0
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Kind: ATDFStringValue {
                        static let flash = Kind(value: "flash")
                        static let signatures = Kind(value: "signatures")
                        static let ram = Kind(value: "ram")
                        static let lockbits = Kind(value: "lockbits")
                        static let fuses = Kind(value: "fuses")
                        static let io = Kind(value: "io")
                        static let eeprom = Kind(value: "eeprom")
                        static let regs = Kind(value: "regs")
                        static let osccal = Kind(value: "osccal")
                        static let user_signatures = Kind(value: "user_signatures")
                        static let other = Kind(value: "other")
                        static let sysreg = Kind(value: "sysreg")

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Kind] = [
                                    flash,
                                    signatures,
                                    ram,
                                    lockbits,
                                    fuses,
                                    io,
                                    eeprom,
                                    regs,
                                    osccal,
                                    user_signatures,
                                    other,
                                    sysreg
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct ReadWrite: ATDFStringValue {
                        static let RW = ReadWrite(value: "RW")
                        static let R = ReadWrite(value: "R")

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [ReadWrite] = [
                                    RW,
                                    R
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Exec: ATDFStringValue {
                        static let zero = Exec(value: "0")
                        static let one = Exec(value: "1")

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Exec] = [
                                    zero,
                                    one
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Name: ATDFStringValue {
                        static let SIGNATURES = Name(value: "SIGNATURES")
                        static let LOCKBITS = Name(value: "LOCKBITS")
                        static let FUSES = Name(value: "FUSES")
                        static let EEPROM = Name(value: "EEPROM")
                        static let FLASH = Name(value: "FLASH")
                        static let REGISTERS = Name(value: "REGISTERS")
                        static let MAPPED_IO = Name(value: "MAPPED_IO")
                        static let IRAM = Name(value: "IRAM")
                        static let OSCCAL = Name(value: "OSCCAL")
                        static let BOOT_SECTION_1 = Name(value: "BOOT_SECTION_1")
                        static let BOOT_SECTION_2 = Name(value: "BOOT_SECTION_2")
                        static let BOOT_SECTION_3 = Name(value: "BOOT_SECTION_3")
                        static let BOOT_SECTION_4 = Name(value: "BOOT_SECTION_4")
                        static let IO = Name(value: "IO")
                        static let USER_SIGNATURES = Name(value: "USER_SIGNATURES")
                        static let PROD_SIGNATURES = Name(value: "PROD_SIGNATURES")
                        static let MAPPED_PROGMEM = Name(value: "MAPPED_PROGMEM")
                        static let INTERNAL_SRAM = Name(value: "INTERNAL_SRAM")
                        static let PROGMEM = Name(value: "PROGMEM")
                        static let XRAM = Name(value: "XRAM")
                        static let MAPPED_CONFIGURATION_BITS = Name(value: "MAPPED_CONFIGURATION_BITS")
                        static let MAPPED_CALIBRATION_BITS = Name(value: "MAPPED_CALIBRATION_BITS")
                        static let MAPPED_DEVICE_ID_BITS = Name(value: "MAPPED_DEVICE_ID_BITS")
                        static let MAPPED_NVM_LOCK_BITS = Name(value: "MAPPED_NVM_LOCK_BITS")
                        static let MAPPED_FLASH = Name(value: "MAPPED_FLASH")
                        static let SRAM = Name(value: "SRAM")

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Name] = [
                                    SIGNATURES,
                                    LOCKBITS,
                                    FUSES,
                                    EEPROM,
                                    FLASH,
                                    REGISTERS,
                                    MAPPED_IO,
                                    IRAM,
                                    OSCCAL,
                                    BOOT_SECTION_1,
                                    BOOT_SECTION_2,
                                    BOOT_SECTION_3,
                                    BOOT_SECTION_4,
                                    IO,
                                    USER_SIGNATURES,
                                    PROD_SIGNATURES,
                                    MAPPED_PROGMEM,
                                    INTERNAL_SRAM,
                                    PROGMEM,
                                    XRAM,
                                    MAPPED_CONFIGURATION_BITS,
                                    MAPPED_CALIBRATION_BITS,
                                    MAPPED_DEVICE_ID_BITS,
                                    MAPPED_NVM_LOCK_BITS,
                                    MAPPED_FLASH,
                                    SRAM
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }

                    struct Pagesize: ATDFStringValue {
                        static let zeroX80 = Pagesize(value: "0x80")
                        static let zeroX40 = Pagesize(value: "0x40")
                        static let zeroX100 = Pagesize(value: "0x100")
                        static let zeroX20 = Pagesize(value: "0x20")
                        static let zeroX04 = Pagesize(value: "0x04")
                        static let zeroX08 = Pagesize(value: "0x08")
                        static let zeroX02 = Pagesize(value: "0x02")
                        static let zeroX10 = Pagesize(value: "0x10")

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Pagesize] = [
                                    zeroX80,
                                    zeroX40,
                                    zeroX100,
                                    zeroX20,
                                    zeroX04,
                                    zeroX08,
                                    zeroX02,
                                    zeroX10
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }
                }
            }
        }

        struct Interfaces: Codable {
            let interface: [Interface]

            enum CodingKeys: String, CodingKey {
                case interface
            }

            struct Interface: Codable {
                @Attribute var name: Name
                @Attribute var type: Kind
                let parameters: Parameters?

                enum CodingKeys: String, CodingKey {
                    case name
                    case type
                    case parameters
                }

                struct Name: ATDFStringValue {
                    static let ISP = Name(value: "ISP")
                    static let HVPP = Name(value: "HVPP")
                    static let JTAG = Name(value: "JTAG")
                    static let debugWIRE = Name(value: "debugWIRE")
                    static let UPDI = Name(value: "UPDI")
                    static let HVSP = Name(value: "HVSP")
                    static let TPI = Name(value: "TPI")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Name] = [
                                ISP,
                                HVPP,
                                JTAG,
                                debugWIRE,
                                UPDI,
                                HVSP,
                                TPI
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Kind: ATDFStringValue {
                    static let isp = Kind(value: "isp")
                    static let hvpp = Kind(value: "hvpp")
                    static let megajtag = Kind(value: "megajtag")
                    static let dw = Kind(value: "dw")
                    static let updi = Kind(value: "updi")
                    static let hvsp = Kind(value: "hvsp")
                    static let tpi = Kind(value: "tpi")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Kind] = [
                                isp,
                                hvpp,
                                megajtag,
                                dw,
                                updi,
                                hvsp,
                                tpi
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Parameters: Codable {
                    let param: Param

                    enum CodingKeys: String, CodingKey {
                        case param
                    }

                    struct Param: Codable {
                        @Attribute var name: Name
                        @Attribute var value: Value

                        enum CodingKeys: String, CodingKey {
                            case name
                            case value
                        }

                        struct Name: ATDFStringValue {
                            static let SUPPORTS_EEPROM_ERASE = Name(value: "SUPPORTS_EEPROM_ERASE")

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [Name] = [
                                        SUPPORTS_EEPROM_ERASE
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }

                        struct Value: ATDFStringValue {
                            static let zero = Value(value: "0")

                            let rawValue: String
                            let alternateValues: [String]

                            static let allCases: [Value] = [
                                        zero
                                    ]

                            init(value: String, alternateValues: [String] = []) {
                                self.rawValue = value
                                self.alternateValues = alternateValues
                            }
                        }
                    }
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

                enum CodingKeys: String, CodingKey {
                    case name
                    case property
                }

                struct Property: Codable {
                    @Attribute var name: String
                    @Attribute var value: String
                    @Attribute var caption: Caption?

                    enum CodingKeys: String, CodingKey {
                        case name
                        case value
                        case caption
                    }

                    struct Caption: ATDFStringValue {
                        static let ioregSignatureForChangeProtect = Caption(value: "IOREG signature for Change Protect")
                        static let spmSignatureForChangeProtect = Caption(value: "SPM signature for Change Protect")

                        let rawValue: String
                        let alternateValues: [String]

                        static let allCases: [Caption] = [
                                    ioregSignatureForChangeProtect,
                                    spmSignatureForChangeProtect
                                ]

                        init(value: String, alternateValues: [String] = []) {
                            self.rawValue = value
                            self.alternateValues = alternateValues
                        }
                    }
                }
            }
        }

        struct Interrupts: Codable {
            let interrupt: [Interrupt]

            enum CodingKeys: String, CodingKey {
                case interrupt
            }

            struct Interrupt: Codable {
                @Attribute var index: Index
                @Attribute var name: Name
                @Attribute var caption: Caption?
                @Attribute var moduleInstance: ModuleInstance?

                enum CodingKeys: String, CodingKey {
                    case index
                    case name
                    case caption
                    case moduleInstance = "module-instance"
                }

                struct Index: ATDFStringValue {
                    static let ten = Index(value: "10")
                    static let eleven = Index(value: "11")
                    static let eight = Index(value: "8")
                    static let twelve = Index(value: "12")
                    static let seven = Index(value: "7")
                    static let nine = Index(value: "9")
                    static let one = Index(value: "1")
                    static let two = Index(value: "2")
                    static let three = Index(value: "3")
                    static let six = Index(value: "6")
                    static let four = Index(value: "4")
                    static let thirteen = Index(value: "13")
                    static let five = Index(value: "5")
                    static let fourteen = Index(value: "14")
                    static let sixteen = Index(value: "16")
                    static let fifteen = Index(value: "15")
                    static let seventeen = Index(value: "17")
                    static let eighteen = Index(value: "18")
                    static let nineteen = Index(value: "19")
                    static let twenty = Index(value: "20")
                    static let zero = Index(value: "0")
                    static let twentyOne = Index(value: "21")
                    static let twentyTwo = Index(value: "22")
                    static let twentyFour = Index(value: "24")
                    static let twentyThree = Index(value: "23")
                    static let twentyFive = Index(value: "25")
                    static let twentySix = Index(value: "26")
                    static let twentySeven = Index(value: "27")
                    static let twentyEight = Index(value: "28")
                    static let twentyNine = Index(value: "29")
                    static let thirty = Index(value: "30")
                    static let thirtyOne = Index(value: "31")
                    static let thirtyTwo = Index(value: "32")
                    static let thirtyThree = Index(value: "33")
                    static let thirtyFour = Index(value: "34")
                    static let thirtyFive = Index(value: "35")
                    static let thirtySix = Index(value: "36")
                    static let thirtySeven = Index(value: "37")
                    static let thirtyEight = Index(value: "38")
                    static let thirtyNine = Index(value: "39")
                    static let forty = Index(value: "40")
                    static let fortyOne = Index(value: "41")
                    static let fortyTwo = Index(value: "42")
                    static let fortyThree = Index(value: "43")
                    static let fortyFour = Index(value: "44")
                    static let fifty = Index(value: "50")
                    static let fortyFive = Index(value: "45")
                    static let fortySix = Index(value: "46")
                    static let fortySeven = Index(value: "47")
                    static let fortyEight = Index(value: "48")
                    static let fortyNine = Index(value: "49")
                    static let fiftySeven = Index(value: "57")
                    static let fiftyEight = Index(value: "58")
                    static let fiftyNine = Index(value: "59")
                    static let sixty = Index(value: "60")
                    static let sixtyOne = Index(value: "61")
                    static let sixtyTwo = Index(value: "62")
                    static let sixtyThree = Index(value: "63")
                    static let sixtyFour = Index(value: "64")
                    static let sixtyFive = Index(value: "65")
                    static let sixtySix = Index(value: "66")
                    static let sixtySeven = Index(value: "67")
                    static let sixtyEight = Index(value: "68")
                    static let sixtyNine = Index(value: "69")
                    static let seventy = Index(value: "70")
                    static let seventyOne = Index(value: "71")
                    static let fiftyOne = Index(value: "51")
                    static let fiftyTwo = Index(value: "52")
                    static let fiftyThree = Index(value: "53")
                    static let fiftyFour = Index(value: "54")
                    static let fiftyFive = Index(value: "55")
                    static let fiftySix = Index(value: "56")
                    static let seventyTwo = Index(value: "72")
                    static let seventyThree = Index(value: "73")
                    static let seventyFour = Index(value: "74")
                    static let seventyFive = Index(value: "75")
                    static let seventySix = Index(value: "76")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Index] = [
                                ten,
                                eleven,
                                eight,
                                twelve,
                                seven,
                                nine,
                                one,
                                two,
                                three,
                                six,
                                four,
                                thirteen,
                                five,
                                fourteen,
                                sixteen,
                                fifteen,
                                seventeen,
                                eighteen,
                                nineteen,
                                twenty,
                                zero,
                                twentyOne,
                                twentyTwo,
                                twentyFour,
                                twentyThree,
                                twentyFive,
                                twentySix,
                                twentySeven,
                                twentyEight,
                                twentyNine,
                                thirty,
                                thirtyOne,
                                thirtyTwo,
                                thirtyThree,
                                thirtyFour,
                                thirtyFive,
                                thirtySix,
                                thirtySeven,
                                thirtyEight,
                                thirtyNine,
                                forty,
                                fortyOne,
                                fortyTwo,
                                fortyThree,
                                fortyFour,
                                fifty,
                                fortyFive,
                                fortySix,
                                fortySeven,
                                fortyEight,
                                fortyNine,
                                fiftySeven,
                                fiftyEight,
                                fiftyNine,
                                sixty,
                                sixtyOne,
                                sixtyTwo,
                                sixtyThree,
                                sixtyFour,
                                sixtyFive,
                                sixtySix,
                                sixtySeven,
                                sixtyEight,
                                sixtyNine,
                                seventy,
                                seventyOne,
                                fiftyOne,
                                fiftyTwo,
                                fiftyThree,
                                fiftyFour,
                                fiftyFive,
                                fiftySix,
                                seventyTwo,
                                seventyThree,
                                seventyFour,
                                seventyFive,
                                seventySix
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Name: ATDFStringValue {
                    static let RESET = Name(value: "RESET")
                    static let INT0 = Name(value: "INT0")
                    static let TIMER0_OVF = Name(value: "TIMER0_OVF")
                    static let TIMER1_OVF = Name(value: "TIMER1_OVF")
                    static let PORT = Name(value: "PORT")
                    static let ADC = Name(value: "ADC")
                    static let TIMER1_COMPA = Name(value: "TIMER1_COMPA")
                    static let TIMER1_COMPB = Name(value: "TIMER1_COMPB")
                    static let TIMER1_CAPT = Name(value: "TIMER1_CAPT")
                    static let PCINT0 = Name(value: "PCINT0")
                    static let SPI_STC = Name(value: "SPI_STC")
                    static let INT = Name(value: "INT")
                    static let EE_READY = Name(value: "EE_READY")
                    static let PCINT1 = Name(value: "PCINT1")
                    static let WDT = Name(value: "WDT")
                    static let INT1 = Name(value: "INT1")
                    static let ANALOG_COMP = Name(value: "ANALOG_COMP")
                    static let TIMER2_OVF = Name(value: "TIMER2_OVF")
                    static let SPM_READY = Name(value: "SPM_READY")
                    static let TIMER0_COMPB = Name(value: "TIMER0_COMPB")
                    static let TIMER0_COMPA = Name(value: "TIMER0_COMPA")
                    static let DRE = Name(value: "DRE")
                    static let RXC = Name(value: "RXC")
                    static let TXC = Name(value: "TXC")
                    static let INT2 = Name(value: "INT2")
                    static let USART0_TX = Name(value: "USART0_TX")
                    static let TWI = Name(value: "TWI")
                    static let PCINT2 = Name(value: "PCINT2")
                    static let OVF = Name(value: "OVF")
                    static let USART0_UDRE = Name(value: "USART0_UDRE")
                    static let USART0_RX = Name(value: "USART0_RX")
                    static let AC = Name(value: "AC")
                    static let VLM = Name(value: "VLM")
                    static let TIMER2_COMP = Name(value: "TIMER2_COMP")
                    static let USI_START = Name(value: "USI_START")
                    static let RESRDY = Name(value: "RESRDY")
                    static let TIMER2_COMPA = Name(value: "TIMER2_COMPA")
                    static let TIMER2_COMPB = Name(value: "TIMER2_COMPB")
                    static let TIMER0_COMP = Name(value: "TIMER0_COMP")
                    static let USART_UDRE = Name(value: "USART_UDRE")
                    static let USART1_UDRE = Name(value: "USART1_UDRE")
                    static let INT3 = Name(value: "INT3")
                    static let USART1_RX = Name(value: "USART1_RX")
                    static let USART1_TX = Name(value: "USART1_TX")
                    static let ANA_COMP = Name(value: "ANA_COMP")
                    static let LCMP0 = Name(value: "LCMP0")
                    static let LCMP1 = Name(value: "LCMP1")
                    static let LCMP2 = Name(value: "LCMP2")
                    static let CMP0 = Name(value: "CMP0")
                    static let CMP1 = Name(value: "CMP1")
                    static let CMP2 = Name(value: "CMP2")
                    static let HUNF = Name(value: "HUNF")
                    static let LUNF = Name(value: "LUNF")
                    static let TWIM = Name(value: "TWIM")
                    static let TWIS = Name(value: "TWIS")
                    static let CNT = Name(value: "CNT")
                    static let NMI = Name(value: "NMI")
                    static let PIT = Name(value: "PIT")
                    static let EE = Name(value: "EE")
                    static let USART_RX = Name(value: "USART_RX")
                    static let USI_OVERFLOW = Name(value: "USI_OVERFLOW")
                    static let WCOMP = Name(value: "WCOMP")
                    static let PCINT3 = Name(value: "PCINT3")
                    static let EE_RDY = Name(value: "EE_RDY")
                    static let TIMER1_COMPC = Name(value: "TIMER1_COMPC")
                    static let TIMER3_COMPA = Name(value: "TIMER3_COMPA")
                    static let TIMER3_COMPB = Name(value: "TIMER3_COMPB")
                    static let TIMER3_CAPT = Name(value: "TIMER3_CAPT")
                    static let TIMER3_OVF = Name(value: "TIMER3_OVF")
                    static let INT6 = Name(value: "INT6")
                    static let USART_TX = Name(value: "USART_TX")
                    static let INT4 = Name(value: "INT4")
                    static let INT5 = Name(value: "INT5")
                    static let INT7 = Name(value: "INT7")
                    static let TIMER3_COMPC = Name(value: "TIMER3_COMPC")
                    static let USI_OVF = Name(value: "USI_OVF")
                    static let CCL = Name(value: "CCL")
                    static let TIM0_COMPA = Name(value: "TIM0_COMPA")
                    static let TIM0_COMPB = Name(value: "TIM0_COMPB")
                    static let TIM0_OVF = Name(value: "TIM0_OVF")
                    static let SPM_Ready = Name(value: "SPM_Ready")
                    static let LCD = Name(value: "LCD")
                    static let TIMER4_COMPA = Name(value: "TIMER4_COMPA")
                    static let TIMER4_COMPB = Name(value: "TIMER4_COMPB")
                    static let TIMER4_OVF = Name(value: "TIMER4_OVF")
                    static let TIMER4_CAPT = Name(value: "TIMER4_CAPT")
                    static let TRIG = Name(value: "TRIG")
                    static let TIMER4_COMPC = Name(value: "TIMER4_COMPC")
                    static let TIMER5_COMPA = Name(value: "TIMER5_COMPA")
                    static let TIMER5_COMPB = Name(value: "TIMER5_COMPB")
                    static let TIMER5_COMPC = Name(value: "TIMER5_COMPC")
                    static let TIMER5_CAPT = Name(value: "TIMER5_CAPT")
                    static let TIMER5_OVF = Name(value: "TIMER5_OVF")
                    static let SAMPRDY = Name(value: "SAMPRDY")
                    static let ERROR = Name(value: "ERROR")
                    static let TIM1_OVF = Name(value: "TIM1_OVF")
                    static let USB_COM = Name(value: "USB_COM")
                    static let USB_GEN = Name(value: "USB_GEN")
                    static let TIM1_COMPA = Name(value: "TIM1_COMPA")
                    static let TIM1_COMPB = Name(value: "TIM1_COMPB")
                    static let TIM1_CAPT = Name(value: "TIM1_CAPT")
                    static let SPM_RDY = Name(value: "SPM_RDY")
                    static let ANALOG_COMP_1 = Name(value: "ANALOG_COMP_1")
                    static let ANALOG_COMP_2 = Name(value: "ANALOG_COMP_2")
                    static let PSC0_CAPT = Name(value: "PSC0_CAPT")
                    static let PSC2_CAPT = Name(value: "PSC2_CAPT")
                    static let USART_RXC = Name(value: "USART_RXC")
                    static let USART_TXC = Name(value: "USART_TXC")
                    static let LIN_ERR = Name(value: "LIN_ERR")
                    static let PSC0_EC = Name(value: "PSC0_EC")
                    static let PSC2_EC = Name(value: "PSC2_EC")
                    static let LIN_TC = Name(value: "LIN_TC")
                    static let TRX24_PLL_UNLOCK = Name(value: "TRX24_PLL_UNLOCK")
                    static let TRX24_CCA_ED_DONE = Name(value: "TRX24_CCA_ED_DONE")
                    static let TRX24_PLL_LOCK = Name(value: "TRX24_PLL_LOCK")
                    static let TRX24_RX_START = Name(value: "TRX24_RX_START")
                    static let SCNT_BACKOFF = Name(value: "SCNT_BACKOFF")
                    static let CCADC_REG_CUR = Name(value: "CCADC_REG_CUR")
                    static let TRX24_XAH_AMI = Name(value: "TRX24_XAH_AMI")
                    static let TRX24_AWAKE = Name(value: "TRX24_AWAKE")
                    static let USART2_UDRE = Name(value: "USART2_UDRE")
                    static let TRX24_RX_END = Name(value: "TRX24_RX_END")
                    static let TRX24_TX_END = Name(value: "TRX24_TX_END")
                    static let CCADC_CONV = Name(value: "CCADC_CONV")
                    static let AES_READY = Name(value: "AES_READY")
                    static let CCADC_ACC = Name(value: "CCADC_ACC")
                    static let SCNT_CMP1 = Name(value: "SCNT_CMP1")
                    static let SCNT_CMP2 = Name(value: "SCNT_CMP2")
                    static let SCNT_CMP3 = Name(value: "SCNT_CMP3")
                    static let SCNT_OVFL = Name(value: "SCNT_OVFL")
                    static let TIMER0_IC = Name(value: "TIMER0_IC")
                    static let TIMER1_IC = Name(value: "TIMER1_IC")
                    static let USART2_RX = Name(value: "USART2_RX")
                    static let USART2_TX = Name(value: "USART2_TX")
                    static let NOT_USED = Name(value: "NOT_USED")
                    static let BAT_LOW = Name(value: "BAT_LOW")
                    static let USI_STR = Name(value: "USI_STR")
                    static let BPINT = Name(value: "BPINT")
                    static let PCINT = Name(value: "PCINT")
                    static let VADC = Name(value: "VADC")
                    static let FAULT_PROTECTION = Name(value: "FAULT_PROTECTION")
                    static let TRX24_TX_START = Name(value: "TRX24_TX_START")
                    static let TIMER1_COMPD = Name(value: "TIMER1_COMPD")
                    static let ANALOG_COMP_0 = Name(value: "ANALOG_COMP_0")
                    static let RESERVED15 = Name(value: "RESERVED15")
                    static let RESERVED30 = Name(value: "RESERVED30")
                    static let RESERVED31 = Name(value: "RESERVED31")
                    static let TIMER0_CAPT = Name(value: "TIMER0_CAPT")
                    static let USART3_UDRE = Name(value: "USART3_UDRE")
                    static let TRX24_AMI0 = Name(value: "TRX24_AMI0")
                    static let TRX24_AMI1 = Name(value: "TRX24_AMI1")
                    static let TRX24_AMI2 = Name(value: "TRX24_AMI2")
                    static let TRX24_AMI3 = Name(value: "TRX24_AMI3")
                    static let ANACOMP0 = Name(value: "ANACOMP0")
                    static let ANACOMP1 = Name(value: "ANACOMP1")
                    static let ANACOMP2 = Name(value: "ANACOMP2")
                    static let ANACOMP3 = Name(value: "ANACOMP3")
                    static let PSC1_CAPT = Name(value: "PSC1_CAPT")
                    static let PSC_FAULT = Name(value: "PSC_FAULT")
                    static let TIM0_CAPT = Name(value: "TIM0_CAPT")
                    static let TWI_SLAVE = Name(value: "TWI_SLAVE")
                    static let USART3_RX = Name(value: "USART3_RX")
                    static let USART3_TX = Name(value: "USART3_TX")
                    static let VREGMON = Name(value: "VREGMON")
                    static let CAN_TOVF = Name(value: "CAN_TOVF")
                    static let EXT_INT0 = Name(value: "EXT_INT0")
                    static let CAN_INT = Name(value: "CAN_INT")
                    static let PSC1_EC = Name(value: "PSC1_EC")
                    static let PSC_EC = Name(value: "PSC_EC")
                    static let USART0_START = Name(value: "USART0_START")
                    static let USART1_START = Name(value: "USART1_START")
                    static let SPM = Name(value: "SPM")
                    static let USART_START = Name(value: "USART_START")
                    static let TWIBUSCD = Name(value: "TWIBUSCD")
                    static let IO_PINS = Name(value: "IO_PINS")
                    static let BGSCD = Name(value: "BGSCD")
                    static let CHDET = Name(value: "CHDET")
                    static let QTRIP = Name(value: "QTRIP")
                    static let SPI = Name(value: "SPI")
                    static let EEPROM_Ready = Name(value: "EEPROM_Ready")
                    static let WDT_OVERFLOW = Name(value: "WDT_OVERFLOW")
                    static let TIMER0_COMP_A = Name(value: "TIMER0_COMP_A")
                    static let CANIT = Name(value: "CANIT")
                    static let OVRIT = Name(value: "OVRIT")
                    static let TIMER4_COMPD = Name(value: "TIMER4_COMPD")
                    static let ANALOG_COMP_3 = Name(value: "ANALOG_COMP_3")
                    static let TIMER2_CAPT = Name(value: "TIMER2_CAPT")
                    static let Reserved1 = Name(value: "Reserved1")
                    static let Reserved2 = Name(value: "Reserved2")
                    static let Reserved3 = Name(value: "Reserved3")
                    static let Reserved4 = Name(value: "Reserved4")
                    static let Reserved5 = Name(value: "Reserved5")
                    static let Reserved6 = Name(value: "Reserved6")
                    static let TIMER4_FPF = Name(value: "TIMER4_FPF")
                    static let USART0_RXC = Name(value: "USART0_RXC")
                    static let USART0_RXS = Name(value: "USART0_RXS")
                    static let USART0_TXC = Name(value: "USART0_TXC")
                    static let USART1_RXC = Name(value: "USART1_RXC")
                    static let USART1_RXS = Name(value: "USART1_RXS")
                    static let USART1_TXC = Name(value: "USART1_TXC")
                    static let ANA_COMP0 = Name(value: "ANA_COMP0")
                    static let ANA_COMP1 = Name(value: "ANA_COMP1")
                    static let PTC_WCOMP = Name(value: "PTC_WCOMP")
                    static let USART_DRE = Name(value: "USART_DRE")
                    static let USART_RXS = Name(value: "USART_RXS")
                    static let PSC0_EEC = Name(value: "PSC0_EEC")
                    static let PSC2_EEC = Name(value: "PSC2_EEC")
                    static let SPI0_STC = Name(value: "SPI0_STC")
                    static let SPI1_STC = Name(value: "SPI1_STC")
                    static let PCINT_A = Name(value: "PCINT_A")
                    static let PCINT_B = Name(value: "PCINT_B")
                    static let PCINT_D = Name(value: "PCINT_D")
                    static let PTC_EOC = Name(value: "PTC_EOC")
                    static let TWI0 = Name(value: "TWI0")
                    static let TWI1 = Name(value: "TWI1")
                    static let USART2_START = Name(value: "USART2_START")
                    static let TIMER0_OVF0 = Name(value: "TIMER0_OVF0")
                    static let TIMER1_CMPA = Name(value: "TIMER1_CMPA")
                    static let TIMER1_CMPB = Name(value: "TIMER1_CMPB")
                    static let TIMER1_COMP = Name(value: "TIMER1_COMP")
                    static let TIMER1_OVF1 = Name(value: "TIMER1_OVF1")
                    static let CADC_REG_CUR = Name(value: "CADC_REG_CUR")
                    static let LIN_STATUS = Name(value: "LIN_STATUS")
                    static let USART0_DRE = Name(value: "USART0_DRE")
                    static let USART1_DRE = Name(value: "USART1_DRE")
                    static let USART2_RXS = Name(value: "USART2_RXS")
                    static let ADC_READY = Name(value: "ADC_READY")
                    static let CADC_CONV = Name(value: "CADC_CONV")
                    static let LIN_ERROR = Name(value: "LIN_ERROR")
                    static let TIM1_COMP = Name(value: "TIM1_COMP")
                    static let VADC_CONV = Name(value: "VADC_CONV")
                    static let TWI_BUS_CD = Name(value: "TWI_BUS_CD")
                    static let CADC_ACC = Name(value: "CADC_ACC")
                    static let USI_STRT = Name(value: "USI_STRT")
                    static let VADC_ACC = Name(value: "VADC_ACC")
                    static let PCINT4 = Name(value: "PCINT4")
                    static let WAKEUP = Name(value: "WAKEUP")
                    static let XOSCFD = Name(value: "XOSCFD")
                    static let ADC_ADC = Name(value: "ADC_ADC")
                    static let WAKE_UP = Name(value: "WAKE_UP")
                    static let CFD = Name(value: "CFD")
                    static let PLL = Name(value: "PLL")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Name] = [
                                RESET,
                                INT0,
                                TIMER0_OVF,
                                TIMER1_OVF,
                                PORT,
                                ADC,
                                TIMER1_COMPA,
                                TIMER1_COMPB,
                                TIMER1_CAPT,
                                PCINT0,
                                SPI_STC,
                                INT,
                                EE_READY,
                                PCINT1,
                                WDT,
                                INT1,
                                ANALOG_COMP,
                                TIMER2_OVF,
                                SPM_READY,
                                TIMER0_COMPB,
                                TIMER0_COMPA,
                                DRE,
                                RXC,
                                TXC,
                                INT2,
                                USART0_TX,
                                TWI,
                                PCINT2,
                                OVF,
                                USART0_UDRE,
                                USART0_RX,
                                AC,
                                VLM,
                                TIMER2_COMP,
                                USI_START,
                                RESRDY,
                                TIMER2_COMPA,
                                TIMER2_COMPB,
                                TIMER0_COMP,
                                USART_UDRE,
                                USART1_UDRE,
                                INT3,
                                USART1_RX,
                                USART1_TX,
                                ANA_COMP,
                                LCMP0,
                                LCMP1,
                                LCMP2,
                                CMP0,
                                CMP1,
                                CMP2,
                                HUNF,
                                LUNF,
                                TWIM,
                                TWIS,
                                CNT,
                                NMI,
                                PIT,
                                EE,
                                USART_RX,
                                USI_OVERFLOW,
                                WCOMP,
                                PCINT3,
                                EE_RDY,
                                TIMER1_COMPC,
                                TIMER3_COMPA,
                                TIMER3_COMPB,
                                TIMER3_CAPT,
                                TIMER3_OVF,
                                INT6,
                                USART_TX,
                                INT4,
                                INT5,
                                INT7,
                                TIMER3_COMPC,
                                USI_OVF,
                                CCL,
                                TIM0_COMPA,
                                TIM0_COMPB,
                                TIM0_OVF,
                                SPM_Ready,
                                LCD,
                                TIMER4_COMPA,
                                TIMER4_COMPB,
                                TIMER4_OVF,
                                TIMER4_CAPT,
                                TRIG,
                                TIMER4_COMPC,
                                TIMER5_COMPA,
                                TIMER5_COMPB,
                                TIMER5_COMPC,
                                TIMER5_CAPT,
                                TIMER5_OVF,
                                SAMPRDY,
                                ERROR,
                                TIM1_OVF,
                                USB_COM,
                                USB_GEN,
                                TIM1_COMPA,
                                TIM1_COMPB,
                                TIM1_CAPT,
                                SPM_RDY,
                                ANALOG_COMP_1,
                                ANALOG_COMP_2,
                                PSC0_CAPT,
                                PSC2_CAPT,
                                USART_RXC,
                                USART_TXC,
                                LIN_ERR,
                                PSC0_EC,
                                PSC2_EC,
                                LIN_TC,
                                TRX24_PLL_UNLOCK,
                                TRX24_CCA_ED_DONE,
                                TRX24_PLL_LOCK,
                                TRX24_RX_START,
                                SCNT_BACKOFF,
                                CCADC_REG_CUR,
                                TRX24_XAH_AMI,
                                TRX24_AWAKE,
                                USART2_UDRE,
                                TRX24_RX_END,
                                TRX24_TX_END,
                                CCADC_CONV,
                                AES_READY,
                                CCADC_ACC,
                                SCNT_CMP1,
                                SCNT_CMP2,
                                SCNT_CMP3,
                                SCNT_OVFL,
                                TIMER0_IC,
                                TIMER1_IC,
                                USART2_RX,
                                USART2_TX,
                                NOT_USED,
                                BAT_LOW,
                                USI_STR,
                                BPINT,
                                PCINT,
                                VADC,
                                FAULT_PROTECTION,
                                TRX24_TX_START,
                                TIMER1_COMPD,
                                ANALOG_COMP_0,
                                RESERVED15,
                                RESERVED30,
                                RESERVED31,
                                TIMER0_CAPT,
                                USART3_UDRE,
                                TRX24_AMI0,
                                TRX24_AMI1,
                                TRX24_AMI2,
                                TRX24_AMI3,
                                ANACOMP0,
                                ANACOMP1,
                                ANACOMP2,
                                ANACOMP3,
                                PSC1_CAPT,
                                PSC_FAULT,
                                TIM0_CAPT,
                                TWI_SLAVE,
                                USART3_RX,
                                USART3_TX,
                                VREGMON,
                                CAN_TOVF,
                                EXT_INT0,
                                CAN_INT,
                                PSC1_EC,
                                PSC_EC,
                                USART0_START,
                                USART1_START,
                                SPM,
                                USART_START,
                                TWIBUSCD,
                                IO_PINS,
                                BGSCD,
                                CHDET,
                                QTRIP,
                                SPI,
                                EEPROM_Ready,
                                WDT_OVERFLOW,
                                TIMER0_COMP_A,
                                CANIT,
                                OVRIT,
                                TIMER4_COMPD,
                                ANALOG_COMP_3,
                                TIMER2_CAPT,
                                Reserved1,
                                Reserved2,
                                Reserved3,
                                Reserved4,
                                Reserved5,
                                Reserved6,
                                TIMER4_FPF,
                                USART0_RXC,
                                USART0_RXS,
                                USART0_TXC,
                                USART1_RXC,
                                USART1_RXS,
                                USART1_TXC,
                                ANA_COMP0,
                                ANA_COMP1,
                                PTC_WCOMP,
                                USART_DRE,
                                USART_RXS,
                                PSC0_EEC,
                                PSC2_EEC,
                                SPI0_STC,
                                SPI1_STC,
                                PCINT_A,
                                PCINT_B,
                                PCINT_D,
                                PTC_EOC,
                                TWI0,
                                TWI1,
                                USART2_START,
                                TIMER0_OVF0,
                                TIMER1_CMPA,
                                TIMER1_CMPB,
                                TIMER1_COMP,
                                TIMER1_OVF1,
                                CADC_REG_CUR,
                                LIN_STATUS,
                                USART0_DRE,
                                USART1_DRE,
                                USART2_RXS,
                                ADC_READY,
                                CADC_CONV,
                                LIN_ERROR,
                                TIM1_COMP,
                                VADC_CONV,
                                TWI_BUS_CD,
                                CADC_ACC,
                                USI_STRT,
                                VADC_ACC,
                                PCINT4,
                                WAKEUP,
                                XOSCFD,
                                ADC_ADC,
                                WAKE_UP,
                                CFD,
                                PLL
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Caption: ATDFStringValue {
                    static let externalInterruptRequest0 = Caption(value: "External Interrupt Request 0")
                    static let eepromReady = Caption(value: "EEPROM Ready")
                    static let timerCounter0Overflow = Caption(value: "Timer/Counter0 Overflow")
                    static let adcConversionComplete = Caption(value: "ADC Conversion Complete", alternateValues: ["ADC Conversion complete"])
                    static let timerCounter1Overflow = Caption(value: "Timer/Counter1 Overflow", alternateValues: ["Timer/Counter 1 Overflow"])
                    static let analogComparator = Caption(value: "Analog Comparator", alternateValues: ["Analog comparator"])
                    static let pinChangeInterruptRequest0 = Caption(value: "Pin Change Interrupt Request 0", alternateValues: ["Pin change Interrupt Request 0"])
                    static let timerCounter1CaptureEvent = Caption(value: "Timer/Counter1 Capture Event")
                    static let timerCounter1CompareMatchA = Caption(value: "Timer/Counter1 Compare Match A", alternateValues: [" Timer/Counter1 Compare Match A"])
                    static let spiSerialTransferComplete = Caption(value: "SPI Serial Transfer Complete", alternateValues: ["SPI Serial Transfer Complet", "SPI Serial transfer complete"])
                    static let storeProgramMemoryRead = Caption(value: "Store Program Memory Read", alternateValues: ["Store Program Memory Ready"])
                    static let pinChangeInterruptRequest1 = Caption(value: "Pin Change Interrupt Request 1")
                    static let externalInterruptRequest1 = Caption(value: "External Interrupt Request 1")
                    static let timerCounter2Overflow = Caption(value: "Timer/Counter2 Overflow")
                    static let timerCounter1CompareMatchB = Caption(value: "Timer/Counter1 Compare Match B", alternateValues: [" Timer/Counter1 Compare Match B", "Timer/Counter 1 Compare Match", "Timer/Counter1 Compare Match", "Timer/Counter1 Compare MatchB"])
                    static let externalInterruptRequest2 = Caption(value: "External Interrupt Request 2")
                    static let usart0TxComplete = Caption(value: "USART0, Tx Complete", alternateValues: ["USART0 Tx Complete"])
                    static let timerCounter0CompareMatchA = Caption(value: "Timer/Counter0 Compare Match A", alternateValues: ["TimerCounter0 Compare Match A"])
                    static let externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRResetSeeDatasheet = Caption(value: "External Pin,Power-on Reset,Brown-out Reset,Watchdog Reset,and JTAG AVR Reset. See Datasheet.     ", alternateValues: ["External Pin, Power-on Reset, Brown-out Reset,Watchdog Reset", "External Pin,Power-on Reset,Brown-out Reset,Watchdog Reset,and JTAG AVR Reset. See Datasheet."])
                    static let timerCounter2CompareMatchA = Caption(value: "Timer/Counter2 Compare Match A")
                    static let timerCounter0CompareMatchB = Caption(value: "Timer/Counter0 Compare Match B", alternateValues: ["Timer Counter 0 Compare Match B", "TimerCounter0 Compare Match B"])
                    static let watchdogTimeOutInterrupt = Caption(value: "Watchdog Time-out Interrupt", alternateValues: ["Watchdog Time-Out Interrupt", "Watchdog Timeout Interrupt"])
                    static let timerCounterCompareMatchB = Caption(value: "Timer/Counter Compare Match B")
                    static let usart0RxComplete = Caption(value: "USART0, Rx Complete", alternateValues: ["USART0 Rx Complete"])
                    static let usiOverflow = Caption(value: "USI Overflow")
                    static let pinChangeInterruptRequest2 = Caption(value: "Pin Change Interrupt Request 2")
                    static let timerCounter2CompareMatch = Caption(value: "Timer/Counter2 Compare Match")
                    static let externalInterruptRequest3 = Caption(value: "External Interrupt Request 3")
                    static let timerCounter0CompareMatch = Caption(value: "Timer/Counter0 Compare Match", alternateValues: ["TimerCounter0 Compare Match"])
                    static let usart0DataRegisterEmpty = Caption(value: "USART0 Data register Empty", alternateValues: ["USART0 Data Register Empty", "USART0, Data Register Empty"])
                    static let timerCounter2CompareMatchB = Caption(value: "Timer/Counter2 Compare Match B")
                    static let usiStartCondition = Caption(value: "USI Start Condition")
                    static let value2WireSerialInterface = Caption(value: "2-wire Serial Interface", alternateValues: ["2-wire Serial Interface        "])
                    static let pinChangeInterruptRequest3 = Caption(value: "Pin Change Interrupt Request 3")
                    static let usart1RxComplete = Caption(value: "USART1, Rx Complete", alternateValues: ["USART1 RX complete", "USART1 Rx Complete"])
                    static let usart1TxComplete = Caption(value: "USART1, Tx Complete", alternateValues: ["USART1 TX complete", "USART1 Tx Complete"])
                    static let externalPinPowerOnResetBrownOutResetAndWatchdogReset = Caption(value: "External Pin, Power-on Reset, Brown-out Reset and Watchdog Reset", alternateValues: ["External Pin, Power-on Reset, Brown-out Reset  and Watchdog Reset"])
                    static let timerCounter3CompareMatchA = Caption(value: "Timer/Counter3 Compare Match A")
                    static let timerCounter3CompareMatchB = Caption(value: "Timer/Counter3 Compare Match B")
                    static let externalInterruptRequest6 = Caption(value: "External Interrupt Request 6")
                    static let timerCounter3CaptureEvent = Caption(value: "Timer/Counter3 Capture Event")
                    static let timerCounter3Overflow = Caption(value: "Timer/Counter3 Overflow")
                    static let usartRxComplete = Caption(value: "USART, Rx Complete", alternateValues: ["USART RX Complete", "USART Rx Complete", "USART, RX Complete"])
                    static let externalInterruptRequest4 = Caption(value: "External Interrupt Request 4")
                    static let externalInterruptRequest5 = Caption(value: "External Interrupt Request 5")
                    static let externalInterruptRequest7 = Caption(value: "External Interrupt Request 7")
                    static let externalResetPowerOnResetAndWatchdogReset = Caption(value: "External Reset, Power-on Reset and Watchdog Reset")
                    static let timerCounter1CompareMatchC = Caption(value: "Timer/Counter1 Compare Match C")
                    static let timerCounter3CompareMatchC = Caption(value: "Timer/Counter3 Compare Match C")
                    static let twoWireSerialInterface = Caption(value: "Two-wire Serial Interface", alternateValues: ["Two-Wire Serial Interface"])
                    static let externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRReset = Caption(value: "External Pin, Power-on Reset, Brown-out Reset, Watchdog Reset and JTAG AVR Reset")
                    static let usart1DataRegisterEmpty = Caption(value: "USART1 Data register Empty", alternateValues: ["USART1 Data Register Empty", "USART1, Data Register Empty", "USART1, Data register Empty"])
                    static let usartTxComplete = Caption(value: "USART Tx Complete", alternateValues: ["USART, TX Complete", "USART, Tx Complete"])
                    static let watchdogTimeOut = Caption(value: "Watchdog Time-out", alternateValues: ["Watchdog Time-Out"])
                    static let usartDataRegisterEmpty = Caption(value: "USART, Data Register Empty", alternateValues: ["USART Data Register Empty", "USART Data register Empty", "USART Data register empty"])
                    static let externalInterrupt0 = Caption(value: "External Interrupt 0")
                    static let lcdStartOfFrame = Caption(value: "LCD Start of Frame")
                    static let timerCounter4CompareMatchA = Caption(value: "Timer/Counter4 Compare Match A")
                    static let timerCounter4CompareMatchB = Caption(value: "Timer/Counter4 Compare Match B")
                    static let timerCounter4Overflow = Caption(value: "Timer/Counter4 Overflow")
                    static let analogComparator1 = Caption(value: "Analog Comparator 1")
                    static let timerCounter4CaptureEvent = Caption(value: "Timer/Counter4 Capture Event")
                    static let analogComparator0 = Caption(value: "Analog Comparator 0")
                    static let analogComparator2 = Caption(value: "Analog Comparator 2")
                    static let timerCounter1CompareMatch1A = Caption(value: "Timer/Counter1 Compare Match 1A")
                    static let timerCounter4CompareMatchC = Caption(value: "Timer/Counter4 Compare Match C")
                    static let timerCounter5CompareMatchA = Caption(value: "Timer/Counter5 Compare Match A")
                    static let timerCounter5CompareMatchB = Caption(value: "Timer/Counter5 Compare Match B")
                    static let timerCounter5CompareMatchC = Caption(value: "Timer/Counter5 Compare Match C")
                    static let timerCounter5CaptureEvent = Caption(value: "Timer/Counter5 Capture Event")
                    static let timerCounter5Overflow = Caption(value: "Timer/Counter5 Overflow")
                    static let usbEndpointPipeInterruptCommunicationRequest = Caption(value: "USB Endpoint/Pipe Interrupt Communication Request")
                    static let usbGeneralInterruptRequest = Caption(value: "USB General Interrupt Request")
                    static let usiStart = Caption(value: "USI START", alternateValues: ["USI Start"])
                    static let timerCounter1CompareMatch1B = Caption(value: "Timer/Counter1 Compare Match 1B")
                    static let timerCounterCompareMatchA = Caption(value: "Timer/Counter Compare Match A")
                    static let linTransferComplete = Caption(value: "LIN Transfer Complete")
                    static let analogComparator3 = Caption(value: "Analog Comparator 3")
                    static let psc0CaptureEvent = Caption(value: "PSC0 Capture Event")
                    static let psc2CaptureEvent = Caption(value: "PSC2 Capture Event")
                    static let psc0EndCycle = Caption(value: "PSC0 End Cycle")
                    static let psc2EndCycle = Caption(value: "PSC2 End Cycle")
                    static let linError = Caption(value: "LIN Error")
                    static let batteryMonitorIndicatesSupplyVoltageBelowThreshold = Caption(value: "Battery monitor indicates supply voltage below threshold")
                    static let trx24AwakeTransceiverIsReachingStateTRXOFF = Caption(value: "TRX24 AWAKE - transceiver is reaching state TRX_OFF")
                    static let coulombCounterADCConversionComplete = Caption(value: "Coulomb Counter ADC Conversion Complete")
                    static let symbolCounterCompareMatch1Interrupt = Caption(value: "Symbol counter - compare match 1 interrupt")
                    static let symbolCounterCompareMatch2Interrupt = Caption(value: "Symbol counter - compare match 2 interrupt")
                    static let symbolCounterCompareMatch3Interrupt = Caption(value: "Symbol counter - compare match 3 interrupt")
                    static let coloumbCounterADCRegularCurrent = Caption(value: "Coloumb Counter ADC Regular Current")
                    static let symbolCounterOverflowInterrupt = Caption(value: "Symbol counter - overflow interrupt")
                    static let symbolCounterBackoffInterrupt = Caption(value: "Symbol counter - backoff interrupt")
                    static let coloumbCounterADCAccumulator = Caption(value: "Coloumb Counter ADC Accumulator")
                    static let voltageADCConversionComplete = Caption(value: "Voltage ADC Conversion Complete")
                    static let batteryProtectionInterrupt = Caption(value: "Battery Protection Interrupt")
                    static let trx24ReceiveStartInterrupt = Caption(value: "TRX24 - Receive start interrupt")
                    static let timerCounter2CaptureEvent = Caption(value: "Timer/Counter2 Capture Event")
                    static let aesEngineReadyInterrupt = Caption(value: "AES engine ready interrupt")
                    static let usart2DataRegisterEmpty = Caption(value: "USART2 Data register Empty")
                    static let trx24PLLUnlockInterrupt = Caption(value: "TRX24 - PLL unlock interrupt")
                    static let trx24CCAEDDoneInterrupt = Caption(value: "TRX24 - CCA/ED done interrupt")
                    static let serialTransferComplete = Caption(value: "Serial Transfer Complete")
                    static let trx24PLLLockInterrupt = Caption(value: "TRX24 - PLL lock interrupt")
                    static let timer0CompareMatchA = Caption(value: "Timer 0 Compare Match A")
                    static let timer0CompareMatchB = Caption(value: "Timer 0 Compare Match B")
                    static let timer1CompareMatchA = Caption(value: "Timer 1 Compare Match A")
                    static let timer1CompareMatchB = Caption(value: "Timer 1 Compare Match B")
                    static let trx24RXENDInterrupt = Caption(value: "TRX24 - RX_END interrupt")
                    static let trx24TXENDInterrupt = Caption(value: "TRX24 - TX_END interrupt")
                    static let externalInterrupt1 = Caption(value: "External Interrupt 1")
                    static let timer0InputCapture = Caption(value: "Timer 0 Input Capture")
                    static let timer1InputCapture = Caption(value: "Timer 1 Input capture")
                    static let timer0Overflow = Caption(value: "Timer 0 Overflow")
                    static let timer1Overflow = Caption(value: "Timer 1 overflow")
                    static let trx24XAHAMI = Caption(value: "TRX24 - XAH - AMI")
                    static let RESERVED = Caption(value: "RESERVED")
                    static let addressMatchInterruptOfAddressFilter0 = Caption(value: "Address match interrupt of address filter 0")
                    static let addressMatchInterruptOfAddressFilter1 = Caption(value: "Address match interrupt of address filter 1")
                    static let addressMatchInterruptOfAddressFilter2 = Caption(value: "Address match interrupt of address filter 2")
                    static let addressMatchInterruptOfAddressFilter3 = Caption(value: "Address match interrupt of address filter 3")
                    static let voltageRegulatorMonitorInterrupt = Caption(value: "Voltage regulator monitor interrupt")
                    static let timerCounter1FaultProtection = Caption(value: "Timer/Counter1 Fault Protection")
                    static let timerCounter1CompareMatchD = Caption(value: "Timer/Counter1 Compare Match D")
                    static let timerCounter0InputCapture = Caption(value: "Timer/Counter0 Input Capture")
                    static let canMOBBurstGeneralErrors = Caption(value: "CAN MOB, Burst, General Errors")
                    static let usart3DataRegisterEmpty = Caption(value: "USART3 Data register Empty")
                    static let timer1Counter1Overflow = Caption(value: "Timer1/Counter1 Overflow")
                    static let vccVoltageLevelMonitor = Caption(value: "Vcc Voltage Level Monitor")
                    static let trx24TXStartInterrupt = Caption(value: "TRX24 TX start interrupt")
                    static let timerCouner0Overflow = Caption(value: "Timer/Couner0 Overflow")
                    static let pinChangeInterrupt0 = Caption(value: "Pin Change Interrupt 0")
                    static let pinChangeInterrupt1 = Caption(value: "Pin Change Interrupt 1")
                    static let pinChangeInterrupt = Caption(value: "Pin Change Interrupt")
                    static let canTimerOverflow = Caption(value: "CAN Timer Overflow")
                    static let psc1CaptureEvent = Caption(value: "PSC1 Capture Event")
                    static let usart2RxComplete = Caption(value: "USART2, Rx Complete", alternateValues: ["USART2 Rx Complete"])
                    static let usart2TxComplete = Caption(value: "USART2, Tx Complete", alternateValues: ["USART2 Tx Complete"])
                    static let usart3RxComplete = Caption(value: "USART3, Rx Complete")
                    static let usart3TxComplete = Caption(value: "USART3, Tx Complete")
                    static let pscEndOfCycle = Caption(value: "PSC End of Cycle")
                    static let psc1EndCycle = Caption(value: "PSC1 End Cycle")
                    static let pscFault = Caption(value: "PSC Fault")
                    static let twoWireBusConnectDisconnect = Caption(value: "Two-Wire Bus Connect/Disconnect")
                    static let timerCounter2CompareMatchC = Caption(value: "Timer/Counter2 Compare Match C")
                    static let spmReady = Caption(value: "SPM Ready")
                    static let bandgapBufferShortCircuitDetected = Caption(value: "Bandgap Buffer Short Circuit Detected")
                    static let serialPeripheralInterface = Caption(value: "Serial Peripheral Interface")
                    static let chargerDetect = Caption(value: "Charger Detect")
                    static let touchSensing = Caption(value: "Touch Sensing")
                    static let usart0Start = Caption(value: "USART0, Start")
                    static let usart1Start = Caption(value: "USART1, Start")
                    static let canTransferCompleteOrError = Caption(value: "CAN Transfer Complete or Error")
                    static let usartStartEdgeInterrupt = Caption(value: "USART Start Edge Interrupt")
                    static let watchdogTimerOverflow = Caption(value: "Watchdog Timer Overflow")
                    static let adcConversionReady = Caption(value: "ADC Conversion ready", alternateValues: ["ADC Conversion Ready"])
                    static let canTimerOverrun = Caption(value: "CAN Timer Overrun")
                    static let timerCounter4FaultProtectionInterrupt = Caption(value: "Timer/Counter4 Fault Protection Interrupt")
                    static let timerCounter0CompareMatch0A = Caption(value: "Timer/Counter0 Compare Match 0A")
                    static let spi1SerialTransferComplete = Caption(value: "SPI1 Serial Transfer Complete")
                    static let usiStartConditionDetection = Caption(value: "USI Start Condition Detection")
                    static let pinChangeInterruptRequestA = Caption(value: "Pin Change Interrupt Request A")
                    static let pinChangeInterruptRequestB = Caption(value: "Pin Change Interrupt Request B")
                    static let pinChangeInterruptRequestD = Caption(value: "Pin Change Interrupt Request D")
                    static let timerCounter4CompareMatchD = Caption(value: "Timer/Counter4 Compare Match D")
                    static let timerCounter1InputCapture = Caption(value: "Timer/Counter1 Input Capture")
                    static let usart0RXStartEdgeDetect = Caption(value: "USART0 RX start edge detect")
                    static let usart1RXStartEdgeDetect = Caption(value: "USART1 RX start edge detect")
                    static let usart2RXStartEdgeDetect = Caption(value: "USART2 RX start edge detect")
                    static let psc0EndOfEnhancedCycle = Caption(value: "PSC0 End Of Enhanced Cycle")
                    static let psc2EndOfEnhancedCycle = Caption(value: "PSC2 End Of Enhanced Cycle")
                    static let conversionComplete = Caption(value: "Conversion Complete")
                    static let usiCounterOverflow = Caption(value: "USI Counter Overflow")
                    static let twoWireInterface = Caption(value: "Two-Wire Interface")
                    static let usartRXStart = Caption(value: "USART RX Start")
                    static let Reserved1 = Caption(value: "Reserved1")
                    static let Reserved2 = Caption(value: "Reserved2")
                    static let Reserved3 = Caption(value: "Reserved3")
                    static let Reserved4 = Caption(value: "Reserved4")
                    static let Reserved5 = Caption(value: "Reserved5")
                    static let Reserved6 = Caption(value: "Reserved6")
                    static let voltageADCInstantaneousConversionComplete = Caption(value: "Voltage ADC Instantaneous Conversion Complete")
                    static let voltageADCAccumulatedConversionComplete = Caption(value: "Voltage ADC Accumulated Conversion Complete")
                    static let cADCInstantaneousConversionComplete = Caption(value: "C-ADC Instantaneous Conversion Complete")
                    static let cADCAccumulatedConversionComplete = Caption(value: "C-ADC Accumulated Conversion Complete")
                    static let clockFailureDetectionInterrupt = Caption(value: "Clock failure detection interrupt")
                    static let ptcWindowComparatorInterrupt = Caption(value: "PTC window comparator interrupt")
                    static let spi0SerialTransferComplete = Caption(value: "SPI0 Serial Transfer Complete")
                    static let pinChangeInterruptRequest4 = Caption(value: "Pin Change Interrupt Request 4")
                    static let timerCounter0CompareAMatch = Caption(value: "Timer/Counter0 Compare A Match")
                    static let timerCounter0CompareBMatch = Caption(value: "Timer/Counter0 Compare B Match")
                    static let usart0StartFrameDetection = Caption(value: "USART0 Start frame detection")
                    static let usart1StartFrameDetection = Caption(value: "USART1 Start frame detection")
                    static let ptcWindowComparatorMode = Caption(value: "PTC Window comparator mode")
                    static let pllLockChangeInterrupt = Caption(value: "PLL Lock Change Interrupt")
                    static let value2WireSerialInterface0 = Caption(value: "2-wire Serial Interface 0")
                    static let value2WireSerialInterface1 = Caption(value: "2-wire Serial Interface 1")
                    static let crystalFailureDetect = Caption(value: "Crystal failure detect")
                    static let twiTransferComplete = Caption(value: "TWI Transfer Complete")
                    static let wakeupTimerOverflow = Caption(value: "Wakeup Timer Overflow", alternateValues: ["Wakeup timer overflow"])
                    static let linStatusInterrupt = Caption(value: "LIN Status Interrupt")
                    static let cADCRegularCurrent = Caption(value: "C-ADC Regular Current")
                    static let ptcEndOfConversion = Caption(value: "PTC end of conversion", alternateValues: ["PTC End of conversion"])
                    static let timer0CompareMatch = Caption(value: "Timer 0 Compare Match")
                    static let linErrorInterrupt = Caption(value: "LIN Error Interrupt")
                    static let usartStart = Caption(value: "USART, Start")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Caption] = [
                                externalInterruptRequest0,
                                eepromReady,
                                timerCounter0Overflow,
                                adcConversionComplete,
                                timerCounter1Overflow,
                                analogComparator,
                                pinChangeInterruptRequest0,
                                timerCounter1CaptureEvent,
                                timerCounter1CompareMatchA,
                                spiSerialTransferComplete,
                                storeProgramMemoryRead,
                                pinChangeInterruptRequest1,
                                externalInterruptRequest1,
                                timerCounter2Overflow,
                                timerCounter1CompareMatchB,
                                externalInterruptRequest2,
                                usart0TxComplete,
                                timerCounter0CompareMatchA,
                                externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRResetSeeDatasheet,
                                timerCounter2CompareMatchA,
                                timerCounter0CompareMatchB,
                                watchdogTimeOutInterrupt,
                                timerCounterCompareMatchB,
                                usart0RxComplete,
                                usiOverflow,
                                pinChangeInterruptRequest2,
                                timerCounter2CompareMatch,
                                externalInterruptRequest3,
                                timerCounter0CompareMatch,
                                usart0DataRegisterEmpty,
                                timerCounter2CompareMatchB,
                                usiStartCondition,
                                value2WireSerialInterface,
                                pinChangeInterruptRequest3,
                                usart1RxComplete,
                                usart1TxComplete,
                                externalPinPowerOnResetBrownOutResetAndWatchdogReset,
                                timerCounter3CompareMatchA,
                                timerCounter3CompareMatchB,
                                externalInterruptRequest6,
                                timerCounter3CaptureEvent,
                                timerCounter3Overflow,
                                usartRxComplete,
                                externalInterruptRequest4,
                                externalInterruptRequest5,
                                externalInterruptRequest7,
                                externalResetPowerOnResetAndWatchdogReset,
                                timerCounter1CompareMatchC,
                                timerCounter3CompareMatchC,
                                twoWireSerialInterface,
                                externalPinPowerOnResetBrownOutResetWatchdogResetAndJTAGAVRReset,
                                usart1DataRegisterEmpty,
                                usartTxComplete,
                                watchdogTimeOut,
                                usartDataRegisterEmpty,
                                externalInterrupt0,
                                lcdStartOfFrame,
                                timerCounter4CompareMatchA,
                                timerCounter4CompareMatchB,
                                timerCounter4Overflow,
                                analogComparator1,
                                timerCounter4CaptureEvent,
                                analogComparator0,
                                analogComparator2,
                                timerCounter1CompareMatch1A,
                                timerCounter4CompareMatchC,
                                timerCounter5CompareMatchA,
                                timerCounter5CompareMatchB,
                                timerCounter5CompareMatchC,
                                timerCounter5CaptureEvent,
                                timerCounter5Overflow,
                                usbEndpointPipeInterruptCommunicationRequest,
                                usbGeneralInterruptRequest,
                                usiStart,
                                timerCounter1CompareMatch1B,
                                timerCounterCompareMatchA,
                                linTransferComplete,
                                analogComparator3,
                                psc0CaptureEvent,
                                psc2CaptureEvent,
                                psc0EndCycle,
                                psc2EndCycle,
                                linError,
                                batteryMonitorIndicatesSupplyVoltageBelowThreshold,
                                trx24AwakeTransceiverIsReachingStateTRXOFF,
                                coulombCounterADCConversionComplete,
                                symbolCounterCompareMatch1Interrupt,
                                symbolCounterCompareMatch2Interrupt,
                                symbolCounterCompareMatch3Interrupt,
                                coloumbCounterADCRegularCurrent,
                                symbolCounterOverflowInterrupt,
                                symbolCounterBackoffInterrupt,
                                coloumbCounterADCAccumulator,
                                voltageADCConversionComplete,
                                batteryProtectionInterrupt,
                                trx24ReceiveStartInterrupt,
                                timerCounter2CaptureEvent,
                                aesEngineReadyInterrupt,
                                usart2DataRegisterEmpty,
                                trx24PLLUnlockInterrupt,
                                trx24CCAEDDoneInterrupt,
                                serialTransferComplete,
                                trx24PLLLockInterrupt,
                                timer0CompareMatchA,
                                timer0CompareMatchB,
                                timer1CompareMatchA,
                                timer1CompareMatchB,
                                trx24RXENDInterrupt,
                                trx24TXENDInterrupt,
                                externalInterrupt1,
                                timer0InputCapture,
                                timer1InputCapture,
                                timer0Overflow,
                                timer1Overflow,
                                trx24XAHAMI,
                                RESERVED,
                                addressMatchInterruptOfAddressFilter0,
                                addressMatchInterruptOfAddressFilter1,
                                addressMatchInterruptOfAddressFilter2,
                                addressMatchInterruptOfAddressFilter3,
                                voltageRegulatorMonitorInterrupt,
                                timerCounter1FaultProtection,
                                timerCounter1CompareMatchD,
                                timerCounter0InputCapture,
                                canMOBBurstGeneralErrors,
                                usart3DataRegisterEmpty,
                                timer1Counter1Overflow,
                                vccVoltageLevelMonitor,
                                trx24TXStartInterrupt,
                                timerCouner0Overflow,
                                pinChangeInterrupt0,
                                pinChangeInterrupt1,
                                pinChangeInterrupt,
                                canTimerOverflow,
                                psc1CaptureEvent,
                                usart2RxComplete,
                                usart2TxComplete,
                                usart3RxComplete,
                                usart3TxComplete,
                                pscEndOfCycle,
                                psc1EndCycle,
                                pscFault,
                                twoWireBusConnectDisconnect,
                                timerCounter2CompareMatchC,
                                spmReady,
                                bandgapBufferShortCircuitDetected,
                                serialPeripheralInterface,
                                chargerDetect,
                                touchSensing,
                                usart0Start,
                                usart1Start,
                                canTransferCompleteOrError,
                                usartStartEdgeInterrupt,
                                watchdogTimerOverflow,
                                adcConversionReady,
                                canTimerOverrun,
                                timerCounter4FaultProtectionInterrupt,
                                timerCounter0CompareMatch0A,
                                spi1SerialTransferComplete,
                                usiStartConditionDetection,
                                pinChangeInterruptRequestA,
                                pinChangeInterruptRequestB,
                                pinChangeInterruptRequestD,
                                timerCounter4CompareMatchD,
                                timerCounter1InputCapture,
                                usart0RXStartEdgeDetect,
                                usart1RXStartEdgeDetect,
                                usart2RXStartEdgeDetect,
                                psc0EndOfEnhancedCycle,
                                psc2EndOfEnhancedCycle,
                                conversionComplete,
                                usiCounterOverflow,
                                twoWireInterface,
                                usartRXStart,
                                Reserved1,
                                Reserved2,
                                Reserved3,
                                Reserved4,
                                Reserved5,
                                Reserved6,
                                voltageADCInstantaneousConversionComplete,
                                voltageADCAccumulatedConversionComplete,
                                cADCInstantaneousConversionComplete,
                                cADCAccumulatedConversionComplete,
                                clockFailureDetectionInterrupt,
                                ptcWindowComparatorInterrupt,
                                spi0SerialTransferComplete,
                                pinChangeInterruptRequest4,
                                timerCounter0CompareAMatch,
                                timerCounter0CompareBMatch,
                                usart0StartFrameDetection,
                                usart1StartFrameDetection,
                                ptcWindowComparatorMode,
                                pllLockChangeInterrupt,
                                value2WireSerialInterface0,
                                value2WireSerialInterface1,
                                crystalFailureDetect,
                                twiTransferComplete,
                                wakeupTimerOverflow,
                                linStatusInterrupt,
                                cADCRegularCurrent,
                                ptcEndOfConversion,
                                timer0CompareMatch,
                                linErrorInterrupt,
                                usartStart
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct ModuleInstance: ATDFStringValue {
                    static let TCA0 = ModuleInstance(value: "TCA0")
                    static let USART0 = ModuleInstance(value: "USART0")
                    static let ADC0 = ModuleInstance(value: "ADC0")
                    static let TWI0 = ModuleInstance(value: "TWI0")
                    static let RTC = ModuleInstance(value: "RTC")
                    static let USART1 = ModuleInstance(value: "USART1")
                    static let CRCSCAN = ModuleInstance(value: "CRCSCAN")
                    static let NVMCTRL = ModuleInstance(value: "NVMCTRL")
                    static let PORTA = ModuleInstance(value: "PORTA")
                    static let SPI0 = ModuleInstance(value: "SPI0")
                    static let TCB0 = ModuleInstance(value: "TCB0")
                    static let AC0 = ModuleInstance(value: "AC0")
                    static let BOD = ModuleInstance(value: "BOD")
                    static let PORTB = ModuleInstance(value: "PORTB")
                    static let PORTC = ModuleInstance(value: "PORTC")
                    static let TCD0 = ModuleInstance(value: "TCD0")
                    static let TCB1 = ModuleInstance(value: "TCB1")
                    static let USART2 = ModuleInstance(value: "USART2")
                    static let CCL = ModuleInstance(value: "CCL")
                    static let USART3 = ModuleInstance(value: "USART3")
                    static let ADC1 = ModuleInstance(value: "ADC1")
                    static let PORTD = ModuleInstance(value: "PORTD")
                    static let PORTE = ModuleInstance(value: "PORTE")
                    static let PORTF = ModuleInstance(value: "PORTF")
                    static let TCB2 = ModuleInstance(value: "TCB2")
                    static let AC1 = ModuleInstance(value: "AC1")
                    static let AC2 = ModuleInstance(value: "AC2")
                    static let TCB3 = ModuleInstance(value: "TCB3")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [ModuleInstance] = [
                                TCA0,
                                USART0,
                                ADC0,
                                TWI0,
                                RTC,
                                USART1,
                                CRCSCAN,
                                NVMCTRL,
                                PORTA,
                                SPI0,
                                TCB0,
                                AC0,
                                BOD,
                                PORTB,
                                PORTC,
                                TCD0,
                                TCB1,
                                USART2,
                                CCL,
                                USART3,
                                ADC1,
                                PORTD,
                                PORTE,
                                PORTF,
                                TCB2,
                                AC1,
                                AC2,
                                TCB3
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }
            }
        }

        struct Parameters: Codable {
            let param: Param

            enum CodingKeys: String, CodingKey {
                case param
            }

            struct Param: Codable {
                @Attribute var name: Name
                @Attribute var value: Value

                enum CodingKeys: String, CodingKey {
                    case name
                    case value
                }

                struct Name: ATDFStringValue {
                    static let SUPPORTS_EEPROM_ERASE = Name(value: "SUPPORTS_EEPROM_ERASE")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Name] = [
                                SUPPORTS_EEPROM_ERASE
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }

                struct Value: ATDFStringValue {
                    static let one = Value(value: "1")

                    let rawValue: String
                    let alternateValues: [String]

                    static let allCases: [Value] = [
                                one
                            ]

                    init(value: String, alternateValues: [String] = []) {
                        self.rawValue = value
                        self.alternateValues = alternateValues
                    }
                }
            }
        }
    }
}
