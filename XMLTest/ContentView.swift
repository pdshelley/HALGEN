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
    print()
    for name in uniqueNames {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        let enumValue = name.filter {okayChars.contains($0) }
        print("case \(enumValue) = \"\(name)\"")
    }
}

func decodeATDF(data: Data) {
    
    let ATDFObject = try! XMLDecoder().decode(AVRToolsDeviceFile.self, from: data)

    
    print("ATDFObject.devices.device.name = \(ATDFObject.devices.device.name)")
    print()
    print(buildGPIO(file: ATDFObject))
    
//    for module in ATDFObject.devices.device.peripherals.module {
//        if module.name == .port {
//            for instance in module.instance {
//                guard let signals = instance.signals else { break }
//                print()
//                for signal in signals.signal {
//                    print(signal.pad)
//                }
//            }
//        }
//    }
    
//    listOfValues.append(ATDFObject.devices.device.family.rawValue)
    
//    if let pinouts = ATDFObject.pinouts {
//    for module in ATDFObject.devices.device.peripherals.module {
////        if module.name == .port {
//            print("ATDFObject.devices.device.name = \(ATDFObject.devices.device.name)")
//            for instance in module.instance {
////                guard let registerGroup = instance.registerGroup else { break }
//
////                listOfValues.append(registerGroup.offset.rawValue)
//                guard let signals = instance.signals else { break }
//                for signal in signals.signal {
//                    listOfValues.append(signal.function.rawValue)
//                }
//            }
////        }
////        for pin in module {
////                listOfValues.append(pin.pad.rawValue)
////            }
//        }
//    }
}




extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
