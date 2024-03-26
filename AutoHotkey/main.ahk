#Requires AutoHotkey v2.0
#SingleInstance Force

UpdateIncludesFile(includeDir, includeScript) {
    ; Delete the existing includes.ahk file to start fresh
    FileDelete(includeScript)
    ; Wait for the file to be deleted before proceeding
    while (FileExist(includeScript))
        Sleep(100)

    ; Open the includes.ahk file for writing. In AHK V2, FileOpen returns an object.
    file := FileOpen(includeScript, "w")
    if (!file) {
        MsgBox("Failed to open " includeScript " for writing.")
        return
    }

    ; Loop through all .ahk files in the include directory
    Loop Files, includeDir "\*.ahk", "R"
    {
        ; Write each #Include directive to includes.ahk
        file.Write('#Include "' A_LoopFileFullPath '"`n')
    }
    
    file.Close()  ; Close the file when done
}

; Example usage
includeDirectoryPath := A_ScriptDir "\include"
includesFilePath := A_ScriptDir "\includes.ahk"
UpdateIncludesFile(includeDirectoryPath, includesFilePath)

#Include "%A_ScriptDir%"
#Include "includes.ahk"

#^9::{
  MsgBox("Reloaded script!")
  Reload ; Ctrl + Alt + r 
}
