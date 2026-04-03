#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import re
import sys
import xml.etree.ElementTree as ET
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from pathlib import Path


DROP_WORDS = {"the", "with", "shared", "module", "only"}
TOKEN_REPLACEMENTS = {
    "mux": "multiplexer",
    "satrt": "start",
    "lenght": "length",
    "ouput": "output",
    "noice": "noise",
    "canceller": "canceler",
}
TRAILING_WORDS = {
    "registers": {"byte", "bytes"},
    "bitfields": {"bit", "bits", "byte", "bytes", "register"},
}
FALLBACK_PERIPHERAL_NAME = "Uncategorized"


@dataclass
class AliasObservation:
    occurrences: int = 0
    chips: set[str] = field(default_factory=set)
    captions: Counter[str] = field(default_factory=Counter)
    suggested_names: Counter[str] = field(default_factory=Counter)
    value_types: Counter[str] = field(default_factory=Counter)
    default_values: Counter[str] = field(default_factory=Counter)
    accesses: Counter[str] = field(default_factory=Counter)
    split_targets: Counter[str] = field(default_factory=Counter)


@dataclass(frozen=True)
class BitfieldMetadata:
    value_type: str = ""
    default_value: str = ""
    access: str = ""
    split_target: str = ""


@dataclass(frozen=True)
class BitfieldMetadataIndexes:
    general_by_alias: dict[str, list[BitfieldMetadata]]
    general_by_variable_name: dict[str, list[BitfieldMetadata]]
    chip_by_alias: dict[str, dict[str, list[BitfieldMetadata]]]
    atdf_access_by_chip_alias: dict[str, dict[str, list[str]]]


@dataclass(frozen=True)
class GeneralJsonEntry:
    aliases: tuple[str, ...]
    variable_name: str
    value_type: str = ""
    default_value: str = ""
    access: str = ""
    split_target: str = ""


@dataclass(frozen=True)
class GeneralJsonIndexes:
    by_variable_name: dict[str, dict[str, list[GeneralJsonEntry]]]


@dataclass(frozen=True)
class BitfieldFieldSummary:
    values: tuple[str, ...]
    blank_count: int = 0
    used_fallback: bool = False


@dataclass(frozen=True)
class BitfieldRowSummary:
    fields: dict[str, BitfieldFieldSummary]
    cells: dict[str, str]
    notes: list[str]


@dataclass(frozen=True)
class GeneralJsonSuggestion:
    action: str
    json_cell: str
    notes: list[str]


