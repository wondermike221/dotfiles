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

-- Dynamic / clipboard-based expansions ported from work_hotstrings.ahk

-- date
hotstrings.add("]bh", function()
  hotstrings.typeText("eBay B&H Orders " .. os.date("%m/%d/%y"))
end)

-- Splunk: append Source_Workstation filter after clipboard value
hotstrings.add("]sworkstation", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(cb .. ' Source_Workstation="\\\\*"')
end)

-- tracking URL hotlinks (type URL + clipboard tracking number)
hotstrings.add("]fedh", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText("https://www.fedex.com/fedextrack/?trknbr=" .. cb)
end)

hotstrings.add("]upsh", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText("https://www.ups.com/track?track=yes&trackNums=" .. cb)
end)

-- Excel scaffold row: date + fixed columns (tabs between each cell)
hotstrings.add("]scaffold", function()
  hotstrings.typeText(os.date("%m/%d/%y") .. "\tSLC\t\t1\tWalk In\t\t\t\t\t\t\t\t\t\tUSA\t_office\t\t\t\tn")
end)

-- Equipment collection request: parses Name\tNT lines from clipboard
hotstrings.add("]ritequip", function()
  local cb = (hs.pasteboard.getContents() or ""):gsub("\r\n", "\n"):gsub("\r", "\n"):gsub("\n$", "")
  local nameLines = ""
  for line in (cb .. "\n"):gmatch("([^\n]*)\n") do
    local parts = {}
    for p in (line .. "\t"):gmatch("([^\t]*)\t") do table.insert(parts, p) end
    if #parts >= 2 and #parts[1] > 0 then
      nameLines = nameLines .. "- " .. parts[1] .. " (" .. parts[2] .. ")\n"
    end
  end
  hotstrings.typeText(
    "Can I get Contact info for the following exited employee:\n" ..
    nameLines ..
    "I Need the following information to collect IT equipment:\nexternal email,\nphone number,\naddress"
  )
end)

-- Three-strikes escalation: clipboard = employee name/ID
hotstrings.add("]lescalate", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText("Three strikes. " .. cb .. " still deployed.\nEscalating to legal.")
end)

-- Asset scaffold: expects 5 tab-separated fields (Tag, Serial, Status, Status2, Model)
hotstrings.add("]assetScaff", function()
  local cb = (hs.pasteboard.getContents() or ""):gsub("\r\n", "\n"):gsub("\r", "\n")
  local parts = {}
  for p in (cb .. "\t"):gmatch("([^\t]*)\t") do table.insert(parts, p) end
  if #parts >= 5 then
    hotstrings.typeText("- " .. parts[5] .. " [SN: " .. parts[2] .. ", Tag: " .. parts[1] .. "]")
  else
    hs.alert.show("Expected 5 tab-separated fields, got " .. #parts)
  end
end)

-- Chat log label + paste clipboard
hotstrings.add("]cl", function()
  hotstrings.typeText("Chat log:")
  hs.eventtap.keyStroke({}, "return", 0)
  hs.eventtap.keyStroke({"cmd"}, "v", 0)
end)

-- ServiceNow URL builders (append clipboard value to URL)
hotstrings.add("]snowinc", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText("ebayinc.service-now.com/nav_to.do?uri=incident.do?sysparm_query=number%3D" .. cb)
end)

hotstrings.add("]snowtask", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText("ebayinc.service-now.com/nav_to.do?uri=task.do?sysparm_query=number%3D" .. cb)
end)

hotstrings.add("]snowsearch", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText("https://ebayinc.service-now.com/nav_to.do?uri=textsearch.do?sysparm_search=" .. cb)
end)

-- Convert clipboard string to NATO phonetic alphabet (one word per line)
hotstrings.add("]a2nato", function()
  local natoMap = {
    a="alpha", b="bravo", c="charlie", d="delta", e="echo", f="foxtrot",
    g="golf", h="hotel", i="india", j="juliet", k="kilo", l="lima",
    m="mike", n="november", o="oscar", p="papa", q="quebec", r="romeo",
    s="sierra", t="tango", u="uniform", v="victor", w="whiskey", x="x-ray",
    y="yankee", z="zulu",
    A="Alpha", B="Bravo", C="Charlie", D="Delta", E="Echo", F="Foxtrot",
    G="Golf", H="Hotel", I="India", J="Juliet", K="Kilo", L="Lima",
    M="Mike", N="November", O="Oscar", P="Papa", Q="Quebec", R="Romeo",
    S="Sierra", T="Tango", U="Uniform", V="Victor", W="Whiskey", X="X-Ray",
    Y="Yankee", Z="Zulu",
  }
  local cb = hs.pasteboard.getContents() or ""
  local result = ""
  for char in cb:gmatch(".") do
    result = result .. (natoMap[char] or char) .. "\n"
  end
  hotstrings.typeText(result)
end)

-- Tracking hyperlinks: types "Carrier: <tracking>", selects the number,
-- opens hyperlink dialog (Cmd+K), inserts URL. Works in Outlook/rich-text editors.
-- On Mac: Opt+Shift+Left selects word left (≈ Ctrl+Shift+Left on Windows).
local function trackingHyperlink(prefix, urlBase)
  return function()
    local cb = (hs.pasteboard.getContents() or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local url = urlBase .. cb
    hotstrings.typeText(prefix .. cb)
    hs.timer.doAfter(0.1, function()
      hs.eventtap.keyStroke({"alt", "shift"}, "left", 0)  -- select tracking number
      hs.timer.doAfter(0.1, function()
        hs.eventtap.keyStroke({"cmd"}, "k", 0)            -- open hyperlink dialog
        hs.timer.doAfter(0.15, function()
          hs.eventtap.keyStrokes(url)
          hs.eventtap.keyStroke({}, "return", 0)
          hs.eventtap.keyStroke({}, "right", 0)
        end)
      end)
    end)
  end
end

hotstrings.add("]feds", trackingHyperlink("FedEx: ", "https://www.fedex.com/fedextrack/?trknbr="))
hotstrings.add("]upss", trackingHyperlink("UPS: ",   "https://www.ups.com/track?track=yes&trackNums="))

-- 20-field form fill: expects tab-delimited row (from spreadsheet).
-- Fields used: sctask(4), costCenter(18), exitedNT(7), serial(13) → types + Tab, ends with 2x Enter.
hotstrings.add("]tcus", function()
  local cb = (hs.pasteboard.getContents() or ""):gsub("\r\n", "\n"):gsub("\r", "\n")
  local parts = {}
  for p in (cb .. "\t"):gmatch("([^\t]*)\t") do table.insert(parts, p) end
  if #parts >= 20 then
    for _, v in ipairs({ parts[4], parts[18], parts[7], parts[13], "1000" }) do
      hs.eventtap.keyStrokes(v)
      hs.eventtap.keyStroke({}, "tab", 0)
    end
    hs.eventtap.keyStroke({}, "return", 0)
    hs.eventtap.keyStroke({}, "return", 0)
  else
    hs.alert.show("Expected 20 tab-separated fields, got " .. #parts)
  end
end)
