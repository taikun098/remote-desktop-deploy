#!/bin/bash
echo "=== DNS 解析 ==="
for h in yc.445800773.xyz 60.31.207.20; do
  r=$(timeout 5 getent ahostsv4 "$h" | head -1)
  echo "$h -> ${r:-FAIL}"
done
echo "=== 节点 11011 端口可达性 ==="
for t in "60.31.207.20 11011" "yc.445800773.xyz 11011"; do
  ip=${t% *}; port=${t##* }
  if timeout 6 bash -c "cat < /dev/null > /dev/tcp/$ip/$port" 2>/dev/null; then echo "$ip:$port OK"; else echo "$ip:$port FAIL"; fi
done
echo "=== 延长运行 easytier 40s，观察连接 ==="
rm -f /tmp/et_test2.log
nohup /usr/local/bin/easytier-core --network-name lw --network-secret 'admin@8897802' -i 10.1.0.20 \
  -p tcp://60.31.207.20:11011 tcp://yc.445800773.xyz:11011 --instance-name g01 --multi-thread true --bind-device true \
  > /tmp/et_test2.log 2>&1 &
EPID=$!
sleep 40
echo "=== 40s 后 peer 状态 ==="
timeout 8 /usr/local/bin/easytier-cli peer 2>&1 | head -20
echo "=== 日志中关键行（连接/错误/auth/secret）==="
grep -iE 'connect.*error|auth|secret|network|handshake|fail|refus|timeout' /tmp/et_test2.log | tail -20
echo "=== 日志尾部 ==="
tail -6 /tmp/et_test2.log
echo "=== 清理 ==="
kill $EPID 2>/dev/null; sleep 1; pkill -f 'easytier-core' 2>/dev/null || true
echo done
