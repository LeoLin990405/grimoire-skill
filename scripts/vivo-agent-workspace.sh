#!/usr/bin/env bash
# Backward-compatible wrapper for the Vivo workspace generator.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "[deprecated] vivo-agent-workspace.sh → use vivo-workspace.sh (this compat wrapper will be removed in a future major release)" >&2
exec "$SCRIPT_DIR/vivo-workspace.sh" "$@"
