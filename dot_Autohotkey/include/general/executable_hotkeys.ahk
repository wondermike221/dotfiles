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

; Right-click + scroll: navigate tabs in opted-in apps.
; Toggle on/off with Win+F8. Add apps to IsRBtnTabNavActive() as needed.
; Right-click still works normally (fires on release) if you don't scroll.

_RBtnTabNav := true
_RBtnScrolled := false

IsRBtnTabNavActive() {
    global _RBtnTabNav
    return _RBtnTabNav && (
        WinActive("ahk_exe chrome.exe")          ||
        WinActive("ahk_exe librewolf.exe")       ||
        WinActive("ahk_exe firefox.exe")         ||
        WinActive("ahk_exe msedge.exe")          ||
        WinActive("ahk_exe zen.exe")             ||
        WinActive("ahk_exe WindowsTerminal.exe")
    )
}

#HotIf IsRBtnTabNavActive()
RButton::
{
    global _RBtnScrolled
    _RBtnScrolled := false
    KeyWait("RButton")
    if !_RBtnScrolled
        Click("Right")
}
#HotIf

#HotIf IsRBtnTabNavActive() && GetKeyState("RButton", "P")
WheelDown::
{
    global _RBtnScrolled
    _RBtnScrolled := true
    SendInput("^{Tab}")
}
WheelUp::
{
    global _RBtnScrolled
    _RBtnScrolled := true
    SendInput("^+{Tab}")
}
#HotIf

#F8::
{
    global _RBtnTabNav
    _RBtnTabNav := !_RBtnTabNav
    TrayTip("RBtn Tab Nav", _RBtnTabNav ? "Enabled" : "Disabled", 1)
}
