//
//  GenerationApi.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 02/03/2026.
//

import Foundation
import Dispatch
import XMLCoder

struct GeneratedCodeFile {
    let fileName: String
    let content: String
    let subdirectory: String
}

struct GeneratedAVRCore {
    let name: String
    let files: [GeneratedCodeFile]
}

private struct GeneratedFileJob {
    let chipName: String
    let file: GeneratedCodeFile
}

private struct FormattedGeneratedFile {
    let chipName: String
    let fileName: String
    let subdirectory: String
    let content: String
    let diagnostics: [FormattingDiagnostic]
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

/// Decodes ATDF (Atmel Device File) XML files and generates Swift code for AVR microcontroller hardware registers and bitfields.
///
/// - Parameters:
///   - urls: An array of URLs pointing to ATDF XML files containing device register and bitfield definitions.
///   - docURL: A URL pointing to chip documentation files that provide additional metadata such as variable names,
///     access permissions, and documentation text for registers and bitfields.
///
/// - Returns: A dictionary mapping chip names to their generated Swift code modules, including register definitions,
///   bitfield accessors, and hardware peripheral configurations.
///
/// - Note: This function is responsible for parsing the ATDF format, extracting register and bitfield information,
///   and generating Swift code that provides type-safe access to AVR microcontroller hardware registers.
///   The generated code includes documentation comments derived from the chip documentation files.
func decodeATDF(urls: [URL], docURL: URL) -> [GeneratedAVRCore] {
    let pipeline = GenerationPipeline()
    let resultsLock = NSLock()
    var generatedAVRCores = Array<GeneratedAVRCore?>(repeating: nil, count: urls.count)

    DispatchQueue.concurrentPerform(iterations: urls.count) { index in
        let url = urls[index]

        do {
            let documentation = ChipDocumentationLoader()
            documentation.directory = docURL

            let data = try Data(contentsOf: url)
            let atdfObject = try XMLDecoder().decode(AVRToolsDeviceFile.self, from: data)
            let generatedFiles = pipeline.run(device: atdfObject, documentation: documentation)
            let generatedCore = GeneratedAVRCore(name: atdfObject.devices.device.name, files: generatedFiles)

            resultsLock.lock()
            generatedAVRCores[index] = generatedCore
            resultsLock.unlock()
        } catch {
            print("Could not generate from ATDF file URL: \(url.lastPathComponent) (\(error.localizedDescription))")
            print(error)
        }
    }

    return generatedAVRCores.compactMap { $0 }
}

/// Exports generated AVR microcontroller code files to the specified destination directory.
///
/// This function orchestrates the complete workflow of decoding ATDF XML files, generating
/// Swift code modules for each chip, and exporting all generated files to disk along with
/// a logs.json file for tracking.
///
/// - Parameters:
///   - fromURLs: An array of URLs pointing to ATDF XML files containing device register
///     and bitfield definitions for AVR microcontrollers.
///   - toURL: A URL pointing to the destination directory where generated files will be
///     exported. Subdirectories will be created for each chip name.
///   - docURL: A URL pointing to chip documentation files that provide additional metadata
///     such as variable names, access permissions, and documentation text for registers
///     and bitfields.
///
/// - Note: This function creates a directory structure where each chip gets its own
///   subdirectory, and within each subdirectory, files are organized according to their
///   designated subdirectory paths from the generation pipeline. After all files are
///   exported, a logs.json file containing chip operation logs is saved to the destination
///   directory.
///
/// - SeeAlso: `decodeATDF(urls:docURL:)` - Decodes ATDF files and generates Swift code modules.
/// - SeeAlso: `exportFile(toURL:fileName:fileContents:)` - Writes individual file contents to disk.
func exportAll(fromURLs: [URL], toURL: URL, docURL: URL) {
    let generatedCores = decodeATDF(urls: fromURLs, docURL: docURL)
    let generatedFiles = generatedCores.flatMap { core in
        core.files.map { GeneratedFileJob(chipName: core.name, file: $0) }
    }

    let resultsLock = NSLock()
    var formattedFiles = Array<FormattedGeneratedFile?>(repeating: nil, count: generatedFiles.count)

    DispatchQueue.concurrentPerform(iterations: generatedFiles.count) { index in
        let generatedFile = generatedFiles[index]
        let formatter = CodeFormatter()
        let result = formatter.format(source: generatedFile.file.content)

        let formattedFile = FormattedGeneratedFile(
            chipName: generatedFile.chipName,
            fileName: generatedFile.file.fileName,
            subdirectory: generatedFile.file.subdirectory,
            content: result.content,
            diagnostics: result.diagnostics
        )

        resultsLock.lock()
        formattedFiles[index] = formattedFile
        resultsLock.unlock()
    }

    var report = FormattingReport()

    for formattedFile in formattedFiles.compactMap({ $0 }) {
        report.add(
            chipName: formattedFile.chipName,
            fileName: formattedFile.fileName,
            diagnostics: formattedFile.diagnostics
        )

        let folder = toURL
            .appendingPathComponent(formattedFile.chipName, isDirectory: true)
            .appendingPathComponent(formattedFile.subdirectory, isDirectory: true)
        exportFile(toURL: folder, fileName: formattedFile.fileName, fileContents: formattedFile.content)
    }

    logs.saveToFile(toURL: toURL)
    report.save(to: toURL)
}

/// Exports a file with the specified contents to the given directory URL.
///
/// Creates the directory structure if it doesn't exist, then writes the file
/// contents atomically to the destination. If an error occurs during the
/// export process, an error message is printed to the console.
///
/// - Parameters:
///   - toURL: A URL pointing to the directory where the file will be saved.
///     The directory will be created if it does not already exist.
///   - fileName: The name of the file to create (without path information).
///   - fileContents: The string content to write to the file.
///
/// - Note: This function performs error handling by printing error messages
///   to the console rather than throwing errors. The directory creation uses
///   intermediate directories, allowing nested paths to be created automatically.
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
