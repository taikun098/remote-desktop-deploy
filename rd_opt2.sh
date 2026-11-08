#!/bin/bash
echo "=== 完整 custom-* 键列表 ==="
grep -aEo 'custom-[a-z0-9-]{2,40}' /usr/share/rustdesk/lib/librustdesk.so 2>/dev/null | sort -u
echo "=== 现测：向 lightdm 配置加 [options] custom-* 键 ==="
CFG=/var/lib/lightdm/.config/rustdesk/RustDesk.toml
sudo -n cp "$CFG" "$CFG.bak2.$(date +%s)"
sudo -n python3 - <<'PYEOF'
p="/var/lib/lightdm/.config/rustdesk/RustDesk.toml"
s=open(p, encoding="utf-8").read()
if "custom-rendezvous-server" in s:
    print("already present")
else:
    opt='''[options]
custom-rendezvous-server = "yc.445800773.xyz"
custom-relay-server = "yc.445800773.xyz"
custom-api-server = "http://yc.445800773.xyz:21114"
custom_key = "Or36bSikmefnl+vTHhlXeuPcZq8VaxRLJJdzSlMlI9M="

'''
    s = s.rstrip("\n") + "\n" + opt
    open(p,"w",encoding="utf-8").write(s)
    print("added [options] custom keys")
PYEOF
echo "=== 确认（隐藏 key）==="
sudo -n grep -A6 '\[options\]' "$CFG" | sed -E 's/(custom_key.*)/custom_key=[REDACTED]/'
echo "=== 重启 ==="
sudo -n systemctl restart rustdesk.service
sleep 15
echo "=== 21116? ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "(21116 TCP 未监听)"
ss -ulnp 2>/dev/null | grep 21116 || echo "(21116 UDP 未监听)"
echo "=== 到 yc 的连接 ==="
ss -tnp 2>/dev/null | grep -iE '445800773|36.102.85.112|:21116' | grep -i rustdesk | head -5 || echo "(未见 rustdesk 到 yc 21116 连接)"
echo "=== DONE ==="
