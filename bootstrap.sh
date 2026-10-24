#!/usr/bin/env bash
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "$0")" && pwd)
apply=false
extras=false
aur=false
system=false
boot_menu=false
login_shell=false
usage() {
  cat <<'EOF'
Usage: bash bootstrap.sh [--apply] [--full] [options]
Without --apply, print the plan without changing the machine.
  --full          Enable extras, AUR apps, system services, boot menu and zsh login
  --extras        Add packages/optional-repo.txt (Waybar installed, not started)
  --aur           Add packages/aur.txt, preferring repository packages
  --system        Enable installed laptop/Bluetooth/power services
  --boot-menu     Scan for Windows and set Limine's menu timeout to 10 seconds
  --login-shell   Make zsh the current user's login shell
  --apply         Perform the selected setup on installed CachyOS
EOF
}
for option in "$@"; do
  case "$option" in
    --apply) apply=true ;;
    --dry-run) apply=false ;;
    --full) extras=true; aur=true; system=true; boot_menu=true; login_shell=true ;;
    --extras) extras=true ;;
    --aur) aur=true ;;
    --system) system=true ;;
    --boot-menu) boot_menu=true ;;
    --login-shell) login_shell=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $option" >&2; usage >&2; exit 2 ;;
  esac
done
read_manifest() { sed -E 's/#.*//; /^[[:space:]]*$/d' "$1"; }
mapfile -t packages < <(read_manifest "$repo_dir/packages/repo.txt")
if $extras; then
  mapfile -t more_packages < <(read_manifest "$repo_dir/packages/optional-repo.txt")
  packages+=("${more_packages[@]}")
fi
printf 'CachyOS setup from %s\nRepository packages:\n' "$repo_dir"
printf '  %s\n' "${packages[@]}"
printf 'Debian zsh, tmux/workmux and LazyVim; shared Windows Git/Zed preferences.\n'
printf 'Extras=%s AUR=%s system=%s boot-menu=%s login-shell=%s\n' \
  "$extras" "$aur" "$system" "$boot_menu" "$login_shell"
if ! $apply; then
  if $aur; then printf 'AUR/repo candidates:\n'; read_manifest "$repo_dir/packages/aur.txt"; fi
  echo 'Plan only. Add --apply to run. No partition, graphics-mode or Niri-shell changes.'
  exit 0
fi
[[ $(id -u) -ne 0 ]] || { echo 'Run as your normal user, not root.' >&2; exit 1; }
[[ ! -d /run/archiso ]] || { echo 'Run after booting the installed OS, not the live ISO.' >&2; exit 1; }
. /etc/os-release
[[ ${ID:-} == cachyos ]] || { echo 'This installer is for CachyOS.' >&2; exit 1; }
[[ $(uname -m) == x86_64 ]] || { echo 'This release bundle targets x86_64.' >&2; exit 1; }
command -v pacman >/dev/null
for package in "${packages[@]}"; do
  [[ "$package" =~ ^[a-zA-Z0-9@._+-]+$ ]] || { echo "Invalid package: $package" >&2; exit 1; }
  pacman -Si "$package" >/dev/null 2>&1 || {
    echo "Package unavailable: $package. Check configured repositories and run a full system update." >&2
    exit 1
  }
done
sudo pacman -Syu --needed "${packages[@]}"

backup_dir="$HOME/.local/share/cachyos-dotfiles/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
for relative in .zshrc .tmux.conf .gitconfig .config/tmux/workmux.conf \
  .config/workmux/config.yaml .config/kitty/kitty.conf .config/zed/keymap.json \
  .config/omz-custom .config/chezmoi/chezmoi.toml; do
  if [[ -e "$HOME/$relative" || -L "$HOME/$relative" ]]; then
    mkdir -p "$backup_dir/$(dirname -- "$relative")"
    cp -a -- "$HOME/$relative" "$backup_dir/$relative"
  fi
done
bash "$repo_dir/scripts/install-sources.sh"
bash "$repo_dir/scripts/install-workmux.sh"
chezmoi --source "$repo_dir" init --apply
if [[ ! -e "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
  mkdir -p "$HOME/.config"
  cp -a "$repo_dir/assets/nvim" "$HOME/.config/nvim"
  chmod -R u+w "$HOME/.config/nvim"
else
  echo 'Existing Neovim configuration preserved; the Debian snapshot is in assets/nvim.'
fi
if ! $aur; then
  echo 'Zen browser and supergfxctl are optional; add --aur to include them.'
else
  bash "$repo_dir/scripts/install-optional.sh"
fi
if $system; then bash "$repo_dir/scripts/configure-system.sh"; fi
if $boot_menu; then bash "$repo_dir/scripts/configure-boot-menu.sh"; fi
if $login_shell && [[ $(getent passwd "$(id -un)" | cut -d: -f7) != "$(command -v zsh)" ]]; then
  chsh -s "$(command -v zsh)"
fi
printf '\nSetup complete. Existing config backup: %s\n' "$backup_dir"
printf 'Open a new zsh shell, then tmux. Alt+A is the prefix; D opens workmux.\n'
printf 'Niri and its installed shell were preserved. Log in to your browser and agent CLI separately.\n'
