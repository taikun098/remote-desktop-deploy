#!/bin/bash
set -e
echo "=== 停止服务 ==="
systemctl stop rustdesk.service
sleep 2
echo "=== 写 RustDesk2.toml (root + lightdm) via heredoc ==="
cat > /root/.config/rustdesk/RustDesk2.toml <<'TOML'
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
TOML
cp /root/.config/rustdesk/RustDesk2.toml /var/lib/lightdm/.config/rustdesk/RustDesk2.toml
chmod 600 /root/.config/rustdesk/RustDesk2.toml /var/lib/lightdm/.config/rustdesk/RustDesk2.toml
echo "=== 确认（含引号）==="
grep -E 'rendezvous_server|relay_server|api_server|custom-rendezvous|^key =|verification|allow-linux' /root/.config/rustdesk/RustDesk2.toml | sed -E "s/(^key = .*)/key=[REDACTED]/"
echo "=== TOML 校验 ==="
python3 -c "import tomllib; tomllib.loads(open('/root/.config/rustdesk/RustDesk2.toml',encoding='utf-8').read()); print('TOML 合法')"
echo "=== 启动 ==="
systemctl start rustdesk.service
sleep 22
echo "=== 状态 ==="
systemctl is-active rustdesk.service
echo "=== 21116? ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "(21116 TCP 未监听)"
ss -ulnp 2>/dev/null | grep 21116 || echo "(21116 UDP 未监听)"
echo "=== rustdesk 到 yc 连接 ==="
ss -tnp 2>/dev/null | grep -iE '36.102.85.112|:21116' | grep -i rustdesk | head || echo "(未见 rustdesk 连 yc:21116)"
echo "=== rustdesk 所有监听 ==="
ss -tlnp 2>/dev/null | grep rustdesk || echo "(无 rustdesk tcp)"
echo "=== 日志网络/错误 ==="
tail -50 /root/.local/share/logs/RustDesk/service/rustdesk_rCURRENT.log 2>/dev/null | grep -iE 'rendezvous|connect|relay|2111|error|yc\.' | tail -10 || echo "(日志无网络行)"
echo "=== DONE ==="
