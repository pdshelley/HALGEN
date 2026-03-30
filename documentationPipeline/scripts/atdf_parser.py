from __future__ import annotations

import argparse
import json
import re
import sys
import xml.etree.ElementTree as ET
from copy import deepcopy
from pathlib import Path


PIPELINE_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = PIPELINE_ROOT.parent
DEFAULT_ATDF_DIR = REPO_ROOT / "atdf"
DEFAULT_GENERAL_JSON = REPO_ROOT / "docs" / "general.json"


def collapse_whitespace(value: str | None) -> str:
    if value is None:
        return ""
    return " ".join(value.split())


def parse_numeric(value: str | None) -> int | None:
    if value is None or value == "":
        return None
    try:
        return int(value, 0)
    except ValueError:
        return None


def normalize_access(value: str | None) -> str | None:
    if value is None:
        return None

    compact = value.replace(" ", "").upper()
    if compact == "RW":
        return "R/W"
    if compact in {"R", "W", "R/W"}:
        return compact
    return value


def normalize_identifier(value: str) -> str:
    return re.sub(r"[^A-Za-z0-9]+", "", value).upper()


def chip_match_score(query: str, chip_name: str) -> tuple[int, int] | None:
    normalized_query = normalize_identifier(query)
    normalized_chip = normalize_identifier(chip_name)

    if not normalized_query or not normalized_chip:
        return None
    if normalized_query == normalized_chip:
        return (3, len(normalized_chip))
    if normalized_query.startswith(normalized_chip):
        return (2, len(normalized_chip))
    if normalized_chip in normalized_query:
        return (1, len(normalized_chip))
    return None


def match_chip_name(query: str, chip_names: list[str]) -> str | None:
    ranked_matches: list[tuple[int, int, str]] = []

    for chip_name in chip_names:
        score = chip_match_score(query, chip_name)
        if score is None:
            continue
        ranked_matches.append((score[0], score[1], chip_name))

    if not ranked_matches:
        return None

    ranked_matches.sort(key=lambda item: (item[0], item[1], item[2]), reverse=True)
    return ranked_matches[0][2]


def discover_atdf_paths(atdf_dir: Path = DEFAULT_ATDF_DIR) -> list[Path]:
    return sorted(path for path in atdf_dir.glob("*.atdf") if path.is_file())


def discover_pdf_paths(pdf_dir: Path) -> list[Path]:
    return sorted(path for path in pdf_dir.glob("*.pdf") if path.is_file())


def bits_from_value(
    value: int | None, width: int = 8, placeholder: str = "?"
) -> list[str]:
    if value is None:
        return [placeholder] * width
    return ["1" if value & (1 << bit) else "0" for bit in range(width - 1, -1, -1)]


def bit_positions_from_mask(mask_value: int | None) -> list[int]:
    if mask_value is None:
        return []
    return [bit for bit in range(mask_value.bit_length()) if mask_value & (1 << bit)]


def contiguous_groups(bit_positions: list[int]) -> list[list[int]]:
    if not bit_positions:
        return []

    ordered_positions = sorted(bit_positions)
    groups: list[list[int]] = [[ordered_positions[0]]]

    for bit in ordered_positions[1:]:
        if bit == groups[-1][-1] + 1:
            groups[-1].append(bit)
        else:
            groups.append([bit])

    return groups


def relative_display_path(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path.resolve())


def load_general_aliases(
    path: Path = DEFAULT_GENERAL_JSON,
) -> dict[str, dict[str, dict[str, object]]]:
    with path.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)

    register_aliases: dict[str, dict[str, object]] = {}
    bitfield_aliases: dict[str, dict[str, object]] = {}

    for entry in payload.get("registers", []):
        for alias in entry.get("aliases", []):
            register_aliases[alias] = deepcopy(entry)

    for entry in payload.get("bitfields", []):
        for alias in entry.get("aliases", []):
            bitfield_aliases[alias] = deepcopy(entry)

    return {
        "registers": register_aliases,
        "bitfields": bitfield_aliases,
    }


def parse_signal(node: ET.Element) -> dict[str, object]:
    return {
        "group": node.attrib.get("group", ""),
        "function": node.attrib.get("function", ""),
        "pad": node.attrib.get("pad", ""),
        "index": parse_numeric(node.attrib.get("index")),
    }


def parse_value(node: ET.Element) -> dict[str, object]:
    raw_value = node.attrib.get("value", "")
    return {
        "name": node.attrib.get("name", ""),
        "caption": collapse_whitespace(node.attrib.get("caption")),
        "value": raw_value,
        "valueInt": parse_numeric(raw_value),
    }


def parse_value_group(node: ET.Element) -> dict[str, object]:
    return {
        "name": node.attrib.get("name", ""),
        "caption": collapse_whitespace(node.attrib.get("caption")),
        "values": [parse_value(value_node) for value_node in node.findall("value")],
    }


