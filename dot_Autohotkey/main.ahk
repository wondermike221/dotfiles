#SingleInstance Force ;include this script in windows startup
InstallKeybdHook
InstallMouseHook
KeyHistory 50

UpdateIncludesFile(includeDir, includeScript) {
  file := FileOpen(includeScript, "w")
  if(!file) {
    MsgBox("Failed to open " includeScript " for writing.")
    return
  }

  Loop Files, includeDir "\*.ahk", "R" {
    file.Write('#Include `"' A_LoopFileFullPath '"`n')
  }
  file.Close()
}

includeDirectoryPath := A_ScriptDir "\include"
includesFilePath := A_ScriptDir "\includes.ahk"
UpdateIncludesFile(includeDirectoryPath, includesFilePath)

#include "C:/Users/mhixon\.Autohotkey"
#include "includes.ahk"
#include "hotstringMaker.ahk"
#include "caps-ctrl-esc.ahk"
#include "Lib/jsongo.v2.ahk"
#include "Lib/peep.v2.ahk"

^F12:: {
    Send("{F20}")
}

#=::{
   MsgBox("reloaded script")
   Reload
}

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
        Run("C:\Program Files\WindowsApps\Microsoft.WindowsTerminalPreview_1.24.3504.0_x64__8wekyb3d8bbwe\WindowsTerminal.exe") ; Replace with the actual path to your application
    }
    return
}


global enterTabToggle := false     ; Toggle for Enter->Tab
global autoNavToggle := false      ; Toggle for auto Down+Home after every second scan
global scanCounter := 0            ; Counts Enter presses while toggle is ON

; Win + - to toggle
#-:: {
    global enterTabToggle, autoNavToggle, scanCounter

    enterTabToggle := !enterTabToggle

    if (enterTabToggle) {
        scanCounter := 0
        Hotkey("Enter", EnterAsTab, "On")  ; Turn on custom Enter functionality

        ; Ask whether to enable the auto Down+Home behavior
        choice := MsgBox(
            "Enter will now be Tab.`n`nEnable auto Down+Home after every second scan?",
            "Enter→Tab Toggle",
            "YesNo"
        )
        autoNavToggle := (choice = "Yes")
    } else {
        Hotkey("Enter", EnterAsTab, "Off") ; Turn off custom Enter functionality
        autoNavToggle := false
        scanCounter := 0
        MsgBox("Enter will be Enter again") ; Enter can dismiss this box
    }
}

EnterAsTab(ThisHotkey) {
    global autoNavToggle, scanCounter

    Send("{Tab}")       ; Replace Enter with Tab
    scanCounter += 1

    ; After every second scan, optionally send Down+Home
    if (autoNavToggle && Mod(scanCounter, 2) = 0) {
        ; Small delay helps Excel reliably process sequential keys; adjust if needed
        Sleep(30)
        Send("{Down}{Home}")
    }
}

^+WheelUp::SendInput("^+{Tab}")
^+WheelDown::SendInput("^{Tab}")
