#!/usr/bin/env bash
# kedou-bili-subs.sh — drive Kedou's Bilibili caption page via OpenCLI to
# download a video's Chinese .srt, then print its path.
#
# Encodes the validated playbook (Knowledge-Hub note 2026-05-19, opencli
# 1.7.22). Deterministic acquisition only — NO LLM, no note writing (same
# red-line category as forge.sh's yt-dlp path). Feed the printed .srt into
#   forge.sh <file.srt> --from-text
# for the notes/skills pipeline.
#
# Usage:
#   kedou-bili-subs.sh <bilibili-video-url> [options]
#   kedou-bili-subs.sh https://space.bilibili.com/<id> --list   # list videos
#
# Options:
#   --video <url>      Explicit video URL (bilibili.com/video/BV...).
#   --list             For a space page: extract + print video URLs, then exit.
#   --session <name>   OpenCLI browser session (default: kedou-bili).
#   --downloads <dir>  Where Chrome saves (default: ~/Downloads).
#   --timeout <sec>    Download wait timeout (default: 90).
#   --lang-label <s>   Language row to click (default: 中文).
#   --input-el <n>  --extract-el <n>  --zh-el <n>
#                      Explicit OpenCLI element ids (skip heuristic locate;
#                      DOM numbers shift on SPA re-render — see the playbook).
#   --dry-run          Print the planned OpenCLI sequence; do nothing.
#   -h, --help
#
# Boundary: only authorized / public / personally-accessible content. This
# script never sends, prints, or stores cookies / auth headers / account
# tokens; keep any login in your own browser/Kedou client. It will not try
# to bypass paywalls or access controls.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "${BASH_SOURCE[0]}"; exit 0; }

INPUT=""; VIDEO=""; LIST=false; SESSION="kedou-bili"
DOWNLOADS="$HOME/Downloads"; TIMEOUT=90; LANG_LABEL="中文"
INPUT_EL=""; EXTRACT_EL=""; ZH_EL=""; DRY=false
KEDOU_URL="https://www.kedou.life/caption/subtitle/bilibili"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --video) VIDEO="${2:?}"; shift 2 ;;
        --list) LIST=true; shift ;;
        --session) SESSION="${2:?}"; shift 2 ;;
        --downloads) DOWNLOADS="${2:?}"; shift 2 ;;
        --timeout) TIMEOUT="${2:?}"; shift 2 ;;
        --lang-label) LANG_LABEL="${2:?}"; shift 2 ;;
        --input-el) INPUT_EL="${2:?}"; shift 2 ;;
        --extract-el) EXTRACT_EL="${2:?}"; shift 2 ;;
        --zh-el) ZH_EL="${2:?}"; shift 2 ;;
        --dry-run) DRY=true; shift ;;
        -*) error "Unknown option: $1" ;;
        *) [[ -n "$INPUT" ]] && error "Only one input is supported"; INPUT="$1"; shift ;;
    esac
done
[[ -n "$INPUT" || -n "$VIDEO" ]] || error "Pass a Bilibili video URL (or a space URL with --list). --help"
$DRY || require_cmd opencli

oc() { # oc <args...> : run or echo an opencli browser command for this session
    if $DRY; then echo "  DRY> opencli browser $SESSION $*"; else
        opencli browser "$SESSION" "$@"; fi
}
state() { $DRY && { echo "  DRY> opencli browser $SESSION state"; return 0; }
          opencli browser "$SESSION" state 2>/dev/null || true; }

# locate_el <keyword> <override> <human-name>
# Best-effort: find the OpenCLI element id whose state line matches <keyword>.
# DOM ids are NOT stable across SPA renders (playbook gotcha) so we re-state
# and parse every time; an explicit override wins; failure is explicit.
locate_el() {
    local kw="$1" override="$2" name="$3"
    if [[ -n "$override" ]]; then echo "$override"; return 0; fi
    if $DRY; then echo "<$name-el from state>"; return 0; fi
    local line id
    line="$(state | grep -m1 -F "$kw" || true)"
    id="$(printf '%s' "$line" | grep -oE '[0-9]+' | head -1 || true)"
    [[ -n "$id" ]] || error "Could not locate the '$name' element ($kw). Re-run with --$( [[ $name == input ]] && echo input-el || ([[ $name == extract ]] && echo extract-el || echo zh-el) ) <n> after checking: opencli browser $SESSION state"
    echo "$id"
}

