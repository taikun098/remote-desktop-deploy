#!/bin/bash
echo "=== 当前 rustdesk 进程 ==="
ps -eo pid,user,args | grep '[r]ustdesk' | grep -v check-hwcodec
echo "=== --server 进程的 HOME / XDG ==="
SPID=$(ps -eo pid,args | grep 'rustdesk --server' | grep -v grep | awk '{print $1}' | head -1)
echo "server pid=$SPID"
echo "HOME=$(tr '\0' '\n' < /proc/$SPID/environ 2>/dev/null | grep '^HOME=')"
echo "XDG_CONFIG_HOME=$(tr '\0' '\n' < /proc/$SPID/environ 2>/dev/null | grep '^XDG_CONFIG_HOME=')"
echo "=== lightdm 用户家目录下的 rustdesk 配置 ==="
for d in /home/lightdm/.config/rustdesk /var/lib/lightdm/.config/rustdesk /var/lib/lightdm-data/lightdm/.config/rustdesk /home/lightdm/.rustdesk; do
  echo "--- $d ---"
  sudo -n ls -la "$d" 2>/dev/null || echo "(无)"
done
echo "=== lightdm 用户配置里的网络项 ==="
sudo -n grep -iE 'rendezvous|relay_server|api_server|key =' /home/lightdm/.config/rustdesk/RustDesk.toml /var/lib/lightdm/.config/rustdesk/RustDesk.toml 2>/dev/null | sed -E 's/(key = .*)/key=[REDACTED]/' || echo "(lightdm 配置无网络项)"
echo "=== DONE ==="
