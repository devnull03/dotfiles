#!/usr/bin/env bash
# macOS-style desktop settings: MacTahoe icons if installed.
command -v gsettings >/dev/null || exit 0
if [[ -d /usr/share/icons/MacTahoe-dark || -d "$HOME/.local/share/icons/MacTahoe-dark" ]]; then
  gsettings set org.gnome.desktop.interface icon-theme 'MacTahoe-dark'
fi
if [[ -d /usr/share/icons/macOS ]]; then
  gsettings set org.gnome.desktop.interface cursor-theme 'macOS'
  gsettings set org.gnome.desktop.interface cursor-size 24
fi
# Subpixel (ClearType-style) font antialiasing; matches fontconfig rgba=rgb.
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.interface font-rgba-order 'rgb'
gsettings set org.gnome.desktop.interface font-hinting 'slight'
# Slightly heavier UI text (Inter variable at wght 450 instead of 400).
gsettings set org.gnome.desktop.interface font-name 'Inter Variable 11 @wght=450'
gsettings set org.gnome.desktop.interface document-font-name 'Inter Variable 11 @wght=450'
