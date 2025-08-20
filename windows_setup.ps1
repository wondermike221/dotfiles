# startup items

$startupFolder = [Environment]::GetFolderPath('Startup')
function makeShortcut {
  param(
    [String] $shortcutPath,
    [String] $target
  )
  $WshShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WshShell.CreateShortcut($shortcutPath)
  $Shortcut.TargetPath = $target
  $Shortcut.Save()
}
if (-not (Test-Path "$startupFolder\main.ahk.lnk") -and (Test-Path "$HOME\.Autohotkey\main.ahk")) {
  # main.ahk
  makeShortcut "$startupFolder\main.ahk.lnk" "$HOME\.Autohotkey\main.ahk"
}
if (-not (Test-Path "$startupFolder\glazewm.exe.lnk") -and (Test-Path "C:\Program Files\glzr.io\GlazeWM\cli\glazewm.exe")) {
  # glazewm
  makeShortcut "$startupFolder\glazewm.exe.lnk" "C:\Program Files\glzr.io\GlazeWM\cli\glazewm.exe"
}

# Set up EDITOR env
if (where.exe nvim -and (-not (Test-Path Env:EDITOR) -and ($env:EDITOR -ne "C:\Program Files/Neovim/bin/nvim.exe"))) {
  [Environment]::SetEnvironmentVariable
     ("EDITOR", (where.exe nvim), [System.EnvironmentVariableTarget]::User)
} else {
  write-output "neovim is not installed!"
}

# set up lazyvim
if (Test-Path "~\.config\nvim\") {
  New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target C:\Users\mhixon\.config\nvim\
}

# set up alternate yazi config Path
if ((Test-Path Env:YAZI_CONFIG_HOME) -and ($env:YAZI_CONFIG_HOME -ne "~\.config\yazi")) {
  [Environment]::SetEnvironmentVariable
    ("YAZI_CONFIG_HOME", "~\.config\yazi", [System.EnvironmentVariableTarget]::User)
}
