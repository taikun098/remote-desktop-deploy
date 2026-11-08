#!/bin/bash
timeout 40 bash -c '
echo "=== 1) 在 :0 桌面启动 Hidamari（后台保持）==="
echo 1 | sudo -S -u user env DISPLAY=:0 XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
  nohup flatpak run io.github.jeffshee.Hidamari >/tmp/hid_run.log 2>&1 &
sleep 6
echo "--- Hidamari 进程 ---"
pgrep -af "Hidamari|hidamari" | grep -v "bash -c" | head -2
echo "=== 2) 运行日志 ==="
tail -8 /tmp/hid_run.log 2>/dev/null
echo "=== 3) 配置文件 ==="
ls -la /home/user/.config/Hidamari/ 2>/dev/null
echo "--- config.json 内容 ---"
cat /home/user/.config/Hidamari/config.json 2>/dev/null | head -60
echo "=== DONE ==="
'
