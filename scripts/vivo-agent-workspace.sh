#!/usr/bin/env bash
# Create a Vivo workspace for Codex/Claude-style agents to capture sources,
# write notes, and distill skills from books, courses, web pages, videos, and PDFs.

set -euo pipefail

OUTPUT_ROOT="./vivo-workspaces"
TITLE=""
SLUG=""
AGENT_NAME="Codex or Claude"
SOURCE_TYPE="auto"
FORCE=false

usage() {
    cat <<EOF
Vivo Agent Workspace

Usage: vivo-agent-workspace.sh --title <title> [options]

Options:
  --title <title>    Workspace title. Required.
  --slug <slug>      Workspace slug. Defaults to a sanitized title.
  --agent <name>     Agent name. Default: "Codex or Claude".
  --type <type>      Source type hint: auto, book, course, paper, manual,
                    article-collection, project-notes, video, web, or mixed.
                    Default: auto.
  --output <dir>     Workspace root. Default: ./vivo-workspaces
  --force            Replace an existing workspace.
  -h, --help         Show this help.

Output:
  <output>/<slug>/
    AGENT_TASK.md
    SOURCES.md
    manifest.json
    notes/
    inbox/
    captured-markdown/
    packs/
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
    [[ -n "$value" ]] || value="vivo-workspace-$(date -u +%Y%m%d%H%M%S)"
    printf '%s' "$value"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --title) TITLE="${2:?Missing value for --title}"; shift 2 ;;
        --slug) SLUG="${2:?Missing value for --slug}"; shift 2 ;;
        --agent) AGENT_NAME="${2:?Missing value for --agent}"; shift 2 ;;
        --type|--source-type|--text-type) SOURCE_TYPE="${2:?Missing value for $1}"; shift 2 ;;
        --output) OUTPUT_ROOT="${2:?Missing value for --output}"; shift 2 ;;
        --force) FORCE=true; shift ;;
        -*) error "Unknown option: $1" ;;
        *) error "Unexpected positional argument: $1" ;;
    esac
done

[[ -n "$TITLE" ]] || error "--title is required"
case "$SOURCE_TYPE" in
    auto|book|course|paper|manual|article-collection|project-notes|video|audio|web|mixed) ;;
    *) error "Unsupported source type: $SOURCE_TYPE" ;;
esac
command -v jq >/dev/null 2>&1 || error "jq is required but not installed"

[[ -n "$SLUG" ]] || SLUG="$(slugify "$TITLE")"
WORKSPACE="$OUTPUT_ROOT/$SLUG"

if [[ -e "$WORKSPACE" ]]; then
    if [[ "$FORCE" == true ]]; then
        case "$WORKSPACE" in
            ""|"/"|"."|"..") error "Refusing to replace unsafe workspace path: $WORKSPACE" ;;
        esac
        rm -rf "$WORKSPACE"
    else
        error "Workspace already exists: $WORKSPACE (use --force to replace it)"
    fi
fi

mkdir -p \
    "$WORKSPACE/inbox/web" \
    "$WORKSPACE/inbox/video" \
    "$WORKSPACE/inbox/audio" \
    "$WORKSPACE/inbox/pdf" \
    "$WORKSPACE/inbox/course" \
    "$WORKSPACE/inbox/notes" \
    "$WORKSPACE/captured-markdown" \
    "$WORKSPACE/notes" \
    "$WORKSPACE/packs"

CREATED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

jq -n \
    --arg schema "vivo.agent-workspace.v1" \
    --arg title "$TITLE" \
    --arg slug "$SLUG" \
    --arg agent "$AGENT_NAME" \
    --arg source_type "$SOURCE_TYPE" \
    --arg created_at "$CREATED_AT" \
    '{
      schema: $schema,
      title: $title,
      slug: $slug,
      target_agent: $agent,
      source_type_hint: $source_type,
      created_at: $created_at,
      agent_executes_reasoning: true,
      model_called_by_this_script: false,
      source_type_confirmation_required: true,
      confirmed_source_type: null,
      note_template: null,
      capture_pipeline: "manual|mineru|opencli|existing-markdown",
      skill_discovery_policy: "repeat_until_no_new_supported_skills",
      skill_discovery_complete: false,
      directories: {
        inbox: "inbox/",
        captured_markdown: "captured-markdown/",
        notes: "notes/",
        packs: "packs/"
      }
    }' > "$WORKSPACE/manifest.json"

