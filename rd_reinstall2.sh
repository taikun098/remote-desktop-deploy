#!/bin/bash
DEB=/tmp/rustdesk-1.5.0-x86_64.deb
echo "=== 重新安装并捕获完整错误 ==="
sudo -n dpkg -i "$DEB" 2>&1 | grep -viE 'trigger|bamf|desktop-file|hicolor|index' | tail -40
echo "=== exit: dpkg 结果 ==="
dpkg -l | grep -i rustdesk || echo "(未安装)"
echo "=== 若失败尝试 --configure -a ==="
sudo -n dpkg --configure -a 2>&1 | tail -10
echo "=== 包是否完整解包 ==="
ls -la /usr/share/rustdesk/rustdesk 2>/dev/null || echo "(rustdesk 二进制不存在)"
echo "=== DONE ==="
