^!r::{ ; -a pass
   apass := FileRead("C:\Users\mhixon\OneDrive - eBay Inc\Desktop\macros\apass.txt")
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
