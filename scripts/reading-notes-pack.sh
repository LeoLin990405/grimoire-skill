#!/usr/bin/env bash
# Build a reading-notes workspace from MinerU Markdown output.
# Usage: reading-notes-pack.sh <markdown_file_or_extracted_dir> [options]
#
# This script classifies the source as book / paper / document (hybrid:
# deterministic heuristic + AI confirmation fallback when confidence is low),
# scaffolds the matching note discipline, and stages an Obsidian write plan.
# It does NOT call an LLM and does NOT write into the vault itself: the active
# agent reads the parsed Markdown, fills the notes, and (after the quality
# self-check) writes the final note into the planned vault path.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/source-types.sh
source "$SCRIPT_DIR/lib/source-types.sh"
# shellcheck source=lib/segment.sh
source "$SCRIPT_DIR/lib/segment.sh"
# shellcheck source=lib/reading-types.sh
source "$SCRIPT_DIR/lib/reading-types.sh"

TEMPLATE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)/templates/reading-notes"

OUTPUT_DIR="./reading-note-packs"
TITLE=""
SLUG=""
READING_TYPE="auto"
PAGE_COUNT=0
AGENT_NAME="Agent"
OBSIDIAN_VAULT="${MINERU_OBSIDIAN_VAULT:-$HOME/Documents/Obsidian-Vaults/Knowledge-Hub}"
FORCE=false

usage() {
    cat <<EOF
MinerU Reading-Notes Pack Builder

Usage: reading-notes-pack.sh <markdown_file_or_extracted_dir> [options]

Arguments:
  markdown_file_or_extracted_dir
                     A single .md/.markdown file or a directory of MinerU
                     Markdown output.

Options:
  --title <title>    Source title. Defaults to the file/dir basename.
  --slug <slug>      Pack + vault note slug. Defaults to a sanitized title.
  --type <type>      auto (default) | book | paper | document.
                     auto runs the hybrid classifier.
  --pages <n>        Page count hint, improves auto classification.
  --agent <name>     Name of the agent that will read and write notes.
  --vault <path>     Obsidian vault root. Default: \$MINERU_OBSIDIAN_VAULT or
                     ~/Documents/Obsidian-Vaults/Knowledge-Hub
  --output <dir>     Pack root. Default: ./reading-note-packs
  --force            Replace an existing pack.
  -h, --help         Show this help.

Output (per source):
  <output>/<slug>/
    README.md
    classification.json        detected type, confidence, signals
    AI_CLASSIFY.md             only when confidence is low
    AI_READING_TASK.md         the contract for the reading agent
    OBSIDIAN_PLAN.md           exact vault target + house-style rules
    manifest.json
    source-markdown/           copied MinerU Markdown
    segments/                  chapter/section split (book & document)
    notes/<slug>.md            note scaffold from the matching template

The script never calls an LLM and never writes into the Obsidian vault.
EOF
    exit 0
}

SOURCE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --title) TITLE="${2:?Missing value for --title}"; shift 2 ;;
        --slug) SLUG="${2:?Missing value for --slug}"; shift 2 ;;
        --type|--reading-type) READING_TYPE="${2:?Missing value for $1}"; shift 2 ;;
        --pages) PAGE_COUNT="${2:?Missing value for --pages}"; shift 2 ;;
        --agent) AGENT_NAME="${2:?Missing value for --agent}"; shift 2 ;;
        --vault) OBSIDIAN_VAULT="${2:?Missing value for --vault}"; shift 2 ;;
        --output) OUTPUT_DIR="${2:?Missing value for --output}"; shift 2 ;;
        --force) FORCE=true; shift ;;
        -*) error "Unknown option: $1" ;;
        *)
            if [[ -n "$SOURCE" ]]; then
                error "Only one source path is supported"
            fi
            SOURCE="$1"
            shift
            ;;
    esac
done

[[ -z "$SOURCE" ]] && error "No markdown file or extracted directory provided. Use --help."
[[ -e "$SOURCE" ]] || error "Source not found: $SOURCE"
[[ "$PAGE_COUNT" =~ ^[0-9]+$ ]] || error "--pages must be an integer"
validate_reading_type "$READING_TYPE"
require_cmd jq
require_cmd awk

