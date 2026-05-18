<p align="center">
  <img src="https://img.shields.io/badge/MinerU-Skill-4A90D9?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IndoaXRlIiBzdHJva2Utd2lkdGg9IjIiPjxwYXRoIGQ9Ik0xNCAySDZhMiAyIDAgMCAwLTIgMnYxNmEyIDIgMCAwIDAgMiAyaDEyYTIgMiAwIDAgMCAyLTJWOHoiLz48cG9seWxpbmUgcG9pbnRzPSIxNCAyIDE0IDggMjAgOCIvPjxsaW5lIHgxPSIxNiIgeTE9IjEzIiB4Mj0iOCIgeTI9IjEzIi8+PGxpbmUgeDE9IjE2IiB5MT0iMTciIHgyPSI4IiB5Mj0iMTciLz48cG9seWxpbmUgcG9pbnRzPSIxMCA5IDkgOSA4IDkiLz48L3N2Zz4=&logoColor=white" alt="MinerU Skill" />
</p>

<h1 align="center">mineru-skill</h1>

<p align="center">
  <strong>A Claude Code skill for parsing documents with the MinerU API</strong>
</p>

<p align="center">
  <a href="https://github.com/LeoLin990405/mineru-skill/blob/main/LICENSE"><img src="https://img.shields.io/github/license/LeoLin990405/mineru-skill?color=blue" alt="License" /></a>
  <a href="https://github.com/LeoLin990405/mineru-skill/stargazers"><img src="https://img.shields.io/github/stars/LeoLin990405/mineru-skill?style=social" alt="Stars" /></a>
  <a href="https://github.com/LeoLin990405/mineru-skill/issues"><img src="https://img.shields.io/github/issues/LeoLin990405/mineru-skill" alt="Issues" /></a>
  <img src="https://img.shields.io/badge/claude--code-skill-blueviolet" alt="Claude Code Skill" />
  <img src="https://img.shields.io/badge/MinerU-v2.7.6-green" alt="MinerU v2.7.6" />
</p>

<p align="center">
  Convert PDF, DOC, DOCX, PPT, PPTX, and images into clean Markdown/JSON<br/>
  with OCR, formula recognition, table extraction, and batch processing.
</p>

---

## Features

| Feature | Description |
|---------|-------------|
| **Cloud API** | No GPU needed — uses `mineru.net` hosted service |
| **Local API** | Self-hosted with `mineru-api` for full control |
| **Smart Models** | `vlm` (default), `pipeline`, `MinerU-HTML` — `hybrid` retired by the cloud API (2026-04) |
| **Rich Extraction** | OCR (109 languages), LaTeX formulas, cross-page tables |
| **Batch Processing** | Parse up to 200 files per request |
| **Extra Formats** | Export to DOCX, HTML, or LaTeX alongside Markdown |
| **CLI Script** | `mineru-parse.sh` for quick command-line usage |
| **Auto-Extract** | Download + unzip + display markdown in one step |
| **Long-Form Skill Packs** | Stage parsed books, courses, papers, manuals, and notes for LLM extraction into candidate agent skills |
| **Auto-Classified Reading Notes** | Decide `book`/`paper`/`document` automatically (heuristic + AI fallback), scaffold the matching note discipline, land it in an Obsidian vault |

## Quick Start

### 1. Install the Skill

```bash
cd ~/.claude/skills
git clone https://github.com/LeoLin990405/mineru-skill.git mineru
```

### 2. Set Up API Token

