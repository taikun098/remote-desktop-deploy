#!/bin/bash
for i in $(seq 1 60); do
  ST=$(snap changes 2>/dev/null | grep -iE 'install.*freecad' | awk '{print $2}' | head -1)
  if [ -z "$ST" ] || [ "$ST" = "Done" ]; then break; fi
  if [ "$ST" = "Error" ]; then echo "SNAP_ERROR"; break; fi
  sleep 15
done
echo "=== snap 安装结果 ==="
snap list freecad 2>/dev/null
snap changes 2>/dev/null | grep -i freecad | tail -2
echo "=== DONE ==="
