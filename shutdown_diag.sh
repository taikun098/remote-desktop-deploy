#!/bin/bash
echo "=== 当前开机时长 ==="
uptime -p
echo "=== 最近几次重启/关机记录 (last) ==="
last -x reboot shutdown 2>/dev/null | head -15
echo "=== 上次关机的日志（休眠/关机/过热/panic 关键词）==="
journalctl -b -1 --no-pager 2>/dev/null | grep -iE 'shutdown|poweroff|suspend|hibernate|sleep|thermal|temperature|critical|panic|reboot|power key' | tail -30
echo "=== systemd logind 电源管理配置 ==="
grep -rE 'HandleLidSwitch|HandlePowerKey|HandleSuspendKey|IdleAction|IdleActionSec|Suspend' /etc/systemd/logind.conf /etc/systemd/logind.conf.d/*.conf 2>/dev/null || echo "(默认配置)"
echo "=== 当前 logind 生效设置 ==="
systemd-inhibit --list --mode=block 2>/dev/null | head -10
loginctl show-session $(loginctl list-sessions --no-legend | awk '{print $1}' | head -1) -p IdleAction -p IdleActionSec -p HandlePowerKey 2>/dev/null || echo "(n/a)"
echo "=== xfce 电源管理器设置（空闲休眠相关）==="
xfconf-query -c xfce4-power-manager -l 2>/dev/null | grep -iE 'inactivity|sleep|suspend|lock|blank' 
echo "=== 定时任务（可能导致关机/休眠）==="
systemctl list-timers --no-pager 2>/dev/null | head -12
crontab -l 2>/dev/null; sudo -n crontab -l 2>/dev/null | head -5
echo "=== 温度 ==="
for z in /sys/class/thermal/thermal_zone*; do
  [ -f "$z/temp" ] && echo "$(basename $z): $(( $(cat $z/temp) / 1000 ))°C  type=$(cat $z/type 2>/dev/null)"
done 2>/dev/null | head -12
echo "=== 内核电源/CPU 相关 dmesg 尾部 ==="
dmesg 2>/dev/null | grep -iE 'thermal|critical|overtemp|acpi' | tail -10 || echo "(无)"
