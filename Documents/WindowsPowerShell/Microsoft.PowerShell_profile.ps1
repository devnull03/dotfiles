oh-my-posh init pwsh --config ~/kali.omp.json | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-Alias lg lazygit
# Keep the chezmoi winget list in sync after package changes
function winget {
    winget.exe @args
    if ($args[0] -in 'install', 'add', 'uninstall', 'remove', 'rm', 'upgrade', 'update') {
        $src = chezmoi source-path
        winget.exe export -o "$src\winget.json" --accept-source-agreements | Out-Null
        git -C $src add winget.json
        git -C $src diff --cached --quiet
        if ($LASTEXITCODE) { git -C $src commit -q -m "Update winget.json"; git -C $src push -q }
    }
}
