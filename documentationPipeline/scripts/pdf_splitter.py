from __future__ import annotations

import argparse
from functools import lru_cache
import json
import re
import sys
from pathlib import Path

from atdf_parser import (
    DEFAULT_ATDF_DIR,
    PIPELINE_ROOT,
    discover_atdf_paths,
    discover_pdf_paths,
    parse_atdf,
    relative_display_path,
)


DEFAULT_CONFIG_PATH = PIPELINE_ROOT / "config" / "peripherals.json"
DEFAULT_OUTPUT_DIR = PIPELINE_ROOT / "output" / "datasheet_sections"
DEFAULT_DATASHEET_DIR = PIPELINE_ROOT / "datasheets"


def normalize_text(value: str) -> str:
    lowered = value.lower()
    normalized = re.sub(r"[^a-z0-9]+", " ", lowered)
    return re.sub(r"\s+", " ", normalized).strip()


def dedupe(items: list[str]) -> list[str]:
    seen: set[str] = set()
    ordered: list[str] = []
    for item in items:
        if not item or item in seen:
            continue
        seen.add(item)
        ordered.append(item)
    return ordered


def safe_name(value: str) -> str:
    return re.sub(r"[^A-Za-z0-9_.-]+", "_", value)


def compile_word_pattern(term: str) -> re.Pattern[str]:
    return re.compile(rf"(?<![A-Za-z0-9_]){re.escape(term)}(?![A-Za-z0-9_])")


def datasheet_base_name(pdf_path: Path) -> str:
    stem = pdf_path.stem
    if "__" in stem:
        return stem.split("__", 1)[0]
    return stem


def chip_family_prefix(chip_name: str) -> str | None:
    match = re.match(r"^(.*[A-Za-z])(\d[A-Za-z0-9]*)$", chip_name)
    if match is None:
        return None
    return match.group(1)


def extract_chip_candidates_from_name(name: str) -> list[dict[str, object]]:
    candidates: list[dict[str, object]] = []
    current_prefix: str | None = None

    for group in re.split(r"_+", name):
        if not group:
            continue

        for segment in group.split("-"):
            token = segment.strip()
            if not token:
                continue

            expanded = False
            if token.upper().startswith("AT"):
                candidate = token
            elif current_prefix and token[0].isdigit():
                candidate = f"{current_prefix}{token}"
                expanded = True
            else:
                continue

            prefix = chip_family_prefix(candidate)
            if prefix is not None:
                current_prefix = prefix

            candidates.append(
                {
                    "chip": candidate,
                    "expanded": expanded,
                    "sourceToken": token,
                }
            )

    best_by_chip: dict[str, dict[str, object]] = {}
    for candidate in candidates:
        chip_name = candidate["chip"]
        existing = best_by_chip.get(chip_name)
        if existing is None or (
            existing["expanded"] is True and candidate["expanded"] is False
        ):
            best_by_chip[chip_name] = candidate

    return [
        best_by_chip[chip_name]
        for chip_name in dedupe([item["chip"] for item in candidates])
    ]


def extract_pages_with_pymupdf(pdf_path: Path) -> list[dict[str, object]]:
    import fitz

    document = fitz.open(pdf_path)
    try:
        return [
            {
                "page": index + 1,
                "text": page.get_text("text") or "",
            }
            for index, page in enumerate(document)
        ]
    finally:
        document.close()


def extract_pages_with_pdfplumber(pdf_path: Path) -> list[dict[str, object]]:
    import pdfplumber

    pages: list[dict[str, object]] = []
    with pdfplumber.open(pdf_path) as document:
        for index, page in enumerate(document.pages):
            pages.append(
                {
                    "page": index + 1,
                    "text": page.extract_text() or "",
                }
            )
    return pages


