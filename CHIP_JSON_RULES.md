# Chip JSON Rules

This file documents the structure and behavior of the chip documentation JSON files in `docs/`.

The generator does not use a single `chip.json` file. Instead, it loads one file per chip:

- `docs/ATmega328P.json`
- `docs/ATtiny85.json`
- etc.

The file name must match the ATDF device name because the loader resolves it as:

- `docs/<ChipName>.json`

Example:

- ATDF chip name: `ATmega328P`
- Expected docs file: `docs/ATmega328P.json`

If the file is missing or invalid JSON, supplemental documentation for that chip will not load.

## Top-Level Shape

Each chip file must look like this:

```json
{
  "chip": "ATmega328P",
  "datasheet": "ATmega328P Datasheet (DS40002061B)",
  "registers": {
    "REGISTER_NAME": {
      "variableName": "swiftPropertyName",
      "documentation": [],
      "access": "R/W"
    }
  },
  "bitfields": {
    "BITFIELD_NAME": {
      "variableName": "swiftPropertyName",
      "valueType": "Bool",
      "defaultValue": "",
      "documentation": [],
      "access": "R/W"
    }
  }
}
```

## Top-Level Keys

### `chip`

- Required
- Must be a string
- Describes the chip the file belongs to
- Should match the filename and ATDF chip name

Implications:

- This field is required for JSON decoding
- It is descriptive only; the loader selects the file by filename, not by this value
- If it is omitted, the entire file fails to decode

### `datasheet`

- Required
- Must be a string
- Human-readable datasheet identifier

Implications:

- Required for decoding
- Currently metadata only; it is not used directly by the loader when generating accessors
- If it is omitted, the entire file fails to decode

### `registers`

- Required
- Must be an object keyed by ATDF register name
- Keys must match the register names exactly, for example `UDR0`, `ADMUX`, `TCCR1A`

Implications:

- Missing `registers` causes the entire file to fail to decode
- If a specific register key is missing, the generator falls back to derived defaults for that register

### `bitfields`

- Required
- Must be an object keyed by ATDF bitfield name
- Keys must match the bitfield names exactly, for example `RXC0`, `WGM0`, `ADEN`

Implications:

- Missing `bitfields` causes the entire file to fail to decode
- If a specific bitfield key is missing, the generator falls back to derived defaults for that bitfield

## Register Entry Shape

Each register entry supports this structure:

```json
"ADMUX": {
  "variableName": "multiplexerSelectionRegister",
  "valueType": "",
  "defaultValue": "",
  "documentation": [],
  "documentationL": [],
  "documentationH": [],
  "initialValues": [],
  "initialValuesL": [],
  "initialValuesH": [],
  "access": "R/W"
}
```

### `variableName`

- Required
- Must be a string
- Becomes the generated Swift property name for the register

Implications:

- If omitted, the entire chip JSON fails to decode
- This overrides the fallback name derived from the ATDF caption
- Choose a valid Swift-style lowerCamelCase name

### `valueType`

- Optional
- Must be a string if present
- Currently stored in the decoded model but not used by `generateRegister(...)`

Implications:

- Safe to omit for registers today
- Keeping it empty has no current effect on generated register accessors

### `defaultValue`

- Optional
- Must be a string if present
- Currently stored in the decoded model but not used by register accessor generation

Implications:

- Safe to omit for registers today
- Keeping it empty has no current effect on generated register accessors

### `documentation`

- Optional
- Must be an array of strings if present
- Each array item becomes one generated doc-comment line

Implications:

- If omitted or empty, no supplemental register prose is added
- Empty string elements become blank `///` lines
- Markdown fences and tables are allowed and preserved line-by-line
- This text is appended before the generator's own register table

Important:

- If you put a full register table here, and the generator also emits its own table, you may get duplicate tables in the generated Swift docs
- This is especially relevant for ADC and other registers where generator code already adds structured docs

### `documentationL`

- Optional
- Array of strings
- Used for the low byte view of a 16-bit register when the generator splits it into `...L`

Implications:

- If omitted, the low-byte property gets no custom split-register prose
- The low-byte property may still get generated with default/generated docs

### `documentationH`

- Optional
- Array of strings
- Used for the high byte view of a 16-bit register when the generator splits it into `...H`

Implications:

- If omitted, the high-byte property gets no custom split-register prose
- Use this when the high byte needs different wording than the low byte

### `initialValues`

- Optional
- Array of strings
- Supplies the generated `InitialValue` table row for byte-sized register docs

Implications:

- Values are read left-to-right as bit 7 through bit 0
- If omitted, the generator keeps `?` for every bit
- If fewer than 8 values are provided, the remaining cells stay `?`
- Empty string entries are treated as `?`

Example:

```json
"TCCR0B": {
  "initialValues": ["0", "0", "0", "0", "0", "0", "0", "0"]
}
```

### `initialValuesL`

- Optional
- Array of strings
- Supplies the generated `InitialValue` row for the low-byte `...L` property of a split 16-bit register

### `initialValuesH`

- Optional
- Array of strings
- Supplies the generated `InitialValue` row for the high-byte `...H` property of a split 16-bit register

### `access`

- Optional
- String such as `R`, `W`, or `R/W`

Implications:

- For registers, this value is mainly used when generating the register documentation table
- If omitted, the fallback for missing register entries is `R/W`
- If present but empty, the generated docs can show blank access cells
- This does not currently enforce Swift read-only or write-only behavior for register properties

### `bitfields`

