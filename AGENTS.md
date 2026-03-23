# AGENTS.md - HALGEN Agent Guide

## Project Summary
HALGEN is a macOS Swift code generator for AVR microcontrollers. It reads ATDF XML plus supplemental JSON docs and emits Swift HAL source files.
Targets:
- `SwiftAVRGenerator` - SwiftUI macOS app
- `SwiftAVRGeneratorCLI` - command-line generator
Dependencies: `swift-syntax`, `XMLCoder`
Key paths:
- `atdf/` - source ATDF device descriptions
- `docs/` - supplemental JSON docs (`general.json` plus per-chip files)
- `Output/` - generated Swift output
- `Scripts/generate_avr_tools_device_file.swift` - ATDF model regeneration helper
Data flow: `atdf/*.atdf` -> `XMLDecoder` -> `AVRToolsDeviceFile` -> `GenerationPipeline` -> peripheral generators -> formatted Swift output in `Output/<ChipName>/...`

## Extra Rule Files
Checked:
- `.cursorrules`
- `.cursor/rules/`
- `.github/copilot-instructions.md`
No Cursor or Copilot rule files were found.

## Repository Layout
- `SwiftAVRGenerator/CLI/main.swift` - CLI entry point
- `SwiftAVRGenerator/App/` - SwiftUI app target
- `SwiftAVRGenerator/Generators/` - pipeline, registry, peripheral generators
- `SwiftAVRGenerator/CodeGeneration/` - register/bitfield generation and formatter
- `SwiftAVRGenerator/Documentation/` - supplemental doc models and loader
- `SwiftAVRGenerator/AVRToolsDeviceFile/` - ATDF decoding models
- `SwiftAVRGeneratorTests/` - XCTest coverage
- `SwiftAVRGeneratorUITests/` - UI test stubs
Schemes: `SwiftAVRGenerator`, `SwiftAVRGeneratorCLI`

## Build And Run
```bash
./generate.sh
./generate.sh --all
./generate.sh --output /tmp/halgen-test
./generate.sh --all --output /tmp/halgen-test

xcodebuild \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGeneratorCLI \
  -configuration Release \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath .build

.build/Build/Products/Release/SwiftAVRGeneratorCLI [--all] [--output <path>]

xcodebuild \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -configuration Debug \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath .build
```
`./generate.sh --help` was verified locally and successfully built the CLI.

## Test Commands
```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64"

xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests

xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests/testExample

xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorUITests/SwiftAVRGeneratorUITests/testLaunchPerformance
```
If `xcodebuild test` fails with `No signing certificate "Mac Development" found`, append `CODE_SIGNING_ALLOWED=NO CODE_SIGN_IDENTITY="" DEVELOPMENT_TEAM=""`.
A single unit test succeeded locally with that signing-disabled suffix.
Add new tests under `SwiftAVRGeneratorTests/` unless the work is specifically UI behavior.

## Linting And Formatting
- No `SwiftLint`, `SwiftFormat`, or other standalone repo-wide lint config is present.
- There is no separate lint command to run.
- Generated code is normalized by `CodeFormatter` and `HALGENCodeFormat` in `SwiftAVRGenerator/CodeGeneration/Linter/`.
- Export runs also write `formatting-report.txt` and `logs.json`.

## Workflow Notes
- Prefer changing generator code or documentation inputs over hand-editing generated files.
- Do not edit `Output/` unless the task is specifically about generated output inspection.
- When changing docs behavior, check both `docs/general.json` and `docs/<Chip>.json`.
- If you need to update the ATDF decode layer, inspect `Scripts/generate_avr_tools_device_file.swift` first.
- Keep changes scoped; generator logic is shared across many chips.
- Match local style in the file you touch; newer code uses `SwiftSyntaxBuilder`, older files sometimes build strings directly.

## Swift Source Style
File header:
```swift
//
//  FileName.swift
//  SwiftAVRGenerator
//
//  Created by <Author> on <date>.
//
```
Imports:
- Import only what the file uses.
- Put `Foundation` first when needed, Apple modules like `Dispatch` next, package imports after that, and `SwiftUI` last.
- In tests, keep `@testable import SwiftAVRGenerator` after normal imports.
- Remove unused imports.
Formatting:
- Match surrounding indentation and brace style; 4 spaces are standard.
- Prefer readable multiline code over dense one-liners, and keep blank lines/doc comments intentional.
- Prefer ASCII unless the file already uses something else.
- When building `SwiftSyntaxBuilder` output, call `.formatted().description` before emitting text.
- `exportAll` also runs generated content through `CodeFormatter`; do not assume a separate formatter step exists.
Types and modeling:
- Prefer `struct` for generators, value types, report types, and decode models.
- Use `class` only when shared mutable state or caching is needed, such as `ChipDocumentationLoader`.
- Keep ATDF/XML models as nested `Codable` structs and use XMLCoder's `@Attribute` wrapper for XML attributes.
- Prefer `let` over `var`; mutate only when decoding or generation logic requires it.
- Use `String`-backed enums when exact source tokens matter.
- Avoid new module-level mutable globals; `listOfValues` is the main legacy exception.
Naming:
- Types and protocols use `UpperCamelCase`.
- Functions, methods, properties, and locals use `lowerCamelCase`.
- Boolean names should read as predicates, such as `hasMissingSupplementalData`, `shouldExport`, or `supports(device:)`.
- Static constants usually use `lowerCamelCase`, for example `allGenerators`.
- Preserve meaningful XML terms where they matter, such as `nameInModule`, `bitAddressable`, or `ocdRw`.
Documentation:
- Use `///` for public APIs and generated register/bitfield docs.
- Include datasheet section references when known.
- Keep supplemental docs additive; avoid duplicating the same prose in both generator code and JSON docs.
- Use `// TODO:` for genuine follow-up work only.
Error handling:
- In CLI code and helper scripts, validate arguments explicitly, print fatal errors to `stderr` with `fputs`, and exit nonzero.
- In library and generator code, prefer `do/catch` and useful diagnostics over `exit`.
- Avoid `try!`; use `try?` only when failure is genuinely optional.
- `preconditionFailure` is acceptable for impossible internal states, but prefer validating external input first.
- Never swallow errors silently when a user or agent needs to know what failed.

## Generator Guidance
- New peripherals belong in `SwiftAVRGenerator/Generators/Peripherals/`.
- Conform new peripherals to `PeripheralGenerator` with `name`, `subdirectory`, `supports(device:)`, and `generate(device:documentation:)`.
- Register new generators in `GeneratorRegistry.allGenerators`.
- Generated files export under `Output/<ChipName>/<subdirectory>/`.
- Keep generated register accessors consistent with the current style: `@inlinable`, `@inline(__always)`, `public static var`, and `_volatileRegisterReadUInt8` or `_volatileRegisterWriteUInt8`.
- Prefer `SwiftSyntaxBuilder` for structured multi-declaration output; small string fragments are acceptable in older files when that matches local style.

## Validation Checklist
- Run focused tests for the area you changed when practical.
- For generator changes, `./generate.sh` is usually the most valuable verification step.
- Inspect both `logs.json` and `formatting-report.txt` after generation.
- Check at least one representative chip, usually `ATmega328P`, unless the task targets another device.
- If you touch CLI path handling or documentation loading, verify with `./generate.sh --output /tmp/halgen-test`.
- If full tests are not practical, say exactly what you ran and what you could not verify.
