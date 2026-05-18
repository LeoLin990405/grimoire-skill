#!/usr/bin/env bash
# Build a long-form source skill extraction workspace from MinerU markdown output.
# Usage: book-skill-pack.sh <markdown_file_or_extracted_dir> [options]

set -euo pipefail

OUTPUT_DIR="./book-skill-packs"
TITLE=""
SLUG=""
AGENT_NAME="Agent"
SOURCE_TYPE="auto"
FORCE=false

usage() {
    cat <<EOF
Long-Form Skill Pack Builder

Usage: book-skill-pack.sh <markdown_file_or_extracted_dir> [options]

Arguments:
  markdown_file_or_extracted_dir
      A single Markdown file, or a MinerU extracted directory containing .md files.

Options:
  --title <title>    Source title. Defaults to the source filename/directory.
  --slug <slug>      Output directory slug. Defaults to a sanitized title.
  --agent <name>     Agent name to use in generated prompts. Default: Agent.
  --type <type>      Source type: auto, book, course, paper, manual,
                    article-collection, or project-notes. Default: auto.
  --output <dir>     Parent output directory. Default: ./book-skill-packs
  --force            Replace an existing pack directory.
  -h, --help         Show this help.

Output:
  <output>/<slug>/
    README.md
    manifest.json
    LLM_EXTRACTION_PROMPT.md
    BOOK_SKILL_INDEX.md
    MANAGE_SKILLS.md
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

error() {
    echo "Error: $*" >&2
    exit 1
}

slugify() {
    local value="$1"
    value=$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')
    value=$(printf '%s' "$value" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
    if [[ -z "$value" ]]; then
        value="book-skill-pack-$(date -u +%Y%m%d%H%M%S)"
    fi
    printf '%s' "$value"
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || error "$1 is required but not installed"
}

classify_source_type() {
    local title_lc="$1"
    local file_sample="$2"

    if [[ "$SOURCE_TYPE" != "auto" ]]; then
        printf '%s' "$SOURCE_TYPE"
        return
    fi

    if printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'abstract|methodology|experiments?|limitations?|references|arxiv|doi'; then
        printf '%s' "paper"
    elif printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'lesson|module|nanodegree|udacity|course|quiz|exercise|project rubric'; then
        printf '%s' "course"
    elif printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'api reference|installation|configuration|quick start|troubleshooting|manual|specification'; then
        printf '%s' "manual"
    elif printf '%s\n%s\n' "$title_lc" "$file_sample" | grep -Eiq 'article|newsletter|post|essay collection'; then
        printf '%s' "article-collection"
    else
        printf '%s' "book"
    fi
}

source_unit_label() {
    case "$1" in
        book) printf '%s' "Chapter" ;;
        course) printf '%s' "Lesson" ;;
        paper) printf '%s' "Section" ;;
        manual) printf '%s' "Section" ;;
        article-collection) printf '%s' "Article" ;;
        project-notes) printf '%s' "Note" ;;
        *) printf '%s' "Section" ;;
    esac
}

boundary_keywords() {
    case "$1" in
        paper)
            printf '%s' "abstract|introduction|background|related work|method|methods|methodology|experiment|experiments|evaluation|results|discussion|limitations?|conclusion|references|appendix"
            ;;
        manual)
            printf '%s' "overview|quick start|getting started|installation|setup|configuration|usage|api reference|reference|examples?|troubleshooting|faq|appendix"
            ;;
        course)
            printf '%s' "lesson|module|unit|week|project|exercise|quiz|rubric|summary|review"
            ;;
        article-collection)
            printf '%s' "article|essay|post|newsletter|part"
            ;;
        *)
            printf '%s' "chapter|chap\\.?|part|section|lesson|module|unit|week"
            ;;
    esac
}

