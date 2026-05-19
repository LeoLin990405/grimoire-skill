# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

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
