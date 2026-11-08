#!/bin/bash
set -e
echo "=== 停止服务 ==="
sudo -n systemctl stop rustdesk.service
sleep 2
echo "=== 写 lightdm 配置（同 root 正确格式）==="
sudo -n python3 - <<'PYEOF'
import re
p="/var/lib/lightdm/.config/rustdesk/RustDesk.toml"
s=open(p, encoding="utf-8").read()
s=re.sub(r'\n\[options\].*$', '', s, flags=re.S)
for k in ['rendezvous_server','relay_server','api_server']:
    s=re.sub(rf'^{k} = .*\n', '', s, flags=re.M)
top="""rendezvous_server = 'yc.445800773.xyz:21116'
relay_server = 'yc.445800773.xyz:21116'
api_server = 'http://yc.445800773.xyz:21114'

"""
opt="""[options]
custom-rendezvous-server = 'yc.445800773.xyz'
key = 'Or36bSikmefnl+vTHhlXeuPcZq8VaxRLJJdzSlMlI9M='
verification-method = 'use-permanent-password'
allow-linux-headless = 'Y'
"""
if "[keys_confirmed]" in s:
    s = s.replace("[keys_confirmed]", top + "[keys_confirmed]", 1)
else:
    s = s.rstrip("\n") + "\n" + top
s = s.rstrip("\n") + "\n" + opt + "\n"
open(p,"w",encoding="utf-8").write(s)
print("lightdm 配置已写入")
PYEOF
echo "=== 确认 ==="
sudo -n grep -E 'rendezvous_server|relay_server|api_server|custom-rendezvous|verification|allow-linux|^key =' /var/lib/lightdm/.config/rustdesk/RustDesk.toml | sed -E "s/(^key = .*)/key=[REDACTED]/"
echo "=== 启动 ==="
sudo -n systemctl start rustdesk.service
sleep 20
echo "=== 状态 ==="
systemctl is-active rustdesk.service
echo "=== 21116? ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "(21116 TCP 未监听)"
ss -ulnp 2>/dev/null | grep 21116 || echo "(21116 UDP 未监听)"
echo "=== rustdesk 到 yc 连接 ==="
ss -tnp 2>/dev/null | grep -iE '36.102.85.112|:21116' | grep -i rustdesk | head || echo "(未见 rustdesk 连 yc:21116)"
echo "=== rustdesk 所有监听 ==="
ss -tlnp 2>/dev/null | grep rustdesk || echo "(无 rustdesk tcp)"
echo "=== DONE ==="
