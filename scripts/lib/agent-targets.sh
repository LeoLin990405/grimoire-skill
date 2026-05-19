#!/usr/bin/env bash
# agent-targets.sh — repo-local mirror of the verified cross-agent skill
# topology (the same rules as the machine engine ~/.claude/skills-sync.sh,
# kept self-contained so the repo works on any machine).
#
# Sourced by skill-install.sh / skill-manage.sh. Bash 3.2 compatible
# (macOS): no associative arrays, no mapfile.
#
# Verified per-agent topology (memory: skills-unified-management):
#   claude    ~/.claude/skills            copy        (machine SSOT)
#   codex     ~/.codex/skills             symlink → canonical ~/.claude/skills
#   trae      ~/.trae/builtin/trae/default/skills   copy (app-managed; wiped on update)
#   hub       ~/.agents/skills            copy        (sandbox mount; symlink would dangle)
#   opencode  ~/.config/opencode/skills   symlink → hub ~/.agents/skills
#   copilot   ~/.copilot/skills           symlink → hub
#   qwen      ~/.qwen/skills              symlink → hub
#   deepseek  ~/.deepseek/skills          copy        (app-managed)
#   stepfun   ~/.stepfun/skills           copy        (app-managed)
#
# Invariants (identical to skills-sync.sh):
#   • per-pack only — only ever touches <dst>/<name>, so an agent's OWN
#     non-canonical skills (codex ppt-master, trae web-dev, stepfun's 10,
#     deepseek marker, hub dws) are never enumerated, never deleted.
#   • drift backup — a differing real dir is moved to <base>-backup-<stamp>/
#     before being replaced (reversible), never silently clobbered.
#   • idempotent — correct symlink/identical copy → no-op.
#   • dry-run aware — prints "DRY: …", changes nothing.

if [[ -n "${AGENT_TARGETS_SH_LOADED:-}" ]]; then return 0; fi
AGENT_TARGETS_SH_LOADED=1

AT_CANON="$HOME/.claude/skills"
AT_HUB="$HOME/.agents/skills"

# at_all_agents — every known agent id, in safe install order (hub/canonical
# materialized before the agents that symlink into them).
at_all_agents() { printf '%s\n' claude codex trae hub opencode copilot qwen deepseek stepfun; }

# at_dir <agent> — destination skills dir for an agent (empty if unknown).
at_dir() {
    case "$1" in
        claude)   printf '%s' "$AT_CANON" ;;
        codex)    printf '%s' "$HOME/.codex/skills" ;;
        trae)     printf '%s' "$HOME/.trae/builtin/trae/default/skills" ;;
        hub)      printf '%s' "$AT_HUB" ;;
        opencode) printf '%s' "$HOME/.config/opencode/skills" ;;
        copilot)  printf '%s' "$HOME/.copilot/skills" ;;
        qwen)     printf '%s' "$HOME/.qwen/skills" ;;
        deepseek) printf '%s' "$HOME/.deepseek/skills" ;;
        stepfun)  printf '%s' "$HOME/.stepfun/skills" ;;
        *)        printf '' ;;
    esac
}

# at_mech <agent> — copy | linkcanon | linkhub
at_mech() {
    case "$1" in
        claude|trae|hub|deepseek|stepfun) printf 'copy' ;;
        codex)                            printf 'linkcanon' ;;
        opencode|copilot|qwen)            printf 'linkhub' ;;
        *)                                printf '' ;;
    esac
}

# at_present <agent> — true if the agent looks installed (its skills dir's
# parent exists, so we can create the skills dir if missing).
at_present() {
    local d; d="$(at_dir "$1")"; [[ -n "$d" ]] || return 1
    [[ -d "$d" || -d "$(dirname "$d")" ]]
}

# _at_stage_copy <src_pack> <dst_dir> <name> <backup_root> <dry>
# Drift-backup-then-copy one pack into a copy-target dir. Echoes a status word.
_at_stage_copy() {
    local src="$1" dstdir="$2" name="$3" backup="$4" dry="$5"
    local dst="$dstdir/$name"
    mkdir -p "$dstdir" 2>/dev/null || true
    if [[ -e "$dst" || -L "$dst" ]]; then
        if [[ ! -L "$dst" && -d "$dst" ]] && diff -rq "$src" "$dst" >/dev/null 2>&1; then
            printf 'already-ok'; return 0
        fi
        if [[ "$dry" == true ]]; then
            printf 'DRY:backup+copy'; return 0
        fi
        mkdir -p "$backup"
        mv "$dst" "$backup/$name"
    elif [[ "$dry" == true ]]; then
        printf 'DRY:copy'; return 0
    fi
    cp -RL "$src" "$dst"
    printf 'copied'
}

# _at_make_symlink <target> <link_dir> <name> <dry>
# Idempotent per-pack symlink. Echoes a status word.
_at_make_symlink() {
    local target="$1" linkdir="$2" name="$3" dry="$4"
    local link="$linkdir/$name"
    mkdir -p "$linkdir" 2>/dev/null || true
    if [[ -L "$link" ]]; then
        [[ "$(readlink "$link")" == "$target" ]] && { printf 'already-ok'; return 0; }
        [[ "$dry" == true ]] && { printf 'DRY:repoint'; return 0; }
        ln -sfn "$target" "$link"; printf 'repointed'; return 0
    fi
    if [[ -e "$link" ]]; then
        # a real dir/file sits where the link should go
        [[ "$dry" == true ]] && { printf 'DRY:backup+link'; return 0; }
        mkdir -p "$linkdir/.skill-install-backup"
        mv "$link" "$linkdir/.skill-install-backup/$name.$(date +%s)"
        ln -s "$target" "$link"; printf 'backed-up+linked'; return 0
    fi
    [[ "$dry" == true ]] && { printf 'DRY:link'; return 0; }
    ln -s "$target" "$link"; printf 'linked'
}

# at_install <src_pack> <name> <agent> <dry> <stamp>
# Install ONE pack into ONE agent using that agent's verified mechanism.
# Symlink agents are auto-staged into their target root (canonical/hub) first
# — this mirrors the real machine topology (choosing codex implies the
# canonical copy; choosing opencode/copilot/qwen implies the hub copy).
# Echoes: "<agent>: <status>".
at_install() {
    local src="$1" name="$2" agent="$3" dry="$4" stamp="$5"
    local dir mech st
    dir="$(at_dir "$agent")"; mech="$(at_mech "$agent")"
    if [[ -z "$dir" || -z "$mech" ]]; then printf '%s: unknown-agent\n' "$agent"; return 0; fi
    if ! at_present "$agent"; then printf '%s: skipped(not-installed)\n' "$agent"; return 0; fi

    case "$mech" in
        copy)
            st="$(_at_stage_copy "$src" "$dir" "$name" "$dir-backup-$stamp" "$dry")"
            ;;
        linkcanon)
            # ensure canonical copy exists, then symlink to it
            _at_stage_copy "$src" "$AT_CANON" "$name" "$AT_CANON-backup-$stamp" "$dry" >/dev/null
            st="$(_at_make_symlink "$AT_CANON/$name" "$dir" "$name" "$dry")"
            ;;
        linkhub)
            # ensure hub copy exists, then symlink to it
            _at_stage_copy "$src" "$AT_HUB" "$name" "$AT_HUB-backup-$stamp" "$dry" >/dev/null
            st="$(_at_make_symlink "$AT_HUB/$name" "$dir" "$name" "$dry")"
            ;;
    esac
    printf '%s: %s\n' "$agent" "$st"
}
