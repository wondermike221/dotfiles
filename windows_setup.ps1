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
# main.ahk
makeShortcut "$startupFolder\main.ahk.lnk" "$HOME\.Autohotkey\main.ahk"
# glazewm
makeShortcut "$startupFolder\glazewm.exe.lnk" "C:\Program Files\glzr.io\GlazeWM\cli\glazewm.exe"


New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target C:\Users\mhixon\.config\nvim\
