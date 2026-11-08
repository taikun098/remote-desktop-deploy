#!/bin/bash
echo "=== 1. rustdesk 服务状态 ==="
systemctl is-active rustdesk; systemctl is-enabled rustdesk 2>&1
echo "=== 2. 运行用户 + 显示 ==="
ps -eo pid,user,args | grep '[r]ustdesk --server' | head -2
ps -eo pid,user,args | grep '[r]ustdesk --service' | head -2
echo "=== 3. 当前 RustDesk2.toml 配置（user）==="
cat /home/user/.config/rustdesk/RustDesk2.toml 2>/dev/null
echo "--- root ---"
cat /root/.config/rustdesk/RustDesk2.toml 2>/dev/null
echo "=== 4. 设备 ID (enc_id) ==="
grep -E '^enc_id' /home/user/.config/rustdesk/RustDesk.toml 2>/dev/null | head -1
echo "=== 5. 21116 是否监听（TCP/UDP）==="
ss -tlnp 2>/dev/null | grep 21116 || echo "TCP 21116 未监听"
ss -ulnp 2>/dev/null | grep 21116 || echo "UDP 21116 未监听"
echo "=== 6. rustdesk 到 yc 的连接 ==="
ss -tnp 2>/dev/null | grep 36.102.85.112
echo "=== 7. --server 日志尾部 12 行 ==="
tail -12 /home/user/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null
echo "=== DONE ==="
