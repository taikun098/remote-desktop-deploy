#!/bin/bash
echo "=== 当前物理屏/会话 ==="
who 2>/dev/null | head
echo "--- lightdm 会话 ---"
ps -eo user,pid,args | grep -E '[l]ightdm|[g]dm|[X]org|[x]org|[X]vfb' | head -5
echo "=== X socket ==="
ls -la /tmp/.X11-unix/ 2>/dev/null
echo "=== 各候选 XAUTHORITY ==="
ls -la /home/user/.Xauthority 2>/dev/null || echo "(无 /home/user/.Xauthority)"
ls -la /run/user/1000/gdm/Xauthority /var/run/lightdm/root/:0 /run/user/1000/.mutter-Xwaylandauth.* 2>/dev/null
echo "=== xauthority 里有哪些 display ==="
for f in /home/user/.Xauthority /run/user/1000/gdm/Xauthority /var/run/lightdm/root/:0; do
  [ -f "$f" ] && echo "$f:" && echo 1 | sudo -S xauth -f "$f" list 2>/dev/null | head -3
done
echo "=== 用一个简单 GTK 程序测哪个 auth 能连 :0 ==="
which zenity gtk-demo xclock 2>/dev/null | head
echo "=== orcaslicer 启动方式(直接 AppImage) ==="
ls -lh /opt/orcaslicer/OrcaSlicer.AppImage 2>/dev/null
file /opt/orcaslicer/OrcaSlicer.AppImage 2>/dev/null | head -1
echo "=== DONE ==="
