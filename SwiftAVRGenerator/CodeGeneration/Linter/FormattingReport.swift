//
//  FormattingReport.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 06/03/2026.
//

import Foundation

struct FormattingReport {
    struct Entry {
        let chipName: String
        let fileName: String
        let diagnostic: FormattingDiagnostic
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
        let text = buildReportText()
        exportFile(toURL: directory, fileName: "formatting-report.txt", fileContents: text)
        printSummary()
    }
    
    /// Builds a human-readable text report of all formatting diagnostics.
    /// - Returns: A formatted string containing the full report with chip names, file names,
    ///   locations, and severity levels.
    private func buildReportText() -> String {
        var lines: [String] = []
        lines.append("HALGEN Formatting Report")
        lines.append("========================")
        lines.append("")
        
        guard !isEmpty else {
            lines.append("All generated files parsed and formatted without issues.")
            return lines.joined(separator: "\n")
        }
        
        let byChip = Dictionary(grouping: entries, by: { $0.fileName })
        for chipName in byChip.keys.sorted() {
            lines.append("[\(chipName)]")
            let byFile = Dictionary(grouping: byChip[chipName]!, by: { $0.fileName })
            for fileName in byFile.keys.sorted() {
                for entry in byFile[fileName]! {
                    let d = entry.diagnostic
                    let locationStr = " (line \(d.line, default: ""))"
                    lines.append(" \(d.severity.rawValue): \(fileName)\(locationStr) - \(d.message)")
                }
            }
            lines.append("")
        }
        lines.append("Summary: \(errorCount) error(s), \(warningCount) warning(s)")
        return lines.joined(separator: "\n")
    }
    
    /// Prints a summary of the formatting report to the console.
    /// - Note: Outputs either "all files OK" if no issues found, or a count of errors and warnings
    ///   with a reference to the full report file.
    private func printSummary() {
        if isEmpty {
            print("Formatting: all files OK")
        } else {
            print("Formatting: \(errorCount) error(s), \(warningCount) warning(s) - see formatting-report.txt")
        }
    }
}
