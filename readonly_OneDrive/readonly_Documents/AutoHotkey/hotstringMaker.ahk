; Variables
textDir := ".\\hotstrings\\" ; Path to directory of text files to use
prefix := "::]"

; Main 
Loop Files, textDir "*.txt"
{
  fileName := StrReplace(A_LoopFileName, ".txt", "")
  hotstringActivation := prefix . fileName
  fileContent := FileRead(textDir . A_LoopFileName)
  Hotstring(hotstringActivation, fileContent)
}
