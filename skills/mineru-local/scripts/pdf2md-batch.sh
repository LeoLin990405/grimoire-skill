#!/usr/bin/env bash
# pdf2md-batch.sh — 批量把目录下所有 PDF 转 Markdown
#
# 用法: pdf2md-batch.sh <dir> [-b backend] [--force]
#   <dir>     目标目录（递归找 *.pdf）
#   -b        backend: pipeline (默认) | vlm-transformers | vlm-vllm-engine
#   --force   覆盖已有 .md 文件（默认 skip）
#
# 例: pdf2md-batch.sh ~/Downloads
#     pdf2md-batch.sh ~/Books -b vlm-transformers --force

set -euo pipefail

DIR=${1:-}
[ -z "$DIR" ] || [ ! -d "$DIR" ] && { echo "usage: pdf2md-batch.sh <dir> [-b backend] [--force]"; exit 1; }
shift

BACKEND=pipeline
FORCE=0
while [ $# -gt 0 ]; do
  case "$1" in
    -b) BACKEND=$2; shift 2 ;;
    --force) FORCE=1; shift ;;
    *) echo "unknown arg: $1"; exit 1 ;;
  esac
done

PDFS=()
while IFS= read -r -d '' f; do
  PDFS+=("$f")
done < <(find "$DIR" -type f -name "*.pdf" -print0)

TOTAL=${#PDFS[@]}
echo ">> found $TOTAL PDFs in $DIR"
[ "$TOTAL" -eq 0 ] && exit 0

OK=0
SKIP=0
FAIL=0
for i in "${!PDFS[@]}"; do
  pdf=${PDFS[$i]}
  out="${pdf%.pdf}.md"
  n=$((i+1))
  if [ -f "$out" ] && [ "$FORCE" -eq 0 ]; then
    echo "[$n/$TOTAL] skip (exists): $out"
    SKIP=$((SKIP+1))
    continue
  fi
  echo "[$n/$TOTAL] $pdf"
  if pdf2md "$pdf" "$out" -b "$BACKEND" 2>&1 | tail -2; then
    OK=$((OK+1))
  else
    echo "  FAILED"
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "=== summary: $OK ok / $SKIP skipped / $FAIL failed ==="
