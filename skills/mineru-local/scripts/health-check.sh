#!/usr/bin/env bash
# health-check.sh — 检查 M5 mineru-api 服务是否健康
# 用法: health-check.sh

set -e
HOST=${MINERU_LOCAL_URL:-http://127.0.0.1:8010}

echo "=== 1. tailnet 连通性 ==="
nc -z -G 3 127.0.0.1 8010 2>&1 && echo "  TCP OK" || { echo "  TCP FAIL"; exit 1; }

echo ""
echo "=== 2. mineru-api /docs ==="
code=$(curl -s --max-time 5 "$HOST/docs" -o /dev/null -w "%{http_code}")
echo "  HTTP $code"
[ "$code" = "200" ] || { echo "  FAIL"; exit 1; }

echo ""
echo "=== 3. M5 launchd 状态 ==="
ssh mbp 'launchctl list | grep mineru-api || echo "  NOT LOADED"' 2>&1

echo ""
echo "=== 4. M5 端口 ==="
ssh mbp 'lsof -iTCP:8010 -sTCP:LISTEN -P 2>/dev/null | tail -2' 2>&1

echo ""
echo "=== 5. M5 mineru-api 最近日志（最后 5 行） ==="
ssh mbp 'tail -5 /tmp/mineru-api.err 2>/dev/null' 2>&1

echo ""
echo "=== 6. M5 模型 cache ==="
ssh mbp 'du -sh ~/.cache/modelscope ~/.cache/huggingface 2>/dev/null' 2>&1

echo ""
echo "=== 7. web profile (mineru.net 浏览器登录态) ==="
PROFILE=~/Tools/mineru-web/profile
if [ -d "$PROFILE" ] && [ -n "$(ls -A "$PROFILE" 2>/dev/null)" ]; then
  age_days=$(( ($(date +%s) - $(stat -f %m "$PROFILE")) / 86400 ))
  echo "  ✅ profile exists ($PROFILE) · 上次写入 ${age_days}d ago"
  echo "     失效后跑: python3 ~/Tools/mineru-web/login.py"
else
  echo "  ⚠️  profile 未初始化"
  echo "     首次设置: python3 ~/Tools/mineru-web/login.py"
fi

echo ""
echo "=== 8. cloud token (mineru.net) ==="
TOKEN_FILE=~/.config/mineru/token
if [ -f "$TOKEN_FILE" ]; then
  python3 <<'PY'
import base64, json, datetime, sys, pathlib
tok = pathlib.Path.home() / ".config/mineru/token"
parts = tok.read_text().strip().split(".")
def b64d(s): return base64.urlsafe_b64decode(s + "=" * (-len(s) % 4))
p = json.loads(b64d(parts[1]))
exp = datetime.datetime.fromtimestamp(p["exp"])
days = (exp - datetime.datetime.now()).days
status = "✅" if days > 7 else ("⚠️" if days > 0 else "❌")
print(f"  {status} jti={p['jti']}  exp={exp.strftime('%Y-%m-%d')}  ({days} days left)")
sys.exit(0 if days > 0 else 1)
PY
else
  echo "  ⚠️  no token at $TOKEN_FILE (cloud fallback unavailable)"
fi

echo ""
echo "✅ all checks passed; service ready at $HOST"
echo "   Cloud fallback: pdf2md ... --cloud  (mineru.net /api/v4)"
