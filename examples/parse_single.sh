#!/usr/bin/env bash
# Example: raw parse layer — fetch a single PDF from a URL and convert it to
# Markdown via MinerU. This is the parse step Grimoire builds on; for the full
# notes + skill-pack run use ./examples/grimoire.sh.
# Usage: ./examples/parse_single.sh

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Parse a PDF from URL ==="
"$SCRIPT_DIR/scripts/mineru-parse.sh" \
    "https://arxiv.org/pdf/2301.00001.pdf" \
    --model vlm \
    --output /tmp/grimoire-parse-example \
    --extract

echo ""
echo "=== Done! Check /tmp/grimoire-parse-example/ for results ==="
