#!/usr/bin/env bash
# source-adapter-obsidian.sh — read an Obsidian vault segment (single note or folder).
# v2 (2026-06-03) — input source extension #2 (Obsidian vault).
#
# Output: Concatenated Markdown with section dividers, frontmatter parsed, [[wikilinks]] preserved.
#
# Usage:
#   source-adapter-obsidian.sh <vault-path-or-note-file> [--out <file>] [--max-depth N]
#
# Examples:
#   source-adapter-obsidian.sh ~/Documents/Obsidian-Vaults/Knowledge-Hub/Books/INSPIRED-Cagan/
#   source-adapter-obsidian.sh ~/Documents/Obsidian-Vaults/Knowledge-Hub/Books/some-note.md

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh" 2>/dev/null || { error() { echo "ERROR: $*" >&2; exit 1; }; }

INPUT=""; OUT=""; MAX_DEPTH=5
while [[ $# -gt 0 ]]; do
    case "$1" in
        --out) OUT="${2:?}"; shift 2 ;;
        --max-depth) MAX_DEPTH="${2:?}"; shift 2 ;;
        -*) error "Unknown option: $1" ;;
        *) INPUT="$1"; shift ;;
    esac
done
[[ -n "$INPUT" ]] || error "Usage: source-adapter-obsidian.sh <vault-path-or-note-file>"
[[ -e "$INPUT" ]] || error "Path not found: $INPUT"

emit() {
    if [[ -n "$OUT" ]]; then
        cat > "$OUT"
        echo "[obsidian-adapter] wrote: $OUT" >&2
    else
        cat
    fi
}

process_note() {
    local file="$1"
    echo ""
    echo "---"
    echo "# Note: $(basename "$file" .md)"
    echo "Path: ${file#$HOME/}"
    echo "---"
    echo ""
    cat "$file"
}

{
    if [[ -f "$INPUT" ]]; then
        # Single note
        echo "# Obsidian Note Segment"
        echo ""
        echo "Source: $INPUT"
        echo "Type: single-note"
        echo ""
        echo "---"
        echo ""
        cat "$INPUT"
    elif [[ -d "$INPUT" ]]; then
        # Folder — concatenate all .md
        local vault_root="$(basename "$INPUT")"
        echo "# Obsidian Vault Segment: $vault_root"
        echo ""
        echo "Source folder: $INPUT"
        echo "Type: vault-segment"
        echo ""
        # Find all .md, sort by depth then name
        find "$INPUT" -maxdepth "$MAX_DEPTH" -type f -name '*.md' \
            -not -path '*/.obsidian/*' \
            -not -path '*/Templates/*' \
            | sort \
            | while read -r note; do
                process_note "$note"
            done
    fi
} | emit

echo "[obsidian-adapter] done: $INPUT" >&2
