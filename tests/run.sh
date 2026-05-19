#!/usr/bin/env bash
# Grimoire test suite — zero-dependency, offline.
#
# Runs the whole pipeline without the MinerU cloud (everything uses
# --from-markdown / the packers directly on synthetic Markdown), so it needs
# no token and never touches the network or the real Obsidian vault.
#
# Usage: tests/run.sh            # run all
#        tests/run.sh -v         # show every assertion
#
# Requires: bash 3.2+, jq (already a runtime dependency of the scripts).

set -u

VERBOSE=false
[[ "${1:-}" == "-v" ]] && VERBOSE=true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS="$SCRIPT_DIR/scripts"

TESTROOT="$(mktemp -d "${TMPDIR:-/tmp}/grimoire-tests.XXXXXX")"
# Keep all generated notes away from the real vault.
export MINERU_OBSIDIAN_VAULT="$TESTROOT/vault"
mkdir -p "$MINERU_OBSIDIAN_VAULT"
cleanup() { rm -rf "$TESTROOT"; }
trap cleanup EXIT

PASS=0
FAIL=0
CURRENT=""

start()  { CURRENT="$1"; }
ok()     { PASS=$((PASS + 1)); $VERBOSE && echo "  ok   - $1"; }
bad()    { FAIL=$((FAIL + 1)); echo "  FAIL - [$CURRENT] $1"; }

# assert_contains <file> <substring> <msg>
assert_contains() {
    if grep -qF -- "$2" "$1" 2>/dev/null; then ok "$3"; else
        bad "$3 (expected to find: $2 in $1)"; fi
}
# assert_not_contains <file> <substring> <msg>
assert_not_contains() {
    if grep -qF -- "$2" "$1" 2>/dev/null; then
        bad "$3 (did NOT expect: $2 in $1)"; else ok "$3"; fi
}
# assert_eq <actual> <expected> <msg>
assert_eq() {
    if [[ "$1" == "$2" ]]; then ok "$3"; else
        bad "$3 (expected '$2', got '$1')"; fi
}
# assert_file <path> <msg>
assert_file() {
    if [[ -f "$1" ]]; then ok "$2"; else bad "$2 (missing file: $1)"; fi
}
# assert_status <expected_nonzero|zero> <msg> -- <cmd...>
assert_fail() {
    local msg="$1"; shift
    if "$@" >/dev/null 2>&1; then bad "$msg (command unexpectedly succeeded)";
    else ok "$msg"; fi
}

mkmd() { # mkmd <path>
    cat > "$1" <<'MD'
# 第1章 引论

深度工作是无干扰状态下的专注能力。

## 1.1 背景

知识经济要求高质量产出。

# 第2章 方法

## 2.1 时间块

将一天划分为若干专注块。

# 第3章 实践

给出一套可执行清单。
MD
}

# ---------------------------------------------------------------------------
start "classifier buckets"
# shellcheck source=/dev/null
source "$SCRIPTS/lib/common.sh"
# shellcheck source=/dev/null
source "$SCRIPTS/lib/reading-types.sh"

book_tsv="$(classify_reading_type auto "deep work" $'# Chapter 1\n第1章\n第2章\n第3章\nTable of Contents\nISBN 978-0' 320)"
assert_eq "$(printf '%s' "$book_tsv" | cut -f1)" "book" "book heuristic → book"

paper_tsv="$(classify_reading_type auto "attention is all you need" $'Abstract\nWe propose...\narXiv:1706.03762\nReferences\nRelated Work\ndoi:10.1/x' 11)"
assert_eq "$(printf '%s' "$paper_tsv" | cut -f1)" "paper" "paper heuristic → paper"

doc_tsv="$(classify_reading_type auto "api reference" $'# Installation\nRun npm install.\n## Configuration\nSet the API key.' 4)"
assert_eq "$(printf '%s' "$doc_tsv" | cut -f1)" "document" "doc heuristic → document"

# ---------------------------------------------------------------------------
start "reading-notes vault-slug decoupling"
md="$TESTROOT/src.md"; mkmd "$md"
out="$TESTROOT/rnp"
"$SCRIPTS/reading-notes-pack.sh" "$md" --title "Deep Work" --type book \
    --slug notes --vault-slug deep-work --output "$out" --force >/dev/null 2>&1
man="$out/notes/manifest.json"
assert_file "$man" "notes pack manifest written"
assert_eq "$(jq -r .slug "$man")" "notes" "slug stays workspace slug"
assert_eq "$(jq -r .vault_slug "$man")" "deep-work" "vault_slug is per-source"
assert_eq "$(jq -r .note_file "$man")" "notes/deep-work.md" "note_file mirrors vault slug"
case "$(jq -r .vault_target "$man")" in
    *"/Books/deep-work.md") ok "vault target = Books/deep-work.md" ;;
    *) bad "vault target wrong: $(jq -r .vault_target "$man")" ;;
