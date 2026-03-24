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

    if logs_path is not None:
        ensure_exists(logs_path, "logs.json")
        observations = collect_missing_aliases_from_logs(logs_path)
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


def collect_missing_aliases_from_logs(logs_path: Path) -> dict[str, object]:
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
                add_observation(
                    alias_observations=alias_observations,
                    kind="bitfields",
                    peripheral=peripheral_name,
                    alias=item.get("name", ""),
                    chip_name=chip_name,
                    caption=item.get("caption", "").strip(),
                    suggested_name=item.get("suggestedVariableName", "").strip(),
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
                    add_observation(
                        alias_observations=alias_observations,
                        kind="bitfields",
                        peripheral=peripheral,
                        alias=bitfield_name,
                        chip_name=chip_name,
                        caption=bitfield.get("caption", "").strip(),
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
        "- Each row can become one `general.json` object with that row's alias list and `variableName`.",
        "- The script is fully data-driven in logs mode: peripheral names come straight from `logs.json`.",
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
        render_kind_sections("Registers", "registers", grouped, alias_observations)
    )
    lines.extend(
        render_kind_sections("Bitfields", "bitfields", grouped, alias_observations)
    )
    lines.extend(render_cross_peripheral_section(cross_peripheral))

    return "\n".join(lines).rstrip() + "\n"


def render_kind_sections(
    title: str,
    kind: str,
    grouped: dict[str, dict[str, dict[str, set[str]]]],
    alias_observations: dict[str, defaultdict[str, dict[str, AliasObservation]]],
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
                "| Proposed variableName | Aliases | Chips | Instances | Samples | Notes |",
                "| --- | --- | ---: | ---: | --- | --- |",
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

            lines.append(
                "| `{variable_name}` | {aliases_cell} | {chip_count} | {instances} | {samples} | {notes} |".format(
                    variable_name=variable_name,
                    aliases_cell=", ".join(f"`{alias}`" for alias in aliases),
                    chip_count=len(chip_names),
                    instances=instances,
                    samples=samples_cell(aliases, aliases_in_section),
                    notes=notes_cell(aliases, aliases_in_section),
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
            "| `{alias}` | {peripherals} | {variable_names} | {action} |".format(
                alias=entry["alias"],
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


def notes_cell(aliases: list[str], observations: dict[str, AliasObservation]) -> str:
    notes: list[str] = []

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
