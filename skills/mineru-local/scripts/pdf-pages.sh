#!/usr/bin/env bash
# pdf-pages.sh — 超大 PDF 分块解析（绕过 mineru-api concurrency=1 + 单请求超时）
#
# 用法: pdf-pages.sh <input.pdf> [chunk_size] [-b backend] [-o output.md]
#   chunk_size  每块多少页（默认 100）
#   -b          backend (默认 pipeline)
#   -o          最终合并输出 .md（默认 <input>.md）
#
# 例: pdf-pages.sh huge_book.pdf
#     pdf-pages.sh huge_book.pdf 200 -b vlm-transformers -o /tmp/book_full.md

set -euo pipefail

PDF=${1:-}
[ -z "$PDF" ] || [ ! -f "$PDF" ] && { echo "usage: pdf-pages.sh <input.pdf> [chunk_size=100] [-b backend] [-o output.md]"; exit 1; }
shift

CHUNK=100
BACKEND=pipeline
OUT="${PDF%.pdf}.md"
while [ $# -gt 0 ]; do
  case "$1" in
    -b) BACKEND=$2; shift 2 ;;
    -o) OUT=$2; shift 2 ;;
    [0-9]*) CHUNK=$1; shift ;;
    *) echo "unknown: $1"; exit 1 ;;
  esac
done

# 总页数（用 python 的 pypdf；M5 mineru venv 里有；本机若无就 pip install pypdf 或 用 pdftk）
PAGES=$(python3 -c "
import sys
try:
    from pypdf import PdfReader
except ImportError:
    try:
        from PyPDF2 import PdfReader
    except ImportError:
        print('pypdf/PyPDF2 not installed; pip install pypdf', file=sys.stderr)
        sys.exit(1)
print(len(PdfReader('$PDF').pages))
")
echo ">> $PDF: $PAGES pages, chunk_size=$CHUNK, backend=$BACKEND"

basename=$(basename "$PDF" .pdf)
TMPDIR=$(mktemp -d -t mineru-chunks.XXXXXX)
trap "echo '<< tmp dir: $TMPDIR (kept for debug)'" EXIT

idx=0
for start in $(seq 0 "$CHUNK" $((PAGES-1))); do
  end=$((start+CHUNK-1))
  [ $end -ge "$PAGES" ] && end=$((PAGES-1))
  chunk_md="$TMPDIR/$(printf '%03d' $idx)_${start}-${end}.md"
  echo "[chunk $((idx+1))] pages $start..$end"
  json="$TMPDIR/chunk_$idx.json"
  curl -s --max-time 1200 -X POST ${MINERU_LOCAL_URL:-http://127.0.0.1:8010}/file_parse \
    -F "files=@$PDF" \
    -F "backend=$BACKEND" \
    -F "start_page_id=$start" \
    -F "end_page_id=$end" \
    -F "return_md=true" \
    -o "$json" -w "  HTTP %{http_code} time %{time_total}s\n"
  python3 -c "
import json
d = json.load(open('$json'))
md = d.get('results', {}).get('$basename', {}).get('md_content', '')
if not md:
    print('ERROR: empty md_content', file=__import__('sys').stderr)
    print('keys:', list(d.get('results', {}).keys()), file=__import__('sys').stderr)
print(md)
" > "$chunk_md"
  echo "  wrote $chunk_md ($(wc -c < "$chunk_md") bytes)"
  idx=$((idx+1))
done

# 合并所有 chunk
cat "$TMPDIR"/*.md > "$OUT"
echo ""
echo ">> merged $idx chunks → $OUT ($(wc -c < "$OUT") bytes)"
