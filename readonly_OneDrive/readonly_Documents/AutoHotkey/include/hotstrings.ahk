TodaysDate() {
  Send(FormatTime(, "MM/d/yy"))  ; It will look like 9/1/2005 3:53 PM
}
FileFriendlyDate() {
  Send(FormatTime(, "yyyy-MM-d"))
}
::]shrug::¯\_(ツ)_/¯

::]d::TodaysDate()
^;::TodaysDate()
^+;::FileFriendlyDate()
::]fd::FileFriendlyDate()

; :r*:]wordle::
; (
; let dataURL='https://raw.githubusercontent.com/chidiwilliams/wordle/main/src/data/words.json';let preTag,all;async function getData(){if(window.location.href==dataURL){preTag=document.querySelector('pre');all=JSON.parse(preTag.textContent)}else{const response=await fetch(dataURL);const words=await response.json();all=words}}getData();function getPossibleWordles(excludedLetters,includedLetters,positionalChecks){let filtered=all.filter((item)=>{for(let excluded of excludedLetters){if(item.includes(excluded)){return false}}for(let included of includedLetters){if(!item.includes(included)){return false}}return(positionalChecks(item))});return filtered}
; )
:r*:]wordl::
(
const wordleSolver=await(async()=>{let dataURL="https://raw.githubusercontent.com/chidiwilliams/wordle/main/src/data/words.json";let preTag,all;async function getData(){if(window.location.href==dataURL){preTag=document.querySelector("pre");all=JSON.parse(preTag.textContent)}else{const response=await fetch(dataURL);const words=await response.json();all=words}}
await getData();return function(regex,excludedLetters="",includedLetters=""){rx=regex||/...../;return all.filter((word)=>{let w=new Set([...word]);let ex=new Set([...excludedLetters]);let inc=new Set([...includedLetters]);return rx.test(word)&&w.isDisjointFrom(ex)&&w.isSupersetOf(inc)})}})()
)

;NATO Alphabet
::]nato::https://militaryalphabet.net/ ;quick reference site
alph := "abcdefghijklmnopqrstuvwxyz"
nato_file_contents := FileRead("include\nato.txt")
nato_lines := StrSplit(nato_file_contents, "`n", "`n`r")
Loop 26 {
  activation := "::]n" . SubStr(alph, A_Index, 1)
  Hotstring(activation, nato_lines[A_Index])
}

::]csv::{
  cb := A_Clipboard
  cb := StrReplace(cb, '`r`n', ",")
  SendText(cb)
}
