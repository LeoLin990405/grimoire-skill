#!/usr/bin/env bash
# Shared shell helpers for MinerU/Vivo scripts.

if [[ -n "${MINERU_COMMON_SH_LOADED:-}" ]]; then
    return 0
fi
MINERU_COMMON_SH_LOADED=1

error() {
    echo "Error: $*" >&2
    exit 1
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || error "$1 is required but not installed"
}

slugify() {
    local value="$1"
    local fallback_prefix="${2:-source}"

    value=$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')
    value=$(printf '%s' "$value" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
    if [[ -z "$value" ]]; then
        value="$fallback_prefix-$(date -u +%Y%m%d%H%M%S)"
    fi
    printf '%s' "$value"
}

safe_remove_dir() {
    local path="$1"

    case "$path" in
        ""|"/"|"."|".."|"./"|"/."|"/.."|~|"$HOME") error "Refusing to replace unsafe path: $path" ;;
    esac
    rm -rf "$path"
}
