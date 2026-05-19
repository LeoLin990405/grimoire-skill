# Contributing to mineru-skill

Thanks for your interest in contributing! This guide will help you get started.

## How to Contribute

### Reporting Bugs

1. Check [existing issues](https://github.com/LeoLin990405/mineru-skill/issues) first
2. Use the [Bug Report](https://github.com/LeoLin990405/mineru-skill/issues/new?template=bug_report.yml) template
3. Include your OS, shell, and MinerU API version

### Suggesting Features

1. Open a [Feature Request](https://github.com/LeoLin990405/mineru-skill/issues/new?template=feature_request.yml)
2. Describe your use case and expected behavior

### Submitting Changes

1. Fork the repository
2. Create a branch: `git checkout -b feature/my-change`
3. Make your changes
4. Test the script locally:
   ```bash
   # Test URL mode
   ./scripts/mineru-parse.sh https://example.com/test.pdf --output /tmp/test

   # Test local file mode
   ./scripts/mineru-parse.sh /path/to/local.pdf --output /tmp/test --extract
   ```
5. Commit with a clear message
6. Open a Pull Request

## Development Setup

### Prerequisites

- `bash` 4.0+
- `curl`
- `jq`
- A MinerU API token (see [README](README.md#2-set-up-api-token))

### Testing

```bash
# Verify script syntax
bash -n scripts/mineru-parse.sh

# Run with --help
./scripts/mineru-parse.sh --help

# Test with a public PDF
./scripts/mineru-parse.sh https://arxiv.org/pdf/2301.00001.pdf --output /tmp/mineru-test --extract
```

## Code Style

- Shell scripts follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Use `shellcheck` for linting: `shellcheck scripts/mineru-parse.sh`
- SKILL.md follows Claude Code skill format with YAML frontmatter

## What Makes a Good PR

- Focused on a single change
- Includes updated CHANGELOG.md entry
- Script changes are tested locally
- SKILL.md stays in sync with script capabilities
