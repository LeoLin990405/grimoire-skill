#!/usr/bin/env bash
# Build a long-form source skill extraction workspace from MinerU markdown output.
# Usage: source-skill-pack.sh <markdown_file_or_extracted_dir> [options]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/source-types.sh
source "$SCRIPT_DIR/lib/source-types.sh"
# shellcheck source=lib/segment.sh
source "$SCRIPT_DIR/lib/segment.sh"

OUTPUT_DIR="./source-skill-packs"
TITLE=""
SLUG=""
AGENT_NAME="Agent"
SOURCE_TYPE="auto"
FORCE=false
NOTES_SOURCE=""   # set → mine skills FROM written notes (re-learning pass)

usage() {
    cat <<EOF
Long-Form Skill Pack Builder

Usage: source-skill-pack.sh <markdown_file_or_extracted_dir> [options]

Arguments:
  markdown_file_or_extracted_dir
      A single Markdown file, or a MinerU extracted directory containing .md files.

Options:
  --title <title>    Source title. Defaults to the source filename/directory.
  --slug <slug>      Output directory slug. Defaults to a sanitized title.
  --agent <name>     Agent name to use in generated prompts. Default: Agent.
  --type <type>      Source type: auto, book, course, paper, manual,
                    article-collection, project-notes, video, audio, web, or mixed.
                    Default: auto.
  --output <dir>     Parent output directory. Default: ./source-skill-packs
  --notes-source <p> Path to the reading notes the agent already wrote. When
                     set, the extraction prompt becomes a re-learning pass:
                     skills are mined FROM those notes' knowledge points, with
                     source-markdown/ kept only for evidence anchors. Unset
                     (default) → skills are mined from source-markdown/.
  --force            Replace an existing pack directory.
  -h, --help         Show this help.

Output:
  <output>/<slug>/
    README.md
    manifest.json
    LLM_EXTRACTION_PROMPT.md
    BOOK_SKILL_INDEX.md
    MANAGE_SKILLS.md
    MINDMAP.md
    SKILL_DISCOVERY_COVERAGE.md
    source-markdown/
    segments/
    chapter-skills/
    whole-book/
    skills/

This script does not call an LLM. It stages parsed long-form Markdown and the
extraction contract so a model can turn reusable source knowledge into reviewed skills.
EOF
    exit 0
}

SOURCE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --title) TITLE="${2:?Missing value for --title}"; shift 2 ;;
        --slug) SLUG="${2:?Missing value for --slug}"; shift 2 ;;
        --agent) AGENT_NAME="${2:?Missing value for --agent}"; shift 2 ;;
        --type|--source-type|--text-type) SOURCE_TYPE="${2:?Missing value for $1}"; shift 2 ;;
        --output) OUTPUT_DIR="${2:?Missing value for --output}"; shift 2 ;;
        --notes-source) NOTES_SOURCE="${2:?Missing value for --notes-source}"; shift 2 ;;
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

validate_source_type "$SOURCE_TYPE"

# Skill-extraction substrate. Default: the source Markdown (standalone /
# --only skills / legacy callers). With --notes-source: a re-learning pass
# over the reading notes the agent already wrote (the two-stage Grimoire
# flow — notes first, then skills FROM the notes' knowledge points).
if [[ -n "$NOTES_SOURCE" ]]; then
    SKILL_SUBSTRATE="notes"
    [[ -e "$NOTES_SOURCE" ]] || \
        echo "Warning: --notes-source path does not exist yet: $NOTES_SOURCE (the agent fills it in Stage 1)" >&2
    SUBSTRATE_HEADER="Primary substrate: your **reading notes** at \`$NOTES_SOURCE\` (you wrote these in Stage 1).
