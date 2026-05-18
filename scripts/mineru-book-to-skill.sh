#!/usr/bin/env bash
# Parse a long-form source with MinerU, then stage a skill extraction workspace.
# This is a first-iteration wrapper: it prepares files for an LLM, but does
# not call the LLM and does not enable generated skills.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARSER="$SCRIPT_DIR/mineru-parse.sh"
PACKER="$SCRIPT_DIR/book-skill-pack.sh"

OUTPUT_ROOT="./book-workspaces"
TITLE=""
SLUG=""
MODEL="hybrid"
OCR=false
PAGE_RANGES=""
SOURCE_TYPE="auto"
CLOUD_OK=false
FORCE=false

usage() {
    cat <<EOF
MinerU Long-Form Source To Skill Workspace

Usage: mineru-book-to-skill.sh <url_or_file> [options]

Arguments:
  url_or_file        Public URL or local long-form source file.

Options:
  --title <title>    Source title. Defaults to the filename or URL basename.
  --slug <slug>      Workspace slug. Defaults to a sanitized title.
  --output <dir>     Workspace root. Default: ./book-workspaces
  --model <m>        MinerU model: hybrid (default), pipeline, vlm, MinerU-HTML
  --ocr              Enable OCR mode.
  --pages <range>    Page ranges, e.g. "1-50,80-120".
  --type <type>      Source type: auto, book, course, paper, manual,
                    article-collection, project-notes, video, audio, web, or mixed.
                    Default: auto.
  --cloud-ok         Confirm local-file upload to MinerU cloud API is acceptable.
  --force            Replace an existing workspace.
  -h, --help         Show this help.

Output:
  <output>/books/<book-slug>/
    README.md
    source/
    mineru/
      parse_manifest.json
      <MinerU zip and extracted files>
    analysis/
      book-skill-pack/
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

error() {
    echo "Error: $*" >&2
    exit 1
}

slugify() {
    local value="$1"
    value=$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')
    value=$(printf '%s' "$value" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
    if [[ -z "$value" ]]; then
        value="book-$(date -u +%Y%m%d%H%M%S)"
    fi
    printf '%s' "$value"
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
command -v jq >/dev/null 2>&1 || error "jq is required but not installed"

case "$SOURCE_TYPE" in
    auto|book|course|paper|manual|article-collection|project-notes|video|audio|web|mixed) ;;
    *) error "Unsupported source type: $SOURCE_TYPE" ;;
esac

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

[[ -z "$SLUG" ]] && SLUG="$(slugify "$TITLE")"

BOOK_DIR="$OUTPUT_ROOT/books/$SLUG"
SOURCE_DIR="$BOOK_DIR/source"
MINERU_DIR="$BOOK_DIR/mineru"
ANALYSIS_DIR="$BOOK_DIR/analysis"
MANIFEST_FILE="$MINERU_DIR/parse_manifest.json"

if [[ -e "$BOOK_DIR" ]]; then
    if [[ "$FORCE" == true ]]; then
        case "$BOOK_DIR" in
            ""|"/"|"."|"..") error "Refusing to replace unsafe workspace path: $BOOK_DIR" ;;
        esac
        rm -rf "$BOOK_DIR"
    else
        error "Workspace already exists: $BOOK_DIR (use --force to replace it)"
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
    --slug "book-skill-pack" \
    --type "$SOURCE_TYPE" \
    --output "$ANALYSIS_DIR" \
    --force

cat > "$BOOK_DIR/README.md" <<EOF
# $TITLE

This long-form source workspace was created by \`mineru-book-to-skill.sh\`.

## Status

- MinerU parsed: yes
- LLM invoked: no
- Skills enabled: no

## Next Step

Give this prompt and source workspace to a large language model:

- Prompt: \`analysis/book-skill-pack/LLM_EXTRACTION_PROMPT.md\`
- Source Markdown: \`analysis/book-skill-pack/source-markdown/\`
- Segments: \`analysis/book-skill-pack/segments/\`

The model should fill:

- \`analysis/book-skill-pack/chapter-skills/*/CHAPTER_SKILL_INDEX.md\`
- \`analysis/book-skill-pack/chapter-skills/*/skills/*.md\`
- \`analysis/book-skill-pack/whole-book/WHOLE_BOOK_SUMMARY.md\`
- \`analysis/book-skill-pack/BOOK_SKILL_INDEX.md\`
- \`analysis/book-skill-pack/skills/*.md\` for reviewed cross-segment candidates

Review all generated skills before promoting anything into managed skills.
EOF

echo "Long-form source workspace created: $BOOK_DIR"
echo "LLM prompt: $ANALYSIS_DIR/book-skill-pack/LLM_EXTRACTION_PROMPT.md"
