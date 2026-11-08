#!/bin/bash
echo "=== sudo 解包 OrcaSlicer ==="
echo 1 | sudo -S rm -rf /opt/orcaslicer/squashfs-root 2>/dev/null
cd /opt/orcaslicer
echo 1 | sudo -S env APPIMAGE_EXTRACT_AND_RUN=1 ./OrcaSlicer.AppImage --appimage-extract >/tmp/orca_x3.log 2>&1
echo "extract_exit=$?"
echo "=== 解包结果 ==="
ls /opt/orcaslicer/squashfs-root 2>/dev/null | head -8
echo "--- 找主可执行 ---"
BIN=$(find /opt/orcaslicer/squashfs-root -type f -executable 2>/dev/null | grep -iE '/bin/|orca' | grep -vE '\.so' | head -1)
echo "BIN=$BIN"
echo "--- AppRun 内容 ---"
cat /opt/orcaslicer/squashfs-root/AppRun 2>/dev/null | head -20
echo "=== 写启动器指向解包二进制 ==="
echo 1 | sudo -S rm -f /usr/local/bin/orcaslicer 2>/dev/null
if [ -n "$BIN" ]; then
  echo 1 | sudo -S bash -c "echo '#!/bin/bash' > /usr/local/bin/orcaslicer; echo 'exec $BIN \"\\\$@\"' >> /usr/local/bin/orcaslicer; chmod +x /usr/local/bin/orcaslicer"
  cat /usr/local/bin/orcaslicer
fi
echo "=== 测试启动（:0, 12秒）==="
export DISPLAY=:0
echo 1 | sudo -S -u user env DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  timeout 12 /usr/local/bin/orcaslicer 2>/tmp/orca_f2.log; echo "launch_exit=$?"
pgrep -af -i orca-slicer | grep -v bash | head -2 || echo "(无 orca 进程)"
tail -4 /tmp/orca_f2.log 2>/dev/null
echo "=== DONE ==="
