#!/bin/bash
echo "=== snap 里 FreeCAD 信息 ==="
snap info freecad 2>/dev/null | head -30
echo "=== DONE ==="
