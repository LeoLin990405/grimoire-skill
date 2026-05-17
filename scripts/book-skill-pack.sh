#!/usr/bin/env bash
# Build a book skill extraction workspace from MinerU markdown output.
# Usage: book-skill-pack.sh <markdown_file_or_extracted_dir> [options]

set -euo pipefail

OUTPUT_DIR="./book-skill-packs"
TITLE=""
SLUG=""
AGENT_NAME="Agent"
FORCE=false

usage() {
    cat <<EOF
Book Skill Pack Builder

Usage: book-skill-pack.sh <markdown_file_or_extracted_dir> [options]

Arguments:
  markdown_file_or_extracted_dir
      A single Markdown file, or a MinerU extracted directory containing .md files.

Options:
  --title <title>    Book title. Defaults to the source filename/directory.
  --slug <slug>      Output directory slug. Defaults to a sanitized title.
  --agent <name>     Agent name to use in generated prompts. Default: Agent.
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
    skills/

This script does not call an LLM. It stages the parsed book and the extraction
contract so a model can turn reusable book knowledge into reviewed skills.
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

SOURCE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --title) TITLE="${2:?Missing value for --title}"; shift 2 ;;
        --slug) SLUG="${2:?Missing value for --slug}"; shift 2 ;;
        --agent) AGENT_NAME="${2:?Missing value for --agent}"; shift 2 ;;
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

mkdir -p "$PACK_DIR/source-markdown" "$PACK_DIR/skills"

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

jq -n \
    --arg title "$TITLE" \
    --arg slug "$SLUG" \
    --arg agent "$AGENT_NAME" \
    --arg source_path "$SOURCE" \
    --arg created_at "$CREATED_AT" \
    --argjson markdown_file_count "${#COPIED_FILES[@]}" \
    --argjson total_bytes "$TOTAL_BYTES" \
    '{
      schema: "mineru.book-skill-pack.v1",
      title: $title,
      slug: $slug,
      target_agent: $agent,
      source_path: $source_path,
      created_at: $created_at,
      markdown_file_count: $markdown_file_count,
      total_markdown_bytes: $total_bytes,
      status: "staged_for_llm_extraction",
      expected_outputs: [
        "BOOK_SKILL_INDEX.md",
        "skills/*.md"
      ]
    }' > "$PACK_DIR/manifest.json"

cat > "$PACK_DIR/README.md" <<EOF
# $TITLE

This is a staged book skill pack generated from MinerU Markdown output.

## What This Pack Is For

Use this pack to let a large language model read the parsed book and extract
reusable agent skills from it. The model should answer:

- What can this book help $AGENT_NAME do?
- In what situations should $AGENT_NAME consult this book?
- Which reusable procedures, frameworks, checklists, heuristics, prompts, or
  decision rules can become skills?
- Which parts are book-specific references rather than general skills?

## Files

