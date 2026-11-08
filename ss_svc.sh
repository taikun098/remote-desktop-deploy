#!/bin/bash
timeout 40 bash -c '
echo "=== deb 提供的文件 ==="
echo 1 | sudo -S dpkg -L sunshine 2>/dev/null | grep -iE "systemd|\.service|sunshine$"
echo "=== 查找 service 单元 ==="
echo 1 | sudo -S find /etc/systemd /lib/systemd /usr/lib/systemd -iname "*sunshine*" 2>/dev/null
echo "=== systemd 里 sunshine 单元 ==="
echo 1 | sudo -S systemctl list-unit-files 2>/dev/null | grep -i sunshine
echo "=== daemon-reload 后再查 ==="
echo 1 | sudo -S systemctl daemon-reload 2>/dev/null
echo 1 | sudo -S systemctl list-unit-files 2>/dev/null | grep -i sunshine
echo "=== DONE ==="
'
