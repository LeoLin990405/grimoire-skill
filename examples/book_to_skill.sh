#!/usr/bin/env bash
# Example: skills-only path. Parse a long-form source and stage an
# LLM-ready skill extraction pack.
#
# For the full Grimoire run (notes + skill pack in one pass) use
# ./examples/grimoire.sh instead.
#
# Usage: ./examples/book_to_skill.sh /path/to/source.pdf

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
INPUT="${1:?Usage: $0 <source_file_or_url>}"
TITLE="${2:-}"

echo "=== Parse source and build skill extraction workspace ==="

args=("$INPUT" --output /tmp/grimoire-source-workspaces --force --type auto)
if [[ -n "$TITLE" ]]; then
    args+=(--title "$TITLE")
fi

if [[ "$INPUT" =~ ^https?:// ]]; then
    "$SCRIPT_DIR/scripts/mineru-source-to-skill.sh" "${args[@]}"
else
    "$SCRIPT_DIR/scripts/mineru-source-to-skill.sh" "${args[@]}" --cloud-ok
fi

echo ""
echo "=== Done. Check /tmp/grimoire-source-workspaces/sources/ for the source workspace ==="
