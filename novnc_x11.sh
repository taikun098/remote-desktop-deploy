#!/bin/bash
echo "=== 是否有 x11vnc 相关 systemd 单元 ==="
systemctl list-unit-files 2>/dev/null | grep -iE 'vnc|novnc'
ls -l /etc/systemd/system/*vnc* 2>/dev/null
echo "=== x11vnc.service 内容（若有）==="
cat /etc/systemd/system/x11vnc.service 2>/dev/null || echo "(无 x11vnc.service)"
echo "=== 密码文件 ==="
ls -l /etc/x11vnc.pass 2>/dev/null
echo "=== 是否有 autostart / rc.local 启动 x11vnc ==="
grep -rn 'x11vnc' /etc/rc.local /etc/lightdm /etc/xdg/autostart /home/user/.config/autostart 2>/dev/null | head
echo "=== 手动起一次 x11vnc 看报错 ==="
timeout 4 x11vnc -display :0 -auth guess -nopw -o /tmp/x11vnc_test.log 2>&1 | tail -5; echo "--- log ---"; tail -5 /tmp/x11vnc_test.log 2>/dev/null
echo "=== DONE ==="
