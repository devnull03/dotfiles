#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Set Exit Node
# @vicinae.mode silent
# @vicinae.packageName Tailscale
# @vicinae.icon 🔒
# @vicinae.keywords ["ts", "tailscale", "vpn"]
# @vicinae.argument1 {"type": "text", "placeholder": "city or country, e.g. tokyo / japan / off"}

exec "$(dirname "$0")/.ts-exit-node.py" "$1"
