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
//    @State var saveLocationURL: URL? = nil
    
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
                Text("Decode ATDF Files")
            }
            Button {
                printValues()
            } label: {
                Text("Display in Console")
            }
            Button {
                // Select Location:
                let panel = NSSavePanel()
                panel.allowedContentTypes = [.text]
                panel.canCreateDirectories = true
                panel.nameFieldLabel = "File Name:"
                if panel.runModal() == .OK {
                    guard let url = panel.url else { return }
                    export(fromURLs: self.urls, toURL: url)
                }
            } label: {
                Text("Export")
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


func decodeATDF(urls: [URL]) -> [GeneratedAVRCore] {
    var generatedAVRCores: [GeneratedAVRCore] = []
    
    for url in urls {
        do {
            let data = try Data(contentsOf: url)
            generatedAVRCores.append(decodeATDF(data: data))
        } catch {
            print("Could not get data from ATDF file URL.")
        }
    }
    
    return generatedAVRCores
}

var listOfValues: [String] = []

func export(fromURLs: [URL], toURL: URL) {
    // Load ATDF Files
    let generatedCores = decodeATDF(urls: fromURLs)
    
    // Save GPIO.swift
    for core in generatedCores {
        let subFolderURL = toURL.appendingPathComponent(core.name, conformingTo: .directory)
        for file in core.files {
            export(toURL: subFolderURL, fileName: file.fileName, fileContents: file.content)
        }
    }
}

func export(toURL: URL, fileName: String, fileContents: String) {
    do {
        try FileManager.default.createDirectory(at: toURL, withIntermediateDirectories: true)
        
        do {
            let fileNameURL = toURL.appendingPathComponent(fileName, conformingTo: .text)
            try fileContents.write(to: fileNameURL, atomically: true, encoding: .utf8)
            
        } catch {
            // TODO: Show error in GUI.
            print("Write File Error: \(error.localizedDescription)")
        }
        
    } catch {
        // TODO: Show error in GUI.
        print("Create Directory Error: \(error)")
    }
}

func printValues() {
    let uniqueNames = listOfValues.unique()
    print()
    for name in uniqueNames {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        let enumValue = name.filter {okayChars.contains($0) }
        print("case \(enumValue) = \"\(name)\"")
    }
}

struct GeneratedCodeFile {
    let fileName: String
    let content: String
}

struct GeneratedAVRCore {
    let name: String
    let files: [GeneratedCodeFile]
}

func decodeATDF(data: Data) -> GeneratedAVRCore {
    
    let ATDFObject = try! XMLDecoder().decode(AVRToolsDeviceFile.self, from: data)
    let deviceName = ATDFObject.devices.device.name
    var generatedFiles: [GeneratedCodeFile] = []
    generatedFiles.append(buildGPIO(file: ATDFObject))
    
    print("ATDFObject.devices.device.name = \(deviceName)")
    print()
    print(buildGPIO(file: ATDFObject).content)
    
    return GeneratedAVRCore(name: deviceName, files: generatedFiles)
    
    
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
