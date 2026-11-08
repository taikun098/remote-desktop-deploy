#!/bin/bash
echo "=== 从 g01 测 yc.445800773.xyz (36.102.85.112) 端口可达性 ==="
for p in 21114 21115 21116 21118 21119; do
  if timeout 4 bash -c "cat < /dev/null > /dev/tcp/36.102.85.112/$p" 2>/dev/null; then
    echo "2111$((p%10))... 端口 $p : 可达"
  else
    echo "端口 $p : 不可达/拒绝"
  fi
done
echo "=== DNS 解析 ==="
getent hosts yc.445800773.xyz
echo "=== 21116 TCP 三次握手的 banner（hbbs 握手特征）==="
timeout 4 bash -c 'exec 3<>/dev/tcp/36.102.85.112/21115; head -c 64 <&3 | xxd | head -2' 2>/dev/null || echo "(21115 无 banner)"
echo "=== DONE ==="
