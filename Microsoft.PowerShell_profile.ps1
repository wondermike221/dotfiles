# Useful Vars
$HOSTS = "$env:windir\System32\drivers\etc\hosts"
$DOTSSHDIR = "$env:USERPROFILE\.ssh"
$DOTCONFIGDIR = "$env:USERPROFILE\.config"
$NVIMRC = "$env:LOCALAPPDATA\nvim\"

#Alias'
Set-Alias -Name n -Value nvim

# eza helpers
Set-Alias -Name ls -Value eza
Function l {eza -lh}
Function la {eza -a}
Function lla {eza -lha}
Function lt {eza --tree --git-ignore}
Function fz {nvim $(fzf)}

# Starship prompt
Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "$HOME\Documents\starship.toml"

# Zoxide init
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })

# scans the cwd for files older than the provide date
function Get-Old-Files {
	param (
		[Parameter (Mandatory = $False)]
		[string]$date = (Get-Date).addMonths(-18)
	)
	get-childitem -file -Recurse -Force | Where-Object { $_.LastWriteTime -lt $date }
}
