#!/usr/bin/env python3
"""
Clean a chip draft by stripping _meta fields and writing the final output.

Usage:
    python3 clean_draft.py <draft.json> <output.json>
"""

import json
import sys
from pathlib import Path


def strip_meta(obj):
    """Recursively remove _meta keys from a dict."""
    if isinstance(obj, dict):
        return {k: strip_meta(v) for k, v in obj.items() if k != "_meta"}
    elif isinstance(obj, list):
        return [strip_meta(item) for item in obj]
    return obj


def main() -> None:
    if len(sys.argv) != 3:
        print("Usage: clean_draft.py <draft.json> <output.json>", file=sys.stderr)
        sys.exit(1)

    draft_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])

    with open(draft_path) as f:
        draft = json.load(f)

    cleaned = strip_meta(draft)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w") as f:
        json.dump(cleaned, f, indent=2, ensure_ascii=False)

    reg_count = len(cleaned.get("registers", {}))
    bf_count = len(cleaned.get("bitfields", {}))
    print(
        f"Cleaned draft written to {output_path} ({reg_count} registers, {bf_count} bitfields)"
    )


if __name__ == "__main__":
    main()
