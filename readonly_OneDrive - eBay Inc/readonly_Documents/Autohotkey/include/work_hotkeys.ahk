^!r::{ ; -a pass
   apass := FileRead("C:\Users\mhixon\OneDrive - eBay Inc\Desktop\macros\apass.txt")
   SendText(apass)
}

^!+c::{ ; Search Outlook
  ;Focus Outlook
  if WinExist("hk_exe outlook.exe")
  {
      WinActivate("ahk_exe outlook.exe")
  }
  else
  {
      MsgBox "Outlook is not running."
      return
  }
  WinWaitActive("ahk_exe outlook.exe")

  Send(!q)

  Sleep(100)

  Send(^a)

  Send({delete})

  Send(^v)

  Send({Enter})
}
