# Adding Or Changing Peripheral Generators

Peripheral generators turn decoded ATDF modules into Swift HAL files. Add a new generator when a peripheral family needs generated APIs that cannot be handled by an existing generator.

## Before You Start

Check whether the peripheral already has a generator under `SwiftAVRGenerator/Generators/Peripherals/`.

Existing generators include:

- `AnalogToDigitalConverter.swift`
- `GPIO.swift`
- `SerialPeripheralInterface.swift`
- `Timers.swift`
- `TwoWireInterface.swift`
- `UART.swift`

If the change is shared register or bitfield behavior, prefer `SwiftAVRGenerator/CodeGeneration/`. If the change is specific to one peripheral family, keep it in that peripheral generator.

## Generator Contract

New generators conform to `PeripheralGenerator`:

```swift
protocol PeripheralGenerator {
    var name: String { get }
    var logName: String { get }
    var subdirectory: String { get }
    func supports(device: AVRToolsDeviceFile) -> Bool
    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile]
}
```

`logName` defaults to `name`. Override it when the generated Swift-facing name differs from the ATDF or log grouping name. `TwoWireInterfaceGenerator` does this by using `name = "TwoWireInterface"` and `logName = "TWI"`.

## Minimal Generator Shape

Use this shape as a starting point:

```swift
struct ExampleGenerator: PeripheralGenerator {
    let name: String = "Example"
    let subdirectory: String = "module/Example"

    func supports(device: AVRToolsDeviceFile) -> Bool {
        device.modules.module.contains { $0.name == "EXAMPLE" }
    }

    func generate(device: AVRToolsDeviceFile, documentation: ChipDocumentationLoader) -> [GeneratedCodeFile] {
        guard let module = device.modules.module.first(where: { $0.name == "EXAMPLE" }) else {
            return []
        }

        var files: [GeneratedCodeFile] = []

        for registerGroup in module.registerGroup {
            let structName = "Example\(peripheralInstanceIndex(for: registerGroup.name))"
            var code = buildFileHeader(for: structName)

            // Build declarations from registers and bitfields here.

            files.append(
                GeneratedCodeFile(
                    fileName: "\(structName).swift",
                    content: code,
                    subdirectory: subdirectory
                )
            )
        }

        return files
    }
}
```

Keep `supports(device:)` conservative. Return `true` only when the required ATDF module or register shape exists. If only some chips have the classic register layout your generator supports, check for that exact shape instead of only checking the module name.

## Documentation Context And Logs

`GenerationPipeline` wraps every registered generator with:

```swift
documentation.withPeripheralContext(named: generator.logName) {
    generator.generate(device: device, documentation: documentation)
}
```

This means missing supplemental documentation discovered during `generate(device:documentation:)` is grouped under that generator's log name in `logs.json`.

Set `name` and `logName` deliberately. Only call `withPeripheralContext(named:)` inside a generator if the generator intentionally needs multiple log groups.

## Registering The Generator

Add the generator to `SwiftAVRGenerator/Generators/GeneratorRegistry.swift`:

```swift
struct GeneratorRegistry {
    static let allGenerators: [PeripheralGenerator] = [
        UARTGenerator(),
        SPIGenerator(),
        TwoWireInterfaceGenerator(),
        TimerGenerator(),
        ADCGenerator(),
        GPIOGenerator(),
        ExampleGenerator()
    ]
}
```

Keep ordering intentional. If output order matters for generated package layout or review readability, place the new generator where it makes sense with the existing families.

## Boilerplate Templates

If the peripheral needs hand-maintained Swift protocols, convenience APIs, or setup helpers, add a template under `docs/boilerplate/` and load it with `BoilerplateTemplate.load` or `BoilerplateTemplate.render`.

Use templates for stable API surfaces. Use Swift generator code for declarations that are derived from ATDF registers or bitfields.

## Tests And Verification

Add focused unit tests under `SwiftAVRGeneratorTests/` for the behavior you changed. Good tests assert generated content for a representative chip or a small constructed model.

Run focused tests first:

```bash
xcodebuild test \
  -project SwiftAVRGenerator.xcodeproj \
  -scheme SwiftAVRGenerator \
  -destination "platform=macOS,arch=arm64" \
  -only-testing:SwiftAVRGeneratorTests/SwiftAVRGeneratorTests
```

Then generate a representative chip into a temporary directory:

```bash
./generate.sh --output /tmp/halgen-test
```

Inspect:

- `/tmp/halgen-test/logs.json`
- `/tmp/halgen-test/formatting-report.txt`
- the generated peripheral files under `/tmp/halgen-test/<Chip>/`

For broad generator changes, run all bundled chips:

```bash
./generate.sh --all --output /tmp/halgen-test
```

## Contributor Checklist

- The generator supports only chips with the expected ATDF shape.
- New generated files use the existing `GeneratedCodeFile` export path pattern.
- Register accessors use shared helpers where possible.
- Bitfield accessors use shared helpers where possible.
- Missing supplemental docs appear under a useful peripheral name in `logs.json`.
- Focused tests cover the new behavior.
- Generated output formats cleanly.
