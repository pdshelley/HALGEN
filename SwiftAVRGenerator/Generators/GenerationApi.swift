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
    let log: ChipGenerationLog

    var shouldExport: Bool {
        log.exported
    }
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

struct Logs: Codable {
    let exportedChipCount: Int
    let skippedChipCount: Int
    let chips: [ChipGenerationLog]

    enum CodingKeys: String, CodingKey {
        case exportedChipCount
        case skippedChipCount
        case chips
    }

    init(chips: [ChipGenerationLog]) {
        self.chips = chips
        self.exportedChipCount = chips.filter(\.exported).count
        self.skippedChipCount = chips.count - exportedChipCount
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(exportedChipCount, forKey: .exportedChipCount)
        try container.encode(skippedChipCount, forKey: .skippedChipCount)
        try container.encode(chips, forKey: .chips)
    }

    func saveToFile(toURL: URL) {
        do {
            let jsonString = try prettyPrintedJSONString()

            exportFile(toURL: toURL, fileName: "logs.json", fileContents: jsonString)
            print("Saved pretty-printed logs.json")
        } catch {
            print("Could not save logs.json (\(error.localizedDescription))")
        }
    }

    private func prettyPrintedJSONString() throws -> String {
        let chipLines = try chips.enumerated().map { index, chip in
            let suffix = index == chips.index(before: chips.endIndex) ? "" : ","
            return try chip.prettyPrintedJSONString(indentation: "    ") + suffix
        }

        let chipsBody = chipLines.isEmpty ? "" : "\n" + chipLines.joined(separator: "\n") + "\n"

        return """
        {
          \"exportedChipCount\" : \(exportedChipCount),
          \"skippedChipCount\" : \(skippedChipCount),
          \"chips\" : [\(chipsBody)  ]
        }
        """
    }
}

private extension ChipGenerationLog {
    func prettyPrintedJSONString(indentation: String) throws -> String {
        let peripheralLines = try peripherals.enumerated().map { index, peripheral in
            let suffix = index == peripherals.index(before: peripherals.endIndex) ? "" : ","
            return try peripheral.prettyPrintedJSONString(indentation: indentation + "    ") + suffix
        }

        let peripheralsBody = peripheralLines.isEmpty ? "" : "\n" + peripheralLines.joined(separator: "\n") + "\n" + indentation + "  "

        return """
        \(indentation){
        \(indentation)  \"name\" : \(try jsonStringLiteral(name)),
        \(indentation)  \"exported\" : \(exported ? "true" : "false"),
        \(indentation)  \"peripherals\" : [\(peripheralsBody)]
        \(indentation)}
        """
    }
}

private extension PeripheralGenerationLog {
    func prettyPrintedJSONString(indentation: String) throws -> String {
        let registerLines = try missingRegisters.enumerated().map { index, register in
            let suffix = index == missingRegisters.index(before: missingRegisters.endIndex) ? "" : ","
            return try register.prettyPrintedJSONString(indentation: indentation + "    ") + suffix
        }
        let bitfieldLines = try missingBitfields.enumerated().map { index, bitfield in
            let suffix = index == missingBitfields.index(before: missingBitfields.endIndex) ? "" : ","
            return try bitfield.prettyPrintedJSONString(indentation: indentation + "    ") + suffix
        }

        let registersBody = registerLines.isEmpty ? "" : "\n" + registerLines.joined(separator: "\n") + "\n" + indentation + "  "
        let bitfieldsBody = bitfieldLines.isEmpty ? "" : "\n" + bitfieldLines.joined(separator: "\n") + "\n" + indentation + "  "

        return """
        \(indentation){
        \(indentation)  \"name\" : \(try jsonStringLiteral(name)),
        \(indentation)  \"missingRegisters\" : [\(registersBody)],
        \(indentation)  \"missingBitfields\" : [\(bitfieldsBody)]
        \(indentation)}
        """
    }
}

private extension MissingRegisterLog {
    func prettyPrintedJSONString(indentation: String) throws -> String {
        """
        \(indentation){
        \(indentation)  \"name\" : \(try jsonStringLiteral(name)),
        \(indentation)  \"caption\" : \(try jsonStringLiteral(caption)),
        \(indentation)  \"offset\" : \(try jsonStringLiteral(offset)),
        \(indentation)  \"suggestedVariableName\" : \(try jsonStringLiteral(suggestedVariableName))
        \(indentation)}
        """
    }
}

private extension MissingBitfieldLog {
    func prettyPrintedJSONString(indentation: String) throws -> String {
        """
        \(indentation){
        \(indentation)  \"name\" : \(try jsonStringLiteral(name)),
        \(indentation)  \"caption\" : \(try jsonStringLiteral(caption)),
        \(indentation)  \"mask\" : \(try jsonStringLiteral(mask)),
        \(indentation)  \"suggestedVariableName\" : \(try jsonStringLiteral(suggestedVariableName))
        \(indentation)}
        """
    }
}

private func jsonStringLiteral(_ value: String) throws -> String {
    let data = try JSONEncoder().encode(value)

    guard let encoded = String(data: data, encoding: .utf8) else {
        throw NSError(
            domain: "GenerationApi",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Could not encode JSON string literal"]
        )
    }

    return encoded
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
func decodeATDF(urls: [URL], docURL: URL, inferValueTypes: Bool = false) -> [GeneratedAVRCore] {
    let pipeline = GenerationPipeline()
    let resultsLock = NSLock()
    var generatedAVRCores = Array<GeneratedAVRCore?>(repeating: nil, count: urls.count)

    DispatchQueue.concurrentPerform(iterations: urls.count) { index in
        let url = urls[index]

        do {
            let documentation = ChipDocumentationLoader()
            documentation.directory = docURL
            documentation.inferValueTypes = inferValueTypes

            let data = try Data(contentsOf: url)
            let atdfObject = try XMLDecoder().decode(AVRToolsDeviceFile.self, from: data)
            let generatedFiles = pipeline.run(device: atdfObject, documentation: documentation)
            let generatedCore = GeneratedAVRCore(
                name: atdfObject.devices.device.name,
                files: generatedFiles,
                log: documentation.generationLog
            )

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
func exportAll(fromURLs: [URL], toURL: URL, docURL: URL, inferValueTypes: Bool = false) {
    let generatedCores = decodeATDF(urls: fromURLs, docURL: docURL, inferValueTypes: inferValueTypes)
    let skippedChipNames = generatedCores.filter { $0.shouldExport == false }.map { $0.name }.sorted()
    let exportableCores = generatedCores.filter { $0.shouldExport }
    let generatedFiles = exportableCores.flatMap { core in
        core.files.map { GeneratedFileJob(chipName: core.name, file: $0) }
    }

    let resultsLock = NSLock()
    var formattedFiles = Array<FormattedGeneratedFile?>(repeating: nil, count: generatedFiles.count)

    if generatedFiles.isEmpty == false {
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

    if skippedChipNames.isEmpty == false {
        print("Skipped export for \(skippedChipNames.joined(separator: ", ")) - see logs.json")
    }

    Logs(chips: generatedCores.map { $0.log }).saveToFile(toURL: toURL)
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
