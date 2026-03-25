; Usernames that should load work hotstrings.
workUsernames := ["mhixon"]
isWork := false
for _, wUser in workUsernames {
  if (A_UserName = wUser) {
    isWork := true
    break
  }
}

prefix := "::]"

LoadHotstringsFromDir(dir) {
  global prefix
  Loop Files, dir "*.txt" {
    fileName := StrReplace(A_LoopFileName, ".txt", "")
    Hotstring(prefix . fileName, FileRead(dir . A_LoopFileName))
  }
}

LoadHotstringsFromDir(A_ScriptDir "\hotstrings\general\")
if (isWork)
  LoadHotstringsFromDir(A_ScriptDir "\hotstrings\work\")
