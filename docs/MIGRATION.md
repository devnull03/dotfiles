# Sources and migration choices

Captured on 2026-10-23.

| Configuration | Source |
| --- | --- |
| zsh theme/plugins, aliases, completion and vi/fzf behavior | Live Debian WSL /home/dvnl/.zshrc and ~/.oh-my-zsh |
| tmux theme and pane titles | Live Debian ~/.tmux.conf and ~/.config/tmux/workmux.conf |
| workmux layout | Live Debian ~/.config/workmux/config.yaml |
| LazyVim | Live Debian ~/.config/nvim |
| Git identity and URL preference | windows branch dot_gitconfig |
| Zed keymap | windows branch dot_config/zed/keymap.json |
| Terminal font | Windows Terminal profile defaults, JetBrainsMono Nerd Font |
| Additional package/service inventory | Saved NixOS configuration; used as a checklist only |

The NixOS repository is not a configuration source for this branch. No NixOS files, systemd-boot entries, Hyprland config, Caelestia shell config, hardware bus IDs or old user passwords are imported. No native Windows psmux config or plugin is used.

Debian-specific Homebrew/ghcup paths and credential exports are removed from the zsh port. Executables come from CachyOS/Arch packages. The final fzf history bindings retain the behavior of the live Debian shell; zsh-history-enquirer's command was absent there and its widget has the same fallback here.

Jovial's two custom files are copied from Debian. Its MIT license is in docs/licenses/jovial-LICENSE. Other plugin sources are fetched from their upstream repositories at the exact Debian commits in sources.lock.

Kitty did not have a Debian config. Its font is taken from Windows Terminal; other settings are minimal. No desktop-wide theme is imposed.

ASUS services are enabled only by the optional system step. It does not change GPU modes, assume a hardware MUX, hard-code PCI IDs, or replace graphics drivers. The installer should detect the AMD iGPU and RTX 3060.

The Windows EFI remains separate from Linux /boot. Limine's scanner adds a Windows boot entry without moving Windows boot files. The helper preserves a backup of limine.conf and sets timeout: 10.

## Validation

The bootstrap is prepared on Windows and checked with Bash, zsh and chezmoi. Installation on a fresh CachyOS system, package availability in its configured repositories, laptop services, and actual Windows/Linux boots still need validation there. The scripts check packages against pacman before installing.

References:

- https://www.chezmoi.io/user-guide/advanced/customize-your-source-directory/
- https://wiki.cachyos.org/installation/installation_on_root/
- https://wiki.cachyos.org/configuration/boot_manager_configuration/
- https://wiki.cachyos.org/configuration/desktop_environments/niri/
- https://github.com/raine/workmux
- https://github.com/ohmyzsh/ohmyzsh
