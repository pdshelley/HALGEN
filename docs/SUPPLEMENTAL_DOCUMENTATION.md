# Supplemental Documentation Contract

This file is the source of truth for the hand-maintained JSON files in `docs/`.

Use it when:

- adding a new alias to `general.json`
- adding or updating a chip file such as `ATmega328P.json`
- deciding whether a value belongs in shared docs or chip-specific docs
- checking what HALGEN does when a field is missing

`docs/README.md` is reserved for generated audit output from `Scripts/audit_general_json.py`.
Put stable guidance here instead of in `docs/README.md`.

## Overview

HALGEN merges three sources:

```text
ATDF + docs/general.json + docs/<Chip>.json
```

The ATDF remains the primary hardware source. The JSON files provide naming,
typing, generated documentation overrides, and board-level fallbacks when the
ATDF is incomplete or inconvenient.

## Which File To Edit

Edit `docs/general.json` when the same meaning applies across many chips.

Typical examples:

- common register aliases such as `UDR0`, `UBRR0`, `TCCR0A`
- common bitfield aliases such as `RXC0`
- shared variable names
- shared value types
- shared default values
- shared access metadata
- shared bitfield inlining preferences

Edit `docs/<Chip>.json` when the data is chip-specific.

Typical examples:

- chip-specific documentation text
- split bitfield mappings
- register or bitfield behavior that differs from the general case
- board defaults such as RAM size fallbacks, CPU frequency, and baud rate

## Resolution Order

### Registers

For a register alias, HALGEN resolves fields in this order:

1. `docs/<Chip>.json`
2. `docs/general.json`
3. Generated fallback from the ATDF

Current behavior:

- `variableName`: chip value, else general value, else generated from caption
- `valueType`: chip value, else general value, else empty
- `defaultValue`: chip value, else general value, else empty
- `access`: chip value, else general value, else ATDF `rw`, else `"R/W"`
- `documentation`: chip file only
- `documentationL` and `documentationH`: chip file only
- `initialValues`, `initialValuesL`, `initialValuesH`: chip file only
- `overrideGeneratedDocumentation`: chip file only

If neither chip nor general docs define a register alias, HALGEN still
generates code, uses a generated variable name, and records the missing alias
in `logs.json`.

### Bitfields

For a bitfield alias, HALGEN resolves fields in this order:

1. `docs/<Chip>.json`
2. `docs/general.json`
3. Generated fallback from the ATDF

Current behavior:

- `variableName`: chip value, else general value, else generated from caption
- `valueType`: chip value, else general value, else inferred only when
  `--infer-value-types` is enabled, else empty
- `defaultValue`: chip value, else general value, else empty
- `access`: chip value, else general value, else ATDF `rw`, else read/write
- `inline`: chip value, else general value, else `"__always"`
- `documentation`: chip file only
- `splitTarget`: chip file only
- `overrideGeneratedDocumentation`: chip file only

If neither chip nor general docs define a bitfield alias, HALGEN still
generates code, uses a generated variable name, and records the missing alias
in `logs.json`.

### Board Metadata

Board metadata currently lives only in `docs/<Chip>.json`.

For `board.include`, HALGEN resolves fields in this order:

1. `docs/<Chip>.json` `board`
2. ATDF-derived value
3. hardcoded fallback

Current behavior:

- `ramSize`: chip override, else ATDF `IRAM` or `ram` segment, else `0`
- `flashSize`: chip override, else ATDF `FLASH` or `flash` segment, else `0`
- `eepromSize`: chip override, else ATDF `EEPROM` or `eeprom` segment, else missing
- `baud`: chip override, else `115200`
- `cpuFrequency`: chip override, else max ATDF `variant.speedmax`, else `16000000`

Important: EEPROM and RAM are separate concepts. Do not use EEPROM size as RAM
size unless we intentionally change the generator to do that.

## `docs/general.json`

Shape:

```json
{
  "registers": [
    {
      "aliases": ["UDR0", "UDR1"],
      "variableName": "dataRegister",
      "valueType": "UInt8",
      "defaultValue": "",
      "access": "R/W"
    }
  ],
  "bitfields": [
    {
      "aliases": ["RXC0", "RXC1"],
      "variableName": "receiveComplete",
      "valueType": "Bool",
      "defaultValue": "",
      "access": "R",
      "inline": "__always"
    }
  ]
}
```

Notes:

- `aliases` is required and should include every ATDF alias that maps to the same concept.
- `variableName` is required in practice and should be the canonical generated Swift name.
- `documentation` does not belong in `general.json` today.
- `splitTarget` does not belong in `general.json` today.
- Keep entries semantic. Prefer one shared concept with several aliases over many duplicate objects.

## `docs/<Chip>.json`

Shape:

```json
{
  "chip": "ATmega328P",
  "datasheet": "ATmega328P Datasheet (DS40002061B)",
  "board": {
    "ramSize": 2048,
    "flashSize": 32768,
    "eepromSize": 1024,
    "baud": 115200,
    "cpuFrequency": 16000000
  },
  "registers": {
    "UDR0": {
      "variableName": "dataRegister",
      "valueType": "UInt8",
      "defaultValue": "",
      "access": "R/W",
      "documentation": ["Chip-specific documentation paragraph."],
      "documentationL": ["Low-byte documentation."],
      "documentationH": ["High-byte documentation."],
      "initialValues": ["0", "0", "0", "0", "0", "0", "0", "0"],
      "initialValuesL": ["0", "0", "0", "0", "0", "0", "0", "0"],
      "initialValuesH": ["0", "0", "0", "0", "0", "0", "0", "0"],
      "overrideGeneratedDocumentation": true
    }
  },
  "bitfields": {
    "RXC0": {
      "variableName": "receiveComplete",
      "valueType": "Bool",
      "defaultValue": "",
      "access": "R",
      "documentation": ["Chip-specific bitfield documentation paragraph."],
      "inline": "__always",
      "splitTarget": "UCSZ0",
      "overrideGeneratedDocumentation": true
    }
  }
}
```

Notes:

- `chip`, `datasheet`, `registers`, and `bitfields` are the standard top-level fields.
- `board` is optional and should be used for chip-specific board defaults and ATDF gaps.
- `registers` and `bitfields` are keyed by the exact ATDF alias, not by generated Swift name.
- Documentation arrays are joined with newlines by the loader.
- `initialValues*` arrays are normalized to 8 entries. Blank entries become `"?"`.

## Missing Data Rules

When deciding whether to add data, use these rules:

- If HALGEN can derive it reliably from ATDF, prefer the ATDF and do not duplicate it in JSON.
- If the same fix applies to many chips, prefer `general.json`.
- If the value depends on the chip, place it in `docs/<Chip>.json`.
- If the ATDF is incomplete for a chip, add the smallest chip-specific override needed.
- If you are not sure whether a field is truly shared, start in the chip file and generalize later.

## Recommended Workflow

1. Run generation for the affected chip or chips.
2. Inspect `logs.json` for missing aliases.
3. Add shared naming and typing to `docs/general.json`.
4. Add chip-only behavior and board metadata to `docs/<Chip>.json`.
5. Regenerate and confirm the missing entries are gone.
6. If you want a grouped audit report for `general.json`, regenerate `docs/README.md` with:

```bash
python3 Scripts/audit_general_json.py --logs Output/logs.json
```

## Future Changes

If we add new supported JSON fields, update this file in the same change.

This contract should stay aligned with:

- `SwiftAVRGenerator/Documentation/GeneralDocumentation.swift`
- `SwiftAVRGenerator/Documentation/ChipDocumentation.swift`
- `SwiftAVRGenerator/Documentation/ChipDocumentationLoader.swift`
- `SwiftAVRGenerator/Generators/CoreAVRPackageSupport.swift`