esac
# second source, different vault-slug → different target (no collision)
"$SCRIPTS/reading-notes-pack.sh" "$md" --title "Clean Code" --type book \
    --slug notes --vault-slug clean-code --output "$TESTROOT/rnp2" --force >/dev/null 2>&1
t1="$(jq -r .vault_target "$man")"
t2="$(jq -r .vault_target "$TESTROOT/rnp2/notes/manifest.json")"
if [[ "$t1" != "$t2" ]]; then ok "distinct sources → distinct vault files"; else
    bad "vault collision: both → $t1"; fi

start "reading-notes standalone compat"
"$SCRIPTS/reading-notes-pack.sh" "$md" --title "Pragmatic Programmer" --type book \
    --output "$TESTROOT/rnp3" --force >/dev/null 2>&1
sm="$TESTROOT/rnp3/pragmatic-programmer/manifest.json"
assert_eq "$(jq -r .slug "$sm")" "$(jq -r .vault_slug "$sm")" "standalone: slug == vault_slug"

# ---------------------------------------------------------------------------
start "source-skill-pack substrate modes"
"$SCRIPTS/source-skill-pack.sh" "$md" --title T --output "$TESTROOT/ssp_src" --force >/dev/null 2>&1
p="$TESTROOT/ssp_src/t/LLM_EXTRACTION_PROMPT.md"
assert_contains "$p" "Source Markdown directory:" "default prompt = source substrate"
assert_eq "$(jq -r .skill_substrate "$TESTROOT/ssp_src/t/manifest.json")" "source" "manifest skill_substrate=source"

note="$TESTROOT/mynote.md"; printf '# Notes\n\nDistilled knowledge points.\n' > "$note"
"$SCRIPTS/source-skill-pack.sh" "$md" --title T --notes-source "$note" \
    --output "$TESTROOT/ssp_notes" --force >/dev/null 2>&1
pn="$TESTROOT/ssp_notes/t/LLM_EXTRACTION_PROMPT.md"
assert_contains "$pn" "Primary substrate: your **reading notes**" "notes prompt = notes substrate"
assert_contains "$pn" "重复学习" "notes prompt mentions re-learning"
mn="$TESTROOT/ssp_notes/t/manifest.json"
assert_eq "$(jq -r .skill_substrate "$mn")" "notes" "manifest skill_substrate=notes"
assert_eq "$(jq -r .notes_source "$mn")" "$note" "manifest records notes_source"

# ---------------------------------------------------------------------------
start "grimoire --only both (two-stage notes→skills)"
g="$TESTROOT/g_both"
"$SCRIPTS/grimoire.sh" --md "$md" --title "Deep Work" --type book \
    --only both --output "$g" --force >/dev/null 2>&1
W="$g/grimoires/deep-work"
task="$W/GRIMOIRE_TASK.md"
assert_file "$task" "GRIMOIRE_TASK.md written"
assert_contains "$task" "two-stage" "contract is two-stage"
assert_contains "$task" "Stage 1" "contract has Stage 1"
assert_contains "$task" "Stage 2" "contract has Stage 2"
assert_contains "$task" "重复学习" "contract names the re-learning pass"
assert_contains "$task" "NOT" "Stage 2 says NOT the raw source"
assert_eq "$(jq -r .skill_substrate "$W/skills/manifest.json")" "notes" "skills mined from notes"
assert_file "$W/notes/notes/deep-work.md" "note scaffold has meaningful name"

start "grimoire --only notes (one stage)"
gn="$TESTROOT/g_notes"
"$SCRIPTS/grimoire.sh" --md "$md" --title "Deep Work" --type book \
    --only notes --output "$gn" --force >/dev/null 2>&1
tn="$gn/grimoires/deep-work/GRIMOIRE_TASK.md"
assert_contains "$tn" "notes only" "notes-only contract"
assert_not_contains "$tn" "Stage 2" "notes-only has no Stage 2"

start "grimoire --only skills (source substrate, back-compat)"
gs="$TESTROOT/g_skills"
"$SCRIPTS/grimoire.sh" --md "$md" --title "Deep Work" --type book \
    --only skills --output "$gs" --force >/dev/null 2>&1
ts="$gs/grimoires/deep-work/GRIMOIRE_TASK.md"
assert_contains "$ts" "skills only" "skills-only contract"
assert_eq "$(jq -r .skill_substrate "$gs/grimoires/deep-work/skills/manifest.json")" \
    "source" "skills-only mines from source"

start "grimoire error paths"
assert_fail "no input is rejected" "$SCRIPTS/grimoire.sh" --only notes
assert_fail "bad --from-markdown is rejected" \
    "$SCRIPTS/grimoire.sh" --from-markdown "$TESTROOT/nope.md"

