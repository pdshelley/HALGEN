from __future__ import annotations

import argparse
import json
import sys
from collections import defaultdict
from pathlib import Path

from atdf_parser import (
    DEFAULT_ATDF_DIR,
    PIPELINE_ROOT,
    contiguous_groups,
    discover_atdf_paths,
    parse_atdf,
    relative_display_path,
)


DEFAULT_OUTPUT_DIR = PIPELINE_ROOT / "output" / "skeletons"


def longest_existing_prefix(name: str, known_names: set[str]) -> str | None:
    if not name or name[-1].isdigit() is False:
        return None

    for index in range(len(name) - 1, 0, -1):
        prefix = name[:index]
        if prefix in known_names:
            return prefix

    return None


def build_occurrences(parsed: dict[str, object]) -> list[dict[str, object]]:
    occurrences: list[dict[str, object]] = []
    for peripheral in parsed["peripherals"]:
        for register in peripheral["registers"]:
            for bitfield in register.get("bitfields", []):
                occurrences.append(
                    {
                        "peripheral": peripheral["name"],
                        "module": peripheral["module"],
                        "register": register["name"],
                        "name": bitfield["name"],
                        "caption": bitfield.get("caption"),
                        "mask": bitfield.get("mask"),
                        "bitPositions": bitfield.get("bitPositions", []),
                        "lsb": bitfield.get("lsb"),
                        "access": bitfield.get("access") or register.get("access"),
                        "isNonContiguous": bitfield.get("isNonContiguous", False),
                    }
                )
    return occurrences


def pages_to_components(
    occurrences: list[dict[str, object]],
) -> list[dict[str, object]]:
    return sorted(
        [
            {
                "bitfield": occurrence["name"],
                "register": occurrence["register"],
                "mask": occurrence["mask"],
                "bitPositions": occurrence["bitPositions"],
                "lsb": occurrence["lsb"],
            }
            for occurrence in occurrences
        ],
        key=lambda item: (item["register"], item["bitfield"], item["mask"] or ""),
    )


def detect_prefix_candidates(
    occurrences: list[dict[str, object]],
) -> list[dict[str, object]]:
    grouped_by_peripheral: dict[str, dict[str, list[dict[str, object]]]] = defaultdict(
        lambda: defaultdict(list)
    )
    for occurrence in occurrences:
        grouped_by_peripheral[occurrence["peripheral"]][occurrence["name"]].append(
            occurrence
        )

    candidates: list[dict[str, object]] = []

    for peripheral_name, names in grouped_by_peripheral.items():
        known_names = set(names)
        seen_keys: set[tuple[str, str]] = set()

        for name, name_occurrences in names.items():
            prefix = longest_existing_prefix(name, known_names)
            if prefix is None:
                continue

            candidate_key = (peripheral_name, prefix)
            if candidate_key in seen_keys:
                continue
            seen_keys.add(candidate_key)

            base_occurrences = names[prefix]
            related_occurrences = base_occurrences + name_occurrences
            registers = {occurrence["register"] for occurrence in related_occurrences}
            confidence = "high" if len(registers) > 1 else "medium"

            candidates.append(
                {
                    "peripheral": peripheral_name,
                    "module": related_occurrences[0]["module"],
                    "baseName": prefix,
                    "components": pages_to_components(related_occurrences),
                    "suggestedSplitTarget": prefix,
                    "confidence": confidence,
                    "reason": "A numbered suffix shares the same base name as another bitfield in the same peripheral.",
                }
            )

    return sorted(candidates, key=lambda item: (item["peripheral"], item["baseName"]))


def detect_banked_names(
    occurrences: list[dict[str, object]],
) -> list[dict[str, object]]:
    grouped: dict[str, list[dict[str, object]]] = defaultdict(list)
    for occurrence in occurrences:
        grouped[occurrence["name"]].append(occurrence)

    candidates: list[dict[str, object]] = []
    for name, name_occurrences in grouped.items():
        registers = {occurrence["register"] for occurrence in name_occurrences}
        lsbs = [
            occurrence["lsb"]
            for occurrence in name_occurrences
            if occurrence.get("lsb") is not None
        ]
        if len(registers) < 2 or not lsbs:
            continue

        candidates.append(
            {
                "name": name,
                "registers": sorted(registers),
                "lsbValues": sorted(lsbs),
                "confidence": "medium",
                "reason": "The same bitfield name appears in multiple registers with explicit lsb offsets.",
                "occurrences": pages_to_components(name_occurrences),
            }
        )

    return sorted(candidates, key=lambda item: item["name"])


def detect_non_contiguous_masks(
    occurrences: list[dict[str, object]],
) -> list[dict[str, object]]:
    candidates: list[dict[str, object]] = []
    for occurrence in occurrences:
        bit_positions = occurrence.get("bitPositions", [])
        if len(contiguous_groups(bit_positions)) <= 1:
            continue

        candidates.append(
            {
                "name": occurrence["name"],
                "peripheral": occurrence["peripheral"],
                "register": occurrence["register"],
                "mask": occurrence["mask"],
                "bitPositions": bit_positions,
                "confidence": "medium",
                "reason": "The bitfield mask is non-contiguous inside a single register.",
            }
        )

    return sorted(
        candidates,
        key=lambda item: (item["peripheral"], item["register"], item["name"]),
    )


def build_report(chip_name: str, atdf_path: Path) -> dict[str, object]:
    parsed = parse_atdf(atdf_path)
    occurrences = build_occurrences(parsed)
    return {
        "chip": chip_name,
        "atdf": relative_display_path(atdf_path),
        "splitBitfieldCandidates": detect_prefix_candidates(occurrences),
        "bankedBitfieldCandidates": detect_banked_names(occurrences),
        "nonContiguousBitfieldCandidates": detect_non_contiguous_masks(occurrences),
    }


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Detect split-bitfield candidates from ATDF files."
    )
    parser.add_argument("chip", nargs="?", help="Chip name, for example ATmega328P")
    parser.add_argument("--all", action="store_true", help="Process every ATDF file")
    parser.add_argument("--atdf", type=Path, help="Path to a single ATDF file")
    parser.add_argument(
        "--atdf-dir",
        type=Path,
        default=DEFAULT_ATDF_DIR,
        help="Directory containing ATDF files for --all mode",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help="Directory or file path for the report",
    )
    return parser


def resolve_output_path(output: Path, chip_name: str) -> Path:
    if output.suffix.lower() == ".json":
        return output
    return output / f"{chip_name}.split-bitfields.json"


def write_report(chip_name: str, atdf_path: Path, output_path: Path) -> None:
    payload = build_report(chip_name, atdf_path)
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
                write_report(chip_name, atdf_path, output_path)
                generated_count += 1
            except Exception as error:  # noqa: BLE001
                failures.append(
                    f"Failed to generate split-bitfield report for {relative_display_path(atdf_path)}: {error}"
                )

        print(
            f"Generated {generated_count} split-bitfield reports in {relative_display_path(args.output)}"
        )
        for failure in failures:
            print(failure, file=sys.stderr)
        return 1 if failures else 0

    if args.atdf is None and args.chip is None:
        parser.error("Provide a chip name, --atdf, or use --all.")

    chip_name = args.chip or args.atdf.stem
    atdf_path = args.atdf or (args.atdf_dir / f"{chip_name}.atdf")
    output_path = resolve_output_path(args.output, chip_name)

    write_report(chip_name, atdf_path, output_path)
    print(f"Wrote split-bitfield report to {relative_display_path(output_path)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
