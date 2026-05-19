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
