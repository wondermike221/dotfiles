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
