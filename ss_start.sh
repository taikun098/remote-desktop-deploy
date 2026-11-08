#!/bin/bash
timeout 40 bash -c '
UID1000=$(id -u user)
echo "=== 1) 启用用户 linger（开机自启用户服务）==="
echo 1 | sudo -S loginctl enable-linger user 2>&1 | tail -1
echo "linger: $(loginctl show-user user -p Linger 2>/dev/null)"
echo "=== 2) 检查用户 systemd 实例 ==="
ls -ld /run/user/$UID1000 2>/dev/null
pgrep -u user -f systemd | head -1 && echo "(用户 systemd 在跑)" || echo "(需启动)"
echo "=== 3) 以 user 启用并启动 sunshine 用户服务 ==="
echo 1 | sudo -S -u user env XDG_RUNTIME_DIR=/run/user/$UID1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UID1000/bus \
  systemctl --user enable --now sunshine 2>&1 | tail -3
sleep 4
echo "--- 服务状态: $(echo 1 | sudo -S -u user env XDG_RUNTIME_DIR=/run/user/$UID1000 systemctl --user is-active sunshine 2>/dev/null)"
echo "=== 4) 端口监听 ==="
echo 1 | sudo -S ss -tlnp 2>/dev/null | grep -E "47990|48010" | head
echo "=== 5) sunshine 进程 ==="
pgrep -af "sunshine$|sunshine /" | head -2
echo "=== 6) 日志关键行 ==="
echo 1 | sudo -S journalctl --user -u sunshine --no-pager -n 15 2>/dev/null | grep -iE "error|fail|listen|bind|encoder|vaapi|drm|/dev/dri|display" | tail -10
echo "=== DONE ==="
'
