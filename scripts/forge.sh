#!/usr/bin/env bash
# forge.sh — one command: a book OR a video in, a grimoire (notes + skill
# pack contract) out.
#
# It auto-routes the input, runs the deterministic source-acquisition step
# (PDF→Markdown via pdf2md/MinerU, video→subtitles via yt-dlp), then hands
# the text to grimoire.sh. forge.sh itself NEVER calls an LLM — acquisition
# is plain tooling; the notes/skills are still written by the agent that
# executes the produced GRIMOIRE_TASK.md (the repo red line is preserved).
#
# Usage:
#   forge.sh <pdf|doc|ppt|img|.md|.txt|video-url|pdf-url> [options]
#
# Options (extra ones are passed through to grimoire.sh):
#   --only <both|notes|skills>   default: both
#   --title <t>  --slug <s>  --type <t>  --output <dir>  --vault <p>
#   --install                    opt-in cross-agent install (via grimoire)
#   --cloud-ok                   allow MinerU cloud upload for local files
#   --force                      replace an existing grimoire
#   --lang <csv>                 subtitle langs for video (default zh.*,en.*,en)
#   --bili-via <auto|kedou|ytdlp>  Bilibili subtitle route (default auto:
#                                kedou-bili-subs.sh if opencli present, else yt-dlp)
#   --skip-doctor                skip the host-config preflight
#   --dry-run                    print the detected route + commands, do nothing
#   -h, --help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
GRIMOIRE="$SCRIPT_DIR/grimoire.sh"
DOCTOR="$SCRIPT_DIR/skill-manage.sh"

usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "${BASH_SOURCE[0]}"; exit 0; }

INPUT=""; ONLY="both"; LANG_CSV="zh.*,en.*,en"; DRY=false; SKIP_DOCTOR=false
BILI_VIA="auto"; KEDOU_BILI="$SCRIPT_DIR/kedou-bili-subs.sh"
PASS=()   # forwarded verbatim to grimoire.sh
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --only) ONLY="${2:?}"; PASS+=(--only "$2"); shift 2 ;;
        --lang) LANG_CSV="${2:?}"; shift 2 ;;
        --bili-via) BILI_VIA="${2:?}"; shift 2 ;;
        --skip-doctor) SKIP_DOCTOR=true; shift ;;
        --dry-run) DRY=true; shift ;;
        --title|--slug|--type|--output|--vault|--agent|--model|--pages)
            PASS+=("$1" "${2:?Missing value for $1}"); shift 2 ;;
        --install|--cloud-ok|--force|--ocr) PASS+=("$1"); shift ;;
        -* ) error "Unknown option: $1" ;;
        *) [[ -n "$INPUT" ]] && error "Only one input is supported"; INPUT="$1"; shift ;;
    esac
done
[[ -n "$INPUT" ]] || error "No input. Pass a PDF/doc/.md/.txt or a video URL. --help for usage."

