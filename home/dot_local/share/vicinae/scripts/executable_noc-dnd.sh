#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Toggle Do Not Disturb
# @vicinae.mode silent
# @vicinae.packageName Noctalia
# @vicinae.icon 🌙
# @vicinae.keywords ["$", "noctalia"]

swaync-client -d -sw >/dev/null && echo "Do Not Disturb: $(swaync-client -D -sw)"
