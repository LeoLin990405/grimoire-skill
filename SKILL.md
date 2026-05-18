---
name: mineru
description: MinerU document parsing API - convert PDF/DOC/PPT/images to Markdown/JSON. Supports OCR, formula recognition, table extraction, batch processing, and staging parsed long-form sources for LLM skill extraction.
triggers:
  - mineru
  - pdf解析
  - 文档解析
  - document parsing
  - pdf to markdown
  - extract pdf
  - book to skill
  - 书籍转 skill
  - 从书中提炼 skill
  - 技能提炼
---

# MinerU API Skill

## Overview
MinerU converts PDF, DOC, DOCX, PPT, PPTX, PNG, JPG, JPEG, HTML into machine-readable Markdown/JSON. Supports OCR (109 languages), formula/table recognition, cross-page table merging, and batch processing.

This skill can also stage a parsed long-form source as a **source skill pack**:
a workspace that a large language model can read to extract candidate agent
skills, grouped by source first and then by chapter, lesson, section, or note.
The workflow does not call an LLM and does not install generated skills
automatically.

**Two modes:**
- **Cloud API** — `https://mineru.net/api/v4` (no GPU required, token-based)
- **Local API** — `mineru-api --port 8000` (self-hosted, requires GPU or CPU backend)

## Authentication (Cloud API)

- **Token file**: `~/.config/mineru/token`
- **Header**: `Authorization: Bearer <token>`
- **Get token**: https://mineru.net/apiManage/token

```bash
mkdir -p ~/.config/mineru
echo "YOUR_TOKEN" > ~/.config/mineru/token
chmod 600 ~/.config/mineru/token
```

## Limits (Cloud API)

| Item | Limit |
|------|-------|
| Single file size | 200MB max |
| Single file pages | 600 pages max |
| Daily priority pages | 2000 pages/account |
| Batch upload | 200 files/request |
| Token validity | 90 days |

## Model Versions

| Model | Use Case | Speed | Notes |
|-------|----------|-------|-------|
| `hybrid` | **Default since v2.7.0** — best of pipeline + vlm | Medium | Recommended for most use |
| `pipeline` | General documents, CPU-friendly | Fast | Pure CPU support |
| `vlm` | Complex layouts, higher accuracy | Slower | Needs GPU (10GB+ VRAM) |
| `MinerU-HTML` | HTML output, preserves formatting | Medium | For web content |

## API Endpoints (Cloud)

Base URL: `https://mineru.net/api/v4`

### 1. Create Extraction Task (Single File)
```
POST /extract/task
```

| Param | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| url | string | yes | - | File URL (no direct upload) |
| model_version | string | no | hybrid | `hybrid` / `pipeline` / `vlm` / `MinerU-HTML` |
| is_ocr | bool | no | false | Enable OCR |
| enable_formula | bool | no | true | Formula recognition |
| enable_table | bool | no | true | Table recognition |
| language | string | no | ch | Document language |
| data_id | string | no | - | Custom identifier |
| page_ranges | string | no | - | e.g. "2,4-6" |
| callback | string | no | - | Callback URL for async results |
| extra_formats | array | no | - | `["docx"]`, `["html"]`, `["latex"]` |

**Response:**
```json
{"code": 0, "data": {"task_id": "xxx"}, "msg": "ok"}
```

### 2. Get Task Results
```
GET /extract/task/{task_id}
```

**States:** `pending` → `running` → `done` / `failed` / `converting`

**Done response:** includes `full_zip_url` (download link)

### 3. Batch Upload Local Files
```
POST /file-urls/batch
```
Returns presigned upload URLs (valid 24h). System auto-submits extraction after upload.

### 4. Batch URL Extraction
```
POST /extract/task/batch
```
Submit multiple URLs at once, returns `batch_id`.

### 5. Batch Results
```
GET /extract-results/batch/{batch_id}
```

## Local API (Self-Hosted)

### Start Server
```bash
# FastAPI server
mineru-api --host 0.0.0.0 --port 8000

# Gradio WebUI
mineru-gradio --server-name 0.0.0.0 --server-port 7860

# OpenAI-compatible server (for remote VLM inference)
mineru-openai-server --port 30000
```

### Environment Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `MINERU_MODEL_SOURCE` | Model source: `modelscope` / `huggingface` | huggingface |
| `MINERU_API_MAX_CONCURRENT_REQUESTS` | Max concurrent API requests | Unlimited |
| `MINERU_API_ENABLE_FASTAPI_DOCS` | Enable /docs page | true |

### Local API Docs
Access at `http://127.0.0.1:8000/docs` after starting.

### Use CLI with Remote Server
```bash
mineru -p input.pdf -o output/ -b hybrid-http-client -u http://server:30000
```

## Error Codes

| Code | Issue | Fix |
|------|-------|-----|
| A0202 | Token invalid | Check Bearer prefix and token |
| A0211 | Token expired | Recreate at mineru.net |
| -60002 | Unrecognized format | Check file extension |
| -60005 | File too large | Max 200MB |
| -60006 | Too many pages | Max 600, split document |
| -60008 | URL timeout | Check URL accessibility |
| -60012 | Task not found | Verify task_id |

## Helper Script

`~/.claude/skills/mineru/scripts/mineru-parse.sh` — full-featured CLI wrapper.

```bash
# URL mode
mineru-parse.sh https://example.com/doc.pdf

# Local file with options
mineru-parse.sh /path/to/file.pdf --model vlm --ocr --output /tmp/result

# Extra formats
mineru-parse.sh doc.pdf --format docx --format latex

# Page ranges
mineru-parse.sh doc.pdf --pages "1-5,8" --output ./results

# Auto-extract markdown from zip
mineru-parse.sh doc.pdf --output ./results --extract

# Extract without printing book-sized markdown and write a local manifest
mineru-parse.sh book.pdf --output ./results --extract --no-print-md --manifest ./results/parse_manifest.json
```

