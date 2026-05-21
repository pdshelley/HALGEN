# Contributing to HALGEN

HALGEN generates Swift hardware abstraction layers for AVR microcontrollers. The generator reads bundled ATDF XML files, merges supplemental documentation from `docs/`, and writes formatted Swift source into `Output/`.

The primary development workflow is the command-line generator. The SwiftUI app target exists, but most contributor work should start with the CLI and focused tests.

## First Successful Run

Requirements:

- macOS with Xcode installed
- Xcode command line tools pointed at the full Xcode app

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

Generate the default representative chip:

```bash
./generate.sh
```

Generate into a temporary directory when you want to inspect output without touching `Output/`:

```bash
./generate.sh --output /tmp/halgen-test
```

Run the focused unit test target:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests
```

If local signing blocks test runs, retry with signing disabled:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests \
  CODE_SIGNING_ALLOWED=NO CODE_SIGN_IDENTITY="" DEVELOPMENT_TEAM=""
```

## Golden Rule

Change generator code or documentation inputs. Do not hand-edit files under `Output/` unless you are only inspecting generated output.

Generated files should improve because one of these changed:

- Swift generator logic under `SwiftAVRGenerator/`
- supplemental JSON or templates under `docs/`
- ATDF input data under `atdf/`

## Where To Change Things

| If you are changing... | Start here |
| --- | --- |
| CLI arguments or export behavior | `SwiftAVRGenerator/CLI/main.swift` and `SwiftAVRGenerator/Generators/GenerationApi.swift` |
| ATDF decoding models | `SwiftAVRGenerator/AVRToolsDeviceFile/` |
| supplemental JSON loading | `SwiftAVRGenerator/Documentation/` |
| register or bitfield code generation | `SwiftAVRGenerator/CodeGeneration/` |
| peripheral output | `SwiftAVRGenerator/Generators/Peripherals/` |
| generator registration | `SwiftAVRGenerator/Generators/GeneratorRegistry.swift` |
| generated formatting | `SwiftAVRGenerator/CodeGeneration/Linter/` |
| supplemental docs data | `docs/general.json`, `docs/<Chip>.json`, and `docs/SUPPLEMENTAL_DOCUMENTATION.md` |
| boilerplate module code | `docs/boilerplate/` |
| tests | `SwiftAVRGeneratorTests/` |

## Common Workflows

Read `DeveloperDocs/ARCHITECTURE.md` before making broad generator changes. It explains the data flow from ATDF input to generated Swift output.

Read `DeveloperDocs/DOCUMENTATION_SYSTEM.md` before editing `docs/general.json`, `docs/<Chip>.json`, or boilerplate templates. That guide explains how supplemental data is merged and why missing entries appear in `logs.json`.

Read `DeveloperDocs/ADDING_PERIPHERALS.md` before adding a new peripheral generator or changing an existing generator's structure.

Read `DeveloperDocs/TESTING_AND_GENERATION.md` when you need exact build, test, generation, and inspection commands.

## Review Checklist

Before opening a pull request or asking for review:

- Run focused tests for the area you changed.
- Run `./generate.sh --output /tmp/halgen-test` for generator or documentation changes.
- Inspect `logs.json` for unexpected missing supplemental data.
- Inspect `formatting-report.txt` for generated formatting diagnostics.
- Update contributor docs when behavior, commands, or documentation fields change.
