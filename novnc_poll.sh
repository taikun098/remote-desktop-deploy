#!/bin/bash
# 轮询 novnc-install 是否完成，回读 apt 日志
for i in $(seq 1 30); do
  if ! systemctl is-active novnc-install >/dev/null 2>&1; then
    break
  fi
  sleep 5
done
echo "=== systemd-run 状态 ==="
systemctl is-active novnc-install 2>&1 || echo "已结束"
echo "=== apt 日志尾部 ==="
tail -20 /tmp/novnc_apt.log 2>/dev/null
echo "=== 验证安装 ==="
dpkg -l 2>/dev/null | grep -E 'novnc|websockify'
which websockify 2>/dev/null
ls -d /usr/share/novnc/vnc.html 2>/dev/null
echo "=== DONE ==="
