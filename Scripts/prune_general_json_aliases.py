#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class Removal:
    section: str
    variable_name: str
    alias: str
    removed_entry: bool


def parse_arguments() -> argparse.Namespace:
    repo_root = Path(__file__).resolve().parent.parent
    parser = argparse.ArgumentParser(
        description="Remove stale aliases from docs/general.json using current ATDF files."
    )
    parser.add_argument(
        "--repo-root",
        type=Path,
        default=repo_root,
        help="Repository root. Defaults to the parent of this script.",
    )
    parser.add_argument(
        "--atdf-dir",
        type=Path,
        help="ATDF directory. Defaults to <repo-root>/atdf.",
    )
    parser.add_argument(
        "--general-json",
        type=Path,
        help="Path to general.json. Defaults to <repo-root>/docs/general.json.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print removals without writing docs/general.json.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_arguments()

    repo_root = args.repo_root.resolve()
    atdf_dir = (args.atdf_dir or repo_root / "atdf").resolve()
    general_json_path = (
        args.general_json or repo_root / "docs" / "general.json"
    ).resolve()

    ensure_exists(atdf_dir, "ATDF directory")
    ensure_exists(general_json_path, "general.json")

    general_documentation = load_json(general_json_path)
    atdf_names = collect_atdf_names(atdf_dir)

    removals = prune_aliases(general_documentation, atdf_names)

    if removals and args.dry_run is False:
        general_json_path.write_text(
            json.dumps(general_documentation, indent=4) + "\n",
            encoding="utf-8",
        )

    print_removals(removals, dry_run=args.dry_run)

    return 0


def ensure_exists(path: Path, description: str) -> None:
    if path.exists() is False:
        raise SystemExit(f"{description} does not exist: {path}")


def load_json(path: Path) -> dict[str, object]:
    with path.open(encoding="utf-8") as file_handle:
        return json.load(file_handle)


def collect_atdf_names(atdf_dir: Path) -> dict[str, set[str]]:
    register_names: set[str] = set()
    bitfield_names: set[str] = set()
    atdf_paths = sorted(atdf_dir.glob("*.atdf"))

    if atdf_paths == []:
        raise SystemExit(f"No ATDF files found in: {atdf_dir}")

    for path in atdf_paths:
        root = ET.parse(path).getroot()

        for register in root.findall(".//register"):
            name = register.get("name")
            if name:
                register_names.add(name)

        for bitfield in root.findall(".//bitfield"):
            name = bitfield.get("name")
            if name:
                bitfield_names.add(name)

    return {
        "registers": register_names,
        "bitfields": bitfield_names,
    }


def prune_aliases(
    general_documentation: dict[str, object],
    atdf_names: dict[str, set[str]],
) -> list[Removal]:
    removals: list[Removal] = []

    for section in ("registers", "bitfields"):
        entries = general_documentation.get(section)
        if isinstance(entries, list) is False:
            continue

        kept_entries: list[dict[str, object]] = []
        known_names = atdf_names[section]

        for entry in entries:
            if isinstance(entry, dict) is False:
                continue

            aliases = entry.get("aliases")
            variable_name = str(entry.get("variableName", ""))
            if isinstance(aliases, list) is False:
                kept_entries.append(entry)
                continue

            kept_aliases: list[str] = []
            removed_aliases: list[str] = []

            for alias in aliases:
                alias_name = str(alias)
                if alias_name in known_names:
                    kept_aliases.append(alias_name)
                else:
                    removed_aliases.append(alias_name)

            if kept_aliases:
                if removed_aliases:
                    updated_entry = dict(entry)
                    updated_entry["aliases"] = kept_aliases
                    kept_entries.append(updated_entry)
                else:
                    kept_entries.append(entry)
            for alias_name in removed_aliases:
                removals.append(
                    Removal(
                        section=section,
                        variable_name=variable_name,
                        alias=alias_name,
                        removed_entry=not kept_aliases,
                    )
                )

        general_documentation[section] = kept_entries

    return removals


def print_removals(removals: list[Removal], dry_run: bool) -> None:
    if not removals:
        print("No stale aliases found.")
        return

    prefix = "Would remove" if dry_run else "Removed"

    for removal in removals:
        target = "entry" if removal.removed_entry else "alias"
        print(
            f"{prefix} {target}: section={removal.section} "
            f"variableName={removal.variable_name} alias={removal.alias}"
        )


if __name__ == "__main__":
    sys.exit(main())
