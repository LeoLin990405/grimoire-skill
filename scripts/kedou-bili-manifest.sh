#!/usr/bin/env bash
# kedou-bili-manifest.sh — build a Bilibili space video manifest by capturing
# the page's own /x/space/wbi/arc/search responses via OpenCLI (NOT the
# direct API: that hits 风控 — HTTP 412 / -352 风控校验失败).
#
# Deterministic core: parse an OpenCLI network dump → videos.jsonl.
# Best-effort driver: open the space page + capture across pages.
#
# Usage:
#   kedou-bili-manifest.sh <space-url> [--pages N] [--out <file>] [--dry-run]
#   kedou-bili-manifest.sh --from-network <dump.json> [--out <file>]
#
# Options:
#   --from-network <f>  Parse a saved OpenCLI network dump (robust path —
#                       capture it however, then extract offline).
#   --pages <N>         Page-capture rounds to attempt (default 13).
#   --page-wait <sec>   Wait between capture rounds (default 4).
#   --session <name>    OpenCLI session (default: bili-pages-batch).
#   --out <file>        Output JSONL (default: ./videos.jsonl).
#   --dry-run           Print the planned OpenCLI sequence; do nothing.
#   -h, --help
#
# Output line: {"index":N,"bvid":"BV..","title":"..","url":"https://www.
# bilibili.com/video/BV..","aid":..,"length":"..","created":..}
#
# Boundary: only spaces/videos the user is authorized to access for personal
# study/archival. Never logs or stores cookies / auth headers / tokens.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "${BASH_SOURCE[0]}"; exit 0; }

SPACE=""; FROM_NET=""; PAGES=13; PAGE_WAIT=4
SESSION="bili-pages-batch"; OUT="./videos.jsonl"; DRY=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --from-network) FROM_NET="${2:?}"; shift 2 ;;
        --pages) PAGES="${2:?}"; shift 2 ;;
        --page-wait) PAGE_WAIT="${2:?}"; shift 2 ;;
        --session) SESSION="${2:?}"; shift 2 ;;
        --out) OUT="${2:?}"; shift 2 ;;
        --dry-run) DRY=true; shift ;;
        -*) error "Unknown option: $1" ;;
        *) [[ -n "$SPACE" ]] && error "Only one space URL"; SPACE="$1"; shift ;;
    esac
done
require_cmd jq

# Tolerant extractor: from any JSON (network dump, raw response, or a string
# body), pull every Bilibili vlist-style video object → manifest JSONL.
extract_videos() {
    jq -r '
      [ .. | objects
        | (if (.responseBody? | type) == "string"
           then (try (.responseBody | fromjson) catch empty) else . end) ]
      + [ .. | objects ]
      | [ .. | objects | select(has("bvid") and has("title")) ]
      | unique_by(.bvid)
      | to_entries[]
      | {index:(.key+1), bvid:.value.bvid, title:.value.title,
         url:("https://www.bilibili.com/video/" + .value.bvid),
         aid:(.value.aid // null), length:(.value.length // null),
         created:(.value.created // null)}
      | @json'
}

if [[ -n "$FROM_NET" ]]; then
    [[ -f "$FROM_NET" ]] || error "--from-network file not found: $FROM_NET"
    extract_videos < "$FROM_NET" > "$OUT"
    n="$(wc -l < "$OUT" | tr -d ' ')"
    [[ "$n" -gt 0 ]] || error "No videos found in $FROM_NET (is it the /x/space/wbi/arc/search capture?)"
    echo "[manifest] $n videos → $OUT"
    exit 0
fi

[[ -n "$SPACE" ]] || error "Pass a Bilibili space URL or --from-network <dump>. --help"
case "$SPACE" in *space.bilibili.com/*) : ;; *) error "Not a Bilibili space URL: $SPACE" ;; esac
$DRY || require_cmd opencli

oc() { if $DRY; then echo "  DRY> opencli browser $SESSION $*"; else opencli browser "$SESSION" "$@"; fi; }

echo "[manifest] direct space API is 风控-blocked (412 / -352) — capturing the page's own /x/space/wbi/arc/search via OpenCLI"
oc close >/dev/null 2>&1 || true
oc open "$SPACE"
oc wait time 5
NETDUMP="<network-dump>"
$DRY || NETDUMP="$(mktemp "${TMPDIR:-/tmp}/bili-net.XXXXXX")"
p=1
while [[ $p -le $PAGES ]]; do
    echo "[manifest] capture round $p/$PAGES"
    if $DRY; then
        echo "  DRY> opencli browser $SESSION network --all --since 60s   # filter /x/space/wbi/arc/search"
        echo "  DRY> scroll/next-page, wait ${PAGE_WAIT}s"
    else
        opencli browser "$SESSION" network --all --since 120s 2>/dev/null >> "$NETDUMP" || true
        opencli browser "$SESSION" wait time "$PAGE_WAIT" >/dev/null 2>&1 || true
    fi
    p=$((p + 1))
done
oc close >/dev/null 2>&1 || true

if $DRY; then
    echo "  DRY> extract_videos < <network-dump> > $OUT"
    echo "[manifest] dry-run only — nothing executed"
    exit 0
fi
extract_videos < "$NETDUMP" > "$OUT" || true
rm -f "$NETDUMP"
n="$(wc -l < "$OUT" 2>/dev/null | tr -d ' ' || echo 0)"
[[ "$n" -gt 0 ]] || error "Captured no videos. The space SPA may need manual scrolling/pagination; scroll through it, then re-run, or capture the network log yourself and use --from-network."
echo "[manifest] $n videos → $OUT  (verify: jq -s length \"$OUT\")"
