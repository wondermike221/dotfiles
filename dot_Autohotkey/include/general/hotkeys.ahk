#!`::ToggleApp()
ToggleApp() {
    AppClass := "CASCADIA_HOSTING_WINDOW_CLASS"

    if WinActive("ahk_class" AppClass) {
      WinMinimize("ahk_class" AppClass)
    }
    else {
      WinActivate("ahk_class" AppClass)
    }
    if not WinExist("ahk_class" AppClass) {
        Run("C:\Program Files\WindowsApps\Microsoft.WindowsTerminalPreview_1.24.3504.0_x64__8wekyb3d8bbwe\WindowsTerminal.exe")
    }
    return
}

^+WheelUp::SendInput("^+{Tab}")
^+WheelDown::SendInput("^{Tab}")
