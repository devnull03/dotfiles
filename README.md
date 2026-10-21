# dotfiles

Windows dotfiles, managed with [chezmoi](https://chezmoi.io).

Includes yasb, komorebi + whkd, Windows Terminal, PowerShell (5.1 + 7) with oh-my-posh, fzf and predictive completions, git and Zed.

## New machine

```powershell
winget install twpayne.chezmoi
chezmoi init --apply --branch windows devnull03/dotfiles
```

`apply` copies the configs into place and runs `winget import` on `winget.json`, plus installs the PSFzf and CompletionPredictor modules.

## Day to day

- Changed a config: `chezmoi re-add` (auto commits and pushes)
- `winget install/uninstall/upgrade` in PowerShell re-exports `winget.json` and pushes it
- On another machine: `chezmoi update`

The old `Setup.py` script from 2023 is still here but ignored by chezmoi.
