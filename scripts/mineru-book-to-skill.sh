#!/usr/bin/env bash
# Backward-compatible wrapper for the source-first MinerU workflow.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "[deprecated] mineru-book-to-skill.sh → use mineru-source-to-skill.sh (this compat wrapper will be removed in a future major release)" >&2
exec "$SCRIPT_DIR/mineru-source-to-skill.sh" "$@"
