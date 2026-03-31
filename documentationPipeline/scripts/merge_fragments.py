#!/usr/bin/env python3
"""
Merge peripheral-documentation JSON fragments into a chip skeleton.

Usage:
    python3 merge_fragments.py <skeleton.json> <output.json> <fragment1.json> [fragment2.json ...]

Each fragment is a JSON object with optional "registers" and "bitfields" keys.
The script deep-merges all fragments into the skeleton and writes the result.
_meta fields in the skeleton are preserved.
"""

import json
import sys
from pathlib import Path


def deep_merge(base: dict, updates: dict) -> None:
    """Deep merge updates into base dict."""
    for key, value in updates.items():
        if key == "_meta":
            continue
        if key in base and isinstance(base[key], dict) and isinstance(value, dict):
            deep_merge(base[key], value)
        else:
            base[key] = value


def main() -> None:
    if len(sys.argv) < 4:
        print(
            "Usage: merge_fragments.py <skeleton.json> <output.json> <fragment1.json> [fragment2.json ...]",
            file=sys.stderr,
        )
        sys.exit(1)

    skeleton_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])
    fragment_paths = [Path(p) for p in sys.argv[3:]]

    with open(skeleton_path) as f:
        draft = json.load(f)

    merged_count = 0
    for frag_path in fragment_paths:
        with open(frag_path) as f:
            fragment = json.load(f)
        deep_merge(draft, fragment)
        merged_count += 1

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w") as f:
        json.dump(draft, f, indent=2, ensure_ascii=False)

    print(f"Merged {merged_count} fragments into {output_path}")


if __name__ == "__main__":
    main()