# ---- classify the input ---------------------------------------------------
KIND=""
lc="$(printf '%s' "$INPUT" | tr '[:upper:]' '[:lower:]')"
if [[ "$INPUT" =~ ^https?:// ]]; then
    case "$lc" in
        *.pdf|*arxiv.org/pdf/*|*arxiv.org/abs/*) KIND="pdf" ;;
        *youtube.com/*|*youtu.be/*|*bilibili.com/*|*vimeo.com/*|*tiktok.com/*|\
*douyin.com/*|*twitter.com/*|*x.com/*|*.mp4|*.webm|*.mkv) KIND="video" ;;
        # v2 new sources
        *github.com/*|*gitlab.com/*) KIND="github-repo" ;;
        *.mp3|*.m4a|*.wav|*.flac|*.opus|*.ogg|*podcast*|*anchor.fm*) KIND="audio" ;;
        http*://*) KIND="webpage" ;;
        *) error "Unrecognized URL. Supported: PDF / arXiv / video / github repo / audio / webpage." ;;
    esac
elif [[ "$INPUT" =~ ^git@ ]]; then
    KIND="github-repo"   # v2
else
    [[ -e "$INPUT" ]] || error "Path not found: $INPUT"
    if [[ -d "$INPUT" ]]; then
        # v2: directory → Obsidian vault segment
        KIND="obsidian-vault"
    else
        case "$lc" in
            *.md|*.markdown)                       KIND="markdown" ;;
            *.txt|*.text|*.srt|*.vtt)              KIND="text" ;;
            *.pdf|*.doc|*.docx|*.ppt|*.pptx|*.png|*.jpg|*.jpeg|*.tif|*.tiff|*.bmp) KIND="pdf" ;;
            # v2: local audio
            *.mp3|*.m4a|*.wav|*.flac|*.opus|*.ogg)  KIND="audio" ;;
            *) error "Unsupported file type: $INPUT (pdf/doc/ppt/img/.md/.txt/.mp3/.m4a/...)" ;;
        esac
    fi
fi

# ---- host-config preflight (uses skill-manage.sh doctor) ------------------
is_bili() { case "$lc" in *bilibili.com/*|*space.bilibili.com/*) return 0 ;; *) return 1 ;; esac; }
# bili_route → kedou | ytdlp  (auto = kedou when opencli is installed)
bili_route() {
    case "$BILI_VIA" in
        kedou) echo kedou ;;
        ytdlp) echo ytdlp ;;
        auto|*) command -v opencli >/dev/null 2>&1 && echo kedou || echo ytdlp ;;
    esac
}
needed_skill() {
    case "$KIND" in
        video) if is_bili && [[ "$(bili_route)" == kedou ]]; then echo kedou-media-workflow
               else echo youtube-clipper; fi ;;
        pdf)   echo mineru-local ;;
        *)     echo "" ;;
    esac
}
NEED="$(needed_skill)"
if [[ "$SKIP_DOCTOR" != true && -n "$NEED" ]]; then
    echo "[forge] preflight: skill-manage.sh doctor --skill $NEED"
    if ! "$DOCTOR" doctor --skill "$NEED" >/tmp/forge-doctor.$$ 2>&1; then
        cat /tmp/forge-doctor.$$; rm -f /tmp/forge-doctor.$$
        error "Host is missing a REQUIRED prerequisite for '$NEED' (see above). Install it, or re-run with --skip-doctor to try anyway."
    fi
    rm -f /tmp/forge-doctor.$$
fi

run() { if $DRY; then echo "  DRY> $*"; else eval "$@"; fi; }

# ---- acquire text, then invoke grimoire -----------------------------------
echo "[forge] input kind: $KIND"
case "$KIND" in
  # v2: webpage (Crawl4AI / r.jina.ai Reader / pandoc fallback)
  webpage)
    echo "[forge] route: webpage adapter (v2)"
    TMPD="$(mktemp -d "${TMPDIR:-/tmp}/forge-web.XXXXXX")"
    if $DRY; then
        echo "  DRY> source-adapter-webpage.sh '$INPUT' --out $TMPD/page.md ; grimoire.sh --from-markdown <md> ${PASS[*]:-}"
    else
        "$SCRIPT_DIR/source-adapter-webpage.sh" "$INPUT" --out "$TMPD/page.md"
        [[ -s "$TMPD/page.md" ]] || error "Webpage adapter produced no Markdown for: $INPUT"
        "$GRIMOIRE" --from-markdown "$TMPD/page.md" ${PASS[*]:-}
    fi
    ;;

  # v2: github-repo (README + docs + SKILL.md)
  github-repo)
    echo "[forge] route: github-repo adapter (v2)"
    TMPD="$(mktemp -d "${TMPDIR:-/tmp}/forge-gh.XXXXXX")"
    if $DRY; then
        echo "  DRY> source-adapter-github-repo.sh '$INPUT' --out $TMPD/repo.md ; grimoire.sh --from-markdown <md> ${PASS[*]:-}"
    else
        "$SCRIPT_DIR/source-adapter-github-repo.sh" "$INPUT" --out "$TMPD/repo.md"
        [[ -s "$TMPD/repo.md" ]] || error "GitHub repo adapter produced no Markdown for: $INPUT"
        "$GRIMOIRE" --from-markdown "$TMPD/repo.md" ${PASS[*]:-}
    fi
    ;;

  # v2: obsidian-vault (reads .md + frontmatter, preserves [[wikilinks]])
  obsidian-vault)
    echo "[forge] route: obsidian-vault adapter (v2)"
    TMPD="$(mktemp -d "${TMPDIR:-/tmp}/forge-obs.XXXXXX")"
    if $DRY; then
        echo "  DRY> source-adapter-obsidian.sh '$INPUT' --out $TMPD/vault.md ; grimoire.sh --from-markdown <md> ${PASS[*]:-}"
    else
        "$SCRIPT_DIR/source-adapter-obsidian.sh" "$INPUT" --out "$TMPD/vault.md"
        [[ -s "$TMPD/vault.md" ]] || error "Obsidian adapter produced no Markdown for: $INPUT"
        "$GRIMOIRE" --from-markdown "$TMPD/vault.md" ${PASS[*]:-}
    fi
    ;;

  # v2: audio / podcast (Whisper transcription)
  audio)
    echo "[forge] route: audio adapter (v2)"
    TMPD="$(mktemp -d "${TMPDIR:-/tmp}/forge-aud.XXXXXX")"
    if $DRY; then
        echo "  DRY> source-adapter-audio.sh '$INPUT' --out $TMPD/transcript.md ; grimoire.sh --from-text <txt> ${PASS[*]:-}"
    else
        "$SCRIPT_DIR/source-adapter-audio.sh" "$INPUT" --out "$TMPD/transcript.md"
        [[ -s "$TMPD/transcript.md" ]] || error "Audio adapter produced no transcript for: $INPUT"
        "$GRIMOIRE" --from-text "$TMPD/transcript.md" ${PASS[*]:-}
    fi
    ;;

  markdown)
    echo "[forge] route: --from-markdown (no acquisition needed)"
    run "\"$GRIMOIRE\" --from-markdown \"$INPUT\" ${PASS[*]:-}"
    ;;
  text)
    echo "[forge] route: --from-text"
    run "\"$GRIMOIRE\" --from-text \"$INPUT\" ${PASS[*]:-}"
    ;;
  pdf)
    if command -v pdf2md >/dev/null 2>&1; then
        TMPD="$(mktemp -d "${TMPDIR:-/tmp}/forge-pdf.XXXXXX")"
        echo "[forge] acquire: pdf2md → Markdown"
        if $DRY; then
            echo "  DRY> pdf2md \"$INPUT\" -> $TMPD/out.md ; grimoire.sh --from-markdown <md> ${PASS[*]:-}"
        else
            pdf2md "$INPUT" > "$TMPD/out.md" 2>/dev/null || pdf2md "$INPUT" "$TMPD" >/dev/null 2>&1 || true
            MD="$TMPD/out.md"; [[ -s "$MD" ]] || MD="$(find "$TMPD" -name '*.md' | head -1)"
            [[ -s "$MD" ]] || error "pdf2md produced no Markdown for: $INPUT"
            "$GRIMOIRE" --from-markdown "$MD" ${PASS[*]:-}
        fi
    else
        echo "[forge] pdf2md not on PATH → hand the source to grimoire.sh (native MinerU)"
        run "\"$GRIMOIRE\" \"$INPUT\" ${PASS[*]:-}"
    fi
    ;;
  video)
    if is_bili && [[ "$(bili_route)" == kedou ]]; then
        echo "[forge] Bilibili → Kedou route via kedou-bili-subs.sh (override with --bili-via)"
        if $DRY; then
            "$KEDOU_BILI" "$INPUT" --dry-run || true
            echo "  DRY> <downloaded .srt> ; grimoire.sh --from-text <srt> ${PASS[*]:-}"
        else
            SRT="$("$KEDOU_BILI" "$INPUT" | tail -1)"
            [[ -s "$SRT" ]] || error "kedou-bili-subs.sh returned no .srt for $INPUT"
            echo "[forge] subtitle: $SRT → grimoire --from-text"
            "$GRIMOIRE" --from-text "$SRT" ${PASS[*]:-}
        fi
    else
    require_cmd yt-dlp
    TMPD="$(mktemp -d "${TMPDIR:-/tmp}/forge-vid.XXXXXX")"
    echo "[forge] acquire: yt-dlp subtitles ($LANG_CSV)"
    if $DRY; then
        echo "  DRY> yt-dlp --skip-download --write-subs --write-auto-subs --sub-langs '$LANG_CSV' --convert-subs srt -o '$TMPD/%(id)s.%(ext)s' '$INPUT'"
        echo "  DRY> <srt→text> ; grimoire.sh --from-text <txt> ${PASS[*]:-}"
    else
        yt-dlp --skip-download --write-subs --write-auto-subs \
            --sub-langs "$LANG_CSV" --convert-subs srt \
            -o "$TMPD/%(id)s.%(ext)s" "$INPUT" >/dev/null 2>&1 || true
        SRT="$(find "$TMPD" -name '*.srt' | head -1)"
        [[ -s "$SRT" ]] || error "No subtitles found for $INPUT (try --lang, or use the youtube-clipper skill for AI transcription)."
        TXT="$TMPD/transcript.txt"
        awk '
            /-->/        {next}
            /^[0-9]+[ \t]*$/ {next}
            /^WEBVTT/     {next}
            { gsub(/<[^>]*>/,""); gsub(/\r/,"");
              if ($0 ~ /[^ \t]/ && $0 != prev) { print; prev=$0 } }
        ' "$SRT" > "$TXT"
        [[ -s "$TXT" ]] || error "Subtitle file was empty after cleaning: $SRT"
        echo "[forge] transcript: $(wc -l <"$TXT" | tr -d ' ') lines → grimoire --from-text"
        "$GRIMOIRE" --from-text "$TXT" ${PASS[*]:-}
    fi
    fi
    ;;
esac

$DRY && { echo "[forge] dry-run only — nothing executed"; exit 0; }
echo "[forge] done. The agent now executes the GRIMOIRE_TASK.md contract (notes + skills)."
