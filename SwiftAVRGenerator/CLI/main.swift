//
//  main.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 02/03/2026.
//

import Foundation

func projectRoot() -> URL {
    let binary = URL(fileURLWithPath: CommandLine.arguments[0]).standardized
    // Try to find the project root by walking up until we find SwiftAVRGenerator.xcodeproj
    var candidate = binary.deletingLastPathComponent()
    for _ in 0..<10 {
        let probe = candidate.appendingPathComponent("SwiftAVRGenerator.xcodeproj")
        if FileManager.default.fileExists(atPath: probe.path) {
            return candidate
        }
        candidate = candidate.deletingLastPathComponent()
    }
    // Fallback: current working directory
    return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
}

var generateAll = false
var outputOverride: URL? = nil

var args = CommandLine.arguments.dropFirst()
var argsIterator = args.makeIterator()

while let arg = argsIterator.next() {
    switch arg {
    case "--all":
        generateAll = true
    case "--output":
        if let path = argsIterator.next() {
            outputOverride = URL(fileURLWithPath: path, isDirectory: true)
        } else {
            fputs("error: --output requires a path argument\n", stderr)
            exit(1)
        }
    case "--help", "-h":
        print("""
        Usage: SwiftAVRGeneratorCLI [--all] [--output <path>]

          --all            Generate for all chips in atdf/
                           (default: ATmega328P only)
          --output <path>  Output directory
                           (default: <project>/Output/)
        """)
        exit(0)
    default:
        fputs("error: unknown argument '\(arg)'\n", stderr)
        exit(1)
    }
}

let root = projectRoot()
let docsURL = root.appendingPathComponent("docs", isDirectory: true)
let archURL = root.appendingPathComponent("atdf", isDirectory: true)
let outputURL = outputOverride ?? root.appendingPathComponent("Output", isDirectory: true)

let atdfURLs: [URL]

if generateAll {
    do {
        let contents = try FileManager.default.contentsOfDirectory(
            at: archURL,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        )
        atdfURLs = contents
            .filter { $0.pathExtension.lowercased() == "atdf" }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }
    } catch {
        fputs("error: could not read atdf/ directory at \(archURL.path): \(error)\n", stderr)
        exit(1)
    }
} else {
    let defaultATDF = archURL.appendingPathComponent("ATmega328P.atdf")
    guard FileManager.default.fileExists(atPath: defaultATDF.path) else {
        fputs("error: default ATDF not found at \(defaultATDF.path)\n", stderr)
        exit(1)
    }
    atdfURLs = [defaultATDF]
}

guard FileManager.default.fileExists(atPath: docsURL.path) else {
    fputs("error: docs/ directory not found at \(docsURL.path)\n", stderr)
    exit(1)
}

print("Project root : \(root.path)")
print("Docs dir     : \(docsURL.path)")
print("Output dir   : \(outputURL.path)")
print("Chips        : \(atdfURLs.map { $0.deletingPathExtension().lastPathComponent }.joined(separator: ", "))")
print()

exportAll(fromURLs: atdfURLs, toURL: outputURL, docURL: docsURL)

print()
print("Done. Output written to: \(outputURL.path)")
