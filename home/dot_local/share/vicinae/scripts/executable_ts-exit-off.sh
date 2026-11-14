#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Exit Node Off
# @vicinae.mode silent
# @vicinae.packageName Tailscale
# @vicinae.icon 🔒
# @vicinae.keywords ["ts", "tailscale", "vpn"]

tailscale set --exit-node= && echo "Exit node off"
