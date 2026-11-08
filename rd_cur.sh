#!/bin/bash
echo "=== 当前 root RustDesk.toml 完整（隐藏密钥/键对）==="
sudo -n python3 - <<'PYEOF'
import re
p="/root/.config/rustdesk/RustDesk.toml"
s=open(p, encoding="utf-8").read()
# 隐藏长数组和密钥
s=re.sub(r'key_pair\s*=\s*\[.*?\]\s*\n', 'key_pair=[REDACTED]\n', s, flags=re.S)
s=re.sub(r'(password\s*=).*', r'\1[REDACTED]', s)
s=re.sub(r'(salt\s*=).*', r'\1[REDACTED]', s)
s=re.sub(r'(key\s*=).*', r'\1[REDACTED]', s)
print(s)
PYEOF
echo "=== 服务是否 active ==="
systemctl is-active rustdesk.service
ps -eo pid,args | grep '[r]ustdesk' | grep -v check-hwcodec
echo "=== DONE ==="
