#!/usr/bin/env bash
# macOS-style desktop settings: WhiteSur icons if installed.
command -v gsettings >/dev/null || exit 0
if [[ -d /usr/share/icons/WhiteSur-dark || -d "$HOME/.local/share/icons/WhiteSur-dark" ]]; then
  gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-dark'
fi
if [[ -d /usr/share/icons/macOS ]]; then
  gsettings set org.gnome.desktop.interface cursor-theme 'macOS'
  gsettings set org.gnome.desktop.interface cursor-size 24
fi
