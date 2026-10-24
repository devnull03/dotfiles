#!/usr/bin/env bash
set -euo pipefail
if systemctl is-active --quiet tlp.service || systemctl is-active --quiet tuned.service; then
  echo 'An alternative power manager is active. Resolve that before enabling power-profiles-daemon.' >&2
  exit 1
fi
for service in NetworkManager.service bluetooth.service power-profiles-daemon.service asusd.service supergfxd.service; do
  if systemctl cat "$service" >/dev/null 2>&1; then
    state=$(systemctl is-enabled "$service" 2>/dev/null || true)
    if [[ "$state" == static ]]; then
      sudo systemctl start "$service"
    else
      sudo systemctl enable --now "$service"
    fi
  fi
done
echo 'Installed services enabled. No GPU mode, bus IDs, fan curves or charge limits changed.'
