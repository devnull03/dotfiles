#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Power Profile
# @vicinae.mode silent
# @vicinae.packageName Noctalia
# @vicinae.icon 🌙
# @vicinae.keywords ["$", "noctalia"]
# @vicinae.argument1 {"type": "text", "placeholder": "performance / balanced / power-saver"}

noctalia msg power-set "$1" && echo "Power profile: $1"
