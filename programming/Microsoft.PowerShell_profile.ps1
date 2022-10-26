# Useful Vars
$HOSTS = "$env:windir\System32\drivers\etc\hosts"
$DOTSSHDIR = "$env:USERPROFILE\.ssh"
$DOTCONFIGDIR = "$env:USERPROFILE\.config"
$NVIMRC = "$env:LOCALAPPDATA\nvim\init.vim"

# Alias'
Set-Alias -Name n -Value nvim
Set-Alias -Name ls -Value exa

Function l {exa -lh}
Function la {exa -a}
Function lla {exa -lha}
Function lt {exa --tree --git-ignore}
Function fz {nvim $(fzf)}

# Start Starship
Invoke-Expression (&starship init powershell)
#$ENV:STARSHIP_CONFIG = "$HOME\Documents\starship.toml"
