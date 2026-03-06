//
//  FormattingReport.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 06/03/2026.
//

import Foundation
import Dispatch

struct FormattingReport {
    struct Entry {
        let chipName: String
        let fileName: String
        let diagnostic: FormattingDiagnostic
    }

    private struct Snapshot {
        let text: String
        let warningCount: Int
        let errorCount: Int
    }
    
    private(set) var entries: [Entry] = []
    
    var isEmpty: Bool { entries.isEmpty }
    var hasErrors: Bool { entries.contains { $0.diagnostic.severity == .error } }
    var warningCount: Int { entries.count { $0.diagnostic.severity == .warning } }
    var errorCount: Int { entries.count { $0.diagnostic.severity == .error } }
    
    /// Adds formatting diagnostics for a specific chip and file to the report.
    /// - Parameters:
    ///   - chipName: The name of the chip (e.g., "ATmega328P").
    ///   - fileName: The name of the generated file that was checked.
    ///   - diagnostics: An array of formatting diagnostics found during parsing.
    mutating func add(chipName: String, fileName: String, diagnostics: [FormattingDiagnostic]) {
        for diagnostic in diagnostics {
            entries.append(Entry(chipName: chipName, fileName: fileName, diagnostic: diagnostic))
        }
    }
    
    /// Saves the report to a text file and prints a summary to the console.
    /// - Parameter directory: The directory where the report file will be saved.
    /// - Note: Creates `formatting-report.txt` in the specified directory.
    func save(to directory: URL) {
        let snapshot = buildSnapshot()
        exportFile(toURL: directory, fileName: "formatting-report.txt", fileContents: snapshot.text)
        printSummary(snapshot: snapshot)
    }
    
    /// Builds a human-readable text report of all formatting diagnostics.
    /// - Returns: A formatted string containing the full report with chip names, file names,
    ///   locations, and severity levels.
    private func buildSnapshot() -> Snapshot {
        var lines: [String] = []
        lines.append("HALGEN Formatting Report")
        lines.append("========================")
        lines.append("")
        
        guard !isEmpty else {
            lines.append("All generated files parsed and formatted without issues.")
            return Snapshot(text: lines.joined(separator: "\n"), warningCount: 0, errorCount: 0)
        }

        let counts = severityCounts()
        let byChip = Dictionary(grouping: entries, by: { $0.chipName })
        let chipNames = byChip.keys.sorted()
        let sectionsLock = NSLock()
        var sections = Array<String?>(repeating: nil, count: chipNames.count)

        DispatchQueue.concurrentPerform(iterations: chipNames.count) { index in
            let chipName = chipNames[index]
            let chipEntries = byChip[chipName] ?? []
            let byFile = Dictionary(grouping: chipEntries, by: { $0.fileName })
            var chipLines: [String] = ["[\(chipName)]"]

            for fileName in byFile.keys.sorted() {
                for entry in byFile[fileName] ?? [] {
                    let diagnostic = entry.diagnostic
                    let locationStr = diagnostic.line.map { " (line \($0))" } ?? ""
                    chipLines.append(" \(diagnostic.severity.rawValue): \(fileName)\(locationStr) - \(diagnostic.message)")
                }
            }

            chipLines.append("")

            sectionsLock.lock()
            sections[index] = chipLines.joined(separator: "\n")
            sectionsLock.unlock()
        }

        lines.append(contentsOf: sections.compactMap { $0 })
        lines.append("Summary: \(counts.errorCount) error(s), \(counts.warningCount) warning(s)")

        return Snapshot(
            text: lines.joined(separator: "\n"),
            warningCount: counts.warningCount,
            errorCount: counts.errorCount
        )
    }
    
    /// Prints a summary of the formatting report to the console.
    /// - Note: Outputs either "all files OK" if no issues found, or a count of errors and warnings
    ///   with a reference to the full report file.
    private func printSummary(snapshot: Snapshot) {
        if isEmpty {
            print("Formatting: all files OK")
        } else {
            print("Formatting: \(snapshot.errorCount) error(s), \(snapshot.warningCount) warning(s) - see formatting-report.txt")
        }
    }

    private func severityCounts() -> (warningCount: Int, errorCount: Int) {
        let workerCount = min(max(ProcessInfo.processInfo.activeProcessorCount, 1), max(entries.count, 1))
        let chunkSize = max((entries.count + workerCount - 1) / workerCount, 1)
        let chunks = stride(from: 0, to: entries.count, by: chunkSize).map {
            Array(entries[$0..<min($0 + chunkSize, entries.count)])
        }

        let countsLock = NSLock()
        var warningCount = 0
        var errorCount = 0

        DispatchQueue.concurrentPerform(iterations: chunks.count) { index in
            var localWarningCount = 0
            var localErrorCount = 0

            for entry in chunks[index] {
                switch entry.diagnostic.severity {
                case .warning:
                    localWarningCount += 1
                case .error:
                    localErrorCount += 1
                }
            }

            countsLock.lock()
            warningCount += localWarningCount
            errorCount += localErrorCount
            countsLock.unlock()
        }

        return (warningCount, errorCount)
    }
}
