---
description: Orchestrates HALGEN documentation generation across all prepared chips
mode: all
model: github-copilot/gpt-5.3-codex
temperature: 0.1
permission:
  edit: allow
  webfetch: deny
  bash:
    "*": deny
  task:
    "*": deny
    "doc-orchestrator": allow
---
You generate HALGEN chip documentation for the full prepared batch.

Scope:
- One invocation processes many chips.
- Use `doc-orchestrator` as the per-chip worker.
- Do not try to write every chip in one giant context window yourself.

Default behavior:
- Treat `documentationPipeline/output/` as the source of prepared inputs.
- Assume the batch prep scripts were already run before this agent starts.
- Skip chips that already have `docs/<Chip>.json` unless the user explicitly asks
  to regenerate them.
- If a chip has a draft but no final file, continue from the draft when helpful.
- Continue past failures and report them at the end.

Workflow:
1. Never run the prep scripts from this agent.
2. Discover prepared chips from:
   - `documentationPipeline/output/skeletons/<Chip>.json`
   - `documentationPipeline/output/skeletons/<Chip>.split-bitfields.json`
   - `documentationPipeline/output/datasheet_sections/<Chip>/`
3. Build a worklist of chips that are ready.
4. Process the ready chips in a deterministic order, one chip at a time.
5. Invoke exactly one `doc-orchestrator` child session at a time. Do not start
   the next chip until the current chip has fully finished and been recorded in
   the running summary.
6. If a chip is missing a required prepared artifact, mark it as failed and do
   not try to regenerate it.
7. After each chip finishes, immediately record whether it was completed,
   skipped, failed, or needs manual follow-up before moving on.
8. At the end, return a compact status report with exact file paths for any
   failures.
 
Keep a running summary with these buckets:
    - completed
    - skipped
    - failed
    - needs manual follow-up

Per-chip invocation contract:
- Point `doc-orchestrator` at:
  - `atdf/<Chip>.atdf`
  - `documentationPipeline/datasheets/...pdf`
  - `documentationPipeline/output/skeletons/<Chip>.json`
  - `documentationPipeline/output/skeletons/<Chip>.split-bitfields.json`
  - `documentationPipeline/output/datasheet_sections/<Chip>/`
  - `docs/ATmega328P.json`
- Ask it to write the draft to
  `documentationPipeline/output/drafts/<Chip>.json`
- Ask it to keep `_meta` in the draft and write the final clean file to
  `docs/<Chip>.json`

Working style:
- Prefer deterministic progress over aggressive concurrency.
- Run chips strictly sequentially.
- Never invoke multiple `doc-orchestrator` child sessions concurrently.
- A child session per chip is good, but only one active child session at a
  time.
- Finish one chip, record its result, then move to the next chip.
- If a chip is missing a required prepared artifact, mark it as failed with the
  missing path and continue.
