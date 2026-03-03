//
//  GenerationApi.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 02/03/2026.
//

import XMLCoder
import Foundation

struct GeneratedCodeFile {
    let fileName: String
    let content: String
    let subdirectory: String
}

struct GeneratedAVRCore {
    let name: String
    let files: [GeneratedCodeFile]
}

var logs = Logs(chips: [])

struct Logs: Codable {
    var chips: [Chip]

    struct Chip: Codable {
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
        exportFile(toURL: toURL, fileName: "logs.json", fileContents: jsonString)
        print("Saved pretty-printed logs.json")
    }
}

func decodeATDF(urls: [URL], docURL: URL) -> [GeneratedAVRCore] {
    var generatedAVRCores: [GeneratedAVRCore] = []
    let documentation = ChipDocumentationLoader()
    documentation.directory = docURL
    let pipeline = GenerationPipeline()
    var generatedFiles: [GeneratedCodeFile]
    var data: Data
    var ATDFObject: AVRToolsDeviceFile
    for url in urls {
        do {
            data = try Data(contentsOf: url)
            ATDFObject = try! XMLDecoder().decode(AVRToolsDeviceFile.self, from: data)
            generatedFiles = pipeline.run(device: ATDFObject, documentation: documentation)
            generatedAVRCores.append(GeneratedAVRCore(name: ATDFObject.devices.device.name, files: generatedFiles))
        } catch {
            print("Could not get data from ATDF file URL: \(url.lastPathComponent)")
        }
    }
    return generatedAVRCores
}

func exportAll(fromURLs: [URL], toURL: URL, docURL: URL) {
    let generatedCores = decodeATDF(urls: fromURLs, docURL: docURL)
    for core in generatedCores {
        let subFolderURL = toURL.appendingPathComponent(core.name, isDirectory: true)
        for file in core.files {
            let folder = subFolderURL.appendingPathComponent(file.subdirectory, isDirectory: true)
            exportFile(toURL: folder, fileName: file.fileName, fileContents: file.content)
        }
    }
    logs.saveToFile(toURL: toURL)
}

func exportFile(toURL: URL, fileName: String, fileContents: String) {
    do {
        try FileManager.default.createDirectory(at: toURL, withIntermediateDirectories: true)
        let fileNameURL = toURL.appendingPathComponent(fileName, isDirectory: false)
        try fileContents.write(to: fileNameURL, atomically: true, encoding: .utf8)
    } catch {
        print("Export error (\(fileName)): \(error.localizedDescription)")
    }
}

var listOfValues: [String] = []

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
