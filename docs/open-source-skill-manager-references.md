# Open Source Skill Manager References

This project is not a general skill manager. MinerU parses documents and stages
long-form sources so a model can extract candidate skills. The projects below
are useful references for the separate managed-skill lifecycle: install, sync,
project selection, cross-agent projection, validation, and review.

## Reference Layers

| Layer | References | What MinerU Should Borrow |
|---|---|---|
| Skill format standard | agentskills.io, openai/skills | `SKILL.md` directory contract, progressive disclosure, scripts/references/assets layout |
| Cross-agent management | mode-io/skill-manager, jtianling/skills-manager, omrikais/skill-manager, Naoray/scribe, weiox/skm | canonical store, symlink/copy projection, profiles, doctor/repair, lockfiles, conflict handling |
| Review and selection | zunalabs/skills-manager, sam-blakeman/quiver, shaungehring/skilllink | GUI review, import/export, project-relevant selection, cross-agent copy workflows |

## Projects

| Project | URL | Supported Agents Or Scope | Useful Mechanisms | Why It Does Not Replace mineru-skill |
|---|---|---|---|---|
| Agent Skills | https://agentskills.io/ | Any client implementing the Agent Skills format | Defines a skill directory with `SKILL.md`; supports `scripts/`, `references/`, and `assets/`; encourages progressive disclosure so runtimes read only name/description until a skill is triggered. | It is a format/specification, not a document parser or long-form skill extraction workflow. |
| OpenAI Skills | https://github.com/openai/skills | Codex | Official Codex skill catalog and installer reference; useful for Codex-compatible packaging expectations. | It is a catalog and distribution reference, not a private cross-agent manager or MinerU workflow. |
| mode-io/skill-manager | https://github.com/mode-io/skill-manager | Codex CLI, Claude Code, Cursor, OpenCode, OpenClaw | Local-first inventory for skills, MCP servers, and slash commands; shared store projected into agent-specific directories; normalized MCP config rendering; hash/sync-state handling. | It manages extensions after they exist; it does not parse documents, segment books, or extract candidate skills. |
| zunalabs/skills-manager | https://github.com/zunalabs/skills-manager | Claude Code, Cursor, Gemini CLI, Antigravity, Windsurf, GitHub Copilot, Goose, Codex, OpenCode, Kilo Code, Trae | Electron desktop app; browse, enable/disable, delete, install from GitHub, and copy skills between agents. | It is a cross-agent skill management UI, not a source-to-skill extraction system. |
| jtianling/skills-manager | https://github.com/jtianling/skills-manager | README claims broad multi-tool support through `.agents/skills/` bridges | Central install library, project-level `.agents/skills/`, registry search/publish, GitHub/local/zip installs, dependency resolution, group deployment, symlink/copy modes. | Useful for publishing/promoting reviewed skills, but it does not provide MinerU parsing or human-review staging. |
| omrikais/skill-manager | https://github.com/omrikais/skill-manager | Claude Code, Codex CLI | Canonical store, symlink deployment, TUI, project manifests, profiles, doctor/repair, backups, append-only history, dependency-aware deployment, triggers-based recommendations, MCP server exposure. | It is a lifecycle manager; MinerU still needs its own parsing, segmentation, and extraction contracts. |
| Naoray/scribe | https://github.com/Naoray/scribe | Claude Code, Cursor, Codex, Gemini, extensible tools | Store-as-truth design, project loadouts, lockfile, project-scoped sync into `.claude/skills`, `.agents/skills`, `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, and Cursor rules; JSON envelope CLI; Codex description-budget checks. | Strong reference for reproducible projections, but it does not produce skills from documents. |
| weiox/skm | https://github.com/weiox/skm | Codex, Claude Code | `~/.skm` source of truth, `personal/` and `vendor/` layers, shared exports, doctor states (`OK`, `BROKEN`, `UNMANAGED`, `CONFLICT`), vendor update, extract/release skill pack flow. | It aligns with reviewed promotion boundaries, but it does not parse or distill long-form sources. |
| sam-blakeman/quiver | https://github.com/sam-blakeman/quiver | Claude Code; Claude Desktop can browse or manually upload | Local web UI and CLI; scans `~/.claude/skills/`; search/details/path display; drag-and-drop import; symlink/copy add; zip import/export; Git-backed sync. | It is mainly a Claude-side review and management UI, not a MinerU parser or cross-agent standard layer. |
| shaungehring/skilllink | https://github.com/shaungehring/skilllink | Claude Code | Master library, catalog metadata, `/skill-this-project` recommendation workflow, `always_include`, dry-run/list/status/link/unlink, project symlinks for relevant skills/agents/plugins. | Useful for project-relevant activation, but it does not extract skills from books/courses/papers. |

## Design Implications For MinerU

MinerU should keep a strict boundary:

1. Parse a source and produce clean Markdown.
2. Classify the source type.
3. Segment by native structure.
4. Stage segment-first skill extraction.
5. Synthesize the whole-source capability summary after segment extraction.
6. Produce reviewed candidate files for a separate skill manager to promote.

The skill manager layer can later import root `skills/*.md` from a pack, but it
should not blindly enable every segment draft under `chapter-skills/*/skills/`.

### Opt-in exception (added)

The default boundary above still holds for the pipeline. An **opt-in** layer
now ships in-repo for users who explicitly want installation, instead of an
external-only manager:

- `scripts/skill-install.sh` — installs a reviewed pack into the agents the
  user explicitly selects (the agent asks; the script never chooses). It
  records the deliberate boundary crossing in the pack manifest
  (`red_line_note`, `installed_to`).
- `scripts/skill-manage.sh` — `status` / `list` / `sync` / `uninstall` /
  `gate` across agents; per-pack only, never touching an agent's own skills.
- `scripts/lib/agent-targets.sh` — the verified per-agent topology
  (copy vs symlink, drift backup, app-managed caveats).

This is invoked only via `grimoire.sh --install` or a direct call — never
from the default pipeline, which remains candidate-only.
