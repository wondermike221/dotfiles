-- Work-specific text expansions. Only loaded when IS_WORK = true.
-- Ported from windows_dot_Autohotkey/hotstrings/work/**/*.txt via hotstringMaker.ahk
-- and inline static expansions from work_hotstrings.ahk.

local hotstrings = require("modules.hotstrings")

-- emails
hotstrings.add("]@@",  "mhixon@ebay.com")
hotstrings.add("]@a",  "mhixon-a@ebay.com")

-- links
hotstrings.add("]go",    "https://go/")
hotstrings.add("]proxy", "https://c2syubi.vip.ebay.com/wpadyubi.pac")
hotstrings.add("]dl",    "DL-eBay-GSS-Deskside-AMER-")

-- locations / contact
hotstrings.add("]addr",      "339 W 13490 S Floor 5, Draper, UT 84020")
hotstrings.add("]workphone", "(385)446-9450")

-- quick fills
hotstrings.add("]-r",   "--redacted--")
hotstrings.add("]na",   "n/a")
hotstrings.add("]sn",   "S/N:")
hotstrings.add("]rec",  "received at SLC.")
hotstrings.add("]drop", "_dropshipped\ty\ty\ty")

-- asset labels / subjects
hotstrings.add("]eeeacn", "eBay Exited Employee Asset Collection Notification")
hotstrings.add("]eeir",   "Exited Employee Information Request -")
hotstrings.add("]esubj",  "Request for Returned Equipment –")
hotstrings.add("]nasset", "No assets per Helix, Azure and Splunk. Closing.")

-- chat support
hotstrings.add("]cintro",   "Thank you for contacting ITSS support! My name is Michael and I will be assisting you today!")
hotstrings.add("]coutro",   "Thank you for contacting ITSS support! Again my name is Michael. Hope you have a wonderful day!")
hotstrings.add("]fhelp",    "Do you have anything else that I can be an assistance with?")
hotstrings.add("]software", "Your software has been ordered and I will follow up with more information once I hear back from our procurement specialist.")
hotstrings.add("]booked",   "I'd love to help but I'm fully booked today. I recommend starting a chat with one of our 24/7 technicians via MyIT or if you can't access MyIT you can call the number on the back of your badge (+1-408-376-7474).")

-- multi-line
hotstrings.add("]ord", table.concat({
  "Your items have been ordered and I will email you the tracking details as soon as our supplier ships them.",
  "Please email me if you have any questions or concerns (mhixon@ebay.com).",
  "Thanks!",
}, "\n"))

hotstrings.add("]deliv", table.concat({
  "Apologies for missing your tracking status notification. It looks like your items have been delivered so I'll go ahead and close your ticket. Please let me know if anything hasn't been delivered so I can remedy that.",
  "Thanks!",
}, "\n"))

hotstrings.add("]retreq", "You will need to return most eBay-issued items, including any laptops, phones, power adapters, and Yubikeys. Accessories such as monitors, keyboards, and headsets may be kept or disposed of.")

hotstrings.add("]-ayubi", table.concat({
  "We recently received an automated Yubikey request associated to the creation of a new Admin (-a) account for you. A secondary Yubikey will be required to manage this account.",
  "Please reply to this message with the following info, Or if you already have a second Yubikey for your -a account please let me know and I will cancel the request. Thanks!",
  " - Physical Shipping Address",
  " - Phone Number",
  " - Do you want a Standard USB Yubikey? Or the USB-c type?",
}, "\n"))

hotstrings.add("]adobelic", table.concat({
  "Your Adobe License for <PRODUCT> has been assigned.  License activation could take up to 1 hour.  You may need to log out of Adobe Creative Cloud and log back in for the changes to take effect.",
  "To install, please open the Adobe Creative Cloud Desktop application on your computer.  You can install individual Adobe applications from there.",
  "If you do not have the Creative Cloud Desktop application installed, open Software Center (Windows) or Self Service (Mac) on your machine and install the Creative Cloud Desktop application.",
}, "\n"))

hotstrings.add("]qr", table.concat({
  "Name:", "Address:", "City:", "Zip:", "State:",
  "Phone:", "Email:", "Ticket:", "Cost Center:", "S/N:",
}, "\n"))

hotstrings.add("]ebayaddr", table.concat({
  "Address for Shipment",
  "Salt Lake City, UT/Remote: 173 W. Election Rd, Draper, UT 84020",
  "San Jose, CA: 2145 Hamilton Ave, San Jose, CA 95125",
  "Austin, TX: 7700 W. Parmer Lane, Austin, TX 78729",
  "Bellevue, WA: 411 108th Ave NE, Bellevue, WA 98004",
  "New York, NY: 625 6th Ave., New York, NY 10011",
  "Portland, OR: 1400 SW 5th Ave., Floor 10, Portland, OR 97201",
}, "\n"))
