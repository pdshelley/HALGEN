# AGENTS.md — HALGEN Coding Agent Guide

## Project Overview

HALGEN is a macOS Swift code generator that reads Microchip ATDF (XML device description)
files and emits Swift HAL (Hardware Abstraction Layer) source files for AVR microcontrollers.
It has two targets: a SwiftUI macOS app (`SwiftAVRGenerator`) and a CLI tool
(`SwiftAVRGeneratorCLI`). The main entry point is `generate.sh`.

**Key dependencies (Swift Package Manager via Xcode SPM integration):**
- `swift-syntax` 602.0.0 — AST-based Swift code generation
- `XMLCoder` 0.17.1 — decoding `.atdf` XML files into `Codable` structs

---

## Build Commands

### Build and run (recommended)
```bash
./generate.sh                        # Generate for ATmega328P → Output/
./generate.sh --all                  # Generate for all chips in atdf/
./generate.sh --output /some/path    # Override output directory
```

### Build CLI only (without running)
```bash
xcodebuild \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGeneratorCLI \
  -configuration Release \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath .build
```

### Build the macOS app
```bash
xcodebuild \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -configuration Debug \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath .build
```

### Run the built CLI binary directly
```bash
.build/Build/Products/Release/SwiftAVRGeneratorCLI [--all] [--output <path>]
```

---

## Test Commands

Tests use Apple's **XCTest** framework (no Jest, Vitest, or pytest).

### Run all tests
```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64"
```

### Run a single test class
```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests
```

### Run a single test method
```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests/testExample
```

> **Note:** The test targets currently contain only stubs. When writing new tests, add them
> to `SwiftAVRGeneratorTests/` using `XCTestCase` subclasses.

---

## Linting / Formatting

There is **no linter or formatter configured** (no SwiftLint, SwiftFormat, etc.). Follow
the code style guidelines below manually.

---

## Project Structure

```
SwiftAVRGenerator/
├── CLI/main.swift                 — CLI entry point (arg parsing, file discovery)
├── App/                           — SwiftUI macOS app
├── Generators/
│   ├── PeripheralGenerator.swift  — Protocol definition
│   ├── GeneratorRegistry.swift    — Static list of all generators
│   ├── GenerationPipeline.swift   — Runs all generators for a device
│   ├── GenerationApi.swift        — decode/export helpers, global state
│   └── Peripherals/               — Concrete generators: GPIO, UART, Timers, ADC
├── CodeGeneration/                — Register/bitfield/supplemental utilities
├── Documentation/                 — JSON documentation loader
├── Extensions/                    — Swift extensions (UInt8/16, String, Int)
└── AVRToolsDeviceFile/            — ATDF XML decode models (Codable structs)
atdf/                              — Source ATDF XML device files (~130 chips)
docs/                              — Supplemental JSON docs (e.g. ATmega328P.json)
Output/                            — Runtime-generated Swift output files
```

---

## Code Style Guidelines

### File Headers
Every Swift file must start with the standard header:
```swift
//
//  FileName.swift
//  SwiftAVRGenerator
//
//  Created by <Author> on <date>.
//
```

### Imports
- Import only what is needed; do not add unused imports.
- Standard ordering: `Foundation` first, then SPM dependencies (`SwiftSyntax`,
  `SwiftSyntaxBuilder`, `XMLCoder`), then `SwiftUI` last (app files only).
- Omit `Foundation` if the file has no Foundation dependencies.

```swift
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import XMLCoder
```

### Types and Data Structures
- **Prefer `struct` over `class`** for all data and generator types.
- Use `class` only when reference semantics are required (e.g., `ChipDocumentationLoader`).
- All ATDF model types must be `struct` conforming to `Codable`.
- Use `enum` with `String` raw values to model every constrained XML attribute; raw values
  must match the original XML string exactly.
- Use `@Attribute` property wrapper (from XMLCoder) for XML attribute decoding.

