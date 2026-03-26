//
//  CodeFormatter.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 06/03/2026.
//

import Foundation
import SwiftBasicFormat
import SwiftParser
import SwiftParserDiagnostics
import SwiftSyntax

struct FormattingResult {
    let content: String
    let diagnostics: [FormattingDiagnostic]
}

struct FormattingDiagnostic {
    let severity: Severity
    let message: String
    let line: Int?
    
    enum Severity: String {
        case warning
        case error
    }
}

struct CodeFormatter {
    private let basicFormat = HALGENCodeFormat()

    /// Formats Swift source code and returns the result along with any parsing diagnostics.
    ///
    /// This method parses the provided source code using SwiftParser, generates any
    /// diagnostics that occur during parsing, and returns the formatted source code
    /// in a standardized format.
    ///
    /// - Parameter source: The Swift source code string to format.
    /// - Returns: A `FormattingResult` containing the formatted code and any diagnostics
    ///   encountered during parsing.
    ///
    /// - Note: If the source code contains syntax errors, they will be reported in the
    ///   diagnostics array with appropriate severity levels (error or warning).
    ///
    /// Example:
    /// ```swift
    /// let formatter = CodeFormatter()
    /// let result = formatter.format(source: "let x = 5")
    /// print(result.content)
    /// print(result.diagnostics)
    /// ```
    func format(source: String) -> FormattingResult {
        let sourceFile = Parser.parse(source: source)
        
        let parseDiagnostics = ParseDiagnosticsGenerator.diagnostics(for: sourceFile)
        
        let diagnostics: [FormattingDiagnostic] = parseDiagnostics.map { diag in
            let severity: FormattingDiagnostic.Severity
            switch diag.diagMessage.severity {
            case .error:
                severity = .error
            case .warning:
                severity = .warning
            default:
                severity = .warning
            }
            
            let location = diag.location(converter: SourceLocationConverter(fileName: "", tree: sourceFile))
            
            return FormattingDiagnostic(severity: severity, message: diag.message, line: location.line)
        }
        
        let formatted = sourceFile.formatted(using: basicFormat).description
        let normalized = normalizeIndentation(in: formatted)
        
        return FormattingResult(content: normalized, diagnostics: diagnostics)
    }

    private func normalizeIndentation(in source: String) -> String {
        var indentationLevel = 0

        let normalizedLines = source
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { rawLine -> String in
                let line = String(rawLine)
                let trimmedLine = line.trimmingCharacters(in: .whitespaces)

                guard !trimmedLine.isEmpty else {
                    return ""
                }

                if trimmedLine.hasPrefix("//") {
                    return String(repeating: " ", count: max(indentationLevel, 0) * 4) + trimmedLine
                }

                let leadingClosures = leadingClosingBraceCount(in: trimmedLine)
                let lineIndentationLevel = max(indentationLevel - leadingClosures, 0)
                let normalizedLine = String(repeating: " ", count: lineIndentationLevel * 4) + trimmedLine

                indentationLevel = max(indentationLevel + braceDelta(in: trimmedLine), 0)
                return normalizedLine
            }

        return normalizedLines.joined(separator: "\n")
    }

    private func leadingClosingBraceCount(in line: String) -> Int {
        var count = 0

        for character in line {
            if character == "}" {
                count += 1
                continue
            }

            break
        }

        return count
    }

    private func braceDelta(in line: String) -> Int {
        var delta = 0
        var isInsideStringLiteral = false
        var previousCharacter: Character?

        for character in line {
            if character == "\"", previousCharacter != "\\" {
                isInsideStringLiteral.toggle()
            }

            if !isInsideStringLiteral {
                if character == "{" {
                    delta += 1
                } else if character == "}" {
                    delta -= 1
                }
            }

            previousCharacter = character
        }

        return delta
    }
}
