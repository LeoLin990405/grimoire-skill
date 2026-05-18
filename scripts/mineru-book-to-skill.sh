#!/usr/bin/env bash
# Backward-compatible wrapper for the source-first MinerU workflow.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/mineru-source-to-skill.sh" "$@"