### Naming Conventions
| Category        | Convention        | Example                           |
|-----------------|-------------------|-----------------------------------|
| Types           | `UpperCamelCase`  | `GenerationPipeline`, `GPIOGenerator` |
| Protocols       | `UpperCamelCase`  | `PeripheralGenerator`             |
| Functions       | `lowerCamelCase` verb phrase | `buildUARTFile`, `generateRegister` |
| Variables/props | `lowerCamelCase`  | `registerGroup`, `memberBlockList` |
| Enum cases      | `lowerCamelCase`  | `.eightBit`, `.readWrite`         |
| Enum cases (XML raw values) | Match XML exactly | `.PORTA`, `.TC0` |
| Static constants | `lowerCamelCase` | `static let allGenerators`        |

### Adding a New Peripheral Generator
1. Create `SwiftAVRGenerator/Generators/Peripherals/MyPeripheral.swift`.
2. Define `struct MyPeripheralGenerator: PeripheralGenerator` with `name`, `subdirectory`,
   `supports(device:)`, and `generate(device:documentation:)`.
3. Register it in `GeneratorRegistry.allGenerators` (`GeneratorRegistry.swift`).
4. Output directory is `Output/<ChipName>/<subdirectory>/`.

```swift
struct MyPeripheralGenerator: PeripheralGenerator {
    let name = "MyPeripheral"
    let subdirectory = "module/myperipheral"

    func supports(device: AVRToolsDeviceFile) -> Bool {
        device.modules.module.contains { $0.name == .myModule }
    }

    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        // Build and return [GeneratedCodeFile]
    }
}
```

### Generated Code Style
- Mark all register accessor computed properties `@inlinable @inline(__always) public static var`.
- Use `_volatileRegisterReadUInt8` / `_volatileRegisterWriteUInt8` (or 16-bit equivalents)
  for register access.
- Annotate every generated property with a `///` doc comment referencing the datasheet section.
- Use `SwiftSyntaxBuilder` AST types when generating multi-declaration files; use string
  interpolation for simpler single-property outputs.
- Call `.formatted().description` on `SwiftSyntaxBuilder` output before writing to disk.

### Error Handling
- In **CLI code** (`main.swift`): use `fputs("error: …\n", stderr)` + `exit(1)` for fatal
  errors. Use `do/catch` for all throwing calls.
- In **file export** (`exportFile`): use `do/catch` and print a descriptive message;
  never `exit` from a library function.
- **Avoid `try!`** in new code — existing uses are technical debt. Prefer `do/catch` or
  `try?` with a `guard` and an explicit fallback.
- **Avoid `try?`** unless the failure is genuinely unrecoverable or irrelevant; prefer
  explicit `do/catch` to surface errors in logs.
- Do not silently swallow errors; always at minimum `print` a diagnostic.

### Global State
The following globals exist and are intentional (treat with care):
- `var logs: Logs` — accumulates per-chip generation logs; written to `Output/logs.json`.
- `var listOfValues: [String]` — debugging helper; may be removed later.
- `var bitfieldsToIgnore` — tracks already-processed split bitfields within a generation run.

Do not add new module-level `var` globals without discussion. Prefer passing state as
function parameters or encapsulating it in a type.

### Comments and TODOs
- Use `// TODO:` for known gaps or follow-up work — these are expected and normal.
- Use `///` triple-slash for documentation comments on public types, properties, and functions.
- Include datasheet section references in doc comments where applicable:
  `/// See ATMega328p Datasheet section 14.4.2.`
- Commented-out code blocks are acceptable during active development but should be cleaned
  up before a feature is considered complete.

### Data Flow
```
atdf/*.atdf (XML)
    → XMLDecoder → AVRToolsDeviceFile (Codable structs)
    → GenerationPipeline.run(device:documentation:)
        → [PeripheralGenerator].generate(device:documentation:)
    → [GeneratedCodeFile]
    → exportAll → disk at Output/<ChipName>/<subdirectory>/<file>.swift
```
Supplemental human-readable docs (`docs/<ChipName>.json`) are loaded by
`ChipDocumentationLoader` and merged during generation to enrich register/bitfield
documentation comments.