- \`source-markdown/\`: copied MinerU Markdown files for the book.
- \`LLM_EXTRACTION_PROMPT.md\`: prompt to give the model together with the source Markdown.
- \`BOOK_SKILL_INDEX.md\`: book-level summary and skill index template.
- \`skills/\`: per-skill files produced after model extraction and human review.
- \`MANAGE_SKILLS.md\`: guidance for promoting reviewed outputs into managed skills.

## First Iteration Boundary

This pack is a staging artifact. It does not automatically call a model and it
does not automatically enable generated skills. Review extracted skills before
promoting any of them into a managed skill repository.
EOF

cat > "$PACK_DIR/BOOK_SKILL_INDEX.md" <<EOF
# $TITLE - Book Skill Index

## Book-Level Agent Capability Summary

Write a concise answer to:

- What can this book help $AGENT_NAME do?
- What kinds of tasks become easier or higher quality when this book is referenced?
- What are the book's strongest reusable ideas?

## When To Reference This Book

List concrete situations where $AGENT_NAME should consult this book. Prefer
trigger-style descriptions.

| Situation | Why this book helps | Relevant chapters/sections | Confidence |
|---|---|---|---|
|  |  |  |  |

## Skill Candidates By Book

All extracted skills in this pack must remain classified under this book first.
Use categories only inside the book boundary.

| Category | Skill candidate | What the agent can do | Trigger situation | Source evidence | Status |
|---|---|---|---|---|---|
| Workflow |  |  |  |  | candidate |
| Checklist |  |  |  |  | candidate |
| Decision rule |  |  |  |  | candidate |
| Diagnostic |  |  |  |  | candidate |
| Prompt pattern |  |  |  |  | candidate |

## Non-Skill Reference Material

Capture concepts that are useful as background reading but should not become
standalone skills yet.

| Topic | Why keep as reference | Source evidence |
|---|---|---|
|  |  |  |

## Extraction Notes

- Do not invent capabilities that are not supported by the book.
- Keep book-level classification intact even if multiple books later share a category.
- Prefer small operational skills over broad summaries.
- Preserve source anchors such as chapter names, headings, page markers, or nearby quotes when available.
EOF

cat > "$PACK_DIR/LLM_EXTRACTION_PROMPT.md" <<EOF
# Book Skill Extraction Prompt

You are extracting reusable agent skills from a parsed book.

Book title: $TITLE
Target agent: $AGENT_NAME
Source Markdown directory: \`source-markdown/\`

## Goal

Read all Markdown files in \`source-markdown/\`. Extract every piece of content
that can become an operational skill for the target agent. Classify everything
under this book first, then use categories inside the book.

The final answer must make it clear:

1. What this book can help the agent do.
2. When the agent should reference this book.
3. What each chapter contributes before the whole-book synthesis.
4. Which specific procedures, frameworks, checklists, heuristics, diagnostics,
   prompts, or decision rules can become skills.
5. Which useful material should remain reference-only for now.

## Required Outputs

Update or create these files:

1. \`BOOK_SKILL_INDEX.md\`
   - Fill the book-level capability summary.
   - Fill "When To Reference This Book".
   - Fill "Skill Candidates By Book".
   - Fill "Non-Skill Reference Material".

2. \`skills/<short-skill-slug>.md\`
   - Create one file per extracted skill candidate.
   - Use the template in \`skills/_skill-template.md\`.
   - Keep each skill narrow enough that an agent can decide when to use it.

## Extraction Rules

- Do not summarize the whole book as one giant skill.
- Split extraction by the book's own structure first. If chapters or headings
  are visible, extract candidates chapter by chapter before writing the
  whole-book summary.
- After chapter-level extraction, synthesize the book-level capability summary
  and explain how the chapter skills fit together as one book-scoped package.
- Do not create skills from generic advice unless the book provides a specific
  procedure, checklist, decision rule, diagnostic, or reusable pattern.
- Do not claim the agent can do something unless the source supports it.
- Prefer triggerable skills: the "when to use" section must be concrete.
- Keep source evidence short. Use chapter/section/page markers when available.
- Mark uncertain candidates as \`draft\` and explain what is missing.
- If the book contains code, formulas, prompts, templates, or step-by-step
  methods, preserve them as references or compact procedures rather than prose.
- Separate "skills" from "reference material"; not every good idea should become
  an active skill.

## Per-Skill File Requirements

Each skill file must include:

- Skill name
- Source book
- What the agent can do with it
- When to use it
- Inputs needed
- Step-by-step procedure
- Output expected
- Evidence anchors from the book
- Limits and failure modes
- Promotion recommendation: \`keep-in-book-pack\`, \`promote-to-managed-skill\`, or \`reference-only\`
- Book structure path: chapter/section where this skill belongs

## Final Response To The User

After producing files, give a short Chinese report:

- 这本书能帮 Agent 做什么
- 什么时候应该参考这本书
- 提炼出了哪些技能类别
- 哪些技能建议进入 managed skills
- 哪些只适合作为书籍参考资料
EOF

cat > "$PACK_DIR/skills/README.md" <<EOF
# Skills Extracted From $TITLE

Put one extracted skill candidate per file in this directory.

Naming convention:

\`\`\`
skills/<short-skill-slug>.md
\`\`\`

Keep all skills classified under the source book first. If a skill is later
promoted into a global managed skill, copy or rewrite it intentionally instead
of blindly enabling every generated file.
EOF

cat > "$PACK_DIR/skills/_skill-template.md" <<EOF
# <Skill Name>

## Source Book

- Book: $TITLE
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

Add short source anchors from the book. Prefer chapter/section/page references.

## Limits And Failure Modes

- 

## Promotion Recommendation

Choose one:

- keep-in-book-pack
- promote-to-managed-skill
- reference-only
EOF

cat > "$PACK_DIR/MANAGE_SKILLS.md" <<EOF
# Manage Skills Guidance

This pack is book-scoped. Treat it as a review workspace before installing or
enabling any skill globally.

## Recommended Flow

1. Parse the uploaded book with MinerU.
2. Build this book skill pack.
3. Give \`LLM_EXTRACTION_PROMPT.md\` and \`source-markdown/\` to a large model.
4. Review \`BOOK_SKILL_INDEX.md\` and \`skills/*.md\`.
5. Promote only stable, generally useful skills into a managed skills repo.
6. Enable promoted skills with the local skills manager when appropriate.

## Boundary With skills-mgr

- Use skills-mgr to manage installed skills, not to blindly install every book output.
- A book pack may contain many draft skills; most should remain book-scoped until reviewed.
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

echo "Book skill pack created: $PACK_DIR"
echo "Next: give $PACK_DIR/LLM_EXTRACTION_PROMPT.md and $PACK_DIR/source-markdown/ to a model."