# ---------------------------------------------------------------------------
start "grimoire --from-text (raw text → skill, no MinerU)"
txt="$TESTROOT/raw.txt"
printf 'Deep work is focus without distraction.\nIt produces high-value output.\n' > "$txt"
gt="$TESTROOT/g_text"
GRIMOIRE_PARSER=/bin/false "$SCRIPTS/grimoire.sh" --from-text "$txt" \
    --only skills --output "$gt" --force >/dev/null 2>&1
WT="$gt/grimoires/raw"
assert_file "$WT/GRIMOIRE_TASK.md" "--from-text produced a workspace"
assert_eq "$(jq -r .title "$WT/GRIMOIRE.md.json")" "raw" "title defaults from text filename"
assert_eq "$(jq -r .skill_substrate "$WT/skills/manifest.json")" "source" "text→skill uses source substrate"
printf 'piped body\n' | GRIMOIRE_PARSER=/bin/false "$SCRIPTS/grimoire.sh" \
    --from-text - --title "Piped" --only skills --output "$TESTROOT/g_stdin" --force >/dev/null 2>&1
assert_file "$TESTROOT/g_stdin/grimoires/piped/GRIMOIRE_TASK.md" "--from-text - reads stdin"
assert_fail "--from-text + --from-markdown mutually exclusive" \
    "$SCRIPTS/grimoire.sh" --from-text "$txt" --from-markdown "$txt"

start "grimoire --install adds the opt-in Stage 3"
gi="$TESTROOT/g_install"
GRIMOIRE_PARSER=/bin/false "$SCRIPTS/grimoire.sh" --from-text "$txt" \
    --only skills --install --output "$gi" --force >/dev/null 2>&1
ti="$gi/grimoires/raw/GRIMOIRE_TASK.md"
assert_contains "$ti" "Stage 3 — Install across agents" "--install adds Stage 3"
assert_contains "$ti" "skill-install.sh" "Stage 3 references skill-install.sh"
assert_contains "$ti" "AskUserQuestion" "Stage 3 tells the agent to ask the user"
gin="$TESTROOT/g_noinstall"
GRIMOIRE_PARSER=/bin/false "$SCRIPTS/grimoire.sh" --md "$md" --title "Deep Work" \
    --type book --only notes --install --output "$gin" --force >/dev/null 2>&1
assert_not_contains "$gin/grimoires/deep-work/GRIMOIRE_TASK.md" "Stage 3" \
    "--install is a no-op with --only notes"

# ---------------------------------------------------------------------------
start "skill-install: list / dry-run write nothing"
SBX="$TESTROOT/sbx"; mkdir -p "$SBX/.claude/skills" "$SBX/.codex/skills" \
    "$SBX/.agents/skills" "$SBX/.config/opencode/skills"
mkdir -p "$SBX/.codex/skills/ppt-master"; echo keep > "$SBX/.codex/skills/ppt-master/x"
PKG="$TESTROOT/pkg"; mkdir -p "$PKG/skills/skills/demo-skill"
printf -- '---\nname: demo-skill\ndescription: d\n---\n# D\n' > "$PKG/skills/skills/demo-skill/SKILL.md"
printf '{"schema":"grimoire.workspace.v1","installs_skills":false}\n' > "$PKG/GRIMOIRE.md.json"
HOME="$SBX" "$SCRIPTS/skill-install.sh" --pack "$PKG" --list > "$TESTROOT/list.out" 2>&1
assert_contains "$TESTROOT/list.out" "demo-skill" "list shows the unit"
assert_contains "$TESTROOT/list.out" "codex     | yes" "list shows present agents"
HOME="$SBX" "$SCRIPTS/skill-install.sh" --pack "$PKG" --agents claude,codex --dry-run >/dev/null 2>&1
if [[ ! -e "$SBX/.claude/skills/demo-skill" ]]; then ok "dry-run wrote nothing"; else
    bad "dry-run created files"; fi

start "skill-install: real install + manifest + idempotent + preservation"
HOME="$SBX" "$SCRIPTS/skill-install.sh" --pack "$PKG" --agents claude,codex,opencode >/dev/null 2>&1
assert_file "$SBX/.claude/skills/demo-skill/SKILL.md" "claude copy installed"
if [[ -L "$SBX/.codex/skills/demo-skill" ]]; then ok "codex is a symlink"; else
    bad "codex should be a symlink"; fi
if [[ -L "$SBX/.config/opencode/skills/demo-skill" ]]; then ok "opencode symlinks to hub"; else
    bad "opencode should symlink to hub"; fi
assert_file "$SBX/.codex/skills/ppt-master/x" "agent-only ppt-master preserved"
assert_contains "$PKG/GRIMOIRE.md.json" "red_line_note" "manifest records red_line_note"
assert_eq "$(jq -r .installs_skills "$PKG/GRIMOIRE.md.json")" "true" "manifest installs_skills=true"
HOME="$SBX" "$SCRIPTS/skill-install.sh" --pack "$PKG" --agents claude,codex,opencode \
    > "$TESTROOT/idem.out" 2>&1