# ---- space page → list videos, then stop -------------------------------
SRC="${VIDEO:-$INPUT}"
case "$SRC" in
  *space.bilibili.com*)
    [[ "$LIST" == true || -z "$VIDEO" ]] || true
    echo "[kedou] space page detected — extracting candidate videos"
    oc open "$SRC"; oc wait time 5; state \
      | grep -oE 'https?://www\.bilibili\.com/video/BV[0-9A-Za-z]+' | sort -u || true
    echo "[kedou] pick one and re-run:  kedou-bili-subs.sh --video <video-url>"
    $DRY && echo "[kedou] dry-run only"
    exit 0
    ;;
esac
case "$SRC" in
  *bilibili.com/video/*) : ;;
  *) error "Not a Bilibili video URL: $SRC (expected bilibili.com/video/BV…). For a space page pass it with --list." ;;
esac

# ---- drive the Kedou caption page --------------------------------------
echo "[kedou] target video: $SRC"
echo "[kedou] open Kedou Bilibili caption page"
oc open "$KEDOU_URL"; oc wait time 3; state >/dev/null 2>&1 || true

IN_EL="$(locate_el '输入' "$INPUT_EL" input)"
EX_EL="$(locate_el '提取' "$EXTRACT_EL" extract)"
echo "[kedou] fill video URL (el $IN_EL), click 提取 (el $EX_EL)"
oc fill "$IN_EL" "$SRC"
oc click "$EX_EL"
oc wait time 8
state >/dev/null 2>&1 || true

# Re-state AFTER extract: the language rows only exist now, and ids changed.
ZH="$(locate_el "语言：$LANG_LABEL" "$ZH_EL" zh)"
echo "[kedou] download '$LANG_LABEL' subtitle (el $ZH) — other languages skipped"

# Filesystem-based download wait (the playbook's fix: `opencli wait
# download` reports `Unknown action: wait-download`; never rely on it).
wait_for_download() {
    local dir="$1" marker="$2" timeout="$3" waited=0 hit="" sz1 sz2
    while [[ $waited -lt $timeout ]]; do
        hit="$(find "$dir" -maxdepth 1 -type f -name '*.srt' -newer "$marker" 2>/dev/null \
               | while read -r f; do printf '%s\t%s\n' "$(stat -f '%m' "$f" 2>/dev/null)" "$f"; done \
               | sort -rn | head -1 | cut -f2-)"
        if [[ -n "$hit" && ! -e "$hit.crdownload" ]]; then
            sz1="$(stat -f '%z' "$hit" 2>/dev/null || echo 0)"; sleep 1
            sz2="$(stat -f '%z' "$hit" 2>/dev/null || echo 0)"
            [[ "$sz1" == "$sz2" && "$sz1" -gt 0 ]] && { printf '%s' "$hit"; return 0; }
        fi
        sleep 2; waited=$((waited + 2))
    done
    return 1
}

if $DRY; then
    echo "  DRY> opencli browser $SESSION click $ZH"
    echo "  DRY> wait_for_download \"$DOWNLOADS\" <marker> ${TIMEOUT}s  (filesystem poll; NOT 'opencli wait download')"
    echo "[kedou] dry-run only — nothing executed"
    exit 0
fi

MARKER="$(mktemp "${TMPDIR:-/tmp}/kedou-mark.XXXXXX")"
trap 'rm -f "$MARKER"' EXIT
oc click "$ZH"
echo "[kedou] waiting for .srt in $DOWNLOADS (≤${TIMEOUT}s, filesystem poll)…"
SRT="$(wait_for_download "$DOWNLOADS" "$MARKER" "$TIMEOUT")" \
    || error "No .srt appeared in $DOWNLOADS within ${TIMEOUT}s. Check: opencli browser $SESSION state ; or the subtitle may not exist (offer local Whisper transcription)."
oc close >/dev/null 2>&1 || true

# Chrome dedupes same-name files to 'name (1).srt' — we picked newest, so
# this is correct regardless of the suffix.
echo "[kedou] downloaded: $SRT"
printf '%s\n' "$SRT"
echo "[kedou] next:  forge.sh \"$SRT\" --from-text --only both" >&2
