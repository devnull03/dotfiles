oh-my-posh init pwsh --config ~/kali.omp.json | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-Alias lg lazygit
# Keep the chezmoi winget list in sync after package changes
function winget {
    winget.exe @args
    if ($args[0] -in 'install', 'add', 'uninstall', 'remove', 'rm', 'upgrade', 'update') {
        winget.exe export -o "$(chezmoi source-path)\winget.json" --accept-source-agreements | Out-Null
    }
}
