#!/bin/bash
echo "=== RustDesk2.toml (root) ==="
sudo -n cat /root/.config/rustdesk/RustDesk2.toml 2>/dev/null | sed -E "s/(key_pair\s*=\s*\[.*)/key_pair=[REDACTED]/g; s/(password\s*=.*)/password=****** s/(salt\s*=.*)/salt=[REDACTED]/" | head -40
echo "=== RustDesk2.toml (lightdm) ==="
sudo -n cat /var/lib/lightdm/.config/rustdesk/RustDesk2.toml 2>/dev/null | sed -E "s/(key_pair\s*=\s*\[.*)/key_pair=[REDACTED]/g; s/(password\s*=.*)/password=****** s/(salt\s*=.*)/salt=[REDACTED]/" | head -40
echo "=== lightdm RustDesk.toml 重启后是否保留 rendezvous ==="
sudo -n grep -cE 'rendezvous_server' /var/lib/lightdm/.config/rustdesk/RustDesk.toml
echo "=== root RustDesk.toml 重启后是否保留 ==="
sudo -n grep -cE 'rendezvous_server' /root/.config/rustdesk/RustDesk.toml
echo "=== 服务日志最后 60 行全文 ==="
sudo -n tail -60 /root/.local/share/logs/RustDesk/service/rustdesk_rCURRENT.log 2>/dev/null
echo "=== 是否有 rustdesk 进程在 /root/.local/share/logs 下的 GUI 日志 ==="
ls -la /root/.config/rustdesk/log 2>/dev/null || ls -la /root/.local/share/logs/RustDesk 2>/dev/null
echo "=== DONE ==="