assert_contains "$TESTROOT/idem.out" "already-ok" "second run is idempotent"

start "skill-manage: status/list/uninstall/gate, never touches settings.json"
printf '# CLAUDE\n' > "$SBX/.claude/CLAUDE.md"
HOME="$SBX" "$SCRIPTS/skill-manage.sh" status --name demo-skill > "$TESTROOT/st.out" 2>&1
assert_contains "$TESTROOT/st.out" "symlink" "status shows codex symlink"
HOME="$SBX" "$SCRIPTS/skill-manage.sh" list > "$TESTROOT/ls.out" 2>&1
assert_contains "$TESTROOT/ls.out" "ppt-master" "list flags agent-only ppt-master"
HOME="$SBX" "$SCRIPTS/skill-manage.sh" gate >/dev/null 2>&1
assert_file "$SBX/.claude/skills/.preflight/PREFLIGHT.md" "gate wrote PREFLIGHT.md"
assert_contains "$SBX/.claude/CLAUDE.md" "BEGIN: skill-preflight-gate" "gate injected paragraph"
if [[ ! -e "$SBX/.claude/settings.json" ]]; then ok "gate never created settings.json"; else
    bad "gate touched settings.json"; fi
HOME="$SBX" "$SCRIPTS/skill-manage.sh" gate > "$TESTROOT/gate2.out" 2>&1
assert_contains "$TESTROOT/gate2.out" "already has gate" "gate is idempotent"
HOME="$SBX" "$SCRIPTS/skill-manage.sh" uninstall --name demo-skill --agents codex >/dev/null 2>&1
if [[ ! -e "$SBX/.codex/skills/demo-skill" ]]; then ok "uninstall removed the codex entry"; else
    bad "uninstall failed"; fi
assert_file "$SBX/.codex/skills/ppt-master/x" "uninstall preserved agent-only ppt-master"

start "skill-manage scan: machine inventory + headline count"
HOME="$SBX" "$SCRIPTS/skill-manage.sh" scan > "$TESTROOT/scan.out" 2>&1
assert_contains "$TESTROOT/scan.out" "Skill-capable agents on this machine" "scan has a header"
assert_contains "$TESTROOT/scan.out" "claude" "scan lists registry agents"
assert_contains "$TESTROOT/scan.out" "Skill-capable agents present on this machine:" "scan prints headline count"
# SBX has 4 present agents (claude/codex/agents-hub/opencode)
cnt="$(grep -oE 'present on this machine: [0-9]+' "$TESTROOT/scan.out" | grep -oE '[0-9]+')"
if [[ "${cnt:-0}" -ge 1 ]]; then ok "scan counts present agents ($cnt)"; else
    bad "scan headline count not a positive number (got '${cnt:-}')"; fi
if [[ ! -e "$SBX/.claude/settings.json" ]]; then ok "scan is read-only (no settings.json)"; else
    bad "scan wrote settings.json"; fi
if HOME="$SBX" "$SCRIPTS/skill-manage.sh" -h >/dev/null 2>&1; then
    ok "skill-manage -h works (awk usage)"; else bad "skill-manage -h failed"; fi

# ---------------------------------------------------------------------------
start "bundled source skills present + sanitized"
for s in mineru-local mineru kedou-media-workflow youtube-clipper; do
    assert_file "$SCRIPT_DIR/skills/$s/SKILL.md" "skills/$s bundled"
    if head -8 "$SCRIPT_DIR/skills/$s/SKILL.md" 2>/dev/null | grep -q '^name:'; then
        ok "skills/$s SKILL.md has a name: frontmatter"
    else bad "skills/$s SKILL.md missing name: frontmatter"; fi
done
# secret/endpoint-leak regression guard (the whole point of the import)
if grep -rIq '100\.124\.57\.48' "$SCRIPT_DIR/skills/" 2>/dev/null; then
    bad "private tailnet IP leaked into skills/"; else
    ok "no private IP in skills/ (mineru-local sanitized)"; fi
if grep -rIq '/Users/leo' "$SCRIPT_DIR/skills/" 2>/dev/null; then
    bad "absolute machine path leaked into skills/"; else
    ok "no /Users/leo machine path in skills/"; fi
if [[ -e "$SCRIPT_DIR/skills/youtube-clipper/.env" ]]; then
    bad "youtube-clipper/.env should not be committed"; else
    ok "youtube-clipper/.env not shipped (.env.example kept)"; fi
assert_contains "$SCRIPT_DIR/skills/mineru-local/scripts/health-check.sh" \
    "MINERU_LOCAL_URL" "mineru-local endpoint is env-configurable"

