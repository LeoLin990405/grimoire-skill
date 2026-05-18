# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added
- Book-to-skill first iteration with `scripts/mineru-book-to-skill.sh`.
- `scripts/book-skill-pack.sh` for staging parsed Markdown as an LLM-ready long-form skill pack.
- `examples/book_to_skill.sh` end-to-end example.
- Long-form skill pack outputs: `LLM_EXTRACTION_PROMPT.md`, `BOOK_SKILL_INDEX.md`, `MANAGE_SKILLS.md`, `manifest.json`, `source-markdown/`, and `skills/`.
- `--manifest` and `--no-print-md` options for `mineru-parse.sh`.
- Long-form source type metadata with `--type auto|book|course|paper|manual|article-collection|project-notes`.
- Chapter/lesson/section segmentation under `segments/`.
- Segment-first extraction workspaces under `chapter-skills/`.
- Whole-source synthesis template at `whole-book/WHOLE_BOOK_SUMMARY.md`.
- Manage-skills consumption contract for reviewing segment drafts before promotion.
- Open-source skill manager reference notes in `docs/open-source-skill-manager-references.md`.

### Changed
- Documented the privacy boundary for book uploads through the MinerU cloud API.
- Documented that generated long-form skill packs are candidates and are not automatically installed or enabled.
- Promoted chapter-level extraction, whole-source synthesis, source-structured skill packaging, and text-type classification from roadmap notes into the staged output contract.

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
