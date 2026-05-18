#!/usr/bin/env bash
# Backward-compatible wrapper for the source-first pack builder.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/source-skill-pack.sh" "$@"