start "skill-manage doctor: host-config check"
MINERU_LOCAL_URL="http://127.0.0.1:9" "$SCRIPTS/skill-manage.sh" doctor \
    > "$TESTROOT/doc.out" 2>&1 || true
assert_contains "$TESTROOT/doc.out" "[mineru-local]" "doctor checks mineru-local"
assert_contains "$TESTROOT/doc.out" "[youtube-clipper]" "doctor checks youtube-clipper"
assert_contains "$TESTROOT/doc.out" "[kedou-media-workflow]" "doctor checks kedou"
assert_not_contains "$TESTROOT/doc.out" '\xE2' "doctor renders emoji, not escapes"
"$SCRIPTS/skill-manage.sh" doctor --skill youtube-clipper > "$TESTROOT/doc1.out" 2>&1 || true
assert_contains "$TESTROOT/doc1.out" "youtube-clipper" "doctor --skill filters to one"
assert_not_contains "$TESTROOT/doc1.out" "[mineru-local]" "doctor --skill excludes others"
assert_contains "$TESTROOT/doc.out" "REQUIRED" "doctor reports a required/optional verdict"

start "forge: one-command auto-routing (book/video/text)"
fmd="$TESTROOT/forge.md"; printf '# Doc\nFocus deeply.\n' > "$fmd"
ftxt="$TESTROOT/forge.txt"; printf 'transcript line.\n' > "$ftxt"
# dry-run routing (offline, no acquisition/grimoire executed)
"$SCRIPTS/forge.sh" "$fmd" --only skills --dry-run > "$TESTROOT/f1" 2>&1
assert_contains "$TESTROOT/f1" "kind: markdown" "forge detects markdown"
assert_contains "$TESTROOT/f1" "from-markdown" "forge routes md → --from-markdown"
"$SCRIPTS/forge.sh" "$ftxt" --dry-run > "$TESTROOT/f2" 2>&1
assert_contains "$TESTROOT/f2" "kind: text" "forge detects text"
assert_contains "$TESTROOT/f2" "from-text" "forge routes txt → --from-text"
"$SCRIPTS/forge.sh" "https://youtu.be/abc123" --dry-run --skip-doctor > "$TESTROOT/f3" 2>&1
assert_contains "$TESTROOT/f3" "kind: video" "forge detects a video URL"
assert_contains "$TESTROOT/f3" "yt-dlp" "forge plans yt-dlp subtitle acquisition"
"$SCRIPTS/forge.sh" "https://arxiv.org/pdf/2310.06825" --dry-run --skip-doctor > "$TESTROOT/f4" 2>&1
assert_contains "$TESTROOT/f4" "kind: pdf" "forge detects a PDF/arXiv URL"
assert_fail "forge rejects an unknown URL" \
    "$SCRIPTS/forge.sh" "https://example.com/page" --dry-run --skip-doctor
# real end-to-end: book(.md) and video-transcript(.txt) → contract, no network
"$SCRIPTS/forge.sh" "$fmd" --only skills --output "$TESTROOT/fg1" --force >/dev/null 2>&1
assert_file "$TESTROOT/fg1/grimoires/forge/GRIMOIRE_TASK.md" "forge book → grimoire contract"
"$SCRIPTS/forge.sh" "$ftxt" --title "Talk" --only skills --output "$TESTROOT/fg2" --force >/dev/null 2>&1
assert_file "$TESTROOT/fg2/grimoires/talk/GRIMOIRE_TASK.md" "forge transcript → grimoire contract"

# ---------------------------------------------------------------------------
start "refactor: behavior-preserving cleanup invariants"
# (a) 1.5M cruft stays gone
if [[ -e "$SCRIPT_DIR/skills/mineru/_restructure-tmp" ]]; then
    bad "skills/mineru/_restructure-tmp must stay deleted"; else
    ok "merge-cruft _restructure-tmp absent"; fi
# (b) ensure_fresh_dir keeps each caller's exact message (Grimoire / Pack / …)
gx="$TESTROOT/efd"; mkmd "$TESTROOT/efd.md"
"$SCRIPTS/grimoire.sh" --md "$TESTROOT/efd.md" --title EFD --only skills \
    --output "$gx" --force >/dev/null 2>&1
"$SCRIPTS/grimoire.sh" --md "$TESTROOT/efd.md" --title EFD --only skills \
    --output "$gx" > "$TESTROOT/efd.err" 2>&1 && bad "second run without --force should fail" || ok "ensure_fresh_dir blocks re-create"
assert_contains "$TESTROOT/efd.err" "Grimoire already exists:" "exact 'Grimoire already exists:' wording preserved"
assert_contains "$TESTROOT/efd.err" "use --force to replace it" "exact --force hint preserved"
"$SCRIPTS/reading-notes-pack.sh" "$TESTROOT/efd.md" --title EFD --type book \
    --output "$TESTROOT/efdp" --force >/dev/null 2>&1
