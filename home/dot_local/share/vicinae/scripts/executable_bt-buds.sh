#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Connect Galaxy Buds
# @vicinae.mode silent
# @vicinae.packageName Bluetooth
# @vicinae.icon 🎧
# @vicinae.keywords ["bt", "bluetooth"]

bluetoothctl connect 7C:7B:BF:43:40:89 >/dev/null && echo "Buds connected" || echo "Could not connect Buds"
