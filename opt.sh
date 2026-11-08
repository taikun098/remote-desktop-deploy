#!/bin/bash
echo "=== 优化前磁盘 ==="
df -h / /home /data 2>/dev/null | head -5
echo "=== apt 清理（autoremove 旧依赖 + 清缓存）==="
echo 1 | sudo -S apt-get autoremove -y 2>&1 | tail -3
echo 1 | sudo -S apt-get autoclean 2>&1 | tail -2
echo "=== 清理临时文件/日志（保守）==="
echo 1 | sudo -S journalctl --vacuum-time=3d 2>&1 | tail -2
echo "=== 确认核心服务健康 ==="
for s in rustdesk novnc vnc easytier; do printf "%s:%s " "$s" "$(systemctl is-active $s)"; done; echo
echo "=== 中文会话确认 ==="
sudo -u user bash -lc 'echo "LANG=$LANG"; echo "IM=$GTK_IM_MODULE"' 2>/dev/null
echo "=== fcitx5 在跑 ==="
pgrep -fc 'fcitx5' && echo "fcitx5 运行中" || echo "fcitx5 未运行"
echo "=== Edge 可用 ==="
microsoft-edge --version 2>&1
echo "=== 磁盘空间（优化后）==="
df -h / /home /data 2>/dev/null | tail -3
echo "=== DONE ==="
