# Useful Vars
$HOSTS = "$env:windir\System32\drivers\etc\hosts"
$DOTSSHDIR = "$env:USERPROFILE\.ssh"
$DOTCONFIGDIR = "$env:USERPROFILE\.config"
$NVIMRC = "$env:LOCALAPPDATA\nvim\init.vim"

# Alias'
Set-Alias -Name n -Value nvim
Set-Alias -Name ls -Value eza

Function l {eza -lh}
Function la {eza -a}
Function lla {eza -lha}
Function lt {eza --tree --git-ignore}
Function fz {nvim $(fzf)}

# Start Starship
Invoke-Expression (&starship init powershell)
#$ENV:STARSHIP_CONFIG = "$HOME\Documents\starship.toml"

# Start zoxide
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })