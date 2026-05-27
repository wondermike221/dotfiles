; Win+T — auto-detect carrier from clipboard, open tracking in Chrome (eBay Work profile)
#t::OpenTrackingWindow()
OpenTrackingWindow() {
    trk := Trim(A_Clipboard)
    if StrLen(trk) > 2000 {
        MsgBox("Clipboard too large to use as a tracking number (" . StrLen(trk) . " chars).", "Tracking", "Icon!")
        return
    }
    if RegExMatch(trk, "^1Z[A-Z0-9]{16}$") {
        url := "https://www.ups.com/track?track=yes&trackNums=" . trk
    } else if RegExMatch(trk, "^\d{12}$|^\d{15}$|^\d{20}$|^\d{22}$|^96\d{20}$|^DT\d+$") {
        url := "https://www.fedex.com/fedextrack/?trknbr=" . trk
    } else {
        url := "https://www.google.com/search?q=" . trk
    }
    Run('"C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 1" --new-window "' . url . '"')
}

^!r::{ ; -a pass
   apass := FileRead("C:\Users\mhixon\Desktop\macros\apass.txt")
   SendText(apass)
}

^!+c::{ ; Search Outlook
  ;Focus Outlook
  if WinExist("ahk_exe olk.exe")
  {
      WinActivate("ahk_exe olk.exe")
  }
  else
  {
      MsgBox "Outlook is not running."
      return
  }
  WinWaitActive("ahk_exe olk.exe")

  Send("!q")

  Sleep(100)

  Send("^a")

  Send("{delete}")

  Send("^v")

  Send("{Enter}")
}

^!+s::{ ; Search SNOW
  if WinExist("Main")
  {
      WinActivate("Main")
      Send("^4")
      Send("^!g")
      SendText(A_Clipboard)
      Sleep(1500)
      Send("{Down}")
  }
  else
  {
    MsgBox "Main browser window not open"
    return
  }
} 
