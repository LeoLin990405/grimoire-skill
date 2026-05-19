#!/usr/bin/env bash
# kedou-bili-batch.sh — resumable batch: a Bilibili space (or a videos.jsonl)
# → per-video Chinese .srt → progress.jsonl → (optional) grimoire contracts.
#
# Orchestration only. Each video's subtitle is fetched by the existing
# single-video helper (kedou-bili-subs.sh, the public Kedou web UI). This
# repo deliberately does NOT ship Kedou-API encryption replication; the
# value here is the manifest + resumable, quota-aware progress + handoff.
# Red line kept: --mode notes hands each .srt to forge.sh (grimoire
# contract); the AGENT writes the note — scripts never write the vault.
#
# Usage:
#   kedou-bili-batch.sh <videos.jsonl | space-url> [options]
#   kedou-bili-batch.sh --status [--out-dir <dir>]
#
# Options:
#   --out-dir <dir>     Workspace (default: ./kedou-bili). Holds
#                       manifests/progress.jsonl and subtitles/.
#   --start <N> --end <N> --limit <N>   Manifest index window.
#   --resume            Start from the first non-`done` manifest index.
#   --delay-ms <ms>     Wait between videos (default 12000).
#   --rate-limit-wait-ms <ms>  Wait after a rate-limit (default 300000).
#   --retries <N>       Retries on rate-limit/transient (default 1).
#   --mode subtitles|notes   subtitles = just download (default);
#                       notes = also run forge.sh <srt> --from-text (the
#                       agent then writes the note from the contract).
#   --force             Re-process even if a subtitle/record exists.
#   --status            Print the dedup'd progress summary, then exit.
#   --dry-run           Print the plan; touch nothing.
#   -h, --help
#
# Boundary: authorized/personal-study content only; Chinese subtitles only;
# never logs/stores cookies/auth/tokens. Quota hit ("您今日的使用次数已达
# 上限") → record quota_limited and STOP (resume next day with --resume).

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/kedou-progress.sh
source "$SCRIPT_DIR/lib/kedou-progress.sh"
SUBS="$SCRIPT_DIR/kedou-bili-subs.sh"
FORGE="$SCRIPT_DIR/forge.sh"
usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "${BASH_SOURCE[0]}"; exit 0; }

INPUT=""; OUT_DIR="./kedou-bili"; START=""; END=""; LIMIT=""; RESUME=false
DELAY_MS=12000; RL_WAIT_MS=300000; RETRIES=1; MODE=subtitles
FORCE=false; STATUS=false; DRY=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --out-dir) OUT_DIR="${2:?}"; shift 2 ;;
        --start) START="${2:?}"; shift 2 ;;
        --end) END="${2:?}"; shift 2 ;;
        --limit) LIMIT="${2:?}"; shift 2 ;;
        --resume) RESUME=true; shift ;;
        --delay-ms) DELAY_MS="${2:?}"; shift 2 ;;
        --rate-limit-wait-ms) RL_WAIT_MS="${2:?}"; shift 2 ;;
        --retries) RETRIES="${2:?}"; shift 2 ;;
        --mode) MODE="${2:?}"; shift 2 ;;
        --force) FORCE=true; shift ;;
        --status) STATUS=true; shift ;;
        --dry-run) DRY=true; shift ;;
        -*) error "Unknown option: $1" ;;
        *) [[ -n "$INPUT" ]] && error "Only one input"; INPUT="$1"; shift ;;
    esac
done
require_cmd jq
case "$MODE" in subtitles|notes) : ;; *) error "--mode must be subtitles or notes" ;; esac

MANI_DIR="$OUT_DIR/manifests"; SUB_DIR="$OUT_DIR/subtitles"
PROGRESS="$MANI_DIR/progress.jsonl"; MANIFEST="$MANI_DIR/videos.jsonl"

if [[ "$STATUS" == true ]]; then
    [[ -f "$PROGRESS" ]] || error "No progress at $PROGRESS"
    echo "[batch] progress summary ($PROGRESS):"
    kp_latest_counts "$PROGRESS" | jq .
    echo "subtitles: $(find "$SUB_DIR" -maxdepth 1 -name '*.zh.srt' 2>/dev/null | wc -l | tr -d ' ')"
    [[ -f "$MANIFEST" ]] && echo "next --resume index: $(kp_next_resume "$PROGRESS" "$MANIFEST")"
    exit 0
fi

[[ -n "$INPUT" ]] || error "Pass a videos.jsonl or a space URL (or --status). --help"
mkdir -p "$MANI_DIR" "$SUB_DIR"

