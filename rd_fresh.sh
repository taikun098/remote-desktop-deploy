#!/bin/bash
echo "=== 新配置目录 ==="
ls -la /root/.config/rustdesk/ 2>/dev/null || echo "(root 无)"
ls -la /var/lib/lightdm/.config/rustdesk/ 2>/dev/null || echo "(lightdm 无)"
echo "=== root RustDesk.toml 结构 ==="
sudo -n cat /root/.config/rustdesk/RustDesk.toml 2>/dev/null | sed -E 's/(key_pair\s*=\s*\[.*)/key_pair=[REDACTED]/; s/(password\s*=.*)/password=****** s/(salt\s*=.*)/salt=[REDACTED]/' | head -40
echo "=== lightdm RustDesk.toml 结构 ==="
sudo -n cat /var/lib/lightdm/.config/rustdesk/RustDesk.toml 2>/dev/null | sed -E 's/(key_pair\s*=\s*\[.*)/key_pair=[REDACTED]/; s/(password\s*=.*)/password=****** s/(salt\s*=.*)/salt=[REDACTED]/' | head -40
echo "=== 服务日志（rendezvous/connect）==="
sudo -n tail -30 /root/.local/share/logs/RustDesk/service/rustdesk_rCURRENT.log 2>/dev/null | grep -iE 'rendezvous|server|connect|relay|2111|error|register|DISPLAY' | tail -15
echo "=== DONE ==="
