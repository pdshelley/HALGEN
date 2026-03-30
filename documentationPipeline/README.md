# Documentation Pipeline

This pipeline prepares datasheet + ATDF context for HALGEN chip documentation,
then uses OpenCode agents to turn that into `docs/<Chip>.json` files.

## Recommended Workflow

Run everything from the repository root.

### 1. Install the Python dependencies

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r documentationPipeline/requirements.txt
```

### 2. Put the datasheets in place

Copy the PDF datasheets into `documentationPipeline/datasheets/`.

Important: the PDF filename should clearly contain the chip name, for example
`ATtiny85.pdf` or `ATmega328P-datasheet.pdf`.

### 3. Prepare the full batch

Generate all skeletons:

```bash
python3 documentationPipeline/scripts/skeleton_generator.py --all
```

Split all datasheets into peripheral bundles:

```bash
python3 documentationPipeline/scripts/pdf_splitter.py --all
```

If you rerun this command later, already-generated chip outputs are skipped
automatically. Use `--force` if you want to regenerate them.

Generate all split-bitfield reports:

```bash
python3 documentationPipeline/scripts/split_bitfield_detector.py --all
```

After this step you will have:
- skeletons in `documentationPipeline/output/skeletons/`
- datasheet slices in `documentationPipeline/output/datasheet_sections/<Chip>/`
- split-bitfield reports in `documentationPipeline/output/skeletons/`

### 4. Install the OpenCode agents

```bash
mkdir -p .opencode/agents
cp documentationPipeline/agents/*.md .opencode/agents/
```

### 5. Generate one chip file at a time with OpenCode

The preparation step is batch-oriented. The LLM authoring step should still be
done per chip.

Recommended usage:
- stay in your normal OpenCode session
- invoke the orchestrator as `@doc-orchestrator`
- do one chip per prompt

Recommended prompt template:

```text
@doc-orchestrator Generate `docs/ATtiny85.json`.

Assume the batch preparation scripts were already run. Do not rerun any prep
scripts from this agent.

Use these inputs:
- `atdf/ATtiny85.atdf`
- `documentationPipeline/datasheets/ATtiny85.pdf`
- `documentationPipeline/output/skeletons/ATtiny85.json`
- `documentationPipeline/output/skeletons/ATtiny85.split-bitfields.json`
- `documentationPipeline/output/datasheet_sections/ATtiny85/`
- `docs/ATmega328P.json` as the style reference

Write the draft to `documentationPipeline/output/drafts/ATtiny85.json`.
Keep `_meta` during the draft stage, validate the result, then write the final clean file to `docs/ATtiny85.json`.
```

Then repeat the same pattern for the next chip.

Important:
- the orchestrator is intended for one chip at a time
- the batch scripts prepare all chips at once, but the LLM generation step is per chip
- this keeps the prompt size reasonable and makes failures easy to retry

### 5a. Generate all prepared chips with OpenCode

If you want one OpenCode run to work through the whole prepared batch, use the
batch orchestrator. It delegates one chip at a time to `@doc-orchestrator`.

Prompt template:

```text
@batch-doc-orchestrator Generate documentation for all prepared chips.

Use the prepared inputs in `documentationPipeline/output/`.
Assume the batch preparation scripts were already run. Do not rerun any prep
scripts from this agent.
Skip chips that already have `docs/<Chip>.json`.
Process chips strictly sequentially, one chip at a time. Do not run multiple
chip generations concurrently.
For each remaining chip, use `docs/ATmega328P.json` as the style reference,
write the draft to `documentationPipeline/output/drafts/<Chip>.json`, keep `_meta`
during the draft stage, and write the final clean file to `docs/<Chip>.json`.

Continue past failures and give me a final list of completed, skipped, and failed chips.
```

### 6. Validate and write the final clean file

Validate the draft first:

```bash
python3 documentationPipeline/scripts/validate_chip_json.py documentationPipeline/output/drafts/ATtiny85.json --atdf atdf/ATtiny85.atdf --draft
```

When the draft looks good, write the final clean file into `docs/`:

```bash
python3 documentationPipeline/scripts/validate_chip_json.py documentationPipeline/output/drafts/ATtiny85.json --atdf atdf/ATtiny85.atdf --write-clean docs/ATtiny85.json
```

## `_meta` Lifecycle

`_meta` stays in the JSON during the preparation and drafting stages.

That means:
- skeletons keep `_meta`
- draft files keep `_meta`
- OpenCode can use `_meta` while filling in documentation

`_meta` is removed at the final cleaning step when you run:

```bash
python3 documentationPipeline/scripts/validate_chip_json.py ... --write-clean docs/<Chip>.json
```

That command strips every key that starts with `_` before writing the final chip
file.

## Output Layout

- `documentationPipeline/output/skeletons/` - preparation artifacts
- `documentationPipeline/output/datasheet_sections/<Chip>/` - peripheral text bundles
- `documentationPipeline/output/drafts/` - LLM draft chip files
- `docs/<Chip>.json` - final cleaned chip files

## Notes

- `docs/general.json` remains the source of truth for stable API naming.
- Chip JSON files are for datasheet-backed documentation and true chip-specific
  overrides.
- `pdf_splitter.py` expects text-based PDFs. If a datasheet is scanned, run OCR
  first.