def extract_pdf_pages(pdf_path: Path) -> list[dict[str, object]]:
    extraction_errors: list[str] = []

    for extractor in (extract_pages_with_pymupdf, extract_pages_with_pdfplumber):
        try:
            pages = extractor(pdf_path)
            if any(page["text"].strip() for page in pages):
                return pages
            extraction_errors.append(f"{extractor.__name__}: extracted no text")
        except Exception as error:  # noqa: BLE001
            extraction_errors.append(f"{extractor.__name__}: {error}")

    joined_errors = "; ".join(extraction_errors)
    raise RuntimeError(f"Could not extract text from {pdf_path}: {joined_errors}")


@lru_cache(maxsize=None)
def extract_pdf_pages_cached(pdf_path: str) -> list[dict[str, object]]:
    return extract_pdf_pages(Path(pdf_path))


def load_config(path: Path) -> dict[str, object]:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


@lru_cache(maxsize=None)
def parse_atdf_cached(atdf_path: str) -> dict[str, object]:
    return parse_atdf(Path(atdf_path))


def build_search_terms(
    peripheral: dict[str, object], config: dict[str, object]
) -> dict[str, list[str]]:
    defaults = config.get("defaults", {})
    max_register_terms = int(defaults.get("maxRegisterTerms", 12))
    max_bitfield_terms = int(defaults.get("maxBitfieldTerms", 16))

    peripheral_config = config.get("peripherals", {}).get(peripheral["name"], {})
    module_config = config.get("modules", {}).get(peripheral["module"], {})

    phrases = dedupe(
        [
            peripheral["name"],
            peripheral.get("caption", ""),
            peripheral["registerGroup"].get("name", ""),
            peripheral["registerGroup"].get("nameInModule", ""),
            peripheral["registerGroup"].get("caption", ""),
            *peripheral_config.get("patterns", []),
            *module_config.get("patterns", []),
        ]
    )

    aliases = dedupe(
        [*peripheral_config.get("aliases", []), *module_config.get("aliases", [])]
    )

    if peripheral["name"].startswith("PORT") and len(peripheral["name"]) == 5:
        port_letter = peripheral["name"][-1]
        phrases = dedupe(phrases + [f"Port {port_letter}", f"PORT{port_letter}"])

    register_terms = dedupe(
        [register["name"] for register in peripheral.get("registers", [])]
    )[:max_register_terms]
    bitfield_terms = dedupe(
        [
            bitfield["name"]
            for register in peripheral.get("registers", [])
            for bitfield in register.get("bitfields", [])
            if len(bitfield["name"]) >= 3
        ]
    )[:max_bitfield_terms]

    return {
        "phrases": phrases,
        "aliases": aliases,
        "registers": register_terms,
        "bitfields": bitfield_terms,
    }


def score_page(
    page: dict[str, object], terms: dict[str, list[str]]
) -> dict[str, object]:
    raw_text = page["text"]
    normalized = normalize_text(raw_text)
    score = 0
    phrase_hits: list[str] = []
    alias_hits: list[str] = []
    register_hits: list[str] = []
    bitfield_hits: list[str] = []

    for phrase in terms["phrases"]:
        normalized_phrase = normalize_text(phrase)
        if normalized_phrase and normalized_phrase in normalized:
            score += 8
            phrase_hits.append(phrase)

    for alias in terms["aliases"]:
        normalized_alias = normalize_text(alias)
        if normalized_alias and normalized_alias in normalized:
            score += 5
            alias_hits.append(alias)

    for register_name in terms["registers"]:
        if compile_word_pattern(register_name).search(raw_text):
            score += 2
            register_hits.append(register_name)

    for bitfield_name in terms["bitfields"]:
        if compile_word_pattern(bitfield_name).search(raw_text):
            score += 1
            bitfield_hits.append(bitfield_name)

    return {
        "page": page["page"],
        "score": score,
        "phraseHits": phrase_hits,
        "aliasHits": alias_hits,
        "registerHits": register_hits,
        "bitfieldHits": bitfield_hits,
    }


def expand_pages(page_numbers: list[int], page_count: int, padding: int) -> list[int]:
    expanded: set[int] = set()
    for page_number in page_numbers:
        for delta in range(-padding, padding + 1):
            candidate = page_number + delta
            if 1 <= candidate <= page_count:
                expanded.add(candidate)
    return sorted(expanded)


