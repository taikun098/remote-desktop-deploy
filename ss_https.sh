#!/bin/bash
timeout 30 bash -c '
echo "=== HTTPS Web 界面探测 ==="
curl -sk -o /dev/null -w "https://192.168.0.20:47990 -> HTTP %{http_code}\n" -m 10 https://127.0.0.1:47990/ 2>&1 | tail -1
echo "=== 串流端口 TCP 探测（48010）==="
curl -s -o /dev/null -w "48010 -> %{http_code} (端口开)\n" -m 8 http://127.0.0.1:48010 2>&1 | tail -1 || echo "48010 端口已监听（非 http 属正常）"
echo "=== 确认服务开机自启 ==="
echo 1 | sudo -S -u user env XDG_RUNTIME_DIR=/run/user/1000 systemctl --user is-enabled sunshine 2>/dev/null
echo "=== DONE ==="
'
