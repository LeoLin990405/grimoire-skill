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
    auto|book|course|paper|manual|article-collection|project-notes|video|web|mixed) ;;
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

| ID | Type | Title | URL or path | Capture status | Notes |
|---|---|---|---|---|---|
| S1 | web / video / pdf / course / note |  |  | pending |  |
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

cat > "$WORKSPACE/AGENT_TASK.md" <<EOF
# Vivo Agent Task - $TITLE

You are $AGENT_NAME operating a Vivo workspace. Vivo does not replace the
agent's reasoning. Vivo gives you a workspace, capture contract, notes, and a
skill-pack output shape.

## Principle

Use the tools available to the current agent runtime. For example:

- Web pages: use the agent's browser, web search, fetch, or OpenAI-backed web
  capability when available. Save clean Markdown in \`captured-markdown/\`.
- Videos: fetch or download subtitles/transcripts with available video tools.
  Save transcript Markdown in \`captured-markdown/\`.
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

## Simultaneous Notes

While capturing, keep \`notes/live-notes.md\` open conceptually and update it
alongside source capture. The notes are for durable observations and candidate
skill decisions, not scratch logs.

## Mindmap And Skill Pack

After capture, run this from the mineru-skill repo:

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
6. root \`skills/*.md\` only for reviewed cross-source candidates

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
    "$WORKSPACE/inbox/pdf/.gitkeep" \
    "$WORKSPACE/inbox/course/.gitkeep" \
    "$WORKSPACE/inbox/notes/.gitkeep" \
    "$WORKSPACE/captured-markdown/.gitkeep" \
    "$WORKSPACE/packs/.gitkeep"

echo "Vivo agent workspace created: $WORKSPACE"
echo "Next: give $WORKSPACE/AGENT_TASK.md to Codex or Claude and add sources to $WORKSPACE/SOURCES.md"
