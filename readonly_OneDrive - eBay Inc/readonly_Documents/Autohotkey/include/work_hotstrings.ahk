; email shortcuts
:*:]a@::mhixon-a@ebay.com ; admin email
:*:]@@::mhixon@ebay.com ; corp email
::]bh::{
  SendText("eBay B&H Orders ")
  Send(FormatTime(, "MM/dd/yy"))  ; It will look like 09/01/2005 3:53 PM
}

;Splunk help
::]sworkstation::{
  SendText(A_Clipboard)
  SendText(' Source_Workstation="\\\\*"')
}

; link shortcuts
:*:]go::https://go/
::]proxy::https://c2syubi.vip.ebay.com/wpadyubi.pac
:*:]fedh::{
  SendText("https://www.fedex.com/fedextrack/?trknbr=")
  SendText(A_Clipboard)
}
:*:]upsh::{
  SendText("https://www.ups.com/track?track=yes&trackNums=")
  SendText(A_Clipboard) 
}

; excel shortcuts
:*:]scaffold::{ ;date|site|what|qty|workorder|email|cost center|who|address1|address2|city|state|zip|phone|country|tracking #|packed|label created|ready for pickup|return label|cross charged
  SendText(Format("{1}`tSLC`t`t1`tWalk In`t`t`t`t`t`t`t`t`t`tUSA`t_office`t`t`t`tn",FormatTime(, "MM/dd/yy")))
}
:*:]drop::_dropshipped`ty`ty`ty
:r*:]xlnmct::=[@ContactFirstName] & " " & [@ContactLastName]

; chat support shortcuts
:r*:]cintro::Thank you for contacting ITSS support! My name is Michael and I will be assisting you today!
:r*:]coutro::Thank you for contacting ITSS support! Again my name is Michael. Hope you have a wonderful day!
:r*:]fhelp::Do you have anything else that I can be an assistance with?

; chat shortcuts
:r*:]booked::I'd love to help but I'm fully booked today. I recommend starting a chat with one of our 24/7 technicians via MyIT or if you can't access MyIT you can call the number on the back of your badge (+1-408-376-7474).
:r*:]software::Your software has been ordered and I will follow up with more information once I hear back from our procurement specialist.
:r*:]ord::
{
  SendText("Your items have been ordered and I will email you the tracking details as soon as our supplier ships them.`nPlease email me if you have any questions or concerns (mhixon@ebay.com).`nThanks!",)
}

; Collect PC shortcuts
:*:]eeeacn::eBay Exited Employee Asset Collection Notification
:*:]qr::
{
  SendText("Name: `nAddress: `nCity: `nZip: `nState: `nPhone: `nEmail: `nTicket: `nCost Center: `nS/N: ")
}
:*:]eeir::Exited Employee Information Request -
:*:]ritequip::Need the following information to collect IT equipment:`npersonal email,`nphone number,`naddress
:*:]nasset::No assets per Helix, Azure and Splunk. Closing.
:*:]-r::--redacted--
:*:]rec::received at SLC.
:*:]esubj::Request for Returned Equipment – 
:*:]lescalate::
{
  SendText("Three strikes. ")
  SendText(A_Clipboard)
  SendText(" still deployed.`nEscalating to legal.")
}


:*:]cpcscaff::
{
  SendText(cpcTemplate)
}
:*:]assetScaff::
{
    ; Retrieve the current contents of the clipboard
    clipboardContent := A_Clipboard

    ; Split the clipboard content by tabs
    parts := StrSplit(clipboardContent, "`t")

    ; Check if there are enough parts to process
    if (parts.Length != 4) {
        Tag := parts[1]
        Serial := parts[2]
        AssetStatus := parts[3]  ; Not used in the output
        Status := parts[4]       ; Not used in the output
        Model := parts[5]

        ; Format the output string
        output := "- " Model " [SN: " Serial ", Tag: " Tag "]"

        ; Send the formatted output
        SendText(output)
    } else {
        ; If the clipboard content is not in the expected format, notify the user
        MsgBox("Clipboard content is not in the expected format.")
    }

    return
}

:r*:]deliv::
{
  SendText("Apologies for missing your tracking status notification. It looks like your items have been delivered so I'll go ahead and close your ticket. Please let me know if anything hasn't been delivered so I can remedy that.`nThanks!")
}

; other
::]sn::S/N:
::]na::n/a

; SNOW
:r*:]snowinc::
{
  SendText("ebayinc.service-now.com/nav_to.do?uri=incident.do?sysparm_query=number%3D")
  SendText(A_Clipboard)
}

:r*:]snowtask::
{
  SendText("ebayinc.service-now.com/nav_to.do?uri=task.do?sysparm_query=number%3D")
  SendText(A_Clipboard)
}

:r*:]snowsearch::
{
  SendText("https://ebayinc.service-now.com/nav_to.do?uri=textsearch.do?sysparm_search=")
  SendText(A_Clipboard)
}

; Define the NATO phonetic alphabet for uppercase and lowercase letters
natoAlphabet := Map(
    "A", "Alfa", "B", "Bravo", "C", "Charlie", "D", "Delta",
    "E", "Echo", "F", "Foxtrot", "G", "Golf", "H", "Hotel",
    "I", "India", "J", "Juliett", "K", "Kilo", "L", "Lima",
    "M", "Mike", "N", "November", "O", "Oscar", "P", "Papa",
    "Q", "Quebec", "R", "Romeo", "S", "Sierra", "T", "Tango",
    "U", "Uniform", "V", "Victor", "W", "Whiskey", "X", "X-ray",
    "Y", "Yankee", "Z", "Zulu", "a", "alfa", "b", "bravo",
    "c", "charlie", "d", "delta", "e", "echo", "f", "foxtrot",
    "g", "golf", "h", "hotel", "i", "india", "j", "juliett",
    "k", "kilo", "l", "lima", "m", "mike", "n", "november",
    "o", "oscar", "p", "papa", "q", "quebec", "r", "romeo",
    "s", "sierra", "t", "tango", "u", "uniform", "v", "victor",
    "w", "whiskey", "x", "x-ray", "y", "yankee", "z", "zulu"
)

; Define the hotstring
::]a2nato::
{
    ; Retrieve the string from the clipboard
    clipboardString := A_Clipboard

    ; Initialize an empty result string
    result := ""

    ; Iterate over each character in the clipboard string
    for index, char in StrSplit(clipboardString, "")
    {
        ; Check if the character is in the NATO alphabet map
        if natoAlphabet.Has(char)
        {
            ; Append the corresponding NATO word to the result string
            result .= natoAlphabet[char] . "`n"
        }
        else
        {
            ; If the character is not in the map, append the character itself
            result .= char . "`n"
        }
    }

    ; Send the result using SendText
    SendText(result)
}

