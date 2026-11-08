#!/bin/bash
# ============================================================
# 目标：sdc(固态 512G) -> /home   sdd(机械 500G) -> /data
# 两块都格式化为 ext4。警告：会【清空】sdc 和 sdd 上所有数据！
# 只动 /dev/sdc 和 /dev/sdd，绝不碰 sda(系统) / sdb(1.8T)。
# 在服务器终端以 user 运行：bash mount_plan.sh
# ============================================================
set -euo pipefail

say(){ echo ">>> $*"; }
# sudo 用 user 的密码（这里是 '1'，如需改在下面改）
SDPW='1'
run(){ echo "$SDPW" | sudo -S -p '' "$@"; }

# ---------- 0. 核对目标盘，防止误格 ----------
say "核对目标盘（必须：sdc=WXC-R1 512GB，sdd=WD5000AAKX）"
lsblk -o NAME,MODEL,SIZE,FSTYPE | grep -Ei 'NAME|sdc|sdd'
echo "若上面 sdc/sdd 型号不是 WXC-R1 / WD5000AAKX，立刻 Ctrl+C 中止！"
read -r -p "确认无误按回车继续，否则按 Ctrl+C 中止：" _

# ---------- 1. 格式化 sdc (SSD -> /home) ----------
say "清空并格式化 sdc ..."
run wipefs -a /dev/sdc
run parted -s /dev/sdc mklabel gpt
run parted -s /dev/sdc mkpart primary ext4 1MiB 100%
run partprobe /dev/sdc
sleep 2
run mkfs.ext4 -F -L home /dev/sdc1

# ---------- 2. 格式化 sdd (HDD -> /data) ----------
say "清空并格式化 sdd ..."
run wipefs -a /dev/sdd
run parted -s /dev/sdd mklabel gpt
run parted -s /dev/sdd mkpart primary ext4 1MiB 100%
run partprobe /dev/sdd
sleep 2
run mkfs.ext4 -F -L data /dev/sdd1

# ---------- 3. 挂载 + 保留 /home 原有内容 ----------
say "准备挂载点并迁移 /home ..."
run mkdir -p /mnt/ssdnew /data
run mount /dev/sdc1 /mnt/ssdnew
# 把原 /home 内容（含 .ssh）复制到新盘，保证 SSH 密钥登录不丢
run cp -a /home/. /mnt/ssdnew/
run umount /mnt/ssdnew
run mount /dev/sdc1 /home
run mount /dev/sdd1 /data

# ---------- 4. 输出结果与 UUID（用于 fstab） ----------
say "完成，当前磁盘状态："
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,MODEL | grep -Ei 'NAME|sdc|sdd'
say "UUID（记下来，我用来写 fstab）"
echo -n "SDC1_UUID="; sudo blkid -s UUID -o value /dev/sdc1
echo -n "SDD1_UUID="; sudo blkid -s UUID -o value /dev/sdd1
say "全部完成。"
