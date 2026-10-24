#!/usr/bin/env bash
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "$0")/.." && pwd)
while IFS= read -r package; do
  [[ -n "$package" ]] || continue
  if [[ "$package" == zen-browser-bin ]] && pacman -Si zen-browser >/dev/null 2>&1; then
    sudo pacman -S --needed zen-browser
  elif pacman -Si "$package" >/dev/null 2>&1; then
    sudo pacman -S --needed "$package"
  else
    helper=
    if command -v paru >/dev/null; then helper=paru
    elif command -v yay >/dev/null; then helper=yay
    elif pacman -Si paru >/dev/null 2>&1; then
      sudo pacman -S --needed paru
      helper=paru
    else
      echo "No AUR helper available for $package. Install paru/yay and rerun --aur." >&2
      exit 1
    fi
    "$helper" -S --needed "$package"
  fi
done < <(sed -E 's/#.*//; /^[[:space:]]*$/d' "$repo_dir/packages/aur.txt")
