#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Copy Tailscale IP
# @vicinae.mode silent
# @vicinae.packageName Tailscale
# @vicinae.icon 🔒
# @vicinae.keywords ["ts", "tailscale", "vpn"]

ip=$(tailscale ip -4) && printf %s "$ip" | wl-copy && echo "Copied $ip"
