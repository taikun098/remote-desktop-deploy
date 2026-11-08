#!/bin/bash
echo "=== 经代理下载小文件(SHA256)测试 ==="
curl -x http://192.168.0.6:7897 -svL --max-time 25 \
  "https://github.com/FreeCAD/FreeCAD/releases/download/1.1.4/FreeCAD_1.1.4-Linux-x86_64-py311.AppImage-SHA256.txt" -o /tmp/shachk.txt 2>/tmp/curlv.log
echo "exit=$?"
echo "--- 内容 ---"
cat /tmp/shachk.txt 2>/dev/null | head -3
echo "--- verbose 摘要 ---"
grep -iE 'connected|proxy|http/|error|trying|refused|CONNECT|SSL' /tmp/curlv.log 2>/dev/null | tail -15
echo "=== 尝试 socks5 ==="
curl --socks5-hostname 192.168.0.6:7897 -sL --max-time 15 -o /dev/null -w "socks5速度: %{speed_download} B/s 已下:%{size_download} B\n" \
  "https://github.com/FreeCAD/FreeCAD/releases/download/1.1.4/FreeCAD_1.1.4-Linux-x86_64-py311.AppImage-SHA256.txt" 2>/dev/null
echo "=== DONE ==="
