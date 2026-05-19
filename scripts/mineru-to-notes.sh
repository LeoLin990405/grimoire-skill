#!/usr/bin/env bash
# Parse a PDF/document with MinerU, auto-classify it as book/paper/document,
# then stage a type-specific reading-notes workspace for an agent to fill and
# land in the Obsidian Knowledge-Hub vault.
#
# Pipeline: mineru-parse.sh  ->  reading-notes-pack.sh
# This wrapper does not call an LLM and does not write into the vault.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/reading-types.sh
source "$SCRIPT_DIR/lib/reading-types.sh"

PARSER="$SCRIPT_DIR/mineru-parse.sh"
PACKER="$SCRIPT_DIR/reading-notes-pack.sh"

OUTPUT_ROOT="./reading-workspaces"
TITLE=""
SLUG=""
MODEL="vlm"
OCR=false
PAGE_RANGES=""
READING_TYPE="auto"
AGENT_NAME="Agent"
OBSIDIAN_VAULT="${MINERU_OBSIDIAN_VAULT:-$HOME/Documents/Obsidian-Vaults/Knowledge-Hub}"
CLOUD_OK=false
FORCE=false

usage() {
    cat <<EOF
MinerU -> Reading Notes (auto-classified)

Usage: mineru-to-notes.sh <url_or_file> [options]

Arguments:
  url_or_file        Public URL or local document (PDF/DOC/PPT/image).

Options:
  --title <title>    Source title. Defaults to the filename/URL basename.
  --slug <slug>      Workspace + vault note slug.
  --type <type>      auto (default) | book | paper | document.
                     auto = hybrid classifier (heuristic + AI fallback).
  --model <m>        MinerU model: vlm (default), pipeline, MinerU-HTML.
                     Note: 'hybrid' was retired by the cloud API (2026-04).
  --ocr              Enable OCR.
  --pages <range>    Page ranges, e.g. "1-50,80-120".
  --agent <name>     Agent that will read and write the notes.
  --vault <path>     Obsidian vault root. Default: \$MINERU_OBSIDIAN_VAULT or
                     ~/Documents/Obsidian-Vaults/Knowledge-Hub
  --output <dir>     Workspace root. Default: ./reading-workspaces
  --cloud-ok         Confirm local-file upload to the MinerU cloud API.
  --force            Replace an existing workspace.
  -h, --help         Show this help.

Output:
  <output>/sources/<slug>/
    README.md
    source/
    mineru/parse_manifest.json + extracted Markdown
    notes/reading-notes-pack/   (classification + scaffold + AI task)

The reading type is decided automatically:
  book     -> chapter-by-chapter complete notes
  paper    -> detailed structured reading / excerpt notes
  document -> content-adaptive structured notes

Privacy: local files are uploaded to the MinerU cloud API. Use --cloud-ok to
confirm, or a local MinerU workflow for private/copyrighted sources.
EOF
    exit 0
}

INPUT=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --title) TITLE="${2:?Missing value for --title}"; shift 2 ;;
        --slug) SLUG="${2:?Missing value for --slug}"; shift 2 ;;
        --type|--reading-type) READING_TYPE="${2:?Missing value for $1}"; shift 2 ;;
        --model) MODEL="${2:?Missing value for --model}"; shift 2 ;;
        --ocr) OCR=true; shift ;;
        --pages) PAGE_RANGES="${2:?Missing value for --pages}"; shift 2 ;;
        --agent) AGENT_NAME="${2:?Missing value for --agent}"; shift 2 ;;
        --vault) OBSIDIAN_VAULT="${2:?Missing value for --vault}"; shift 2 ;;
        --output) OUTPUT_ROOT="${2:?Missing value for --output}"; shift 2 ;;
        --cloud-ok) CLOUD_OK=true; shift ;;
        --force) FORCE=true; shift ;;
        -*) error "Unknown option: $1" ;;
        *)
            if [[ -n "$INPUT" ]]; then
                error "Only one input is supported"
            fi
            INPUT="$1"
            shift
            ;;
    esac
done

[[ -n "$INPUT" ]] || error "No URL or source file provided. Use --help."
[[ -x "$PARSER" ]] || error "Parser not executable: $PARSER"
[[ -x "$PACKER" ]] || error "Pack builder not executable: $PACKER"
require_cmd jq
validate_reading_type "$READING_TYPE"

