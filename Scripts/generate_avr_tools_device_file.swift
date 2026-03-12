#!/usr/bin/env swift
//
//  generate_avr_tools_device_file.swift
//  SwiftAVRGenerator
//
//  Created by Friso De Backer on 03/11/2026.
//

import Foundation

private enum OutputFile: CaseIterable {
    case avrToolsDeviceFile
    case variants
    case devices
    case modules
    case pinouts

    var fileName: String {
        switch self {
        case .avrToolsDeviceFile:
            return "AVRToolsDeviceFile.swift"
        case .variants:
            return "AVRVariants.swift"
        case .devices:
            return "AVRDevices.swift"
        case .modules:
            return "AVRModules.swift"
        case .pinouts:
            return "AVRPinouts.swift"
        }
    }
}

private enum ValueKind {
    case wrappedString
    case plainString
    case int
    case bool
    case bitfieldMask
}

private enum MergeStrategy {
    case exact
    case fuzzyCaption
}

struct AttributeStats {
    var seenCount: Int = 0
    var valueCounts: [String: Int] = [:]
}

struct ChildStats {
    var maxCount: Int = 0
    var presentCount: Int = 0
}

struct ElementStats {
    let xmlName: String
    var occurrenceCount: Int = 0
    var attributeOrder: [String] = []
    var attributes: [String: AttributeStats] = [:]
    var childOrder: [String] = []
    var children: [String: ChildStats] = [:]
}

private struct RenderAttribute {
    let xmlName: String
    let propertyName: String
    let typeName: String
    let typeReference: String
    let isOptional: Bool
    let valueKind: ValueKind
    let valueCounts: [String: Int]
    let mergeStrategy: MergeStrategy
}

private struct RenderChild {
    let xmlName: String
    let propertyName: String
    let typeName: String
    let path: String
    let isArray: Bool
    let isOptional: Bool
}

private let stringPaths: Set<String> = [
    "avr-tools-device-file/devices/device/@name",
    "avr-tools-device-file/devices/device/property-groups/property-group/@name",
    "avr-tools-device-file/devices/device/property-groups/property-group/property/@name",
    "avr-tools-device-file/devices/device/property-groups/property-group/property/@value",
    "avr-tools-device-file/variants/variant/@ordercode",
    "avr-tools-device-file/variants/variant/@tempmin",
    "avr-tools-device-file/variants/variant/@tempmax",
    "avr-tools-device-file/variants/variant/@speedmax",
    "avr-tools-device-file/variants/variant/@pinout",
    "avr-tools-device-file/variants/variant/@package",
    "avr-tools-device-file/variants/variant/@vccmin",
    "avr-tools-device-file/variants/variant/@vccmax"
]

private let intPaths: Set<String> = [
    "avr-tools-device-file/modules/module/register-group/register/bitfield/@lsb"
]

private let boolPaths: Set<String> = [
    "avr-tools-device-file/devices/device/address-spaces/address-space/memory-segment/@external"
]

private let bitfieldMaskPaths: Set<String> = [
    "avr-tools-device-file/modules/module/register-group/register/bitfield/@mask"
]

private let rootFileTypes: [String: String] = [
    "avr-tools-device-file/devices": "AVRDevices",
    "avr-tools-device-file/modules": "AVRModules",
    "avr-tools-device-file/pinouts": "AVRPinouts"
]

private let specialTypeNames: [String: String] = [
    "id": "ID",
    "rw": "ReadWrite",
    "ocdRW": "OCDRW",
    "type": "Kind",
    "vREF": "VREF"
]

private let reservedWords: Set<String> = [
    "associatedtype", "class", "deinit", "enum", "extension", "fileprivate", "func", "import",
    "init", "inout", "internal", "let", "open", "operator", "private", "protocol", "public",
    "rethrows", "static", "struct", "subscript", "typealias", "var", "break", "case", "continue",
    "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", "in", "repeat",
    "return", "switch", "where", "while", "as", "Any", "catch", "false", "is", "nil", "super",
    "self", "Self", "throw", "throws", "true", "try"
]

private let leadingDescriptionTokens: Set<String> = ["A", "AN", "THE"]

