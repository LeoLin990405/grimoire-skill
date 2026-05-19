#!/usr/bin/env bash
# skill-manage.sh — the management layer that interconnects produced skills
# across the user's agents. Idempotent, --dry-run aware. Self-contained
# (uses lib/agent-targets.sh; no dependency on the machine engine).
#
# This is the OPT-IN management counterpart to skill-install.sh. Like it, it
# only ever touches the named skill(s) — an agent's own skills are never
# enumerated or removed.
#
# Usage:
#   skill-manage.sh status [--name <skill>]
#       Cross-agent presence/mechanism matrix (drift flagged).
#   skill-manage.sh list
#       Per-agent skill counts + each agent's own (non-shared) skills.
#   skill-manage.sh scan
#       Scan THIS machine: which skill-capable agents are present, how many
#       skills each holds, plus any extra skill dirs discovered. Prints the
#       headline count of skill-capable agents.
#   skill-manage.sh doctor [--skill <name>]
#       Check whether THIS host has the config/tools the bundled source
#       skills need (MinerU server/token, ffmpeg/yt-dlp, Kedou, …). Read
#       only. Exit 1 if a REQUIRED prerequisite is missing (⚠️ warnings
#       do not fail).
#   skill-manage.sh sync --pack <dir> [--agents <csv|all>] [--dry-run]
#       Re-distribute a pack (use after a Trae/stepfun/deepseek app update
#       wiped its app-managed dir). Thin wrapper over skill-install.sh.
#   skill-manage.sh uninstall --name <skill> [--agents <csv|all>] [--dry-run]
#       Remove ONE skill from the chosen agents (only that name).
#   skill-manage.sh gate [--dry-run]
#       Print the manual Claude PreToolUse hook snippet and idempotently
#       inject the skill-preflight paragraph into agent instruction files.
#       NEVER touches ~/.claude/settings.json.
#   -h, --help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/agent-targets.sh
source "$SCRIPT_DIR/lib/agent-targets.sh"

usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "${BASH_SOURCE[0]}"; exit 0; }
[[ $# -gt 0 ]] || usage
case "$1" in -h|--help) usage ;; esac
CMD="$1"; shift || true
NAME=""; PACK=""; AGENTS="all"; DRY=false; SKILL=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --name) NAME="${2:?Missing value for --name}"; shift 2 ;;
        --pack) PACK="${2:?Missing value for --pack}"; shift 2 ;;
        --agents) AGENTS="${2:?Missing value for --agents}"; shift 2 ;;
        --skill) SKILL="${2:?Missing value for --skill}"; shift 2 ;;
        --dry-run) DRY=true; shift ;;
        -*) error "Unknown option: $1" ;;
        *) error "Unexpected argument: $1" ;;
    esac
done

# resolve --agents (csv|all) → space list of present agents
resolve_agents() {
    local out=""
    if [[ "$AGENTS" == "all" ]]; then
        while read -r a; do at_present "$a" && out="$out $a"; done < <(at_all_agents)
    else
        local OLD_IFS="$IFS"; IFS=','
        for a in $AGENTS; do
            a="$(printf '%s' "$a" | tr -d '[:space:]')"; [[ -z "$a" ]] && continue
            [[ -n "$(at_dir "$a")" ]] || error "Unknown agent id: $a"
            out="$out $a"
        done
        IFS="$OLD_IFS"
    fi
    printf '%s' "$out"
}

case "$CMD" in
status)
    echo "Cross-agent skill status${NAME:+ — $NAME}"
    echo
    printf '  %-9s | %-7s | %-9s | %s\n' agent present mechanism detail
    while read -r a; do
        pres=no; at_present "$a" && pres=yes
        detail="-"
        if [[ -n "$NAME" && "$pres" == yes ]]; then
            t="$(at_dir "$a")/$NAME"
            if [[ -L "$t" ]]; then detail="symlink → $(readlink "$t")"
            elif [[ -d "$t" ]]; then detail="copy (dir present)"
            else detail="absent"; fi
        fi
        printf '  %-9s | %-7s | %-9s | %s\n' "$a" "$pres" "$(at_mech "$a")" "$detail"
    done < <(at_all_agents)
    ;;