## Source-to-Skill Workflow

Use this when the user uploads a book, course, paper, manual, article
collection, or other long-form text and wants the agent to learn which reusable
skills can be extracted from it.

### Commands

```bash
# Local files are uploaded to the MinerU cloud API; --cloud-ok is required.
~/.claude/skills/mineru/scripts/mineru-book-to-skill.sh /path/to/book.pdf \
  --title "Book Title" \
  --type auto \
  --output ./book-workspaces \
  --cloud-ok

# If the book is already parsed to Markdown, stage a pack directly.
~/.claude/skills/mineru/scripts/book-skill-pack.sh ./mineru-extracted/book \
  --title "Book Title" \
  --type auto \
  --output ./book-skill-packs
```

### Output Contract

The wrapper creates a source-scoped workspace:

```text
book-workspaces/
└── books/
    └── <book-slug>/
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

Give `LLM_EXTRACTION_PROMPT.md`, `segments/`, and `chapter-skills/` to the
active agent. The agent should fill:

- `chapter-skills/*/CHAPTER_SKILL_INDEX.md`: what each segment contributes before whole-source synthesis.
- `chapter-skills/*/skills/*.md`: one narrow candidate skill per segment-level capability.
- `whole-book/WHOLE_BOOK_SUMMARY.md`: source-level capability summary after segment extraction.
- `MINDMAP.md`: topic classification and skill-family map.
- `BOOK_SKILL_INDEX.md`: what this source can help the agent do, when to reference it, and a table of skill candidates.
- `skills/*.md`: reviewed cross-segment candidates only, using the generated `_skill-template.md`.

### Extraction Criteria

Extract only content that can become an operational skill:

- procedures and workflows
- checklists
- diagnostics
- decision rules
- reusable prompt patterns
- coding or analysis patterns
- frameworks with clear trigger situations

Keep broad concepts and background theory as reference-only material unless the source gives a concrete procedure.

### Manage Skills Boundary

Long-form skill packs are candidates. Do not automatically install, enable, or sync generated skills. After human review, promote only stable skills into the managed skills repository, then run the local skills manager separately, for example:

```bash
skills enable <promoted-skill-name>
```

The generated pack must not store API tokens, authorization headers, remote result URLs, or private account data.

### Source Type Classification

Use `--type auto` by default. The packer records detected type metadata for
books, courses, papers, manuals, article collections, videos, web sources,
mixed source sets, and project notes. Override with `--type book`,
`--type course`, `--type paper`, `--type manual`, `--type article-collection`,
`--type video`, `--type web`, `--type mixed`, or `--type project-notes` when the
automatic classifier is wrong.

## Vivo Agent Workflow

Use this when the user wants Codex, Claude Code, or another agent to collect
knowledge from web pages, videos, PDFs, courses, books, or existing notes and
distill it into candidate skills.

```bash
~/.claude/skills/mineru/scripts/vivo-agent-workspace.sh \
  --title "Knowledge Source" \
  --type mixed \
  --agent "Claude Code" \
  --output ./vivo-workspaces
```

Vivo creates `AGENT_TASK.md`, `SOURCES.md`, `notes/live-notes.md`,
`notes/topic-classification.md`, `captured-markdown/`, and `packs/`. The script
does not call OpenAI, Claude, or any model. The active agent performs capture
and reasoning with its available tools:

- web pages: browser, fetch, web search, or OpenAI-backed web capability
- videos: subtitles or transcript tools
- PDFs: MinerU parsing or another local converter
- courses: lesson/module/topic classification
- notes: simultaneous durable notes while capture happens

After capture, the agent runs `book-skill-pack.sh` over `captured-markdown/` and
fills segment skills, `whole-book/WHOLE_BOOK_SUMMARY.md`, `MINDMAP.md`, and
`BOOK_SKILL_INDEX.md` before promoting reviewed candidates.

## Quick Parse (Python)

```python
import requests, time

TOKEN = open("~/.config/mineru/token").read().strip()
BASE = "https://mineru.net/api/v4"
HEADERS = {"Authorization": f"Bearer {TOKEN}"}

def parse_document(url, model="hybrid", ocr=False, extra_formats=None):
    """Parse a document from URL, return download link."""
    body = {
        "url": url, "model_version": model,
        "is_ocr": ocr, "enable_formula": True, "enable_table": True,
    }
    if extra_formats:
        body["extra_formats"] = extra_formats

    resp = requests.post(f"{BASE}/extract/task", headers=HEADERS, json=body)
    task_id = resp.json()["data"]["task_id"]

    while True:
        result = requests.get(f"{BASE}/extract/task/{task_id}", headers=HEADERS).json()
        state = result["data"]["state"]
        if state == "done":
            return result["data"]["full_zip_url"]
        elif state == "failed":
            raise Exception(f"Task failed: {result}")
        time.sleep(5)
```

## Quick Parse (curl)

```bash
TOKEN=$(cat ~/.config/mineru/token)

# Submit
curl -s -X POST "https://mineru.net/api/v4/extract/task" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"url":"https://example.com/doc.pdf","model_version":"hybrid"}'

# Check result
curl -s "https://mineru.net/api/v4/extract/task/{task_id}" \
  -H "Authorization: Bearer $TOKEN"
```

## Installation (Local Mode)

```bash
pip install uv
uv pip install -U "mineru[all]"
```

Requirements: Python 3.10-3.13, 16GB+ RAM, 20GB+ SSD. GPU optional (Volta+ or Apple Silicon).
