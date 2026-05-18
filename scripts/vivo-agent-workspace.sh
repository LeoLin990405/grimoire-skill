#!/usr/bin/env bash
# Backward-compatible wrapper for the Vivo workspace generator.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/vivo-workspace.sh" "$@"
