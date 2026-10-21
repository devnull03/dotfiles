# Sync komorebi gaps to yasb's bar padding, per monitor DPI.
# yasb padding is logical px (scaled per monitor); komorebi padding is physical px.
# So: gap_physical = yasb_padding * (monitor_dpi / 96), split into workspace+container padding.
$ErrorActionPreference = 'Stop'

$yaml = Get-Content "$env:USERPROFILE\.config\yasb\config.yaml" -Raw
$pad  = [int][regex]::Match($yaml, 'padding:\s*\r?\n\s*top:\s*(\d+)').Groups[1].Value

Add-Type -Name Dpi -Namespace Win -MemberDefinition @'
[DllImport("shcore.dll")] public static extern int SetProcessDpiAwareness(int v);
[DllImport("shcore.dll")] public static extern int GetDpiForMonitor(IntPtr h, int t, out uint x, out uint y);
'@

[void][Win.Dpi]::SetProcessDpiAwareness(2)
$state = komorebic state | ConvertFrom-Json
for ($m = 0; $m -lt $state.monitors.elements.Count; $m++) {
    $mon = $state.monitors.elements[$m]
    $dx = 0; $dy = 0
    [void][Win.Dpi]::GetDpiForMonitor([IntPtr]$mon.id, 0, [ref]$dx, [ref]$dy)
    $gap = [math]::Round($pad * $dx / 96)
    # ponytail: container padding is per-side, so inter-window gap = 2*cp; edge gap = wp+cp
    $cp = [math]::Floor($gap / 2)
    $wp = $gap - $cp
    Write-Host "$($mon.name): dpi $dx ($([math]::Round($dx/96,2))x) -> gap ${gap}px (wp $wp / cp $cp)"
    for ($w = 0; $w -lt $mon.workspaces.elements.Count; $w++) {
        komorebic workspace-padding $m $w $wp
        komorebic container-padding $m $w $cp
    }
}
