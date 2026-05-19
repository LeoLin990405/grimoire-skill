#!/usr/bin/env bash
# Example: the flagship Grimoire run.
#
# One source in -> one workspace out, holding BOTH:
#   - type-specific reading notes (book / paper / document, bound for the
#     Obsidian Knowledge-Hub vault)
#   - a per-source skill pack (reusable skills mined segment by segment,
#     merged per book/course)
#
# One parse, one workspace, two artifacts, one agent contract. The scripts
# never call an LLM and never write into the vault — your agent does that
# after reading GRIMOIRE_TASK.md.
#
# Usage: ./examples/grimoire.sh <source_file_or_url> [title]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
INPUT="${1:?Usage: $0 <source_file_or_url> [title]}"
TITLE="${2:-}"

echo "=== Grimoire: parse -> classify -> notes + skill pack (one pass) ==="

args=("$INPUT" --output /tmp/grimoires --force --type auto --only both)
if [[ -n "$TITLE" ]]; then
    args+=(--title "$TITLE")
fi

if [[ "$INPUT" =~ ^https?:// ]]; then
    "$SCRIPT_DIR/scripts/grimoire.sh" "${args[@]}"
else
    # Local files are uploaded to the MinerU cloud API; confirm with --cloud-ok
    # (or set GRIMOIRE_PARSER to a local MinerU workflow for private sources).
    "$SCRIPT_DIR/scripts/grimoire.sh" "${args[@]}" --cloud-ok
fi

echo ""
echo "=== Done. Hand your agent the single contract: ==="
echo "    /tmp/grimoires/*/GRIMOIRE_TASK.md"
echo "The detected type, Obsidian vault target, and both artifact paths"
echo "(notes/ + skills/) are printed above."
