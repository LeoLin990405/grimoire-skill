# Vivo Agent Workflow

Vivo is an agent-operated knowledge-to-skill workflow. It is not a closed
service that performs all reasoning by itself. Codex, Claude Code, or another
capable agent performs source type confirmation, typed note writing, online
capture when needed, topic classification, mindmap synthesis, and repeated skill
discovery inside a reproducible workspace.

## What Vivo Provides

- A workspace contract for sources, notes, captured Markdown, and generated packs.
- A required source-type confirmation step before notes or skill packs.
- Type-specific note templates for books, papers, courses, transcripts, web
  articles, manuals/specs, project notes, and mixed source sets.
- A capture contract for web pages, videos, PDFs, courses, books, and notes.
- A long-form skill-pack structure with segment-first extraction.
- A mindmap template that maps source topics into skill families.
- A manage-skills boundary: generated skills are candidates until reviewed.

## Step 0: Source Type Confirmation

The first agent action is to inspect the provided text or source metadata and
fill `notes/source-type-confirmation.md`. Do not start skill extraction until
the source type and note template are selected.

| Type | Recognition signals | Note template | Segment unit | Skill discovery focus |
|---|---|---|---|---|
| book | ISBN, publisher, table of contents, chapters | book chapter notes | chapter/section | frameworks, workflows, checklists, decision rules |
| paper | abstract, authors, DOI/arXiv, methods, experiments | paper reading notes | abstract/method/results/limitations | methods, evaluations, failure modes |
| course | modules, lessons, exercises, projects | course lesson notes | module/lesson/exercise | learning workflows, projects, rubrics |
| video | timestamps, video URL, visual demo context | video transcript notes | timestamp/topic segment | demos, operation order, practical heuristics |
| audio | speakers, podcast/interview/meeting transcript | audio transcript notes | speaker/topic segment | decision context, rules, action items |
| web | URL, author/date, article headings | web article notes | heading/topic section | web workflows, tool usage, reference links |
| manual/spec | official docs, versions, APIs, parameters | manual/spec notes | concept/how-to/reference/error | exact commands, APIs, troubleshooting |
| project-notes | logs, paths, commands, issues, PRs, TODOs | project notes | date/topic/task | runbooks, conventions, rollback paths |
| mixed | multiple source types joined together | mixed source notes | source first, then topic | cross-source stable patterns |

## What The Agent Does

The agent uses whatever tools are available in its runtime:

| Source type | Agent action | Vivo output |
|---|---|---|
| Web page | Use browser, fetch, web search, or future opencli web capture; preserve URLs and citation notes. | `captured-markdown/<source>.md` |
| Video | Fetch subtitles or transcript with available video/opencli tools; summarize with timestamps when possible. | `captured-markdown/<video>.md` |
| Audio | Fetch or transcribe audio with available audio/opencli tools; preserve speakers and timestamps when possible. | `captured-markdown/<audio>.md` |
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
  audio/
  pdf/
  course/
  notes/
captured-markdown/
packs/
```

## Typed Notes And Skill Distillation Order

After source type confirmation and typed notes are written, the agent captures
or normalizes source text into `captured-markdown/`, then runs:

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
5. `SKILL_DISCOVERY_COVERAGE.md`
6. `BOOK_SKILL_INDEX.md`
7. root `skills/*.md` only for reviewed cross-source candidates

## Notes Rule

The agent writes notes while capturing sources. Use `notes/live-notes.md` for
durable observations, candidate skills, open questions, and verification notes.
Do not dump raw logs, credentials, cookies, or full copyrighted excerpts.

## Discovery Stop Condition

Do not stop because the source was read once. Stop only when a full pass over
every source unit finds no new supported operational skills. Record each pass in
`notes/skill-discovery-coverage.md` and the generated pack's
`SKILL_DISCOVERY_COVERAGE.md`.

## Managed Skills Boundary

Vivo creates candidates. A separate skill manager or human review promotes only
stable skills into Codex, Claude Code, Trae, or a shared registry.