if [[ "$INPUT" =~ ^https?:// ]]; then
    INPUT_KIND="url"
else
    INPUT_KIND="file"
    [[ -f "$INPUT" ]] || error "File not found: $INPUT"
    if [[ "$CLOUD_OK" != true ]]; then
        error "Local files are uploaded to the MinerU cloud API. Re-run with --cloud-ok, or use mineru-local for private sources."
    fi
fi

if [[ -z "$TITLE" ]]; then
    TITLE="$(basename "$INPUT")"
    TITLE="${TITLE%.*}"
fi
[[ -z "$SLUG" ]] && SLUG="$(slugify "$TITLE" "source")"

WORKSPACE_DIR="$OUTPUT_ROOT/sources/$SLUG"
SOURCE_DIR="$WORKSPACE_DIR/source"
MINERU_DIR="$WORKSPACE_DIR/mineru"
NOTES_ANALYSIS_DIR="$WORKSPACE_DIR/notes"
MANIFEST_FILE="$MINERU_DIR/parse_manifest.json"

ensure_fresh_dir "$WORKSPACE_DIR" "$FORCE" "Workspace"

mkdir -p "$SOURCE_DIR" "$MINERU_DIR" "$NOTES_ANALYSIS_DIR"

if [[ "$INPUT_KIND" == "file" ]]; then
    cp "$INPUT" "$SOURCE_DIR/$(basename "$INPUT")"
else
    printf '%s\n' "$INPUT" > "$SOURCE_DIR/source_url.txt"
fi

parse_args=(
    "$INPUT"
    --model "$MODEL"
    --output "$MINERU_DIR"
    --extract
    --no-print-md
    --manifest "$MANIFEST_FILE"
)
[[ "$OCR" == true ]] && parse_args+=(--ocr)
[[ -n "$PAGE_RANGES" ]] && parse_args+=(--pages "$PAGE_RANGES")

echo "Parsing with MinerU (model: $MODEL)..."
"$PARSER" "${parse_args[@]}"

EXTRACT_DIR="$(jq -r '.extract_dir' "$MANIFEST_FILE")"
[[ -n "$EXTRACT_DIR" && "$EXTRACT_DIR" != "null" && -d "$EXTRACT_DIR" ]] \
    || error "Parse manifest did not contain a valid extract_dir"

# Page count hint for the classifier, if MinerU reported it.
PAGE_COUNT="$(jq -r '(.total_page_count // .page_count // 0)' "$MANIFEST_FILE" 2>/dev/null || echo 0)"
[[ "$PAGE_COUNT" =~ ^[0-9]+$ ]] || PAGE_COUNT=0

echo "Classifying and staging reading-notes pack..."
"$PACKER" "$EXTRACT_DIR" \
    --title "$TITLE" \
    --slug "reading-notes-pack" \
    --type "$READING_TYPE" \
    --pages "$PAGE_COUNT" \
    --agent "$AGENT_NAME" \
    --vault "$OBSIDIAN_VAULT" \
    --output "$NOTES_ANALYSIS_DIR" \
    --force

PACK_DIR="$NOTES_ANALYSIS_DIR/reading-notes-pack"
DETECTED_TYPE="$(jq -r '.reading_type' "$PACK_DIR/manifest.json")"
CONFIDENCE="$(jq -r '.confidence' "$PACK_DIR/manifest.json")"
VAULT_TARGET="$(jq -r '.vault_target' "$PACK_DIR/manifest.json")"

cat > "$WORKSPACE_DIR/README.md" <<EOF
# $TITLE

Reading-notes workspace created by \`mineru-to-notes.sh\`.

## Status

- MinerU parsed: yes (model: $MODEL)
- Auto-classified: \`$DETECTED_TYPE\` (confidence: \`$CONFIDENCE\`)
- LLM invoked: no
- Vault written: no

## Next step

Give the reading agent: \`notes/reading-notes-pack/AI_READING_TASK.md\`

It will read the parsed Markdown, write \`$DETECTED_TYPE\` notes, and land the
final note at:

\`$VAULT_TARGET\`
EOF

echo
echo "Workspace: $WORKSPACE_DIR"
echo "Detected type: $DETECTED_TYPE (confidence: $CONFIDENCE)"
echo "Reading contract: $PACK_DIR/AI_READING_TASK.md"
echo "Vault target: $VAULT_TARGET"
