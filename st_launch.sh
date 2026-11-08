# 重启 Steam：env -i 干净环境 + setsid 独立进程，走正常网络
export DISPLAY=:0
echo 1 | sudo -S -u user env -i \
  HOME=/home/user DISPLAY=:0 XAUTHORITY=/home/user/.Xauthority \
  USER=user PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  /usr/games/steam -nobigpicture \
  >/tmp/steam_clean.log 2>&1 </dev/null &
disown 2>/dev/null
sleep 12
echo "launched. steam PIDs:"
pgrep -f "ubuntu12_32/steam " | head -1
tail -3 /tmp/steam_clean.log 2>/dev/null
