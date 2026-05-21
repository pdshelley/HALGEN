# Testing And Generation

Use this guide when you need exact commands for building, generating, testing, and inspecting HALGEN output.

## Helper Script

The preferred workflow is `generate.sh` from the repository root. It builds the CLI in Release and then runs it.

Generate the default representative chip, currently `ATmega328P`:

```bash
./generate.sh
```

Generate every bundled ATDF file:

```bash
./generate.sh --all
```

Generate into a temporary output directory:

```bash
./generate.sh --output /tmp/halgen-test
```

Generate every bundled chip into a temporary output directory:

```bash
./generate.sh --all --output /tmp/halgen-test
```

Show CLI help:

```bash
./generate.sh --help
```

## Direct CLI Build And Run

Build the CLI directly:

```bash
xcodebuild \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGeneratorCLI \
  -configuration Release \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath .build
```

Run the built CLI:

```bash
.build/Build/Products/Release/SwiftAVRGeneratorCLI [--all] [--output <path>]
```

## App Build

Build the SwiftUI app target:

```bash
xcodebuild \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -configuration Debug \
  -destination "platform=macOS,arch=arm64" \
  -derivedDataPath .build
```

## Tests

Run the full test suite:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64"
```

Run the focused unit test class:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests
```

Run one focused unit test:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests/testExample
```

If local signing blocks a test run, append:

```bash
CODE_SIGNING_ALLOWED=NO CODE_SIGN_IDENTITY="" DEVELOPMENT_TEAM=""
```

Example:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests \
  CODE_SIGNING_ALLOWED=NO CODE_SIGN_IDENTITY="" DEVELOPMENT_TEAM=""
```

## Inspecting Generated Output

After generation, inspect the generated files for the affected chip and these reports:

```text
Output/logs.json
Output/formatting-report.txt
```

When using `--output /tmp/halgen-test`, inspect:

```text
/tmp/halgen-test/logs.json
/tmp/halgen-test/formatting-report.txt
```

`logs.json` records missing supplemental documentation grouped by chip and peripheral. Unexpected new missing entries usually mean a generator started looking at new registers or bitfields that need aliases in `docs/general.json` or chip-specific entries in `docs/<Chip>.json`.

`formatting-report.txt` records diagnostics from generated Swift formatting. Formatting diagnostics should be reviewed before treating generated output as valid.

## Which Generation Command To Use

| Change type | Suggested verification |
| --- | --- |
| One peripheral on a common chip | `./generate.sh --output /tmp/halgen-test` |
| Shared register or bitfield generation | focused tests, then `./generate.sh --output /tmp/halgen-test` |
| Supplemental docs behavior | focused tests, then `./generate.sh --output /tmp/halgen-test` |
| New peripheral generator | focused tests, then `./generate.sh --all --output /tmp/halgen-test` |
| CLI output path handling | `./generate.sh --output /tmp/halgen-test` |
| Broad architecture change | full tests, then `./generate.sh --all --output /tmp/halgen-test` |

Use `ATmega328P` as the representative chip unless the change targets another device.

## Generated Output Policy

Do not fix generated code by editing `Output/`. Fix the source that produced it: generator code, supplemental JSON, boilerplate templates, or ATDF input.
