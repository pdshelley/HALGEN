# HALGEN — Swift HAL Generator

Generates Swift Hardware Abstraction Layer (HAL) code for AVR microcontrollers from Atmel `.atdf` device description files.

ATDFs are pulled from: http://packs.download.atmel.com

---

## Requirements

- macOS with Xcode installed
- Xcode command line tools pointing to Xcode (not just CLT):
  ```
  sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
  ```

---

## Usage

### generate.sh

The easiest way to run the generator is via the shell script at the project root. It builds the CLI tool automatically before running it.

```
./generate.sh [--all] [--output <path>]
```

**Examples:**

Generate HAL for ATmega328P (default) into `Output/`:
```
./generate.sh
```

Generate HAL for all chips in `atdf/` into `Output/`:
```
./generate.sh --all
```

Generate HAL for ATmega328P into a custom directory:
```
./generate.sh --output ~/Desktop/MyHAL
```

Generate all chips into a custom directory:
```
./generate.sh --all --output ~/Desktop/MyHAL
```

**Parameters:**

| Parameter | Description |
|---|---|
| *(none)* | Generate for ATmega328P only, output to `Output/` |
| `--all` | Generate for every `.atdf` file in `atdf/` |
| `--output <path>` | Write output to `<path>` instead of `Output/` |

---

### CLI directly

After the project has been built at least once with `generate.sh`, you can invoke the binary directly:

```
.build/Build/Products/Release/SwiftAVRGeneratorCLI [--all] [--output <path>]
```

---

## Output structure

Generated files are written under the output directory, organized by chip name:

```
Output/
└── ATmega328P/
    └── module/
        ├── GPIO.swift
        ├── AnalogToDigitalConverter.swift
        ├── Timer/
        │   ├── Timer0.swift
        │   ├── Timer1.swift
        │   └── Timer2.swift
        └── UART/
            ├── UART.swift
            └── UART0.swift
```

---

## Project structure

```
HALGEN/
├── generate.sh                  — Build and run script
├── atdf/                        — ATDF source files (one per chip)
├── docs/                        — Supplemental JSON documentation
├── Output/                      — Generated Swift files (created on first run)
└── SwiftAVRGenerator/
    ├── App/                     — SwiftUI macOS app
    ├── CLI/                     — Command-line entry point
    ├── Generators/              — Per-peripheral code generators
    ├── CodeGeneration/          — Core code generation utilities
    ├── Documentation/           — Documentation loader
    ├── Extensions/              — Swift extensions
    └── AVRToolsDeviceFile/      — ATDF decode models
```