private let descriptiveTailTokens: Set<String> = [
    "BIT", "BITS", "DEFINE", "DEFINES", "DEFINED", "ENABLE", "ENABLES", "ENABLED",
    "DISABLE", "DISABLES", "DISABLED", "SELECT", "SELECTS", "SELECTED", "SOURCE",
    "MODE", "MODES", "SETTING", "SETTINGS", "VALUE", "VALUES", "FLAG", "FLAGS",
    "INDICATE", "INDICATES", "INDICATED", "CONTROL", "CONTROLS", "USED", "USE",
    "WHEN", "FOR", "OF", "AND"
]

private func projectRoot() -> URL {
    let scriptURL = URL(fileURLWithPath: #filePath).standardizedFileURL
    var candidate = scriptURL.deletingLastPathComponent()

    for _ in 0..<10 {
        let probe = candidate.appendingPathComponent("SwiftAVRGenerator.xcodeproj")
        if FileManager.default.fileExists(atPath: probe.path) {
            return candidate
        }
        candidate.deleteLastPathComponent()
    }

    return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
}

private func usage() -> String {
    """
    Usage: swift Scripts/generate_avr_tools_device_file.swift [options] [atdf files or directories ...]

      Generates `SwiftAVRGenerator/AVRToolsDeviceFile/*.swift` from the repo `atdf/` directory.
      Additional ATDF files or directories are merged into the generation set so you can add
      support for one or more new chips without losing existing cases.

      Options:
        --output <path>   Override the output directory
        --help, -h        Show this help text
    """
}

struct Options {
    var outputDirectory: URL
    var extraInputs: [String] = []
}

private func parseOptions(root: URL) -> Options {
    var options = Options(outputDirectory: root.appendingPathComponent("SwiftAVRGenerator/AVRToolsDeviceFile", isDirectory: true))
    var iterator = CommandLine.arguments.dropFirst().makeIterator()

    while let argument = iterator.next() {
        switch argument {
        case "--help", "-h":
            print(usage())
            exit(0)
        case "--output":
            guard let path = iterator.next() else {
                fputs("error: --output requires a path argument\n", stderr)
                exit(1)
            }
            options.outputDirectory = URL(fileURLWithPath: path, isDirectory: true)
        default:
            options.extraInputs.append(argument)
        }
    }

    return options
}

private func collectATDFFiles(from path: String) -> [URL] {
    let url = URL(fileURLWithPath: path).standardizedFileURL
    var isDirectory: ObjCBool = false

    guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
        fputs("warning: skipping missing path '\(path)'\n", stderr)
        return []
    }

    if isDirectory.boolValue {
        guard let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil) else {
            return []
        }

        var files: [URL] = []
        for case let fileURL as URL in enumerator where fileURL.pathExtension.lowercased() == "atdf" {
            files.append(fileURL.standardizedFileURL)
        }
        return files
    }

    return url.pathExtension.lowercased() == "atdf" ? [url] : []
}

private func loadATDFFiles(root: URL, extraInputs: [String]) -> [URL] {
    let repoATDFDirectory = root.appendingPathComponent("atdf", isDirectory: true)
    var urls = collectATDFFiles(from: repoATDFDirectory.path)
    urls.append(contentsOf: extraInputs.flatMap(collectATDFFiles(from:)))

    let deduped = Dictionary(grouping: urls, by: { $0.standardizedFileURL.path })
        .values
        .compactMap { $0.first }
        .sorted { $0.lastPathComponent < $1.lastPathComponent }

    guard deduped.isEmpty == false else {
        fputs("error: no ATDF files found\n", stderr)
        exit(1)
    }

    return deduped
}

private func attributePath(elementPath: String, attributeName: String) -> String {
    "\(elementPath)/@\(attributeName)"
}

private func appendUnique(_ item: String, to array: inout [String]) {
    if array.contains(item) == false {
        array.append(item)
    }
}

private func ingest(element: XMLElement, path: [String], stats: inout [String: ElementStats]) {
    let pathString = path.joined(separator: "/")
    let xmlName = element.name ?? path.last ?? "Node"

    if stats[pathString] == nil {
        stats[pathString] = ElementStats(xmlName: xmlName)
    }

    stats[pathString]!.occurrenceCount += 1

    if pathString != "avr-tools-device-file" {
        for attribute in element.attributes ?? [] {
            guard let attributeName = attribute.name else { continue }
            appendUnique(attributeName, to: &stats[pathString]!.attributeOrder)

            var attributeStats = stats[pathString]!.attributes[attributeName] ?? AttributeStats()
            attributeStats.seenCount += 1
            let value = attribute.stringValue ?? ""
            attributeStats.valueCounts[value, default: 0] += 1
            stats[pathString]!.attributes[attributeName] = attributeStats
        }
    }

    let children = element.children?.compactMap { $0 as? XMLElement } ?? []
    var countsByName: [String: Int] = [:]
    for child in children {
        guard let childName = child.name else { continue }
        countsByName[childName, default: 0] += 1
    }

    for (childName, count) in countsByName {
        appendUnique(childName, to: &stats[pathString]!.childOrder)
        var childStats = stats[pathString]!.children[childName] ?? ChildStats()
        childStats.presentCount += 1
        childStats.maxCount = max(childStats.maxCount, count)
        stats[pathString]!.children[childName] = childStats
    }

    for child in children {
        guard let childName = child.name else { continue }
        ingest(element: child, path: path + [childName], stats: &stats)
    }
}