Source Markdown directory: \`source-markdown/\` — secondary, evidence/anchor lookup only.
Segment manifest: \`segments/manifest.json\` (chapter order; the notes follow it)."
    SUBSTRATE_GOAL="This is a **re-learning pass (重复学习)**. Re-read the notes you wrote in
Stage 1 and mine reusable skills from the knowledge points you captured
there. The note is the distilled substrate; go back to \`source-markdown/\`
only to verify an evidence anchor or recover a concrete procedure the note
compressed away. Do not re-derive skills from the raw source as if the notes
did not exist."
    WORK_ORDER_READ="1. Read \`manifest.json\`, \`segments/manifest.json\`, and your Stage 1
   reading notes at \`$NOTES_SOURCE\`."
    WORK_ORDER_PER_SEGMENT="2. For each segment in \`segments/manifest.json\` order, re-read that
   chapter/section's note block, then fill the matching
   \`chapter-skills/<segment>/CHAPTER_SKILL_INDEX.md\` from the note's
   knowledge points (use \`source-markdown/\` only for anchors)."
else
    SKILL_SUBSTRATE="source"
    SUBSTRATE_HEADER="Source Markdown directory: \`source-markdown/\`
Segment manifest: \`segments/manifest.json\`"
    SUBSTRATE_GOAL="Read the segmented source and extract every piece of content that can
become an operational skill for the target agent. Classify everything under
this source first, then use categories inside the source."
    WORK_ORDER_READ="1. Read \`manifest.json\` and \`segments/manifest.json\`."
    WORK_ORDER_PER_SEGMENT="2. For each file in \`segments/\`, fill the matching
   \`chapter-skills/<segment>/CHAPTER_SKILL_INDEX.md\`."
fi

require_cmd jq
require_cmd find

MD_FILES=()
if [[ -f "$SOURCE" ]]; then
    case "$SOURCE" in
        *.md|*.markdown) MD_FILES+=("$SOURCE") ;;
        *) error "Source file must be .md or .markdown: $SOURCE" ;;
    esac
elif [[ -d "$SOURCE" ]]; then
    while IFS= read -r file; do
        MD_FILES+=("$file")
    done < <(find "$SOURCE" -type f \( -name "*.md" -o -name "*.markdown" \) | sort)
else
    error "Source must be a file or directory: $SOURCE"
fi

[[ ${#MD_FILES[@]} -gt 0 ]] || error "No Markdown files found in: $SOURCE"

if [[ -z "$TITLE" ]]; then
    if [[ -f "$SOURCE" ]]; then
        TITLE="$(basename "$SOURCE")"
        TITLE="${TITLE%.*}"
    else
        TITLE="$(basename "$SOURCE")"
    fi
fi

[[ -z "$SLUG" ]] && SLUG="$(slugify "$TITLE" "source-skill-pack")"
PACK_DIR="$OUTPUT_DIR/$SLUG"

if [[ -e "$PACK_DIR" ]]; then
    if [[ "$FORCE" == true ]]; then
        safe_remove_dir "$PACK_DIR"
    else
        error "Output already exists: $PACK_DIR (use --force to replace it)"
    fi
fi

SEGMENTS_DIR="$PACK_DIR/segments"
CHAPTER_SKILLS_DIR="$PACK_DIR/chapter-skills"
WHOLE_BOOK_DIR="$PACK_DIR/whole-book"

mkdir -p "$PACK_DIR/source-markdown" "$PACK_DIR/skills" "$SEGMENTS_DIR" "$CHAPTER_SKILLS_DIR" "$WHOLE_BOOK_DIR"

COPIED_FILES=()
idx=1
for file in "${MD_FILES[@]}"; do
    dest="$PACK_DIR/source-markdown/$(printf '%03d' "$idx")-$(basename "$file")"
    cp "$file" "$dest"
    COPIED_FILES+=("$dest")
    idx=$((idx + 1))
done

TOTAL_BYTES=0
for file in "${COPIED_FILES[@]}"; do
    bytes=$(wc -c < "$file" | tr -d ' ')
    TOTAL_BYTES=$((TOTAL_BYTES + bytes))
done

CREATED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
SAMPLE_TEXT="$(sed -n '1,220p' "${COPIED_FILES[0]}")"
DETECTED_SOURCE_TYPE="$(classify_source_type "$SOURCE_TYPE" "$(printf '%s' "$TITLE" | tr '[:upper:]' '[:lower:]')" "$SAMPLE_TEXT")"
UNIT_LABEL="$(source_unit_label "$DETECTED_SOURCE_TYPE")"
UNIT_LABEL_LC="$(printf '%s' "$UNIT_LABEL" | tr '[:upper:]' '[:lower:]')"
BOUNDARY_KEYWORDS="$(boundary_keywords "$DETECTED_SOURCE_TYPE")"

SEGMENT_TSV="$SEGMENTS_DIR/manifest.tsv"
: > "$SEGMENT_TSV"
SEGMENT_OFFSET=0
for file in "${COPIED_FILES[@]}"; do
    segment_markdown_file "$file" "$SEGMENTS_DIR" "$UNIT_LABEL" "source-markdown/$(basename "$file")" "$SEGMENT_OFFSET" "$BOUNDARY_KEYWORDS" >> "$SEGMENT_TSV"
    SEGMENT_OFFSET=$(wc -l < "$SEGMENT_TSV" | tr -d ' ')
done

SEGMENT_COUNT=$(wc -l < "$SEGMENT_TSV" | tr -d ' ')
SEGMENTS_JSON="$(jq -Rn '
  [inputs
   | split("\t")
   | select(length >= 2)
   | {path: .[0], title: .[1], order: (input_line_number)}]
' "$SEGMENT_TSV")"

jq -n \
    --arg schema "mineru.source-segments.v1" \
    --arg source_type "$DETECTED_SOURCE_TYPE" \
    --arg requested_type "$SOURCE_TYPE" \
    --arg unit_label "$UNIT_LABEL" \
    --arg method "markdown_heading_boundary_with_file_fallback" \
    --argjson segment_count "$SEGMENT_COUNT" \
    --argjson segments "$SEGMENTS_JSON" \
    '{
      schema: $schema,
      source_type: $source_type,
      requested_type: $requested_type,
      unit_label: $unit_label,
      segmentation_method: $method,
      segment_count: $segment_count,
      segments: $segments
    }' > "$SEGMENTS_DIR/manifest.json"

while IFS=$'\t' read -r segment_file segment_title; do
    [[ -n "$segment_file" ]] || continue
    segment_slug="$(basename "${segment_file%.*}")"
    chapter_dir="$CHAPTER_SKILLS_DIR/$segment_slug"
    mkdir -p "$chapter_dir/skills"

    cat > "$chapter_dir/CHAPTER_SKILL_INDEX.md" <<EOF
# $segment_title - ${UNIT_LABEL} Skill Index

## Segment Summary

Summarize what this $UNIT_LABEL_LC contributes to $AGENT_NAME before creating
any whole-source conclusions.

## Candidate Skills From This Segment

| Skill candidate | What the agent can do | Trigger situation | Evidence anchor | Status |
|---|---|---|---|---|
|  |  |  |  | draft |

## Reference-Only Material

| Topic | Why it should remain reference-only | Evidence anchor |
|---|---|---|
|  |  |  |

## Extraction Notes

- Segment source: \`$segment_file\`
- Extract operational procedures, workflows, checklists, diagnostics, decision rules, prompt patterns, and implementation patterns.
- Keep source anchors short and local to this segment.
EOF

    cat > "$chapter_dir/skills/_skill-template.md" <<EOF
# <Skill Name>

## Source

- Source title: $TITLE
- Source type: $DETECTED_SOURCE_TYPE
- Segment: $segment_title
- Segment file: $segment_file

## What The Agent Can Do

Describe the concrete capability this segment gives $AGENT_NAME.

## When To Use

List concrete trigger situations.

## Inputs Needed

-

## Procedure

1.
2.
3.

## Expected Output

Describe the artifact, decision, diagnosis, plan, prompt, or checklist produced.

## Evidence Anchors

Add short source anchors from this segment.

## Limits And Failure Modes

-

## Promotion Recommendation

Choose one:

- keep-in-source-pack
- promote-to-managed-skill
- reference-only
EOF
done < "$SEGMENT_TSV"

cat > "$WHOLE_BOOK_DIR/WHOLE_BOOK_SUMMARY.md" <<EOF
# $TITLE - Whole-Source Summary

Fill this only after the chapter/segment extraction is complete.

## What This Source Helps $AGENT_NAME Do

Write a concise operational summary. Focus on capabilities, not a general source
report.

## When $AGENT_NAME Should Reference It

| Situation | Why this source helps | Relevant segments | Confidence |
|---|---|---|---|
|  |  |  |  |

## Skill Package Structure

Explain how the extracted segment skills fit together as a source-scoped package.

## Promotion Recommendations

| Skill candidate | Current location | Recommendation | Reason |
|---|---|---|---|
|  |  | keep-in-source-pack / promote-to-managed-skill / reference-only |  |

## Reference-Only Material

List useful concepts that should remain source-scoped references.
EOF

cat > "$PACK_DIR/MINDMAP.md" <<EOF
# $TITLE - Source Mindmap

Fill this as a hierarchical map before final skill promotion. Keep it compact
and operational: the map should show how source topics become reusable skills.

## Root

- $TITLE
  - Source type: $DETECTED_SOURCE_TYPE
  - Target agent: $AGENT_NAME
  - Core capability:

## Structure Map

Use \`segments/manifest.json\` as the canonical order.

| Segment | Main ideas | Candidate skill families | Reference-only concepts |
|---|---|---|---|
EOF

while IFS=$'\t' read -r segment_file segment_title; do
    [[ -n "$segment_file" ]] || continue
    printf '| %s |  |  |  |\n' "$segment_title" >> "$PACK_DIR/MINDMAP.md"
done < "$SEGMENT_TSV"

cat >> "$PACK_DIR/MINDMAP.md" <<EOF

## Skill Creation Map

- Managed skill candidates
  -
- Source-pack-only skills
  -
- Reference-only material
  -

## Topic Classification

Use this section to classify a course, video series, book, paper, or web source
into stable skill domains. Prefer domains that can become folders or packages in
a managed skill registry.

| Topic | Subtopic | Evidence segments | Candidate skills |
|---|---|---|---|
|  |  |  |  |
EOF

cat > "$PACK_DIR/SKILL_DISCOVERY_COVERAGE.md" <<EOF
# $TITLE - Skill Discovery Coverage

Repeat extraction passes until no new supported skills are found.

## Coverage Status

| Field | Value |
|---|---|
| Current pass | 1 |
| Skill discovery complete | false |
| Completion confidence | low / medium / high |
| Completion reason |  |

## Pass Log

| Pass | Sources/segments checked | New skills found | Skipped material | Why skipped | Next action |
|---|---|---:|---|---|---|
| 1 |  | 0 |  |  |  |

## Exhaustiveness Checklist

- [ ] Every chapter/lesson/section/timestamp/source segment checked.
- [ ] Procedures and workflows extracted.
- [ ] Checklists extracted.
- [ ] Diagnostics extracted.
- [ ] Decision rules extracted.
- [ ] Prompt patterns extracted.
- [ ] Implementation patterns extracted.
- [ ] Evaluation criteria extracted.
- [ ] Reference-only material separated.
- [ ] No unsupported skills invented.
- [ ] No long copyrighted excerpts copied.

## Stop Condition

Set \`Skill discovery complete\` to true only when a full pass over every source
unit produces no new supported operational skills and skipped material has a
clear reason. Reading all text once is not sufficient.
EOF

jq -n \
    --arg title "$TITLE" \
    --arg slug "$SLUG" \
    --arg agent "$AGENT_NAME" \
    --arg source_type "$DETECTED_SOURCE_TYPE" \
    --arg requested_type "$SOURCE_TYPE" \
    --arg source_path "$SOURCE" \
    --arg skill_substrate "$SKILL_SUBSTRATE" \
    --arg notes_source "$NOTES_SOURCE" \
    --arg created_at "$CREATED_AT" \
    --argjson markdown_file_count "${#COPIED_FILES[@]}" \
    --argjson total_bytes "$TOTAL_BYTES" \
    --argjson segment_count "$SEGMENT_COUNT" \
    '{
      schema: "mineru.longform-skill-pack.v2",
      title: $title,
      slug: $slug,
      target_agent: $agent,
      source_type: $source_type,
      requested_source_type: $requested_type,
      source_path: $source_path,
      skill_substrate: $skill_substrate,
      notes_source: $notes_source,
      created_at: $created_at,
      markdown_file_count: $markdown_file_count,
      total_markdown_bytes: $total_bytes,
      segment_count: $segment_count,
      status: "staged_for_llm_extraction",
      expected_outputs: [
        "BOOK_SKILL_INDEX.md",
        "MINDMAP.md",
        "SKILL_DISCOVERY_COVERAGE.md",
        "segments/manifest.json",
        "chapter-skills/*/CHAPTER_SKILL_INDEX.md",
        "chapter-skills/*/skills/*.md",
        "whole-book/WHOLE_BOOK_SUMMARY.md",
        "skills/*.md"
      ]
    }' > "$PACK_DIR/manifest.json"

cat > "$PACK_DIR/README.md" <<EOF
# $TITLE

This is a staged long-form skill pack generated from MinerU Markdown output.

## What This Pack Is For

Use this pack to let a large language model read a parsed long-form source and
extract reusable agent skills from it. The pack is source-scoped first, then
split into chapters, lessons, paper sections, or other native source units.

- Source type: \`$DETECTED_SOURCE_TYPE\`
- Segment count: \`$SEGMENT_COUNT\`

The model should answer:

- What can this source help $AGENT_NAME do?
- In what situations should $AGENT_NAME consult this source?
- What does each segment contribute before whole-source synthesis?
- Which reusable procedures, frameworks, checklists, heuristics, prompts, or
  decision rules can become skills?
- Which parts are source-specific references rather than general skills?

## Files

- \`source-markdown/\`: copied MinerU Markdown files.
- \`segments/\`: generated chapter/lesson/section files and \`manifest.json\`.
- \`MINDMAP.md\`: source structure map for turning topics into skill families.
- \`SKILL_DISCOVERY_COVERAGE.md\`: pass log for repeated skill discovery until no new supported skills are found.
- \`chapter-skills/\`: one extraction workspace per segment.
- \`whole-book/WHOLE_BOOK_SUMMARY.md\`: whole-source synthesis template, filled after segment extraction.
- \`BOOK_SKILL_INDEX.md\`: source-level summary and skill index template.
- \`skills/\`: optional promoted cross-segment candidates after review.
- \`MANAGE_SKILLS.md\`: guidance for promoting reviewed outputs into managed skills.
- \`LLM_EXTRACTION_PROMPT.md\`: prompt to give the model together with this workspace.

## First Iteration Boundary

This pack is a staging artifact. It does not automatically call a model and it
does not automatically enable generated skills. Review extracted skills before
promoting any of them into a managed skill repository.
EOF

cat > "$PACK_DIR/BOOK_SKILL_INDEX.md" <<EOF
# $TITLE - Source Skill Index

## Source-Level Agent Capability Summary

Fill this after all \`chapter-skills/*/CHAPTER_SKILL_INDEX.md\` files are completed.

- What can this source help $AGENT_NAME do?
- What kinds of tasks become easier or higher quality when this source is referenced?
- What are the strongest reusable ideas?

## When To Reference This Source

List concrete situations where $AGENT_NAME should consult this source. Prefer
trigger-style descriptions.

| Situation | Why this source helps | Relevant segments | Confidence |
|---|---|---|---|
|  |  |  |  |

## Source Segments

Use \`segments/manifest.json\` as the canonical list. Extract skills in
\`chapter-skills/\` before filling the whole-source synthesis.

## Skill Candidates By Source

All extracted skills in this pack must remain classified under this source first.
Use categories only inside the source boundary.

| Segment | Category | Skill candidate | What the agent can do | Trigger situation | Source evidence | Status |
|---|---|---|---|---|---|---|
|  | Workflow |  |  |  |  | candidate |
|  | Checklist |  |  |  |  | candidate |
|  | Decision rule |  |  |  |  | candidate |
|  | Diagnostic |  |  |  |  | candidate |
|  | Prompt pattern |  |  |  |  | candidate |

## Non-Skill Reference Material

Capture concepts that are useful as background reading but should not become
standalone skills yet.

| Topic | Why keep as reference | Source evidence |
|---|---|---|
|  |  |  |

## Extraction Notes

- Do not invent capabilities that are not supported by the source.
- Keep source-level classification intact even if multiple sources later share a category.
- Prefer small operational skills over broad summaries.
- Preserve source anchors such as chapter names, headings, page markers, or nearby quotes when available.
EOF

cat > "$PACK_DIR/LLM_EXTRACTION_PROMPT.md" <<EOF
# Long-Form Source Skill Extraction Prompt

You are extracting reusable agent skills from a parsed long-form source.

Source title: $TITLE
Detected source type: $DETECTED_SOURCE_TYPE
Target agent: $AGENT_NAME
$SUBSTRATE_HEADER

## Goal

$SUBSTRATE_GOAL

The final answer must make it clear:

1. What this source can help the agent do.
2. When the agent should reference this source.
3. What each segment contributes before the whole-source synthesis.
4. Which specific procedures, frameworks, checklists, heuristics, diagnostics,
   prompts, or decision rules can become skills.
5. Which useful material should remain reference-only for now.

## Required Work Order

$WORK_ORDER_READ
$WORK_ORDER_PER_SEGMENT
3. Create one narrow candidate skill per operational capability under the
   matching \`chapter-skills/<segment>/skills/\` directory.
4. Only after segment-level extraction is complete, fill
   \`whole-book/WHOLE_BOOK_SUMMARY.md\`.
5. Fill \`MINDMAP.md\` to map source topics into candidate skill families.
6. Fill \`SKILL_DISCOVERY_COVERAGE.md\`. Repeat passes until no new supported
   operational skills are found.
7. Fill \`BOOK_SKILL_INDEX.md\` from the segment indexes and whole-source
   synthesis.
8. Copy or rewrite only reviewed cross-segment candidates into root \`skills/\`.

## Required Outputs

Update or create these files:

1. \`chapter-skills/*/CHAPTER_SKILL_INDEX.md\`
   - Fill the segment summary.
   - Fill segment-level skill candidates.
   - Fill reference-only material.

2. \`chapter-skills/*/skills/<short-skill-slug>.md\`
   - Create one file per segment-level skill candidate.
   - Use the template in each segment's \`skills/_skill-template.md\`.

3. \`whole-book/WHOLE_BOOK_SUMMARY.md\`
   - Fill the source-level capability summary after segment extraction.
   - Explain when the agent should reference this source.
   - Describe how segment skills fit together as one package.

4. \`BOOK_SKILL_INDEX.md\`
   - Fill "Source-Level Agent Capability Summary".
   - Fill "When To Reference This Source".
   - Fill "Skill Candidates By Source".
   - Fill "Non-Skill Reference Material".

5. \`MINDMAP.md\`
   - Fill topic classification and skill-family mapping.
   - Use this to decide package structure for managed skills.

6. \`SKILL_DISCOVERY_COVERAGE.md\`
   - Record every extraction pass.
   - Stop only when a full pass finds no new supported operational skills.

7. \`skills/<short-skill-slug>.md\`
   - Optional root-level promoted candidates only.
   - Use this only after review-worthy cross-segment candidates are clear.

## Extraction Rules

- Do not summarize the whole source as one giant skill.
- Extract candidates segment by segment before writing the whole-source summary.
- After segment-level extraction, synthesize the source-level capability summary
  and explain how the segment skills fit together as one source-scoped package.
- Do not create skills from generic advice unless the source provides a specific
  procedure, checklist, decision rule, diagnostic, or reusable pattern.
- Do not claim the agent can do something unless the source supports it.
- Prefer triggerable skills: the "when to use" section must be concrete.
- Keep source evidence short. Use chapter/section/page markers when available.
- Mark uncertain candidates as \`draft\` and explain what is missing.
- If the source contains code, formulas, prompts, templates, or step-by-step
  methods, preserve them as references or compact procedures rather than prose.
- Separate "skills" from "reference material"; not every good idea should become
  an active skill.
- Keep extracting until a full coverage pass finds no new supported operational
  skills. Do not stop only because the text was read once.

## Per-Skill File Requirements

Each skill file must include:

- Skill name
- Source title and type
- What the agent can do with it
- When to use it
- Inputs needed
- Step-by-step procedure
- Output expected
- Evidence anchors from the source
- Limits and failure modes
- Promotion recommendation: \`keep-in-source-pack\`, \`promote-to-managed-skill\`, or \`reference-only\`
- Source structure path: chapter/lesson/section where this skill belongs

## Final Response To The User

After producing files, give a short Chinese report:

- 这个来源能帮 Agent 做什么
- 什么时候应该参考它
- 提炼出了哪些技能类别
- 哪些技能建议进入 managed skills
- 哪些只适合作为来源参考资料
EOF

cat > "$PACK_DIR/skills/README.md" <<EOF
# Reviewed Cross-Segment Skills From $TITLE

Put only reviewed cross-segment skill candidates in this directory. Segment-level
drafts belong in \`chapter-skills/*/skills/\` first.

Naming convention:

\`\`\`
skills/<short-skill-slug>.md
\`\`\`

Keep all skills classified under the source first. If a skill is later promoted
into a global managed skill, copy or rewrite it intentionally instead of blindly
enabling every generated file.
EOF

cat > "$PACK_DIR/skills/_skill-template.md" <<EOF
# <Skill Name>

## Source

- Title: $TITLE
- Source type: $DETECTED_SOURCE_TYPE
- Source files:
- Source anchors:

## What The Agent Can Do

Describe the concrete capability this skill gives the agent.

## When To Use

List trigger situations. These should be specific enough that the agent can
decide whether to consult this skill during normal work.

## Inputs Needed

-

## Procedure

1.
2.
3.

## Expected Output

Describe the artifact, decision, diagnosis, plan, prompt, or checklist produced.

## Evidence Anchors

Add short source anchors. Prefer chapter/lesson/section/page references.

## Limits And Failure Modes

-

## Promotion Recommendation

Choose one:

- keep-in-source-pack
- promote-to-managed-skill
- reference-only
EOF

cat > "$PACK_DIR/MANAGE_SKILLS.md" <<EOF
# Manage Skills Guidance

This pack is source-scoped. Treat it as a review workspace before installing or
enabling any skill globally.

## Recommended Flow

1. Parse the uploaded source with MinerU.
2. Build this long-form skill pack.
3. Read \`manifest.json\` and \`segments/manifest.json\`.
4. Process \`chapter-skills/*\` one segment at a time.
5. Fill \`whole-book/WHOLE_BOOK_SUMMARY.md\` after segment extraction.
6. Review \`BOOK_SKILL_INDEX.md\`, \`chapter-skills/*/skills/*.md\`, and root \`skills/*.md\`.
7. Promote only stable, generally useful skills into a managed skills repo.
8. Enable promoted skills with the local skills manager when appropriate.

## Manage Skills Consumption Contract

A skill manager or agent team should consume this pack in this order:

1. \`manifest.json\`: detect schema, title, source type, and segment count.
2. \`segments/manifest.json\`: enumerate source units.
3. \`chapter-skills/<segment>/CHAPTER_SKILL_INDEX.md\`: review segment-level candidates.
4. \`chapter-skills/<segment>/skills/*.md\`: review individual draft skills.
5. \`whole-book/WHOLE_BOOK_SUMMARY.md\`: read final source-level synthesis.
6. \`MINDMAP.md\`: read topic and skill-family classification.
7. \`SKILL_DISCOVERY_COVERAGE.md\`: verify the no-new-skills stop condition.
8. \`BOOK_SKILL_INDEX.md\`: read the final index and promotion recommendations.
9. \`skills/*.md\`: promote only deliberately reviewed cross-segment skills.

## Boundary With skills-mgr

- Use skills-mgr to manage installed skills, not to blindly install every source output.
- A source pack may contain many draft skills; most should remain source-scoped until reviewed.
- After promoting a skill into a real managed skill, run the local skills manager separately, for example:

\`\`\`bash
skills enable <promoted-skill-name>
\`\`\`

Then restart the agent runtime if required by the local skills manager.

## Safety

- Do not store API tokens, auth headers, cookies, or private account data in generated skills.
- Do not promote copyrighted long excerpts. Keep evidence anchors short.
- Do not claim a skill is active until it has been installed/enabled through the normal skill manager.
EOF

echo "Long-form skill pack created: $PACK_DIR"
echo "Next: give $PACK_DIR/LLM_EXTRACTION_PROMPT.md, $PACK_DIR/segments/, and $PACK_DIR/chapter-skills/ to a model."
