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
    @State var docDir: URL? = nil
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
//            Button {
//                decodeATDF(urls: urls, docURL: docDir!)
//            } label: {
//                Text("Decode ATDF Files")
//            }
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
                    export(fromURLs: self.urls, toURL: url, docURL: docDir!)
                }
            } label: {
                Text("Export")
            }
            Button("doc dir") {
               let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = true
                if panel.runModal() == .OK {
                    self.docDir = panel.url
                }
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


func decodeATDF(urls: [URL], docURL: URL) -> [GeneratedAVRCore] {
    var generatedAVRCores: [GeneratedAVRCore] = []
    
    for url in urls {
        do {
            let data = try Data(contentsOf: url)
            generatedAVRCores.append(decodeATDF(data: data, docURL: docURL))
        } catch {
            print("Could not get data from ATDF file URL.")
        }
    }
    
    return generatedAVRCores
}

var listOfValues: [String] = []

// Does all of the decoding - Maybe it should not?
// Creates Sub Folder for Chip and saves all the data to files in this folder.
func export(fromURLs: [URL], toURL: URL, docURL: URL) {
    // Load ATDF Files
    let generatedCores = decodeATDF(urls: fromURLs, docURL: docURL)
    
    for core in generatedCores {
        let subFolderURL = toURL.appendingPathComponent(core.name, conformingTo: .directory)
        for file in core.files {
            let folder = subFolderURL.appendingPathComponent(file.subdirectory, conformingTo: .directory)
            export(toURL: folder, fileName: file.fileName, fileContents: file.content)
        }
    }
    
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
    let subdirectory: String
}

struct GeneratedAVRCore {
    let name: String
    let files: [GeneratedCodeFile]
}

func decodeATDF(data: Data, docURL: URL) -> GeneratedAVRCore {
    
    let documentation = ChipDocumentationLoader()
    documentation.directory = docURL
    let ATDFObject = try! XMLDecoder().decode(AVRToolsDeviceFile.self, from: data)
    print("************************************************** \(ATDFObject.devices.device.name) **************************************************")
    let deviceName = ATDFObject.devices.device.name
    //var generatedFiles: [GeneratedCodeFile] = []
    let pipeline = GenerationPipeline()
    var generatedFiles: [GeneratedCodeFile] = pipeline.run(device: ATDFObject, documentation: documentation)

    return GeneratedAVRCore(name: deviceName, files: generatedFiles)
}




extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