segment_markdown_file() {
    local source_file="$1"
    local segments_dir="$2"
    local unit_label="$3"
    local source_label="${4:-$(basename "$source_file")}"
    local start_index="${5:-0}"
    local extra_keywords="${6:-$(boundary_keywords book)}"

    awk -v outdir="$segments_dir" -v source_file="$source_file" -v source_label="$source_label" -v unit_label="$unit_label" -v start_index="$start_index" -v extra_keywords="$extra_keywords" '
    function slugify(value, result) {
        result = tolower(value)
        gsub(/[^a-z0-9]+/, "-", result)
        gsub(/^-+/, "", result)
        gsub(/-+$/, "", result)
        if (result == "") {
            result = "section"
        }
        return result
    }
    function is_boundary(line) {
        lc = tolower(line)
        return lc ~ "^#{1,3}[[:space:]]+((" extra_keywords ")([[:space:]:.-]+|$)|第.+[章节篇部]|[0-9]+([.)]|[[:space:]]+))"
    }
    function open_chapter(title) {
        if (file != "") {
            close(file)
        }
        count += 1
        global_index = start_index + count
        slug = slugify(title)
        filename = sprintf("%03d-%s.md", global_index, slug)
        file = sprintf("%s/%s", outdir, filename)
        titles[count] = title
        files[count] = "segments/" filename
        printf("# %s\n\n", title) > file
        printf("Source: `%s`\n\n", source_label) >> file
    }
    BEGIN {
        count = 0
        file = ""
    }
    {
        if (is_boundary($0)) {
            title = $0
            sub(/^#{1,3}[[:space:]]+/, "", title)
            open_chapter(title)
            next
        }
        if (file == "") {
            open_chapter(unit_label " 1 - " source_label)
        }
        print $0 >> file
    }
    END {
        if (file != "") {
            close(file)
        }
        for (i = 1; i <= count; i++) {
            printf("%s\t%s\n", files[i], titles[i])
        }
    }' "$source_file"
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

case "$SOURCE_TYPE" in
    auto|book|course|paper|manual|article-collection|project-notes) ;;
    *) error "Unsupported source type: $SOURCE_TYPE" ;;
esac

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

[[ -z "$SLUG" ]] && SLUG="$(slugify "$TITLE")"
PACK_DIR="$OUTPUT_DIR/$SLUG"

if [[ -e "$PACK_DIR" ]]; then
    if [[ "$FORCE" == true ]]; then
        case "$PACK_DIR" in
            ""|"/"|"."|"..") error "Refusing to replace unsafe output path: $PACK_DIR" ;;
        esac
        rm -rf "$PACK_DIR"
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
DETECTED_SOURCE_TYPE="$(classify_source_type "$(printf '%s' "$TITLE" | tr '[:upper:]' '[:lower:]')" "$SAMPLE_TEXT")"
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

jq -n \
    --arg title "$TITLE" \
    --arg slug "$SLUG" \
    --arg agent "$AGENT_NAME" \
    --arg source_type "$DETECTED_SOURCE_TYPE" \
    --arg requested_type "$SOURCE_TYPE" \
    --arg source_path "$SOURCE" \
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
      created_at: $created_at,
      markdown_file_count: $markdown_file_count,
      total_markdown_bytes: $total_bytes,
      segment_count: $segment_count,
      status: "staged_for_llm_extraction",
      expected_outputs: [
        "BOOK_SKILL_INDEX.md",
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
Source Markdown directory: \`source-markdown/\`
Segment manifest: \`segments/manifest.json\`

## Goal

Read the segmented source and extract every piece of content that can become an
operational skill for the target agent. Classify everything under this source
first, then use categories inside the source.

The final answer must make it clear:

1. What this source can help the agent do.
2. When the agent should reference this source.
3. What each segment contributes before the whole-source synthesis.
4. Which specific procedures, frameworks, checklists, heuristics, diagnostics,
   prompts, or decision rules can become skills.
5. Which useful material should remain reference-only for now.

## Required Work Order

1. Read \`manifest.json\` and \`segments/manifest.json\`.
2. For each file in \`segments/\`, fill the matching
   \`chapter-skills/<segment>/CHAPTER_SKILL_INDEX.md\`.
3. Create one narrow candidate skill per operational capability under the
   matching \`chapter-skills/<segment>/skills/\` directory.
4. Only after segment-level extraction is complete, fill
   \`whole-book/WHOLE_BOOK_SUMMARY.md\`.
5. Fill \`BOOK_SKILL_INDEX.md\` from the segment indexes and whole-source
   synthesis.
6. Copy or rewrite only reviewed cross-segment candidates into root \`skills/\`.

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

5. \`skills/<short-skill-slug>.md\`
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
6. \`BOOK_SKILL_INDEX.md\`: read the final index and promotion recommendations.
7. \`skills/*.md\`: promote only deliberately reviewed cross-segment skills.

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
