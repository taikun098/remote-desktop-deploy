#!/bin/bash
echo "=== Steam 单元 ==="
systemctl is-active steam-install
echo "--- steam.log 尾 ---"
tail -8 /tmp/steam.log 2>/dev/null
echo "=== FreeCAD 单元 ==="
systemctl is-active fc-dl
echo "--- fc_dl.log 尾 ---"
tail -8 /tmp/fc_dl.log 2>/dev/null
echo "=== 校验点 ==="
grep -h -oE 'STEAM_DONE|FC_DONE|DOWNLOAD_FAIL|EXTRACT_FAIL|SHA_FAIL' /tmp/steam.log /tmp/fc_dl.log 2>/dev/null | sort -u
echo "=== DONE ==="
