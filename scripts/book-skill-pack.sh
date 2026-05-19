#!/usr/bin/env bash
# Backward-compatible wrapper for the source-first pack builder.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "[deprecated] book-skill-pack.sh → use source-skill-pack.sh (this compat wrapper will be removed in a future major release)" >&2
exec "$SCRIPT_DIR/source-skill-pack.sh" "$@"
