#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Tailscale Disconnect
# @vicinae.mode silent
# @vicinae.packageName Tailscale
# @vicinae.icon 🔒
# @vicinae.keywords ["ts", "tailscale", "vpn"]

tailscale down && echo "Tailscale disconnected"
