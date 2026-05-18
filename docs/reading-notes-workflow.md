# Source-to-Notes Workflow

This workflow turns a PDF/document into **reading notes**, with the note
discipline chosen automatically from the document itself. It is a sibling of
the source-to-skill workflow but has a different output contract: notes for a
human/agent knowledge base, not reusable agent skills.

## Pipeline

```
input (PDF / DOC / PPT / image / URL)
  │
  ▼  scripts/mineru-parse.sh           (MinerU cloud parse → Markdown)
  │
  ▼  scripts/lib/reading-types.sh      (hybrid classify: heuristic + AI fallback)
  │       book | paper | document  + confidence
  │
  ▼  scripts/reading-notes-pack.sh     (scaffold the matching note discipline)
  │       classification.json, AI_READING_TASK.md, OBSIDIAN_PLAN.md,
  │       segments/, notes/<slug>.md
  │
  ▼  the active agent                  (reads Markdown, writes notes)
  │
  ▼  Obsidian Knowledge-Hub vault      (final note, written by the agent)
```

`scripts/mineru-to-notes.sh` runs the whole chain. No script in this chain
calls an LLM, and no script writes into the vault.

## Classification (hybrid, autonomous)

`classify_reading_type` scores the title plus a sample of the parsed Markdown
(first 220 + last 80 lines) and an optional page count:

| Bucket | Evidence | Confidence raises when |
|--------|----------|------------------------|
| `paper` | abstract, `\bdoi\b`/arXiv, references, related work, paper voice, venue, methodology | several independent paper signals fire |
| `book` | many `第N章`/`Chapter N`, table of contents, ISBN, front matter, parts, long page count | ≥5 chapter headings or ISBN + length |
| `document` | API ref / install / config / troubleshooting / report / spec / slides; short single doc | manual or report markers, or short with no book/paper signals |

The scorer always returns a best guess plus a band:

- `high` / `medium` — the pack proceeds for that type.
- `low` — the pack also writes `AI_CLASSIFY.md`. The agent must do **Step 0**:
  read the sample, decide `book`/`paper`/`document`, and either confirm
  (`needs_ai_confirmation → false`) or re-run the packer with the correct
  `--type`. This is the AI fallback that makes classification autonomous even
  on adversarial inputs the heuristic cannot resolve.

Manual override: `--type book|paper|document` skips classification entirely.

## Note disciplines

| Type | Template | Discipline |
|------|----------|------------|
| book | `templates/reading-notes/book-notes.md` | Chapter map + one complete note block per chapter (core question, argument, detailed unpacking, key terms, reusable methods, evidence anchors, follow-up), then a whole-book synthesis. Source is split into `segments/` and read chapter by chapter. |
| paper | `templates/reading-notes/paper-notes.md` | One-line summary, structured reading (question, contributions, method, setup, results, limitations, relation to prior work), a per-section excerpt table with anchors, and a personal critique. Read whole — not segmented. |
| document | `templates/reading-notes/document-notes.md` | Reorganized by the document's own structure into retrievable points, emphasis adapted to the kind (manual/report/spec/slides), plus an actionable checklist and a reference index. Split into `segments/` by section. |

## Obsidian integration

The pack's `OBSIDIAN_PLAN.md` resolves the exact target:

- folder: `book → Books/`, `paper → Papers/`, `document → Documents/`
- vault root: `$MINERU_OBSIDIAN_VAULT`, default
  `~/Documents/Obsidian-Vaults/Knowledge-Hub`, overridable with `--vault`
- file: `<slug>.md`

The scripts do **not** create or modify any vault file. The agent:

1. opens an existing sibling note in the target folder and mirrors its
   house style (frontmatter keys, headings, language);
2. fills `notes/<slug>.md`;
3. passes the quality self-check (> 2KB of real synthesis, evidence anchors,
   `[[wikilinks]]`, no leftover `<placeholders>`);
4. writes the final note to the vault target path;
5. appends one `ingest` line to the vault `log.md`.

## Privacy & boundaries

- Local files are uploaded to the MinerU cloud API; `mineru-to-notes.sh`
  requires `--cloud-ok`. Use a local MinerU workflow for private sources.
- Generated packs store no API tokens, auth headers, or remote result URLs
  (`manifest.json` records `llm_invoked: false`, `writes_into_vault: false`,
  `stores_remote_result_url: false`).
- Notes are written by the agent only after the quality self-check, so the
  knowledge base is never polluted with half-finished scaffolds.