def parse_mode(node: ET.Element) -> dict[str, object]:
    return {
        "name": node.attrib.get("name", ""),
        "qualifier": node.attrib.get("qualifier", ""),
        "value": node.attrib.get("value", ""),
    }


def parse_bitfield(node: ET.Element) -> dict[str, object]:
    raw_mask = node.attrib.get("mask")
    mask_value = parse_numeric(raw_mask)
    bit_positions = bit_positions_from_mask(mask_value)

    return {
        "name": node.attrib.get("name", ""),
        "caption": collapse_whitespace(node.attrib.get("caption")),
        "mask": raw_mask,
        "maskInt": mask_value,
        "bitPositions": bit_positions,
        "width": len(bit_positions),
        "lsb": parse_numeric(node.attrib.get("lsb")),
        "values": node.attrib.get("values"),
        "access": normalize_access(node.attrib.get("rw")),
        "modes": node.attrib.get("modes"),
        "isNonContiguous": len(contiguous_groups(bit_positions)) > 1,
    }


def parse_register(node: ET.Element) -> dict[str, object]:
    raw_mask = node.attrib.get("mask")
    raw_init_value = node.attrib.get("initval")

    register = {
        "name": node.attrib.get("name", ""),
        "offset": node.attrib.get("offset", ""),
        "size": parse_numeric(node.attrib.get("size")) or 1,
        "caption": collapse_whitespace(node.attrib.get("caption")),
        "mask": raw_mask,
        "maskInt": parse_numeric(raw_mask),
        "initValue": raw_init_value,
        "initValueInt": parse_numeric(raw_init_value),
        "access": normalize_access(node.attrib.get("rw") or node.attrib.get("ocd-rw")),
        "rw": normalize_access(node.attrib.get("rw")),
        "ocdRw": normalize_access(node.attrib.get("ocd-rw")),
        "modes": node.attrib.get("modes"),
        "bitAddressable": node.attrib.get("bit-addressable"),
        "bitfields": [
            parse_bitfield(bitfield_node) for bitfield_node in node.findall("bitfield")
        ],
        "modeOverrides": [parse_mode(mode_node) for mode_node in node.findall("mode")],
    }
    return register


def parse_register_group(node: ET.Element) -> dict[str, object]:
    return {
        "name": node.attrib.get("name", ""),
        "caption": collapse_whitespace(node.attrib.get("caption")),
        "size": parse_numeric(node.attrib.get("size")),
        "registers": [
            parse_register(register_node) for register_node in node.findall("register")
        ],
        "modeOverrides": [parse_mode(mode_node) for mode_node in node.findall("mode")],
    }


def parse_module_definition(node: ET.Element) -> dict[str, object]:
    register_groups = [
        parse_register_group(group_node)
        for group_node in node.findall("register-group")
    ]
    value_groups = [
        parse_value_group(group_node) for group_node in node.findall("value-group")
    ]

    return {
        "name": node.attrib.get("name", ""),
        "caption": collapse_whitespace(node.attrib.get("caption")),
        "id": node.attrib.get("id"),
        "registerGroups": {group["name"]: group for group in register_groups},
        "valueGroups": {group["name"]: group for group in value_groups},
    }


def build_module_index(root: ET.Element) -> dict[str, dict[str, object]]:
    modules_root = root.find("modules")
    if modules_root is None:
        return {}

    return {
        module["name"]: module
        for module in (
            parse_module_definition(module_node)
            for module_node in modules_root.findall("module")
        )
    }


def parse_device_peripherals(device_node: ET.Element) -> list[dict[str, object]]:
    instances: list[dict[str, object]] = []
    peripherals_root = device_node.find("peripherals")
    if peripherals_root is None:
        return instances

    for module_node in peripherals_root.findall("module"):
        module_name = module_node.attrib.get("name", "")
        for instance_node in module_node.findall("instance"):
            register_group = instance_node.find("register-group")
            instances.append(
                {
                    "module": module_name,
                    "name": instance_node.attrib.get("name", ""),
                    "caption": collapse_whitespace(instance_node.attrib.get("caption")),
                    "registerGroupName": register_group.attrib.get("name", "")
                    if register_group is not None
                    else "",
                    "registerGroupNameInModule": register_group.attrib.get(
                        "name-in-module", ""
                    )
                    if register_group is not None
                    else "",
                    "registerGroupCaption": collapse_whitespace(
                        register_group.attrib.get("caption")
                    )
                    if register_group is not None
                    else "",
                    "registerGroupOffset": register_group.attrib.get("offset", "")
                    if register_group is not None
                    else "",
                    "addressSpace": register_group.attrib.get("address-space", "")
                    if register_group is not None
                    else "",
                    "signals": [
                        parse_signal(signal_node)
                        for signal_node in instance_node.findall("./signals/signal")
                    ],
                }
            )

    return instances


