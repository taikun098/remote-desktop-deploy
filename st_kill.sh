PIDS=$(pgrep -f "ubuntu12_32/steam|steam.sh" 2>/dev/null)
echo "before: $PIDS"
for p in $PIDS; do echo 1 | sudo -S kill -9 "$p" 2>/dev/null; done
sleep 3
LEFT=$(pgrep -f "ubuntu12_32/steam|steam.sh" 2>/dev/null)
echo "after 剩余: [$LEFT]"
