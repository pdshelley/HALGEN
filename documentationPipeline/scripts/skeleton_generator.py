from __future__ import annotations

import argparse
import json
import sys
from collections import OrderedDict
from pathlib import Path

from atdf_parser import (
    DEFAULT_ATDF_DIR,
    DEFAULT_GENERAL_JSON,
    PIPELINE_ROOT,
    bits_from_value,
    discover_atdf_paths,
    discover_pdf_paths,
    load_general_aliases,
    match_chip_name,
    parse_atdf,
    relative_display_path,
)


DEFAULT_OUTPUT_DIR = PIPELINE_ROOT / "output" / "skeletons"
DEFAULT_DATASHEET_DIR = PIPELINE_ROOT / "datasheets"


def find_datasheet_path(chip_name: str, datasheet_dir: Path) -> Path | None:
    exact_prefix_matches = sorted(datasheet_dir.glob(f"{chip_name}*.pdf"))
    if exact_prefix_matches:
        return exact_prefix_matches[0]

    for pdf_path in discover_pdf_paths(datasheet_dir):
        if match_chip_name(pdf_path.stem, [chip_name]) == chip_name:
            return pdf_path

    return None


def infer_datasheet_reference(chip_name: str, datasheet_dir: Path) -> str:
    match = find_datasheet_path(chip_name, datasheet_dir)
    if match is not None:
        return f"{match.stem} (TODO reference)"
    return "TODO: Add datasheet reference"


def initial_value_fields(register: dict[str, object]) -> dict[str, list[str]]:
    size = int(register.get("size", 1))
    init_value = register.get("initValueInt")
    numeric_value = init_value if isinstance(init_value, int) else None

    if size == 1:
        return {"initialValues": bits_from_value(numeric_value, width=8)}

    if size == 2:
        low_byte = numeric_value & 0xFF if numeric_value is not None else None
        high_byte = (numeric_value >> 8) & 0xFF if numeric_value is not None else None
        return {
            "initialValuesL": bits_from_value(low_byte, width=8),
            "initialValuesH": bits_from_value(high_byte, width=8),
        }

    return {}


def make_general_meta(
    entry: dict[str, object] | None, include_inline: bool = False
) -> dict[str, object] | None:
    if entry is None:
        return None

    payload = {
        "variableName": entry.get("variableName"),
        "valueType": entry.get("valueType"),
        "defaultValue": entry.get("defaultValue"),
        "access": entry.get("access"),
    }

    if include_inline:
        payload["inline"] = entry.get("inline")

    return {key: value for key, value in payload.items() if value not in (None, "")}


def make_register_occurrence(
    peripheral: dict[str, object], register: dict[str, object]
) -> dict[str, object]:
    return {
        "peripheral": peripheral["name"],
        "module": peripheral["module"],
        "registerGroup": peripheral["registerGroup"]["nameInModule"]
        or peripheral["registerGroup"]["name"],
        "offset": register.get("offset"),
        "caption": register.get("caption"),
        "access": register.get("access"),
        "size": register.get("size"),
    }


def make_bitfield_occurrence(
    peripheral: dict[str, object],
    register: dict[str, object],
    bitfield: dict[str, object],
) -> dict[str, object]:
    return {
        "peripheral": peripheral["name"],
        "module": peripheral["module"],
        "register": register["name"],
        "caption": bitfield.get("caption"),
        "mask": bitfield.get("mask"),
        "bitPositions": bitfield.get("bitPositions", []),
        "lsb": bitfield.get("lsb"),
        "access": bitfield.get("access") or register.get("access"),
    }


