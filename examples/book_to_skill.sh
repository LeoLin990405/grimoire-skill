#!/usr/bin/env bash
# Example: parse a book and stage an LLM-ready skill extraction pack.
# Usage: ./examples/book_to_skill.sh /path/to/book.pdf

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
INPUT="${1:?Usage: $0 <book_file_or_url>}"
TITLE="${2:-}"

echo "=== Parse book and build skill extraction workspace ==="

args=("$INPUT" --output /tmp/mineru-book-workspaces --force --type auto)
if [[ -n "$TITLE" ]]; then
    args+=(--title "$TITLE")
fi

if [[ "$INPUT" =~ ^https?:// ]]; then
    "$SCRIPT_DIR/scripts/mineru-book-to-skill.sh" "${args[@]}"
else
    "$SCRIPT_DIR/scripts/mineru-book-to-skill.sh" "${args[@]}" --cloud-ok
fi

echo ""
echo "=== Done. Check /tmp/mineru-book-workspaces/books/ for the book workspace ==="
