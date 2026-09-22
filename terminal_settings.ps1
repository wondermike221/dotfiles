param(
    [Parameter(Mandatory, Position=0)]
    [ValidateSet('push','pull')]
    [string]$Command
)

$Live = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
$Canonical = "$env:USERPROFILE\.config\windows-terminal\settings.json"

switch ($Command) {
    'push' {
        Copy-Item $Canonical $Live
        Write-Host "Pushed canonical -> live"
    }
    'pull' {
        Get-Content $Live | jq --sort-keys '.' | Set-Content $Canonical
        Write-Host "Pulled live -> canonical (sorted)"
        Write-Host "Run: chezmoi add ~/.config/windows-terminal/settings.json"
    }
}
