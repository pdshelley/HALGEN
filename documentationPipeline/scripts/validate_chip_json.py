from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from atdf_parser import (
    DEFAULT_ATDF_DIR,
    PIPELINE_ROOT,
    parse_atdf,
    relative_display_path,
)


DEFAULT_SCHEMA_PATH = PIPELINE_ROOT / "config" / "schema.json"
PLACEHOLDER_MARKERS = ("TODO", "TBD", "???")


def strip_internal_keys(value: object) -> object:
    if isinstance(value, dict):
        return {
            key: strip_internal_keys(item)
            for key, item in value.items()
            if not key.startswith("_")
        }
    if isinstance(value, list):
        return [strip_internal_keys(item) for item in value]
    return value


def load_json(path: Path) -> dict[str, object]:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def validate_schema(document: dict[str, object], schema_path: Path) -> list[str]:
    try:
        from jsonschema import Draft202012Validator
    except ImportError as error:  # pragma: no cover - dependency error path
        raise RuntimeError(
            "jsonschema is required for validation. Install documentationPipeline/requirements.txt first."
        ) from error

    schema = load_json(schema_path)
    validator = Draft202012Validator(schema)
    errors: list[str] = []
    for error in sorted(
        validator.iter_errors(document), key=lambda item: list(item.path)
    ):
        json_path = ".".join(str(part) for part in error.path) or "<root>"
        errors.append(f"{json_path}: {error.message}")
    return errors


def contains_placeholder(value: str) -> bool:
    return any(marker in value for marker in PLACEHOLDER_MARKERS)


def check_string_fields(
    mapping: dict[str, object],
    path: str,
    warnings: list[str],
    errors: list[str],
    draft: bool,
) -> None:
    for key, value in mapping.items():
        if isinstance(value, str):
            if value.strip() == "":
                warnings.append(f"{path}.{key} is blank")
            if contains_placeholder(value):
                message = f"{path}.{key} still contains a placeholder"
                if draft:
                    warnings.append(message)
                else:
                    errors.append(message)
        elif isinstance(value, list):
            for index, item in enumerate(value):
                if isinstance(item, str) and contains_placeholder(item):
                    message = f"{path}.{key}[{index}] still contains a placeholder"
                    if draft:
                        warnings.append(message)
                    else:
                        errors.append(message)


def check_documentation_presence(
    registers: dict[str, object],
    bitfields: dict[str, object],
    errors: list[str],
    warnings: list[str],
    draft: bool,
) -> None:
    for register_name, register in registers.items():
        documentation_fields = [
            register.get("documentation"),
            register.get("documentationL"),
            register.get("documentationH"),
        ]
        has_docs = any(
            isinstance(field, list) and len(field) > 0 for field in documentation_fields
        )
        if not has_docs:
            message = f"register {register_name} is missing documentation"
            if draft:
                warnings.append(message)
            else:
                errors.append(message)

    for bitfield_name, bitfield in bitfields.items():
        documentation = bitfield.get("documentation")
        has_docs = isinstance(documentation, list) and len(documentation) > 0
        if not has_docs:
            message = f"bitfield {bitfield_name} is missing documentation"
            if draft:
                warnings.append(message)
            else:
                errors.append(message)


def check_initial_values(
    registers: dict[str, object], errors: list[str], warnings: list[str], draft: bool
) -> None:
    for register_name, register in registers.items():
        for key in ("initialValues", "initialValuesL", "initialValuesH"):
            if key not in register:
                continue
            values = register[key]
            if not isinstance(values, list):
                continue
            if any(value == "?" for value in values):
                message = f"register {register_name} has unresolved {key} placeholders"
                if draft:
                    warnings.append(message)
                else:
                    errors.append(message)


def check_split_targets(bitfields: dict[str, object], errors: list[str]) -> None:
    known_bitfields = set(bitfields)
    for bitfield_name, bitfield in bitfields.items():
        split_target = bitfield.get("splitTarget")
        if split_target and split_target not in known_bitfields:
            errors.append(
                f"bitfield {bitfield_name} references unknown splitTarget {split_target}"
            )


def build_atdf_index(
    parsed: dict[str, object],
) -> tuple[dict[str, dict[str, object]], dict[str, dict[str, object]]]:
    registers: dict[str, dict[str, object]] = {}
    bitfields: dict[str, dict[str, object]] = {}

    for peripheral in parsed["peripherals"]:
        for register in peripheral["registers"]:
            register_entry = registers.setdefault(
                register["name"],
                {
                    "size": register.get("size"),
                    "occurrences": [],
                },
            )
            register_entry["occurrences"].append(
                {
                    "peripheral": peripheral["name"],
                    "register": register["name"],
                }
            )

            for bitfield in register.get("bitfields", []):
                bitfield_entry = bitfields.setdefault(
                    bitfield["name"], {"occurrences": []}
                )
                bitfield_entry["occurrences"].append(
                    {
                        "peripheral": peripheral["name"],
                        "register": register["name"],
                    }
                )

    return registers, bitfields


