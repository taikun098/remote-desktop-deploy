#!/bin/bash
timeout 40 bash -c '
echo "=== 1) 进程是否存活 ==="
pgrep -af sunshine | grep -v "bash -c" | head
echo "--- 端口 ---"
echo 1 | sudo -S ss -tlnp 2>/dev/null | grep -E "47990|48010"
echo "=== 2) sunshine.log 全文（找编码器/显示/错误）==="
tail -40 /home/user/.config/sunshine/sunshine.log 2>/dev/null
echo "=== 3) 详细连接测试 ==="
curl -v -m 8 http://127.0.0.1:47990/ 2>&1 | grep -iE "connected|refused|failed|HTTP|error" | head -6
echo "=== DONE ==="
'
