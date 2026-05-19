#!/usr/bin/env bash
# Example: raw parse layer — upload and parse a local file to Markdown via
# MinerU. This is the parse step Grimoire builds on; for the full notes +
# skill-pack run use ./examples/grimoire.sh.
# Usage: ./examples/parse_local.sh /path/to/document.pdf

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
INPUT="${1:?Usage: $0 <file_path>}"

echo "=== Upload and parse local file ==="
"$SCRIPT_DIR/scripts/mineru-parse.sh" \
    "$INPUT" \
    --model vlm \
    --ocr \
    --output /tmp/grimoire-parse-local \
    --extract

echo ""
echo "=== Done! Check /tmp/grimoire-parse-local/ for results ==="
