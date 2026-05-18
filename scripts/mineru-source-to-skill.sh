#!/usr/bin/env bash
# Parse a long-form source with MinerU, then stage a skill extraction workspace.
# This is a first-iteration wrapper: it prepares files for an LLM, but does
# not call the LLM and does not enable generated skills.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/source-types.sh
source "$SCRIPT_DIR/lib/source-types.sh"

PARSER="$SCRIPT_DIR/mineru-parse.sh"
PACKER="$SCRIPT_DIR/source-skill-pack.sh"

OUTPUT_ROOT="./source-workspaces"
TITLE=""
SLUG=""
MODEL="vlm"
OCR=false
PAGE_RANGES=""
SOURCE_TYPE="auto"
CLOUD_OK=false
FORCE=false

usage() {
    cat <<EOF
MinerU Long-Form Source To Skill Workspace

Usage: mineru-source-to-skill.sh <url_or_file> [options]

Arguments:
  url_or_file        Public URL or local long-form source file.

Options:
  --title <title>    Source title. Defaults to the filename or URL basename.
  --slug <slug>      Workspace slug. Defaults to a sanitized title.
  --output <dir>     Workspace root. Default: ./source-workspaces
  --model <m>        MinerU model: vlm (default), pipeline, MinerU-HTML
  --ocr              Enable OCR mode.
  --pages <range>    Page ranges, e.g. "1-50,80-120".
  --type <type>      Source type: auto, book, course, paper, manual,
                    article-collection, project-notes, video, audio, web, or mixed.
                    Default: auto.
  --cloud-ok         Confirm local-file upload to MinerU cloud API is acceptable.
  --force            Replace an existing workspace.
  -h, --help         Show this help.

Output:
  <output>/sources/<source-slug>/
    README.md
    source/
    mineru/
      parse_manifest.json
      <MinerU zip and extracted files>
    analysis/
      source-skill-pack/
        segments/
        chapter-skills/
        whole-book/

Privacy:
  This repo uses the MinerU cloud API. Local source files are uploaded to MinerU
  unless you use a separate local MinerU workflow. For local files, this wrapper
  requires --cloud-ok so private or copyrighted sources are not uploaded by accident.
EOF
    exit 0
}

INPUT=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --title) TITLE="${2:?Missing value for --title}"; shift 2 ;;
        --slug) SLUG="${2:?Missing value for --slug}"; shift 2 ;;
        --output) OUTPUT_ROOT="${2:?Missing value for --output}"; shift 2 ;;
        --model) MODEL="${2:?Missing value for --model}"; shift 2 ;;
        --ocr) OCR=true; shift ;;
        --pages) PAGE_RANGES="${2:?Missing value for --pages}"; shift 2 ;;
        --type|--source-type|--text-type) SOURCE_TYPE="${2:?Missing value for $1}"; shift 2 ;;
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
validate_source_type "$SOURCE_TYPE"

if [[ "$INPUT" =~ ^https?:// ]]; then
    INPUT_KIND="url"
    if [[ -z "$TITLE" ]]; then
        TITLE="$(basename "$INPUT")"
        TITLE="${TITLE%.*}"
    fi
else
    INPUT_KIND="file"
    [[ -f "$INPUT" ]] || error "File not found: $INPUT"
    if [[ "$CLOUD_OK" != true ]]; then
        error "Local source files are uploaded to the MinerU cloud API. Re-run with --cloud-ok, or use mineru-local for private sources."
    fi
    if [[ -z "$TITLE" ]]; then
        TITLE="$(basename "$INPUT")"
        TITLE="${TITLE%.*}"
    fi
fi

[[ -z "$SLUG" ]] && SLUG="$(slugify "$TITLE" "source")"

WORKSPACE_DIR="$OUTPUT_ROOT/sources/$SLUG"
SOURCE_DIR="$WORKSPACE_DIR/source"
MINERU_DIR="$WORKSPACE_DIR/mineru"
ANALYSIS_DIR="$WORKSPACE_DIR/analysis"
MANIFEST_FILE="$MINERU_DIR/parse_manifest.json"

if [[ -e "$WORKSPACE_DIR" ]]; then
    if [[ "$FORCE" == true ]]; then
        safe_remove_dir "$WORKSPACE_DIR"
    else
        error "Workspace already exists: $WORKSPACE_DIR (use --force to replace it)"
    fi
fi

mkdir -p "$SOURCE_DIR" "$MINERU_DIR" "$ANALYSIS_DIR"

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

if [[ "$OCR" == true ]]; then
    parse_args+=(--ocr)
fi

if [[ -n "$PAGE_RANGES" ]]; then
    parse_args+=(--pages "$PAGE_RANGES")
fi

echo "Parsing source with MinerU..."
"$PARSER" "${parse_args[@]}"

EXTRACT_DIR="$(jq -r '.extract_dir' "$MANIFEST_FILE")"
[[ -n "$EXTRACT_DIR" && "$EXTRACT_DIR" != "null" && -d "$EXTRACT_DIR" ]] || error "Parse manifest did not contain a valid extract_dir"

echo "Building long-form skill pack..."
"$PACKER" "$EXTRACT_DIR" \
    --title "$TITLE" \
    --slug "source-skill-pack" \
    --type "$SOURCE_TYPE" \
    --output "$ANALYSIS_DIR" \
    --force

cat > "$WORKSPACE_DIR/README.md" <<EOF
# $TITLE

This long-form source workspace was created by \`mineru-source-to-skill.sh\`.

## Status

- MinerU parsed: yes
- LLM invoked: no
- Skills enabled: no

## Next Step

Give this prompt and source workspace to a large language model:

- Prompt: \`analysis/source-skill-pack/LLM_EXTRACTION_PROMPT.md\`
- Source Markdown: \`analysis/source-skill-pack/source-markdown/\`
- Segments: \`analysis/source-skill-pack/segments/\`

The model should fill:

- \`analysis/source-skill-pack/chapter-skills/*/CHAPTER_SKILL_INDEX.md\`
- \`analysis/source-skill-pack/chapter-skills/*/skills/*.md\`
- \`analysis/source-skill-pack/whole-book/WHOLE_BOOK_SUMMARY.md\`
- \`analysis/source-skill-pack/BOOK_SKILL_INDEX.md\`
- \`analysis/source-skill-pack/skills/*.md\` for reviewed cross-segment candidates

Review all generated skills before promoting anything into managed skills.
EOF

echo "Long-form source workspace created: $WORKSPACE_DIR"
echo "LLM prompt: $ANALYSIS_DIR/source-skill-pack/LLM_EXTRACTION_PROMPT.md"
