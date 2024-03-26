::]d::
{
    SendInput(FormatTime(, "MM/d/yyyy"))
}

::]wordle::
(
let dataURL='https://raw.githubusercontent.com/chidiwilliams/wordle/main/src/data/words.json';let preTag,all;async function getData(){if(window.location.href==dataURL){preTag=document.querySelector('pre');all=JSON.parse(preTag.textContent)}else{const response=await fetch(dataURL);const words=await response.json();all=words}}getData();function getPossibleWordles(excludedLetters,includedLetters,positionalChecks){let filtered=all.filter((item)=>{for(let excluded of excludedLetters){if(item.includes(excluded)){return false}}for(let included of includedLetters){if(!item.includes(included)){return false}}return(positionalChecks(item))});return filtered}
)

::]@@::michael.hixon@hotmail.com
::]@o::michael.hixon@outlook.com

::]ez::rakushou 

::]shrug::¯\_(ツ)_/¯


::]ytt::
{
ID := A_Clipboard
Send(Format("https://img.youtube.com/vi/{1}/maxresdefault.jpg", ID))
}

