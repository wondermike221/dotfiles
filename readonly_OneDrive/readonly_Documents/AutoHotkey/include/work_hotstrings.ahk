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
:*:]atc::Assets to collect:`n
cpcTemplate :=  "
(
[Main]
email_template="Wait"
status=""

[Exited_Employee]
name=""
username=""
source=""
vendor=""
personal_email=""

[Manager]
name=""
email=""

[[Asset]]
serial=""
tag=""

#manually input other assets that need retrieval. Always work off ticket with smallest number.
[[Asset]]
serial=""
tag=""

)"


:*:]cpcscaff::
{
  SendText(cpcTemplate)
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
