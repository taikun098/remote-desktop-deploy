#!/bin/bash
# 禁用自动休眠/挂起，让 g01 成为常开远程机（可逆：systemctl unmask 恢复）
set -e
echo "=== 1) 屏蔽 sleep/suspend/hibernate 目标 ==="
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
echo "masked:"
systemctl is-enabled sleep.target suspend.target hibernate.target hybrid-sleep.target 2>/dev/null || true

echo "=== 2) logind 忽略电源/合盖/空闲动作 ==="
LOGIND=/etc/systemd/logind.conf
# 仅当未设置时追加/取消注释关键项（幂等）
set_opt() {
  local key="$1"; local val="$2"
  if grep -qE "^${key}=" "$LOGIND"; then
    sed -i "s|^${key}=.*|${key}=${val}|" "$LOGIND"
  elif grep -qE "^#${key}=" "$LOGIND"; then
    sed -i "s|^#${key}=.*|${key}=${val}|" "$LOGIND"
  else
    echo "${key}=${val}" >> "$LOGIND"
  fi
}
set_opt HandleSuspendKey ignore
set_opt HandleLidSwitch ignore
set_opt HandleLidSwitchExternalPower ignore
set_opt HandleLidSwitchDocked ignore
set_opt IdleAction ignore
systemctl restart systemd-logind
echo "logind done"

echo "=== 3) xfce4 电源管理器：空闲不休眠 ==="
DISPLAY=:1 XAUTHORITY=/home/user/.Xauthority xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-sleep-mode -s 0 -n -t int 2>/dev/null || echo "(set inactivity-sleep-mode=0, or already)"
DISPLAY=:1 XAUTHORITY=/home/user/.Xauthority xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-ac -s 0 -n -t int 2>/dev/null || true
DISPLAY=:1 XAUTHORITY=/home/user/.Xauthority xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/general-save-on-battery -s false -n -t bool 2>/dev/null || true

echo "=== 4) 验证：挂起目标已不可用 ==="
systemctl list-unit-files --state=masked 2>/dev/null | grep -iE 'sleep|suspend|hibernate' || echo "(已屏蔽)"
echo "=== 5) 当前挂起目标状态 ==="
systemctl status suspend.target 2>&1 | head -2
echo "=== done ==="
