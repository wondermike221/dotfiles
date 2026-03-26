; Variables
textDir := ".\\hotstrings\\" ; Path to directory of text files to use
prefix := "::]"

; Main - Recursively load all .txt files from hotstrings folder and subdirectories
Loop Files, textDir "*.txt", "R"  ; "R" = recursive
{
  fileName := StrReplace(A_LoopFileName, ".txt", "")
  hotstringActivation := prefix . fileName
  fileContent := FileRead(A_LoopFileFullPath)
  Hotstring(hotstringActivation, fileContent)
}
