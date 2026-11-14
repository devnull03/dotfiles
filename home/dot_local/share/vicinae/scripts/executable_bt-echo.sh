#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Connect Echo Pop
# @vicinae.mode silent
# @vicinae.packageName Bluetooth
# @vicinae.icon 🎧
# @vicinae.keywords ["bt", "bluetooth"]

bluetoothctl connect 68:F6:3B:FF:25:EA >/dev/null && echo "Echo Pop connected" || echo "Could not connect Echo Pop"
