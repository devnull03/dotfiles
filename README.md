# CachyOS dotfiles

The cachyos branch of devnull03/dotfiles uses chezmoi. It restores the live Debian WSL shell/editor/terminal setup and shared Windows preferences on an installed CachyOS system.

## Install

In the CachyOS installer, select Niri and Limine. Use only the prepared 128 GiB free space: 4096 MiB FAT32 mounted at /boot, then the remaining space as Btrfs mounted at /. Leave the existing Windows partitions unchanged.

After installing and rebooting into CachyOS:

    sudo pacman -S --needed git
    git clone --branch cachyos https://github.com/devnull03/dotfiles.git ~/Projects/dotfiles
    cd ~/Projects/dotfiles
    bash bootstrap.sh --full
    bash bootstrap.sh --full --apply

The first bootstrap command prints the plan. The second runs it. A private GitHub repo needs authentication when cloning; the USB includes a Git bundle so the first clone can also work without GitHub authentication. Open cachyos-setup/INSTALL.txt on the USB for that route.

Run the bootstrap as your normal user. It uses sudo when needed and refuses to run from the live installer or another distribution.

## Included

- zsh and Oh My Zsh with the Debian Jovial theme, autosuggestions, fast syntax highlighting, history plugin, vi bindings, fzf and zoxide.
- Native Linux tmux with Debian's Alt+A prefix, Catppuccin Mocha theme, pane titles and workmux dashboard binding. No psmux files are used.
- LazyVim copied from Debian, including its lockfile. It is seeded only when ~/.config/nvim does not already exist, so updates remain writable.
- lazygit, fastfetch, Neovim, Zed, Kitty, Bun, uv and the development tools listed in packages/repo.txt.
- Git identity and Zed Shift+Enter binding from the shared Windows dotfiles. Kitty uses the JetBrainsMono Nerd Font from Windows Terminal.

The full preset also installs the optional package lists, enables the installed ASUS/Bluetooth/power services, selects zsh as the login shell and configures the Limine menu. AUR builds still show their normal review prompts.

Workmux is configured to launch Codex. Agent CLI installation/login, browser login, account passwords and SSH keys remain separate; no tokens or passwords are copied into this branch.

Fastfetch is available as a command; it is not run in every new terminal.

## Optional parts

Run bash bootstrap.sh --help for all flags.

| Flag | Action |
| --- | --- |
| --apply | Install the base packages and managed dotfiles |
| --extras | Add packages/optional-repo.txt |
| --aur | Add Zen and supergfxctl; prefer configured repos over AUR |
| --system | Start installed ASUS, Bluetooth, NetworkManager and power services |
| --boot-menu | Run limine-scan and set a ten-second menu |
| --login-shell | Set the current user's login shell to zsh |
| --full | Select all the optional parts above |

Waybar is installed by --extras, but is not started alongside the installer's shell. Niri, Noctalia, display-manager settings, graphics drivers and GPU modes are left to the CachyOS installer. The old Hyprland/Caelestia configuration is not applied.

If TLP or tuned is already active, the service helper stops rather than enabling a competing power manager.

## Updates and backups

The bootstrap configures chezmoi to use this checkout. Future dotfile updates use:

    chezmoi update

Package lists and pinned plugin versions are applied by rerunning the bootstrap. Existing managed configs are backed up under ~/.local/share/cachyos-dotfiles/backups before applying. Existing Neovim configs are preserved.

To update the tracked LazyVim snapshot after editing it:

    cp -a ~/.config/nvim/. assets/nvim/

Review the resulting diff before committing. Plugin versions are pinned in sources.lock; the workmux release checksum is pinned in assets/workmux-linux-amd64.sha256.

The scripts never partition disks or reboot. Check both Windows and CachyOS boot entries before calling the migration complete.

Source details and deliberate changes are recorded in docs/MIGRATION.md.