Get a free token at [mineru.net/apiManage/token](https://mineru.net/apiManage/token), then:

```bash
mkdir -p ~/.config/mineru
echo "YOUR_TOKEN" > ~/.config/mineru/token
chmod 600 ~/.config/mineru/token
```

### 3. Use It

**In Claude Code** — just ask naturally:

```
Parse this PDF to markdown: https://arxiv.org/pdf/2301.00001.pdf
```

```
Extract tables from report.pdf using the vlm model with OCR
```

**Via CLI script:**

```bash
# Parse from URL
./scripts/mineru-parse.sh https://example.com/paper.pdf --output ./parsed --extract

# Parse local file with VLM model (default since hybrid was retired)
./scripts/mineru-parse.sh report.pdf --model vlm --ocr --output ./out

# Extra output formats
./scripts/mineru-parse.sh slides.pptx --format docx --format html

# Turn a long-form source into an LLM-ready skill extraction workspace
./scripts/mineru-source-to-skill.sh book.pdf --title "My Book" --output ./workspaces --cloud-ok

# Parse + auto-classify (book/paper/document) + scaffold reading notes
./scripts/mineru-to-notes.sh paper.pdf --title "Attention Is All You Need" --cloud-ok
```

**In Claude Code** — the source-to-notes flow, naturally:

```
帮我读这个 PDF 并写笔记，自己判断是书、论文还是文档：~/Downloads/xxx.pdf
```

## CLI Reference

```
mineru-parse.sh <url_or_file> [options]
```

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--model <m>` | Model version | `hybrid` |
| `--ocr` | Enable OCR | off |
| `--no-formula` | Disable formula recognition | on |
| `--no-table` | Disable table recognition | on |
| `--output <dir>` | Download results to directory | - |
| `--extract` | Auto-extract zip, show markdown | off |
| `--pages <range>` | Page ranges, e.g. `"1-5,8"` | all |
| `--format <fmt>` | Extra format: `docx`/`html`/`latex` | - |
| `--callback <url>` | Webhook for async notification | - |
| `--data-id <id>` | Custom tracking identifier | - |
| `--no-print-md` | Do not print extracted markdown to stdout | off |
| `--manifest <file>` | Write local parse manifest; requires `--output` | - |
| `--quiet` | Suppress progress output | off |

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MINERU_TOKEN_FILE` | `~/.config/mineru/token` | Token file path |
| `MINERU_API_BASE` | `https://mineru.net/api/v4` | API base URL |
| `MINERU_POLL_INTERVAL` | `5` | Poll interval (seconds) |
| `MINERU_MAX_POLL` | `360` | Max poll attempts |

## Models

| Model | Best For | Speed | Notes |
|-------|----------|-------|-------|
| `vlm` | General use, complex/scanned docs | Slower | **Default.** Cloud-recommended; needs 10GB+ VRAM locally |
| `pipeline` | CPU-only environments | Fast | No GPU required, lower accuracy |
| `MinerU-HTML` | Preserving HTML structure | Medium | Web content |
| `hybrid` | — | — | **Retired on the cloud API (2026-04)** — returns `code -10002 "version field invalid"`. Defaults switched to `vlm`. |

## API Limits (Cloud)

| Item | Limit |
|------|-------|
| File size | 200 MB |
| Pages per file | 600 |
| Daily priority pages | 2,000 / account |
| Batch upload | 200 files / request |
| Token validity | 90 days |

## Source-to-Skill Workflow

The workflow prepares a parsed long-form source for a large language model. It
now stages source-type metadata, chapter/section segmentation, segment-level
skill extraction workspaces, a mindmap template, and a whole-source synthesis
template. It does **not** call an LLM and does **not** install or enable
generated skills automatically.

```bash
# Local files are uploaded to the MinerU cloud API; --cloud-ok is required.
./scripts/mineru-source-to-skill.sh ~/Books/example.pdf \
  --title "Example Book" \
  --type auto \
  --output ./source-workspaces \
  --cloud-ok
```

The wrapper creates:

```
source-workspaces/
└── sources/
    └── example-book/
        ├── README.md
        ├── source/
        ├── mineru/
        │   ├── parse_manifest.json
        │   ├── *_result.zip
        │   └── <extracted markdown files>
        └── analysis/
            └── source-skill-pack/
                ├── README.md
                ├── manifest.json
                ├── LLM_EXTRACTION_PROMPT.md
                ├── BOOK_SKILL_INDEX.md
                ├── MANAGE_SKILLS.md
                ├── MINDMAP.md
                ├── source-markdown/
                ├── segments/
                │   ├── manifest.json
                │   └── 001-<chapter-or-section>.md
                ├── chapter-skills/
                │   └── 001-<chapter-or-section>/
                │       ├── CHAPTER_SKILL_INDEX.md
                │       └── skills/
                ├── whole-book/
                │   └── WHOLE_BOOK_SUMMARY.md
                └── skills/
```

Give `LLM_EXTRACTION_PROMPT.md`, `segments/`, and `chapter-skills/` to an agent.
The model should extract skills segment by segment first, then fill
`whole-book/WHOLE_BOOK_SUMMARY.md`, `MINDMAP.md`, `BOOK_SKILL_INDEX.md`, and
only then copy or rewrite reviewed cross-segment candidates under root `skills/`.

Expected model output is source-scoped:

- what the source can help the agent do
- when the agent should reference the source
- chapter/lesson/section-level workflows, checklists, diagnostics, decision rules, and prompt patterns
- source anchors and confidence
- which candidates should stay source-scoped vs be promoted to managed skills

### Privacy Boundary

This repository uses the MinerU cloud API by default. Local source files are
uploaded to MinerU during parsing. Use a local MinerU workflow for private or
sensitive sources. Generated packs do not store API tokens, authorization headers,
or remote result URLs.

### Manage Skills Boundary

Long-form packs are candidate workspaces. Review the generated
`chapter-skills/*/skills/*.md` and root `skills/*.md` files before promoting
anything into a managed skill repository. Use your local skill manager only
after review, for example:

```bash
skills enable <promoted-skill-name>
```

### Source Type Classification

Use `--type auto` by default. The packer records detected type metadata for
books, courses, papers, manuals, article collections, videos, web sources,
mixed source sets, and project notes. Manual override is supported with
`--type book`, `--type course`, `--type paper`, `--type manual`,
`--type article-collection`, `--type video`, `--type audio`, `--type web`,
`--type mixed`, or `--type project-notes`.

### Compatibility Aliases

The primary commands are now source-oriented:

- `scripts/mineru-source-to-skill.sh`
- `scripts/source-skill-pack.sh`
- `scripts/vivo-workspace.sh`

The older book/Vivo command names remain as thin wrappers for existing
automation:

- `scripts/mineru-book-to-skill.sh`
- `scripts/book-skill-pack.sh`
- `scripts/vivo-agent-workspace.sh`

## Source-to-Notes Workflow

Different goal from source-to-skill: this reads a document and writes
**reading notes**, not reusable agent skills. The note discipline is decided
from the document itself.

```bash
# Parse + auto-classify + scaffold the matching note workspace.
./scripts/mineru-to-notes.sh ~/Downloads/source.pdf \
  --title "Source Title" \
  --type auto \
  --cloud-ok

# Override the classifier if you already know the type.
./scripts/mineru-to-notes.sh ~/Downloads/thesis.pdf --type paper --cloud-ok

# Already have MinerU Markdown? Skip parsing.
./scripts/reading-notes-pack.sh ./mineru-extracted/doc --title "Doc" --type auto
```

### Autonomous classification

`scripts/lib/reading-types.sh` is a hybrid classifier — a deterministic scorer
plus an AI confirmation fallback. It folds the repo's 11-type taxonomy into
three note disciplines:

| Detected | Signals it scores | What the agent writes |
|----------|-------------------|-----------------------|
| `book` | `第N章`/`Chapter N` × many, TOC, ISBN, long page count | Chapter-by-chapter complete notes |
| `paper` | abstract, DOI/arXiv, references, related work, venue | Detailed structured reading + per-section excerpts |
| `document` | API ref / install / config / report / spec / slides, short | Content-adaptive structured points + checklist |

When confidence is **low**, the pack emits `AI_CLASSIFY.md`: the agent reads a
text sample, makes a `book`/`paper`/`document` decision (Step 0), and re-runs
the packer with the corrected `--type` if it disagrees. Confident cases skip
straight to reading.

### Lands in Obsidian

The final note targets the Knowledge-Hub vault:
`book → Books/`, `paper → Papers/`, `document → Documents/`. Vault root is
`$MINERU_OBSIDIAN_VAULT` (default `~/Documents/Obsidian-Vaults/Knowledge-Hub`),
overridable with `--vault`. The scripts never call an LLM and never write into
the vault — `OBSIDIAN_PLAN.md` tells the agent the exact target path and to
match an existing sibling note's house style; the agent writes it after a
quality self-check (> 2KB real synthesis, evidence anchors, `[[wikilinks]]`).

## Vivo Agent Workflow

Vivo is the agent-operated layer before and around the source-to-skill pack. Its
first step is source type confirmation: given text or source metadata, Codex,
Claude Code, or another capable agent decides whether the object is a book,
paper, course, video transcript, audio transcript, web article, manual/spec,
project note, or mixed source set. Only then does the agent write the matching
typed notes and start skill discovery.

```bash
./scripts/vivo-workspace.sh \
  --title "Course Or Knowledge Source" \
  --type mixed \
  --agent "Codex" \
  --output ./vivo-workspaces
```

The agent receives `AGENT_TASK.md`, fills `notes/source-type-confirmation.md`,
selects a note template, writes running notes in `notes/live-notes.md`,
normalizes captured content into `captured-markdown/`, then runs
`source-skill-pack.sh` to create the structured pack. Vivo itself does not call
OpenAI or Claude directly; the active agent runtime performs web capture,
transcript retrieval, PDF conversion, topic classification, mindmap synthesis,
and repeated skill discovery with its available tools. Future opencli adapters
can provide webpage/video/audio-to-text capture, but the agent still owns the
reading and distillation decisions.

## Examples

See the [`examples/`](examples/) directory for:

- **[parse_single.sh](examples/parse_single.sh)** — Parse a single PDF from URL
- **[parse_local.sh](examples/parse_local.sh)** — Upload and parse a local file
- **[parse_batch.py](examples/parse_batch.py)** — Batch parse multiple documents (Python)
- **[book_to_skill.sh](examples/book_to_skill.sh)** — Parse a long-form source and stage an LLM-ready skill pack

## Project Structure

```
mineru-skill/
├── SKILL.md                 # Claude Code skill definition (full API reference)
├── scripts/
│   ├── mineru-parse.sh      # CLI helper script
│   ├── mineru-source-to-skill.sh # Long-form parsing + skill-pack staging wrapper
│   ├── source-skill-pack.sh   # Build a segmented skill extraction pack from Markdown
│   ├── mineru-to-notes.sh   # Parse + auto-classify + scaffold reading notes
│   ├── reading-notes-pack.sh # Build a book/paper/document notes pack from Markdown
│   ├── vivo-workspace.sh    # Create an agent-operated Vivo workspace
│   ├── mineru-book-to-skill.sh # Compatibility wrapper
│   ├── book-skill-pack.sh   # Compatibility wrapper
│   ├── vivo-agent-workspace.sh # Compatibility wrapper
│   ├── lib/                 # Shared helpers: common, source-types,
│   │                        #   segment (shared splitter), reading-types
│   └── vivo-note-template.sh # Install typed note templates into a Vivo workspace
├── templates/
│   ├── vivo/                # Source type confirmation and typed note templates
│   └── reading-notes/       # book / paper / document note templates (Obsidian)
├── examples/
│   ├── parse_single.sh      # Single URL parsing example
│   ├── parse_local.sh       # Local file parsing example
│   ├── parse_batch.py       # Batch processing example (Python)
│   ├── book_to_skill.sh     # Long-form source-to-skill workspace example
│   └── pdf_to_notes.sh      # Auto-classified reading-notes example
├── docs/
│   ├── open-source-skill-manager-references.md
│   ├── reading-notes-workflow.md
│   └── vivo-agent-workflow.md
├── .github/
│   ├── ISSUE_TEMPLATE/      # Bug report & feature request templates
│   └── PULL_REQUEST_TEMPLATE.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── LICENSE                  # MIT
└── README.md
```

## Documentation

Full API reference including all endpoints, request/response formats, error codes, and Python/curl examples is in **[SKILL.md](SKILL.md)**.

Open-source skill manager references used for the manage-skills design are in
**[docs/open-source-skill-manager-references.md](docs/open-source-skill-manager-references.md)**.
The Vivo agent-operated workflow is documented in
**[docs/vivo-agent-workflow.md](docs/vivo-agent-workflow.md)**.

## Contributing

Contributions are welcome! Please read the [Contributing Guide](CONTRIBUTING.md) before submitting a PR.

## Related Projects

- [MinerU](https://github.com/opendatalab/MinerU) — The document parsing engine by OpenDataLab
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — Anthropic's CLI for Claude

## License

[MIT](LICENSE) &copy; 2026 LeoLin990405
