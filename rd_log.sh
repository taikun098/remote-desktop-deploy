#!/bin/bash
echo "=== rustdesk 日志目录 ==="
ls -la /var/lib/lightdm/.config/rustdesk/log/ 2>/dev/null || echo "(无)"
ls -la /root/.config/rustdesk/log/ 2>/dev/null || echo "(root 无)"
echo "=== lightdm rustdesk 日志尾部（连接/rendezvous/错误）==="
for f in /var/lib/lightdm/.config/rustdesk/log/*.log /root/.config/rustdesk/log/*.log; do
  [ -f "$f" ] && echo "--- $f ---" && sudo -n tail -30 "$f" | grep -iE 'rendezvous|server|connect|error|fail|relay|2111|register' | tail -15
done
echo "=== rustdesk 对外连接（到哪）==="
ss -tnp 2>/dev/null | grep -iE 'rustdesk|:2111' | head -10 || echo "(无 rustdesk 对外连接)"
echo "=== 是否有到 36.102.85.112 或 yc 的 rustdesk 连接 ==="
ss -tnp 2>/dev/null | grep -iE '445800773|36.102.85.112' | head -10 || echo "(无到 yc 的连接)"
echo "=== DONE ==="