private func parseSchema(from urls: [URL]) -> [String: ElementStats] {
    var stats: [String: ElementStats] = [:]

    for url in urls {
        do {
            let document = try XMLDocument(contentsOf: url, options: .nodePreserveAll)
            guard let root = document.rootElement() else {
                fputs("warning: skipping invalid XML root in \(url.lastPathComponent)\n", stderr)
                continue
            }
            ingest(element: root, path: [root.name ?? "avr-tools-device-file"], stats: &stats)
        } catch {
            fputs("error: failed to parse \(url.lastPathComponent): \(error)\n", stderr)
            exit(1)
        }
    }

    return stats
}

private func valueKind(for path: String) -> ValueKind {
    if stringPaths.contains(path) {
        return .plainString
    }
    if intPaths.contains(path) {
        return .int
    }
    if boolPaths.contains(path) {
        return .bool
    }
    if bitfieldMaskPaths.contains(path) {
        return .bitfieldMask
    }
    return .wrappedString
}

private func splitIdentifierTokens(_ value: String) -> [String] {
    value
        .replacingOccurrences(of: "[^A-Za-z0-9]+", with: " ", options: .regularExpression)
        .split(separator: " ")
        .map(String.init)
}

private func upperCamelCase(_ value: String) -> String {
    if let special = specialTypeNames[value] {
        return special
    }

    let tokens = splitIdentifierTokens(value)
    guard tokens.isEmpty == false else { return "Value" }

    let name = tokens.map { token -> String in
        if token.allSatisfy({ $0.isUppercase || $0.isNumber || $0 == "_" }) {
            return token.replacingOccurrences(of: "_", with: "")
        }

        let lower = token.lowercased()
        return lower.prefix(1).uppercased() + lower.dropFirst()
    }.joined()

    return reservedWords.contains(name) ? "\(name)Type" : name
}

private func lowerCamelCase(_ value: String) -> String {
    let tokens = splitIdentifierTokens(value)
    guard tokens.isEmpty == false else { return "value" }

    func isUppercaseToken(_ token: String) -> Bool {
        let letters = token.filter(\.isLetter)
        return letters.isEmpty == false && letters.allSatisfy(\.isUppercase)
    }

    func titleCased(_ token: String) -> String {
        let lower = token.lowercased()
        return lower.prefix(1).uppercased() + lower.dropFirst()
    }

    let firstToken = tokens[0]
    let first: String
    if isUppercaseToken(firstToken) {
        first = firstToken.lowercased()
    } else {
        first = firstToken.prefix(1).lowercased() + firstToken.dropFirst()
    }

    let remainder = tokens.dropFirst().map { token -> String in
        if isUppercaseToken(token) {
            return titleCased(token)
        }
        return token.prefix(1).uppercased() + token.dropFirst()
    }.joined()

    let combined = first + remainder
    if combined.isEmpty {
        return "value"
    }

    if let firstCharacter = combined.first, firstCharacter.isNumber {
        return "value\(combined)"
    }

    return reservedWords.contains(combined) ? "`\(combined)`" : combined
}

private func legacyLowerCamelCase(_ value: String) -> String {
    let tokens = splitIdentifierTokens(value)
    guard tokens.isEmpty == false else { return "value" }

    func isUppercaseToken(_ token: String) -> Bool {
        let letters = token.filter(\.isLetter)
        return letters.isEmpty == false && letters.allSatisfy(\.isUppercase)
    }

    func legacyTailToken(_ token: String) -> String {
        let letters = token.filter(\.isLetter)
        if isUppercaseToken(token), letters.count <= 4 {
            return token
        }

        let lower = token.lowercased()
        return lower.prefix(1).uppercased() + lower.dropFirst()
    }

    let firstToken = tokens[0]
    let first = isUppercaseToken(firstToken)
        ? firstToken.lowercased()
        : firstToken.prefix(1).lowercased() + firstToken.dropFirst()

    let remainder = tokens.dropFirst().map(legacyTailToken(_:)).joined()
    let combined = first + remainder

    if let firstCharacter = combined.first, firstCharacter.isNumber {
        return "value\(combined)"
    }

    return reservedWords.contains(combined) ? "`\(combined)`" : combined
}

