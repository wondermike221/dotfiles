#SingleInstance Force ;include this script in windows startup
InstallKeybdHook
InstallMouseHook
KeyHistory 50

UpdateIncludesFile(includeDir, includeScript) {
  FileDelete(includeScript)
  while (FileExist(includeScript))
    Sleep(100)

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

#include "./"
#include "includes.ahk"
#include "hotstringMaker.ahk"
#include "caps-ctrl-esc.ahk"

#=::{
   MsgBox("reloaded script")
   Reload
}

#!`::ToggleApp()
ToggleApp() {
    AppClass := "org.wezfurlong.wezterm"

    if WinActive("ahk_class" AppClass) {
      WinMinimize("ahk_class" AppClass)
    }
    else {
      WinActivate("ahk_class" AppClass)
    }
    if not WinExist("ahk_class" AppClass) {
        Run("C:\Program Files\WezTerm\wezterm-gui.exe") ; Replace with the actual path to your application
    }
    return
}


global enterTabToggle := false  ; Initialize the toggle variable to false

; Define the hotkey Win+NumKey5 to toggle the functionality
#-::{  ; Win+NumKey5
    global enterTabToggle
    enterTabToggle := !enterTabToggle  ; Toggle the boolean value
    if (enterTabToggle) {
      MsgBox("Enter will now be Tab")
      Hotkey("Enter", EnterAsTab, "On")  ; Turn on the custom Enter functionality
    } else {
      Hotkey("Enter", EnterAsTab, "Off")  ; Turn off the custom Enter functionality
      MsgBox("Enter will be Enter again") ; MsgBox second this time so the enter key can always dismiss the box
    }
}

; Define the custom functionality for the Enter key
EnterAsTab(ThisHotkey) {
    Send("{Tab}")  ; Send the Tab key instead of Enter
}