def page_ranges(page_numbers: list[int]) -> list[dict[str, int]]:
    if not page_numbers:
        return []

    ranges: list[dict[str, int]] = []
    start = page_numbers[0]
    end = start

    for page_number in page_numbers[1:]:
        if page_number == end + 1:
            end = page_number
            continue

        ranges.append({"start": start, "end": end})
        start = page_number
        end = page_number

    ranges.append({"start": start, "end": end})
    return ranges


def render_page_bundle(
    pages_by_number: dict[int, dict[str, object]], selected_pages: list[int]
) -> str:
    blocks: list[str] = []
    for page_number in selected_pages:
        page_text = pages_by_number[page_number]["text"].strip()
        blocks.append(f"## Page {page_number}\n\n{page_text}")
    return "\n\n".join(blocks).strip() + "\n"


def register_summary_pages(pages: list[dict[str, object]]) -> list[int]:
    summary_terms = ["register summary", "summary of registers"]
    hits: list[int] = []
    for page in pages:
        normalized = normalize_text(page["text"])
        if any(term in normalized for term in summary_terms):
            hits.append(page["page"])
    return hits


def resolve_output_directory(output: Path, chip_name: str) -> Path:
    if output.name == chip_name:
        return output
    return output / chip_name


def output_is_current(output_directory: Path, pdf_path: Path, atdf_path: Path) -> bool:
    toc_path = output_directory / "_toc.json"
    if toc_path.exists() is False:
        return False

    try:
        with toc_path.open("r", encoding="utf-8") as handle:
            toc = json.load(handle)
    except (OSError, json.JSONDecodeError):
        return False

    return toc.get("pdf") == relative_display_path(pdf_path) and toc.get(
        "atdf"
    ) == relative_display_path(atdf_path)


def split_datasheet(
    pdf_path: Path,
    chip_name: str,
    atdf_path: Path,
    config: dict[str, object],
    output_root: Path,
    force: bool = False,
) -> tuple[Path, bool]:
    output_directory = resolve_output_directory(output_root, chip_name)
    if force is False and output_is_current(output_directory, pdf_path, atdf_path):
        return output_directory, True

    defaults = config.get("defaults", {})
    minimum_score = int(defaults.get("minimumScore", 8))
    page_padding = int(defaults.get("pagePadding", 1))

    parsed = parse_atdf_cached(str(atdf_path.resolve()))
    pages = extract_pdf_pages_cached(str(pdf_path.resolve()))
    pages_by_number = {page["page"]: page for page in pages}
    output_directory.mkdir(parents=True, exist_ok=True)

    toc_payload = {
        "chip": chip_name,
        "pdf": relative_display_path(pdf_path),
        "atdf": relative_display_path(atdf_path),
        "pageCount": len(pages),
        "peripherals": [],
    }

    for peripheral in parsed["peripherals"]:
        terms = build_search_terms(peripheral, config)
        page_scores = [score_page(page, terms) for page in pages]
        matching_pages = [
            page_score["page"]
            for page_score in page_scores
            if page_score["score"] >= minimum_score
            or len(page_score["registerHits"]) >= 3
        ]

        if not matching_pages:
            top_scores = [
                page_score
                for page_score in sorted(
                    page_scores, key=lambda item: item["score"], reverse=True
                )[:3]
                if page_score["score"] > 0
            ]
            matching_pages = [page_score["page"] for page_score in top_scores]

        selected_pages = expand_pages(matching_pages, len(pages), page_padding)
        peripheral_basename = safe_name(peripheral["name"])

        text_path = output_directory / f"{peripheral_basename}.txt"
        metadata_path = output_directory / f"{peripheral_basename}_pages.json"

        if selected_pages:
            text_path.write_text(
                render_page_bundle(pages_by_number, selected_pages), encoding="utf-8"
            )
        else:
            text_path.write_text("", encoding="utf-8")

        peripheral_payload = {
            "name": peripheral["name"],
            "module": peripheral["module"],
            "caption": peripheral.get("caption", ""),
            "selectedPages": selected_pages,
            "pageRanges": page_ranges(selected_pages),
            "searchTerms": terms,
            "topScores": [
                page_score
                for page_score in sorted(
                    page_scores, key=lambda item: item["score"], reverse=True
                )[:10]
                if page_score["score"] > 0
            ],
            "textPath": relative_display_path(text_path),
        }

        with metadata_path.open("w", encoding="utf-8") as handle:
            json.dump(peripheral_payload, handle, indent=2)
            handle.write("\n")

        toc_payload["peripherals"].append(peripheral_payload)

    summary_pages = register_summary_pages(pages)
    summary_bundle = (
        render_page_bundle(pages_by_number, summary_pages) if summary_pages else ""
    )
    (output_directory / "_register_summary.txt").write_text(
        summary_bundle, encoding="utf-8"
    )

    with (output_directory / "_toc.json").open("w", encoding="utf-8") as handle:
        json.dump(toc_payload, handle, indent=2)
        handle.write("\n")

    return output_directory, False


