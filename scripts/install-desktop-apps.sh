#!/usr/bin/env bash
set -euo pipefail

sudo pacman -Syu --needed ghostty
if ! pacman -Qq zen-browser >/dev/null 2>&1 && ! pacman -Qq zen-browser-bin >/dev/null 2>&1; then
  if pacman -Si zen-browser >/dev/null 2>&1; then
    sudo pacman -S --needed zen-browser
  else
    sudo pacman -S --needed paru
    paru -S --needed zen-browser-bin
  fi
fi
if pacman -Qq kitty >/dev/null 2>&1; then
  sudo pacman -R kitty
fi

python - <<'PY'
from pathlib import Path
from datetime import datetime
import shutil

path = Path.home() / '.config/niri/cfg/keybinds.kdl'
if path.exists():
    old = path.read_text()
    new = old.replace('Open Terminal: Alacritty', 'Open Terminal: Ghostty')
    new = new.replace('spawn "alacritty";', 'spawn "ghostty";')
    new = new.replace('Open Browser: firefox', 'Open Browser: Zen')
    new = new.replace('spawn "firefox";', 'spawn "zen-browser";')
    if new != old:
        backup = path.with_name(path.name + '.before-desktop-apps-' + datetime.now().strftime('%Y%m%d-%H%M%S'))
        shutil.copy2(path, backup)
        path.write_text(new)
        print(f'Updated Niri shortcuts; backup: {backup}')
PY
niri validate
printf '\nInstalled Zen and Ghostty; removed Kitty. Super+Return opens Ghostty; Super+B opens Zen.\n'
