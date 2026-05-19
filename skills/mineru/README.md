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

## Examples

See the [`examples/`](examples/) directory for:

- **[parse_single.sh](examples/parse_single.sh)** — Parse a single PDF from URL
- **[parse_local.sh](examples/parse_local.sh)** — Upload and parse a local file
- **[parse_batch.py](examples/parse_batch.py)** — Batch parse multiple documents (Python)

## Project Structure

```
mineru-skill/
├── SKILL.md                 # Claude Code skill definition (full API reference)
├── scripts/
│   └── mineru-parse.sh      # CLI helper script
├── examples/
│   ├── parse_single.sh      # Single URL parsing example
│   ├── parse_local.sh       # Local file parsing example
│   └── parse_batch.py       # Batch processing example (Python)
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
