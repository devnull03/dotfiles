#!/usr/bin/env bash
set -euo pipefail
command -v limine-scan >/dev/null || { echo 'Limine is not installed. Select it in the CachyOS installer.' >&2; exit 1; }
sudo test -f /boot/limine.conf || { echo '/boot/limine.conf is missing.' >&2; exit 1; }
sudo cp -a /boot/limine.conf "/boot/limine.conf.before-dotfiles-$(date +%Y%m%d-%H%M%S)"
sudo limine-scan
if sudo grep -qE '^[[:space:]]*timeout:' /boot/limine.conf; then
  sudo sed -i -E 's/^[[:space:]]*timeout:.*/timeout: 10/' /boot/limine.conf
else
  sudo sed -i '1i timeout: 10' /boot/limine.conf
fi
if ! sudo grep -qi windows /boot/limine.conf; then
  echo 'Windows entry was not found in /boot/limine.conf. Inspect before rebooting.' >&2
  exit 1
fi
echo 'Limine menu timeout is 10 seconds. Verify both CachyOS and Windows entries.'
