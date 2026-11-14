#!/usr/bin/env bash
# Dual-boot: import Windows Bluetooth pairings into Linux on every boot.
set -euo pipefail
src="$(cd "$(dirname "$0")/.." && pwd)/system/bt-windows-sync"
sudo pacman -S --needed --noconfirm chntpw
sudo install -Dm755 "$src/bt-windows-sync" /usr/local/bin/bt-windows-sync
sudo install -Dm644 "$src/bt-windows-sync.service" /etc/systemd/system/bt-windows-sync.service
sudo systemctl daemon-reload
sudo systemctl enable bt-windows-sync.service
echo 'Enabled. Pair new devices in Windows last; run "sudo bt-windows-sync --restart" to import now.'