# ---- collect markdown files ------------------------------------------
MD_FILES=()
if [[ -f "$SOURCE" ]]; then
    case "$SOURCE" in
        *.md|*.markdown) MD_FILES+=("$SOURCE") ;;
        *) error "Source file must be .md or .markdown: $SOURCE" ;;
    esac
else
    while IFS= read -r f; do
        MD_FILES+=("$f")
    done < <(find "$SOURCE" -type f \( -name "*.md" -o -name "*.markdown" \) | sort)
fi
[[ ${#MD_FILES[@]} -gt 0 ]] || error "No .md/.markdown files found under: $SOURCE"

if [[ -z "$TITLE" ]]; then
    TITLE="$(basename "$SOURCE")"
    # Strip only real Markdown extensions so dotted directory names survive.
    TITLE="${TITLE%.md}"
    TITLE="${TITLE%.markdown}"
fi
# Display-safe title for agent-facing here-docs: a crafted --title with
# newlines or leading '#' could otherwise inject fake instructions/headings
# into AI_READING_TASK.md / AI_CLASSIFY.md.
SAFE_TITLE="${TITLE//$'\n'/ }"
SAFE_TITLE="${SAFE_TITLE//$'\r'/ }"
SAFE_TITLE="${SAFE_TITLE//\#/}"

[[ -z "$SLUG" ]] && SLUG="$(slugify "$TITLE" "source")"
# slugify drops non-ASCII; a Chinese-only title degrades to a timestamp slug
# (unstable path, different on every run). Warn so the user can pin --slug.
case "$SLUG" in
    source-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
        echo "Warning: title produced a timestamp slug ('$SLUG'); pass --slug for a stable vault path." >&2 ;;
esac

PACK_DIR="$OUTPUT_DIR/$SLUG"
if [[ -e "$PACK_DIR" ]]; then
    if [[ "$FORCE" == true ]]; then
        safe_remove_dir "$PACK_DIR"
    else
        error "Pack already exists: $PACK_DIR (use --force to replace it)"
    fi
fi

SRC_MD_DIR="$PACK_DIR/source-markdown"
SEGMENTS_DIR="$PACK_DIR/segments"
NOTES_DIR="$PACK_DIR/notes"
mkdir -p "$SRC_MD_DIR" "$NOTES_DIR"

COPIED_FILES=()
idx=1
for file in "${MD_FILES[@]}"; do
    dest="$SRC_MD_DIR/$(printf '%03d' "$idx")-$(basename "$file")"
    cp "$file" "$dest"
    COPIED_FILES+=("$dest")
    idx=$((idx + 1))
done

TOTAL_BYTES=0
for file in "${COPIED_FILES[@]}"; do
    TOTAL_BYTES=$((TOTAL_BYTES + $(wc -c < "$file" | tr -d ' ')))
done

# ---- hybrid classification -------------------------------------------
TITLE_LC="$(printf '%s' "$TITLE" | tr '[:upper:]' '[:lower:]')"
SAMPLE_HEAD="$(sed -n '1,220p' "${COPIED_FILES[0]}")"
SAMPLE_TAIL="$(tail -n 80 "${COPIED_FILES[${#COPIED_FILES[@]}-1]}")"
# Neutralize code-fence sequences so source content cannot break out of the
# fenced sample blocks in AI_CLASSIFY.md and inject text as document body.
SAMPLE_HEAD_SAFE="${SAMPLE_HEAD//\`\`\`/\~\~\~}"
SAMPLE_TAIL_SAFE="${SAMPLE_TAIL//\`\`\`/\~\~\~}"

IFS=$'\t' read -r DETECTED_TYPE CONFIDENCE METHOD SIGNALS \
    < <(classify_reading_type "$READING_TYPE" "$TITLE_LC" "$SAMPLE_HEAD"$'\n'"$SAMPLE_TAIL" "$PAGE_COUNT")

NEEDS_AI=false
[[ "$CONFIDENCE" == "low" ]] && NEEDS_AI=true

CREATED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
SIGNALS_JSON="$(printf '%s' "$SIGNALS" | tr ',' '\n' | jq -Rn '[inputs | select(. != "-" and length > 0)]')"

jq -n \
    --arg schema "mineru.reading-classification.v1" \
    --arg title "$TITLE" \
    --arg requested "$READING_TYPE" \
    --arg detected "$DETECTED_TYPE" \
    --arg confidence "$CONFIDENCE" \
    --arg method "$METHOD" \
    --argjson page_count "$PAGE_COUNT" \
    --argjson needs_ai "$NEEDS_AI" \
    --argjson signals "$SIGNALS_JSON" \
    --arg created_at "$CREATED_AT" \
    '{
       schema: $schema,
       title: $title,
       requested_type: $requested,
       detected_type: $detected,
       final_type: $detected,
       confidence: $confidence,
       method: $method,
       page_count: $page_count,
       needs_ai_confirmation: $needs_ai,
       signals: $signals,
       created_at: $created_at
     }' > "$PACK_DIR/classification.json"

VAULT_FOLDER="$(reading_vault_folder "$DETECTED_TYPE")"
TEMPLATE_FILE="$TEMPLATE_DIR/$(reading_note_template "$DETECTED_TYPE")"
[[ -f "$TEMPLATE_FILE" ]] || error "Missing note template: $TEMPLATE_FILE"
UNIT_LABEL="$(reading_unit_label "$DETECTED_TYPE")"
NOTE_FILE="$NOTES_DIR/$SLUG.md"
VAULT_TARGET="$OBSIDIAN_VAULT/$VAULT_FOLDER/$SLUG.md"

cp "$TEMPLATE_FILE" "$NOTE_FILE"

# ---- segmentation ----------------------------------------------------
# Books and documents get chapter/section splits to read unit by unit.
# Papers stay whole (short, single argument) — no segmentation.
SEGMENT_COUNT=0
if [[ "$DETECTED_TYPE" != "paper" ]]; then
    mkdir -p "$SEGMENTS_DIR"
    BOUNDARY_KEYWORDS="$(reading_boundary_keywords "$DETECTED_TYPE")"
    SEGMENT_TSV="$SEGMENTS_DIR/manifest.tsv"
    : > "$SEGMENT_TSV"
    SEGMENT_OFFSET=0
    for file in "${COPIED_FILES[@]}"; do
        segment_markdown_file "$file" "$SEGMENTS_DIR" "$UNIT_LABEL" \
            "source-markdown/$(basename "$file")" "$SEGMENT_OFFSET" "$BOUNDARY_KEYWORDS" >> "$SEGMENT_TSV"
        SEGMENT_OFFSET=$(wc -l < "$SEGMENT_TSV" | tr -d ' ')
    done
    SEGMENT_COUNT=$(wc -l < "$SEGMENT_TSV" | tr -d ' ')
    SEGMENTS_JSON="$(jq -Rn '[inputs | select(length>0) | split("\t") | {file: .[0], title: .[1]}]' "$SEGMENT_TSV")"
    jq -n \
        --arg schema "mineru.reading-segments.v1" \
        --arg type "$DETECTED_TYPE" \
        --arg unit "$UNIT_LABEL" \
        --argjson count "$SEGMENT_COUNT" \
        --argjson segments "$SEGMENTS_JSON" \
        '{schema:$schema, reading_type:$type, unit_label:$unit, segment_count:$count, segments:$segments}' \
        > "$SEGMENTS_DIR/manifest.json"
fi

# ---- low-confidence AI confirmation step -----------------------------
if [[ "$NEEDS_AI" == true ]]; then
    cat > "$PACK_DIR/AI_CLASSIFY.md" <<EOF
# Step 0 — Confirm Source Type (required)

The deterministic classifier was **not confident**.

- Heuristic best guess: \`$DETECTED_TYPE\`
- Confidence: \`$CONFIDENCE\`
- Signals: \`$SIGNALS\`

This pack was scaffolded for \`$DETECTED_TYPE\`. Before reading, confirm the
real type from the sample below. Decide exactly one of: **book**, **paper**,
**document**.

Definitions:
- **book**: multi-chapter long-form work; note discipline is chapter-by-chapter.
- **paper**: a single research paper / article; note discipline is a detailed
  structured reading + excerpt note.
- **document**: manual, spec, report, slides, runbook, mixed material; note
  discipline is content-adaptive structured points.

After deciding:

1. If your decision == \`$DETECTED_TYPE\`: set \`needs_ai_confirmation\` to
   \`false\` in \`classification.json\` and continue with \`AI_READING_TASK.md\`.
2. If your decision != \`$DETECTED_TYPE\`: re-run the packer for the correct
   type (deterministic, cheap), then continue:

   \`\`\`bash
   reading-notes-pack.sh "<same source>" --type <book|paper|document> \\
     --title "$SAFE_TITLE" --slug "$SLUG" --output "$OUTPUT_DIR" --force
   \`\`\`

## Sample — first 220 lines

\`\`\`text
$SAMPLE_HEAD_SAFE
\`\`\`

## Sample — last 80 lines

\`\`\`text
$SAMPLE_TAIL_SAFE
\`\`\`
EOF
fi

# ---- Obsidian write plan --------------------------------------------
cat > "$PACK_DIR/OBSIDIAN_PLAN.md" <<EOF
# Obsidian Write Plan

The final note for this source belongs in the Knowledge-Hub vault.

| Field | Value |
|---|---|
| Vault root | \`$OBSIDIAN_VAULT\` |
| Reading type | \`$DETECTED_TYPE\` |
| Target folder | \`$VAULT_FOLDER/\` |
| Target file | \`$SLUG.md\` |
| Full target path | \`$VAULT_TARGET\` |

## House-style rules (Knowledge-Hub)

1. Match the existing convention. Before writing, open one sibling note in
   \`$OBSIDIAN_VAULT/$VAULT_FOLDER/\` and mirror its frontmatter keys, heading
   style, and language. The scaffold in \`notes/$SLUG.md\` is a starting point,
   not a fixed schema.
2. Keep YAML frontmatter (\`title\`, \`tags\`, \`type\`, ...). Use Chinese title
   with English subtitle when the source has one.
3. Cross-reference related vault pages with \`[[wikilinks]]\`.
4. Quality bar: a finished note under 2KB is "weak" and not acceptable.
   Target > 2KB (solid) and aim for > 5KB (deep) with real synthesis, not
   restated headings.
5. Preserve evidence anchors (chapter/section/page). Do not over-summarize or
   rewrite the source's meaning away.
6. After writing the note, append one line to \`$OBSIDIAN_VAULT/log.md\`:
   \`## [$(date -u +%Y-%m-%d)] ingest | $SAFE_TITLE -> $VAULT_FOLDER/$SLUG.md\`

The packer did NOT create or modify any vault file. You write it after the
quality self-check in \`AI_READING_TASK.md\`.
EOF

# ---- the reading contract -------------------------------------------
if [[ "$DETECTED_TYPE" == "book" ]]; then
    DISCIPLINE='Fill the chapter map, then write one complete note block per chapter
(core question, argument, detailed unpacking, key terms, reusable
methods, evidence anchors, follow-up thoughts). Read chapter by chapter
from `segments/` using `segments/manifest.json` as the canonical order.
End with the whole-book synthesis.'
elif [[ "$DETECTED_TYPE" == "paper" ]]; then
    DISCIPLINE='Write a detailed structured reading note: research question,
contributions, method, experimental setup, results, limitations,
relation to prior work. Then a per-section excerpt table with anchors
(§, Fig., Table) and your interpretation. End with a personal critique.
Do not flatten the paper into a one-paragraph abstract.'
else
    DISCIPLINE='Reorganize by the documents own structure (sections / modules /
steps) into retrievable points. Adapt emphasis to the document kind:
manuals -> how-to + parameters + constraints; reports -> conclusions +
evidence; specs -> rules + boundaries. Add an actionable checklist and a
reference index. Read section by section from `segments/`.'
fi

cat > "$PACK_DIR/AI_READING_TASK.md" <<EOF
# Reading Task — $SAFE_TITLE

Agent: $AGENT_NAME
Reading type: \`$DETECTED_TYPE\` (confidence: \`$CONFIDENCE\`)
This task was staged by a script. **No LLM has run yet. You are that LLM.**

## Step 0 — Type confirmation

$(if [[ "$NEEDS_AI" == true ]]; then echo "Confidence is low. Do **Step 0** in \`AI_CLASSIFY.md\` first."; else echo "Confidence is acceptable. Skip to Step 1 (re-check only if the sample obviously contradicts \`$DETECTED_TYPE\`)."; fi)

## Step 1 — Read the source

- Source Markdown: \`source-markdown/\`
$(if [[ "$DETECTED_TYPE" == "paper" ]]; then echo "- Read the whole paper; it is short and single-argument."; else echo "- Segments: \`segments/\` ($SEGMENT_COUNT units). Use \`segments/manifest.json\` as the canonical order and read unit by unit."; fi)
- Do not skim. The notes must reflect the actual content, not the headings.

## Step 2 — Write notes

Edit \`notes/$SLUG.md\` (seeded from the \`$DETECTED_TYPE\` template).

$DISCIPLINE

Rules:
- Preserve evidence anchors (chapter / §section / p.page).
- Use \`[[wikilinks]]\` for concepts that likely have vault pages.
- Keep the source's meaning. Do not polish it into something it is not.

## Step 3 — Quality self-check

- [ ] Every chapter / section / key claim is actually covered.
- [ ] Note is > 2KB of real synthesis (target > 5KB for deep sources).
- [ ] Evidence anchors present.
- [ ] Cross-references added.
- [ ] No template placeholders left (\`<...>\`, empty table rows).

## Step 4 — Land it in Obsidian

Follow \`OBSIDIAN_PLAN.md\`: match a sibling note's house style, write the
final note to the target vault path, then append the \`log.md\` line.

Stop only when Step 3 passes and the note exists at the vault target path.
EOF

# ---- pack manifest + readme -----------------------------------------
jq -n \
    --arg schema "mineru.reading-notes-pack.v1" \
    --arg title "$TITLE" \
    --arg slug "$SLUG" \
    --arg reading_type "$DETECTED_TYPE" \
    --arg confidence "$CONFIDENCE" \
    --arg vault_target "$VAULT_TARGET" \
    --argjson page_count "$PAGE_COUNT" \
    --argjson segment_count "$SEGMENT_COUNT" \
    --argjson markdown_file_count "${#COPIED_FILES[@]}" \
    --argjson total_markdown_bytes "$TOTAL_BYTES" \
    --argjson needs_ai "$NEEDS_AI" \
    --arg created_at "$CREATED_AT" \
    '{
       schema: $schema,
       title: $title,
       slug: $slug,
       reading_type: $reading_type,
       confidence: $confidence,
       needs_ai_confirmation: $needs_ai,
       page_count: $page_count,
       segment_count: $segment_count,
       markdown_file_count: $markdown_file_count,
       total_markdown_bytes: $total_markdown_bytes,
       vault_target: $vault_target,
       created_at: $created_at,
       llm_invoked: false,
       writes_into_vault: false,
       stores_remote_result_url: false
     }' > "$PACK_DIR/manifest.json"

cat > "$PACK_DIR/README.md" <<EOF
# Reading-Notes Pack — $SAFE_TITLE

| | |
|---|---|
| Detected type | \`$DETECTED_TYPE\` |
| Confidence | \`$CONFIDENCE\` |
| Segments | \`$SEGMENT_COUNT\` |
| Vault target | \`$VAULT_TARGET\` |
| LLM invoked | no |
| Vault written | no |

## What to do

Give this pack to the reading agent. Entry point: \`AI_READING_TASK.md\`.
$(if [[ "$NEEDS_AI" == true ]]; then echo "Confidence is low — \`AI_CLASSIFY.md\` (Step 0) runs first."; fi)

The agent reads \`source-markdown/\`$(if [[ "$DETECTED_TYPE" != "paper" ]]; then echo " / \`segments/\`"; fi), fills
\`notes/$SLUG.md\`, then writes the final note into the vault per
\`OBSIDIAN_PLAN.md\`.
EOF

echo "Reading-notes pack created: $PACK_DIR"
echo "Detected type: $DETECTED_TYPE (confidence: $CONFIDENCE; signals: $SIGNALS)"
[[ "$NEEDS_AI" == true ]] && echo "Low confidence -> agent must confirm type via AI_CLASSIFY.md"
echo "Reading contract: $PACK_DIR/AI_READING_TASK.md"
echo "Vault target: $VAULT_TARGET"
