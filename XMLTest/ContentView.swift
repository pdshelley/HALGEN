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
          </variants>
      <devices>
        <device name="ATmega328P" architecture="AVR8" family="megaAVR">
    
          <address-spaces>
            
            <address-space endianness="little" name="prog" id="prog" start="0x0000" size="0x8000">
              <memory-segment start="0x0000" size="0x8000" type="flash" rw="RW" exec="1" name="FLASH" pagesize="0x80"/>
              <memory-segment start="0x7c00" size="0x0400" type="flash" rw="RW" exec="1" name="BOOT_SECTION_2" pagesize="0x80"/>
            </address-space>
    
            <address-space endianness="little" name="signatures" id="signatures" start="0" size="3">
              <memory-segment start="0" size="3" type="signatures" rw="R" exec="0" name="SIGNATURES"/>
            </address-space>
    
          </address-spaces>
    
          <peripherals>
          </peripherals>
    
          <interrupts>
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
            var device: [Device]
            
            struct Device: Codable {
                @Attribute var name: String
                @Attribute var architecture: String
                @Attribute var family: String
                let addressSpaces: AddressSpaces
                let peripherals: String
                let interrupts: String
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
                    var addressSpace: [AddressSpace]
                    
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
                            @Attribute var rw: String
                            @Attribute var exec: String
                            @Attribute var name: String
                            @Attribute var pagesize: String?
                        }
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