"$SCRIPTS/reading-notes-pack.sh" "$TESTROOT/efd.md" --title EFD --type book \
    --output "$TESTROOT/efdp" > "$TESTROOT/efdp.err" 2>&1 || true
assert_contains "$TESTROOT/efdp.err" "Pack already exists:" "reading-notes keeps 'Pack already exists:' wording"
# (c) legacy wrappers warn but still forward
"$SCRIPTS/book-skill-pack.sh" -h > "$TESTROOT/wrap.out" 2> "$TESTROOT/wrap.err" || true
assert_contains "$TESTROOT/wrap.err" "[deprecated]" "book-skill-pack.sh prints deprecation notice"
assert_contains "$TESTROOT/wrap.out" "source-skill-pack" "book-skill-pack.sh still forwards (target help shown)"
"$SCRIPTS/vivo-agent-workspace.sh" -h >/dev/null 2> "$TESTROOT/vw.err" || true
assert_contains "$TESTROOT/vw.err" "[deprecated]" "vivo-agent-workspace.sh prints deprecation notice"
# (d) skill-install.sh usage() de-brittled (awk leading-comment, exit 0, no stray code)
"$SCRIPTS/skill-install.sh" -h > "$TESTROOT/si.out" 2>&1
assert_contains "$TESTROOT/si.out" "OPT-IN cross-agent installer" "skill-install -h shows header help"
assert_not_contains "$TESTROOT/si.out" "set -euo pipefail" "skill-install -h no longer leaks code lines"

# ---------------------------------------------------------------------------
start "kedou-bili-subs: Bilibili subtitle helper (dry-run, offline)"
"$SCRIPTS/kedou-bili-subs.sh" "https://www.bilibili.com/video/BV1SrLG6oEax" --dry-run > "$TESTROOT/kb.out" 2>&1
assert_contains "$TESTROOT/kb.out" "opencli browser kedou-bili open https://www.kedou.life" "drives the Kedou caption page via OpenCLI"
assert_contains "$TESTROOT/kb.out" "filesystem poll" "uses a filesystem download wait"
assert_contains "$TESTROOT/kb.out" "NOT 'opencli wait download'" "does NOT rely on the broken opencli wait download"
"$SCRIPTS/kedou-bili-subs.sh" "https://space.bilibili.com/59807853" --dry-run > "$TESTROOT/kb2.out" 2>&1
assert_contains "$TESTROOT/kb2.out" "space page detected" "space URL → extract + list path"
assert_contains "$TESTROOT/kb2.out" "--video" "space URL tells you to re-run with --video"
assert_fail "rejects a non-Bilibili URL" "$SCRIPTS/kedou-bili-subs.sh" "https://youtu.be/x" --dry-run
if "$SCRIPTS/kedou-bili-subs.sh" -h >/dev/null 2>&1; then ok "kedou-bili-subs -h works"; else bad "kedou-bili-subs -h failed"; fi

start "forge: Bilibili routes to Kedou (override-able), others unchanged"
"$SCRIPTS/forge.sh" "https://www.bilibili.com/video/BV1x" --bili-via kedou --dry-run --skip-doctor > "$TESTROOT/fb1" 2>&1
assert_contains "$TESTROOT/fb1" "Bilibili → Kedou route" "bilibili --bili-via kedou → Kedou path"
"$SCRIPTS/forge.sh" "https://www.bilibili.com/video/BV1x" --bili-via ytdlp --dry-run --skip-doctor > "$TESTROOT/fb2" 2>&1
assert_contains "$TESTROOT/fb2" "yt-dlp" "bilibili --bili-via ytdlp → yt-dlp path"
assert_not_contains "$TESTROOT/fb2" "Bilibili → Kedou route" "ytdlp override skips Kedou"
"$SCRIPTS/forge.sh" "https://youtu.be/keep123" --dry-run --skip-doctor > "$TESTROOT/fb3" 2>&1
assert_contains "$TESTROOT/fb3" "yt-dlp" "youtu.be still yt-dlp (unchanged)"
assert_not_contains "$TESTROOT/fb3" "Bilibili → Kedou route" "non-bilibili never takes Kedou path"

start "subtitle template + kedou recipe + doctor opencli"
TPL="$SCRIPT_DIR/templates/subtitle-note-template.md"
assert_file "$TPL" "subtitle-note-template.md shipped"
for sec in "一句话总结" "时间线 / 章节" "工具地图" "后续行动项"; do
    assert_contains "$TPL" "$sec" "template has section: $sec"
