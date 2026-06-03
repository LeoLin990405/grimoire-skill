#!/usr/bin/env bash
# source-adapter-github-repo.sh — fetch a GitHub repo's README + docs/ + extract skill-relevant content.
# v2 (2026-06-03) — input source extension #3 (GitHub repo).
#
# Strategy:
#   1. clone repo to /tmp (shallow)
#   2. extract README.md + docs/**/*.md + SKILL.md (if exists, this is a skill repo)
#   3. concatenate to Markdown with section headers
#
# Output: Markdown printed to stdout (or --out file).
#
# Usage:
#   source-adapter-github-repo.sh <repo-url> [--out <file>]
#   source-adapter-github-repo.sh git@github.com:user/repo.git
#   source-adapter-github-repo.sh https://github.com/user/repo

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh" 2>/dev/null || { error() { echo "ERROR: $*" >&2; exit 1; }; }

URL=""; OUT=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --out) OUT="${2:?}"; shift 2 ;;
        -*) error "Unknown option: $1" ;;
        *) URL="$1"; shift ;;
    esac
done
[[ -n "$URL" ]] || error "Usage: source-adapter-github-repo.sh <repo-url> [--out <file>]"

command -v git >/dev/null 2>&1 || error "git not found in PATH"

emit() {
    if [[ -n "$OUT" ]]; then
        cat > "$OUT"
        echo "[github-repo-adapter] wrote: $OUT" >&2
    else
        cat
    fi
}

# Normalize URL → clone path
REPO_NAME="$(basename "$URL" .git)"
TMPDIR="${TMPDIR:-/tmp}/grimoire-github.$$"
mkdir -p "$TMPDIR"
trap "rm -rf '$TMPDIR'" EXIT

echo "[github-repo-adapter] clone: $URL (shallow, /tmp)" >&2
if ! git clone --depth 1 --quiet "$URL" "$TMPDIR/$REPO_NAME" 2>/dev/null; then
    error "git clone failed for: $URL"
fi

REPO_DIR="$TMPDIR/$REPO_NAME"

{
    echo "# GitHub Repo: $REPO_NAME"
    echo ""
    echo "Source: $URL"
    echo "Type: github-repo"
    echo ""
    echo "---"
    echo ""

    # README (top priority)
    for r in README.md README.rst README.txt readme.md; do
        if [[ -f "$REPO_DIR/$r" ]]; then
            echo "## README"
            echo ""
            cat "$REPO_DIR/$r"
            echo ""
            break
        fi
    done

    # SKILL.md (Claude Code skill)
    if [[ -f "$REPO_DIR/SKILL.md" ]]; then
        echo "## SKILL.md (Claude Code skill manifest)"
        echo ""
        cat "$REPO_DIR/SKILL.md"
        echo ""
    fi

    # docs/ tree
    if [[ -d "$REPO_DIR/docs" ]]; then
        echo "## docs/"
        echo ""
        find "$REPO_DIR/docs" -type f -name '*.md' | sort | while read -r doc; do
            echo "### ${doc#$REPO_DIR/}"
            echo ""
            cat "$doc"
            echo ""
        done
    fi

    # Top-level structure
    echo "## Top-level structure"
    echo ""
    echo '```'
    (cd "$REPO_DIR" && find . -maxdepth 2 -type f -not -path '*/.git/*' | head -40 | sort)
    echo '```'

    # CHANGELOG.md (recent entries)
    if [[ -f "$REPO_DIR/CHANGELOG.md" ]]; then
        echo ""
        echo "## CHANGELOG (head 100 lines)"
        echo ""
        head -100 "$REPO_DIR/CHANGELOG.md"
    fi
} | emit

echo "[github-repo-adapter] done: $URL" >&2
