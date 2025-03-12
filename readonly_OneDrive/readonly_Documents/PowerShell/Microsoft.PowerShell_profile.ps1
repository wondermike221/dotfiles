# Useful Vars
$HOSTS = "$env:windir\System32\drivers\etc\hosts"
$DOTSSHDIR = "$env:USERPROFILE\.ssh"
$DOTCONFIGDIR = "$env:USERPROFILE\.config"
$NVIMRC = "$env:LOCALAPPDATA\nvim\"

$life = "$env:OneDrive\life\"

# Alias'
Set-Alias -Name n -Value nvim
# eza helpers
Set-Alias -Name ls -Value eza
Function l {eza -lh}
Function la {eza -a}
Function lla {eza -lha}
Function lt {eza --tree --git-ignore}
Function fz {nvim $(fzf)}

Function wua {winget update --all --include-unknown --accept-source-agreements --accept-package-agreements}

# Start Starship
# Invoke-Expression (&starship init powershell)
#$ENV:STARSHIP_CONFIG = "$HOME\Documents\starship.toml"

# Start zoxide
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })


function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}

function gh-create { $ErrorActionPreference="Stop"; gh repo create --private --source=. --remote=origin; git push -u --all; gh browse }
