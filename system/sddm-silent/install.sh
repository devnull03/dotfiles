#!/usr/bin/env bash
# Installs SilentSDDM with a random wallpaper on every greeter start.
# Needs sddm-silent-theme first: paru -S sddm-silent-theme
set -euo pipefail
cd "$(dirname "$0")"
[[ $EUID -eq 0 ]] || exec sudo "$0" "$@"
[[ -d /usr/share/sddm/themes/silent ]] || { echo "install sddm-silent-theme first (paru -S sddm-silent-theme)"; exit 1; }

install -Dm755 sync pick xsetup patch-theme -t /usr/local/lib/sddm-wallpaper/
install -Dm644 sddm-silent-patch.hook /etc/pacman.d/hooks/sddm-silent-patch.hook
[[ -e /etc/sddm-wallpaper.conf ]] || install -Dm644 sddm-wallpaper.conf /etc/sddm-wallpaper.conf
install -Dm644 silent.conf /etc/sddm.conf.d/silent.conf
install -Dm644 sddm-wallpaper-sync.service /etc/systemd/system/sddm-wallpaper-sync.service
systemctl daemon-reload
systemctl enable sddm-wallpaper-sync.service

/usr/local/lib/sddm-wallpaper/patch-theme
/usr/local/lib/sddm-wallpaper/sync
/usr/local/lib/sddm-wallpaper/pick
echo "Done. Preview: cd /usr/share/sddm/themes/silent && ./test.sh"
