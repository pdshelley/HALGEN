# Supplemental Documentation System

HALGEN does not generate high-quality Swift names from ATDF data alone. ATDF files provide hardware structure, register names, bit masks, captions, and memory data. The supplemental documentation system turns that raw data into stable Swift-facing names, types, access metadata, prose, and board defaults.

## Mental Model

```text
ATDF gives raw hardware names and structure.
docs/general.json gives shared semantic names, types, access metadata, and inline preferences.
docs/<Chip>.json gives chip-specific corrections, prose, split-field mappings, and board defaults.
ChipDocumentationLoader merges these sources.
Missing entries still generate code, but are recorded in logs.json.
```

Use this system to improve generated output. Do not hand-edit generated files under `Output/`.

## Inputs

| Input | Purpose |
| --- | --- |
| `atdf/*.atdf` | Hardware source of truth from Microchip device packs. |
| `docs/general.json` | Shared aliases and reusable metadata for registers and bitfields that mean the same thing across chips. |
| `docs/<Chip>.json` | Chip-specific documentation, split-field mappings, board defaults, and corrections. |
| `docs/boilerplate/*.swift.template` | Hand-maintained Swift template code included in generated peripheral modules. |
| `docs/coreavr-package/` | Template files used when exporting CoreAVR package support. |

## Resolution Order

For registers and bitfields, HALGEN resolves most naming and metadata fields in this order:

```text
docs/<Chip>.json
-> docs/general.json
-> generated ATDF fallback
```

Chip JSON wins because some chips have behavior or documentation that should not be generalized. `general.json` comes next because many ATDF aliases represent the same semantic concept across peripheral instances or chip families. ATDF fallback keeps generation working even when supplemental data is incomplete.

Board metadata is chip-specific. It comes from `docs/<Chip>.json` first, then ATDF memory or clock data when available, then hardcoded defaults where the generator has a safe fallback.

For exact field-level behavior, use `docs/SUPPLEMENTAL_DOCUMENTATION.md` as the contract.

## Choosing The Right File

Edit `docs/general.json` when the same semantic meaning applies across chips or repeated peripheral instances.

Good `general.json` candidates:

- common register aliases such as `UDR0`, `UDR1`, `UBRR0`, and `UBRR1`
- common bitfield aliases such as `RXC0` and `RXC1`
- canonical Swift variable names
- reusable value types
- default values
- access metadata
- inline preferences

Edit `docs/<Chip>.json` when the value is specific to one chip.

Good chip-file candidates:

- datasheet-specific prose
- split bitfield mappings
- chip-specific access behavior
- board metadata such as RAM, flash, EEPROM, baud, and CPU frequency
- corrections for incomplete ATDF data

If you are unsure whether something is shared, start in the chip file. Generalize later after another chip needs the same concept.

## Missing Data And Logs

Missing supplemental documentation does not stop generation. HALGEN uses generated names and ATDF metadata where it can, then records the missing entries in `logs.json`.

Each missing register log includes:

- ATDF register name
- caption
- offset
- suggested Swift variable name

Each missing bitfield log includes:

- ATDF bitfield name
- caption
- mask
- suggested Swift variable name

`GenerationPipeline` sets a peripheral context for each registered generator. That context lets `ChipDocumentationLoader` group missing entries by peripheral in `logs.json`.

Use `logs.json` after generation to decide what belongs in `general.json` and what belongs in a chip file.

## Audit And Cleanup Scripts

After a full generation pass, rebuild the grouped `general.json` audit report with:

```bash
./generate.sh --all
python3 Scripts/audit_general_json.py --logs Output/logs.json
```

This writes `docs/README.md`. That file is generated audit output, not stable contributor guidance.

Preview stale aliases in `docs/general.json` with:

```bash
python3 Scripts/prune_general_json_aliases.py --dry-run
```

Remove stale aliases with:

```bash
python3 Scripts/prune_general_json_aliases.py
```

## Boilerplate Templates

Some generated modules need hand-maintained Swift code in addition to register accessors. Those snippets live in `docs/boilerplate/*.swift.template`.

Generators load templates through `BoilerplateTemplate.load` or `BoilerplateTemplate.render`. Templates should contain stable Swift APIs that are not practical to derive directly from ATDF registers.

When changing a template:

- generate at least one representative chip that uses it
- inspect the generated module file
- check `formatting-report.txt`
- add or update focused tests when the generated API shape changes

## Examples

### Add A Shared Register Alias

Use `general.json` when several ATDF aliases represent the same Swift concept:

```json
{
  "aliases": ["UDR0", "UDR1"],
  "variableName": "dataRegister",
  "valueType": "UInt8",
  "defaultValue": "",
  "access": "R/W"
}
```

The aliases are ATDF names. `variableName` is the generated Swift name.

### Add A Shared Bitfield Alias

Use `general.json` for common bitfields:

```json
{
  "aliases": ["RXC0", "RXC1"],
  "variableName": "receiveComplete",
  "valueType": "Bool",
  "defaultValue": "",
  "access": "R",
  "inline": "__always"
}
```

Single-bit fields usually use `Bool`. Multi-bit fields usually use an integer type or a generated enum, depending on the generator behavior.

### Add Chip-Specific Register Documentation

Use `docs/<Chip>.json` for prose from a specific datasheet:

```json
{
  "registers": {
    "UDR0": {
      "documentation": [
        "The USART data register contains received data when read and transmit data when written."
      ]
    }
  }
}
```

Documentation arrays are joined with newlines by the loader.

### Add A Split Bitfield Mapping

Use `splitTargetLSB` in the chip file when one logical bitfield is split across registers:

```json
{
  "bitfields": {
    "WGM02": {
      "variableName": "waveformGenerationMode",
      "valueType": "UInt8",
      "splitTargetLSB": "WGM0"
    }
  }
}
```

Set `splitTargetLSB` on the bitfield that should own the generated combined accessor. The value is the ATDF name of the lower-significance companion bitfield.

### Add Board Metadata

Use the chip file for chip-specific board defaults or ATDF gaps:

```json
{
  "chip": "ATmega328P",
  "board": {
    "ramSize": 2048,
    "flashSize": 32768,
    "eepromSize": 1024,
    "baud": 115200,
    "cpuFrequency": 16000000
  }
}
```

Do not use EEPROM size as RAM size. They are separate memory areas.

## Common Mistakes

- Using a generated Swift name as a JSON key. Register and bitfield keys must be exact ATDF aliases.
- Putting chip-specific prose in `general.json`. Documentation prose currently belongs in chip files.
- Duplicating facts the generator can derive reliably from ATDF.
- Editing `docs/README.md` by hand. It is reserved for generated audit output.
- Using the obsolete shorter split-field key instead of `splitTargetLSB`. The loader model expects `splitTargetLSB`.

## Contract And Source Files

Keep this guide aligned with:

- `docs/SUPPLEMENTAL_DOCUMENTATION.md`
- `SwiftAVRGenerator/Documentation/GeneralDocumentation.swift`
- `SwiftAVRGenerator/Documentation/ChipDocumentation.swift`
- `SwiftAVRGenerator/Documentation/ChipDocumentationLoader.swift`
- `SwiftAVRGenerator/Generators/CoreAVRPackageSupport.swift`
