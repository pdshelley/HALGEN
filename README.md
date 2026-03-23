# HALGEN - Swift HAL Generator

HALGEN generates Swift hardware abstraction layers for AVR microcontrollers.
It reads bundled ATDF (Atmel Device File) XML descriptions, merges them with
supplemental JSON documentation, and emits formatted Swift source for each chip.

```text
atdf/*.atdf + docs/general.json + docs/<Chip>.json
    -> GenerationPipeline
    -> Output/<Chip>/...
```

The repository includes both a SwiftUI macOS app target and a command-line
generator. The CLI is the primary workflow.

Bundled ATDF files originate from: http://packs.download.atmel.com

## Requirements

- macOS with Xcode installed
- Xcode command line tools pointed at the full Xcode app:

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

## Quick Start

Use the helper script at the project root. It builds the CLI in Release and
then runs it.

```bash
./generate.sh
./generate.sh --all
./generate.sh --output /tmp/halgen-test
./generate.sh --all --output /tmp/halgen-test
```

Default behavior:

| Invocation | Result |
| --- | --- |
| `./generate.sh` | Generate `ATmega328P` into `Output/` |
| `./generate.sh --all` | Generate every bundled `.atdf` file in `atdf/` |
| `./generate.sh --output <path>` | Write output to a custom directory |

Show CLI help:

```bash
./generate.sh --help
```

## Build And Run The CLI Directly

If you want to build and invoke the binary yourself:

```bash
xcodebuild \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGeneratorCLI \
  -configuration Release \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath .build

.build/Build/Products/Release/SwiftAVRGeneratorCLI [--all] [--output <path>]
```

## Generated Output

HALGEN currently generates these peripheral families:

- GPIO
- ADC
- Timers
- UART

Representative output for `ATmega328P`:

```text
Output/
|-- ATmega328P/
|   `-- module/
|       |-- AnalogToDigitalConverter.swift
|       |-- GPIO.swift
|       |-- Timer/
|       |   |-- Timer0.swift
|       |   |-- Timer1.swift
|       |   `-- Timer2.swift
|       `-- UART/
|           |-- UART.swift
|           `-- UART0.swift
|-- formatting-report.txt
`-- logs.json
```

`logs.json` records missing supplemental documentation for each chip. If a chip
is missing required register or bitfield metadata, HALGEN skips exporting that
chip and reports the missing items there.

`formatting-report.txt` captures diagnostics from the code formatter that runs on
every generated file.

## Supplemental Documentation

The files in `docs/` add naming, access metadata, and richer documentation on
top of the raw ATDF input:

- `docs/general.json` contains shared aliases and reusable metadata.
- `docs/<Chip>.json` contains chip-specific register and bitfield details.
- Missing entries fall back to generated names and are reported in `logs.json`.

This is the preferred way to improve generated output. Avoid hand-editing files
under `Output/` unless you are only inspecting generated results.

## Repository Layout

```text
HALGEN/
|-- generate.sh
|-- atdf/
|-- docs/
|-- Output/
|-- Scripts/
|-- SwiftAVRGenerator/
|   |-- App/
|   |-- CLI/
|   |-- Generators/
|   |-- CodeGeneration/
|   |-- Documentation/
|   `-- AVRToolsDeviceFile/
|-- SwiftAVRGeneratorTests/
`-- SwiftAVRGeneratorUITests/
```

- `SwiftAVRGenerator/App/` contains the SwiftUI macOS app target.
- `SwiftAVRGenerator/CLI/` contains the command-line entry point.
- `SwiftAVRGenerator/Generators/` contains the generation pipeline and
  peripheral generators.
- `SwiftAVRGenerator/Documentation/` contains the supplemental doc models and
  loader.
- `Scripts/generate_avr_tools_device_file.swift` helps regenerate the ATDF model
  layer when needed.

## Development

Build the macOS app target:

```bash
xcodebuild \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -configuration Debug \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath .build
```

Run tests:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64"
```

If local signing blocks test runs, retry with:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  CODE_SIGNING_ALLOWED=NO CODE_SIGN_IDENTITY="" DEVELOPMENT_TEAM=""
```
