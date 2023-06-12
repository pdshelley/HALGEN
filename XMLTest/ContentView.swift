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
    </modules>
        </avr-tools-device-file>
    """
    
    struct AVTToolsDeviceFile: Codable {
        let variants: Variants
        let devices: Devices
        let modules: Modules
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
                        @Attribute var initval: String
                        let bitfield: [Bitfield]

                        struct Bitfield: Codable {
                            @Attribute var caption: String
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
    }
    
    let ATDFObject = try! XMLDecoder().decode(AVTToolsDeviceFile.self, from: Data(sourceXML.utf8))
    let encodedXML = try! XMLEncoder().encode(ATDFObject, withRootKey: "avr-tools-device-file")
    print(String(data: encodedXML, encoding: .utf8)!)
}
