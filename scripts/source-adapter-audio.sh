#!/usr/bin/env bash
# source-adapter-audio.sh — transcribe an audio file (podcast/recording) to Markdown.
# v2 (2026-06-03) — input source extension #4 (audio/podcast).
#
# Strategy chain (first available wins):
#   1. whisper-cpp (local, fast on M-series Macs)
#   2. openai-whisper CLI (pip install openai-whisper)
#   3. yt-dlp + auto-subs (if URL has subs already)
#
# Output: Markdown transcript with optional timestamps. forge.sh pipes to grimoire.sh --from-text.
#
# Usage:
#   source-adapter-audio.sh <audio-file-or-podcast-url> [--out <file>] [--model <whisper-model>]

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh" 2>/dev/null || { error() { echo "ERROR: $*" >&2; exit 1; }; }

INPUT=""; OUT=""; MODEL="small"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --out) OUT="${2:?}"; shift 2 ;;
        --model) MODEL="${2:?}"; shift 2 ;;
        -*) error "Unknown option: $1" ;;
        *) INPUT="$1"; shift ;;
    esac
done
[[ -n "$INPUT" ]] || error "Usage: source-adapter-audio.sh <audio-file-or-URL> [--out <file>] [--model small|medium|large]"

emit() {
    if [[ -n "$OUT" ]]; then
        cat > "$OUT"
        echo "[audio-adapter] wrote: $OUT" >&2
    else
        cat
    fi
}

# If URL, download first
LOCAL_FILE="$INPUT"
TMPDIR="${TMPDIR:-/tmp}/grimoire-audio.$$"
if [[ "$INPUT" =~ ^https?:// ]]; then
    mkdir -p "$TMPDIR"
    trap "rm -rf '$TMPDIR'" EXIT
    echo "[audio-adapter] downloading: $INPUT" >&2
    if command -v yt-dlp >/dev/null 2>&1; then
        yt-dlp -x --audio-format mp3 -o "$TMPDIR/audio.%(ext)s" "$INPUT" >/dev/null 2>&1
        LOCAL_FILE="$(find "$TMPDIR" -name 'audio.*' | head -1)"
    else
        curl -fsSL --max-time 300 "$INPUT" -o "$TMPDIR/audio.bin"
        LOCAL_FILE="$TMPDIR/audio.bin"
    fi
    [[ -s "$LOCAL_FILE" ]] || error "Download failed: $INPUT"
fi

[[ -f "$LOCAL_FILE" ]] || error "Audio file not found: $LOCAL_FILE"

# Strategy 1: whisper-cpp (local, M-series optimized)
if command -v whisper-cpp >/dev/null 2>&1 || command -v whisper.cpp >/dev/null 2>&1; then
    WHISPER_CPP="$(command -v whisper-cpp || command -v whisper.cpp)"
    echo "[audio-adapter] route: whisper-cpp (model=$MODEL)" >&2
    {
        echo "# Audio Transcript"
        echo ""
        echo "Source: $INPUT"
        echo "Type: audio/podcast"
        echo "Engine: whisper-cpp model=$MODEL"
        echo ""
        echo "---"
        echo ""
        "$WHISPER_CPP" -f "$LOCAL_FILE" -m "$MODEL" --output-txt 2>/dev/null \
            | grep -v '^\[' || true
    } | emit
    exit 0
fi

# Strategy 2: openai-whisper CLI
if command -v whisper >/dev/null 2>&1; then
    echo "[audio-adapter] route: openai-whisper (model=$MODEL)" >&2
    TMPTRANS="${TMPDIR:-/tmp}/whisper-out.$$"
    mkdir -p "$TMPTRANS"
    whisper "$LOCAL_FILE" --model "$MODEL" --output_format txt --output_dir "$TMPTRANS" >/dev/null 2>&1
    {
        echo "# Audio Transcript"
        echo ""
        echo "Source: $INPUT"
        echo "Type: audio/podcast"
        echo "Engine: openai-whisper model=$MODEL"
        echo ""
        echo "---"
        echo ""
        cat "$TMPTRANS"/*.txt 2>/dev/null
    } | emit
    rm -rf "$TMPTRANS"
    exit 0
fi

error "No transcription engine found. Install one of:
  - whisper.cpp (recommended on M-series Mac): brew install whisper-cpp
  - openai-whisper:   pip install openai-whisper"
