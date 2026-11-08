#!/bin/bash
timeout 40 bash -c '
echo "=== 删除损坏行（孤立的 1）==="
echo 1 | sudo -S sed -i "/^1$/d" /etc/fstab
echo "=== 用正确方式追加 linglong bind 挂载 ==="
if ! grep -q "/data/linglong /var/lib/linglong" /etc/fstab 2>/dev/null; then
  echo 1 | sudo -S bash -c '\''echo "/data/linglong /var/lib/linglong none bind 0 0" >> /etc/fstab'\''
  echo "已追加"
else
  echo "已存在"
fi
echo "=== 修复后 fstab（带行号+字段数）==="
cat -n /etc/fstab
echo "--- 字段校验 ---"
awk "{n=gsub(/[^ ]+/,\" \"); printf \"行%d: %d 字段\n\", NR, n}" /etc/fstab | grep -E "行.*: [012] 字段" || echo "(无坏行)"
echo 1 | sudo -S systemctl daemon-reload 2>/dev/null
echo 1 | sudo -S systemctl daemon-reload 2>/dev/null
echo "=== 验证 linglong 挂载持久化 ==="
grep linglong /etc/fstab
findmnt /var/lib/linglong -o TARGET,SOURCE 2>/dev/null
echo "=== snapd 能否解析 fstab（不再报错）==="
snap run --help >/dev/null 2>/tmp/snaptest.err; grep -i "cannot parse" /tmp/snaptest.err && echo "仍报错" || echo "fstab 解析正常 ✅"
echo "=== DONE ==="
'
