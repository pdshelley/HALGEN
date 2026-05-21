# HALGEN Architecture

HALGEN is a source generator. It reads Microchip ATDF device descriptions, combines them with supplemental documentation maintained in this repository, and emits Swift HAL source files.

## Data Flow

```text
atdf/*.atdf
-> XMLDecoder
-> AVRToolsDeviceFile
-> ChipDocumentationLoader
-> GenerationPipeline
-> PeripheralGenerator
-> CodeFormatter
-> Output/<Chip>/...
```

The ATDF file is the hardware source of truth. Supplemental JSON improves naming, access metadata, generated documentation, split bitfield handling, and board defaults. Peripheral generators transform the decoded device model plus supplemental data into Swift source files.

## Main Areas

| Area | Responsibility |
| --- | --- |
| `SwiftAVRGenerator/CLI/` | Command-line entry point and argument handling. |
| `SwiftAVRGenerator/App/` | SwiftUI macOS app target. The CLI is the primary contributor workflow. |
| `SwiftAVRGenerator/AVRToolsDeviceFile/` | Codable models for decoded ATDF XML. |
| `SwiftAVRGenerator/Documentation/` | Models and loader for `docs/general.json`, chip JSON files, board metadata, and missing-data logs. |
| `SwiftAVRGenerator/Generators/` | Generation pipeline, generator registry, peripheral generators, and CoreAVR package support. |
| `SwiftAVRGenerator/CodeGeneration/` | Register, bitfield, documentation-comment, formatting, and SwiftSyntax helpers. |
| `Scripts/` | Maintenance scripts for ATDF models and supplemental documentation audits. |
| `docs/` | Supplemental JSON data, boilerplate templates, CoreAVR package template files, and contributor docs. |
| `Output/` | Generated output. Treat this as an artifact, not as source input. |

## Generation Lifecycle

1. The CLI or app chooses one chip or all bundled ATDF files.
2. The selected ATDF XML is decoded into `AVRToolsDeviceFile`.
3. `GenerationPipeline.run(device:documentation:)` loads `docs/general.json` and `docs/<Chip>.json`.
4. `GeneratorRegistry.allGenerators` is scanned in order.
5. Each generator whose `supports(device:)` returns `true` emits one or more `GeneratedCodeFile` values.
6. Documentation lookups go through `ChipDocumentationLoader` while the pipeline sets the current peripheral log context.
7. Generated Swift is formatted before export.
8. Export writes generated files, `logs.json`, and `formatting-report.txt`.

## Core Concepts

### `AVRToolsDeviceFile`

`AVRToolsDeviceFile` is the decoded ATDF model. It should describe hardware structure, not HAL naming policy.

### `ChipDocumentationLoader`

`ChipDocumentationLoader` merges shared docs from `docs/general.json`, chip-specific docs from `docs/<Chip>.json`, and generated fallbacks from ATDF data. It also records missing supplemental entries so the export can write actionable `logs.json` output.

### `PeripheralGenerator`

Each peripheral generator owns one generated peripheral family. A generator decides whether it supports a chip, then emits files under its configured output subdirectory.

### `GeneratedCodeFile`

A generated file contains a file name, file content, and output subdirectory. Generators should return generated files instead of writing to disk directly.

### `CodeFormatter`

Generated Swift is normalized during export. Do not assume generated text is final before formatter diagnostics are written to `formatting-report.txt`.

## Generator Boundaries

Keep hardware discovery close to the relevant peripheral generator. Keep shared register and bitfield formatting in `SwiftAVRGenerator/CodeGeneration/`. Keep supplemental metadata behavior in `SwiftAVRGenerator/Documentation/`.

If a change affects multiple peripheral families, look for a shared helper in `CodeGeneration` before duplicating logic across generators. If a change only affects one peripheral family, keep it in that generator.

## Generated Output Policy

`Output/` is useful for inspection and regression review, but it should not be the place you fix problems. If generated output is wrong, fix the generator, ATDF input, supplemental JSON, or boilerplate template that produced it.

## Related Docs

- `CONTRIBUTING.md` for onboarding and common workflows.
- `DeveloperDocs/DOCUMENTATION_SYSTEM.md` for supplemental docs behavior.
- `DeveloperDocs/ADDING_PERIPHERALS.md` for peripheral generator changes.
- `DeveloperDocs/TESTING_AND_GENERATION.md` for verification commands.
