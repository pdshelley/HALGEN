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
            <module name="TC16">
              <instance name="TC1" caption="Timer/Counter, 16-bit">
                <register-group name="TC1" name-in-module="TC1" offset="0x00" address-space="data" caption="Timer/Counter, 16-bit"/>
                <signals>
                  <signal group="T" function="default" pad="PD5"/>
                  <signal group="ICP" function="default" pad="PB0"/>
                  <signal group="OCA" function="default" pad="PB1"/>
                  <signal group="OCB" function="default" pad="PB2"/>
                </signals>
              </instance>
            </module>
            <module name="TC8_ASYNC">
              <instance name="TC2" caption="Timer/Counter, 8-bit Async">
                <register-group name="TC2" name-in-module="TC2" offset="0x00" address-space="data" caption="Timer/Counter, 8-bit Async"/>
                <signals>
                  <signal group="OCA" function="default" pad="PB3"/>
                  <signal group="OCB" function="default" pad="PD3"/>
                  <signal group="TOSC1" function="default" pad="PB6"/>
                  <signal group="TOSC2" function="default" pad="PB7"/>
                </signals>
              </instance>
            </module>
            <module name="ADC">
              <instance name="ADC" caption="Analog-to-Digital Converter">
                <register-group name="ADC" name-in-module="ADC" offset="0x00" address-space="data" caption="Analog-to-Digital Converter"/>
                <signals>
                  <signal group="ADC" index="0" function="default" pad="PC0"/>
                  <signal group="ADC" index="1" function="default" pad="PC1"/>
                  <signal group="ADC" index="2" function="default" pad="PC2"/>
                  <signal group="ADC" index="3" function="default" pad="PC3"/>
                  <signal group="ADC" index="4" function="default" pad="PC4"/>
                  <signal group="ADC" index="5" function="default" pad="PC5"/>
                </signals>
              </instance>
            </module>
            <module name="AC">
              <instance name="AC" caption="Analog Comparator">
                <register-group name="AC" name-in-module="AC" offset="0x00" address-space="data" caption="Analog Comparator"/>
                <signals>
                  <signal group="AIN" index="0" function="default" pad="PD6"/>
                  <signal group="AIN" index="1" function="default" pad="PD7"/>
                </signals>
              </instance>
            </module>
            <module name="PORT">
              <instance name="PORTB" caption="I/O Port">
                <register-group name="PORTB" name-in-module="PORTB" offset="0x00" address-space="data" caption="I/O Port"/>
                <signals>
                  <signal group="P" function="default" pad="PB0" index="0"/>
                  <signal group="P" function="default" pad="PB1" index="1"/>
                  <signal group="P" function="default" pad="PB2" index="2"/>
                  <signal group="P" function="default" pad="PB3" index="3"/>
                  <signal group="P" function="default" pad="PB4" index="4"/>
                  <signal group="P" function="default" pad="PB5" index="5"/>
                  <signal group="P" function="default" pad="PB6" index="6"/>
                  <signal group="P" function="default" pad="PB7" index="7"/>
                </signals>
              </instance>
              <instance name="PORTC" caption="I/O Port">
                <register-group name="PORTC" name-in-module="PORTC" offset="0x00" address-space="data" caption="I/O Port"/>
                <signals>
                  <signal group="P" function="default" pad="PC0" index="0"/>
                  <signal group="P" function="default" pad="PC1" index="1"/>
                  <signal group="P" function="default" pad="PC2" index="2"/>
                  <signal group="P" function="default" pad="PC3" index="3"/>
                  <signal group="P" function="default" pad="PC4" index="4"/>
                  <signal group="P" function="default" pad="PC5" index="5"/>
                  <signal group="P" function="default" pad="PC6" index="6"/>
                </signals>
              </instance>
              <instance name="PORTD" caption="I/O Port">
                <register-group name="PORTD" name-in-module="PORTD" offset="0x00" address-space="data" caption="I/O Port"/>
                <signals>
                  <signal group="P" function="default" pad="PD0" index="0"/>
                  <signal group="P" function="default" pad="PD1" index="1"/>
                  <signal group="P" function="default" pad="PD2" index="2"/>
                  <signal group="P" function="default" pad="PD3" index="3"/>
                  <signal group="P" function="default" pad="PD4" index="4"/>
                  <signal group="P" function="default" pad="PD5" index="5"/>
                  <signal group="P" function="default" pad="PD6" index="6"/>
                  <signal group="P" function="default" pad="PD7" index="7"/>
                </signals>
              </instance>
            </module>
            <module name="TC8">
              <instance name="TC0" caption="Timer/Counter, 8-bit">
                <register-group name="TC0" name-in-module="TC0" offset="0x00" address-space="data" caption="Timer/Counter, 8-bit"/>
                <signals>
                  <signal group="T" function="default" pad="PD4"/>
                  <signal group="OCB" function="default" pad="PD5"/>
                  <signal group="OCA" function="default" pad="PD6"/>
                </signals>
              </instance>
            </module>
            <module name="EXINT">
              <instance name="EXINT" caption="External Interrupts">
                <register-group name="EXINT" name-in-module="EXINT" offset="0x00" address-space="data" caption="External Interrupts"/>
                <signals>
                  <signal group="INT" index="1" function="default" pad="PD3"/>
                  <signal group="PCINT" index="19" function="default" pad="PD3"/>
                  <signal group="PCINT" index="20" function="default" pad="PD4"/>
                  <signal group="PCINT" index="6" function="default" pad="PB6"/>
                  <signal group="PCINT" index="7" function="default" pad="PB7"/>
                  <signal group="PCINT" index="21" function="default" pad="PD5"/>
                  <signal group="PCINT" index="22" function="default" pad="PD6"/>
                  <signal group="PCINT" index="23" function="default" pad="PD7"/>
                  <signal group="PCINT" index="0" function="default" pad="PB0"/>
                  <signal group="PCINT" index="1" function="default" pad="PB1"/>
                  <signal group="PCINT" index="2" function="default" pad="PB2"/>
                  <signal group="PCINT" index="3" function="default" pad="PB3"/>
                  <signal group="PCINT" index="4" function="default" pad="PB4"/>
                  <signal group="PCINT" index="5" function="default" pad="PB5"/>
                  <signal group="PCINT" index="8" function="default" pad="PC0"/>
                  <signal group="PCINT" index="9" function="default" pad="PC1"/>
                  <signal group="PCINT" index="10" function="default" pad="PC2"/>
                  <signal group="PCINT" index="11" function="default" pad="PC3"/>
                  <signal group="PCINT" index="12" function="default" pad="PC4"/>
                  <signal group="PCINT" index="13" function="default" pad="PC5"/>
                  <signal group="PCINT" index="14" function="default" pad="PC6"/>
                  <signal group="PCINT" index="16" function="default" pad="PD0"/>
                  <signal group="PCINT" index="17" function="default" pad="PD1"/>
                  <signal group="PCINT" index="18" function="default" pad="PD2"/>
                  <signal group="INT" index="0" function="default" pad="PD2"/>
                </signals>
              </instance>
            </module>
            <module name="SPI">
              <instance name="SPI" caption="Serial Peripheral Interface">
                <register-group name="SPI" name-in-module="SPI" offset="0x00" address-space="data" caption="Serial Peripheral Interface"/>
                <signals>
                  <signal group="SS" function="default" pad="PB2"/>
                  <signal group="MOSI" function="default" pad="PB3"/>
                  <signal group="MISO" function="default" pad="PB4"/>
                  <signal group="SCK" function="default" pad="PB5"/>
                </signals>
              </instance>
            </module>
            <module name="WDT">
              <instance name="WDT" caption="Watchdog Timer">
                <register-group name="WDT" name-in-module="WDT" offset="0x00" address-space="data" caption="Watchdog Timer"/>
              </instance>
            </module>
            <module name="EEPROM">
              <instance name="EEPROM" caption="EEPROM">
                <register-group name="EEPROM" name-in-module="EEPROM" offset="0x00" address-space="data" caption="EEPROM"/>
              </instance>
            </module>
            <module name="CPU">
              <instance name="CPU" caption="CPU Registers">
                <register-group name="CPU" name-in-module="CPU" offset="0x00" address-space="data" caption="CPU Registers"/>
                <signals>
                  <signal group="CLK" index="0" function="default" pad="PB0"/>
                  <signal group="XTAL1" function="default" pad="PB6"/>
                  <signal group="XTAL2" function="default" pad="PB7"/>
                </signals>
                <parameters>
                  <param name="CORE_VERSION" value="V2E"/>
                </parameters>
              </instance>
            </module>
            <module name="FUSE">
              <instance name="FUSE" caption="Fuses">
                <register-group name="FUSE" name-in-module="FUSE" offset="0" address-space="fuses" caption="Fuses"/>
              </instance>
            </module>
            <module name="LOCKBIT">
              <instance name="LOCKBIT" caption="Lockbits">
                <register-group name="LOCKBIT" name-in-module="LOCKBIT" offset="0" address-space="lockbits" caption="Lockbits"/>
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
            <interface name="ISP" type="isp"/>
            <interface name="HVPP" type="hvpp"/>
            <interface name="debugWIRE" type="dw"/>
          </interfaces>
          <property-groups>
            <property-group name="SIGNATURES">
              <property name="JTAGID" value="0x950F"/>
              <property name="SIGNATURE0" value="0x1e"/>
              <property name="SIGNATURE1" value="0x95"/>
              <property name="SIGNATURE2" value="0x0f"/>
            </property-group>
            <property-group name="OCD">
              <property name="OCD_REVISION" value="1"/>
              <property name="OCD_DATAREG" value="0x31"/>
              <property name="PROGBASE" value="0x0000"/>
            </property-group>
            <property-group name="JTAG_INTERFACE">
              <property name="ALLOWFULLPAGESTREAM" value="0x00"/>
            </property-group>
            <property-group name="ISP_INTERFACE">
              <property name="IspEnterProgMode_timeout" value="200"/>
              <property name="IspEnterProgMode_stabDelay" value="100"/>
              <property name="IspEnterProgMode_cmdexeDelay" value="25"/>
              <property name="IspEnterProgMode_synchLoops" value="32"/>
              <property name="IspEnterProgMode_byteDelay" value="0"/>
              <property name="IspEnterProgMode_pollIndex" value="3"/>
              <property name="IspEnterProgMode_pollValue" value="0x53"/>
              <property name="IspLeaveProgMode_preDelay" value="1"/>
              <property name="IspLeaveProgMode_postDelay" value="1"/>
              <property name="IspChipErase_eraseDelay" value="45"/>
              <property name="IspChipErase_pollMethod" value="1"/>
              <property name="IspProgramFlash_mode" value="0x41"/>
              <property name="IspProgramFlash_blockSize" value="128"/>
              <property name="IspProgramFlash_delay" value="10"/>
              <property name="IspProgramFlash_cmd1" value="0x40"/>
              <property name="IspProgramFlash_cmd2" value="0x4C"/>
              <property name="IspProgramFlash_cmd3" value="0x00"/>
              <property name="IspProgramFlash_pollVal1" value="0x00"/>
              <property name="IspProgramFlash_pollVal2" value="0x00"/>
              <property name="IspProgramEeprom_mode" value="0x41"/>
              <property name="IspProgramEeprom_blockSize" value="4"/>
              <property name="IspProgramEeprom_delay" value="20"/>
              <property name="IspProgramEeprom_cmd1" value="0xC1"/>
              <property name="IspProgramEeprom_cmd2" value="0xC2"/>
              <property name="IspProgramEeprom_cmd3" value="0x00"/>
              <property name="IspProgramEeprom_pollVal1" value="0x00"/>
              <property name="IspProgramEeprom_pollVal2" value="0x00"/>
              <property name="IspReadFlash_blockSize" value="256"/>
              <property name="IspReadEeprom_blockSize" value="256"/>
              <property name="IspReadFuse_pollIndex" value="4"/>
              <property name="IspReadLock_pollIndex" value="4"/>
              <property name="IspReadSign_pollIndex" value="4"/>
              <property name="IspReadOsccal_pollIndex" value="4"/>
            </property-group>
            <property-group name="PP_INTERFACE">
              <property name="PpControlStack" value="0x0E 0x1E 0x0F 0x1F 0x2E 0x3E 0x2F 0x3F 0x4E 0x5E 0x4F 0x5F 0x6E 0x7E 0x6F 0x7F 0x66 0x76 0x67 0x77 0x6A 0x7A 0x6B 0x7B 0xBE 0xFD 0x00 0x01 0x00 0x00 0x00 0x00"/>
              <property name="PpEnterProgMode_stabDelay" value="100"/>
              <property name="PpEnterProgMode_progModeDelay" value="0"/>
              <property name="PpEnterProgMode_latchCycles" value="5"/>
              <property name="PpEnterProgMode_toggleVtg" value="1"/>
              <property name="PpEnterProgMode_powerOffDelay" value="15"/>
              <property name="PpEnterProgMode_resetDelayMs" value="1"/>
              <property name="PpEnterProgMode_resetDelayUs" value="0"/>
              <property name="PpLeaveProgMode_stabDelay" value="15"/>
              <property name="PpLeaveProgMode_resetDelay" value="15"/>
              <property name="PpChipErase_pulseWidth" value="0"/>
              <property name="PpChipErase_pollTimeout" value="10"/>
              <property name="PpProgramFlash_pollTimeout" value="5"/>
              <property name="PpProgramFlash_mode" value="0x0F"/>
              <property name="PpProgramFlash_blockSize" value="256"/>
              <property name="PpReadFlash_blockSize" value="256"/>
              <property name="PpProgramEeprom_pollTimeout" value="5"/>
              <property name="PpProgramEeprom_mode" value="0x05"/>
              <property name="PpProgramEeprom_blockSize" value="256"/>
              <property name="PpReadEeprom_blockSize" value="256"/>
              <property name="PpProgramFuse_pulseWidth" value="0"/>
              <property name="PpProgramFuse_pollTimeout" value="5"/>
              <property name="PpProgramLock_pulseWidth" value="0"/>
              <property name="PpProgramLock_pollTimeout" value="5"/>
            </property-group>
            <property-group name="ISP_INTERFACE_STK600">
              <property name="IspEnterProgMode_timeout" value="200"/>
              <property name="IspEnterProgMode_stabDelay" value="100"/>
              <property name="IspEnterProgMode_cmdexeDelay" value="25"/>
              <property name="IspEnterProgMode_synchLoops" value="32"/>
              <property name="IspEnterProgMode_byteDelay" value="0"/>
              <property name="IspEnterProgMode_pollIndex" value="3"/>
              <property name="IspEnterProgMode_pollValue" value="0x53"/>
              <property name="IspLeaveProgMode_preDelay" value="1"/>
              <property name="IspLeaveProgMode_postDelay" value="1"/>
              <property name="IspChipErase_eraseDelay" value="45"/>
              <property name="IspChipErase_pollMethod" value="1"/>
              <property name="IspProgramFlash_mode" value="0x41"/>
              <property name="IspProgramFlash_blockSize" value="128"/>
              <property name="IspProgramFlash_delay" value="6"/>
              <property name="IspProgramFlash_cmd1" value="0x40"/>
              <property name="IspProgramFlash_cmd2" value="0x4C"/>
              <property name="IspProgramFlash_cmd3" value="0x00"/>
              <property name="IspProgramFlash_pollVal1" value="0x00"/>
              <property name="IspProgramFlash_pollVal2" value="0x00"/>
              <property name="IspProgramEeprom_mode" value="0x41"/>
              <property name="IspProgramEeprom_blockSize" value="4"/>
              <property name="IspProgramEeprom_delay" value="5"/>
              <property name="IspProgramEeprom_cmd1" value="0xC1"/>
              <property name="IspProgramEeprom_cmd2" value="0xC2"/>
              <property name="IspProgramEeprom_cmd3" value="0x00"/>
              <property name="IspProgramEeprom_pollVal1" value="0x00"/>
              <property name="IspProgramEeprom_pollVal2" value="0x00"/>
              <property name="IspReadFlash_blockSize" value="256"/>
              <property name="IspReadEeprom_blockSize" value="256"/>
              <property name="IspReadFuse_pollIndex" value="4"/>
              <property name="IspReadLock_pollIndex" value="4"/>
              <property name="IspReadSign_pollIndex" value="4"/>
              <property name="IspReadOsccal_pollIndex" value="4"/>
            </property-group>
            <property-group name="PP_INTERFACE_STK600">
              <property name="PpControlStack" value="0x0E 0x1E 0x0F 0x1F 0x2E 0x3E 0x2F 0x3F 0x4E 0x5E 0x4F 0x5F 0x6E 0x7E 0x6F 0x7F 0x66 0x76 0x67 0x77 0x6A 0x7A 0x6B 0x7B 0xBE 0xFD 0x00 0x01 0x00 0x00 0x00 0x00"/>
              <property name="PpEnterProgMode_stabDelay" value="100"/>
              <property name="PpEnterProgMode_progModeDelay" value="0"/>
              <property name="PpEnterProgMode_latchCycles" value="5"/>
              <property name="PpEnterProgMode_toggleVtg" value="1"/>
              <property name="PpEnterProgMode_powerOffDelay" value="20"/>
              <property name="PpEnterProgMode_resetDelayMs" value="1"/>
              <property name="PpEnterProgMode_resetDelayUs" value="0"/>
              <property name="PpLeaveProgMode_stabDelay" value="15"/>
              <property name="PpLeaveProgMode_resetDelay" value="15"/>
              <property name="PpChipErase_pulseWidth" value="0"/>
              <property name="PpChipErase_pollTimeout" value="10"/>
              <property name="PpProgramFlash_pollTimeout" value="5"/>
              <property name="PpProgramFlash_mode" value="0x0F"/>
              <property name="PpProgramFlash_blockSize" value="256"/>
              <property name="PpReadFlash_blockSize" value="256"/>
              <property name="PpProgramEeprom_pollTimeout" value="5"/>
              <property name="PpProgramEeprom_mode" value="0x05"/>
              <property name="PpProgramEeprom_blockSize" value="256"/>
              <property name="PpReadEeprom_blockSize" value="256"/>
              <property name="PpProgramFuse_pulseWidth" value="0"/>
              <property name="PpProgramFuse_pollTimeout" value="5"/>
              <property name="PpProgramLock_pulseWidth" value="0"/>
              <property name="PpProgramLock_pollTimeout" value="5"/>
            </property-group>
            <property-group name="PP_INTERFACE_AVRDRAGON">
              <property name="PpControlStack" value="0x0E 0x1E 0x0F 0x1F 0x2E 0x3E 0x2F 0x3F 0x4E 0x5E 0x4F 0x5F 0x6E 0x7E 0x6F 0x7F 0x66 0x76 0x67 0x77 0x6A 0x7A 0x6B 0x7B 0xBE 0xFD 0x0C 0x01 0x00 0x00 0x00 0x00"/>
              <property name="PpEnterProgMode_stabDelay" value="100"/>
              <property name="PpEnterProgMode_progModeDelay" value="0"/>
              <property name="PpEnterProgMode_latchCycles" value="5"/>
              <property name="PpEnterProgMode_toggleVtg" value="1"/>
              <property name="PpEnterProgMode_powerOffDelay" value="15"/>
              <property name="PpEnterProgMode_resetDelayMs" value="1"/>
              <property name="PpEnterProgMode_resetDelayUs" value="0"/>
              <property name="PpLeaveProgMode_stabDelay" value="15"/>
              <property name="PpLeaveProgMode_resetDelay" value="15"/>
              <property name="PpChipErase_pulseWidth" value="0"/>
              <property name="PpChipErase_pollTimeout" value="10"/>
              <property name="PpProgramFlash_pollTimeout" value="5"/>
              <property name="PpProgramFlash_mode" value="0x0F"/>
              <property name="PpProgramFlash_blockSize" value="256"/>
              <property name="PpReadFlash_blockSize" value="256"/>
              <property name="PpProgramEeprom_pollTimeout" value="5"/>
              <property name="PpProgramEeprom_mode" value="0x05"/>
              <property name="PpProgramEeprom_blockSize" value="256"/>
              <property name="PpReadEeprom_blockSize" value="256"/>
              <property name="PpProgramFuse_pulseWidth" value="0"/>
              <property name="PpProgramFuse_pollTimeout" value="5"/>
              <property name="PpProgramLock_pulseWidth" value="0"/>
              <property name="PpProgramLock_pollTimeout" value="5"/>
            </property-group>
          </property-groups>
        </device>
      </devices>
      <modules>
        <module caption="Fuses" name="FUSE">
          <register-group caption="Fuses" name="FUSE">
            <register name="EXTENDED" offset="0x02" size="1" initval="0xFF">
              <bitfield caption="Brown-out Detector trigger level" mask="0x07" name="BODLEVEL" values="ENUM_BODLEVEL"/>
            </register>
            <register name="HIGH" offset="0x01" size="1" initval="0xD9">
              <bitfield caption="Reset Disabled (Enable PC6 as i/o pin)" mask="0x80" name="RSTDISBL"/>
              <bitfield caption="Debug Wire enable" mask="0x40" name="DWEN"/>
              <bitfield caption="Serial program downloading (SPI) enabled" mask="0x20" name="SPIEN"/>
              <bitfield caption="Watch-dog Timer always on" mask="0x10" name="WDTON"/>
              <bitfield caption="Preserve EEPROM through the Chip Erase cycle" mask="0x08" name="EESAVE"/>
              <bitfield caption="Select boot size" mask="0x06" name="BOOTSZ" values="ENUM_BOOTSZ"/>
              <bitfield caption="Boot Reset vector Enabled" mask="0x01" name="BOOTRST"/>
            </register>
            <register name="LOW" offset="0x00" size="1" initval="0x62">
              <bitfield caption="Divide clock by 8 internally" mask="0x80" name="CKDIV8"/>
              <bitfield caption="Clock output on PORTB0" mask="0x40" name="CKOUT"/>
              <bitfield caption="Select Clock Source" mask="0x3F" name="SUT_CKSEL" values="ENUM_SUT_CKSEL"/>
            </register>
          </register-group>
          <value-group name="ENUM_SUT_CKSEL">
            <value caption="Ext. Clock; Start-up time PWRDWN/RESET: 6 CK/14 CK + 0 ms" name="EXTCLK_6CK_14CK_0MS" value="0x00"/>
            <value caption="Ext. Clock; Start-up time PWRDWN/RESET: 6 CK/14 CK + 4.1 ms" name="EXTCLK_6CK_14CK_4MS1" value="0x10"/>
            <value caption="Ext. Clock; Start-up time PWRDWN/RESET: 6 CK/14 CK + 65 ms" name="EXTCLK_6CK_14CK_65MS" value="0x20"/>
            <value caption="Int. RC Osc. 8 MHz; Start-up time PWRDWN/RESET: 6 CK/14 CK + 0 ms" name="INTRCOSC_8MHZ_6CK_14CK_0MS" value="0x02"/>
            <value caption="Int. RC Osc. 8 MHz; Start-up time PWRDWN/RESET: 6 CK/14 CK + 4.1 ms" name="INTRCOSC_8MHZ_6CK_14CK_4MS1" value="0x12"/>
            <value caption="Int. RC Osc. 8 MHz; Start-up time PWRDWN/RESET: 6 CK/14 CK + 65 ms" name="INTRCOSC_8MHZ_6CK_14CK_65MS" value="0x22"/>
            <value caption="Int. RC Osc. 128kHz; Start-up time PWRDWN/RESET: 6 CK/14 CK + 0 ms" name="INTRCOSC_128KHZ_6CK_14CK_0MS" value="0x03"/>
            <value caption="Int. RC Osc. 128kHz; Start-up time PWRDWN/RESET: 6 CK/14 CK + 4.1 ms" name="INTRCOSC_128KHZ_6CK_14CK_4MS1" value="0x13"/>
            <value caption="Int. RC Osc. 128kHz; Start-up time PWRDWN/RESET: 6 CK/14 CK + 65 ms" name="INTRCOSC_128KHZ_6CK_14CK_65MS" value="0x23"/>
            <value caption="Ext. Low-Freq. Crystal; Start-up time PWRDWN/RESET: 1K CK/14 CK + 0 ms" name="EXTLOFXTAL_1KCK_14CK_0MS" value="0x04"/>
            <value caption="Ext. Low-Freq. Crystal; Start-up time PWRDWN/RESET: 1K CK/14 CK + 4.1 ms" name="EXTLOFXTAL_1KCK_14CK_4MS1" value="0x14"/>
            <value caption="Ext. Low-Freq. Crystal; Start-up time PWRDWN/RESET: 1K CK/14 CK + 65 ms" name="EXTLOFXTAL_1KCK_14CK_65MS" value="0x24"/>
            <value caption="Ext. Low-Freq. Crystal; Start-up time PWRDWN/RESET: 32K CK/14 CK + 0 ms" name="EXTLOFXTAL_32KCK_14CK_0MS" value="0x05"/>
            <value caption="Ext. Low-Freq. Crystal; Start-up time PWRDWN/RESET: 32K CK/14 CK + 4.1 ms" name="EXTLOFXTAL_32KCK_14CK_4MS1" value="0x15"/>
            <value caption="Ext. Low-Freq. Crystal; Start-up time PWRDWN/RESET: 32K CK/14 CK + 65 ms" name="EXTLOFXTAL_32KCK_14CK_65MS" value="0x25"/>
            <value caption="Ext. Full-swing Crystal; Start-up time PWRDWN/RESET: 258 CK/14 CK + 4.1 ms" name="EXTFSXTAL_258CK_14CK_4MS1" value="0x06"/>
            <value caption="Ext. Full-swing Crystal; Start-up time PWRDWN/RESET: 258 CK/14 CK + 65 ms" name="EXTFSXTAL_258CK_14CK_65MS" value="0x16"/>
            <value caption="Ext. Full-swing Crystal; Start-up time PWRDWN/RESET: 1K CK /14 CK + 0 ms" name="EXTFSXTAL_1KCK_14CK_0MS" value="0x26"/>
            <value caption="Ext. Full-swing Crystal; Start-up time PWRDWN/RESET: 1K CK /14 CK + 4.1 ms" name="EXTFSXTAL_1KCK_14CK_4MS1" value="0x36"/>
            <value caption="Ext. Full-swing Crystal; Start-up time PWRDWN/RESET: 1K CK /14 CK + 65 ms" name="EXTFSXTAL_1KCK_14CK_65MS" value="0x07"/>
            <value caption="Ext. Full-swing Crystal; Start-up time PWRDWN/RESET: 16K CK/14 CK + 0 ms" name="EXTFSXTAL_16KCK_14CK_0MS" value="0x17"/>
            <value caption="Ext. Full-swing Crystal; Start-up time PWRDWN/RESET: 16K CK/14 CK + 4.1 ms" name="EXTFSXTAL_16KCK_14CK_4MS1" value="0x27"/>
            <value caption="Ext. Full-swing Crystal; Start-up time PWRDWN/RESET: 16K CK/14 CK + 65 ms" name="EXTFSXTAL_16KCK_14CK_65MS" value="0x37"/>
            <value caption="Ext. Crystal Osc. 0.4-0.9 MHz; Start-up time PWRDWN/RESET: 258 CK/14 CK + 4.1 ms" name="EXTXOSC_0MHZ4_0MHZ9_258CK_14CK_4MS1" value="0x08"/>
            <value caption="Ext. Crystal Osc. 0.4-0.9 MHz; Start-up time PWRDWN/RESET: 258 CK/14 CK + 65 ms" name="EXTXOSC_0MHZ4_0MHZ9_258CK_14CK_65MS" value="0x18"/>
            <value caption="Ext. Crystal Osc. 0.4-0.9 MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 0 ms" name="EXTXOSC_0MHZ4_0MHZ9_1KCK_14CK_0MS" value="0x28"/>
            <value caption="Ext. Crystal Osc. 0.4-0.9 MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 4.1 ms" name="EXTXOSC_0MHZ4_0MHZ9_1KCK_14CK_4MS1" value="0x38"/>
            <value caption="Ext. Crystal Osc. 0.4-0.9 MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 65 ms" name="EXTXOSC_0MHZ4_0MHZ9_1KCK_14CK_65MS" value="0x09"/>
            <value caption="Ext. Crystal Osc. 0.4-0.9 MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 0 ms" name="EXTXOSC_0MHZ4_0MHZ9_16KCK_14CK_0MS" value="0x19"/>
            <value caption="Ext. Crystal Osc. 0.4-0.9 MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 4.1 ms" name="EXTXOSC_0MHZ4_0MHZ9_16KCK_14CK_4MS1" value="0x29"/>
            <value caption="Ext. Crystal Osc. 0.4-0.9 MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 65 ms" name="EXTXOSC_0MHZ4_0MHZ9_16KCK_14CK_65MS" value="0x39"/>
            <value caption="Ext. Crystal Osc. 0.9-3.0 MHz; Start-up time PWRDWN/RESET: 258 CK/14 CK + 4.1 ms" name="EXTXOSC_0MHZ9_3MHZ_258CK_14CK_4MS1" value="0x0A"/>
            <value caption="Ext. Crystal Osc. 0.9-3.0 MHz; Start-up time PWRDWN/RESET: 258 CK/14 CK + 65 ms" name="EXTXOSC_0MHZ9_3MHZ_258CK_14CK_65MS" value="0x1A"/>
            <value caption="Ext. Crystal Osc. 0.9-3.0 MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 0 ms" name="EXTXOSC_0MHZ9_3MHZ_1KCK_14CK_0MS" value="0x2A"/>
            <value caption="Ext. Crystal Osc. 0.9-3.0 MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 4.1 ms" name="EXTXOSC_0MHZ9_3MHZ_1KCK_14CK_4MS1" value="0x3A"/>
            <value caption="Ext. Crystal Osc. 0.9-3.0 MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 65 ms" name="EXTXOSC_0MHZ9_3MHZ_1KCK_14CK_65MS" value="0x0B"/>
            <value caption="Ext. Crystal Osc. 0.9-3.0 MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 0 ms" name="EXTXOSC_0MHZ9_3MHZ_16KCK_14CK_0MS" value="0x1B"/>
            <value caption="Ext. Crystal Osc. 0.9-3.0 MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 4.1 ms" name="EXTXOSC_0MHZ9_3MHZ_16KCK_14CK_4MS1" value="0x2B"/>
            <value caption="Ext. Crystal Osc. 0.9-3.0 MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 65 ms" name="EXTXOSC_0MHZ9_3MHZ_16KCK_14CK_65MS" value="0x3B"/>
            <value caption="Ext. Crystal Osc. 3.0-8.0 MHz; Start-up time PWRDWN/RESET: 258 CK/14 CK + 4.1 ms" name="EXTXOSC_3MHZ_8MHZ_258CK_14CK_4MS1" value="0x0C"/>
            <value caption="Ext. Crystal Osc. 3.0-8.0 MHz; Start-up time PWRDWN/RESET: 258 CK/14 CK + 65 ms" name="EXTXOSC_3MHZ_8MHZ_258CK_14CK_65MS" value="0x1C"/>
            <value caption="Ext. Crystal Osc. 3.0-8.0 MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 0 ms" name="EXTXOSC_3MHZ_8MHZ_1KCK_14CK_0MS" value="0x2C"/>
            <value caption="Ext. Crystal Osc. 3.0-8.0 MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 4.1 ms" name="EXTXOSC_3MHZ_8MHZ_1KCK_14CK_4MS1" value="0x3C"/>
            <value caption="Ext. Crystal Osc. 3.0-8.0 MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 65 ms" name="EXTXOSC_3MHZ_8MHZ_1KCK_14CK_65MS" value="0x0D"/>
            <value caption="Ext. Crystal Osc. 3.0-8.0 MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 0 ms" name="EXTXOSC_3MHZ_8MHZ_16KCK_14CK_0MS" value="0x1D"/>
            <value caption="Ext. Crystal Osc. 3.0-8.0 MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 4.1 ms" name="EXTXOSC_3MHZ_8MHZ_16KCK_14CK_4MS1" value="0x2D"/>
            <value caption="Ext. Crystal Osc. 3.0-8.0 MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 65 ms" name="EXTXOSC_3MHZ_8MHZ_16KCK_14CK_65MS" value="0x3D"/>
            <value caption="Ext. Crystal Osc. 8.0-    MHz; Start-up time PWRDWN/RESET: 258 CK/14 CK + 4.1 ms" name="EXTXOSC_8MHZ_XX_258CK_14CK_4MS1" value="0x0E"/>
            <value caption="Ext. Crystal Osc. 8.0-    MHz; Start-up time PWRDWN/RESET: 258 CK/14 CK + 65 ms" name="EXTXOSC_8MHZ_XX_258CK_14CK_65MS" value="0x1E"/>
            <value caption="Ext. Crystal Osc. 8.0-    MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 0 ms" name="EXTXOSC_8MHZ_XX_1KCK_14CK_0MS" value="0x2E"/>
            <value caption="Ext. Crystal Osc. 8.0-    MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 4.1 ms" name="EXTXOSC_8MHZ_XX_1KCK_14CK_4MS1" value="0x3E"/>
            <value caption="Ext. Crystal Osc. 8.0-    MHz; Start-up time PWRDWN/RESET: 1K CK /14 CK + 65 ms" name="EXTXOSC_8MHZ_XX_1KCK_14CK_65MS" value="0x0F"/>
            <value caption="Ext. Crystal Osc. 8.0-    MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 0 ms" name="EXTXOSC_8MHZ_XX_16KCK_14CK_0MS" value="0x1F"/>
            <value caption="Ext. Crystal Osc. 8.0-    MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 4.1 ms" name="EXTXOSC_8MHZ_XX_16KCK_14CK_4MS1" value="0x2F"/>
            <value caption="Ext. Crystal Osc. 8.0-    MHz; Start-up time PWRDWN/RESET: 16K CK/14 CK + 65 ms" name="EXTXOSC_8MHZ_XX_16KCK_14CK_65MS" value="0x3F"/>
          </value-group>
          <value-group name="ENUM_BODLEVEL">
            <value caption="Brown-out detection at VCC=4.3 V" name="4V3" value="0x04"/>
            <value caption="Brown-out detection at VCC=2.7 V" name="2V7" value="0x05"/>
            <value caption="Brown-out detection at VCC=1.8 V" name="1V8" value="0x06"/>
            <value caption="Brown-out detection disabled" name="DISABLED" value="0x07"/>
          </value-group>
          <value-group name="ENUM_BOOTSZ">
            <value caption="Boot Flash size=256 words start address=$3F00" name="256W_3F00" value="0x03"/>
            <value caption="Boot Flash size=512 words start address=$3E00" name="512W_3E00" value="0x02"/>
            <value caption="Boot Flash size=1024 words start address=$3C00" name="1024W_3C00" value="0x01"/>
            <value caption="Boot Flash size=2048 words start address=$3800" name="2048W_3800" value="0x00"/>
          </value-group>
        </module>
        <module caption="Lockbits" name="LOCKBIT">
          <register-group caption="Lockbits" name="LOCKBIT">
            <register name="LOCKBIT" offset="0x00" size="1" initval="0xFF">
              <bitfield caption="Memory Lock" mask="0x03" name="LB" values="ENUM_LB"/>
              <bitfield caption="Boot Loader Protection Mode" mask="0x0C" name="BLB0" values="ENUM_BLB"/>
              <bitfield caption="Boot Loader Protection Mode" mask="0x30" name="BLB1" values="ENUM_BLB2"/>
            </register>
          </register-group>
          <value-group name="ENUM_LB">
            <value caption="Further programming and verification disabled" name="PROG_VER_DISABLED" value="0x00"/>
            <value caption="Further programming disabled" name="PROG_DISABLED" value="0x02"/>
            <value caption="No memory lock features enabled" name="NO_LOCK" value="0x03"/>
          </value-group>
          <value-group name="ENUM_BLB">
            <value caption="LPM and SPM prohibited in Application Section" name="LPM_SPM_DISABLE" value="0x00"/>
            <value caption="LPM prohibited in Application Section" name="LPM_DISABLE" value="0x01"/>
            <value caption="SPM prohibited in Application Section" name="SPM_DISABLE" value="0x02"/>
            <value caption="No lock on SPM and LPM in Application Section" name="NO_LOCK" value="0x03"/>
          </value-group>
          <value-group name="ENUM_BLB2">
            <value caption="LPM and SPM prohibited in Boot Section" name="LPM_SPM_DISABLE" value="0x00"/>
            <value caption="LPM prohibited in Boot Section" name="LPM_DISABLE" value="0x01"/>
            <value caption="SPM prohibited in Boot Section" name="SPM_DISABLE" value="0x02"/>
            <value caption="No lock on SPM and LPM in Boot Section" name="NO_LOCK" value="0x03"/>
          </value-group>
        </module>
        <module caption="USART" name="USART">
          <register-group caption="USART" name="USART0">
            <register caption="USART I/O Data Register" name="UDR0" offset="0xC6" size="1" mask="0xFF" ocd-rw=""/>
            <register caption="USART Control and Status Register A" name="UCSR0A" offset="0xC0" size="1" ocd-rw="R">
              <bitfield caption="USART Receive Complete" mask="0x80" name="RXC0"/>
              <bitfield caption="USART Transmitt Complete" mask="0x40" name="TXC0"/>
              <bitfield caption="USART Data Register Empty" mask="0x20" name="UDRE0"/>
              <bitfield caption="Framing Error" mask="0x10" name="FE0"/>
              <bitfield caption="Data overRun" mask="0x08" name="DOR0"/>
              <bitfield caption="Parity Error" mask="0x04" name="UPE0"/>
              <bitfield caption="Double the USART transmission speed" mask="0x02" name="U2X0"/>
              <bitfield caption="Multi-processor Communication Mode" mask="0x01" name="MPCM0"/>
            </register>
            <register caption="USART Control and Status Register B" name="UCSR0B" offset="0xC1" size="1">
              <bitfield caption="RX Complete Interrupt Enable" mask="0x80" name="RXCIE0"/>
              <bitfield caption="TX Complete Interrupt Enable" mask="0x40" name="TXCIE0"/>
              <bitfield caption="USART Data register Empty Interrupt Enable" mask="0x20" name="UDRIE0"/>
              <bitfield caption="Receiver Enable" mask="0x10" name="RXEN0"/>
              <bitfield caption="Transmitter Enable" mask="0x08" name="TXEN0"/>
              <bitfield caption="Character Size - together with UCSZ0 in UCSR0C" mask="0x04" name="UCSZ02"/>
              <bitfield caption="Receive Data Bit 8" mask="0x02" name="RXB80"/>
              <bitfield caption="Transmit Data Bit 8" mask="0x01" name="TXB80"/>
            </register>
            <register caption="USART Control and Status Register C" name="UCSR0C" offset="0xC2" size="1">
              <bitfield caption="USART Mode Select" mask="0xC0" name="UMSEL0" values="COMM_USART_MODE_2BIT"/>
              <bitfield caption="Parity Mode Bits" mask="0x30" name="UPM0" values="COMM_UPM_PARITY_MODE"/>
              <bitfield caption="Stop Bit Select" mask="0x08" name="USBS0" values="COMM_STOP_BIT_SEL"/>
              <bitfield caption="Character Size - together with UCSZ2 in UCSR0B" mask="0x06" name="UCSZ0"/>
              <bitfield caption="Clock Polarity" mask="0x01" name="UCPOL0"/>
            </register>
            <register caption="USART Baud Rate Register Bytes" name="UBRR0" offset="0xC4" size="2" mask="0x0FFF"/>
          </register-group>
          <value-group name="COMM_USART_MODE_2BIT">
            <value caption="Asynchronous USART" name="ASYNCHRONOUS_USART" value="0x00"/>
            <value caption="Synchronous USART" name="SYNCHRONOUS_USART" value="0x01"/>
            <value caption="Master SPI" name="MASTER_SPI" value="0x03"/>
          </value-group>
          <value-group name="COMM_UPM_PARITY_MODE">
            <value caption="Disabled" name="DISABLED" value="0x00"/>
            <value caption="Reserved" name="RESERVED" value="0x01"/>
            <value caption="Enabled, Even Parity" name="ENABLED_EVEN_PARITY" value="0x02"/>
            <value caption="Enabled, Odd Parity" name="ENABLED_ODD_PARITY" value="0x03"/>
          </value-group>
          <value-group name="COMM_STOP_BIT_SEL">
            <value caption="1-bit" name="1_BIT" value="0x00"/>
            <value caption="2-bit" name="2_BIT" value="0x01"/>
          </value-group>
        </module>
        <module caption="Two Wire Serial Interface" name="TWI">
          <register-group caption="Two Wire Serial Interface" name="TWI">
            <register caption="TWI (Slave) Address Mask Register" name="TWAMR" offset="0xBD" size="1">
              <bitfield mask="0xFE" name="TWAM"/>
            </register>
            <register caption="TWI Bit Rate register" name="TWBR" offset="0xB8" size="1" mask="0xFF"/>
            <register caption="TWI Control Register" name="TWCR" offset="0xBC" size="1" ocd-rw="R">
              <bitfield caption="TWI Interrupt Flag" mask="0x80" name="TWINT"/>
              <bitfield caption="TWI Enable Acknowledge Bit" mask="0x40" name="TWEA"/>
              <bitfield caption="TWI Start Condition Bit" mask="0x20" name="TWSTA"/>
              <bitfield caption="TWI Stop Condition Bit" mask="0x10" name="TWSTO"/>
              <bitfield caption="TWI Write Collition Flag" mask="0x08" name="TWWC"/>
              <bitfield caption="TWI Enable Bit" mask="0x04" name="TWEN"/>
              <bitfield caption="TWI Interrupt Enable" mask="0x01" name="TWIE"/>
            </register>
            <register caption="TWI Status Register" name="TWSR" offset="0xB9" size="1">
              <bitfield caption="TWI Status" mask="0xF8" name="TWS" lsb="3"/>
              <bitfield caption="TWI Prescaler" mask="0x03" name="TWPS" values="COMM_TWI_PRESACLE"/>
            </register>
            <register caption="TWI Data register" name="TWDR" offset="0xBB" size="1" mask="0xFF"/>
            <register caption="TWI (Slave) Address register" name="TWAR" offset="0xBA" size="1">
              <bitfield caption="TWI (Slave) Address register Bits" mask="0xFE" name="TWA"/>
              <bitfield caption="TWI General Call Recognition Enable Bit" mask="0x01" name="TWGCE"/>
            </register>
          </register-group>
          <value-group name="COMM_TWI_PRESACLE">
            <value caption="1" name="1" value="0x00"/>
            <value caption="4" name="4" value="0x01"/>
            <value caption="16" name="16" value="0x02"/>
            <value caption="64" name="64" value="0x03"/>
          </value-group>
        </module>
        <module caption="Timer/Counter, 16-bit" name="TC16">
          <register-group caption="Timer/Counter, 16-bit" name="TC1">
            <register caption="Timer/Counter Interrupt Mask Register" name="TIMSK1" offset="0x6F" size="1">
              <bitfield caption="Timer/Counter1 Input Capture Interrupt Enable" mask="0x20" name="ICIE1"/>
              <bitfield caption="Timer/Counter1 Output CompareB Match Interrupt Enable" mask="0x04" name="OCIE1B"/>
              <bitfield caption="Timer/Counter1 Output CompareA Match Interrupt Enable" mask="0x02" name="OCIE1A"/>
              <bitfield caption="Timer/Counter1 Overflow Interrupt Enable" mask="0x01" name="TOIE1"/>
            </register>
            <register caption="Timer/Counter Interrupt Flag register" name="TIFR1" offset="0x36" size="1" ocd-rw="R">
              <bitfield caption="Input Capture Flag 1" mask="0x20" name="ICF1"/>
              <bitfield caption="Output Compare Flag 1B" mask="0x04" name="OCF1B"/>
              <bitfield caption="Output Compare Flag 1A" mask="0x02" name="OCF1A"/>
              <bitfield caption="Timer/Counter1 Overflow Flag" mask="0x01" name="TOV1"/>
            </register>
            <register caption="Timer/Counter1 Control Register A" name="TCCR1A" offset="0x80" size="1">
              <bitfield caption="Compare Output Mode 1A, bits" mask="0xC0" name="COM1A"/>
              <bitfield caption="Compare Output Mode 1B, bits" mask="0x30" name="COM1B"/>
              <bitfield caption="Waveform Generation Mode" mask="0x03" name="WGM1"/>
            </register>
            <register caption="Timer/Counter1 Control Register B" name="TCCR1B" offset="0x81" size="1">
              <bitfield caption="Input Capture 1 Noise Canceler" mask="0x80" name="ICNC1"/>
              <bitfield caption="Input Capture 1 Edge Select" mask="0x40" name="ICES1"/>
              <bitfield caption="Waveform Generation Mode" mask="0x18" name="WGM1" lsb="2"/>
              <bitfield caption="Prescaler source of Timer/Counter 1" mask="0x07" name="CS1" values="CLK_SEL_3BIT_EXT"/>
            </register>
            <register caption="Timer/Counter1 Control Register C" name="TCCR1C" offset="0x82" size="1" ocd-rw="">
              <bitfield mask="0x80" name="FOC1A"/>
              <bitfield mask="0x40" name="FOC1B"/>
            </register>
            <register caption="Timer/Counter1  Bytes" name="TCNT1" offset="0x84" size="2" mask="0xFFFF"/>
            <register caption="Timer/Counter1 Output Compare Register  Bytes" name="OCR1A" offset="0x88" size="2" mask="0xFFFF"/>
            <register caption="Timer/Counter1 Output Compare Register  Bytes" name="OCR1B" offset="0x8A" size="2" mask="0xFFFF"/>
            <register caption="Timer/Counter1 Input Capture Register  Bytes" name="ICR1" offset="0x86" size="2" mask="0xFFFF"/>
            <register caption="General Timer/Counter Control Register" name="GTCCR" offset="0x43" size="1">
              <bitfield caption="Timer/Counter Synchronization Mode" mask="0x80" name="TSM"/>
              <bitfield caption="Prescaler Reset Timer/Counter1 and Timer/Counter0" mask="0x01" name="PSRSYNC"/>
            </register>
          </register-group>
          <value-group name="CLK_SEL_3BIT_EXT">
            <value caption="No Clock Source (Stopped)" name="NO_CLOCK_SOURCE_STOPPED" value="0x00"/>
            <value caption="Running, No Prescaling" name="RUNNING_NO_PRESCALING" value="0x01"/>
            <value caption="Running, CLK/8" name="RUNNING_CLK_8" value="0x02"/>
            <value caption="Running, CLK/64" name="RUNNING_CLK_64" value="0x03"/>
            <value caption="Running, CLK/256" name="RUNNING_CLK_256" value="0x04"/>
            <value caption="Running, CLK/1024" name="RUNNING_CLK_1024" value="0x05"/>
            <value caption="Running, ExtClk Tn Falling Edge" name="RUNNING_EXTCLK_TN_FALLING_EDGE" value="0x06"/>
            <value caption="Running, ExtClk Tn Rising Edge" name="RUNNING_EXTCLK_TN_RISING_EDGE" value="0x07"/>
          </value-group>
        </module>
        <module caption="Timer/Counter, 8-bit Async" name="TC8_ASYNC">
          <register-group caption="Timer/Counter, 8-bit Async" name="TC2">
            <register caption="Timer/Counter Interrupt Mask register" name="TIMSK2" offset="0x70" size="1">
              <bitfield caption="Timer/Counter2 Output Compare Match B Interrupt Enable" mask="0x04" name="OCIE2B"/>
              <bitfield caption="Timer/Counter2 Output Compare Match A Interrupt Enable" mask="0x02" name="OCIE2A"/>
              <bitfield caption="Timer/Counter2 Overflow Interrupt Enable" mask="0x01" name="TOIE2"/>
            </register>
            <register caption="Timer/Counter Interrupt Flag Register" name="TIFR2" offset="0x37" size="1" ocd-rw="R">
              <bitfield caption="Output Compare Flag 2B" mask="0x04" name="OCF2B"/>
              <bitfield caption="Output Compare Flag 2A" mask="0x02" name="OCF2A"/>
              <bitfield caption="Timer/Counter2 Overflow Flag" mask="0x01" name="TOV2"/>
            </register>
            <register caption="Timer/Counter2 Control Register A" name="TCCR2A" offset="0xB0" size="1">
              <bitfield caption="Compare Output Mode bits" mask="0xC0" name="COM2A"/>
              <bitfield caption="Compare Output Mode bits" mask="0x30" name="COM2B"/>
              <bitfield caption="Waveform Genration Mode" mask="0x03" name="WGM2"/>
            </register>
            <register caption="Timer/Counter2 Control Register B" name="TCCR2B" offset="0xB1" size="1">
              <bitfield caption="Force Output Compare A" mask="0x80" name="FOC2A"/>
              <bitfield caption="Force Output Compare B" mask="0x40" name="FOC2B"/>
              <bitfield caption="Waveform Generation Mode" mask="0x08" name="WGM22"/>
              <bitfield caption="Clock Select bits" mask="0x07" name="CS2" values="CLK_SEL_3BIT"/>
            </register>
            <register caption="Timer/Counter2" name="TCNT2" offset="0xB2" size="1" mask="0xFF"/>
            <register caption="Timer/Counter2 Output Compare Register B" name="OCR2B" offset="0xB4" size="1" mask="0xFF"/>
            <register caption="Timer/Counter2 Output Compare Register A" name="OCR2A" offset="0xB3" size="1" mask="0xFF"/>
            <register caption="Asynchronous Status Register" name="ASSR" offset="0xB6" size="1">
              <bitfield caption="Enable External Clock Input" mask="0x40" name="EXCLK"/>
              <bitfield caption="Asynchronous Timer/Counter2" mask="0x20" name="AS2"/>
              <bitfield caption="Timer/Counter2 Update Busy" mask="0x10" name="TCN2UB"/>
              <bitfield caption="Output Compare Register2 Update Busy" mask="0x08" name="OCR2AUB"/>
              <bitfield caption="Output Compare Register 2 Update Busy" mask="0x04" name="OCR2BUB"/>
              <bitfield caption="Timer/Counter Control Register2 Update Busy" mask="0x02" name="TCR2AUB"/>
              <bitfield caption="Timer/Counter Control Register2 Update Busy" mask="0x01" name="TCR2BUB"/>
            </register>
            <register caption="General Timer Counter Control register" name="GTCCR" offset="0x43" size="1">
              <bitfield caption="Timer/Counter Synchronization Mode" mask="0x80" name="TSM"/>
              <bitfield caption="Prescaler Reset Timer/Counter2" mask="0x02" name="PSRASY"/>
            </register>
          </register-group>
          <value-group name="CLK_SEL_3BIT">
            <value caption="No Clock Source (Stopped)" name="NO_CLOCK_SOURCE_STOPPED" value="0x00"/>
            <value caption="Running, No Prescaling" name="RUNNING_NO_PRESCALING" value="0x01"/>
            <value caption="Running, CLK/8" name="RUNNING_CLK_8" value="0x02"/>
            <value caption="Running, CLK/32" name="RUNNING_CLK_32" value="0x03"/>
            <value caption="Running, CLK/64" name="RUNNING_CLK_64" value="0x04"/>
            <value caption="Running, CLK/128" name="RUNNING_CLK_128" value="0x05"/>
            <value caption="Running, CLK/256" name="RUNNING_CLK_256" value="0x06"/>
            <value caption="Running, CLK/1024" name="RUNNING_CLK_1024" value="0x07"/>
          </value-group>
        </module>
        <module caption="Analog-to-Digital Converter" name="ADC">
          <register-group caption="Analog-to-Digital Converter" name="ADC">
            <register caption="The ADC multiplexer Selection Register" name="ADMUX" offset="0x7C" size="1">
              <bitfield caption="Reference Selection Bits" mask="0xC0" name="REFS" values="ANALOG_ADC_V_REF3"/>
              <bitfield caption="Left Adjust Result" mask="0x20" name="ADLAR"/>
              <bitfield caption="Analog Channel Selection Bits" mask="0x0F" name="MUX" values="ADC_MUX_SINGLE"/>
            </register>
            <register caption="ADC Data Register  Bytes" name="ADC" offset="0x78" size="2" mask="0xFFFF"/>
            <register caption="The ADC Control and Status register A" name="ADCSRA" offset="0x7A" size="1" ocd-rw="R">
              <bitfield caption="ADC Enable" mask="0x80" name="ADEN"/>
              <bitfield caption="ADC Start Conversion" mask="0x40" name="ADSC"/>
              <bitfield caption="ADC  Auto Trigger Enable" mask="0x20" name="ADATE"/>
              <bitfield caption="ADC Interrupt Flag" mask="0x10" name="ADIF"/>
              <bitfield caption="ADC Interrupt Enable" mask="0x08" name="ADIE"/>
              <bitfield caption="ADC  Prescaler Select Bits" mask="0x07" name="ADPS" values="ANALOG_ADC_PRESCALER"/>
            </register>
            <register caption="The ADC Control and Status register B" name="ADCSRB" offset="0x7B" size="1">
              <bitfield mask="0x40" name="ACME"/>
              <bitfield caption="ADC Auto Trigger Source bits" mask="0x07" name="ADTS" values="ANALOG_ADC_AUTO_TRIGGER"/>
            </register>
            <register caption="Digital Input Disable Register" name="DIDR0" offset="0x7E" size="1">
              <bitfield mask="0x20" name="ADC5D"/>
              <bitfield mask="0x10" name="ADC4D"/>
              <bitfield mask="0x08" name="ADC3D"/>
              <bitfield mask="0x04" name="ADC2D"/>
              <bitfield mask="0x02" name="ADC1D"/>
              <bitfield mask="0x01" name="ADC0D"/>
            </register>
          </register-group>
          <value-group name="ANALOG_ADC_V_REF3">
            <value caption="AREF, Internal Vref turned off" name="AREF_INTERNAL_VREF_TURNED_OFF" value="0x00"/>
            <value caption="AVCC with external capacitor at AREF pin" name="AVCC_WITH_EXTERNAL_CAPACITOR_AT_AREF_PIN" value="0x01"/>
            <value caption="Reserved" name="RESERVED" value="0x02"/>
            <value caption="Internal 1.1V Voltage Reference with external capacitor at AREF pin" name="INTERNAL_1_1V_VOLTAGE_REFERENCE_WITH_EXTERNAL_CAPACITOR_AT_AREF_PIN" value="0x03"/>
          </value-group>
          <value-group name="ADC_MUX_SINGLE">
            <value caption="ADC Single Ended Input pin 0" name="ADC0" value="0x00"/>
            <value caption="ADC Single Ended Input pin 1" name="ADC1" value="0x01"/>
            <value caption="ADC Single Ended Input pin 2" name="ADC2" value="0x02"/>
            <value caption="ADC Single Ended Input pin 3" name="ADC3" value="0x03"/>
            <value caption="ADC Single Ended Input pin 4" name="ADC4" value="0x04"/>
            <value caption="ADC Single Ended Input pin 5" name="ADC5" value="0x05"/>
            <value caption="ADC Single Ended Input pin 6" name="ADC6" value="0x06"/>
            <value caption="ADC Single Ended Input pin 7" name="ADC7" value="0x07"/>
            <value caption="Temperature sensor" name="TEMPSENS" value="0x08"/>
            <value caption="Internal Reference (VBG)" name="ADC_VBG" value="0x0E"/>
            <value caption="0V (GND)" name="ADC_GND" value="0x0F"/>
          </value-group>
          <value-group name="ANALOG_ADC_PRESCALER">
            <value caption="2" name="2" value="0x00"/>
            <value caption="2" name="2" value="0x01"/>
            <value caption="4" name="4" value="0x02"/>
            <value caption="8" name="8" value="0x03"/>
            <value caption="16" name="16" value="0x04"/>
            <value caption="32" name="32" value="0x05"/>
            <value caption="64" name="64" value="0x06"/>
            <value caption="128" name="128" value="0x07"/>
          </value-group>
          <value-group name="ANALOG_ADC_AUTO_TRIGGER">
            <value caption="Free Running mode" name="FREE_RUNNING_MODE" value="0x00"/>
            <value caption="Analog Comparator" name="ANALOG_COMPARATOR" value="0x01"/>
            <value caption="External Interrupt Request 0" name="EXTERNAL_INTERRUPT_REQUEST_0" value="0x02"/>
            <value caption="Timer/Counter0 Compare Match A" name="TIMER_COUNTER0_COMPARE_MATCH_A" value="0x03"/>
            <value caption="Timer/Counter0 Overflow" name="TIMER_COUNTER0_OVERFLOW" value="0x04"/>
            <value caption="Timer/Counter1 Compare Match B" name="TIMER_COUNTER1_COMPARE_MATCH_B" value="0x05"/>
            <value caption="Timer/Counter1 Overflow" name="TIMER_COUNTER1_OVERFLOW" value="0x06"/>
            <value caption="Timer/Counter1 Capture Event" name="TIMER_COUNTER1_CAPTURE_EVENT" value="0x07"/>
          </value-group>
        </module>
        <module caption="Analog Comparator" name="AC">
          <register-group caption="Analog Comparator" name="AC">
            <register caption="Analog Comparator Control And Status Register" name="ACSR" offset="0x50" size="1" ocd-rw="R">
              <bitfield caption="Analog Comparator Disable" mask="0x80" name="ACD"/>
              <bitfield caption="Analog Comparator Bandgap Select" mask="0x40" name="ACBG"/>
              <bitfield caption="Analog Compare Output" mask="0x20" name="ACO"/>
              <bitfield caption="Analog Comparator Interrupt Flag" mask="0x10" name="ACI"/>
              <bitfield caption="Analog Comparator Interrupt Enable" mask="0x08" name="ACIE"/>
              <bitfield caption="Analog Comparator Input Capture Enable" mask="0x04" name="ACIC"/>
              <bitfield caption="Analog Comparator Interrupt Mode Select bits" mask="0x03" name="ACIS" values="ANALOG_COMP_INTERRUPT"/>
            </register>
            <register caption="Digital Input Disable Register 1" name="DIDR1" offset="0x7F" size="1">
              <bitfield caption="AIN1 Digital Input Disable" mask="0x02" name="AIN1D"/>
              <bitfield caption="AIN0 Digital Input Disable" mask="0x01" name="AIN0D"/>
            </register>
          </register-group>
          <value-group name="ANALOG_COMP_INTERRUPT">
            <value caption="Interrupt on Toggle" name="INTERRUPT_ON_TOGGLE" value="0x00"/>
            <value caption="Reserved" name="RESERVED" value="0x01"/>
            <value caption="Interrupt on Falling Edge" name="INTERRUPT_ON_FALLING_EDGE" value="0x02"/>
            <value caption="Interrupt on Rising Edge" name="INTERRUPT_ON_RISING_EDGE" value="0x03"/>
          </value-group>
        </module>
        <module caption="I/O Port" name="PORT">
          <register-group caption="I/O Port" name="PORTB">
            <register caption="Port B Data Register" name="PORTB" offset="0x25" size="1" mask="0xFF"/>
            <register caption="Port B Data Direction Register" name="DDRB" offset="0x24" size="1" mask="0xFF"/>
            <register caption="Port B Input Pins" name="PINB" offset="0x23" size="1" mask="0xFF" ocd-rw="R"/>
          </register-group>
          <register-group caption="I/O Port" name="PORTC">
            <register caption="Port C Data Register" name="PORTC" offset="0x28" size="1" mask="0x7F"/>
            <register caption="Port C Data Direction Register" name="DDRC" offset="0x27" size="1" mask="0x7F"/>
            <register caption="Port C Input Pins" name="PINC" offset="0x26" size="1" mask="0x7F" ocd-rw="R"/>
          </register-group>
          <register-group caption="I/O Port" name="PORTD">
            <register caption="Port D Data Register" name="PORTD" offset="0x2B" size="1" mask="0xFF"/>
            <register caption="Port D Data Direction Register" name="DDRD" offset="0x2A" size="1" mask="0xFF"/>
            <register caption="Port D Input Pins" name="PIND" offset="0x29" size="1" mask="0xFF" ocd-rw="R"/>
          </register-group>
        </module>
        <module caption="Timer/Counter, 8-bit" name="TC8">
          <register-group caption="Timer/Counter, 8-bit" name="TC0">
            <register caption="Timer/Counter0 Output Compare Register" name="OCR0B" offset="0x48" size="1" mask="0xFF"/>
            <register caption="Timer/Counter0 Output Compare Register" name="OCR0A" offset="0x47" size="1" mask="0xFF"/>
            <register caption="Timer/Counter0" name="TCNT0" offset="0x46" size="1" mask="0xFF"/>
            <register caption="Timer/Counter Control Register B" name="TCCR0B" offset="0x45" size="1">
              <bitfield caption="Force Output Compare A" mask="0x80" name="FOC0A"/>
              <bitfield caption="Force Output Compare B" mask="0x40" name="FOC0B"/>
              <bitfield mask="0x08" name="WGM02"/>
              <bitfield caption="Clock Select" mask="0x07" name="CS0" values="CLK_SEL_3BIT_EXT"/>
            </register>
            <register caption="Timer/Counter  Control Register A" name="TCCR0A" offset="0x44" size="1">
              <bitfield caption="Compare Output Mode, Phase Correct PWM Mode" mask="0xC0" name="COM0A"/>
              <bitfield caption="Compare Output Mode, Fast PWm" mask="0x30" name="COM0B"/>
              <bitfield caption="Waveform Generation Mode" mask="0x03" name="WGM0"/>
            </register>
            <register caption="Timer/Counter0 Interrupt Mask Register" name="TIMSK0" offset="0x6E" size="1">
              <bitfield caption="Timer/Counter0 Output Compare Match B Interrupt Enable" mask="0x04" name="OCIE0B"/>
              <bitfield caption="Timer/Counter0 Output Compare Match A Interrupt Enable" mask="0x02" name="OCIE0A"/>
              <bitfield caption="Timer/Counter0 Overflow Interrupt Enable" mask="0x01" name="TOIE0"/>
            </register>
            <register caption="Timer/Counter0 Interrupt Flag register" name="TIFR0" offset="0x35" size="1" ocd-rw="R">
              <bitfield caption="Timer/Counter0 Output Compare Flag 0B" mask="0x04" name="OCF0B"/>
              <bitfield caption="Timer/Counter0 Output Compare Flag 0A" mask="0x02" name="OCF0A"/>
              <bitfield caption="Timer/Counter0 Overflow Flag" mask="0x01" name="TOV0"/>
            </register>
            <register caption="General Timer/Counter Control Register" name="GTCCR" offset="0x43" size="1">
              <bitfield caption="Timer/Counter Synchronization Mode" mask="0x80" name="TSM"/>
              <bitfield caption="Prescaler Reset Timer/Counter1 and Timer/Counter0" mask="0x01" name="PSRSYNC"/>
            </register>
          </register-group>
          <value-group name="CLK_SEL_3BIT_EXT">
            <value caption="No Clock Source (Stopped)" name="NO_CLOCK_SOURCE_STOPPED" value="0x00"/>
            <value caption="Running, No Prescaling" name="RUNNING_NO_PRESCALING" value="0x01"/>
            <value caption="Running, CLK/8" name="RUNNING_CLK_8" value="0x02"/>
            <value caption="Running, CLK/64" name="RUNNING_CLK_64" value="0x03"/>
            <value caption="Running, CLK/256" name="RUNNING_CLK_256" value="0x04"/>
            <value caption="Running, CLK/1024" name="RUNNING_CLK_1024" value="0x05"/>
            <value caption="Running, ExtClk Tn Falling Edge" name="RUNNING_EXTCLK_TN_FALLING_EDGE" value="0x06"/>
            <value caption="Running, ExtClk Tn Rising Edge" name="RUNNING_EXTCLK_TN_RISING_EDGE" value="0x07"/>
          </value-group>
        </module>
        <module caption="External Interrupts" name="EXINT">
          <register-group caption="External Interrupts" name="EXINT">
            <register caption="External Interrupt Control Register" name="EICRA" offset="0x69" size="1">
              <bitfield caption="External Interrupt Sense Control 1 Bits" mask="0x0C" name="ISC1" values="INTERRUPT_SENSE_CONTROL"/>
              <bitfield caption="External Interrupt Sense Control 0 Bits" mask="0x03" name="ISC0" values="INTERRUPT_SENSE_CONTROL"/>
            </register>
            <register caption="External Interrupt Mask Register" name="EIMSK" offset="0x3D" size="1">
              <bitfield caption="External Interrupt Request 1 Enable" mask="0x03" name="INT"/>
            </register>
            <register caption="External Interrupt Flag Register" name="EIFR" offset="0x3C" size="1" ocd-rw="R">
              <bitfield caption="External Interrupt Flags" mask="0x03" name="INTF"/>
            </register>
            <register caption="Pin Change Interrupt Control Register" name="PCICR" offset="0x68" size="1">
              <bitfield caption="Pin Change Interrupt Enables" mask="0x07" name="PCIE"/>
            </register>
            <register caption="Pin Change Mask Register 2" name="PCMSK2" offset="0x6D" size="1">
              <bitfield caption="Pin Change Enable Masks" mask="0xFF" name="PCINT" lsb="16"/>
            </register>
            <register caption="Pin Change Mask Register 1" name="PCMSK1" offset="0x6C" size="1">
              <bitfield caption="Pin Change Enable Masks" mask="0x7F" name="PCINT" lsb="8"/>
            </register>
            <register caption="Pin Change Mask Register 0" name="PCMSK0" offset="0x6B" size="1">
              <bitfield caption="Pin Change Enable Masks" mask="0xFF" name="PCINT"/>
            </register>
            <register caption="Pin Change Interrupt Flag Register" name="PCIFR" offset="0x3B" size="1" ocd-rw="R">
              <bitfield caption="Pin Change Interrupt Flags" mask="0x07" name="PCIF"/>
            </register>
          </register-group>
          <value-group caption="Interrupt Sense Control" name="INTERRUPT_SENSE_CONTROL">
            <value caption="Low Level of INTX" name="LOW_LEVEL_OF_INTX" value="0x00"/>
            <value caption="Any Logical Change of INTX" name="ANY_LOGICAL_CHANGE_OF_INTX" value="0x01"/>
            <value caption="Falling Edge of INTX" name="FALLING_EDGE_OF_INTX" value="0x02"/>
            <value caption="Rising Edge of INTX" name="RISING_EDGE_OF_INTX" value="0x03"/>
          </value-group>
        </module>
        <module caption="Serial Peripheral Interface" name="SPI">
          <register-group caption="Serial Peripheral Interface" name="SPI">
            <register caption="SPI Data Register" name="SPDR" offset="0x4E" size="1" mask="0xFF" ocd-rw=""/>
            <register caption="SPI Status Register" name="SPSR" offset="0x4D" size="1" ocd-rw="R">
              <bitfield caption="SPI Interrupt Flag" mask="0x80" name="SPIF"/>
              <bitfield caption="Write Collision Flag" mask="0x40" name="WCOL"/>
              <bitfield caption="Double SPI Speed Bit" mask="0x01" name="SPI2X"/>
            </register>
            <register caption="SPI Control Register" name="SPCR" offset="0x4C" size="1">
              <bitfield caption="SPI Interrupt Enable" mask="0x80" name="SPIE"/>
              <bitfield caption="SPI Enable" mask="0x40" name="SPE"/>
              <bitfield caption="Data Order" mask="0x20" name="DORD"/>
              <bitfield caption="Master/Slave Select" mask="0x10" name="MSTR"/>
              <bitfield caption="Clock polarity" mask="0x08" name="CPOL"/>
              <bitfield caption="Clock Phase" mask="0x04" name="CPHA"/>
              <bitfield caption="SPI Clock Rate Selects" mask="0x03" name="SPR" values="COMM_SCK_RATE_3BIT"/>
            </register>
          </register-group>
          <value-group name="COMM_SCK_RATE_3BIT">
            <value caption="fosc/2 or fosc/4" name="FOSC_2_OR_FOSC_4" value="0x00"/>
            <value caption="fosc/8 or fosc/16" name="FOSC_8_OR_FOSC_16" value="0x01"/>
            <value caption="fosc/32 or fosc/64" name="FOSC_32_OR_FOSC_64" value="0x02"/>
            <value caption="fosc/64 or fosc/128" name="FOSC_64_OR_FOSC_128" value="0x03"/>
          </value-group>
        </module>
        <module caption="Watchdog Timer" name="WDT">
          <register-group caption="Watchdog Timer" name="WDT">
            <register caption="Watchdog Timer Control Register" name="WDTCSR" offset="0x60" size="1" ocd-rw="R">
              <bitfield caption="Watchdog Timeout Interrupt Flag" mask="0x80" name="WDIF"/>
              <bitfield caption="Watchdog Timeout Interrupt Enable" mask="0x40" name="WDIE"/>
              <bitfield caption="Watchdog Timer Prescaler Bits" mask="0x27" name="WDP" values="WDOG_TIMER_PRESCALE_4BITS"/>
              <bitfield caption="Watchdog Change Enable" mask="0x10" name="WDCE"/>
              <bitfield caption="Watch Dog Enable" mask="0x08" name="WDE"/>
            </register>
          </register-group>
          <value-group name="WDOG_TIMER_PRESCALE_4BITS">
            <value caption="Oscillator Cycles 2K" name="OSCILLATOR_CYCLES_2K" value="0x00"/>
            <value caption="Oscillator Cycles 4K" name="OSCILLATOR_CYCLES_4K" value="0x01"/>
            <value caption="Oscillator Cycles 8K" name="OSCILLATOR_CYCLES_8K" value="0x02"/>
            <value caption="Oscillator Cycles 16K" name="OSCILLATOR_CYCLES_16K" value="0x03"/>
            <value caption="Oscillator Cycles 32K" name="OSCILLATOR_CYCLES_32K" value="0x04"/>
            <value caption="Oscillator Cycles 64K" name="OSCILLATOR_CYCLES_64K" value="0x05"/>
            <value caption="Oscillator Cycles 128K" name="OSCILLATOR_CYCLES_128K" value="0x06"/>
            <value caption="Oscillator Cycles 256K" name="OSCILLATOR_CYCLES_256K" value="0x07"/>
            <value caption="Oscillator Cycles 512K" name="OSCILLATOR_CYCLES_512K" value="0x08"/>
            <value caption="Oscillator Cycles 1024K" name="OSCILLATOR_CYCLES_1024K" value="0x09"/>
          </value-group>
        </module>
        <module caption="CPU Registers" name="CPU">
          <register-group caption="CPU Registers" name="CPU">
            <register caption="Power Reduction Register" name="PRR" offset="0x64" size="1" ocd-rw="R">
              <bitfield caption="Power Reduction TWI" mask="0x80" name="PRTWI"/>
              <bitfield caption="Power Reduction Timer/Counter2" mask="0x40" name="PRTIM2"/>
              <bitfield caption="Power Reduction Timer/Counter0" mask="0x20" name="PRTIM0"/>
              <bitfield caption="Power Reduction Timer/Counter1" mask="0x08" name="PRTIM1"/>
              <bitfield caption="Power Reduction Serial Peripheral Interface" mask="0x04" name="PRSPI"/>
              <bitfield caption="Power Reduction USART" mask="0x02" name="PRUSART0"/>
              <bitfield caption="Power Reduction ADC" mask="0x01" name="PRADC"/>
            </register>
            <register caption="Oscillator Calibration Value" name="OSCCAL" offset="0x66" size="1" mask="0xFF" ocd-rw="R">
              <bitfield caption="Oscillator Calibration " mask="0xFF" name="OSCCAL"/>
            </register>
            <register caption="Clock Prescale Register" name="CLKPR" offset="0x61" size="1" ocd-rw="R">
              <bitfield caption="Clock Prescaler Change Enable" mask="0x80" name="CLKPCE"/>
              <bitfield caption="Clock Prescaler Select Bits" mask="0x0F" name="CLKPS" values="CPU_CLK_PRESCALE_4_BITS_SMALL"/>
            </register>
            <register caption="Status Register" name="SREG" offset="0x5F" size="1">
              <bitfield caption="Global Interrupt Enable" mask="0x80" name="I"/>
              <bitfield caption="Bit Copy Storage" mask="0x40" name="T"/>
              <bitfield caption="Half Carry Flag" mask="0x20" name="H"/>
              <bitfield caption="Sign Bit" mask="0x10" name="S"/>
              <bitfield caption="Two's Complement Overflow Flag" mask="0x08" name="V"/>
              <bitfield caption="Negative Flag" mask="0x04" name="N"/>
              <bitfield caption="Zero Flag" mask="0x02" name="Z"/>
              <bitfield caption="Carry Flag" mask="0x01" name="C"/>
            </register>
            <register caption="Stack Pointer " name="SP" offset="0x5D" size="2" mask="0x0FFF"/>
            <register caption="Store Program Memory Control and Status Register" name="SPMCSR" offset="0x57" size="1">
              <bitfield caption="SPM Interrupt Enable" mask="0x80" name="SPMIE"/>
              <bitfield caption="Read-While-Write Section Busy" mask="0x40" name="RWWSB"/>
              <bitfield caption="Signature Row Read" mask="0x20" name="SIGRD"/>
              <bitfield caption="Read-While-Write section read enable" mask="0x10" name="RWWSRE"/>
              <bitfield caption="Boot Lock Bit Set" mask="0x08" name="BLBSET"/>
              <bitfield caption="Page Write" mask="0x04" name="PGWRT"/>
              <bitfield caption="Page Erase" mask="0x02" name="PGERS"/>
              <bitfield caption="Store Program Memory" mask="0x01" name="SPMEN"/>
            </register>
            <register caption="MCU Control Register" name="MCUCR" offset="0x55" size="1">
              <bitfield caption="BOD Sleep" mask="0x40" name="BODS"/>
              <bitfield caption="BOD Sleep Enable" mask="0x20" name="BODSE"/>
              <bitfield mask="0x10" name="PUD"/>
              <bitfield mask="0x02" name="IVSEL"/>
              <bitfield mask="0x01" name="IVCE"/>
            </register>
            <register caption="MCU Status Register" name="MCUSR" offset="0x54" size="1">
              <bitfield caption="Watchdog Reset Flag" mask="0x08" name="WDRF"/>
              <bitfield caption="Brown-out Reset Flag" mask="0x04" name="BORF"/>
              <bitfield caption="External Reset Flag" mask="0x02" name="EXTRF"/>
              <bitfield caption="Power-on reset flag" mask="0x01" name="PORF"/>
            </register>
            <register caption="Sleep Mode Control Register" name="SMCR" offset="0x53" size="1">
              <bitfield caption="Sleep Mode Select Bits" mask="0x0E" name="SM" values="CPU_SLEEP_MODE_3BITS2"/>
              <bitfield caption="Sleep Enable" mask="0x01" name="SE"/>
            </register>
            <register caption="General Purpose I/O Register 2" name="GPIOR2" offset="0x4B" size="1" mask="0xFF"/>
            <register caption="General Purpose I/O Register 1" name="GPIOR1" offset="0x4A" size="1" mask="0xFF"/>
            <register caption="General Purpose I/O Register 0" name="GPIOR0" offset="0x3E" size="1" mask="0xFF"/>
          </register-group>
          <value-group name="CPU_CLK_PRESCALE_4_BITS_SMALL">
            <value caption="1" name="1" value="0x00"/>
            <value caption="2" name="2" value="0x01"/>
            <value caption="4" name="4" value="0x02"/>
            <value caption="8" name="8" value="0x03"/>
            <value caption="16" name="16" value="0x04"/>
            <value caption="32" name="32" value="0x05"/>
            <value caption="64" name="64" value="0x06"/>
            <value caption="128" name="128" value="0x07"/>
            <value caption="256" name="256" value="0x08"/>
          </value-group>
          <value-group name="CPU_SLEEP_MODE_3BITS2">
            <value caption="Idle" name="IDLE" value="0x00"/>
            <value caption="ADC Noise Reduction (If Available)" name="ADC" value="0x01"/>
            <value caption="Power Down" name="PDOWN" value="0x02"/>
            <value caption="Power Save" name="PSAVE" value="0x03"/>
            <value caption="Reserved" name="VAL_0x04" value="0x04"/>
            <value caption="Reserved" name="VAL_0x05" value="0x05"/>
            <value caption="Standby" name="STDBY" value="0x06"/>
            <value caption="Extended Standby" name="ESTDBY" value="0x07"/>
          </value-group>
          <value-group caption="Oscillator Calibration Values" name="OSCCAL_VALUE_ADDRESSES">
            <value value="0x00" caption="8.0 MHz" name="8_0_MHz"/>
          </value-group>
        </module>
        <module caption="EEPROM" name="EEPROM">
          <register-group caption="EEPROM" name="EEPROM">
            <register caption="EEPROM Address Register  Bytes" name="EEAR" offset="0x41" size="2" mask="0x03FF"/>
            <register caption="EEPROM Data Register" name="EEDR" offset="0x40" size="1" mask="0xFF"/>
            <register caption="EEPROM Control Register" name="EECR" offset="0x3F" size="1">
              <bitfield caption="EEPROM Programming Mode Bits" mask="0x30" name="EEPM" values="EEP_MODE"/>
              <bitfield caption="EEPROM Ready Interrupt Enable" mask="0x08" name="EERIE"/>
              <bitfield caption="EEPROM Master Write Enable" mask="0x04" name="EEMPE"/>
              <bitfield caption="EEPROM Write Enable" mask="0x02" name="EEPE"/>
              <bitfield caption="EEPROM Read Enable" mask="0x01" name="EERE"/>
            </register>
          </register-group>
          <value-group name="EEP_MODE">
            <value caption="Erase and Write in one operation" name="ERASE_AND_WRITE_IN_ONE_OPERATION" value="0x00"/>
            <value caption="Erase Only" name="ERASE_ONLY" value="0x01"/>
            <value caption="Write Only" name="WRITE_ONLY" value="0x02"/>
          </value-group>
        </module>
      </modules>
      <pinouts>
        <pinout name="TQFP32" caption="TQFP32">
          <pin position="1" pad="PD3"/>
          <pin position="2" pad="PD4"/>
          <pin position="3" pad="GND"/>
          <pin position="4" pad="VCC"/>
          <pin position="5" pad="GND"/>
          <pin position="6" pad="VCC"/>
          <pin position="7" pad="PB6"/>
          <pin position="8" pad="PB7"/>
          <pin position="9" pad="PD5"/>
          <pin position="10" pad="PD6"/>
          <pin position="11" pad="PD7"/>
          <pin position="12" pad="PB0"/>
          <pin position="13" pad="PB1"/>
          <pin position="14" pad="PB2"/>
          <pin position="15" pad="PB3"/>
          <pin position="16" pad="PB4"/>
          <pin position="17" pad="PB5"/>
          <pin position="18" pad="AVCC"/>
          <pin position="19" pad="ADC6"/>
          <pin position="20" pad="AREF"/>
          <pin position="21" pad="GND"/>
          <pin position="22" pad="ADC7"/>
          <pin position="23" pad="PC0"/>
          <pin position="24" pad="PC1"/>
          <pin position="25" pad="PC2"/>
          <pin position="26" pad="PC3"/>
          <pin position="27" pad="PC4"/>
          <pin position="28" pad="PC5"/>
          <pin position="29" pad="PC6"/>
          <pin position="30" pad="PD0"/>
          <pin position="31" pad="PD1"/>
          <pin position="32" pad="PD2"/>
        </pinout>
        <pinout name="QFN32" caption="QFN32">
          <pin position="1" pad="PD3"/>
          <pin position="2" pad="PD4"/>
          <pin position="3" pad="GND"/>
          <pin position="4" pad="VCC"/>
          <pin position="5" pad="GND"/>
          <pin position="6" pad="VCC"/>
          <pin position="7" pad="PB6"/>
          <pin position="8" pad="PB7"/>
          <pin position="9" pad="PD5"/>
          <pin position="10" pad="PD6"/>
          <pin position="11" pad="PD7"/>
          <pin position="12" pad="PB0"/>
          <pin position="13" pad="PB1"/>
          <pin position="14" pad="PB2"/>
          <pin position="15" pad="PB3"/>
          <pin position="16" pad="PB4"/>
          <pin position="17" pad="PB5"/>
          <pin position="18" pad="AVCC"/>
          <pin position="19" pad="ADC6"/>
          <pin position="20" pad="AREF"/>
          <pin position="21" pad="GND"/>
          <pin position="22" pad="ADC7"/>
          <pin position="23" pad="PC0"/>
          <pin position="24" pad="PC1"/>
          <pin position="25" pad="PC2"/>
          <pin position="26" pad="PC3"/>
          <pin position="27" pad="PC4"/>
          <pin position="28" pad="PC5"/>
          <pin position="29" pad="PC6"/>
          <pin position="30" pad="PD0"/>
          <pin position="31" pad="PD1"/>
          <pin position="32" pad="PD2"/>
        </pinout>
        <pinout name="QFN28" caption="QFN28">
          <pin position="1" pad="PD3"/>
          <pin position="2" pad="PD4"/>
          <pin position="3" pad="VCC"/>
          <pin position="4" pad="GND"/>
          <pin position="5" pad="PB6"/>
          <pin position="6" pad="PB7"/>
          <pin position="7" pad="PD5"/>
          <pin position="8" pad="PD6"/>
          <pin position="9" pad="PD7"/>
          <pin position="10" pad="PB0"/>
          <pin position="11" pad="PB1"/>
          <pin position="12" pad="PB2"/>
          <pin position="13" pad="PB3"/>
          <pin position="14" pad="PB4"/>
          <pin position="15" pad="PB5"/>
          <pin position="16" pad="AVCC"/>
          <pin position="17" pad="AREF"/>
          <pin position="18" pad="GND"/>
          <pin position="19" pad="PC0"/>
          <pin position="20" pad="PC1"/>
          <pin position="21" pad="PC2"/>
          <pin position="22" pad="PC3"/>
          <pin position="23" pad="PC4"/>
          <pin position="24" pad="PC5"/>
          <pin position="25" pad="PC6"/>
          <pin position="26" pad="PD0"/>
          <pin position="27" pad="PD1"/>
          <pin position="28" pad="PD2"/>
        </pinout>
        <pinout name="PDIP28" caption="PDIP28">
          <pin position="1" pad="PC6"/>
          <pin position="2" pad="PD0"/>
          <pin position="3" pad="PD1"/>
          <pin position="4" pad="PD2"/>
          <pin position="5" pad="PD3"/>
          <pin position="6" pad="PD4"/>
          <pin position="7" pad="VCC"/>
          <pin position="8" pad="GND"/>
          <pin position="9" pad="PB6"/>
          <pin position="10" pad="PB7"/>
          <pin position="11" pad="PD5"/>
          <pin position="12" pad="PD6"/>
          <pin position="13" pad="PD7"/>
          <pin position="14" pad="PB0"/>
          <pin position="15" pad="PB1"/>
          <pin position="16" pad="PB2"/>
          <pin position="17" pad="PB3"/>
          <pin position="18" pad="PB4"/>
          <pin position="19" pad="PB5"/>
          <pin position="20" pad="AVCC"/>
          <pin position="21" pad="AREF"/>
          <pin position="22" pad="GND"/>
          <pin position="23" pad="PC0"/>
          <pin position="24" pad="PC1"/>
          <pin position="25" pad="PC2"/>
          <pin position="26" pad="PC3"/>
          <pin position="27" pad="PC4"/>
          <pin position="28" pad="PC5"/>
        </pinout>
      </pinouts>
    </avr-tools-device-file>
    """
    
    struct AVTToolsDeviceFile: Codable {
        let variants: Variants
        let devices: Devices
        let modules: Modules
        let pinouts: Pinouts
        
        struct Variants: Codable {
            let variant: [Variant]
            
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
                            let signals: Signals?
                            
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
                @Attribute var caption: String
                @Attribute var name: String
                let registerGroup: RegisterGroup
                let valueGroup: [ValueGroup]

                enum CodingKeys: String, CodingKey {
                    case name
                    case caption
                    case registerGroup = "register-group"
                    case valueGroup = "value-group"
                }

                struct RegisterGroup: Codable {
                    @Attribute var name: String
                    @Attribute var caption: String
                    let register: [Register]

                    struct Register: Codable {
                        @Attribute var name: String
                        @Attribute var offset: String
                        @Attribute var size: String
                        @Attribute var initval: String?
                        let bitfield: [Bitfield]

                        struct Bitfield: Codable {
                            @Attribute var caption: String?
                            @Attribute var mask: String
                            @Attribute var name: String
                            @Attribute var values: String?
                        }
                    }
                }
                
                struct ValueGroup: Codable {
                    @Attribute var name: String
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
                @Attribute var caption: String
                let pin: [Pin]
                
                struct Pin:Codable {
                    @Attribute var position: String
                    @Attribute var pad: String
                }
            }
        }
    }
    
    let ATDFObject = try! XMLDecoder().decode(AVTToolsDeviceFile.self, from: Data(sourceXML.utf8))
    let encodedXML = try! XMLEncoder().encode(ATDFObject, withRootKey: "avr-tools-device-file")
    print(String(data: encodedXML, encoding: .utf8)!)
}
