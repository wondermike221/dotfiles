; Variables
textDir := ".\\hotstrings\\" ; Path to directory of text files to use
prefix := ":T:]"  ; "T" option = send as Text, not code

; Main - Recursively load all .txt files from hotstrings folder and subdirectories
Loop Files, textDir "*.txt", "R"  ; "R" = recursive
{
  ; Skip files in archive folders
  if InStr(A_LoopFileFullPath, "\archive\")
    continue

  fileName := StrReplace(A_LoopFileName, ".txt", "")
  hotstringActivation := prefix . fileName
  fileContent := FileRead(A_LoopFileFullPath)
  Hotstring(hotstringActivation, fileContent)
}