def build_skeleton(
    chip_name: str,
    atdf_path: Path,
    general_json_path: Path,
    datasheet_dir: Path,
) -> dict[str, object]:
    parsed = parse_atdf(atdf_path)
    general_aliases = load_general_aliases(general_json_path)

    registers: OrderedDict[str, dict[str, object]] = OrderedDict()
    bitfields: OrderedDict[str, dict[str, object]] = OrderedDict()

    for peripheral in parsed["peripherals"]:
        value_groups = peripheral.get("valueGroups", {})
        for register in peripheral["registers"]:
            register_name = register["name"]
            general_register = general_aliases["registers"].get(register_name)

            if register_name not in registers:
                register_entry: dict[str, object] = {"documentation": []}
                register_entry.update(initial_value_fields(register))

                if int(register.get("size", 1)) == 2:
                    register_entry["documentationL"] = []
                    register_entry["documentationH"] = []

                register_entry["_meta"] = {
                    "caption": register.get("caption"),
                    "size": register.get("size"),
                    "mask": register.get("mask"),
                    "access": register.get("access"),
                    "bitfields": [
                        bitfield["name"] for bitfield in register.get("bitfields", [])
                    ],
                    "generalMatch": general_register is not None,
                    "generalEntry": make_general_meta(general_register),
                    "peripherals": [peripheral["name"]],
                    "occurrences": [make_register_occurrence(peripheral, register)],
                }
                registers[register_name] = register_entry
            else:
                register_meta = registers[register_name]["_meta"]
                register_meta["peripherals"] = sorted(
                    set(register_meta["peripherals"] + [peripheral["name"]])
                )
                register_meta["occurrences"].append(
                    make_register_occurrence(peripheral, register)
                )
                if general_register is not None:
                    register_meta["generalMatch"] = True
                    register_meta["generalEntry"] = make_general_meta(general_register)

            for bitfield in register.get("bitfields", []):
                bitfield_name = bitfield["name"]
                general_bitfield = general_aliases["bitfields"].get(bitfield_name)

                if bitfield_name not in bitfields:
                    bitfield_entry: dict[str, object] = {"documentation": []}
                    bitfield_entry["_meta"] = {
                        "caption": bitfield.get("caption"),
                        "mask": bitfield.get("mask"),
                        "bitPositions": bitfield.get("bitPositions", []),
                        "isNonContiguous": bitfield.get("isNonContiguous", False),
                        "valueGroup": bitfield.get("values"),
                        "valueOptions": value_groups.get(
                            bitfield.get("values"), {}
                        ).get("values", [])
                        if bitfield.get("values")
                        else [],
                        "generalMatch": general_bitfield is not None,
                        "generalEntry": make_general_meta(
                            general_bitfield, include_inline=True
                        ),
                        "registers": [register_name],
                        "peripherals": [peripheral["name"]],
                        "occurrences": [
                            make_bitfield_occurrence(peripheral, register, bitfield)
                        ],
                    }
                    bitfields[bitfield_name] = bitfield_entry
                else:
                    bitfield_meta = bitfields[bitfield_name]["_meta"]
                    bitfield_meta["registers"] = sorted(
                        set(bitfield_meta["registers"] + [register_name])
                    )
                    bitfield_meta["peripherals"] = sorted(
                        set(bitfield_meta["peripherals"] + [peripheral["name"]])
                    )
                    bitfield_meta["occurrences"].append(
                        make_bitfield_occurrence(peripheral, register, bitfield)
                    )
                    if general_bitfield is not None:
                        bitfield_meta["generalMatch"] = True
                        bitfield_meta["generalEntry"] = make_general_meta(
                            general_bitfield, include_inline=True
                        )

    ordered_registers = OrderedDict(
        (name, registers[name]) for name in sorted(registers)
    )
    ordered_bitfields = OrderedDict(
        (name, bitfields[name]) for name in sorted(bitfields)
    )

    return {
        "chip": chip_name,
        "datasheet": infer_datasheet_reference(chip_name, datasheet_dir),
        "registers": ordered_registers,
        "bitfields": ordered_bitfields,
        "_meta": {
            "generatedBy": "documentationPipeline/scripts/skeleton_generator.py",
            "atdf": relative_display_path(atdf_path),
            "generalJson": relative_display_path(general_json_path),
            "registerCount": len(ordered_registers),
            "bitfieldCount": len(ordered_bitfields),
            "peripherals": [
                {
                    "name": peripheral["name"],
                    "module": peripheral["module"],
                    "caption": peripheral["caption"],
                    "registerCount": len(peripheral["registers"]),
                }
                for peripheral in parsed["peripherals"]
            ],
        },
    }


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Generate chip documentation skeletons from ATDF files."
    )
    parser.add_argument("chip", nargs="?", help="Chip name, for example ATmega328P")
    parser.add_argument(
        "--all", action="store_true", help="Generate skeletons for every ATDF file"
    )
    parser.add_argument("--atdf", type=Path, help="Path to a single ATDF file")
    parser.add_argument(
        "--atdf-dir",
        type=Path,
        default=DEFAULT_ATDF_DIR,
        help="Directory containing ATDF files for --all mode",
    )
    parser.add_argument(
        "--datasheet-dir",
        type=Path,
        default=DEFAULT_DATASHEET_DIR,
        help="Directory containing datasheet PDFs used for reference hints",
    )
    parser.add_argument(
        "--general-json",
        type=Path,
        default=DEFAULT_GENERAL_JSON,
        help="Path to docs/general.json",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help="Directory or file path for the generated skeletons",
    )
    return parser


def resolve_output_path(output: Path, chip_name: str) -> Path:
    if output.suffix.lower() == ".json":
        return output
    return output / f"{chip_name}.json"


def write_skeleton(
    chip_name: str,
    atdf_path: Path,
    general_json_path: Path,
    datasheet_dir: Path,
    output_path: Path,
) -> None:
    payload = build_skeleton(chip_name, atdf_path, general_json_path, datasheet_dir)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with output_path.open("w", encoding="utf-8") as handle:
        json.dump(payload, handle, indent=2)
        handle.write("\n")


def main() -> int:
    parser = build_argument_parser()
    args = parser.parse_args()

    if args.all:
        if args.chip is not None or args.atdf is not None:
            parser.error("Do not pass chip or --atdf when using --all.")
        if args.output.suffix.lower() == ".json":
            parser.error("--output must be a directory when using --all.")

        atdf_paths = discover_atdf_paths(args.atdf_dir)
        if not atdf_paths:
            print(
                f"No ATDF files found in {relative_display_path(args.atdf_dir)}",
                file=sys.stderr,
            )
            return 0

        failures: list[str] = []
        generated_count = 0

        for atdf_path in atdf_paths:
            chip_name = atdf_path.stem
            output_path = resolve_output_path(args.output, chip_name)

            try:
                write_skeleton(
                    chip_name,
                    atdf_path,
                    args.general_json,
                    args.datasheet_dir,
                    output_path,
                )
                generated_count += 1
            except Exception as error:  # noqa: BLE001
                failures.append(
                    f"Failed to generate skeleton for {relative_display_path(atdf_path)}: {error}"
                )

        print(
            f"Generated {generated_count} skeletons in {relative_display_path(args.output)}"
        )
        for failure in failures:
            print(failure, file=sys.stderr)
        return 1 if failures else 0

    if args.atdf is None and args.chip is None:
        parser.error("Provide a chip name, --atdf, or use --all.")

    chip_name = args.chip or args.atdf.stem
    atdf_path = args.atdf or (args.atdf_dir / f"{chip_name}.atdf")
    output_path = resolve_output_path(args.output, chip_name)

    write_skeleton(
        chip_name,
        atdf_path,
        args.general_json,
        args.datasheet_dir,
        output_path,
    )
    print(f"Wrote skeleton to {relative_display_path(output_path)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