private func isValidSwiftIdentifier(_ value: String) -> Bool {
    value.range(of: "^[A-Za-z_][A-Za-z0-9_]*$", options: .regularExpression) != nil
}

private func memberIdentifier(for rawValue: String) -> String {
    if isValidSwiftIdentifier(rawValue) {
        return reservedWords.contains(rawValue) ? "`\(rawValue)`" : rawValue
    }

    if rawValue.range(of: "^[0-9]+$", options: .regularExpression) != nil {
        return "value\(rawValue)"
    }

    if rawValue.range(of: "^0x[0-9A-Fa-f]+$", options: .regularExpression) != nil {
        return "value\(rawValue)"
    }

    let camel = lowerCamelCase(rawValue)
    if camel == "value" {
        return "value\(abs(rawValue.hashValue))"
    }
    return camel
}

private func exactIdentifier(for rawValue: String) -> String? {
    guard isValidSwiftIdentifier(rawValue) else { return nil }
    return reservedWords.contains(rawValue) ? "`\(rawValue)`" : rawValue
}

private func validatedGeneratedIdentifier(_ candidate: String?) -> String? {
    guard let candidate, candidate.isEmpty == false else { return nil }

    if candidate.hasPrefix("`") && candidate.hasSuffix("`") {
        let inner = String(candidate.dropFirst().dropLast())
        return isValidSwiftIdentifier(inner) ? candidate : nil
    }

    return isValidSwiftIdentifier(candidate) ? candidate : nil
}

private func numberWordIdentifier(for rawValue: String) -> String? {
    guard let number = Int(rawValue), number >= 0 else { return nil }

    let ones = [
        "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
        "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
    ]
    let tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

    func words(_ value: Int) -> String {
        switch value {
        case 0..<20:
            return ones[value]
        case 20..<100:
            let tensPart = tens[value / 10]
            let remainder = value % 10
            guard remainder > 0 else { return tensPart }
            let remainderWords = words(remainder)
            return tensPart + remainderWords.prefix(1).uppercased() + String(remainderWords.dropFirst())
        case 100..<1_000:
            let hundredsPart = words(value / 100) + "Hundred"
            let remainder = value % 100
            guard remainder > 0 else { return hundredsPart }
            let remainderWords = words(remainder)
            return hundredsPart + remainderWords.prefix(1).uppercased() + String(remainderWords.dropFirst())
        case 1_000..<1_000_000:
            let thousandsPart = words(value / 1_000) + "Thousand"
            let remainder = value % 1_000
            guard remainder > 0 else { return thousandsPart }
            let remainderWords = words(remainder)
            return thousandsPart + remainderWords.prefix(1).uppercased() + String(remainderWords.dropFirst())
        default:
            return "value\(value)"
        }
    }

    return words(number)
}

private func hexIdentifiers(for rawValue: String) -> [String] {
    guard rawValue.range(of: "^0[xX][0-9A-Fa-f]+$", options: .regularExpression) != nil else {
        return []
    }

    let suffix = String(rawValue.dropFirst(2))
    let candidates = [
        "zeroX\(suffix)",
        "zeroX\(suffix.uppercased())",
        "zeroX\(suffix.lowercased())"
    ]

    var unique: [String] = []
    for candidate in candidates where unique.contains(candidate) == false {
        unique.append(candidate)
    }

    return unique
}

private func candidateMemberNames(for rawValue: String) -> [String] {
    var candidates: [String] = []

    func append(_ value: String?) {
        guard let value = validatedGeneratedIdentifier(value), candidates.contains(value) == false else { return }
        candidates.append(value)
    }

    append(numberWordIdentifier(for: rawValue))
    for identifier in hexIdentifiers(for: rawValue) {
        append(identifier)
    }
    append(exactIdentifier(for: rawValue))
    append(legacyLowerCamelCase(rawValue))
    append(lowerCamelCase(rawValue))
    append(upperCamelCase(rawValue))

    if let number = Int(rawValue) {
        append("value\(number)")
    }

    if candidates.isEmpty {
        append(memberIdentifier(for: rawValue))
    }

    return candidates
}

