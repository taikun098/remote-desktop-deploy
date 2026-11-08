#!/bin/bash
echo "=== 开机自启服务总览（active/enabled）==="
for s in rustdesk novnc vnc easytier ssh lightdm; do
  printf "%-10s active=%s enabled=%s\n" "$s" "$(systemctl is-active $s)" "$(systemctl is-enabled $s 2>/dev/null)"
done
echo "=== 端口监听总览 ==="
ss -tlnp 2>/dev/null | grep -E '5900|6080|21118|22 ' | awk '{print $4, $6}'
echo "=== 系统健康 ==="
uptime
echo "最近 dmesg 错误（过滤关键）:"
sudo dmesg --level=err 2>/dev/null | tail -5 || echo "(无)"
echo "=== 中文环境固化确认 ==="
grep LANG /etc/default/locale | head -1
sudo -u user bash -lc 'echo "会话LANG=$LANG IM=$GTK_IM_MODULE"' 2>/dev/null
pgrep -fc fcitx5 >/dev/null && echo "fcitx5: 运行中" || echo "fcitx5: 未运行"
echo "=== 网络（EasyTier + 关键 IP）==="
ip addr show tun0 2>/dev/null | grep 'inet 10.1.0.20' && echo "tun0 10.1.0.20 OK"
echo "=== 磁盘 ==="
df -h / 2>/dev/null | tail -1
echo "=== 内存 ==="
free -h | head -2
echo "=== DONE ==="
