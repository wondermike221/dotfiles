#Requires AutoHotkey v2.0
#SingleInstance Force

; --- Configuration ---
SnippetsGeneralFolder := ".\snippets\general\"
SnippetsWorkFolder := ".\snippets\work\"
HotstringsGeneralFolder := ".\hotstrings\general\"
HotstringsWorkFolder := ".\hotstrings\work\"

; --- SET YOUR SHORTCUT HERE ---
SnippetHotkey := "#]"
; ------------------------------

MyGui := Gui("+AlwaysOnTop -MaximizeBox", "Snippet Browser")
MyGui.SetFont("s10", "Segoe UI")

TV := MyGui.Add("TreeView", "r20 w300")
TV.OnEvent("Click", ProcessSelection)

; Build structure - add folders if they exist
; Snippets section
if DirExist(SnippetsGeneralFolder) {
    GeneralSnippetsRoot := TV.Add("Snippets", 0, "Expand")
    PopulateTreeView(SnippetsGeneralFolder, GeneralSnippetsRoot, TV)
}

if DirExist(SnippetsWorkFolder) {
    WorkSnippetsRoot := TV.Add("Work Snippets", 0, "Expand")
    PopulateTreeView(SnippetsWorkFolder, WorkSnippetsRoot, TV)
}

; Hotstrings section
if DirExist(HotstringsGeneralFolder) {
    GeneralHotRoot := TV.Add("Hotstrings", 0, "Expand")
    PopulateTreeView(HotstringsGeneralFolder, GeneralHotRoot, TV)
}

if DirExist(HotstringsWorkFolder) {
    WorkHotRoot := TV.Add("Work Hotstrings", 0, "Expand")
    PopulateTreeView(HotstringsWorkFolder, WorkHotRoot, TV)
}

; Handle Escape key
MyGui.OnEvent("Escape", (*) => MyGui.Hide())

; --- THE FIX: Handle Loss of Focus (Activation) ---
; 0x0006 is the WM_ACTIVATE message
OnMessage(0x0006, WM_ACTIVATE)

WM_ACTIVATE(wParam, lParam, msg, hwnd) {
    ; If wParam is 0, the window is being deactivated
    if (wParam = 0 && hwnd = MyGui.Hwnd) {
        MyGui.Hide()
    }
}

; Define Hotkey to show GUI
; This checks if Control is pressed BEFORE allowing the mouse combo
#HotIf GetKeyState("Ctrl", "P") 
~LButton & RButton:: {
    ; Get mouse coordinates
    MouseGetPos(&mX, &mY)
    ; Show GUI at mouse position (offset slightly so it's not directly under the click)
    MyGui.Show("x" mX " y" mY)
}
#HotIf ; Reset HotIf so it doesn't affect other hotkeys
Hotkey(SnippetHotkey, (*) => MyGui.Show())



; --- Functions ---

PopulateTreeView(DirSource, ParentID, TVObj) {
    Loop Files, DirSource "\*", "DF" {
        if InStr(FileGetAttrib(A_LoopFilePath), "D") {
            FolderID := TVObj.Add(A_LoopFileName, ParentID)
            PopulateTreeView(A_LoopFilePath, FolderID, TVObj)
        } else {
            TVObj.Add(A_LoopFileName, ParentID)
        }
    }
}

ProcessSelection(GuiCtrl, *) {
    global SnippetsGeneralFolder, SnippetsWorkFolder, HotstringsGeneralFolder, HotstringsWorkFolder

    SelectedID := GuiCtrl.GetSelection()
    if (SelectedID == 0)
        return

    FilePath := BuildPath(SelectedID, GuiCtrl)

    if FileExist(FilePath) && !InStr(FileGetAttrib(FilePath), "D") {
        try {
            A_Clipboard := FileRead(FilePath)
            MyGui.Hide()
            ToolTip("Copied")
            SetTimer () => ToolTip(), -1000
        } catch {
            ToolTip("Error reading file")
            SetTimer () => ToolTip(), -1000
        }
    }
}

BuildPath(ItemID, TVObj) {
    global SnippetsGeneralFolder, SnippetsWorkFolder, HotstringsGeneralFolder, HotstringsWorkFolder

    PathParts := []
    CurrentID := ItemID
    while (CurrentID != 0) {
        PathParts.InsertAt(1, TVObj.GetText(CurrentID))
        CurrentID := TVObj.GetParent(CurrentID)
    }
    RootName := PathParts.RemoveAt(1)

    ; Determine base path based on root name
    switch RootName {
        case "Snippets":
            BasePath := SnippetsGeneralFolder
        case "Work Snippets":
            BasePath := SnippetsWorkFolder
        case "Hotstrings":
            BasePath := HotstringsGeneralFolder
        case "Work Hotstrings":
            BasePath := HotstringsWorkFolder
        default:
            BasePath := ""
    }

    FinalPath := BasePath
    for Part in PathParts
        FinalPath .= "\" Part
    return FinalPath
}