private func normalizeAlternateKey(_ value: String) -> String {
    let normalized = value.uppercased().filter { $0.isLetter || $0.isNumber }
    return normalized.isEmpty ? value.uppercased() : normalized
}

private func mergeStrategy(for path: String) -> MergeStrategy {
    path.hasSuffix("/@caption") ? .fuzzyCaption : .exact
}

private func typoComparisonTokens(_ value: String) -> [String] {
    splitIdentifierTokens(value).map { $0.uppercased() }
}

private func trimmedLeadingDescriptionTokens(_ tokens: [String]) -> [String] {
    var index = 0
    while index < tokens.count, leadingDescriptionTokens.contains(tokens[index]) {
        index += 1
    }
    return Array(tokens.dropFirst(index))
}

private func isDescriptiveExpansionVariant(_ lhs: String, _ rhs: String) -> Bool {
    let lhsTokens = trimmedLeadingDescriptionTokens(typoComparisonTokens(lhs))
    let rhsTokens = trimmedLeadingDescriptionTokens(typoComparisonTokens(rhs))

    let longerTokens: [String]
    let shorterTokens: [String]
    let longerValue: String

    if lhsTokens.count > rhsTokens.count {
        longerTokens = lhsTokens
        shorterTokens = rhsTokens
        longerValue = lhs
    } else if rhsTokens.count > lhsTokens.count {
        longerTokens = rhsTokens
        shorterTokens = lhsTokens
        longerValue = rhs
    } else {
        return false
    }

    guard shorterTokens.count >= 2 else { return false }
    guard longerTokens.count >= shorterTokens.count + 3 else { return false }
    guard Array(longerTokens.prefix(shorterTokens.count)) == shorterTokens else { return false }

    let remainder = Array(longerTokens.dropFirst(shorterTokens.count))
    guard remainder.isEmpty == false else { return false }

    let hasSentenceStructure = longerValue.contains(".") || longerValue.contains(",") || longerValue.contains(":")
    let hasDescriptiveTail = remainder.contains(where: { descriptiveTailTokens.contains($0) })
    let startsWithNumbering = remainder.first?.allSatisfy(\.isNumber) == true

    return hasSentenceStructure || hasDescriptiveTail || startsWithNumbering
}

private func isSingleMissingLetterVariant(_ lhs: String, _ rhs: String) -> Bool {
    let left = lhs.uppercased()
    let right = rhs.uppercased()

    guard left != right else { return false }
    guard left.allSatisfy(\.isLetter), right.allSatisfy(\.isLetter) else { return false }

    let longer: String
    let shorter: String
    if left.count == right.count + 1 {
        longer = left
        shorter = right
    } else if right.count == left.count + 1 {
        longer = right
        shorter = left
    } else {
        return false
    }

    guard longer.count >= 4, shorter.count >= 3 else { return false }

    var longerIndex = longer.startIndex
    var shorterIndex = shorter.startIndex
    var skippedCharacter = false

    while longerIndex < longer.endIndex, shorterIndex < shorter.endIndex {
        if longer[longerIndex] == shorter[shorterIndex] {
            longer.formIndex(after: &longerIndex)
            shorter.formIndex(after: &shorterIndex)
            continue
        }

        guard skippedCharacter == false else { return false }
        skippedCharacter = true
        longer.formIndex(after: &longerIndex)
    }

    return true
}

private func shouldTreatAsAlternate(_ lhs: String, _ rhs: String) -> Bool {
    if normalizeAlternateKey(lhs) == normalizeAlternateKey(rhs) {
        return true
    }

    if isDescriptiveExpansionVariant(lhs, rhs) {
        return true
    }

    let leftTokens = typoComparisonTokens(lhs)
    let rightTokens = typoComparisonTokens(rhs)
    guard leftTokens.count == rightTokens.count else { return false }

    var mismatchedPairs: [(String, String)] = []
    for (leftToken, rightToken) in zip(leftTokens, rightTokens) where leftToken != rightToken {
        mismatchedPairs.append((leftToken, rightToken))
        if mismatchedPairs.count > 1 {
            return false
        }
    }

    guard let pair = mismatchedPairs.first else { return false }
    return isSingleMissingLetterVariant(pair.0, pair.1)
}