def match_pdf_to_atdfs(
    pdf_path: Path, atdf_by_chip: dict[str, Path]
) -> tuple[list[dict[str, object]], list[str]]:
    candidates = extract_chip_candidates_from_name(datasheet_base_name(pdf_path))
    matched_entries: list[dict[str, object]] = []
    warnings: list[str] = []

    for candidate in candidates:
        chip_name = candidate["chip"]
        if chip_name in atdf_by_chip:
            matched_entries.append(candidate)
        else:
            warnings.append(
                f"{relative_display_path(pdf_path)} references {chip_name}, but no matching ATDF was found."
            )

    return matched_entries, warnings


def ranking_for_match(
    pdf_path: Path, chip_entry: dict[str, object], matched_chip_count: int
) -> tuple[int, int, int]:
    direct_token_bonus = 1 if chip_entry["expanded"] is False else 0
    specificity = -matched_chip_count
    filename_length = -len(datasheet_base_name(pdf_path))
    return (direct_token_bonus, specificity, filename_length)


def build_batch_jobs(
    pdf_dir: Path, atdf_dir: Path
) -> tuple[list[tuple[Path, str, Path]], list[str]]:
    pdf_paths = discover_pdf_paths(pdf_dir)
    if not pdf_paths:
        return [], []

    atdf_paths = discover_atdf_paths(atdf_dir)
    atdf_by_chip = {path.stem: path for path in atdf_paths}

    chosen_by_chip: dict[str, tuple[tuple[int, int, int], Path]] = {}
    warnings: list[str] = []

    for pdf_path in pdf_paths:
        matched_entries, match_warnings = match_pdf_to_atdfs(pdf_path, atdf_by_chip)
        warnings.extend(match_warnings)

        if not matched_entries:
            if match_warnings:
                warnings.append(
                    f"Skipped {relative_display_path(pdf_path)} because none of its extracted chip names have matching ATDFs."
                )
            else:
                warnings.append(
                    f"Skipped {relative_display_path(pdf_path)} because no chip names could be extracted from the filename."
                )
            continue

        matched_chip_count = len(matched_entries)
        for entry in matched_entries:
            chip_name = entry["chip"]
            ranking = ranking_for_match(pdf_path, entry, matched_chip_count)

            existing = chosen_by_chip.get(chip_name)
            if existing is None or ranking > existing[0]:
                if existing is not None:
                    warnings.append(
                        f"Skipped {relative_display_path(existing[1])} for chip {chip_name} because {relative_display_path(pdf_path)} is a better datasheet match."
                    )
                chosen_by_chip[chip_name] = (ranking, pdf_path)
            else:
                warnings.append(
                    f"Skipped {relative_display_path(pdf_path)} for chip {chip_name} because {relative_display_path(existing[1])} is already a better datasheet match."
                )

    jobs = [
        (pdf_path, chip_name, atdf_by_chip[chip_name])
        for chip_name, (_, pdf_path) in sorted(chosen_by_chip.items())
    ]
    return jobs, warnings


