#SingleInstance Force ;include this script in windows startup
InstallKeybdHook
InstallMouseHook
KeyHistory 50

; Usernames that should load work scripts. Add more as needed.
workUsernames := ["mhixon"]
isWork := false
for _, wUser in workUsernames {
  if (A_UserName = wUser) {
    isWork := true
    break
  }
}

BuildIncludesContent(generalDir, workDir, isWorkDevice) {
  content := ""
  Loop Files, generalDir "\*.ahk" {
    content .= '#Include `"' A_LoopFileFullPath '"`n'
  }
  if (isWorkDevice) {
    Loop Files, workDir "\*.ahk" {
      content .= '#Include `"' A_LoopFileFullPath '"`n'
    }
  }
  return content
}

UpdateIncludesFile(generalDir, workDir, includeScript, isWorkDevice) {
  newContent := BuildIncludesContent(generalDir, workDir, isWorkDevice)
  currentContent := ""
  try currentContent := FileRead(includeScript)
  if (currentContent = newContent)
    return  ; Nothing changed, no reload needed
  file := FileOpen(includeScript, "w")
  if (!file) {
    MsgBox("Failed to open " includeScript " for writing.")
    return
  }
  file.Write(newContent)
  file.Close()
  Reload()  ; includes.ahk changed — restart with correct scripts loaded
}

UpdateIncludesFile(
  A_ScriptDir "\include\general",
  A_ScriptDir "\include\work",
  A_ScriptDir "\includes.ahk",
  isWork
)

#include "%A_ScriptDir%"
#include "includes.ahk"
#include "hotstringMaker.ahk"
#include "caps-ctrl-esc.ahk"
#include "Lib/jsongo.v2.ahk"
#include "Lib/peep.v2.ahk"
#include "snippetManager.ahk"

#=::{
   MsgBox("reloaded script")
   Reload
}