private func canonicalSortKey(for value: String, count: Int) -> (Int, Int, Int, String) {
    let alphanumericCount = value.count { $0.isLetter || $0.isNumber }
    let separatorCount = value.count { !$0.isLetter && !$0.isNumber }
    return (-count, -alphanumericCount, separatorCount, value.lowercased())
}

private func groupedValues(_ valueCounts: [String: Int], strategy: MergeStrategy) -> [(canonical: String, alternates: [String])] {
    let values = valueCounts.keys.sorted {
        canonicalSortKey(for: $0, count: valueCounts[$0] ?? 0) < canonicalSortKey(for: $1, count: valueCounts[$1] ?? 0)
    }

    guard strategy == .fuzzyCaption else {
        return values.map { value in
            (canonical: value, alternates: [])
        }
    }

    var groups: [[String]] = []

    valueLoop: for value in values {
        for index in groups.indices {
            if groups[index].contains(where: { shouldTreatAsAlternate($0, value) }) {
                groups[index].append(value)
                continue valueLoop
            }
        }

        groups.append([value])
    }

    return groups.map { group in
        let sorted = group.sorted {
            canonicalSortKey(for: $0, count: valueCounts[$0] ?? 0) < canonicalSortKey(for: $1, count: valueCounts[$1] ?? 0)
        }
        return (canonical: sorted[0], alternates: Array(sorted.dropFirst()).sorted())
    }
    .sorted {
        canonicalSortKey(for: $0.canonical, count: valueCounts[$0.canonical] ?? 0) <
        canonicalSortKey(for: $1.canonical, count: valueCounts[$1.canonical] ?? 0)
    }
}

private func escapedStringLiteral(_ value: String) -> String {
    value
        .replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "\"", with: "\\\"")
}

private func header(for fileName: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    let dateString = formatter.string(from: Date())

    return """
    //
    //  \(fileName)
    //  SwiftAVRGenerator
    //
    //  Created by HALGEN on \(dateString).
    //

    import Foundation
    import XMLCoder

    """
}

private func indent(_ text: String, by spaces: Int) -> String {
    let prefix = String(repeating: " ", count: spaces)
    return text
        .split(separator: "\n", omittingEmptySubsequences: false)
        .map { line in
            line.isEmpty ? "" : prefix + line
        }
        .joined(separator: "\n")
}

private func wrapArrayLiteral(_ values: [String], indentLevel: Int) -> String {
    guard values.isEmpty == false else { return "[]" }
    let indentPrefix = String(repeating: " ", count: indentLevel)
    let items = values.map { "\(indentPrefix)    \($0)" }.joined(separator: ",\n")
    return "[\n\(items)\n\(indentPrefix)]"
}

private func renderStringValueType(typeName: String, valueCounts: [String: Int], mergeStrategy: MergeStrategy, indentLevel: Int) -> String {
    var usedNames: Set<String> = []
    var memberNames: [String] = []
    var lines: [String] = []

    for group in groupedValues(valueCounts, strategy: mergeStrategy) {
        let candidates = candidateMemberNames(for: group.canonical)
        let baseIdentifier = candidates.first ?? memberIdentifier(for: group.canonical)
        var identifier = baseIdentifier
        var suffix = 2
        while usedNames.contains(identifier) {
            identifier = "\(baseIdentifier)Alt\(suffix)"
            suffix += 1
        }
        usedNames.insert(identifier)
        memberNames.append(identifier)

        let alternateList = group.alternates.isEmpty
            ? ""
            : ", alternateValues: [\(group.alternates.map { "\"\(escapedStringLiteral($0))\"" }.joined(separator: ", "))]"

        lines.append("static let \(identifier) = \(typeName)(value: \"\(escapedStringLiteral(group.canonical))\"\(alternateList))")
    }

    lines.append("")
    lines.append("let rawValue: String")
    lines.append("let alternateValues: [String]")
    lines.append("")
    lines.append("static let allCases: [\(typeName)] = \(wrapArrayLiteral(memberNames, indentLevel: indentLevel + 4))")
    lines.append("")
    lines.append("init(value: String, alternateValues: [String] = []) {")
    lines.append("    self.rawValue = value")
    lines.append("    self.alternateValues = alternateValues")
    lines.append("}")

    let body = lines.joined(separator: "\n")
    return "struct \(typeName): ATDFStringValue {\n\(indent(body, by: 4))\n}"
}

