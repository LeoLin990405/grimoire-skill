#!/usr/bin/env bash
# whisper-transcribe.sh — OPT-IN local transcription fallback for videos that
# have NO Chinese subtitle track (the kedou batch records these as
# `no_chinese_subtitle`/`subtitle_failed`). This is a SEPARATE task: the
# kedou batch never auto-runs it (per the validated playbook).
#
# Deterministic acquisition only (yt-dlp audio + a LOCAL Whisper model) — no
# remote LLM, no vault writes. Feed the transcript into
#   forge.sh <transcript.txt> --from-text
# for the notes/skills pipeline (the agent writes the note).
#
# Usage:
#   whisper-transcribe.sh <video-url | audio|video file> [options]
#   whisper-transcribe.sh --backlog <backlog.jsonl> [options]
#
# Options:
#   --backlog <f>     JSONL of {url,bvid,index,...} (kedou-bili-batch --backlog).
#   --out-dir <dir>   Transcripts dir (default: ./whisper-out).
#   --engine <e>      auto | mlx | cli  (default auto: mlx_whisper else whisper-cli).
#   --model <m>       Whisper model (engine default if unset).
#   --lang <l>        Spoken language hint (default: zh).
#   --delay-ms <ms>   Wait between backlog items (default 3000).
#   --dry-run         Print the planned commands; do nothing.
#   -h, --help
#
# Boundary: only content the user is authorized to study/archive. Never
# stores cookies/auth/tokens. yt-dlp may read your browser login locally for
# diagnosis only; this script does not persist credentials.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "${BASH_SOURCE[0]}"; exit 0; }

INPUT=""; BACKLOG=""; OUT_DIR="./whisper-out"; ENGINE="auto"
MODEL=""; LANG="zh"; DELAY_MS=3000; DRY=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --backlog) BACKLOG="${2:?}"; shift 2 ;;
        --out-dir) OUT_DIR="${2:?}"; shift 2 ;;
        --engine) ENGINE="${2:?}"; shift 2 ;;
        --model) MODEL="${2:?}"; shift 2 ;;
        --lang) LANG="${2:?}"; shift 2 ;;
        --delay-ms) DELAY_MS="${2:?}"; shift 2 ;;
        --dry-run) DRY=true; shift ;;
        -*) error "Unknown option: $1" ;;
        *) [[ -n "$INPUT" ]] && error "Only one input"; INPUT="$1"; shift ;;
    esac
done
[[ -n "$INPUT" || -n "$BACKLOG" ]] || error "Pass a URL/file or --backlog <jsonl>. --help"

pick_engine() {
    case "$ENGINE" in
        mlx) echo mlx ;;
        cli) echo cli ;;
        auto|*) if command -v mlx_whisper >/dev/null 2>&1; then echo mlx
                elif command -v whisper-cli >/dev/null 2>&1; then echo cli
                else echo none; fi ;;
    esac
}
ENG="$(pick_engine)"
$DRY || [[ "$ENG" != none ]] || error "No Whisper engine: install mlx_whisper (pip install mlx-whisper) or whisper-cli (whisper.cpp). See: skill-manage.sh doctor --skill kedou-media-workflow"

# transcribe_one <audio_or_video> <out_txt>
transcribe_one() {
    local src="$1" out="$2" cmd
    case "$ENG" in
        mlx) cmd=(mlx_whisper "$src" --language "$LANG" --output-dir "$(dirname "$out")" --output-format txt ${MODEL:+--model "$MODEL"}) ;;
        cli) cmd=(whisper-cli -f "$src" -l "$LANG" -otxt -of "${out%.txt}" ${MODEL:+-m "$MODEL"}) ;;
        *)   cmd=(echo "<whisper>") ;;
    esac
    if $DRY; then echo "  DRY> ${cmd[*]}"; return 0; fi
    "${cmd[@]}" >/dev/null 2>&1 || return 1
    # normalize: both engines write "<basename>.txt" into the out dir
    [[ -s "$out" ]] || { local alt; alt="$(dirname "$out")/$(basename "${src%.*}").txt"; [[ -s "$alt" && "$alt" != "$out" ]] && mv "$alt" "$out"; }
    [[ -s "$out" ]]
}

# fetch_audio <url> <dir> → echoes the audio path (deterministic; yt-dlp)
fetch_audio() {
    local url="$1" dir="$2"
    if $DRY; then echo "$dir/audio.m4a"; return 0; fi
    require_cmd yt-dlp
    yt-dlp -x --audio-format mp3 --no-playlist -o "$dir/audio.%(ext)s" "$url" >/dev/null 2>&1 || true
    find "$dir" -maxdepth 1 -type f \( -name 'audio.*' \) | head -1
}

run_one() { # run_one <url|file> <out_txt_path>
    local in="$1" out="$2" dir; dir="$(dirname "$out")"; mkdir -p "$dir"
    if [[ "$in" =~ ^https?:// ]]; then
        echo "[whisper] fetch audio: $in"
        local a; a="$(fetch_audio "$in" "$dir")"
        [[ "$DRY" == true || -s "$a" ]] || { echo "  audio fetch failed"; return 1; }
        echo "[whisper] transcribe ($ENG, $LANG)"
        transcribe_one "${a:-$dir/audio.m4a}" "$out" || { echo "  transcription failed"; return 1; }
    else
        [[ -f "$in" ]] || { echo "  file not found: $in"; return 1; }
        echo "[whisper] transcribe local file ($ENG, $LANG)"
        transcribe_one "$in" "$out" || { echo "  transcription failed"; return 1; }
    fi
    echo "[whisper] → $out"
    echo "[whisper] next:  forge.sh \"$out\" --from-text --only both" >&2
}

mkdir -p "$OUT_DIR"
if [[ -n "$BACKLOG" ]]; then
    [[ -f "$BACKLOG" ]] || error "--backlog file not found: $BACKLOG"
    ok=0; fail=0
    while IFS= read -r row; do
        [[ -n "$row" ]] || continue
        url="$(jq -r '.url' <<<"$row")"; bvid="$(jq -r '.bvid // "x"' <<<"$row")"
        idx="$(jq -r '.index // 0' <<<"$row")"
        out="$OUT_DIR/$(printf '%03d' "$idx")-$bvid.txt"
        echo "[whisper] backlog $idx $bvid"
        if run_one "$url" "$out"; then ok=$((ok+1)); else fail=$((fail+1)); fi
        if $DRY; then echo "  DRY> sleep ${DELAY_MS}ms"; else
            perl -e 'select(undef,undef,undef,$ARGV[0]/1000)' "$DELAY_MS" 2>/dev/null || sleep $((DELAY_MS/1000)); fi
    done < <(jq -c '.' "$BACKLOG")
    echo "[whisper] backlog done: ok=$ok fail=$fail (dir: $OUT_DIR)"
    $DRY && echo "[whisper] dry-run only — nothing executed"
    exit 0
fi

base="$(basename "${INPUT%.*}")"; [[ "$INPUT" =~ ^https?:// ]] && base="$(printf '%s' "$INPUT" | grep -oE 'BV[0-9A-Za-z]+' | head -1 || echo transcript)"
run_one "$INPUT" "$OUT_DIR/${base:-transcript}.txt"
$DRY && echo "[whisper] dry-run only — nothing executed"
