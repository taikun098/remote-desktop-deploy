#!/bin/bash
echo "=== RustDesk.toml 网络配置（rendezvous/relay/direct/host/port）==="
sudo -n cat /root/.config/rustdesk/RustDesk.toml 2>/dev/null | grep -iE 'rendezvous|relay|direct|host|port|id_server|server' | grep -viE 'key|secret|pwd|password|hash' | head -40
echo "=== 文件整体键名（不含值）==="
sudo -n cat /root/.config/rustdesk/RustDesk.toml 2>/dev/null | sed -E 's/=.*//' | grep -E '^\s*[a-z_]+' | head -40
echo "=== DONE ==="