done
assert_contains "$TPL" "不要把完整逐字稿塞进笔记" "template states the no-full-transcript boundary"
assert_file "$SCRIPT_DIR/skills/kedou-media-workflow/references/bilibili-subtitle-to-note.md" "kedou Bilibili recipe shipped"
assert_contains "$SCRIPT_DIR/skills/kedou-media-workflow/SKILL.md" "bilibili-subtitle-to-note.md" "kedou SKILL.md points at the recipe"
"$SCRIPTS/skill-manage.sh" doctor --skill kedou-media-workflow > "$TESTROOT/dkb" 2>&1 || true
assert_contains "$TESTROOT/dkb" "opencli" "doctor kedou section checks opencli"

# ---------------------------------------------------------------------------
start "kedou-progress lib: dedupe + resume (bash+jq, no node)"
KP="$TESTROOT/kp"; mkdir -p "$KP"
cat > "$KP/m.jsonl" <<'EOF'
{"index":1,"bvid":"BVa","title":"A","url":"https://www.bilibili.com/video/BVa"}
{"index":2,"bvid":"BVb","title":"B","url":"https://www.bilibili.com/video/BVb"}
{"index":3,"bvid":"BVc","title":"C","url":"https://www.bilibili.com/video/BVc"}
EOF
( source "$SCRIPTS/lib/kedou-progress.sh"
  kp_record "$KP/p.jsonl" 1 BVa done ""
  kp_record "$KP/p.jsonl" 2 BVb no_chinese_subtitle "x"
  kp_record "$KP/p.jsonl" 2 BVb done "retry"
  kp_record "$KP/p.jsonl" 3 BVc quota_limited "上限"
  kp_latest_counts "$KP/p.jsonl" > "$KP/c.json"
  echo "$(kp_latest_status "$KP/p.jsonl" BVb)" > "$KP/bvb"
  echo "$(kp_next_resume "$KP/p.jsonl" "$KP/m.jsonl")" > "$KP/nr" )
assert_eq "$(jq -r '.counts.done' "$KP/c.json")" "2" "latest-per-bvid: 2 done (BVb retried)"
assert_eq "$(jq -r '.counts.quota_limited' "$KP/c.json")" "1" "quota_limited counted"
assert_eq "$(cat "$KP/bvb")" "done" "latest status for BVb = done"
assert_eq "$(cat "$KP/nr")" "3" "next resume = first non-done (BVc=3)"

start "kedou-bili-manifest: from-network + dry-run + reject"
cat > "$KP/net.json" <<'EOF'
[{"url":"https://api.bilibili.com/x/space/wbi/arc/search?pn=1","responseBody":"{\"code\":0,\"data\":{\"list\":{\"vlist\":[{\"bvid\":\"BV1a\",\"title\":\"一\",\"aid\":1,\"length\":\"10:00\",\"created\":1},{\"bvid\":\"BV1b\",\"title\":\"二\",\"aid\":2,\"length\":\"20:00\",\"created\":2}]}}}"}]
EOF
"$SCRIPTS/kedou-bili-manifest.sh" --from-network "$KP/net.json" --out "$KP/v.jsonl" >/dev/null 2>&1
assert_eq "$(jq -s 'length' "$KP/v.jsonl")" "2" "from-network → 2 videos"
assert_eq "$(jq -rs '.[0].url' "$KP/v.jsonl")" "https://www.bilibili.com/video/BV1a" "synthesizes the video URL"
"$SCRIPTS/kedou-bili-manifest.sh" "https://space.bilibili.com/1" --pages 1 --dry-run > "$KP/md.out" 2>&1
assert_contains "$KP/md.out" "风控" "manifest dry-run explains the 412/-352 风控 reason"
assert_contains "$KP/md.out" "opencli browser" "manifest dry-run prints the OpenCLI capture sequence"
assert_fail "manifest rejects a non-space URL" "$SCRIPTS/kedou-bili-manifest.sh" "https://www.bilibili.com/video/BVx" --dry-run

start "kedou-bili-batch: window / resume / status / space-route (dry)"
"$SCRIPTS/kedou-bili-batch.sh" "$KP/m.jsonl" --out-dir "$KP/ws" --start 2 --limit 1 --dry-run > "$KP/b1" 2>&1
assert_contains "$KP/b1" "[2] B (BVb)" "batch --start/--limit selects the right window"
assert_not_contains "$KP/b1" "[1] A (BVa)" "batch window excludes out-of-range"
mkdir -p "$KP/ws3/manifests"; cp "$KP/m.jsonl" "$KP/ws3/manifests/videos.jsonl"
( source "$SCRIPTS/lib/kedou-progress.sh"; kp_record "$KP/ws3/manifests/progress.jsonl" 1 BVa done "" )
"$SCRIPTS/kedou-bili-batch.sh" "$KP/m.jsonl" --out-dir "$KP/ws3" --resume --dry-run > "$KP/b2" 2>&1
assert_contains "$KP/b2" "resume → starting at index 2" "batch --resume skips done index 1"
"$SCRIPTS/kedou-bili-batch.sh" --status --out-dir "$KP/ws3" > "$KP/b3" 2>&1
assert_contains "$KP/b3" "progress summary" "batch --status prints the summary"
"$SCRIPTS/kedou-bili-batch.sh" "https://space.bilibili.com/9" --out-dir "$KP/ws4" --dry-run > "$KP/b4" 2>&1
assert_contains "$KP/b4" "kedou-bili-manifest.sh" "batch on a space URL routes through the manifest capturer"
"$SCRIPTS/skill-manage.sh" doctor --skill kedou-media-workflow > "$KP/dk" 2>&1 || true
assert_contains "$KP/dk" "batch" "doctor mentions the batch route"

