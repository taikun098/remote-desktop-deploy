#!/bin/bash
set -e
CFG=/var/lib/lightdm/.config/rustdesk/RustDesk.toml
echo "=== 当前 lightdm 配置结构（隐藏密钥）==="
sudo -n cat "$CFG" | sed -E 's/(key_pair\s*=.*)/key_pair=[REDACTED]/; s/(password\s*=.*)/password=****** s/(salt\s*=.*)/salt=[REDACTED]/'
echo "=== 备份 ==="
sudo -n cp "$CFG" "$CFG.bak.$(date +%s)" && echo "backup ok"
echo "=== 插入网络配置 ==="
sudo -n python3 - <<'PYEOF'
p="/var/lib/lightdm/.config/rustdesk/RustDesk.toml"
s=open(p, encoding="utf-8").read()
new="""rendezvous_server = "yc.445800773.xyz"
relay_server = "yc.445800773.xyz"
api_server = "http://yc.445800773.xyz:21114"
key = "Or36bSikmefnl+vTHhlXeuPcZq8VaxRLJJdzSlMlI9M="

"""
if "rendezvous_server" in s:
    print("already has rendezvous_server")
else:
    if "[keys_confirmed]" in s:
        s = s.replace("[keys_confirmed]", new + "[keys_confirmed]", 1)
    else:
        s += new
    open(p,"w",encoding="utf-8").write(s)
    print("inserted into lightdm config")
PYEOF
echo "=== 确认（隐藏 key）==="
sudo -n grep -E 'rendezvous_server|relay_server|api_server|key =' "$CFG" | sed -E 's/(key = .*)/key=[REDACTED]/'
echo "=== 重启 rustdesk ==="
sudo -n systemctl restart rustdesk.service
sleep 15
echo "=== 服务 ==="
systemctl is-active rustdesk.service
echo "=== 21116 监听? ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "(21116 TCP 未监听)"
ss -ulnp 2>/dev/null | grep 21116 || echo "(21116 UDP 未监听)"
echo "=== 全部 rustdesk 端口 ==="
ss -tlnp 2>/dev/null | grep rustdesk
echo "=== 端口连接方向（是否连到 yc 21116）==="
ss -tnp 2>/dev/null | grep -iE '445800773|36.102.85.112|:21116' | head -5 || echo "(未见对外 21116 连接)"
echo "=== DONE ==="