scan)
    echo "Skill-capable agents on this machine"
    echo
    printf '  %-9s | %-7s | %-9s | %6s | %s\n' agent present mechanism skills dir
    present_count=0
    while read -r a; do
        d="$(at_dir "$a")"; pres=no; cnt=0
        if at_present "$a"; then pres=yes; present_count=$((present_count + 1)); fi
        [[ -d "$d" ]] && cnt="$(ls "$d" 2>/dev/null | wc -l | tr -d ' ')"
        printf '  %-9s | %-7s | %-9s | %6s | %s\n' \
            "$a" "$pres" "$(at_mech "$a")" "$cnt" "${d/#$HOME/~}"
    done < <(at_all_agents)
    echo
    echo "Extra skill dirs discovered (have */SKILL.md, NOT in the registry — FYI):"
    extra=0
    while IFS= read -r d; do
        [[ -d "$d" ]] || continue
        is_reg=no
        while read -r a; do [[ "$d" == "$(at_dir "$a")" ]] && is_reg=yes; done < <(at_all_agents)
        [[ "$is_reg" == yes ]] && continue
        if ls "$d"/*/SKILL.md >/dev/null 2>&1; then
            printf '  + %-55s (%s skills)\n' "${d/#$HOME/~}" \
                "$(ls "$d" 2>/dev/null | wc -l | tr -d ' ')"
            extra=$((extra + 1))
        fi
    done < <( { ls -d "$HOME"/.*/skills 2>/dev/null
                ls -d "$HOME"/.config/*/skills 2>/dev/null
                ls -d "$HOME"/.*/builtin/*/*/skills 2>/dev/null; } | sort -u )
    [[ $extra -eq 0 ]] && echo "  (none)"
    echo
    echo "=============================================================="
    echo " Skill-capable agents present on this machine: $present_count"
    [[ $extra -gt 0 ]] && echo " (+ $extra extra skill dir(s) discovered, listed above)"
    echo "=============================================================="
    ;;

list)
    echo "Per-agent skills (count · own non-shared examples)"
    echo
    canon="$AT_CANON"
    while read -r a; do
        at_present "$a" || continue
        d="$(at_dir "$a")"; [[ -d "$d" ]] || { printf '  %-9s | (no dir yet)\n' "$a"; continue; }
        n="$(ls "$d" 2>/dev/null | wc -l | tr -d ' ')"
        own="$(comm -23 <(ls "$d" 2>/dev/null | sort) <(ls "$canon" 2>/dev/null | sort) 2>/dev/null | head -4 | tr '\n' ' ')"
        printf '  %-9s | %4s skills | own: %s\n' "$a" "$n" "${own:-–}"
    done < <(at_all_agents)
    echo
    echo "(\"own\" = present in this agent but not in the ~/.claude/skills SSOT;"
    echo " these are agent-only and are never touched by install/sync/uninstall.)"
    ;;

sync)
    [[ -n "$PACK" ]] || error "sync needs --pack <dir>"
    args=(--pack "$PACK" --agents "$AGENTS")
    [[ "$DRY" == true ]] && args+=(--dry-run)
    exec "$SCRIPT_DIR/skill-install.sh" "${args[@]}"
    ;;

uninstall)
    [[ -n "$NAME" ]] || error "uninstall needs --name <skill>"
    chosen="$(resolve_agents)"
    [[ -n "$chosen" ]] || error "no present agents resolved"
    echo "uninstall '$NAME'$( [[ $DRY == true ]] && echo ' (dry-run)') from:$chosen"
    for a in $chosen; do
        t="$(at_dir "$a")/$NAME"
        if [[ -L "$t" ]]; then
            [[ "$DRY" == true ]] && { echo "  $a: DRY:rm-symlink"; continue; }
            rm -f "$t"; echo "  $a: removed symlink"
        elif [[ -d "$t" ]]; then
            [[ "$DRY" == true ]] && { echo "  $a: DRY:rm-dir"; continue; }
            rm -rf "$t"; echo "  $a: removed copy"
        else
            echo "  $a: not present"
        fi
    done
    echo "(Drift backups, if any, remain under <agent-skills-dir>-backup-* / .skill-install-backup/.)"
    ;;