private func renderBitfieldMaskType(indentLevel: Int) -> String {
    let body = """
    let value: UInt16

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        guard stringValue.lowercased().hasPrefix("0x"),
              let integerValue = UInt16(stringValue.dropFirst(2), radix: 16) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid hexadecimal string for bitfield mask: \\(stringValue)"
            )
        }

        self.value = integerValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let encoded = String(value, radix: 16, uppercase: true)
        try container.encode("0x\\(encoded)")
    }
    """

    return "struct Mask: Codable {\n\(indent(body, by: 4))\n}"
}

private func renderableAttributes(for elementPath: String, statsByPath: [String: ElementStats]) -> [RenderAttribute] {
    guard let elementStats = statsByPath[elementPath] else { return [] }

    return elementStats.attributeOrder.compactMap { attributeName in
        guard let attributeStats = elementStats.attributes[attributeName] else { return nil }
        let path = attributePath(elementPath: elementPath, attributeName: attributeName)
        let kind = valueKind(for: path)
        let mergeStrategy = mergeStrategy(for: path)
        let propertyName = lowerCamelCase(attributeName)
        let typeName = upperCamelCase(attributeName)
        let typeReference: String

        switch kind {
        case .plainString:
            typeReference = "String"
        case .int:
            typeReference = "Int"
        case .bool:
            typeReference = "Bool"
        case .bitfieldMask, .wrappedString:
            typeReference = typeName
        }

        return RenderAttribute(
            xmlName: attributeName,
            propertyName: propertyName,
            typeName: typeName,
            typeReference: typeReference,
            isOptional: attributeStats.seenCount < elementStats.occurrenceCount,
            valueKind: kind,
            valueCounts: attributeStats.valueCounts,
            mergeStrategy: mergeStrategy
        )
    }
}

private func renderableChildren(for elementPath: String, statsByPath: [String: ElementStats]) -> [RenderChild] {
    guard let elementStats = statsByPath[elementPath] else { return [] }

    return elementStats.childOrder.compactMap { childName in
        guard let childStats = elementStats.children[childName] else { return nil }
        let childPath = "\(elementPath)/\(childName)"
        let propertyName = lowerCamelCase(childName)
        let typeName = rootFileTypes[childPath] ?? upperCamelCase(childName)

        return RenderChild(
            xmlName: childName,
            propertyName: propertyName,
            typeName: typeName,
            path: childPath,
            isArray: childStats.maxCount > 1,
            isOptional: childStats.maxCount > 1 ? false : childStats.presentCount < elementStats.occurrenceCount
        )
    }
}

private func renderCodingKeys(attributes: [RenderAttribute], children: [RenderChild]) -> String? {
    let lines = attributes.map { attribute in
        attribute.propertyName == attribute.xmlName
            ? "case \(attribute.propertyName)"
            : "case \(attribute.propertyName) = \"\(attribute.xmlName)\""
    } + children.map { child in
        child.propertyName == child.xmlName
            ? "case \(child.propertyName)"
            : "case \(child.propertyName) = \"\(child.xmlName)\""
    }

    guard lines.isEmpty == false else { return nil }
    return "enum CodingKeys: String, CodingKey {\n\(indent(lines.joined(separator: "\n"), by: 4))\n}"
}

private func renderElement(path: String, typeName: String, statsByPath: [String: ElementStats]) -> String {
    let attributes = renderableAttributes(for: path, statsByPath: statsByPath)
    let children = renderableChildren(for: path, statsByPath: statsByPath)

    var sections: [String] = []

    let propertyLines = attributes.map {
        "@Attribute var \($0.propertyName): \($0.typeReference)\($0.isOptional ? "?" : "")"
    } + children.map {
        let type = $0.isArray ? "[\($0.typeName)]" : $0.typeName
        return "let \($0.propertyName): \(type)\($0.isOptional ? "?" : "")"
    }

    if propertyLines.isEmpty == false {
        sections.append(propertyLines.joined(separator: "\n"))
    }

    if let codingKeys = renderCodingKeys(attributes: attributes, children: children) {
        sections.append(codingKeys)
    }

    let nestedAttributeTypes = attributes.compactMap { attribute -> String? in
        switch attribute.valueKind {
        case .wrappedString:
            return renderStringValueType(typeName: attribute.typeName, valueCounts: attribute.valueCounts, mergeStrategy: attribute.mergeStrategy, indentLevel: 4)
        case .bitfieldMask:
            return renderBitfieldMaskType(indentLevel: 4)
        case .plainString, .int, .bool:
            return nil
        }
    }

    if nestedAttributeTypes.isEmpty == false {
        sections.append(nestedAttributeTypes.joined(separator: "\n\n"))
    }

    let nestedChildTypes = children.compactMap { child -> String? in
        guard statsByPath[child.path] != nil else { return nil }
        return renderElement(path: child.path, typeName: child.typeName, statsByPath: statsByPath)
    }

    if nestedChildTypes.isEmpty == false {
        sections.append(nestedChildTypes.joined(separator: "\n\n"))
    }

    let body = sections.joined(separator: "\n\n")
    return "struct \(typeName): Codable {\n\(indent(body, by: 4))\n}"
}

