# AGENTS.md — HALGEN Agent Guide

## Project Summary

HALGEN is a macOS Swift code generator for AVR microcontrollers.
It reads Microchip ATDF XML files and emits Swift HAL source files.

Targets:
- `SwiftAVRGenerator` — SwiftUI macOS app
- `SwiftAVRGeneratorCLI` — command-line generator

Key paths:
- `atdf/` — source ATDF device descriptions
- `docs/` — supplemental JSON documentation per chip
- `Output/` — generated Swift output

Primary workflow:
- `generate.sh` builds the CLI in Release and runs it.

Dependencies used by the generator:
- `swift-syntax`
- `XMLCoder`

## Extra Rule Files

Checked these locations for additional instructions:
- `.cursorrules`
- `.cursor/rules/`
- `.github/copilot-instructions.md`

No Cursor or Copilot rule files were found.

## Repository Layout

```text
SwiftAVRGenerator/
├── CLI/main.swift
├── App/
├── Generators/
│   ├── GenerationApi.swift
│   ├── GenerationPipeline.swift
│   ├── GeneratorRegistry.swift
│   ├── PeripheralGenerator.swift
│   └── Peripherals/
├── CodeGeneration/
├── Documentation/
├── Extensions/
└── AVRToolsDeviceFile/
SwiftAVRGeneratorTests/
SwiftAVRGeneratorUITests/
atdf/
docs/
Output/
```

## Build Commands

Recommended build-and-run flow:

```bash
./generate.sh
./generate.sh --all
./generate.sh --output /some/path
```

Build the CLI only:

```bash
xcodebuild \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGeneratorCLI \
  -configuration Release \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath .build
```

Build the macOS app:

```bash
xcodebuild \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -configuration Debug \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath .build
```

Run the built CLI directly:

```bash
.build/Build/Products/Release/SwiftAVRGeneratorCLI [--all] [--output <path>]
```

## Test Commands

Tests use XCTest through Xcode.

Run all tests:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64"
```

Run a single unit test class:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests
```

Run a single unit test method:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests/testExample
```

Run a single UI test method:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorUITests/SwiftAVRGeneratorUITests/testExample
```

Current tests are mostly Xcode stubs. Add new tests under `SwiftAVRGeneratorTests/`
or `SwiftAVRGeneratorUITests/`.

## Linting And Formatting

There is no configured lint or formatting step.
Do not assume SwiftLint or SwiftFormat is available.
Match surrounding style manually.

## Workflow Notes

- Prefer changing generator inputs or templates over hand-editing generated output.
- Do not hand-edit files in `Output/` unless the task is explicitly about generated output inspection.
- Before broad generation changes, inspect existing generated files for style and API shape.
- When changing docs behavior, check both generator code and `docs/<Chip>.json` to avoid duplicate tables or prose.
- Keep changes scoped; generator logic is shared across many chips.

## Swift Source Style

Every Swift source file should begin with:

```swift
//
//  FileName.swift
//  SwiftAVRGenerator
//
//  Created by <Author> on <date>.
//
```

Imports:
- Import only what is needed.
- Keep `Foundation` first when used.
- Put package imports next: `SwiftSyntax`, `SwiftSyntaxBuilder`, `XMLCoder`.
- Put `SwiftUI` last, and only in app or UI files.
- Remove unused imports.

Formatting:
- Follow the indentation, spacing, and brace style already used in the file.
- Prefer readable line breaks over dense one-liners.
- Keep doc comments aligned with the declarations they describe.
- Match surrounding access-control placement and attribute ordering.
- Use ASCII unless a file already requires something else.
- Use `.formatted().description` on `SwiftSyntaxBuilder` output before writing files.

Types and modeling:
- Prefer `struct` over `class` for generators and model types.
- Use `class` only when shared mutable reference semantics are required.
- Keep ATDF decoding models as `Codable` structs.
- Prefer `let` over `var` unless mutation is required.
- Use `enum` raw values for constrained XML attributes, matching source strings exactly.
- Use XMLCoder's `@Attribute` wrapper for XML attributes.
- Avoid adding new module-level mutable globals.

Known intentional globals:
- `logs`
- `listOfValues`
- `bitfieldsToIgnore`

Naming:
- Types and protocols: `UpperCamelCase`
- Functions, methods, variables, and properties: `lowerCamelCase`
- Boolean names should read clearly, such as `isEnabled` or `supports(device:)`
- Enum cases for Swift concepts: `lowerCamelCase`
- Enum cases mirroring XML tokens should preserve the source meaning/casing requirements
- Static constants: `lowerCamelCase`

Documentation:
- Use `///` for public API and generated register docs.
- Include datasheet section references when known.
- Use `// TODO:` for follow-up work.
- Keep docs additive; avoid duplicating the same table or prose from two sources.

Error handling:
- In CLI code, prefer `do/catch` around throwing operations.
- For fatal CLI failures, print to `stderr` with `fputs("error: ...\n", stderr)` and `exit(1)`.
- In library and generator code, do not call `exit`.
- Avoid `try!` in new code.
- Do not swallow errors silently; print or log a useful diagnostic.
- Prefer explicit handling over `try?` unless failure is genuinely unimportant.

## Generator Guidance

- New peripherals belong in `SwiftAVRGenerator/Generators/Peripherals/`.
- Conform to `PeripheralGenerator` with `name`, `subdirectory`, `supports(device:)`, and `generate(device:documentation:)`.
- Register new generators in `GeneratorRegistry.allGenerators`.
- Generated files export under `Output/<ChipName>/<subdirectory>/`.
- Generated register accessors should follow existing conventions: `@inlinable`, `@inline(__always)`, `public static var`, and `_volatileRegisterReadUInt8` / `_volatileRegisterWriteUInt8` or 16-bit equivalents.
- Prefer `SwiftSyntaxBuilder` for multi-declaration output; string interpolation is acceptable for small fragments.

## Validation Tips

- Run focused tests for the area you changed when practical.
- If no meaningful automated test exists, say so plainly.
- For generator changes, `./generate.sh` is often the most useful verification step.
- Check at least one representative chip, typically `ATmega328P`, unless the task targets another device.
- If you touch CLI path handling or documentation loading, verify with `./generate.sh --output /tmp/halgen-test`.
- Do not claim linting was run; there is no configured lint step.

## Data Flow

```text
atdf/*.atdf
  -> XMLDecoder
  -> AVRToolsDeviceFile
  -> GenerationPipeline.run(device:documentation:)
  -> peripheral generators
  -> [GeneratedCodeFile]
  -> export to Output/<ChipName>/...
```

Supplemental JSON docs from `docs/<ChipName>.json` are loaded through
`ChipDocumentationLoader` and merged into generated register and bitfield docs.