- Optional in the schema
- Present on `ChipDocumentation.Register`
- Currently not consumed by `ChipDocumentationLoader` or the code generators

Implications:

- Nested register-local bitfield metadata is currently ignored
- Put real bitfield definitions in the top-level `bitfields` object instead

## Bitfield Entry Shape

Each bitfield entry supports this structure:

```json
"ADEN": {
  "variableName": "enabled",
  "valueType": "Bool",
  "defaultValue": "",
  "documentation": [
    "Writing this bit to one enables the ADC."
  ],
  "access": "R/W"
}
```

### `variableName`

- Required
- Must be a string
- Becomes the generated Swift property name for the bitfield accessor

Implications:

- If omitted, the entire chip JSON fails to decode
- This is the most important bitfield field besides `valueType`

### `valueType`

- Optional in the schema, but effectively required for useful code generation
- Must be a string naming the generated Swift type

Common values:

- `Bool`
- `UART.ModeSelect`
- `VoltageReferenceSelection`
- `Prescaling`

Implications:

- If `valueType` is `Bool`, the generator emits a boolean accessor
- If `valueType` is an enum-like type, the generator uses `Type(rawValue: mode) ?? defaultValue`
- If omitted, generated Swift will likely be invalid because the property type becomes empty

Rule of thumb:

- Always provide `valueType` for bitfields
- Use `Bool` for one-bit true/false semantics
- Use a concrete enum type for multi-bit fields and for single-bit fields modeled as enums

### `defaultValue`

- Optional in the schema, but required for non-`Bool` bitfields
- Must be a valid Swift expression as a string

Examples:

- `""` for `Bool`
- `.off`
- `.stopped`
- `.adc0`

Implications:

- For `Bool`, this is not used by the generated getter and may be left empty
- For enum-like `valueType`s, this is used as the fallback if `rawValue` decoding fails
- If omitted for a non-`Bool` field, generated Swift will likely be invalid

### `documentation`

- Optional
- Array of strings
- Joined into generated doc comments for the bitfield accessor

Implications:

- Omit or use `[]` when no extra docs are needed
- Use separate array elements for separate lines or paragraphs
- Empty string entries create blank documentation lines

### `access`

- Optional in the schema
- Expected values are `R`, `W`, or `R/W`

Implications:

- `R` produces a readable accessor
- `R/W` produces a readable and writable accessor
- `W` suppresses the getter and creates a write-only accessor
- Any unknown value falls back to `R/W` during decoding

Rule:

- For bitfields, only use `R`, `W`, or `R/W`

### `splitTarget`

- Optional
- Used for bitfields that are split across two registers
- Value must be the name of the other ATDF bitfield that forms the combined logical field

Implications:

- This should be set on the high/MSB side of the split field
- The generator assumes the `splitTarget` entry is the primary definition for the combined accessor
- The target bitfield must exist in the ATDF data and be discoverable in the register group
- If the target name is wrong, the generator can fail at runtime because the split accessor code force-unwraps the target

Practical rule:

- Put the real docs, `variableName`, `valueType`, and `defaultValue` on the entry that has `splitTarget`
- Treat the target entry as the linked low/secondary part

Example:

```json
"UCSZ02": {
  "variableName": "numberOfDataBits",
  "valueType": "UART.NumberOfDataBits",
  "defaultValue": ".eight",
  "documentation": [
    "UCSZn0 and UCSZn1 are bits 1 and 2 on UCSRnC while UCSZn2 is bit 2 on UCSRnB"
  ],
  "access": "R/W",
  "splitTarget": "UCSZ0"
}
```

## Fallback Behavior When Entries Are Missing

If a register key is missing from `registers`:

- `variableName` is derived from the ATDF caption using `getVariableName(...)`
- `documentation` becomes empty
- `access` falls back to `R/W`

If a bitfield key is missing from `bitfields`:

- `variableName` is derived from the ATDF caption
- `documentation` becomes empty
- `access` falls back to `R/W`
- `valueType` becomes empty
- `defaultValue` becomes empty

Important consequence:

- Missing bitfield metadata is much riskier than missing register metadata because an empty bitfield `valueType` can lead to invalid generated Swift

## Authoring Rules

- Use exact ATDF register and bitfield names as object keys
- Prefer lowerCamelCase for `variableName`
- Use arrays of strings for documentation, not one large newline-delimited string
- Use `[]` instead of `null`
- Use only `R`, `W`, and `R/W` for bitfield access
- Avoid duplicating tables in both JSON docs and generator code unless you want both to appear
- Put chip-specific semantic docs in JSON and reusable structural docs in generator code

## Minimal Safe Checklist

For a new register entry:

- add the exact register name key
- add `variableName`
- add `access`
- add `documentation` if needed
- add `documentationL` and `documentationH` only for split 16-bit docs
- add `initialValues` when you want the generated register table to show real reset values
- add `initialValuesL` and `initialValuesH` only for split 16-bit byte views

For a new bitfield entry:

- add the exact bitfield name key
- add `variableName`
- add `valueType`
- add `defaultValue` if `valueType` is not `Bool`
- add `access`
- add `documentation` if needed
- add `splitTarget` only for true split-register fields

## Current Limitations Worth Knowing

- The file is selected by filename, not by the `chip` field
- Nested `registers.<name>.bitfields` are currently ignored
- Register `valueType` and `defaultValue` are currently unused
- Full register tables in JSON can duplicate auto-generated tables in output docs
- Split bitfields rely on strict assumptions in generator code and should be added carefully
