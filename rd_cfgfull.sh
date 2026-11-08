#!/bin/bash
set -x
systemctl stop rustdesk.service
sleep 1
cat > /tmp/RustDesk2.toml <<'EOF'
rendezvous_server = 'yc.445800773.xyz:21116'
relay_server = 'yc.445800773.xyz:21116'
api_server = 'http://yc.445800773.xyz:21114'
nat_type = 2
serial = 0
unlock_pin = ''
trusted_devices = ''

[options]
av1-test = 'Y'
local-ip-addr = '192.168.0.20'
custom-rendezvous-server = 'yc.445800773.xyz'
key = 'Or36bSikmefnl+vTHhlXeuPcZq8VaxRLJJdzSlMlI9M='
verification-method = 'use-permanent-password'
allow-linux-headless = 'Y'
EOF
echo "=== 生成的 TOML 内容 ==="
cat /tmp/RustDesk2.toml
cp /tmp/RustDesk2.toml /root/.config/rustdesk/RustDesk2.toml
cp /tmp/RustDesk2.toml /home/user/.config/rustdesk/RustDesk2.toml
echo "=== 校验 root 配置 ==="
cat /root/.config/rustdesk/RustDesk2.toml
echo "=== 重启 rustdesk ==="
systemctl start rustdesk.service
sleep 2
systemctl is-active rustdesk.service
echo "等 80 秒（注册握手）..."
sleep 80
echo "=== 21116 ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "TCP未监听"
ss -ulnp 2>/dev/null | grep 21116 || echo "UDP未监听"
echo "=== --server 日志尾部 10 行 ==="
tail -10 /home/user/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log 2>/dev/null
echo "=== DONE ==="
