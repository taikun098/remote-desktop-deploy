#!/bin/bash
set -e
echo "=== 检查显示情况 ==="
echo "DISPLAY 环境: $DISPLAY"
ls /tmp/.X11-unix/ 2>/dev/null
ps -eo pid,args | grep -E '[X]org|[X]vfb' | head -5
echo "=== 写 root 配置（顶层+[options] custom-* 双写）==="
sudo -n python3 - <<'PYEOF'
p="/root/.config/rustdesk/RustDesk.toml"
s=open(p, encoding="utf-8").read()
add="""rendezvous_server = "yc.445800773.xyz:21116"
relay_server = "yc.445800773.xyz:21116"
api_server = "http://yc.445800773.xyz:21114"
key = "Or36bSikmefnl+vTHhlXeuPcZq8VaxRLJJdzSlMlI9M="

[options]
custom-rendezvous-server = "yc.445800773.xyz:21116"
custom-relay-server = "yc.445800773.xyz:21116"
custom-api-server = "http://yc.445800773.xyz:21114"
custom_key = "Or36bSikmefnl+vTHhlXeuPcZq8VaxRLJJdzSlMlI9M="

"""
if "custom-rendezvous-server" in s or "rendezvous_server" in s:
    print("已有 rendezvous，跳过")
else:
    # 去掉可能存在的 [options]/[keys_confirmed] 表头之后的键，统一插到文件末尾的表前
    s = s.rstrip("\n") + "\n" + add
    open(p,"w",encoding="utf-8").write(s)
    print("已写入 root 配置")
PYEOF
echo "=== 确认（隐藏 key）==="
sudo -n grep -E 'rendezvous_server|relay_server|api_server|key =|custom-' /root/.config/rustdesk/RustDesk.toml | sed -E 's/(key = .*)/key=[REDACTED]/; s/(custom_key.*)/custom_key=[REDACTED]/'
echo "=== 重启 ==="
sudo -n systemctl restart rustdesk.service
sleep 15
echo "=== 21116? ==="
ss -tlnp 2>/dev/null | grep 21116 || echo "(21116 TCP 未监听)"
ss -ulnp 2>/dev/null | grep 21116 || echo "(21116 UDP 未监听)"
echo "=== rustdesk 到 yc 的连接 ==="
ss -tnp 2>/dev/null | grep -iE '36.102.85.112|:21116' | grep -i rustdesk | head -5 || echo "(未见 rustdesk 连 yc:21116)"
echo "=== 所有 rustdesk 监听 ==="
ss -tlnp 2>/dev/null | grep rustdesk
echo "=== DONE ==="
