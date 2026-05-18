# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added
- **Source-to-notes pipeline**: `scripts/mineru-to-notes.sh` (parse +
  auto-classify + scaffold) and `scripts/reading-notes-pack.sh` (build a
  reading-notes pack from Markdown).
- **Hybrid reading-type classifier** `scripts/lib/reading-types.sh`: a
  deterministic scorer (filename + parsed-Markdown structure + page count)
  with an AI confirmation fallback (`AI_CLASSIFY.md`) when confidence is low.
  Three buckets: `book`, `paper`, `document`.
- Obsidian-aligned note templates under `templates/reading-notes/`
  (`book-notes.md`, `paper-notes.md`, `document-notes.md`) with vault
  frontmatter, `[[wikilinks]]`, and a quality bar.
- `OBSIDIAN_PLAN.md` per pack: resolves the exact vault target
  (`book → Books/`, `paper → Papers/`, `document → Documents/`), vault root
  via `$MINERU_OBSIDIAN_VAULT` / `--vault`, and house-style rules. Scripts
  never write into the vault — the agent does, after a quality self-check.
- Shared Markdown segmenter extracted to `scripts/lib/segment.sh`, now used by
  both the skill-pack and reading-notes pipelines (identical splitting).
- `examples/pdf_to_notes.sh` and `docs/reading-notes-workflow.md`.
- Source-to-skill first iteration with `scripts/mineru-source-to-skill.sh`.
- `scripts/source-skill-pack.sh` for staging parsed Markdown as an LLM-ready long-form skill pack.
- Compatibility wrappers: `scripts/mineru-book-to-skill.sh`, `scripts/book-skill-pack.sh`, and `scripts/vivo-agent-workspace.sh`.
- Shared shell libraries under `scripts/lib/` for common helpers and source type rules.
- `examples/book_to_skill.sh` end-to-end example.
- Long-form skill pack outputs: `LLM_EXTRACTION_PROMPT.md`, `BOOK_SKILL_INDEX.md`, `MANAGE_SKILLS.md`, `manifest.json`, `source-markdown/`, and `skills/`.
- `--manifest` and `--no-print-md` options for `mineru-parse.sh`.
- Long-form source type metadata with `--type auto|book|course|paper|manual|article-collection|project-notes|video|audio|web|mixed`.
- Chapter/lesson/section segmentation under `segments/`.
- Segment-first extraction workspaces under `chapter-skills/`.
- Whole-source synthesis template at `whole-book/WHOLE_BOOK_SUMMARY.md`.
- Mindmap template at `MINDMAP.md` for topic-to-skill-family classification.
- Manage-skills consumption contract for reviewing segment drafts before promotion.
- Open-source skill manager reference notes in `docs/open-source-skill-manager-references.md`.
- Vivo agent workspace generator at `scripts/vivo-workspace.sh`.
- Vivo agent-operated workflow documentation in `docs/vivo-agent-workflow.md`.
- Source type confirmation and typed note templates under `templates/vivo/`.
- `scripts/vivo-note-template.sh` for installing type-specific note templates into a Vivo workspace.
- Skill discovery coverage templates in workspaces and generated packs.
- Audio source type support for transcript-based workflows.

### Changed
- **Default model `hybrid` → `vlm`** in `mineru-parse.sh` and
  `mineru-source-to-skill.sh`. The cloud API retired `model_version: hybrid`
  in 2026-04 (returns `code -10002 "version field invalid"`); docs updated to
  flag `hybrid` as retired.
- Refactored primary command names and workspace paths from book-first to source-first.
- Documented the privacy boundary for local source uploads through the MinerU cloud API.
- Documented that generated long-form skill packs are candidates and are not automatically installed or enabled.
- Promoted chapter-level extraction, whole-source synthesis, source-structured skill packaging, and text-type classification from roadmap notes into the staged output contract.
- Clarified that Vivo capture and reasoning are performed by Codex/Claude-style agents, not by a hidden model call inside the scripts.
- Moved Vivo's first required step to source type confirmation before typed notes, capture normalization, or skill packs.

## [1.1.0] - 2026-03-16

### Added
- `hybrid` model support (default since MinerU v2.7.0)
- `--extract` flag for auto-unzip and markdown display
- `--format` option for extra output formats (docx, html, latex)
- `--callback` option for async webhook notifications
- `--data-id` option for custom tracking
- `--quiet` flag for silent operation
- Environment variable configuration (`MINERU_TOKEN_FILE`, `MINERU_API_BASE`, etc.)
- File size validation before upload (200MB limit)
- Colored terminal output with progress indicators
- Proper HTTP error handling with status codes
- Timeout protection with configurable max poll attempts
- Local API deployment documentation in SKILL.md
- Example scripts in `examples/` directory
- GitHub templates for issues and PRs
- CONTRIBUTING.md guide

### Changed
- Default model changed from `pipeline` to `hybrid`
- Refactored script with helper functions (build_task_json, api_call, poll_progress, download_result)
- Improved error messages with color coding

## [1.0.0] - 2026-02-27

### Added
- Initial release
- Cloud API support (mineru.net/api/v4)
- Single file and batch extraction endpoints
- CLI script `mineru-parse.sh` with URL and local file support
- Models: pipeline, vlm, MinerU-HTML
- OCR, formula, and table recognition options
- Page range selection
- Python and curl usage examples in SKILL.md
