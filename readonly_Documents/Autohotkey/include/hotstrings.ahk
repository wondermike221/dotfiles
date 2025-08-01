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
nato_file_contents := FileRead("C:\Users\mhixon\OneDrive - eBay Inc\Documents\Autohotkey\include\nato.txt")
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

/**
 * Fills a form by typing out a string, interpreting tabs as Tab key presses
 * and newlines as Enter key presses.
 *
 * This is ideal for pasting data copied from spreadsheet applications like Excel.
 * The script is designed to reliably handle various line endings and empty cells/rows.
 *
 * @param input The string to process. Typically from the clipboard (A_Clipboard).
 */
FormFiller(input)
{
    ; First, we normalize line endings. Data from Windows often has carriage returns (`r)
    ; and newlines (`n`). We remove the `r` to make parsing consistent.
    cleanInput := StrReplace(input, "`r", "")

    ; Split the entire input into an array of rows based on the newline character.
    rows := StrSplit(cleanInput, "`n")

    ; Loop through each row in the array. We use a standard Loop instead of `for`
    ; so we can easily get the index to check if it's the last row.
    Loop rows.Length
    {
        row := rows[A_Index]

        ; Split the current row into an array of fields based on the tab character.
        fields := StrSplit(row, "`t")

        ; Loop through each field in the current row.
        Loop fields.Length
        {
            field := fields[A_Index]
            
            ; Send the text content of the field. SendText is generally more reliable
            ; for sending blocks of text than the basic Send() command.
            if (field != "")
            {
                SendText(field)
            }

            ; After sending the field's text, send a Tab key press, but ONLY
            ; if it's not the last field in the row. This is the key fix.
            if (A_Index < fields.Length)
            {
                Send("{Tab}")
            }
        }

        ; After processing all fields in a row, send an Enter key press to move to
        ; the next line in the form. We only do this if it's not the very last row
        ; AND that last row is empty. This prevents an extra Enter at the very end
        ; if your copied data had a trailing newline.
        if (A_Index < rows.Length || rows[rows.Length] != "")
        {
            Send("{Enter}")
        }
    }
}

; This is the hotstring that triggers the script. When you type "]formfill"
; followed by a space or enter, it will execute the code below.
::]formfill::
{
    ; Call the function with the current content of the clipboard.
    FormFiller(A_Clipboard)
}
