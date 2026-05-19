#!/usr/bin/env bash
# Grimoire — one source in, a grimoire out.
#
# Parse a PDF/document with MinerU, auto-classify it (book/paper/document),
# then in ONE pass build a single workspace that holds BOTH:
#   - type-specific reading notes (bound for the Obsidian Knowledge-Hub vault)
#   - a per-source skill pack (reusable skills mined segment by segment,
#     merged per book/course)
#
# One parse, one workspace, two artifacts, one agent contract. The scripts
# never call an LLM and never write into the vault — the agent does that.
#
# Pipeline:  mineru-parse.sh -> reading-notes-pack.sh + source-skill-pack.sh
#                            -> unified GRIMOIRE.md / GRIMOIRE_TASK.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/reading-types.sh
source "$SCRIPT_DIR/lib/reading-types.sh"

# Override to plug in a local MinerU workflow (or a stub for testing). The
# replacement must honor mineru-parse.sh's --output/--extract/--manifest
# contract and write parse_manifest.json with a valid .extract_dir.
PARSER="${GRIMOIRE_PARSER:-$SCRIPT_DIR/mineru-parse.sh}"
NOTES_PACKER="$SCRIPT_DIR/reading-notes-pack.sh"
SKILL_PACKER="$SCRIPT_DIR/source-skill-pack.sh"

OUTPUT_ROOT="./grimoires"
TITLE=""
SLUG=""
MODEL="vlm"
OCR=false
PAGE_RANGES=""
READING_TYPE="auto"
AGENT_NAME="Agent"
OBSIDIAN_VAULT="${MINERU_OBSIDIAN_VAULT:-$HOME/Documents/Obsidian-Vaults/Knowledge-Hub}"
ONLY="both"          # both | notes | skills
CLOUD_OK=false
FORCE=false
FROM_MARKDOWN=""     # skip parse; continue from already-converted Markdown

usage() {
    cat <<EOF
Grimoire — turn a source into reading notes + a skill pack

Usage: grimoire.sh <url_or_file> [options]

Arguments:
  url_or_file        Public URL or local document (PDF/DOC/PPT/image).

Options:
  --title <title>    Source title. Defaults to the filename/URL basename.
  --slug <slug>      Workspace + vault note slug.
  --type <type>      auto (default) | book | paper | document.
  --only <what>      both (default) | notes | skills.
  --model <m>        MinerU model: vlm (default), pipeline, MinerU-HTML.
  --ocr              Enable OCR.
  --pages <range>    Page ranges, e.g. "1-50,80-120".
  --agent <name>     Agent that will read, write notes, and mine skills.
  --vault <path>     Obsidian vault root. Default: \$MINERU_OBSIDIAN_VAULT or
                     ~/Documents/Obsidian-Vaults/Knowledge-Hub
  --output <dir>     Grimoire root. Default: ./grimoires
  --cloud-ok         Confirm local-file upload to the MinerU cloud API.
  --from-markdown <p>  Skip the MinerU parse and continue from an
                     already-converted Markdown file or extracted dir
                     (e.g. the output of pdf2md / mineru-local). Nothing
                     is uploaded; <url_or_file> becomes optional. This is
                     the MD-first, opt-in path: convert to Markdown first,
                     then run Grimoire only when you want notes/skills.
  --force            Replace an existing grimoire.
  -h, --help         Show this help.

Output:
  <output>/grimoires/<slug>/
    GRIMOIRE.md          unified status + targets
    GRIMOIRE_TASK.md     single agent contract (notes + skills, per segment)
    README.md
    source/
    mineru/parse_manifest.json + extracted Markdown
    notes/   reading-notes pack  (classification, OBSIDIAN_PLAN, scaffold)
    skills/  source-skill pack    (segments, chapter-skills, whole-book, ...)

Both halves segment the SAME parsed Markdown — the agent reads each chapter /
section once and, in that pass, writes the note AND mines candidate skills.
Skills are merged per book/course into the skill pack and stay candidates
until reviewed; notes land in the vault after a quality self-check.

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
        --only) ONLY="${2:?Missing value for --only}"; shift 2 ;;
        --model) MODEL="${2:?Missing value for --model}"; shift 2 ;;
        --ocr) OCR=true; shift ;;
        --pages) PAGE_RANGES="${2:?Missing value for --pages}"; shift 2 ;;
        --agent) AGENT_NAME="${2:?Missing value for --agent}"; shift 2 ;;
        --vault) OBSIDIAN_VAULT="${2:?Missing value for --vault}"; shift 2 ;;
        --output) OUTPUT_ROOT="${2:?Missing value for --output}"; shift 2 ;;
        --cloud-ok) CLOUD_OK=true; shift ;;
        --from-markdown|--md) FROM_MARKDOWN="${2:?Missing value for $1}"; shift 2 ;;
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