# Resolve the manifest: a .jsonl is used directly; a space URL is captured.
if [[ "$INPUT" == *space.bilibili.com/* ]]; then
    if $DRY; then
        echo "[batch] DRY> kedou-bili-manifest.sh \"$INPUT\" --out \"$MANIFEST\""
    else
        [[ -s "$MANIFEST" && "$FORCE" != true ]] || \
            "$SCRIPT_DIR/kedou-bili-manifest.sh" "$INPUT" --out "$MANIFEST"
    fi
else
    [[ -f "$INPUT" ]] || error "Manifest not found: $INPUT"
    [[ "$INPUT" -ef "$MANIFEST" ]] 2>/dev/null || { $DRY || cp "$INPUT" "$MANIFEST"; }
fi
$DRY && [[ ! -s "$MANIFEST" ]] && MANIFEST="$INPUT"   # dry-run reads given file
[[ -s "$MANIFEST" ]] || error "Empty manifest: $MANIFEST"

# Window: --resume overrides --start.
if [[ "$RESUME" == true ]]; then
    START="$(kp_next_resume "$PROGRESS" "$MANIFEST")"
    echo "[batch] --resume → starting at index $START"
fi
[[ -n "$START" ]] || START="$(jq -s 'map(.index)|min // 1' "$MANIFEST")"
[[ -n "$END" ]] || END="$(jq -s 'map(.index)|max // 0' "$MANIFEST")"

delay() { local ms="$1"; $DRY && { echo "  DRY> sleep ${ms}ms"; return; }
          perl -e 'select(undef,undef,undef,$ARGV[0]/1000)' "$ms" 2>/dev/null || sleep $((ms/1000)); }

processed=0
while IFS= read -r row; do
    idx="$(jq -r '.index' <<<"$row")"; bvid="$(jq -r '.bvid' <<<"$row")"
    url="$(jq -r '.url' <<<"$row")"; title="$(jq -r '.title' <<<"$row")"
    [[ "$idx" -ge "$START" && "$idx" -le "$END" ]] || continue
    if [[ -n "$LIMIT" && "$processed" -ge "$LIMIT" ]]; then break; fi
    processed=$((processed + 1))

    if [[ "$FORCE" != true && "$(kp_latest_status "$PROGRESS" "$bvid")" == "done" ]]; then
        echo "[$idx] $bvid already done — skip"; continue
    fi
    srt="$SUB_DIR/$(printf '%03d' "$idx")-$bvid.zh.srt"
    echo "[$idx] $title ($bvid)"
    if $DRY; then
        echo "  DRY> kedou-bili-subs.sh \"$url\" --downloads <tmp> → $srt"
        [[ "$MODE" == notes ]] && echo "  DRY> forge.sh \"$srt\" --from-text --only notes"
        echo "  DRY> kp_record $PROGRESS $idx $bvid <status>"
        delay "$DELAY_MS"; continue
    fi

    attempt=0; outcome=""
    while :; do
        tmpd="$(mktemp -d "${TMPDIR:-/tmp}/kbb.XXXXXX")"
        if out="$("$SUBS" "$url" --downloads "$tmpd" 2>&1)"; then
            got="$(printf '%s\n' "$out" | tail -1)"
            if [[ -s "$got" ]]; then mv "$got" "$srt"; outcome=done; fi
        fi
        rm -rf "$tmpd"
        if [[ "$outcome" == done ]]; then break; fi
        if grep -q '您今日的使用次数已达上限' <<<"$out"; then outcome=quota_limited; break; fi
        if grep -q '请求过于频繁' <<<"$out"; then
            if [[ $attempt -lt $RETRIES ]]; then
                attempt=$((attempt+1)); echo "  rate-limited → wait ${RL_WAIT_MS}ms (retry $attempt)"
                delay "$RL_WAIT_MS"; continue
            fi
            outcome=rate_limited; break
        fi
        if grep -qiE 'no .*subtitle|无中文|subtitle may not exist' <<<"$out"; then
            outcome=no_chinese_subtitle; break
        fi
        outcome=subtitle_failed; break
    done

    msg="$(printf '%s' "$out" | tail -1 | cut -c1-160)"
    kp_record "$PROGRESS" "$idx" "$bvid" "$outcome" "$msg"
    echo "  → $outcome"
    if [[ "$outcome" == quota_limited ]]; then
        echo "[batch] Kedou daily quota reached. Stopping. Resume next day:"
        echo "  $0 \"$MANIFEST\" --out-dir \"$OUT_DIR\" --resume"
        exit 0
    fi
    if [[ "$outcome" == done && "$MODE" == notes ]]; then
        "$FORGE" "$srt" --from-text --only notes --title "$title" \
            --output "$OUT_DIR/grimoires" --force >/dev/null 2>&1 \
            && echo "  note contract staged (agent writes the note)" \
            || echo "  (forge handoff failed; srt kept)"
    fi
    delay "$DELAY_MS"
done < <(jq -c '.' "$MANIFEST")

echo "[batch] window done. Summary:"
[[ -f "$PROGRESS" ]] && kp_latest_counts "$PROGRESS" | jq -c . || echo "(no progress yet)"
$DRY && echo "[batch] dry-run only — nothing executed"
