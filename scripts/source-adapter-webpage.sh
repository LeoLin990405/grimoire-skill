#!/usr/bin/env bash
# source-adapter-webpage.sh — fetch a webpage and normalize to Markdown.
# v2 (2026-06-03) — input source extension #1 (webpage).
#
# Strategy chain (first available wins):
#   1. crawl4ai (if installed) — best for SPA / dynamic content
#   2. Reader-style: r.jina.ai/{URL} via curl — clean Markdown, free
#   3. curl + pandoc fallback — raw HTML → MD
#
# Output: Markdown printed to stdout. forge.sh pipes this to grimoire.sh --from-markdown.
#
# Usage:
#   source-adapter-webpage.sh <URL> [--out <file>]

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
[[ -n "$URL" ]] || error "Usage: source-adapter-webpage.sh <URL> [--out <file>]"

emit() {
    if [[ -n "$OUT" ]]; then
        cat > "$OUT"
        echo "[webpage-adapter] wrote: $OUT" >&2
    else
        cat
    fi
}

# Strategy 1: crawl4ai (best for SPA)
if command -v crawl4ai >/dev/null 2>&1; then
    echo "[webpage-adapter] route: crawl4ai" >&2
    crawl4ai "$URL" 2>/dev/null | emit
    exit 0
fi

# Strategy 2: Reader API (r.jina.ai — free, clean Markdown, no auth needed)
echo "[webpage-adapter] route: r.jina.ai (Reader API)" >&2
if curl -fsSL --max-time 30 "https://r.jina.ai/$URL" 2>/dev/null | emit; then
    exit 0
fi
echo "[webpage-adapter] r.jina.ai failed, falling back" >&2

# Strategy 3: curl + pandoc fallback
if command -v pandoc >/dev/null 2>&1; then
    echo "[webpage-adapter] route: curl + pandoc" >&2
    curl -fsSL --max-time 30 "$URL" 2>/dev/null \
        | pandoc -f html -t markdown_strict --wrap=none 2>/dev/null \
        | emit
    exit 0
fi

# Strategy 4: minimal — strip HTML tags with sed (lossy but works)
echo "[webpage-adapter] route: curl + sed (minimal, lossy)" >&2
curl -fsSL --max-time 30 "$URL" 2>/dev/null \
    | sed -E 's/<[^>]+>//g' \
    | grep -v '^[[:space:]]*$' \
    | emit
