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

- CPUCore
- GPIO
- ADC
- Timers
- UART
- SPI
- TWI

Representative output for `ATmega328P`:

```text
Output/
|-- ATmega328P/
|   `-- module/
|       |-- AnalogToDigitalConverter.swift
|       |-- CPUCore.swift
|       |-- GPIO.swift
|       |-- SPI/
|       |   |-- SPI.swift
|       |   `-- SPI0.swift
|       |-- Timer/
|       |   |-- Timer0.swift
|       |   |-- Timer1.swift
|       |   `-- Timer2.swift
|       |-- TwoWireInterface/
|       |   |-- TwoWireInterface.swift
|       |   `-- TwoWireInterface0.swift
|       `-- UART/
|           |-- UART.swift
|           `-- UART0.swift
|-- formatting-report.txt
`-- logs.json
```

`logs.json` records missing supplemental documentation for each chip. It also
includes top-level exported/skipped chip counts, and any missing items are
grouped by peripheral so follow-up audit tooling can work directly from the log.

`formatting-report.txt` captures diagnostics from the code formatter that runs on
every generated file.

## CoreAVR Parity Tracker

CoreAVR is the handwritten HAL project used as the reference implementation for
HALGEN output. This table tracks what is still missing or incomplete compared to
[CoreAVR](https://github.com/pdshelley/CoreAVR).

| CoreAVR area | HALGEN status |
| --- | --- |
| GPIO | Generated |
| ADC | Generated |
| Timers | Generated |
| UART | Generated |
| SPI | Generated |
| TWI / TwoWireInterface | Generated |
| CPUCore | Partial |
| EEPROM | Missing |
| Interrupts / EXINT | Missing |
| InterruptHandler | Missing |
| Power management / sleep | Partial |
| `atomic` critical sections | Partial |
| Generated package README | Partial |
| S4A/package support files | Partial |

## Supplemental Documentation

The files in `docs/` add naming, access metadata, and richer documentation on
top of the raw ATDF input:

- `docs/general.json` contains shared aliases and reusable metadata.
- `docs/<Chip>.json` contains chip-specific register and bitfield details.
- `docs/SUPPLEMENTAL_DOCUMENTATION.md` documents the expected shape, precedence,
  and fallback behavior for these JSON files.
- Missing entries fall back to generated names and are reported in `logs.json`.

This is the preferred way to improve generated output. Avoid hand-editing files
under `Output/` unless you are only inspecting generated results.

Use `docs/SUPPLEMENTAL_DOCUMENTATION.md` for stable contributor guidance.
`docs/README.md` is reserved for generated audit output.

### Audit Missing `general.json` Entries

Use `Scripts/audit_general_json.py` to regenerate the grouped audit report in
`docs/README.md`.

Preferred workflow after a full generation pass:

```bash
./generate.sh --all
python3 Scripts/audit_general_json.py --logs Output/logs.json
```

What it does:

- Uses `logs.json` as the source of aliases the generator actually reported as missing
- Reads the per-peripheral grouping directly from `logs.json`
- Cleans suggested `variableName` values and groups aliases within the same peripheral family
- Writes the report to `docs/README.md`

If you do not have a fresh `logs.json`, it can still fall back to a direct scan:

```bash
python3 Scripts/audit_general_json.py
```

No script edits or extra flags are needed for new peripherals when you use the
logs-based workflow. The script reads whatever peripheral names are present in
`logs.json`. If you use the direct-scan fallback, it groups entries by ATDF
module name automatically.

### Prune Stale `general.json` Aliases

Use `Scripts/prune_general_json_aliases.py` to remove aliases from
`docs/general.json` that no longer exist in any bundled `atdf/*.atdf` file.

```bash
python3 Scripts/prune_general_json_aliases.py --dry-run
python3 Scripts/prune_general_json_aliases.py
```

What it does:

- Scans every register and bitfield name in `atdf/*.atdf`
- Compares those names against the aliases in `docs/general.json`
- Removes only the missing alias when an entry still has other valid aliases
- Removes the whole JSON object when its only alias is stale
- Prints each removal exactly as it happens, for example:

```text
Removed alias: section=registers variableName=outputCompareRegister alias=OCR1
```

Use `--dry-run` to preview removals without writing back to `docs/general.json`.

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
- `Scripts/audit_general_json.py` rebuilds the missing `general.json` audit
  report.
- `Scripts/prune_general_json_aliases.py` removes stale `general.json` aliases
  that no longer appear in the bundled ATDF files.
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
