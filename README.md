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
| **Smart Models** | `hybrid` (default), `pipeline`, `vlm`, `MinerU-HTML` |
| **Rich Extraction** | OCR (109 languages), LaTeX formulas, cross-page tables |
| **Batch Processing** | Parse up to 200 files per request |
| **Extra Formats** | Export to DOCX, HTML, or LaTeX alongside Markdown |
| **CLI Script** | `mineru-parse.sh` for quick command-line usage |
| **Auto-Extract** | Download + unzip + display markdown in one step |
| **Book Skill Packs** | Stage parsed books for LLM extraction into candidate agent skills |

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

# Parse local file with VLM model
./scripts/mineru-parse.sh report.pdf --model vlm --ocr --output ./out

# Extra output formats
./scripts/mineru-parse.sh slides.pptx --format docx --format html

# Turn a book into an LLM-ready skill extraction workspace
./scripts/mineru-book-to-skill.sh book.pdf --title "My Book" --output ./workspaces --cloud-ok
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
| `hybrid` | General use | Medium | **Default since v2.7.0, recommended** |
| `pipeline` | CPU-only environments | Fast | No GPU required |
| `vlm` | Complex layouts, scanned docs | Slower | Needs 10GB+ VRAM |
| `MinerU-HTML` | Preserving HTML structure | Medium | Web content |

## API Limits (Cloud)

| Item | Limit |
|------|-------|
| File size | 200 MB |
| Pages per file | 600 |
| Daily priority pages | 2,000 / account |
| Batch upload | 200 files / request |
| Token validity | 90 days |

## Book-to-Skill Workflow

First iteration support is implemented as a staging workflow. It prepares a
parsed book for a large language model, but it does **not** call an LLM and does
**not** install or enable generated skills automatically.

```bash
# Local files are uploaded to the MinerU cloud API; --cloud-ok is required.
./scripts/mineru-book-to-skill.sh ~/Books/example.pdf \
  --title "Example Book" \
  --output ./book-workspaces \
  --cloud-ok
```

The wrapper creates:

```
book-workspaces/
└── books/
    └── example-book/
        ├── README.md
        ├── source/
        ├── mineru/
        │   ├── parse_manifest.json
        │   ├── *_result.zip
        │   └── <extracted markdown files>
        └── analysis/
            └── book-skill-pack/
                ├── README.md
                ├── manifest.json
                ├── LLM_EXTRACTION_PROMPT.md
                ├── BOOK_SKILL_INDEX.md
                ├── MANAGE_SKILLS.md
                ├── source-markdown/
                └── skills/
```

Give `LLM_EXTRACTION_PROMPT.md` and `source-markdown/` to a model. The model
should fill `BOOK_SKILL_INDEX.md` and create one candidate file per extracted
skill under `skills/`.

Expected model output is book-scoped:

- what the book can help the agent do
- when the agent should reference the book
- candidate workflows, checklists, diagnostics, decision rules, and prompt patterns
- source anchors and confidence
- which candidates should stay book-scoped vs be promoted to managed skills

### Privacy Boundary

This repository uses the MinerU cloud API by default. Local book files are
uploaded to MinerU during parsing. Use a local MinerU workflow for private or
sensitive books. Generated packs do not store API tokens, authorization headers,
or remote result URLs.

### Manage Skills Boundary

Book packs are candidate workspaces. Review the generated `skills/*.md` files
before promoting anything into a managed skill repository. Use your local skill
manager only after review, for example:

```bash
skills enable <promoted-skill-name>
```

### Roadmap Notes

Next iterations should make extraction more structural:

- split the parsed book by chapters or section headings
- extract skill candidates from each chapter first
- synthesize the whole-book summary after chapter-level extraction
- keep generated skills packaged by the book's structure, so an agent can refer
  to the book as a coherent source package

The same pipeline should later generalize beyond books. Future inputs can
include video courses, papers, and other long-form text. Before extraction, the
system should classify the text type, such as book, course transcript, paper,
manual, or article collection, then choose the right segmentation and skill
extraction strategy.

## Examples

See the [`examples/`](examples/) directory for:

- **[parse_single.sh](examples/parse_single.sh)** — Parse a single PDF from URL
- **[parse_local.sh](examples/parse_local.sh)** — Upload and parse a local file
- **[parse_batch.py](examples/parse_batch.py)** — Batch parse multiple documents (Python)
- **[book_to_skill.sh](examples/book_to_skill.sh)** — Parse a book and stage an LLM-ready skill pack

## Project Structure

```
mineru-skill/
├── SKILL.md                 # Claude Code skill definition (full API reference)
├── scripts/
│   ├── mineru-parse.sh      # CLI helper script
│   ├── mineru-book-to-skill.sh # Book parsing + skill-pack staging wrapper
│   └── book-skill-pack.sh   # Build a skill extraction pack from Markdown
├── examples/
│   ├── parse_single.sh      # Single URL parsing example
│   ├── parse_local.sh       # Local file parsing example
│   ├── parse_batch.py       # Batch processing example (Python)
│   └── book_to_skill.sh     # Book-to-skill workspace example
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

## Contributing

Contributions are welcome! Please read the [Contributing Guide](CONTRIBUTING.md) before submitting a PR.

## Related Projects

- [MinerU](https://github.com/opendatalab/MinerU) — The document parsing engine by OpenDataLab
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — Anthropic's CLI for Claude

## License

[MIT](LICENSE) &copy; 2026 LeoLin990405
