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

; Right-click + scroll: navigate tabs in opted-in apps (works on hovered window).
; Scroll while hovering tab bar: navigate tabs without right-clicking.
; Toggle on/off with Win+F8. Add apps to _IsTabNavProc() as needed.
; Right-click still works normally (fires on release) if you don't scroll.
;
; Tab bar region (px from each edge, 0 = disabled):
_TabBarTop   := 40  ; horizontal tab bar (most browsers, Terminal)
_TabBarLeft  := 0   ; left-side tree tab bar (e.g. Tree Style Tab)
_TabBarRight := 0   ; right-side tree tab bar

_RBtnTabNav := true
_RBtnScrolled := false

_IsTabNavWindow(hwnd) {
    try {
        proc := WinGetProcessName("ahk_id " hwnd)
        if proc = "explorer.exe"
            return WinGetClass("ahk_id " hwnd) = "CabinetWClass"
        return (proc = "chrome.exe"
             || proc = "librewolf.exe"
             || proc = "thorium.exe"
             || proc = "firefox.exe"
             || proc = "msedge.exe"
             || proc = "zen.exe"
             || proc = "WindowsTerminal.exe")
    }
    return false
}

; Always resolve to top-level window — avoids child hwnd (e.g. browser render view)
; returning wrong position/process when mouse is in content area.
_RootHwnd() {
    MouseGetPos(,, &hwnd)
    return DllCall("GetAncestor", "Ptr", hwnd, "UInt", 2, "Ptr")
}

_IsTabNavHovered() {
    global _RBtnTabNav
    return _RBtnTabNav && _IsTabNavWindow(_RootHwnd())
}

_IsOverTabBar() {
    global _RBtnTabNav, _TabBarTop, _TabBarLeft, _TabBarRight
    if !_RBtnTabNav || GetKeyState("RButton", "P")
        return false
    MouseGetPos(,, &hwnd)
    try {
        rootHwnd := DllCall("GetAncestor", "Ptr", hwnd, "UInt", 2, "Ptr")
        if !_IsTabNavWindow(rootHwnd)
            return false
        ; WinGetPos returns physical px but MouseGetPos returns AHK logical px —
        ; they diverge on scaled/multi-monitor setups. Use Win32 physical coords
        ; for both so the comparison is consistent.
        pt := Buffer(8, 0)
        DllCall("GetCursorPos", "Ptr", pt)
        mx := NumGet(pt, 0, "Int")
        my := NumGet(pt, 4, "Int")
        rc := Buffer(16, 0)
        DllCall("GetWindowRect", "Ptr", rootHwnd, "Ptr", rc)
        wx := NumGet(rc, 0, "Int")
        wy := NumGet(rc, 4, "Int")
        wr := NumGet(rc, 8, "Int")
        wb := NumGet(rc, 12, "Int")
        if mx < wx || mx > wr || my < wy || my > wb
            return false
        ; Scale logical threshold to physical pixels for this window's DPI
        scale := DllCall("GetDpiForWindow", "Ptr", rootHwnd, "UInt") / 96
        return (_TabBarTop   > 0 && (my - wy) <= _TabBarTop   * scale)
            || (_TabBarLeft  > 0 && (mx - wx) <= _TabBarLeft  * scale)
            || (_TabBarRight > 0 && (wr - mx)  <= _TabBarRight * scale)
    }
    return false
}

_TabNavSend(keys) {
    rootHwnd := _RootHwnd()
    if !WinActive("ahk_id " rootHwnd) {
        WinActivate("ahk_id " rootHwnd)
        WinWaitActive("ahk_id " rootHwnd,, 0.1)
    }
    SendInput(keys)
}

#HotIf _IsTabNavHovered()
RButton::
{
    global _RBtnScrolled
    _RBtnScrolled := false
    KeyWait("RButton")
    if !_RBtnScrolled
        Click("Right")
}
#HotIf

#HotIf _IsTabNavHovered() && GetKeyState("RButton", "P")
WheelDown::
{
    global _RBtnScrolled
    _RBtnScrolled := true
    _TabNavSend("^{Tab}")
}
WheelUp::
{
    global _RBtnScrolled
    _RBtnScrolled := true
    _TabNavSend("^+{Tab}")
}
#HotIf

#HotIf _IsOverTabBar()
WheelDown::_TabNavSend("^{Tab}")
WheelUp::_TabNavSend("^+{Tab}")
#HotIf

#F8::
{
    global _RBtnTabNav
    _RBtnTabNav := !_RBtnTabNav
    TrayTip("RBtn Tab Nav", _RBtnTabNav ? "Enabled" : "Disabled", 1)
}

; Debug: hover anywhere in browser, press Ctrl+Win+F8 to dump position values
^#F8::
{
    ; AHK logical coords
    MouseGetPos(&mx, &my, &hwnd)
    rootHwnd := DllCall("GetAncestor", "Ptr", hwnd, "UInt", 2, "Ptr")
    WinGetPos(&wx, &wy, &ww, &wh, "ahk_id " rootHwnd)
    proc := WinGetProcessName("ahk_id " rootHwnd)

    ; Physical coords direct from Win32 (no DPI scaling)
    pt := Buffer(8, 0)
    DllCall("GetCursorPos", "Ptr", pt)
    phys_mx := NumGet(pt, 0, "Int")
    phys_my := NumGet(pt, 4, "Int")
    rc := Buffer(16, 0)
    DllCall("GetWindowRect", "Ptr", rootHwnd, "Ptr", rc)
    phys_wx := NumGet(rc, 0, "Int")
    phys_wy := NumGet(rc, 4, "Int")
    phys_ww := NumGet(rc, 8, "Int") - phys_wx
    phys_wh := NumGet(rc, 12, "Int") - phys_wy

    info := "[AHK logical]"
        . "`n  mouse:  x=" mx "  y=" my
        . "`n  hwnd=" hwnd "  root=" rootHwnd
        . "`n  win:   x=" wx "  y=" wy "  w=" ww "  h=" wh
        . "`n  my-wy= " (my - wy) "  (threshold=" _TabBarTop ")"
        . "`n[Win32 physical]"
        . "`n  mouse:  x=" phys_mx "  y=" phys_my
        . "`n  win:   x=" phys_wx "  y=" phys_wy "  w=" phys_ww "  h=" phys_wh
        . "`n  my-wy= " (phys_my - phys_wy)
        . "`nproc:  " proc
        . "`n_IsOverTabBar= " _IsOverTabBar()
        . "`n---"
    A_Clipboard := info
    FileAppend(info "`n", A_ScriptDir "\tabnav-debug.log")
    ToolTip("Copied to clipboard + logged to tabnav-debug.log")
    SetTimer(() => ToolTip(), -2000)
}