# ---------------------------------------------------------------------------
start "kedou report / backlog + opt-in whisper fallback"
KW="$TESTROOT/kw"; mkdir -p "$KW/manifests"
cat > "$KW/manifests/videos.jsonl" <<'EOF'
{"index":1,"bvid":"BVa","title":"A","url":"https://www.bilibili.com/video/BVa"}
{"index":2,"bvid":"BVb","title":"B","url":"https://www.bilibili.com/video/BVb"}
{"index":3,"bvid":"BVc","title":"C","url":"https://www.bilibili.com/video/BVc"}
EOF
( source "$SCRIPTS/lib/kedou-progress.sh"
  kp_record "$KW/manifests/progress.jsonl" 1 BVa done ""
  kp_record "$KW/manifests/progress.jsonl" 2 BVb no_chinese_subtitle "无中文"
  kp_record "$KW/manifests/progress.jsonl" 3 BVc subtitle_failed "boom" )
"$SCRIPTS/kedou-bili-batch.sh" --report --out-dir "$KW" > "$KW/r.out" 2>&1
assert_contains "$KW/r.out" "by status" "batch --report prints a status breakdown"
assert_contains "$KW/r.out" "report →" "batch --report writes a dated report file"
if ls "$KW"/reports/report-*.md >/dev/null 2>&1; then ok "report file created under reports/"; else bad "no report file written"; fi
"$SCRIPTS/kedou-bili-batch.sh" --backlog --out-dir "$KW" > "$KW/bk.out" 2>&1
assert_eq "$(jq -s 'length' "$KW/manifests/backlog.jsonl")" "2" "backlog = the 2 non-done rows"
assert_contains "$KW/bk.out" "whisper-transcribe.sh --backlog" "backlog points at the opt-in Whisper step"
"$SCRIPTS/whisper-transcribe.sh" "https://www.bilibili.com/video/BV1z" --out-dir "$KW/w" --dry-run > "$KW/w1" 2>&1
assert_contains "$KW/w1" "fetch audio" "whisper URL path fetches audio first"
assert_contains "$KW/w1" "forge.sh" "whisper points the transcript at forge --from-text"
"$SCRIPTS/whisper-transcribe.sh" --backlog "$KW/manifests/backlog.jsonl" --out-dir "$KW/w" --dry-run > "$KW/w2" 2>&1
assert_contains "$KW/w2" "backlog done: ok=" "whisper --backlog iterates the list"
assert_fail "whisper rejects a missing local file" "$SCRIPTS/whisper-transcribe.sh" /no/such.mp4 --dry-run
if "$SCRIPTS/whisper-transcribe.sh" -h >/dev/null 2>&1; then ok "whisper-transcribe -h works"; else bad "whisper-transcribe -h failed"; fi
"$SCRIPTS/skill-manage.sh" doctor --skill kedou-media-workflow > "$KW/dk" 2>&1 || true
assert_contains "$KW/dk" "whisper" "doctor reports the Whisper fallback engine"

start "subtitle-note template is two-layer (search-friendly)"
STPL="$SCRIPT_DIR/templates/subtitle-note-template.md"
assert_contains "$STPL" "## 1. 摘要层" "template has the Summary layer"
assert_contains "$STPL" "### 概念索引" "Summary layer adds a concept index (Obsidian search entry)"
assert_contains "$STPL" "## 2. 原始字幕（存档）" "template isolates raw subtitle into an archive layer"
assert_contains "$STPL" "<details>" "raw subtitle is folded to not pollute search/outline"

# ---------------------------------------------------------------------------
start "all shell scripts parse"
while IFS= read -r f; do
    if bash -n "$f" 2>/dev/null; then ok "syntax: ${f#$SCRIPT_DIR/}"; else
        bad "syntax error: ${f#$SCRIPT_DIR/}"; fi
done < <(find "$SCRIPTS" -name '*.sh')

# ---------------------------------------------------------------------------
echo
echo "==============================="
echo " PASS: $PASS   FAIL: $FAIL"
echo "==============================="
[[ $FAIL -eq 0 ]] || exit 1