def parse_atdf(path: Path | str) -> dict[str, object]:
    atdf_path = Path(path)
    root = ET.parse(atdf_path).getroot()

    device_node = root.find("./devices/device")
    if device_node is None:
        raise ValueError(f"No <device> definition found in {atdf_path}")

    module_index = build_module_index(root)
    peripheral_instances = parse_device_peripherals(device_node)
    peripherals: list[dict[str, object]] = []

    for instance in peripheral_instances:
        module_name = instance["module"]
        register_group_key = (
            instance["registerGroupNameInModule"] or instance["registerGroupName"]
        )
        module_definition = module_index.get(module_name, {})
        register_groups = module_definition.get("registerGroups", {})
        register_group = register_groups.get(register_group_key) or register_groups.get(
            instance["registerGroupName"], {}
        )
        registers = deepcopy(register_group.get("registers", []))

        referenced_value_groups = sorted(
            {
                bitfield["values"]
                for register in registers
                for bitfield in register.get("bitfields", [])
                if bitfield.get("values")
            }
        )

        value_groups = {
            value_group_name: deepcopy(
                module_definition["valueGroups"][value_group_name]
            )
            for value_group_name in referenced_value_groups
            if value_group_name in module_definition.get("valueGroups", {})
        }

        peripherals.append(
            {
                "name": instance["name"],
                "module": module_name,
                "caption": instance["caption"] or register_group.get("caption", ""),
                "addressSpace": instance["addressSpace"],
                "registerGroup": {
                    "name": instance["registerGroupName"],
                    "nameInModule": instance["registerGroupNameInModule"],
                    "caption": instance["registerGroupCaption"]
                    or register_group.get("caption", ""),
                    "offset": instance["registerGroupOffset"],
                },
                "signals": deepcopy(instance["signals"]),
                "registers": registers,
                "valueGroups": value_groups,
            }
        )

    return {
        "chip": device_node.attrib.get("name", atdf_path.stem),
        "architecture": device_node.attrib.get("architecture", ""),
        "family": device_node.attrib.get("family", ""),
        "source": relative_display_path(atdf_path),
        "peripherals": peripherals,
        "modules": sorted(module_index.keys()),
    }


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Parse AVR ATDF files into JSON.")
    parser.add_argument(
        "atdf",
        nargs="?",
        type=Path,
        help="Path to a single ATDF file",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Parse every ATDF file in the ATDF directory",
    )
    parser.add_argument(
        "--atdf-dir",
        type=Path,
        default=DEFAULT_ATDF_DIR,
        help="Directory containing ATDF files for --all mode",
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Write JSON to this file or directory instead of stdout",
    )
    parser.add_argument("--compact", action="store_true", help="Emit compact JSON")
    return parser


def write_single_payload(
    payload: dict[str, object], output: Path | None, indent: int | None
) -> None:
    if output is None:
        json.dump(payload, sys.stdout, indent=indent)
        sys.stdout.write("\n")
        return

    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("w", encoding="utf-8") as handle:
        json.dump(payload, handle, indent=indent)
        handle.write("\n")


def write_batch_payloads(
    payloads: list[dict[str, object]], output: Path | None, indent: int | None
) -> None:
    combined_payload = {payload["chip"]: payload for payload in payloads}

    if output is None:
        json.dump(combined_payload, sys.stdout, indent=indent)
        sys.stdout.write("\n")
        return

    if output.suffix.lower() == ".json":
        output.parent.mkdir(parents=True, exist_ok=True)
        with output.open("w", encoding="utf-8") as handle:
            json.dump(combined_payload, handle, indent=indent)
            handle.write("\n")
        return

    output.mkdir(parents=True, exist_ok=True)
    for payload in payloads:
        chip_name = payload["chip"]
        output_path = output / f"{chip_name}.json"
        with output_path.open("w", encoding="utf-8") as handle:
            json.dump(payload, handle, indent=indent)
            handle.write("\n")


def main() -> int:
    parser = build_argument_parser()
    args = parser.parse_args()
    indent = None if args.compact else 2

    if args.all:
        if args.atdf is not None:
            parser.error("Do not pass a single ATDF path when using --all.")

        atdf_paths = discover_atdf_paths(args.atdf_dir)
        if not atdf_paths:
            print(
                f"No ATDF files found in {relative_display_path(args.atdf_dir)}",
                file=sys.stderr,
            )
            return 0

        payloads: list[dict[str, object]] = []
        failures: list[str] = []

        for atdf_path in atdf_paths:
            try:
                payloads.append(parse_atdf(atdf_path))
            except Exception as error:  # noqa: BLE001
                failures.append(
                    f"Failed to parse {relative_display_path(atdf_path)}: {error}"
                )

        write_batch_payloads(payloads, args.output, indent)
        print(
            f"Parsed {len(payloads)} ATDF files from {relative_display_path(args.atdf_dir)}",
            file=sys.stderr,
        )

        for failure in failures:
            print(failure, file=sys.stderr)

        return 1 if failures else 0

    if args.atdf is None:
        parser.error("Provide an ATDF path or use --all.")

    payload = parse_atdf(args.atdf)
    write_single_payload(payload, args.output, indent)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
