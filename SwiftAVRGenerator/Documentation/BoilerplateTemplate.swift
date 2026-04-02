//
//  BoilerplateTemplate.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 02/04/2026.
//

import Foundation

enum BoilerplateTemplate {
    private static let directoryName = "boilerplate"

    static func load(named fileName: String, documentationDirectory: URL?) -> String {
        guard let documentationDirectory else {
            fatalError("Missing documentation directory for boilerplate template '\(fileName)'")
        }

        let fileURL = documentationDirectory
            .appendingPathComponent(directoryName, isDirectory: true)
            .appendingPathComponent(fileName)

        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            fatalError("Could not read boilerplate template at \(fileURL.path): \(error.localizedDescription)")
        }
    }

    static func render(
        named fileName: String,
        documentationDirectory: URL?,
        substitutions: [String: String]
    ) -> String {
        var template = load(named: fileName, documentationDirectory: documentationDirectory)

        for (key, value) in substitutions {
            template = template.replacingOccurrences(of: "{{\(key)}}", with: value)
        }

        return template
    }
}