cat > "$WORKSPACE/SOURCES.md" <<EOF
# Sources - $TITLE

Add every source before or during capture. Keep local paths relative when possible.

| ID | Claimed type | Confirmed type | Type confidence | Note template | Title | URL or path | Capture method | Capture status | Notes |
|---|---|---|---|---|---|---|---|---|---|
| S1 | web / video / audio / pdf / course / note |  |  |  |  |  | manual / MinerU / opencli / browser / transcript / existing-markdown | pending |  |
EOF

cat > "$WORKSPACE/notes/source-type-confirmation.md" <<EOF
# Source Type Confirmation - $TITLE

Confirm the object type before writing notes or extracting skills.

| Field | Value |
|---|---|
| Detected type | book / paper / course / video / audio / web / manual / project-notes / mixed |
| Confidence | high / medium / low |
| Ambiguous between |  |
| Selected note template |  |
| Selected segmentation unit | chapter / section / lesson / timestamp segment / page / source |
| Capture needed | none / MinerU / opencli / browser / transcript / existing markdown |

## Evidence

-

## Next Agent Action

-
EOF

cat > "$WORKSPACE/notes/live-notes.md" <<EOF
# Live Notes - $TITLE

Use this while the agent is reading, watching, parsing, or comparing sources.
Write durable observations only: source identity, useful claims, candidate
skills, open questions, and verification notes.

## Running Notes

-

## Candidate Skills Seen During Capture

| Source | Candidate skill | Why it is operational | Confidence |
|---|---|---|---|
|  |  |  |  |
EOF

cat > "$WORKSPACE/notes/topic-classification.md" <<EOF
# Topic Classification - $TITLE

Classify captured material into skill packages. Use course topics, source
sections, or recurring workflows as the package boundary.

| Topic | Subtopic | Sources | Candidate skill package |
|---|---|---|---|
|  |  |  |  |
EOF

cat > "$WORKSPACE/notes/skill-discovery-coverage.md" <<EOF
# Skill Discovery Coverage - $TITLE

Repeat extraction passes until no new supported skills are found.

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

- [ ] Every chapter/lesson/section/timestamp segment checked.
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
EOF

cat > "$WORKSPACE/AGENT_TASK.md" <<EOF
# Vivo Agent Task - $TITLE

You are $AGENT_NAME operating a Vivo workspace. Vivo does not replace the
agent's reasoning. Vivo gives you a workspace, capture contract, notes, and a
skill-pack output shape.

## AgentTeams Roles

Use AgentTeams or equivalent parallel agents when available:

