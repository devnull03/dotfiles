#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Tailscale Status
# @vicinae.mode inline
# @vicinae.packageName Tailscale
# @vicinae.icon 🔒
# @vicinae.keywords ["ts", "tailscale", "vpn"]
# @vicinae.refreshTime 1m

exec "$(dirname "$0")/.ts-exit-node.py" --status