if [[ -n "$FROM_MARKDOWN" ]]; then
    [[ -e "$FROM_MARKDOWN" ]] || error "--from-markdown path not found: $FROM_MARKDOWN"
else
    [[ -n "$INPUT" ]] || error "No URL or source file provided. Use --help (or --from-markdown to continue from already-converted Markdown)."
    [[ -x "$PARSER" ]] || error "Parser not executable: $PARSER"
fi
[[ -x "$NOTES_PACKER" ]] || error "Notes packer not executable: $NOTES_PACKER"
[[ -x "$SKILL_PACKER" ]] || error "Skill packer not executable: $SKILL_PACKER"
require_cmd jq
validate_reading_type "$READING_TYPE"
case "$ONLY" in both|notes|skills) : ;; *) error "--only must be both, notes, or skills" ;; esac

if [[ -n "$FROM_MARKDOWN" ]]; then
    INPUT_KIND="markdown"   # nothing is uploaded; parse step is skipped
elif [[ "$INPUT" =~ ^https?:// ]]; then
    INPUT_KIND="url"
else
    INPUT_KIND="file"
    [[ -f "$INPUT" ]] || error "File not found: $INPUT"
    if [[ "$CLOUD_OK" != true ]]; then
        error "Local files are uploaded to the MinerU cloud API. Re-run with --cloud-ok, or use a local MinerU workflow for private sources."
    fi
fi

if [[ -z "$TITLE" ]]; then
    if [[ -n "$INPUT" ]]; then
        TITLE="$(basename "$INPUT")"
    else
        TITLE="$(basename "$FROM_MARKDOWN")"
    fi
    TITLE="${TITLE%.*}"
fi
[[ -z "$SLUG" ]] && SLUG="$(slugify "$TITLE" "source")"

WORKSPACE_DIR="$OUTPUT_ROOT/grimoires/$SLUG"
SOURCE_DIR="$WORKSPACE_DIR/source"
MINERU_DIR="$WORKSPACE_DIR/mineru"
NOTES_DIR="$WORKSPACE_DIR/notes"
SKILLS_DIR="$WORKSPACE_DIR/skills"
MANIFEST_FILE="$MINERU_DIR/parse_manifest.json"

if [[ -e "$WORKSPACE_DIR" ]]; then
    if [[ "$FORCE" == true ]]; then
        safe_remove_dir "$WORKSPACE_DIR"
    else
        error "Grimoire already exists: $WORKSPACE_DIR (use --force to replace it)"
    fi
fi

mkdir -p "$SOURCE_DIR" "$MINERU_DIR"

if [[ "$INPUT_KIND" == "markdown" ]]; then
    printf '%s\n' "$FROM_MARKDOWN" > "$SOURCE_DIR/source_markdown.txt"
elif [[ "$INPUT_KIND" == "file" ]]; then
    cp "$INPUT" "$SOURCE_DIR/$(basename "$INPUT")"
else
    printf '%s\n' "$INPUT" > "$SOURCE_DIR/source_url.txt"
fi

# ---- 1. Parse once (or skip — continue from existing Markdown) -------
if [[ "$INPUT_KIND" == "markdown" ]]; then
    echo "[1/4] Continuing from existing Markdown (MinerU parse skipped)..."
    if [[ -d "$FROM_MARKDOWN" ]]; then
        EXTRACT_DIR="$(cd "$FROM_MARKDOWN" && pwd)"
    else
        # Stage the single Markdown file into the workspace so the grimoire
        # stays self-contained and the user's original is never mutated.
        cp "$FROM_MARKDOWN" "$MINERU_DIR/$(basename "$FROM_MARKDOWN")"
        EXTRACT_DIR="$(cd "$MINERU_DIR" && pwd)"
    fi
    # Synthesize the manifest the downstream halves expect. Page count is
    # unknown from Markdown alone; 0 lets the classifier fall back to
    # structure/filename signals.
    jq -n --arg ed "$EXTRACT_DIR" \
        '{extract_dir: $ed, source: "from-markdown", page_count: 0}' \
        > "$MANIFEST_FILE"
else
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

    echo "[1/4] Parsing with MinerU (model: $MODEL)..."
    "$PARSER" "${parse_args[@]}"
fi

EXTRACT_DIR="$(jq -r '.extract_dir' "$MANIFEST_FILE")"
[[ -n "$EXTRACT_DIR" && "$EXTRACT_DIR" != "null" && -d "$EXTRACT_DIR" ]] \
    || error "Parse manifest did not contain a valid extract_dir"

PAGE_COUNT="$(jq -r '(.total_page_count // .page_count // 0)' "$MANIFEST_FILE" 2>/dev/null || echo 0)"
[[ "$PAGE_COUNT" =~ ^[0-9]+$ ]] || PAGE_COUNT=0

# ---- 2. Reading-notes half ------------------------------------------
DETECTED_TYPE="document"; CONFIDENCE="n/a"; VAULT_TARGET="(skipped)"
if [[ "$ONLY" == "both" || "$ONLY" == "notes" ]]; then
    echo "[2/4] Classifying + staging reading notes..."
    "$NOTES_PACKER" "$EXTRACT_DIR" \
        --title "$TITLE" \
        --slug "notes" \
        --type "$READING_TYPE" \
        --pages "$PAGE_COUNT" \
        --agent "$AGENT_NAME" \
        --vault "$OBSIDIAN_VAULT" \
        --output "$WORKSPACE_DIR" \
        --force
    NOTES_PACK="$NOTES_DIR"
    DETECTED_TYPE="$(jq -r '.reading_type' "$NOTES_PACK/manifest.json")"
    CONFIDENCE="$(jq -r '.confidence' "$NOTES_PACK/manifest.json")"
    VAULT_TARGET="$(jq -r '.vault_target' "$NOTES_PACK/manifest.json")"
else
    echo "[2/4] Notes skipped (--only $ONLY)"
fi

# ---- 3. Skill-pack half ---------------------------------------------
if [[ "$ONLY" == "both" || "$ONLY" == "skills" ]]; then
    echo "[3/4] Mining + staging skill pack..."
    # source-skill-pack has its own source-type taxonomy; pass the reading
    # type through (book/paper/document are all valid source types too).
    SKILL_TYPE="$READING_TYPE"
    [[ "$SKILL_TYPE" == "auto" && "$DETECTED_TYPE" != "document" ]] && SKILL_TYPE="$DETECTED_TYPE"
    "$SKILL_PACKER" "$EXTRACT_DIR" \
        --title "$TITLE" \
        --slug "skills" \
        --type "$SKILL_TYPE" \
        --agent "$AGENT_NAME" \
        --output "$WORKSPACE_DIR" \
        --force
    SKILL_PACK="$SKILLS_DIR"
else
    echo "[3/4] Skills skipped (--only $ONLY)"
fi

# ---- 4. Unified contract + manifest ---------------------------------
echo "[4/4] Weaving the grimoire..."
CREATED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
SAFE_TITLE="${TITLE//$'\n'/ }"; SAFE_TITLE="${SAFE_TITLE//$'\r'/ }"; SAFE_TITLE="${SAFE_TITLE//\#/}"

jq -n \
    --arg schema "grimoire.workspace.v1" \
    --arg title "$TITLE" \
    --arg slug "$SLUG" \
    --arg only "$ONLY" \
    --arg reading_type "$DETECTED_TYPE" \
    --arg confidence "$CONFIDENCE" \
    --arg vault_target "$VAULT_TARGET" \
    --arg created_at "$CREATED_AT" \
    --argjson page_count "$PAGE_COUNT" \
    '{
       schema: $schema, title: $title, slug: $slug, scope: $only,
       reading_type: $reading_type, confidence: $confidence,
       page_count: $page_count, vault_target: $vault_target,
       created_at: $created_at,
       llm_invoked: false, writes_into_vault: false,
       installs_skills: false, stores_remote_result_url: false
     }' > "$WORKSPACE_DIR/GRIMOIRE.md.json"

cat > "$WORKSPACE_DIR/GRIMOIRE.md" <<EOF
# 📖 Grimoire — $SAFE_TITLE

One source, parsed once, woven into two bound artifacts.

| | |
|---|---|
| Scope | \`$ONLY\` |
| Reading type | \`$DETECTED_TYPE\` (confidence: \`$CONFIDENCE\`) |
| Pages | \`$PAGE_COUNT\` |
| Notes → vault | \`$VAULT_TARGET\` |
| LLM invoked | no |
| Skills installed | no (candidates only) |

## Contents

- \`mineru/\` — parsed Markdown (single parse, shared by both halves)
$([[ "$ONLY" != skills ]] && echo "- \`notes/\` — typed reading-notes pack (→ Obsidian vault)")
$([[ "$ONLY" != notes ]] && echo "- \`skills/\` — per-source skill pack (segment → chapter-skills → whole-book merge)")
- \`GRIMOIRE_TASK.md\` — the single contract for the reading agent

## Boundary

Scripts parsed and scaffolded only. No note was written into the vault and no
skill was installed. The agent fills both, reviews skills, then promotes.
EOF

cat > "$WORKSPACE_DIR/GRIMOIRE_TASK.md" <<EOF
# Grimoire Task — $SAFE_TITLE

Agent: $AGENT_NAME
Reading type: \`$DETECTED_TYPE\` (confidence: \`$CONFIDENCE\`)
Scope: \`$ONLY\`. **No LLM has run yet. You are that LLM.**

You make ONE reading pass over the parsed source. For each chapter / section
/ segment you do TWO things in the same pass:

1. **Write the note** — follow \`notes/AI_READING_TASK.md\`
   (type-specific discipline: book = chapter notes, paper = structured
   reading + excerpts, document = content-adaptive points).
2. **Mine the skills** — follow \`skills/LLM_EXTRACTION_PROMPT.md\`
   for the SAME segment: extract only operational content (procedures,
   checklists, diagnostics, decision rules, prompt/coding patterns) into
   \`skills/chapter-skills/<segment>/skills/\`.

Then, per book / course (whole-source synthesis):

3. Merge the segment skills — fill
   \`skills/whole-book/WHOLE_BOOK_SUMMARY.md\`,
   \`skills/MINDMAP.md\`, \`skills/BOOK_SKILL_INDEX.md\`;
   promote reviewed cross-segment candidates into
   \`skills/skills/\`. This is the "skill pack" for this source.
4. Finish the notes — whole-source synthesis section, then land the note in
   the Obsidian vault per \`notes/OBSIDIAN_PLAN.md\`.

## Order

Both halves segment the same Markdown identically (shared segmenter), so the
segment lists line up one-to-one. Use
\`skills/segments/manifest.json\` as the canonical order; the note's
\`notes/segments/\` mirrors it ($([[ "$DETECTED_TYPE" == paper ]] && echo "paper notes are read whole" || echo "split the same way")).

## Boundary

- Skills are candidates. Do NOT install/enable them. After review, promote per
  \`skills/MANAGE_SKILLS.md\`.
- The note is written to the vault only after its quality self-check passes.
- Stop only when every segment has both a note and a skill sweep, the
  whole-source skill pack is merged, and the note exists at the vault target.
EOF

cat > "$WORKSPACE_DIR/README.md" <<EOF
# $SAFE_TITLE — Grimoire

Created by \`grimoire.sh\`. One parse → notes + skill pack.

- Status: parsed yes · LLM no · vault written no · skills installed no
- Reading type: \`$DETECTED_TYPE\` (\`$CONFIDENCE\`)
- Next: give the agent \`GRIMOIRE_TASK.md\`
EOF

echo
echo "Grimoire woven: $WORKSPACE_DIR"
echo "Type: $DETECTED_TYPE ($CONFIDENCE) | scope: $ONLY"
echo "Contract: $WORKSPACE_DIR/GRIMOIRE_TASK.md"
[[ "$ONLY" != skills ]] && echo "Notes → vault: $VAULT_TARGET"
[[ "$ONLY" != notes ]] && echo "Skill pack: $SKILLS_DIR/"
