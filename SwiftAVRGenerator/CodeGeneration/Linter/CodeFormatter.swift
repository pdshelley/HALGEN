//
//  CodeFormatter.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 06/03/2026.
//

import Foundation
import SwiftParser
import SwiftSyntax
import SwiftParserDiagnostics

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
        
        let formatted = sourceFile.formatted().description
        
        return FormattingResult(content: formatted, diagnostics: diagnostics)
    }
}