def compare_with_atdf(
    document: dict[str, object], atdf_path: Path, errors: list[str], warnings: list[str]
) -> None:
    parsed = parse_atdf(atdf_path)
    expected_registers, expected_bitfields = build_atdf_index(parsed)

    document_registers = document.get("registers", {})
    document_bitfields = document.get("bitfields", {})

    missing_registers = sorted(set(expected_registers) - set(document_registers))
    extra_registers = sorted(set(document_registers) - set(expected_registers))
    missing_bitfields = sorted(set(expected_bitfields) - set(document_bitfields))
    extra_bitfields = sorted(set(document_bitfields) - set(expected_bitfields))

    for name in missing_registers:
        errors.append(
            f"register {name} exists in the ATDF but is missing from the JSON"
        )
    for name in missing_bitfields:
        errors.append(
            f"bitfield {name} exists in the ATDF but is missing from the JSON"
        )
    for name in extra_registers:
        warnings.append(f"register {name} exists in JSON but not in the ATDF")
    for name in extra_bitfields:
        warnings.append(f"bitfield {name} exists in JSON but not in the ATDF")


def order_mapping(
    mapping: dict[str, object], key_order: list[str]
) -> dict[str, object]:
    ordered: dict[str, object] = {}
    for key in key_order:
        if key in mapping:
            ordered[key] = mapping[key]
    for key in mapping:
        if key not in ordered:
            ordered[key] = mapping[key]
    return ordered


def normalize_document(document: dict[str, object]) -> dict[str, object]:
    normalized: dict[str, object] = {
        "chip": document["chip"],
        "datasheet": document["datasheet"],
        "registers": {},
        "bitfields": {},
    }

    register_order = [
        "variableName",
        "valueType",
        "defaultValue",
        "access",
        "documentation",
        "documentationL",
        "documentationH",
        "initialValues",
        "initialValuesL",
        "initialValuesH",
        "bitfields",
        "overrideGeneratedDocumentation",
    ]
    bitfield_order = [
        "variableName",
        "valueType",
        "defaultValue",
        "access",
        "documentation",
        "inline",
        "splitTarget",
        "overrideGeneratedDocumentation",
    ]

    for register_name in sorted(document.get("registers", {})):
        normalized["registers"][register_name] = order_mapping(
            document["registers"][register_name], register_order
        )

    for bitfield_name in sorted(document.get("bitfields", {})):
        normalized["bitfields"][bitfield_name] = order_mapping(
            document["bitfields"][bitfield_name], bitfield_order
        )

    return normalized


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Validate a chip documentation JSON file."
    )
    parser.add_argument("json_file", type=Path, help="Path to the chip JSON file")
    parser.add_argument(
        "--schema",
        type=Path,
        default=DEFAULT_SCHEMA_PATH,
        help="Path to the validation schema",
    )
    parser.add_argument(
        "--atdf", type=Path, help="Path to the ATDF file for completeness checks"
    )
    parser.add_argument("--chip", help="Chip name used to infer the ATDF path")
    parser.add_argument(
        "--draft",
        action="store_true",
        help="Allow placeholders and incomplete docs as warnings",
    )
    parser.add_argument(
        "--write-clean",
        type=Path,
        help="Write a clean, metadata-free JSON file to this path",
    )
    return parser


def main() -> int:
    parser = build_argument_parser()
    args = parser.parse_args()

    raw_document = load_json(args.json_file)
    clean_document = strip_internal_keys(raw_document)
    if not isinstance(clean_document, dict):
        print("The root JSON value must be an object.", file=sys.stderr)
        return 1

    errors: list[str] = []
    warnings: list[str] = []

    try:
        errors.extend(validate_schema(clean_document, args.schema))
    except RuntimeError as error:
        print(error, file=sys.stderr)
        return 1

    registers = clean_document.get("registers", {})
    bitfields = clean_document.get("bitfields", {})
    if not isinstance(registers, dict) or not isinstance(bitfields, dict):
        errors.append("registers and bitfields must both be JSON objects")
    else:
        for register_name, register in registers.items():
            if isinstance(register, dict):
                check_string_fields(
                    register, f"registers.{register_name}", warnings, errors, args.draft
                )
        for bitfield_name, bitfield in bitfields.items():
            if isinstance(bitfield, dict):
                check_string_fields(
                    bitfield, f"bitfields.{bitfield_name}", warnings, errors, args.draft
                )

        check_documentation_presence(registers, bitfields, errors, warnings, args.draft)
        check_initial_values(registers, errors, warnings, args.draft)
        check_split_targets(bitfields, errors)

    atdf_path = args.atdf
    if atdf_path is None and args.chip:
        atdf_path = DEFAULT_ATDF_DIR / f"{args.chip}.atdf"
    if atdf_path is not None:
        compare_with_atdf(clean_document, atdf_path, errors, warnings)

    if errors:
        print(
            f"Validation failed for {relative_display_path(args.json_file)}",
            file=sys.stderr,
        )
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
    else:
        print(f"Validation passed for {relative_display_path(args.json_file)}")

    for warning in warnings:
        print(f"WARNING: {warning}", file=sys.stderr)

    if args.write_clean and not errors:
        normalized = normalize_document(clean_document)
        args.write_clean.parent.mkdir(parents=True, exist_ok=True)
        with args.write_clean.open("w", encoding="utf-8") as handle:
            json.dump(normalized, handle, indent=4)
            handle.write("\n")
        print(f"Wrote clean JSON to {relative_display_path(args.write_clean)}")

    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