private func renderAVRToolsDeviceFile() -> String {
    let content = """
    struct AVRToolsDeviceFile: Codable {
        let variants: AVRVariants
        let devices: AVRDevices
        let modules: AVRModules
        let pinouts: AVRPinouts?
    }

    protocol ATDFStringValue: Codable, CaseIterable, RawRepresentable, Hashable, CustomStringConvertible where RawValue == String, AllCases == [Self] {
        var alternateValues: [String] { get }
        init(value: String, alternateValues: [String])
    }

    extension ATDFStringValue {
        init?(rawValue: String) {
            guard let match = Self.allCases.first(where: {
                $0.rawValue == rawValue || $0.alternateValues.contains(rawValue)
            }) else {
                return nil
            }

            self = match
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let stringValue = try container.decode(String.self)

            guard let decoded = Self(rawValue: stringValue) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Unknown value '\\(stringValue)'"
                )
            }

            self = decoded
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }

        var description: String {
            rawValue
        }
    }
    """

    return header(for: OutputFile.avrToolsDeviceFile.fileName) + content + "\n"
}

private func renderAVRVariants() -> String {
    let content = """
    struct AVRVariants: Codable {
        let variant: [Variant]

        struct Variant: Codable {
            @Attribute var ordercode: String
            @Attribute var tempmin: String
            @Attribute var tempmax: String
            @Attribute var speedmax: String
            @Attribute var pinout: String?
            @Attribute var package: String
            @Attribute var vccmin: String
            @Attribute var vccmax: String
        }
    }
    """

    return header(for: OutputFile.variants.fileName) + content + "\n"
}

private func renderGeneratedFile(rootPath: String, typeName: String, fileName: String, statsByPath: [String: ElementStats]) -> String {
    header(for: fileName) + renderElement(path: rootPath, typeName: typeName, statsByPath: statsByPath) + "\n"
}

private func write(_ content: String, to url: URL) {
    do {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try content.write(to: url, atomically: true, encoding: .utf8)
    } catch {
        fputs("error: failed to write \(url.path): \(error)\n", stderr)
        exit(1)
    }
}

private func generateFiles(root: URL, outputDirectory: URL, statsByPath: [String: ElementStats], inputs: [URL]) {
    let files: [(OutputFile, String)] = [
        (.avrToolsDeviceFile, renderAVRToolsDeviceFile()),
        (.variants, renderAVRVariants()),
        (.devices, renderGeneratedFile(rootPath: "avr-tools-device-file/devices", typeName: "AVRDevices", fileName: OutputFile.devices.fileName, statsByPath: statsByPath)),
        (.modules, renderGeneratedFile(rootPath: "avr-tools-device-file/modules", typeName: "AVRModules", fileName: OutputFile.modules.fileName, statsByPath: statsByPath)),
        (.pinouts, renderGeneratedFile(rootPath: "avr-tools-device-file/pinouts", typeName: "AVRPinouts", fileName: OutputFile.pinouts.fileName, statsByPath: statsByPath))
    ]

    for (file, content) in files {
        write(content, to: outputDirectory.appendingPathComponent(file.fileName, isDirectory: false))
    }

    print("Project root : \(root.path)")
    print("Output dir   : \(outputDirectory.path)")
    print("ATDF files   : \(inputs.count)")
    print("Generated    : \(files.map { $0.0.fileName }.joined(separator: ", "))")
}

let root = projectRoot()
let options = parseOptions(root: root)
let atdfFiles = loadATDFFiles(root: root, extraInputs: options.extraInputs)
let schema = parseSchema(from: atdfFiles)
generateFiles(root: root, outputDirectory: options.outputDirectory, statsByPath: schema, inputs: atdfFiles)