def parse_arguments() -> argparse.Namespace:
    default_repo_root = Path(__file__).resolve().parent.parent
    parser = argparse.ArgumentParser(
        description="Audit missing general.json aliases and write a grouped Markdown report."
    )
    parser.add_argument(
        "--repo-root",
        type=Path,
        default=default_repo_root,
        help="Repository root. Defaults to the parent of this script.",
    )
    parser.add_argument(
        "--atdf-dir",
        type=Path,
        help="ATDF directory. Defaults to <repo-root>/atdf.",
    )
    parser.add_argument(
        "--docs-dir",
        type=Path,
        help="Documentation directory. Defaults to <repo-root>/docs.",
    )
    parser.add_argument(
        "--general-json",
        type=Path,
        help="Path to general.json. Defaults to <docs-dir>/general.json.",
    )
    parser.add_argument(
        "--logs",
        type=Path,
        help=(
            "Path to logs.json from a prior generation run. Preferred because it "
            "already includes the generator's peripheral grouping and suggested names."
        ),
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Markdown report path. Defaults to <docs-dir>/README.md.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_arguments()

    repo_root = args.repo_root.resolve()
    docs_dir = (args.docs_dir or repo_root / "docs").resolve()
    atdf_dir = (args.atdf_dir or repo_root / "atdf").resolve()
    general_json_path = (args.general_json or docs_dir / "general.json").resolve()
    logs_path = args.logs.resolve() if args.logs else None
    output_path = (args.output or docs_dir / "README.md").resolve()

    ensure_exists(docs_dir, "docs directory")

    general_metadata_paths = bitfield_metadata_paths(
        docs_dir=docs_dir,
        general_json_path=general_json_path,
    )
    general_bitfields_by_alias, general_bitfields_by_variable_name = (
        load_general_bitfield_metadata(general_metadata_paths)
    )
    bitfield_metadata_indexes = BitfieldMetadataIndexes(
        general_by_alias=general_bitfields_by_alias,
        general_by_variable_name=general_bitfields_by_variable_name,
        chip_by_alias=load_chip_bitfield_metadata(docs_dir),
        atdf_access_by_chip_alias=(
            load_atdf_bitfield_accesses(atdf_dir) if atdf_dir.exists() else {}
        ),
    )
    general_json_indexes = load_general_json_indexes(general_json_path)

    if logs_path is not None:
        ensure_exists(logs_path, "logs.json")
        observations = collect_missing_aliases_from_logs(
            logs_path,
            bitfield_metadata_indexes=bitfield_metadata_indexes,
        )
        source_description = (
            "This audit uses a supplied `logs.json` as the source of missing aliases, "
            "including the peripheral grouping emitted by the generator."
        )
        uses_logs = True
    else:
        ensure_exists(atdf_dir, "ATDF directory")
        ensure_exists(general_json_path, "general.json")
        observations = collect_missing_aliases_from_scan(
            atdf_dir=atdf_dir,
            general_aliases=load_general_aliases(general_json_path),
            chip_specific_aliases=load_chip_specific_aliases(docs_dir),
            bitfield_metadata_indexes=bitfield_metadata_indexes,
        )
        source_description = (
            "This audit scans `atdf/*.atdf`, `docs/general.json`, and chip-specific "
            f"docs in `{relative_to_root(docs_dir, repo_root)}/*.json`. The fallback "
            "groups entries by ATDF module name."
        )
        uses_logs = False

    markdown = render_markdown(
        repo_root=repo_root,
        docs_dir=docs_dir,
        observations=observations,
        source_description=source_description,
        uses_logs=uses_logs,
        bitfield_metadata_indexes=bitfield_metadata_indexes,
        general_json_indexes=general_json_indexes,
    )

    output_path.write_text(markdown, encoding="utf-8")

    register_group_count = sum(
        len(variable_groups)
        for variable_groups in observations["grouped"]["registers"].values()
    )
    bitfield_group_count = sum(
        len(variable_groups)
        for variable_groups in observations["grouped"]["bitfields"].values()
    )

    print(f"Wrote {output_path}")
    print(f"Register groups: {register_group_count}")
    print(f"Bitfield groups: {bitfield_group_count}")
    return 0


def ensure_exists(path: Path, description: str) -> None:
    if not path.exists():
        raise SystemExit(f"{description} does not exist: {path}")


def load_general_aliases(path: Path) -> dict[str, set[str]]:
    with path.open(encoding="utf-8") as file_handle:
        general_documentation = json.load(file_handle)

    return {
        "registers": {
            alias
            for entry in general_documentation.get("registers", [])
            for alias in entry.get("aliases", [])
        },
        "bitfields": {
            alias
            for entry in general_documentation.get("bitfields", [])
            for alias in entry.get("aliases", [])
        },
    }


def load_chip_specific_aliases(docs_dir: Path) -> dict[str, dict[str, set[str]]]:
    chip_aliases: dict[str, dict[str, set[str]]] = {}

    for path in sorted(docs_dir.glob("*.json")):
        if path.name == "general.json" or path.name.endswith("old.json"):
            continue

        with path.open(encoding="utf-8") as file_handle:
            documentation = json.load(file_handle)

        chip_name = documentation.get("chip") or path.stem
        chip_aliases[chip_name] = {
            "registers": set(documentation.get("registers", {}).keys()),
            "bitfields": set(documentation.get("bitfields", {}).keys()),
        }

    return chip_aliases


def load_general_json_indexes(path: Path) -> GeneralJsonIndexes:
    if not path.exists():
        return GeneralJsonIndexes(by_variable_name={"registers": {}, "bitfields": {}})

    with path.open(encoding="utf-8") as file_handle:
        documentation = json.load(file_handle)

    by_variable_name: dict[str, defaultdict[str, list[GeneralJsonEntry]]] = {
        "registers": defaultdict(list),
        "bitfields": defaultdict(list),
    }

    for kind in ("registers", "bitfields"):
        for entry in documentation.get(kind, []):
            general_entry = general_json_entry_from_mapping(kind, entry)
            if general_entry.variable_name:
                by_variable_name[kind][general_entry.variable_name].append(
                    general_entry
                )

    return GeneralJsonIndexes(
        by_variable_name={
            kind: dict(variable_map) for kind, variable_map in by_variable_name.items()
        }
    )


def general_json_entry_from_mapping(
    kind: str, entry: dict[str, object]
) -> GeneralJsonEntry:
    aliases = tuple(
        normalized_alias
        for alias in entry.get("aliases", [])
        if (normalized_alias := normalized_string(alias))
    )

    return GeneralJsonEntry(
        aliases=aliases,
        variable_name=normalized_string(entry.get("variableName")),
        value_type=normalized_string(entry.get("valueType")),
        default_value=normalized_string(entry.get("defaultValue")),
        access=normalize_access_value(entry.get("access")),
        split_target=(
            normalized_string(entry.get("splitTarget")) if kind == "bitfields" else ""
        ),
    )


def bitfield_metadata_paths(docs_dir: Path, general_json_path: Path) -> list[Path]:
    paths: list[Path] = []

    if general_json_path.exists():
        paths.append(general_json_path)

    legacy_general_path = docs_dir / "generalold.json"
    if legacy_general_path.exists():
        paths.append(legacy_general_path)

    return paths


def load_general_bitfield_metadata(
    paths: list[Path],
) -> tuple[dict[str, list[BitfieldMetadata]], dict[str, list[BitfieldMetadata]]]:
    by_alias: defaultdict[str, list[BitfieldMetadata]] = defaultdict(list)
    by_variable_name: defaultdict[str, list[BitfieldMetadata]] = defaultdict(list)

    for path in paths:
        with path.open(encoding="utf-8") as file_handle:
            documentation = json.load(file_handle)

        for entry in documentation.get("bitfields", []):
            metadata = bitfield_metadata_from_mapping(entry)

            variable_name = normalized_string(entry.get("variableName"))
            if variable_name:
                by_variable_name[variable_name].append(metadata)

            for alias in entry.get("aliases", []):
                normalized_alias = normalized_string(alias)
                if normalized_alias:
                    by_alias[normalized_alias].append(metadata)

    return dict(by_alias), dict(by_variable_name)


def load_chip_bitfield_metadata(
    docs_dir: Path,
) -> dict[str, dict[str, list[BitfieldMetadata]]]:
    chip_metadata: defaultdict[str, defaultdict[str, list[BitfieldMetadata]]] = (
        defaultdict(lambda: defaultdict(list))
    )

    for path in sorted(docs_dir.glob("*.json")):
        if path.name in {"general.json", "generalold.json"}:
            continue

        with path.open(encoding="utf-8") as file_handle:
            documentation = json.load(file_handle)

        chip_name = normalized_string(
            documentation.get("chip")
        ) or path.stem.removesuffix("old")
        bitfields = documentation.get("bitfields", {})
        if not isinstance(bitfields, dict):
            continue

        for alias, entry in bitfields.items():
            normalized_alias = normalized_string(alias)
            if not normalized_alias or not isinstance(entry, dict):
                continue

            chip_metadata[chip_name][normalized_alias].append(
                bitfield_metadata_from_mapping(entry)
            )

    return {
        chip_name: dict(alias_map) for chip_name, alias_map in chip_metadata.items()
    }


def load_atdf_bitfield_accesses(atdf_dir: Path) -> dict[str, dict[str, list[str]]]:
    chip_accesses: defaultdict[str, defaultdict[str, set[str]]] = defaultdict(
        lambda: defaultdict(set)
    )

    for atdf_path in sorted(atdf_dir.glob("*.atdf")):
        chip_name = atdf_path.stem
        root = ET.parse(atdf_path).getroot()

        for module in root.findall("./modules/module"):
            for register_group in module.findall("./register-group"):
                for register in register_group.findall("./register"):
                    for bitfield in register.findall("./bitfield"):
                        alias = normalized_string(bitfield.get("name"))
                        access = normalize_access_value(bitfield.get("rw"))
                        if alias and access:
                            chip_accesses[chip_name][alias].add(access)

    return {
        chip_name: {
            alias: sorted(accesses, key=natural_key)
            for alias, accesses in alias_map.items()
        }
        for chip_name, alias_map in chip_accesses.items()
    }


def bitfield_metadata_from_mapping(entry: dict[str, object]) -> BitfieldMetadata:
    return BitfieldMetadata(
        value_type=normalized_string(entry.get("valueType")),
        default_value=normalized_string(entry.get("defaultValue")),
        access=normalize_access_value(entry.get("access")),
        split_target=normalized_string(entry.get("splitTarget")),
    )


def normalized_string(value: object) -> str:
    if value is None:
        return ""
    return str(value).strip()


def normalize_access_value(value: object) -> str:
    normalized = normalized_string(value)
    if not normalized:
        return ""

    access_map = {
        "R": "R",
        "RO": "R",
        "R/O": "R",
        "W": "W",
        "WO": "W",
        "W/O": "W",
        "RW": "R/W",
        "R/W": "R/W",
    }

    return access_map.get(normalized.upper(), normalized)


def collect_missing_aliases_from_logs(
    logs_path: Path,
    bitfield_metadata_indexes: BitfieldMetadataIndexes,
) -> dict[str, object]:
    with logs_path.open(encoding="utf-8") as file_handle:
        logs = json.load(file_handle)

    alias_observations = make_observation_map()

    for chip_log in logs.get("chips", []):
        chip_name = chip_log.get("name", "")
        for peripheral_log in chip_log.get("peripherals", []):
            peripheral_name = peripheral_log.get("name") or FALLBACK_PERIPHERAL_NAME

            for item in peripheral_log.get("missingRegisters", []):
                add_observation(
                    alias_observations=alias_observations,
                    kind="registers",
                    peripheral=peripheral_name,
                    alias=item.get("name", ""),
                    chip_name=chip_name,
                    caption=item.get("caption", "").strip(),
                    suggested_name=item.get("suggestedVariableName", "").strip(),
                )

            for item in peripheral_log.get("missingBitfields", []):
                bitfield_name = item.get("name", "")
                metadata = resolve_exact_bitfield_metadata(
                    alias=bitfield_name,
                    chip_name=chip_name,
                    bitfield_metadata_indexes=bitfield_metadata_indexes,
                )
                add_observation(
                    alias_observations=alias_observations,
                    kind="bitfields",
                    peripheral=peripheral_name,
                    alias=bitfield_name,
                    chip_name=chip_name,
                    caption=item.get("caption", "").strip(),
                    suggested_name=item.get("suggestedVariableName", "").strip(),
                    value_type=metadata.value_type,
                    default_value=metadata.default_value,
                    access=metadata.access,
                    split_target=metadata.split_target,
                )

    exported_chip_count = logs.get("exportedChipCount")
    skipped_chip_count = logs.get("skippedChipCount")
    if exported_chip_count is None or skipped_chip_count is None:
        exported_chip_count = sum(
            1 for chip in logs.get("chips", []) if chip.get("exported") is True
        )
        skipped_chip_count = sum(
            1 for chip in logs.get("chips", []) if chip.get("exported") is False
        )

    return finalize_observations(
        alias_observations,
        source_summary={
            "exported_chip_count": exported_chip_count,
            "skipped_chip_count": skipped_chip_count,
        },
    )


def collect_missing_aliases_from_scan(
    atdf_dir: Path,
    general_aliases: dict[str, set[str]],
    chip_specific_aliases: dict[str, dict[str, set[str]]],
    bitfield_metadata_indexes: BitfieldMetadataIndexes,
) -> dict[str, object]:
    alias_observations = make_observation_map()

    for atdf_path in sorted(atdf_dir.glob("*.atdf")):
        chip_name = atdf_path.stem
        chip_aliases = chip_specific_aliases.get(
            chip_name,
            {"registers": set(), "bitfields": set()},
        )

        root = ET.parse(atdf_path).getroot()
        for module in root.findall("./modules/module"):
            peripheral_name = module.get("name") or FALLBACK_PERIPHERAL_NAME
            scan_module(
                module=module,
                chip_name=chip_name,
                peripheral=peripheral_name,
                chip_aliases=chip_aliases,
                general_aliases=general_aliases,
                alias_observations=alias_observations,
                bitfield_metadata_indexes=bitfield_metadata_indexes,
            )

    return finalize_observations(alias_observations)


def make_observation_map() -> dict[str, defaultdict[str, dict[str, AliasObservation]]]:
    return {
        "registers": defaultdict(dict),
        "bitfields": defaultdict(dict),
    }


def finalize_observations(
    alias_observations: dict[str, defaultdict[str, dict[str, AliasObservation]]],
    source_summary: dict[str, int] | None = None,
) -> dict[str, object]:
    grouped = build_grouped_observations(alias_observations)
    return {
        "alias_observations": alias_observations,
        "grouped": grouped,
        "cross_peripheral": build_cross_peripheral_summary(grouped),
        "source_summary": source_summary or {},
    }


def scan_module(
    module: ET.Element,
    chip_name: str,
    peripheral: str,
    chip_aliases: dict[str, set[str]],
    general_aliases: dict[str, set[str]],
    alias_observations: dict[str, defaultdict[str, dict[str, AliasObservation]]],
    bitfield_metadata_indexes: BitfieldMetadataIndexes,
) -> None:
    for register_group in module.findall("./register-group"):
        for register in register_group.findall("./register"):
            register_name = register.get("name")
            if register_name and is_missing_alias(
                alias=register_name,
                kind="registers",
                chip_aliases=chip_aliases,
                general_aliases=general_aliases,
            ):
                add_observation(
                    alias_observations=alias_observations,
                    kind="registers",
                    peripheral=peripheral,
                    alias=register_name,
                    chip_name=chip_name,
                    caption=register.get("caption", "").strip(),
                )

            for bitfield in register.findall("./bitfield"):
                bitfield_name = bitfield.get("name")
                if bitfield_name and is_missing_alias(
                    alias=bitfield_name,
                    kind="bitfields",
                    chip_aliases=chip_aliases,
                    general_aliases=general_aliases,
                ):
                    metadata = resolve_exact_bitfield_metadata(
                        alias=bitfield_name,
                        chip_name=chip_name,
                        bitfield_metadata_indexes=bitfield_metadata_indexes,
                    )
                    add_observation(
                        alias_observations=alias_observations,
                        kind="bitfields",
                        peripheral=peripheral,
                        alias=bitfield_name,
                        chip_name=chip_name,
                        caption=bitfield.get("caption", "").strip(),
                        value_type=metadata.value_type,
                        default_value=metadata.default_value,
                        access=metadata.access
                        or normalize_access_value(bitfield.get("rw")),
                        split_target=metadata.split_target,
                    )


def is_missing_alias(
    alias: str,
    kind: str,
    chip_aliases: dict[str, set[str]],
    general_aliases: dict[str, set[str]],
) -> bool:
    return alias not in general_aliases[kind] and alias not in chip_aliases[kind]


def add_observation(
    alias_observations: dict[str, defaultdict[str, dict[str, AliasObservation]]],
    kind: str,
    peripheral: str,
    alias: str,
    chip_name: str,
    caption: str,
    suggested_name: str = "",
    value_type: str = "",
    default_value: str = "",
    access: str = "",
    split_target: str = "",
) -> None:
    if alias == "":
        return

    observation = alias_observations[kind][peripheral].setdefault(
        alias, AliasObservation()
    )
    observation.occurrences += 1
    if chip_name:
        observation.chips.add(chip_name)
    observation.captions[caption] += 1
    if suggested_name:
        observation.suggested_names[suggested_name] += 1
    if kind == "bitfields":
        observation.value_types[value_type] += 1
        observation.default_values[default_value] += 1
        observation.accesses[access] += 1
        observation.split_targets[split_target] += 1


def resolve_exact_bitfield_metadata(
    alias: str,
    chip_name: str,
    bitfield_metadata_indexes: BitfieldMetadataIndexes,
) -> BitfieldMetadata:
    chip_entries = bitfield_metadata_indexes.chip_by_alias.get(chip_name, {}).get(
        alias, []
    )
    general_entries = bitfield_metadata_indexes.general_by_alias.get(alias, [])
    atdf_accesses = bitfield_metadata_indexes.atdf_access_by_chip_alias.get(
        chip_name, {}
    ).get(alias, [])

    return BitfieldMetadata(
        value_type=first_unique_metadata_value(chip_entries, "value_type")
        or first_unique_metadata_value(general_entries, "value_type"),
        default_value=first_unique_metadata_value(chip_entries, "default_value")
        or first_unique_metadata_value(general_entries, "default_value"),
        access=first_unique_metadata_value(chip_entries, "access")
        or first_unique_metadata_value(general_entries, "access")
        or unique_non_empty_value(atdf_accesses),
        split_target=first_unique_metadata_value(chip_entries, "split_target")
        or first_unique_metadata_value(general_entries, "split_target"),
    )


def first_unique_metadata_value(
    entries: list[BitfieldMetadata], attribute_name: str
) -> str:
    return unique_non_empty_value(getattr(entry, attribute_name) for entry in entries)


def unique_non_empty_value(values) -> str:
    unique_values = sorted({value for value in values if value}, key=natural_key)
    if len(unique_values) == 1:
        return unique_values[0]
    return ""


def build_grouped_observations(
    alias_observations: dict[str, defaultdict[str, dict[str, AliasObservation]]],
) -> dict[str, dict[str, dict[str, set[str]]]]:
    grouped: dict[str, dict[str, dict[str, set[str]]]] = {
        "registers": defaultdict(lambda: defaultdict(set)),
        "bitfields": defaultdict(lambda: defaultdict(set)),
    }

    for kind, peripheral_map in alias_observations.items():
        for peripheral, aliases in peripheral_map.items():
            for alias, observation in aliases.items():
                variable_name = proposed_variable_name(kind, alias, observation)
                grouped[kind][peripheral][variable_name].add(alias)

    return grouped


def build_cross_peripheral_summary(
    grouped: dict[str, dict[str, dict[str, set[str]]]],
) -> dict[str, list[dict[str, object]]]:
    summary = {"registers": [], "bitfields": []}

    for kind, peripheral_map in grouped.items():
        alias_to_peripherals: dict[str, list[tuple[str, str]]] = defaultdict(list)
        for peripheral, variable_groups in peripheral_map.items():
            for variable_name, aliases in variable_groups.items():
                for alias in aliases:
                    alias_to_peripherals[alias].append((peripheral, variable_name))

        for alias, entries in sorted(
            alias_to_peripherals.items(), key=lambda item: natural_key(item[0])
        ):
            peripheral_names = {peripheral for peripheral, _ in entries}
            if len(peripheral_names) < 2:
                continue

            summary[kind].append(
                {
                    "alias": alias,
                    "peripherals": sorted(peripheral_names, key=natural_key),
                    "variable_names": sorted(
                        {variable_name for _, variable_name in entries}, key=natural_key
                    ),
                }
            )

    return summary


def proposed_variable_name(kind: str, alias: str, observation: AliasObservation) -> str:
    caption = representative_value(observation.captions)
    if caption:
        normalized = normalize_variable_name(caption, kind)
        if normalized:
            return normalized

    suggested_name = representative_value(observation.suggested_names)
    if suggested_name:
        normalized = normalize_variable_name(suggested_name, kind)
        if normalized:
            return normalized

    normalized = normalize_variable_name(alias, kind)
    return normalized or alias.lower()


def representative_value(values: Counter[str]) -> str:
    non_empty = [(value, count) for value, count in values.items() if value]
    if not non_empty:
        return ""

    non_empty.sort(key=lambda item: (-item[1], natural_key(item[0])))
    return non_empty[0][0]


def normalize_variable_name(text: str, kind: str) -> str:
    words = words_from_text(text)
    while words and words[-1].lower() in TRAILING_WORDS[kind]:
        words.pop()
    return camel_case(words)


def words_from_text(text: str) -> list[str]:
    if text == "":
        return []

    text = text.replace("Timer/Counter", "Timer Counter")
    text = text.replace("I/O", "IO")
    text = text.replace("_", " ")
    text = re.sub(r"\([^)]*\)", " ", text)
    text = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", text)
    text = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1 \2", text)
    text = re.sub(r"[^A-Za-z0-9]+", " ", text)

    raw_tokens = re.findall(r"[A-Za-z]+|\d+", text)
    merged_tokens = merge_acronym_tokens(raw_tokens)
    words: list[str] = []

    for token in merged_tokens:
        if token.isdigit():
            continue

        lowered = token.lower()
        if lowered in DROP_WORDS:
            continue

        replacement = TOKEN_REPLACEMENTS.get(lowered, lowered)
        words.extend(replacement.split())

    return words


def merge_acronym_tokens(tokens: list[str]) -> list[str]:
    merged: list[str] = []
    index = 0

    while index < len(tokens):
        token = tokens[index]

        if (
            index + 1 < len(tokens)
            and len(token) == 1
            and token.isalpha()
            and tokens[index + 1].isalpha()
            and tokens[index + 1].isupper()
        ):
            merged.append(token.upper() + tokens[index + 1])
            index += 2
            continue

        merged.append(token)
        index += 1

    return merged


def camel_case(words: list[str]) -> str:
    if not words:
        return ""

    parts: list[str] = []
    for index, word in enumerate(words):
        lowered = word.lower()
        if index == 0:
            parts.append(lowered)
        elif len(lowered) == 1:
            parts.append(lowered.upper())
        else:
            parts.append(lowered[0].upper() + lowered[1:])

    return "".join(parts)


def render_markdown(
    repo_root: Path,
    docs_dir: Path,
    observations: dict[str, object],
    source_description: str,
    uses_logs: bool,
    bitfield_metadata_indexes: BitfieldMetadataIndexes,
    general_json_indexes: GeneralJsonIndexes,
) -> str:
    alias_observations = observations["alias_observations"]
    grouped = observations["grouped"]
    cross_peripheral = observations["cross_peripheral"]
    source_summary = observations.get("source_summary", {})

    register_alias_count = sum(
        len(alias_map) for alias_map in alias_observations["registers"].values()
    )
    bitfield_alias_count = sum(
        len(alias_map) for alias_map in alias_observations["bitfields"].values()
    )
    register_group_count = sum(
        len(variable_groups) for variable_groups in grouped["registers"].values()
    )
    bitfield_group_count = sum(
        len(variable_groups) for variable_groups in grouped["bitfields"].values()
    )

    peripheral_names = sorted(
        set(grouped["registers"].keys()).union(grouped["bitfields"].keys()),
        key=natural_key,
    )
    peripheral_list = ", ".join(f"`{name}`" for name in peripheral_names) or "-"

    lines = [
        "# Missing `general.json` entries",
        "",
        "Generated by `python3 Scripts/audit_general_json.py`.",
        "",
        source_description,
        "",
        f"- Peripherals with missing entries: {peripheral_list}",
        (
            "- `logs.json` is the preferred source because it reflects the aliases the generator actually reported as missing."
            if uses_logs
            else "- If you already have a fresh generation run, pass `--logs <path>` to use the generator's grouped `logs.json` directly."
        ),
        "- Rows are grouped by cleaned `variableName` inside the same peripheral family.",
        "- Alias lists are rendered as JSON-ready strings so they can be pasted directly into `docs/general.json`.",
        "- `Action` shows whether a row should update an existing `general.json` object or become a new one.",
        "- Each row is a starting point for one `general.json` object; review notes when bitfield metadata is partial or conflicting.",
        "- The script is fully data-driven in logs mode: peripheral names come straight from `logs.json`.",
        "- Bitfield rows include best-effort `valueType`, `defaultValue`, `access`, and `splitTarget` suggestions when the script can infer them.",
        "- `JSON` is a ready-to-paste object when the match is unambiguous.",
        "- Review `Cross-Peripheral Aliases` before copying rows into `docs/general.json`, because `general.json` is global while this report is peripheral-aware.",
        "",
    ]

    if uses_logs and source_summary:
        lines.extend(
            [
                f"- Exported chips: {source_summary['exported_chip_count']}",
                f"- Skipped chips: {source_summary['skipped_chip_count']}",
            ]
        )

    lines.extend(
        [
            f"- Register groups: {register_group_count} from {register_alias_count} missing aliases",
            f"- Bitfield groups: {bitfield_group_count} from {bitfield_alias_count} missing aliases",
            "",
        ]
    )

    lines.extend(
        render_kind_sections(
            "Registers",
            "registers",
            grouped,
            alias_observations,
            bitfield_metadata_indexes,
            general_json_indexes,
        )
    )
    lines.extend(
        render_kind_sections(
            "Bitfields",
            "bitfields",
            grouped,
            alias_observations,
            bitfield_metadata_indexes,
            general_json_indexes,
        )
    )
    lines.extend(render_cross_peripheral_section(cross_peripheral))

    return "\n".join(lines).rstrip() + "\n"


def render_kind_sections(
    title: str,
    kind: str,
    grouped: dict[str, dict[str, dict[str, set[str]]]],
    alias_observations: dict[str, defaultdict[str, dict[str, AliasObservation]]],
    bitfield_metadata_indexes: BitfieldMetadataIndexes,
    general_json_indexes: GeneralJsonIndexes,
) -> list[str]:
    lines = [f"## {title}", ""]

    for peripheral in sorted(grouped[kind].keys(), key=natural_key):
        variable_groups = grouped[kind][peripheral]
        aliases_in_section = alias_observations[kind][peripheral]
        chips_in_section = set().union(
            *(observation.chips for observation in aliases_in_section.values())
        )

        lines.extend(
            [
                f"### {peripheral}",
                "",
                f"- Groups: {len(variable_groups)}",
                f"- Aliases: {sum(len(aliases) for aliases in variable_groups.values())}",
                f"- Chips touched: {len(chips_in_section)}",
                "",
                (
                    "| Proposed variableName | Aliases | valueType | defaultValue | access | splitTarget | Action | JSON | Chips | Instances | Samples | Notes |"
                    if kind == "bitfields"
                    else "| Proposed variableName | Aliases | Action | JSON | Chips | Instances | Samples | Notes |"
                ),
                (
                    "| --- | --- | --- | --- | --- | --- | --- | --- | ---: | ---: | --- | --- |"
                    if kind == "bitfields"
                    else "| --- | --- | --- | --- | ---: | ---: | --- | --- |"
                ),
            ]
        )

        for variable_name in sorted(variable_groups.keys(), key=natural_key):
            aliases = sorted(variable_groups[variable_name], key=natural_key)
            chip_names = set()
            instances = 0
            for alias in aliases:
                observation = aliases_in_section[alias]
                chip_names.update(observation.chips)
                instances += observation.occurrences

            if kind == "bitfields":
                metadata_summary = summarize_bitfield_metadata(
                    variable_name=variable_name,
                    aliases=aliases,
                    observations=aliases_in_section,
                    bitfield_metadata_indexes=bitfield_metadata_indexes,
                )
                json_suggestion = suggest_general_json_entry(
                    kind=kind,
                    variable_name=variable_name,
                    aliases=aliases,
                    bitfield_summary=metadata_summary,
                    general_json_indexes=general_json_indexes,
                )
                lines.append(
                    "| `{variable_name}` | {aliases_cell} | {value_type} | {default_value} | {access} | {split_target} | {action} | {json_cell} | {chip_count} | {instances} | {samples} | {notes} |".format(
                        variable_name=variable_name,
                        aliases_cell=format_alias_list(aliases),
                        value_type=metadata_summary.cells["valueType"],
                        default_value=metadata_summary.cells["defaultValue"],
                        access=metadata_summary.cells["access"],
                        split_target=metadata_summary.cells["splitTarget"],
                        action=json_suggestion.action,
                        json_cell=json_suggestion.json_cell,
                        chip_count=len(chip_names),
                        instances=instances,
                        samples=samples_cell(aliases, aliases_in_section),
                        notes=notes_cell(
                            aliases,
                            aliases_in_section,
                            extra_notes=metadata_summary.notes + json_suggestion.notes,
                        ),
                    )
                )
            else:
                json_suggestion = suggest_general_json_entry(
                    kind=kind,
                    variable_name=variable_name,
                    aliases=aliases,
                    bitfield_summary=None,
                    general_json_indexes=general_json_indexes,
                )
                lines.append(
                    "| `{variable_name}` | {aliases_cell} | {action} | {json_cell} | {chip_count} | {instances} | {samples} | {notes} |".format(
                        variable_name=variable_name,
                        aliases_cell=format_alias_list(aliases),
                        action=json_suggestion.action,
                        json_cell=json_suggestion.json_cell,
                        chip_count=len(chip_names),
                        instances=instances,
                        samples=samples_cell(aliases, aliases_in_section),
                        notes=notes_cell(
                            aliases,
                            aliases_in_section,
                            extra_notes=json_suggestion.notes,
                        ),
                    )
                )

        lines.append("")

    return lines


def render_cross_peripheral_section(
    cross_peripheral: dict[str, list[dict[str, object]]],
) -> list[str]:
    register_entries = cross_peripheral["registers"]
    bitfield_entries = cross_peripheral["bitfields"]

    lines = [
        "## Cross-Peripheral Aliases",
        "",
        "These aliases appeared under more than one peripheral family in the audit.",
        "",
        "- If every row for an alias resolves to the same `variableName`, one shared `general.json` entry is usually enough.",
        "- If an alias resolves to different names across peripherals, keep it out of `general.json` until you decide how to handle the conflict.",
        "",
    ]

    if not register_entries and not bitfield_entries:
        lines.append("No cross-peripheral aliases were found.")
        return lines

    if register_entries:
        lines.extend(render_cross_peripheral_table("Registers", register_entries))
    if bitfield_entries:
        lines.extend(render_cross_peripheral_table("Bitfields", bitfield_entries))

    return lines


def render_cross_peripheral_table(
    title: str,
    entries: list[dict[str, object]],
) -> list[str]:
    lines = [
        f"### {title}",
        "",
        "| Alias | Peripherals | Proposed variableNames | Suggested action |",
        "| --- | --- | --- | --- |",
    ]

    for entry in entries:
        variable_names = entry["variable_names"]
        action = "shared entry ok" if len(variable_names) == 1 else "manual review"
        lines.append(
            "| {alias} | {peripherals} | {variable_names} | {action} |".format(
                alias=json_string(entry["alias"]),
                peripherals=", ".join(
                    f"`{peripheral}`" for peripheral in entry["peripherals"]
                ),
                variable_names=", ".join(
                    f"`{variable_name}`" for variable_name in variable_names
                ),
                action=action,
            )
        )

    lines.append("")
    return lines


def samples_cell(aliases: list[str], observations: dict[str, AliasObservation]) -> str:
    samples: list[str] = []
    more_count = 0

    for alias in aliases:
        observation = observations[alias]
        sample = representative_value(
            observation.suggested_names
        ) or representative_value(observation.captions)
        if not sample:
            continue

        entry = f"`{alias}`: {escape_markdown(sample)}"
        if len(samples) < 2:
            samples.append(entry)
        else:
            more_count += 1

    if not samples:
        return "-"
    if more_count:
        samples.append(f"+{more_count} more")
    return "; ".join(samples)


def summarize_bitfield_metadata(
    variable_name: str,
    aliases: list[str],
    observations: dict[str, AliasObservation],
    bitfield_metadata_indexes: BitfieldMetadataIndexes,
) -> BitfieldRowSummary:
    metadata_cells: dict[str, str] = {}
    fields: dict[str, BitfieldFieldSummary] = {}
    notes: list[str] = []
    fallback_entries = bitfield_metadata_indexes.general_by_variable_name.get(
        variable_name, []
    )

    field_specs = [
        ("valueType", "value_types", "value_type"),
        ("defaultValue", "default_values", "default_value"),
        ("access", "accesses", "access"),
        ("splitTarget", "split_targets", "split_target"),
    ]

    for label, counter_name, attribute_name in field_specs:
        merged_counter: Counter[str] = Counter()
        for alias in aliases:
            merged_counter.update(getattr(observations[alias], counter_name))

        values = sorted({value for value in merged_counter if value}, key=natural_key)
        blank_count = merged_counter.get("", 0)
        used_fallback = False

        if not values:
            values = metadata_values_from_entries(fallback_entries, attribute_name)
            used_fallback = bool(values)

        fields[label] = BitfieldFieldSummary(
            values=tuple(values),
            blank_count=blank_count,
            used_fallback=used_fallback,
        )
        metadata_cells[label] = format_metadata_values(values)

        if len(values) > 1:
            notes.append(
                f"{label}: {'fallback ' if used_fallback else ''}{len(values)} values"
            )
        elif len(values) == 1 and blank_count:
            notes.append(f"{label}: partial")

    return BitfieldRowSummary(fields=fields, cells=metadata_cells, notes=notes)


def suggest_general_json_entry(
    kind: str,
    variable_name: str,
    aliases: list[str],
    bitfield_summary: BitfieldRowSummary | None,
    general_json_indexes: GeneralJsonIndexes,
) -> GeneralJsonSuggestion:
    existing_entries = general_json_indexes.by_variable_name.get(kind, {}).get(
        variable_name, []
    )
    matching_entries = [
        entry
        for entry in existing_entries
        if general_json_entry_matches_row(entry, bitfield_summary)
    ]

    if len(matching_entries) == 1:
        merged_entry = merge_general_json_entry_aliases(matching_entries[0], aliases)
        return GeneralJsonSuggestion(
            action="update existing",
            json_cell=format_json_object(general_json_object(merged_entry, kind)),
            notes=[],
        )

    if len(matching_entries) > 1:
        return GeneralJsonSuggestion(
            action="manual review",
            json_cell="-",
            notes=[f"general.json: {len(matching_entries)} matching entries"],
        )

    if kind == "bitfields" and bitfield_summary is not None:
        ambiguous_fields = [
            label
            for label, field in bitfield_summary.fields.items()
            if len(field.values) > 1
        ]
        if ambiguous_fields:
            return GeneralJsonSuggestion(
                action="manual review",
                json_cell="-",
                notes=[f"json: ambiguous {', '.join(ambiguous_fields)}"],
            )

    new_entry = suggested_general_json_entry(
        kind, variable_name, aliases, bitfield_summary
    )
    return GeneralJsonSuggestion(
        action="new entry",
        json_cell=format_json_object(general_json_object(new_entry, kind)),
        notes=[],
    )


def general_json_entry_matches_row(
    entry: GeneralJsonEntry,
    bitfield_summary: BitfieldRowSummary | None,
) -> bool:
    if bitfield_summary is None:
        return True

    field_to_entry_value = {
        "valueType": entry.value_type,
        "defaultValue": entry.default_value,
        "access": entry.access,
        "splitTarget": entry.split_target,
    }

    for label, entry_value in field_to_entry_value.items():
        row_values = bitfield_summary.fields[label].values
        if row_values and entry_value not in row_values:
            return False

    return True


def suggested_general_json_entry(
    kind: str,
    variable_name: str,
    aliases: list[str],
    bitfield_summary: BitfieldRowSummary | None,
) -> GeneralJsonEntry:
    field_values = {
        label: "" for label in ("valueType", "defaultValue", "access", "splitTarget")
    }

    if bitfield_summary is not None:
        for label in field_values:
            values = bitfield_summary.fields[label].values
            if len(values) == 1:
                field_values[label] = values[0]

    return GeneralJsonEntry(
        aliases=tuple(aliases),
        variable_name=variable_name,
        value_type=field_values["valueType"],
        default_value=field_values["defaultValue"],
        access=field_values["access"],
        split_target=field_values["splitTarget"] if kind == "bitfields" else "",
    )


def merge_general_json_entry_aliases(
    entry: GeneralJsonEntry, new_aliases: list[str]
) -> GeneralJsonEntry:
    merged_aliases = list(entry.aliases)
    seen_aliases = set(merged_aliases)

    for alias in sorted(new_aliases, key=natural_key):
        if alias not in seen_aliases:
            merged_aliases.append(alias)
            seen_aliases.add(alias)

    return GeneralJsonEntry(
        aliases=tuple(merged_aliases),
        variable_name=entry.variable_name,
        value_type=entry.value_type,
        default_value=entry.default_value,
        access=entry.access,
        split_target=entry.split_target,
    )


def general_json_object(entry: GeneralJsonEntry, kind: str) -> dict[str, object]:
    data: dict[str, object] = {
        "aliases": list(entry.aliases),
        "variableName": entry.variable_name,
    }

    if entry.value_type:
        data["valueType"] = entry.value_type
    if entry.default_value:
        data["defaultValue"] = entry.default_value
    if entry.access:
        data["access"] = entry.access
    if kind == "bitfields" and entry.split_target:
        data["splitTarget"] = entry.split_target

    return data


def format_json_object(data: dict[str, object]) -> str:
    return escape_markdown(json.dumps(data, ensure_ascii=True, separators=(", ", ": ")))


def metadata_values_from_entries(
    entries: list[BitfieldMetadata], attribute_name: str
) -> list[str]:
    return sorted(
        {
            getattr(entry, attribute_name)
            for entry in entries
            if getattr(entry, attribute_name)
        },
        key=natural_key,
    )


def format_metadata_values(values: list[str]) -> str:
    if not values:
        return "-"

    rendered_values = [json_string(value) for value in values[:3]]
    if len(values) > 3:
        rendered_values.append("...")
    return " / ".join(rendered_values)


def format_alias_list(aliases: list[str]) -> str:
    return ", ".join(json_string(alias) for alias in aliases)


def json_string(value: str) -> str:
    return escape_markdown(json.dumps(value))


def notes_cell(
    aliases: list[str],
    observations: dict[str, AliasObservation],
    extra_notes: list[str] | None = None,
) -> str:
    notes: list[str] = list(extra_notes or [])

    for alias in aliases:
        observation = observations[alias]
        review_notes: list[str] = []

        normalized_captions = {
            normalize_spacing(caption.lower())
            for caption in observation.captions
            if caption
        }
        if len(normalized_captions) > 1:
            review_notes.append(f"{len(normalized_captions)} captions")
        if "" in observation.captions:
            review_notes.append("blank caption")

        if review_notes:
            notes.append(f"`{alias}`: {', '.join(review_notes)}")

    if not notes:
        return "-"
    if len(notes) > 3:
        return "; ".join(notes[:3]) + "; ..."
    return "; ".join(notes)


def normalize_spacing(text: str) -> str:
    return " ".join(text.split())


def escape_markdown(text: str) -> str:
    return text.replace("|", "\\|").replace("`", "\\`")


def natural_key(value: str):
    return [
        int(part) if part.isdigit() else part.lower()
        for part in re.split(r"(\d+)", value)
    ]


def relative_to_root(path: Path, repo_root: Path) -> str:
    try:
        return str(path.relative_to(repo_root))
    except ValueError:
        return str(path)


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except SystemExit:
        raise
    except Exception as error:
        print(f"audit_general_json.py failed: {error}", file=sys.stderr)
        raise