def infer_chip_name_for_pdf(
    pdf_path: Path,
    requested_chip: str | None,
    requested_atdf: Path | None,
    available_atdfs: dict[str, Path],
) -> str | None:
    if requested_chip:
        return requested_chip
    if requested_atdf is not None:
        return requested_atdf.stem

    matched_entries, _ = match_pdf_to_atdfs(pdf_path, available_atdfs)
    if len(matched_entries) == 1:
        return matched_entries[0]["chip"]
    return None


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Split datasheet PDFs into peripheral-focused text bundles."
    )
    parser.add_argument(
        "pdf", nargs="?", type=Path, help="Path to a single datasheet PDF"
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Process every PDF in the datasheet directory",
    )
    parser.add_argument("--chip", help="Chip name, for example ATmega328P")
    parser.add_argument("--atdf", type=Path, help="Path to a single ATDF file")
    parser.add_argument(
        "--atdf-dir",
        type=Path,
        default=DEFAULT_ATDF_DIR,
        help="Directory containing ATDF files for matching PDFs in --all mode",
    )
    parser.add_argument(
        "--pdf-dir",
        type=Path,
        default=DEFAULT_DATASHEET_DIR,
        help="Directory containing datasheet PDFs for --all mode",
    )
    parser.add_argument(
        "--config",
        type=Path,
        default=DEFAULT_CONFIG_PATH,
        help="Peripheral search hint config",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=DEFAULT_OUTPUT_DIR,
        help="Directory or chip-specific output directory",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Regenerate outputs even if the current PDF+ATDF pair was already processed",
    )
    return parser


def main() -> int:
    parser = build_argument_parser()
    args = parser.parse_args()
    config = load_config(args.config)

    if args.all:
        if args.pdf is not None or args.chip is not None or args.atdf is not None:
            parser.error("Do not pass pdf, --chip, or --atdf when using --all.")

        pdf_paths = discover_pdf_paths(args.pdf_dir)
        if not pdf_paths:
            print(
                f"No PDF files found in {relative_display_path(args.pdf_dir)}",
                file=sys.stderr,
            )
            return 0

        jobs, warnings = build_batch_jobs(args.pdf_dir, args.atdf_dir)
        if not jobs:
            for warning in warnings:
                print(warning, file=sys.stderr)
            return 1

        failures: list[str] = []
        processed_count = 0
        skipped_count = 0

        for pdf_path, chip_name, atdf_path in jobs:
            try:
                _, skipped = split_datasheet(
                    pdf_path,
                    chip_name,
                    atdf_path,
                    config,
                    args.output,
                    force=args.force,
                )
                if skipped:
                    skipped_count += 1
                else:
                    processed_count += 1
            except Exception as error:  # noqa: BLE001
                failures.append(
                    f"Failed to split {relative_display_path(pdf_path)} for chip {chip_name}: {error}"
                )

        print(
            f"Processed {processed_count} chip datasheet jobs into {relative_display_path(args.output)}"
        )
        if skipped_count:
            print(f"Skipped {skipped_count} outputs that were already up to date")
        for warning in warnings:
            print(warning, file=sys.stderr)
        for failure in failures:
            print(failure, file=sys.stderr)
        return 1 if failures else 0

    if args.pdf is None:
        parser.error("Provide a PDF path or use --all.")

    available_atdfs = {path.stem: path for path in discover_atdf_paths(args.atdf_dir)}
    chip_name = infer_chip_name_for_pdf(args.pdf, args.chip, args.atdf, available_atdfs)
    if chip_name is None:
        parser.error(
            "Could not infer a single chip from the PDF filename. Pass --chip or --atdf explicitly."
        )

    atdf_path = args.atdf or (args.atdf_dir / f"{chip_name}.atdf")
    output_directory, skipped = split_datasheet(
        args.pdf,
        chip_name,
        atdf_path,
        config,
        args.output,
        force=args.force,
    )

    if skipped:
        print(
            f"Skipped {relative_display_path(output_directory)} because it is already up to date"
        )
    else:
        print(f"Wrote datasheet sections to {relative_display_path(output_directory)}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except RuntimeError as error:
        print(error, file=sys.stderr)
        raise SystemExit(1)
