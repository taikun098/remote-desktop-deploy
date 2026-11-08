#!/bin/bash
echo "=== 经代理 verbose 测 GitHub deb ==="
curl -x http://192.168.0.6:7897 -svL --max-time 25 \
  "https://github.com/HanHan666666/flutter-linglong-store/releases/download/v3.7.0/linglong-store_3.7.0_amd64.deb" \
  -o /tmp/lltest.deb 2>/tmp/llcurl.log
echo "exit=$? size=$(stat -c%s /tmp/lltest.deb 2>/dev/null)"
grep -iE 'connected|http/|error|refused|resolve|404|denied|CONNECT' /tmp/llcurl.log 2>/dev/null | tail -8
rm -f /tmp/lltest.deb
echo "=== 试 Gitee 镜像（国内直连）==="
curl -sL --max-time 20 "https://gitee.com/hanplus/flutter-linglong-store/releases" -o /tmp/gitee.html 2>/dev/null
echo "gitee 页面 exit=$? 大小=$(stat -c%s /tmp/gitee.html 2>/dev/null)"
grep -oP 'linglong-store[^"]*amd64\.deb' /tmp/gitee.html 2>/dev/null | head -3 || echo "(未在页面匹配到 deb 链接)"
echo "=== DONE ==="