gate)
    PF="$AT_CANON/.preflight/PREFLIGHT.md"
    BLOCK_BEGIN="<!-- BEGIN: skill-preflight-gate (managed by skill-manage.sh — do not edit between markers) -->"
    BLOCK_END="<!-- END: skill-preflight-gate -->"
    read -r -d '' PARA <<'EOF' || true
## Skill Preflight Gate (MANDATORY)

Before reading, loading, or acting on ANY skill, first ask the user to
confirm: show the skill name, a one-line summary, the files/paths and
commands it may touch, and its risk tier; then ask "Proceed? (yes/no/modify
scope)". Do not load or follow the skill body until the user says yes.

Anti-fatigue: a read-only skill (no scripts/, no file writes, no shell or
network) already confirmed earlier THIS session may be auto-approved
silently. Skills with a scripts/ dir, file writes, shell/network, or a
write/destructive risk tier must ALWAYS be confirmed. Full contract:
~/.claude/skills/.preflight/PREFLIGHT.md
EOF
    # 1. shared canonical contract (lives in SSOT → propagates via install/sync)
    if [[ "$DRY" == true ]]; then
        echo "DRY: would write $PF and inject the gate paragraph into instruction files"
    else
        mkdir -p "$(dirname "$PF")"
        cat > "$PF" <<EOF
# Skill Preflight Confirmation Contract (SSOT)

$PARA

Confirmation prompt to present:

  ⚠️ Skill preflight — confirm before running
  • Skill: <name>
  • What it does: <one-line summary>
  • Files/paths it may touch: <list | none (read-only)>
  • Commands/scripts it may run: <list | none>
  • Risk tier: <none|read-only|writes-files|runs-scripts|network|destructive>
  Proceed? (yes / no / modify scope)
EOF
        echo "wrote $PF"
    fi
    # 2. idempotent paragraph injection into instruction files (NEVER settings*.json)
    for f in "$HOME/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md" \
             "$HOME/.config/opencode/OPENCODE.md" "$HOME/.qwen/QWEN.md"; do
        case "$f" in *settings*.json) echo "REFUSE: $f"; continue ;; esac
        [[ -f "$f" ]] || { echo "skip (absent): ${f/#$HOME/~}"; continue; }
        if grep -qF "BEGIN: skill-preflight-gate" "$f" 2>/dev/null; then
            echo "already has gate: ${f/#$HOME/~}"; continue
        fi
        if [[ "$DRY" == true ]]; then echo "DRY: append gate → ${f/#$HOME/~}"; continue; fi
        cp "$f" "$f.bak-$(date +%Y%m%d-%H%M%S)"
        { printf '\n%s\n\n%s\n\n%s\n' "$BLOCK_BEGIN" "$PARA" "$BLOCK_END"; } >> "$f"
        echo "injected gate → ${f/#$HOME/~} (backup kept)"
    done
    # 3. the deterministic Claude hook — MANUAL (agent cannot edit settings.json)
    cat <<'EOF'

────────────────────────────────────────────────────────────────────
MANUAL STEP (cannot be scripted — Claude blocks settings.json self-edit):
Merge this into ~/.claude/settings.json under a top-level "hooks" key,
then fully restart Claude Code:

{ "hooks": { "PreToolUse": [ { "matcher": "Skill", "hooks": [ { "type":
"command", "command": "echo '{\"hookSpecificOutput\":{\"hookEventName\":\
\"PreToolUse\",\"permissionDecision\":\"ask\",\"permissionDecisionReason\":\
\"Skill preflight: confirm name/scope/files/risk first (see ~/.claude/skills/.preflight/PREFLIGHT.md)\"}}}'" } ] } ] } }
────────────────────────────────────────────────────────────────────
EOF
    ;;

