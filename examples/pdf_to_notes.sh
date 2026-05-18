#!/usr/bin/env bash
# Example: parse a PDF, auto-classify it as book/paper/document, and stage a
# type-specific reading-notes workspace for an agent to fill into Obsidian.
# Usage: ./examples/pdf_to_notes.sh <source_file_or_url> [title]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
INPUT="${1:?Usage: $0 <source_file_or_url> [title]}"
TITLE="${2:-}"

echo "=== Parse + auto-classify + scaffold reading notes ==="

args=("$INPUT" --output /tmp/mineru-reading-workspaces --force --type auto)
if [[ -n "$TITLE" ]]; then
    args+=(--title "$TITLE")
fi

if [[ "$INPUT" =~ ^https?:// ]]; then
    "$SCRIPT_DIR/scripts/mineru-to-notes.sh" "${args[@]}"
else
    "$SCRIPT_DIR/scripts/mineru-to-notes.sh" "${args[@]}" --cloud-ok
fi

echo ""
echo "=== Done. Give the agent: ==="
echo "    /tmp/mineru-reading-workspaces/sources/*/notes/reading-notes-pack/AI_READING_TASK.md"
echo "The detected type and Obsidian vault target are printed above."
