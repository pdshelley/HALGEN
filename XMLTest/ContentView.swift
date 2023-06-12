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
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button {
                doThis()
            } label: {
                Text("Do the thing")
            }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





func doThis() {
    
//    let sourceJSON = """
//    {
//      "variants": [
//        {
//          "name": "Apples",
//          "code": "345"
//        },
//        {
//          "name": "Bananas",
//          "code": "237"
//        }
//      ]
//    }
//    """
//
//    struct JSONFruit: Codable {
//        let variants: [Variant]
//
//        struct Variant: Codable {
//            let code: String
//            let name: String
//        }
//    }
    
//        let sourceXML = """
//        <fruit>
//            <variants>
//                <variant code="345" name="Apples" />
//                <variant code="237" name="Bananas" />
//            </variants>
//        </fruit>
//    """
    
    
    let sourceXML = """
    <avr-tools-device-file xmlns:xalan="http://xml.apache.org/xalan" xmlns:NumHelper="NumHelper" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" schema-version="0.3" xsi:noNamespaceSchemaLocation="../../schema/avr_tools_device_file.xsd">
      <variants>
        <variant ordercode="ATmega328P-AU" tempmin="-40" tempmax="85" speedmax="20000000" pinout="TQFP32" package="TQFP32" vccmin="1.8" vccmax="5.5"/>
        <variant ordercode="ATmega328P-MMH" tempmin="-40" tempmax="85" speedmax="20000000" pinout="QFN28" package="QFN28" vccmin="1.8" vccmax="5.5"/>
        <variant ordercode="ATmega328P-MU" tempmin="-40" tempmax="85" speedmax="20000000" pinout="QFN32" package="QFN32" vccmin="1.8" vccmax="5.5"/>
        <variant ordercode="ATmega328P-PU" tempmin="-40" tempmax="85" speedmax="20000000" pinout="PDIP28" package="PDIP28" vccmin="1.8" vccmax="5.5"/>
        <variant ordercode="ATmega328P-AN" tempmin="-40" tempmax="105" speedmax="20000000" pinout="TQFP32" package="TQFP32" vccmin="1.8" vccmax="5.5"/>
        <variant ordercode="ATmega328P-MN" tempmin="-40" tempmax="105" speedmax="20000000" pinout="QFN32" package="QFN32" vccmin="1.8" vccmax="5.5"/>
        <variant ordercode="ATmega328P-PN" tempmin="-40" tempmax="105" speedmax="20000000" pinout="PDIP28" package="PDIP28" vccmin="1.8" vccmax="5.5"/>
      </variants>
      <devices>
        <device name="ATmega328P" architecture="AVR8" family="megaAVR">
      <address-spaces>
        <address-space endianness="little" name="prog" id="prog" start="0x0000" size="0x8000">
          <memory-segment start="0x0000" size="0x8000" type="flash" rw="RW" exec="1" name="FLASH" pagesize="0x80"/>
          <memory-segment start="0x7e00" size="0x0200" type="flash" rw="RW" exec="1" name="BOOT_SECTION_1" pagesize="0x80"/>
          <memory-segment start="0x7c00" size="0x0400" type="flash" rw="RW" exec="1" name="BOOT_SECTION_2" pagesize="0x80"/>
          <memory-segment start="0x7800" size="0x0800" type="flash" rw="RW" exec="1" name="BOOT_SECTION_3" pagesize="0x80"/>
          <memory-segment start="0x7000" size="0x1000" type="flash" rw="RW" exec="1" name="BOOT_SECTION_4" pagesize="0x80"/>
        </address-space>
        <address-space endianness="little" name="signatures" id="signatures" start="0" size="3">
          <memory-segment start="0" size="3" type="signatures" rw="R" exec="0" name="SIGNATURES"/>
        </address-space>
        <address-space endianness="little" name="fuses" id="fuses" start="0" size="0x0003">
          <memory-segment start="0" size="0x0003" type="fuses" rw="RW" exec="0" name="FUSES"/>
        </address-space>
        <address-space endianness="little" name="lockbits" id="lockbits" start="0" size="0x0001">
          <memory-segment start="0" size="0x0001" type="lockbits" rw="RW" exec="0" name="LOCKBITS"/>
        </address-space>
        <address-space endianness="little" name="data" id="data" start="0x0000" size="0x0900">
          <memory-segment external="false" type="regs" size="0x0020" start="0x0000" name="REGISTERS"/>
          <memory-segment name="MAPPED_IO" start="0x0020" size="0x00e0" type="io" external="false"/>
          <memory-segment name="IRAM" start="0x0100" size="0x0800" type="ram" external="false"/>
        </address-space>
        <address-space endianness="little" name="eeprom" id="eeprom" start="0x0000" size="0x0400">
          <memory-segment start="0x0000" size="0x0400" type="eeprom" rw="RW" exec="0" name="EEPROM" pagesize="0x04"/>
        </address-space>
        <address-space size="0x40" start="0x00" endianness="little" name="io" id="io"/>
        <address-space endianness="little" name="osccal" id="osccal" start="0" size="1">
          <memory-segment start="0" size="1" type="osccal" rw="R" exec="0" name="OSCCAL"/>
        </address-space>
      </address-spaces>
    
          <peripherals>
    <module name="USART">
          <instance name="USART0" caption="USART">
            <register-group name="USART0" name-in-module="USART0" offset="0x00" address-space="data" caption="USART"/>
            <signals>
              <signal group="TXD" function="default" pad="PD1"/>
              <signal group="RXD" function="default" pad="PD0"/>
              <signal group="XCK" function="default" pad="PD4"/>
            </signals>
          </instance>
        </module>
        <module name="TWI">
          <instance name="TWI" caption="Two Wire Serial Interface">
            <register-group name="TWI" name-in-module="TWI" offset="0x00" address-space="data" caption="Two Wire Serial Interface"/>
            <signals>
              <signal group="SDA" function="default" pad="PC4"/>
              <signal group="SCL" function="default" pad="PC5"/>
            </signals>
          </instance>
        </module>
      </peripherals>
      <interrupts>
        <interrupt index="0" name="RESET" caption="External Pin, Power-on Reset, Brown-out Reset and Watchdog Reset"/>
        <interrupt index="1" name="INT0" caption="External Interrupt Request 0"/>
        <interrupt index="2" name="INT1" caption="External Interrupt Request 1"/>
        <interrupt index="3" name="PCINT0" caption="Pin Change Interrupt Request 0"/>
        <interrupt index="4" name="PCINT1" caption="Pin Change Interrupt Request 1"/>
        <interrupt index="5" name="PCINT2" caption="Pin Change Interrupt Request 2"/>
        <interrupt index="6" name="WDT" caption="Watchdog Time-out Interrupt"/>
        <interrupt index="7" name="TIMER2_COMPA" caption="Timer/Counter2 Compare Match A"/>
        <interrupt index="8" name="TIMER2_COMPB" caption="Timer/Counter2 Compare Match B"/>
        <interrupt index="9" name="TIMER2_OVF" caption="Timer/Counter2 Overflow"/>
        <interrupt index="10" name="TIMER1_CAPT" caption="Timer/Counter1 Capture Event"/>
        <interrupt index="11" name="TIMER1_COMPA" caption="Timer/Counter1 Compare Match A"/>
        <interrupt index="12" name="TIMER1_COMPB" caption="Timer/Counter1 Compare Match B"/>
        <interrupt index="13" name="TIMER1_OVF" caption="Timer/Counter1 Overflow"/>
        <interrupt index="14" name="TIMER0_COMPA" caption="TimerCounter0 Compare Match A"/>
        <interrupt index="15" name="TIMER0_COMPB" caption="TimerCounter0 Compare Match B"/>
        <interrupt index="16" name="TIMER0_OVF" caption="Timer/Couner0 Overflow"/>
        <interrupt index="17" name="SPI_STC" caption="SPI Serial Transfer Complete"/>
        <interrupt index="18" name="USART_RX" caption="USART Rx Complete"/>
        <interrupt index="19" name="USART_UDRE" caption="USART, Data Register Empty"/>
        <interrupt index="20" name="USART_TX" caption="USART Tx Complete"/>
        <interrupt index="21" name="ADC" caption="ADC Conversion Complete"/>
        <interrupt index="22" name="EE_READY" caption="EEPROM Ready"/>
        <interrupt index="23" name="ANALOG_COMP" caption="Analog Comparator"/>
        <interrupt index="24" name="TWI" caption="Two-wire Serial Interface"/>
        <interrupt index="25" name="SPM_Ready" caption="Store Program Memory Read"/>
      </interrupts>
    
          <interfaces>
          </interfaces>
    
          <property-groups>
          </property-groups>

        </device>
      </devices>
        </avr-tools-device-file>
    """
    
    struct AVTToolsDeviceFile: Codable {
        let variants: Variants
        let devices: Devices
//        let modules: Modules
//        let pinouts: Pinouts
        
        struct Variants: Codable {
            var variant: [Variant]
            
            struct Variant: Codable {
                @Attribute var ordercode: String
                @Attribute var tempmin: String
                @Attribute var tempmax: String
                @Attribute var speedmax: String
                @Attribute var pinout: String
                @Attribute var package: String
                @Attribute var vccmin: String
                @Attribute var vccmax: String
            }
        }
        
        struct Devices: Codable {
            let device: [Device]
            
            struct Device: Codable {
                @Attribute var name: String
                @Attribute var architecture: String
                @Attribute var family: String
                let addressSpaces: AddressSpaces
                let peripherals: Peripherals
                let interrupts: Interrupts
                let interfaces: String
                let propertyGroups: String
                
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
                        }
                    }
                }
                
                struct Peripherals: Codable {
                    let module: [Module]
                     
                    struct Module: Codable {
                        @Attribute var name: String
                        let instance: Instance
                        
                        struct Instance: Codable {
                            @Attribute var name: String
                            @Attribute var caption: String
                            let registerGroup: RegisterGroup
                            let signals: Signals
                            
                            enum CodingKeys: String, CodingKey {
                                case name
                                case caption
                                case registerGroup = "register-group"
                                case signals
                            }
                            
                            struct RegisterGroup: Codable {
                                @Attribute var name: String
                                @Attribute var nameInModule: String
                                @Attribute var offset: String
                                @Attribute var addressSpace: String
                                @Attribute var caption: String
                                
                                enum CodingKeys: String, CodingKey {
                                    case name
                                    case nameInModule  = "name-in-module"
                                    case offset
                                    case addressSpace = "address-space"
                                    case caption
                                }
                            }
                            
                            struct Signals: Codable {
                                let signal: [Signal]
                                
                                struct Signal: Codable {
                                    @Attribute var group: String
                                    @Attribute var function: String
                                    @Attribute var pad: String
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
                        @Attribute var caption: String
                    }
                }
            }
        }
    }
    
    
//    let apple = XMLFruit.Variants.Variant(code: "345", name: "Apples")
//    let banana = XMLFruit.Variants.Variant(code: "237", name: "Bananas")
//
//    let variant: [XMLFruit.Variants.Variant] = [apple, banana]
//
//    let variants: XMLFruit.Variants = XMLFruit.Variants(variant: variant)
//
//    let xFruit: XMLFruit = XMLFruit(variants: variants)
    
//    struct XMLFruit: Codable {
//      @Element var variants: Variants
//
//      struct Variants: Codable {
//        @Element var variant: [Variant]
//      }
//
//      struct Variant: Codable {
//          @Attribute var code: String
//          @Attribute var name: String
//      }
//    }
    
//    struct XMLFruit: Codable {
//        let variants: [Variant]
//
//        struct Variant: Codable {
//            @Attribute var code: String
//            @Attribute var name: String
//        }
//    }

//    struct ToolsFile: Codable {
//        let variants: [Variants]
//
//        struct Variants: Codable, Equatable {
//            var variant: [String]
//        }
//    }
    
    
//    let sourceXML = """
//    <book>
//        <title>Cat in the Hat</title>
//            <category>Kids</category>
//            <category>Wildlife</category>
//    </book>
//    """
//
//    struct Book: Codable {
//        let title: String
//        let categories: [Category]
//
//        enum CodingKeys: String, CodingKey {
//            case title
//            case categories = "category"
//        }
//
//        struct Category: Codable { }
//    }
    
    
    
    

    
    let note = try! XMLDecoder().decode(AVTToolsDeviceFile.self, from: Data(sourceXML.utf8))

    let encodedXML = try! XMLEncoder().encode(note, withRootKey: "avr-tools-device-file")  // "book"
    
//    let note = try! JSONDecoder().decode(JSONFruit.self, from: Data(sourceJSON.utf8))
//    let fruit = JSONFruit(variants: [
//        JSONFruit.Variant(code: "345", name: "Apples"),
//        JSONFruit.Variant(code: "237", name: "Bananas")
//    ])
    
    
//    let encodedJSON = try! JSONEncoder().encode(note)

//    let encodedXML = try! XMLEncoder().encode(note, withRootKey: "fruit")  // "book"

//    let note = try! XMLDecoder().decode(AVRToolsDeviceFile.self, from: Data(sourceXML.utf8))
//
//    let encodedXML = try! XMLEncoder().encode(note, withRootKey: "avr-tools-device-file")
    
//    let jsonEncoder = JSONEncoder()
//    let jsonData = try! jsonEncoder.encode(note)
    
    print(String(data: encodedXML, encoding: .utf8)!)
}
