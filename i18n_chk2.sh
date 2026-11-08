#!/bin/bash
echo "=== /etc/default/locale (系统默认) ==="
cat /etc/default/locale 2>/dev/null
echo "=== user 的 LANG ==="
echo 1 | sudo -S -u user bash -c 'echo "LANG=$LANG LC_ALL=$LC_ALL"'
echo "=== 当前 locale ==="
locale 2>/dev/null | head -3
echo "=== 已生成的中文 locale ==="
locale -a 2>/dev/null | grep -iE 'zh_CN|zh\.' || echo "(无 zh locale)"
echo "=== 已装语言包 ==="
dpkg -l 2>/dev/null | grep -iE 'language-pack-zh|language-selector|locales' | awk '{print $2,$3}'
echo "=== lightdm/登录屏语言 ==="
grep -riE '^lang|^language' /etc/lightdm/ 2>/dev/null
echo "=== DONE ==="
