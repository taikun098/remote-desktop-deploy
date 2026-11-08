#!/bin/bash
set -x
SQUASH=/opt/freecad/squashfs-root
# 0. 旧 freecad 是什么？
echo "=== 旧 /usr/local/bin/freecad ==="
ls -la /usr/local/bin/freecad 2>/dev/null
file /usr/local/bin/freecad 2>/dev/null
# 1. 备份旧 freecad（若非指向 AppImage 的软链）
if [ -e /usr/local/bin/freecad ] && [ ! -L /usr/local/bin/freecad ] && [ ! -e /usr/local/bin/freecad.old ]; then
  mv /usr/local/bin/freecad /usr/local/bin/freecad.old
fi
# 2. 写中文配置脚本
cat > /tmp/fcsetlang.py <<'PY'
import FreeCAD
p = FreeCAD.ParamGet('User parameter:BaseApp/Preferences/General')
p.SetString('Language', 'Chinese (Simplified)')
print('language set')
PY
# 3. 以 user 身份运行 freecadcmd 生成合法 user.cfg
echo 1 | sudo -S -u user env LD_LIBRARY_PATH=$SQUASH/usr/lib HOME=/home/user QT_QPA_PLATFORM=offscreen \
  $SQUASH/usr/bin/freecadcmd /tmp/fcsetlang.py 2>&1 | tail -6
# 4. 验证 user.cfg
echo "=== user.cfg 语言项 ==="
find /home/user/.config/FreeCAD -name user.cfg 2>/dev/null
grep -A2 -i 'Language' $(find /home/user/.config/FreeCAD -name user.cfg 2>/dev/null | head -1) 2>/dev/null | head -6
echo "=== 翻译文件存在？ ==="
ls $SQUASH/usr/share/freecad/translations/ 2>/dev/null | grep -iE 'zh_CN|zh_TW' | head
echo "=== DONE ==="