1. Type classifier: inspect the given text or source metadata and fill
   \`notes/source-type-confirmation.md\`.
2. Capture/normalization agent: convert online web/video/audio/PDF sources into
   Markdown when needed. Future online capture may use opencli; current agents
   should use their available browser, transcript, fetch, or MinerU tools.
3. Typed note writer: write the matching note shape, such as paper reading
   notes, book chapter notes, course lesson notes, video/audio transcript notes,
   web article notes, or manual/spec notes.
4. Skill discovery agent: extract candidate skills while notes are being built.
5. Coverage reviewer: repeat extraction passes until no new supported
   operational skills are found; update \`notes/skill-discovery-coverage.md\`.

## Required First Step

Do not start the skill pack first. First inspect the provided text/source and
confirm its type:

- book
- paper
- course
- video transcript
- audio transcript
- web article
- manual/spec
- project notes
- mixed source set

Fill \`notes/source-type-confirmation.md\`, update \`SOURCES.md\`, and select the
right note template before writing detailed notes.

## Principle

Use the tools available to the current agent runtime. For example:

- Web pages: use the agent's browser, web search, fetch, or OpenAI-backed web
  capability when available. Save clean Markdown in \`captured-markdown/\`.
- Videos: fetch or download subtitles/transcripts with available video tools.
  Save transcript Markdown in \`captured-markdown/\`.
- Audio: fetch or transcribe audio when tools are available. Save transcript
  Markdown in \`captured-markdown/\`.
- PDFs: use MinerU parsing when needed, then save or link converted Markdown.
- Courses: preserve lessons/modules/projects as structure and classify topics.
- Notes: write running notes in \`notes/live-notes.md\` while capture is happening.

Do not store API keys, cookies, auth headers, raw secrets, or private account
tokens in this workspace.

## Capture Contract

For every captured source, create one Markdown file:

\`\`\`text
captured-markdown/<source-id>-<short-title>.md
\`\`\`

Each captured Markdown file should include:

- source type
- title
- URL or original path
- capture method
- source anchors or citation notes
- content outline
- key concepts
- operational procedures, workflows, checklists, diagnostics, decision rules,
  prompt patterns, or implementation patterns
- candidate skill ideas grouped by topic

## Typed Notes

Use the confirmed source type to write the right note form:

| Type | Notes to write | Segment unit | Skill focus |
|---|---|---|---|
| book | book chapter notes | chapter/section | frameworks, workflows, checklists, decision rules |
| paper | paper reading notes | abstract/method/experiment/limitation | methods, evaluations, failure modes |
| course | course lesson notes | module/lesson/exercise | learning workflows, projects, rubrics |
| video | video transcript notes | timestamp/topic segment | demos, operation order, practical heuristics |
| audio | audio transcript notes | speaker/topic segment | decision context, rules, action items |
| web | web article notes | heading/topic section | web workflows, tool usage, reference links |
| manual | manual/spec notes | concept/how-to/reference/error | exact commands, APIs, troubleshooting |
| project-notes | project notes | date/topic/task | runbooks, conventions, rollback paths |
| mixed | mixed source notes | source first, then topic | cross-source stable patterns |

## Simultaneous Notes

While capturing, keep \`notes/live-notes.md\` open conceptually and update it
alongside source capture. The notes are for durable observations and candidate
skill decisions, not scratch logs.

## Mindmap And Skill Pack

Only after type confirmation and typed notes are written, run this from the
mineru-skill repo:

\`\`\`bash
./scripts/book-skill-pack.sh "$WORKSPACE/captured-markdown" \\
  --title "$TITLE" \\
  --type "$SOURCE_TYPE" \\
  --agent "$AGENT_NAME" \\
  --output "$WORKSPACE/packs" \\
  --force
\`\`\`

Then fill the generated pack in this order:

1. \`chapter-skills/*/CHAPTER_SKILL_INDEX.md\`
2. \`chapter-skills/*/skills/*.md\`
3. \`whole-book/WHOLE_BOOK_SUMMARY.md\`
4. \`MINDMAP.md\`
5. \`BOOK_SKILL_INDEX.md\`
6. \`SKILL_DISCOVERY_COVERAGE.md\`
7. root \`skills/*.md\` only for reviewed cross-source candidates

Repeat discovery passes until a full pass over every source unit produces no
new supported operational skills. Reading all text once is not sufficient.

## Final Report

Return a short Chinese report:

- Vivo captured which source types
- What new knowledge was distilled
- Which topics became candidate skill packages
- Which skills should be promoted into managed skills
- Which material should remain source-pack reference only
EOF

touch \
    "$WORKSPACE/inbox/web/.gitkeep" \
    "$WORKSPACE/inbox/video/.gitkeep" \
    "$WORKSPACE/inbox/audio/.gitkeep" \
    "$WORKSPACE/inbox/pdf/.gitkeep" \
    "$WORKSPACE/inbox/course/.gitkeep" \
    "$WORKSPACE/inbox/notes/.gitkeep" \
    "$WORKSPACE/captured-markdown/.gitkeep" \
    "$WORKSPACE/packs/.gitkeep"

echo "Vivo agent workspace created: $WORKSPACE"
echo "Next: give $WORKSPACE/AGENT_TASK.md to Codex or Claude and add sources to $WORKSPACE/SOURCES.md"
