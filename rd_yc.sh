#!/bin/bash
echo "=== yc.445800773.xyz 解析 + 21116 端口 ==="
getent ahostsv4 yc.445800773.xyz | head -2
if timeout 6 bash -c "cat < /dev/null > /dev/tcp/yc.445800773.xyz/21116" 2>/dev/null; then echo "yc:21116 TCP OK"; else echo "yc:21116 TCP FAIL"; fi
echo "=== RustDesk.toml 完整结构（隐藏密钥）==="
sudo -n cat /root/.config/rustdesk/RustDesk.toml 2>/dev/null | sed -E 's/^(key_pair\s*=).*/\1 [REDACTED]/; s/^(password\s*=).*/\1 [REDACTED]/; s/^(salt\s*=).*/\1 [REDACTED]/'
echo "=== DONE ==="
