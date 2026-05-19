#!/usr/bin/env bash
# skill-install.sh — OPT-IN cross-agent installer for a produced skill pack.
#
# ⚠️ This deliberately crosses Grimoire's default "scripts never install
# skills" red line. It runs ONLY when explicitly invoked (by you, or by the
# agent following an --install GRIMOIRE_TASK step) — never from the default
# pipeline. The boundary crossing is recorded in the pack manifest's
# `red_line_note` (the same convention the 101-course dlai install used).
#
# The script does NOT pick agents for you and does NOT call an LLM. It prints
# the agent inventory (`--list`); the AGENT then asks you (AskUserQuestion)
# which agents to target and re-invokes with `--agents`.
#
# Usage:
#   skill-install.sh --pack <dir> --list
#   skill-install.sh --pack <dir> --agents claude,codex,trae[,…|all] [--dry-run]
#
# Options:
#   --pack <dir>     A skill dir (has SKILL.md), a dir of such dirs, or a
#                    grimoire workspace (uses skills/skills/ promoted packs).
#   --agents <csv>   Comma list of agent ids, or "all" (all present agents).
#                    ids: claude codex trae hub opencode copilot qwen
#                         deepseek stepfun
#   --name <n>       Override the installed skill name (single-pack only).
#   --list           Print agent inventory + units, then exit (no changes).
#   --dry-run        Show what would change; touch nothing.
#   -h, --help       Show this help.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
# shellcheck source=lib/agent-targets.sh
source "$SCRIPT_DIR/lib/agent-targets.sh"

PACK=""; AGENTS=""; NAME=""; LIST=false; DRY=false
# Print the leading header-comment block as help (robust: no hardcoded line
# range — stops at the first non-comment line, same idiom as forge.sh /
# skill-manage.sh).
usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "${BASH_SOURCE[0]}"; exit 0; }
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --pack) PACK="${2:?Missing value for --pack}"; shift 2 ;;
        --agents) AGENTS="${2:?Missing value for --agents}"; shift 2 ;;
        --name) NAME="${2:?Missing value for --name}"; shift 2 ;;
        --list) LIST=true; shift ;;
        --dry-run) DRY=true; shift ;;
        -*) error "Unknown option: $1" ;;
        *) error "Unexpected argument: $1" ;;
    esac
done
require_cmd jq
[[ -n "$PACK" ]] || error "--pack <dir> is required"
[[ -d "$PACK" ]] || error "--pack not a directory: $PACK"
PACK="$(cd "$PACK" && pwd)"

# ---- discover the unit(s) to install --------------------------------------
# Emits "<name>\t<abs_src_dir>" lines.
discover_units() {
    if [[ -f "$PACK/SKILL.md" ]]; then
        printf '%s\t%s\n' "${NAME:-$(basename "$PACK")}" "$PACK"
        return
    fi
    # grimoire workspace: reviewed promoted packs under skills/skills/
    local promoted="$PACK/skills/skills"
    [[ -d "$promoted" ]] || promoted="$PACK/skills"
    if [[ -d "$promoted" ]]; then
        local found=false d
        for d in "$promoted"/*/; do
            [[ -d "$d" && -f "$d/SKILL.md" ]] || continue
            printf '%s\t%s\n' "$(basename "$d")" "${d%/}"; found=true
        done
        $found && return
    fi
    # a directory of skill dirs
    local found=false d
    for d in "$PACK"/*/; do
        [[ -d "$d" && -f "$d/SKILL.md" ]] || continue
        printf '%s\t%s\n' "$(basename "$d")" "${d%/}"; found=true
    done
    $found || error "No skill found under $PACK (need a SKILL.md, a dir of SKILL.md dirs, or a grimoire skills/skills/ with reviewed packs)"
}

UNITS="$(discover_units)"

# ---- --list : inventory for the agent's AskUserQuestion -------------------
if [[ "$LIST" == true ]]; then
    echo "# Skill-install inventory"
    echo
    echo "Units to install (reviewed candidate skills in this pack):"
    printf '%s\n' "$UNITS" | while IFS=$'\t' read -r n s; do echo "  - $n  ($s)"; done
    echo
    echo "Agents on this machine (id | present | mechanism | dir):"
    while read -r a; do
        pres=no; at_present "$a" && pres=yes
        printf '  %-9s | %-3s | %-9s | %s\n' "$a" "$pres" "$(at_mech "$a")" "$(at_dir "$a")"
    done < <(at_all_agents)
    echo
    echo "Next: ask the user which agents to target, then re-run:"
    echo "  $0 --pack \"$PACK\" --agents <comma,list|all>"
    exit 0
fi

[[ -n "$AGENTS" ]] || error "--agents <csv|all> is required (or use --list first)"

# resolve agent list
CHOSEN=""
if [[ "$AGENTS" == "all" ]]; then
    while read -r a; do at_present "$a" && CHOSEN="$CHOSEN $a"; done < <(at_all_agents)
else
    OLD_IFS="$IFS"; IFS=','
    for a in $AGENTS; do
        a="$(printf '%s' "$a" | tr -d '[:space:]')"
        [[ -z "$a" ]] && continue
        [[ -n "$(at_dir "$a")" ]] || error "Unknown agent id: $a"
        CHOSEN="$CHOSEN $a"
    done
    IFS="$OLD_IFS"
fi
[[ -n "$CHOSEN" ]] || error "No valid/present agents selected"

STAMP="$(date +%Y%m%d-%H%M%S)"
echo "skill-install$( [[ $DRY == true ]] && echo ' (dry-run)') — pack: $PACK"
echo "agents:$CHOSEN"
echo

n_units=0
printf '%s\n' "$UNITS" | while IFS=$'\t' read -r name src; do
    [[ -n "$name" ]] || continue
    echo "▸ $name"
    for a in $CHOSEN; do
        echo "    $(at_install "$src" "$name" "$a" "$DRY" "$STAMP")"
    done
done
n_units="$(printf '%s\n' "$UNITS" | grep -c .)"

# ---- record the deliberate red-line crossing in the pack manifest --------
if [[ "$DRY" != true ]]; then
    mf=""
    for c in "$PACK/GRIMOIRE.md.json" "$PACK/skills/manifest.json" "$PACK/manifest.json"; do
        [[ -f "$c" ]] && { mf="$c"; break; }
    done
    if [[ -n "$mf" ]]; then
        agents_json="$(printf '%s' "$CHOSEN" | tr ' ' '\n' | grep . | jq -R . | jq -s .)"
        tmp="$(mktemp)"
        jq --argjson agents "$agents_json" --arg ts "$STAMP" '
            . + {
              installs_skills: true,
              red_line_note: ("Deliberately crossed the default \"scripts never install skills\" boundary by explicit user request via skill-install.sh; installed to: " + ($agents|join(", ")) + " at " + $ts),
              installed_to: $agents,
              installed_at: $ts
            }' "$mf" > "$tmp" && mv "$tmp" "$mf"
        echo
        echo "manifest updated (red_line_note recorded): ${mf#$PACK/}"
    fi
fi

echo
echo "Done. $n_units skill(s) → agents:$CHOSEN"
[[ "$DRY" == true ]] && echo "(dry-run — nothing was written)"
echo "Restart an agent for it to pick up newly added skills."
