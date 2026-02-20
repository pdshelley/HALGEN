//
//  ContentView.swift
//  SwiftAVRGenerator
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
//                    DispatchQueue.global().async() {
//                        export(fromURLs: self.urls, toURL: url)
//                    }
                    // Singlethreaded
                    //export(fromURLs: self.urls, toURL: url)
                    //await parallelExport(fromURLs: self.urls, toURL: url)
                    // Multithreaded
                    Task {
                        await parallelExport(fromURLs: self.urls, toURL: url)
                    }
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

func parallelDecodeATDF(urls: [URL]) async -> [GeneratedAVRCore] {
//    var generatedAVRCores: [GeneratedAVRCore] = []
//    
//    for url in urls {
//        do {
//            let data = try Data(contentsOf: url)
//            generatedAVRCores.append(decodeATDF(data: data))
//        } catch {
//            print("Could not get data from ATDF file URL.")
//        }
//    }
//    
//    return generatedAVRCores
    return await withTaskGroup(of: GeneratedAVRCore?.self) { group in
        var generatedAVRCores: [GeneratedAVRCore] = []
        
        for url in urls {
            group.addTask {
                do {
                    let data = try Data(contentsOf: url)
                    return decodeATDF(data: data)
                } catch {
                    return nil
                }
            }
        }
        
        for await core in group {
            if let core = core {
                generatedAVRCores.append(core)
            }
        }
        return generatedAVRCores
    }
}

func parallelExport(fromURLs: [URL], toURL: URL) async {
    // Load ATDF Files
    let generatedCores = await parallelDecodeATDF(urls: fromURLs)
    
    // New
    for core in generatedCores {
        let subFolderURL = toURL.appendingPathComponent(core.name, conformingTo: .directory)
        let moduleFolderURL = subFolderURL.appendingPathComponent("module", conformingTo: .directory)
        let timerFolderUrl = moduleFolderURL.appendingPathComponent("Timer", conformingTo: .directory)
        let uartFolderUrl = moduleFolderURL.appendingPathComponent("UART", conformingTo: .directory)
        //print(uartFolderUrl.lastPathComponent)
        for file in core.files {
            //export(toURL: subFolderURL, fileName: file.fileName, fileContents: file.content)
            if file.fileName.contains(timerFolderUrl.lastPathComponent) {
                export(toURL: timerFolderUrl, fileName: file.fileName, fileContents: file.content)
            } else if file.fileName.contains(uartFolderUrl.lastPathComponent) {
                export(toURL: uartFolderUrl, fileName: file.fileName, fileContents: file.content)
            } else {
                export(toURL: moduleFolderURL, fileName: file.fileName, fileContents: file.content)
            }
            
        }
    }
    
    // Old
//    for core in generatedCores {
//        let subFolderURL = toURL.appendingPathComponent(core.name, conformingTo: .directory)
//        for file in core.files {
//            export(toURL: subFolderURL, fileName: file.fileName, fileContents: file.content)
//        }
//    }
    
    logs.saveToFile(toURL: toURL)
}

var listOfValues: [String] = []

// Does all of the decoding - Maybe it should not?
// Creates Sub Folder for Chip and saves all the data to files in this folder.
func export(fromURLs: [URL], toURL: URL) {
    // Load ATDF Files
    let generatedCores = decodeATDF(urls: fromURLs)
    
    // New
    for core in generatedCores {
        let subFolderURL = toURL.appendingPathComponent(core.name, conformingTo: .directory)
        let moduleFolderURL = subFolderURL.appendingPathComponent("module", conformingTo: .directory)
        let timerFolderUrl = moduleFolderURL.appendingPathComponent("Timer", conformingTo: .directory)
        let uartFolderUrl = moduleFolderURL.appendingPathComponent("UART", conformingTo: .directory)
        //print(uartFolderUrl.lastPathComponent)
        for file in core.files {
            //export(toURL: subFolderURL, fileName: file.fileName, fileContents: file.content)
            if file.fileName.contains(timerFolderUrl.lastPathComponent) {
                export(toURL: timerFolderUrl, fileName: file.fileName, fileContents: file.content)
            } else if file.fileName.contains(uartFolderUrl.lastPathComponent) {
                export(toURL: uartFolderUrl, fileName: file.fileName, fileContents: file.content)
            } else {
                export(toURL: moduleFolderURL, fileName: file.fileName, fileContents: file.content)
            }
            
        }
    }
    
    // Old
//    for core in generatedCores {
//        let subFolderURL = toURL.appendingPathComponent(core.name, conformingTo: .directory)
//        for file in core.files {
//            export(toURL: subFolderURL, fileName: file.fileName, fileContents: file.content)
//        }
//    }
    
    logs.saveToFile(toURL: toURL)
}

// The actual saving of data to each file.
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

var logs = Logs(chips: [])

struct Logs: Codable {
    var chips: [Chip]
    
    struct  Chip: Codable {
        let name: String
        var logs: [String]
    }
    
    mutating func addLog(_ text: String, toChip name: String) {
        if let index = chips.firstIndex(where: { $0.name == name }) {
            chips[index].logs.append(text)
        } else {
            chips.append(Chip(name: name, logs: [text]))
        }
    }
    
    func saveToFile(toURL: URL) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try! encoder.encode(logs)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        export(toURL: toURL, fileName: "logs.json", fileContents: jsonString)
        print("Saved pretty-printed logs.json")
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
    print("************************************************** \(ATDFObject.devices.device.name) **************************************************")
    let deviceName = ATDFObject.devices.device.name
    var generatedFiles: [GeneratedCodeFile] = []
    generatedFiles.append(buildGPIO(file: ATDFObject))
    for file in buildTimers(file: ATDFObject) {
        generatedFiles.append(file)
    }
    //generatedFiles.append(buildUART(file: ATDFObject))
    
    for uartFile in buildUARTs(file: ATDFObject) {
        generatedFiles.append(uartFile)
    }
    
//    print("ATDFObject.devices.device.name = \(deviceName)")
//    print()
//    print(buildGPIO(file: ATDFObject).content)
    
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