doctor)
    REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
    REQMISS=0
    have() { command -v "$1" >/dev/null 2>&1; }
    okx()  { printf '  ✅ %s\n' "$1"; }
    warn() { printf '  ⚠️  %s\n' "$1"; }
    miss() { printf '  ❌ %s\n' "$1"; REQMISS=$((REQMISS + 1)); }
    want() { [[ -z "$SKILL" || "$SKILL" == "$1" ]]; }
    tok_status() {
        local t="$HOME/.config/mineru/token"
        if [[ ! -f "$t" ]]; then warn "cloud token ~/.config/mineru/token absent (cloud fallback unavailable)"; return; fi
        if have python3; then
            python3 - "$t" <<'PY' 2>/dev/null || warn "cloud token present but unreadable"
import base64,json,sys,datetime,pathlib
p=pathlib.Path(sys.argv[1]).read_text().strip().split(".")
d=lambda s:base64.urlsafe_b64decode(s+"="*(-len(s)%4))
exp=datetime.datetime.fromtimestamp(json.loads(d(p[1]))["exp"])
left=(exp-datetime.datetime.now()).days
print(f"  {'✅' if left>7 else '⚠️ '} cloud token exp {exp:%Y-%m-%d} ({left}d left)")
PY
        else okx "cloud token present (install python3 to check expiry)"; fi
    }

    echo "Host config check for bundled source skills${SKILL:+ — $SKILL}"
    echo "(read-only; ❌ = required missing → exit 1, ⚠️ = optional)"

    if want mineru-local; then
        echo; echo "[mineru-local] PDF/DOC/PPT/image → Markdown"
        have curl && okx "curl" || miss "curl missing (brew install curl)"
        have jq   && okx "jq"   || miss "jq missing (brew install jq)"
        url="${MINERU_LOCAL_URL:-http://127.0.0.1:8010}"
        if curl -fs --max-time 3 "$url/docs" -o /dev/null 2>/dev/null; then
            okx "local MinerU reachable: $url"
        else
            warn "local MinerU NOT reachable at $url — export MINERU_LOCAL_URL=<your-host>, or rely on cloud fallback"
        fi
        tok_status
        have pdf2md && okx "pdf2md helper on PATH" || warn "pdf2md helper not on PATH (optional convenience wrapper)"
    fi

    if want mineru; then
        echo; echo "[mineru] legacy cloud MinerU API"
        have curl && okx "curl" || miss "curl missing"
        have jq   && okx "jq"   || miss "jq missing"
        tok_status
    fi

    if want youtube-clipper; then
        echo; echo "[youtube-clipper] video → subtitles"
        if have ffmpeg; then okx "ffmpeg"
        elif [[ -n "${FFMPEG_PATH:-}" && -x "${FFMPEG_PATH:-}" ]]; then okx "ffmpeg via \$FFMPEG_PATH"
        else miss "ffmpeg missing (brew install ffmpeg) or set FFMPEG_PATH"; fi
        have yt-dlp && okx "yt-dlp" || miss "yt-dlp missing (brew install yt-dlp / pip install yt-dlp)"
        have python3 && okx "python3" || miss "python3 missing"
        ycd="$REPO/skills/youtube-clipper"
        if [[ -f "$ycd/.env" ]]; then okx ".env present"
        elif [[ -f "$ycd/.env.example" ]]; then warn "no .env yet — cp skills/youtube-clipper/.env.example .env and edit FFMPEG_PATH/TARGET_LANGUAGE"
        fi
    fi

    if want kedou-media-workflow; then
        echo; echo "[kedou-media-workflow] web video/subtitle parsing"
        have curl && okx "curl" || miss "curl missing"
        if have opencli; then
            okx "opencli ($(opencli --version 2>/dev/null | head -1 | tr -d '\n' || echo '?')) — Bilibili kedou-bili-subs.sh route available"
        else
            warn "opencli not installed — the automated Bilibili subtitle route (scripts/kedou-bili-subs.sh) needs it; forge.sh will fall back to yt-dlp for B站"
        fi
        warn "Kedou is a desktop downloader + browser session: ensure the Kedou app/CLI is installed and a valid cookie/proxy/save-path is configured (see skills/kedou-media-workflow/SKILL.md and references/bilibili-subtitle-to-note.md)"
    fi

    echo
    if [[ $REQMISS -eq 0 ]]; then
        echo "=== OK — all REQUIRED prerequisites present (review ⚠️ items as needed) ==="
    else
        echo "=== $REQMISS REQUIRED prerequisite(s) MISSING — install them before using the affected source skill ==="
        exit 1
    fi
    ;;

*) error "Unknown command: $CMD (use -h)" ;;
esac
