# Vivo Agent Workflow

Vivo is an agent-operated knowledge-to-skill workflow. It is not a closed
service that performs all reasoning by itself. Codex, Claude Code, or another
capable agent performs source capture, note writing, topic classification,
mindmap synthesis, and skill drafting inside a reproducible workspace.

## What Vivo Provides

- A workspace contract for sources, notes, captured Markdown, and generated packs.
- A capture contract for web pages, videos, PDFs, courses, books, and notes.
- A long-form skill-pack structure with segment-first extraction.
- A mindmap template that maps source topics into skill families.
- A manage-skills boundary: generated skills are candidates until reviewed.

## What The Agent Does

The agent uses whatever tools are available in its runtime:

| Source type | Agent action | Vivo output |
|---|---|---|
| Web page | Use browser, fetch, web search, or OpenAI-backed web capability; preserve URLs and citation notes. | `captured-markdown/<source>.md` |
| Video | Fetch subtitles or transcript with available video tools; summarize with timestamps when possible. | `captured-markdown/<video>.md` |
| PDF | Parse with MinerU or a local converter; preserve headings, page markers, tables, and formulas when useful. | `captured-markdown/<pdf>.md` or a nested MinerU pack |
| Course | Preserve modules, lessons, exercises, and projects; classify topics. | `notes/topic-classification.md` and captured lesson Markdown |
| Existing notes | Normalize into source-scoped Markdown and keep evidence anchors. | `captured-markdown/<note>.md` |

## Workspace

Create a workspace:

```bash
./scripts/vivo-agent-workspace.sh \
  --title "Course Or Knowledge Source" \
  --type mixed \
  --agent "Codex" \
  --output ./vivo-workspaces
```

The workspace contains:

```text
AGENT_TASK.md
SOURCES.md
manifest.json
notes/
  live-notes.md
  topic-classification.md
inbox/
  web/
  video/
  pdf/
  course/
  notes/
captured-markdown/
packs/
```

## Skill Distillation Order

After the agent captures sources into `captured-markdown/`, it runs:

```bash
./scripts/book-skill-pack.sh <workspace>/captured-markdown \
  --title "Course Or Knowledge Source" \
  --type mixed \
  --agent "Codex" \
  --output <workspace>/packs \
  --force
```

The agent then fills generated files in this order:

1. `chapter-skills/*/CHAPTER_SKILL_INDEX.md`
2. `chapter-skills/*/skills/*.md`
3. `whole-book/WHOLE_BOOK_SUMMARY.md`
4. `MINDMAP.md`
5. `BOOK_SKILL_INDEX.md`
6. root `skills/*.md` only for reviewed cross-source candidates

## Notes Rule

The agent writes notes while capturing sources. Use `notes/live-notes.md` for
durable observations, candidate skills, open questions, and verification notes.
Do not dump raw logs, credentials, cookies, or full copyrighted excerpts.

## Managed Skills Boundary

Vivo creates candidates. A separate skill manager or human review promotes only
stable skills into Codex, Claude Code, Trae, or a shared registry.
