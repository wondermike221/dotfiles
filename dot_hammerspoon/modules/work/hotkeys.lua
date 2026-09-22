-- Work-specific hotkeys. Only loaded when IS_WORK = true.

require("modules.work.scanning")

-- Tracking opener: detect carrier from clipboard, open in Chrome.
-- Cmd+Opt+T (replaces Win+T; Cmd+T = new tab in most apps).
-- Patterns: UPS = 1Z + 16 alphanum; FedEx = 12/15/20/22 digits or 96+20 digits or DT+digits.
local function openInChrome(url)
  if hs.application.find("Google Chrome") then
    hs.urlevent.openURLWithBundle(url, "com.google.Chrome")
  else
    hs.urlevent.openURL(url)
  end
end

hs.hotkey.bind({ "cmd", "alt" }, "t", function()
  local trk = (hs.pasteboard.getContents() or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if #trk > 2000 then
    hs.alert.show("Clipboard too large for tracking (" .. #trk .. " chars)")
    return
  end
  local url
  if trk:match("^1Z[A-Z0-9]+$") and #trk == 18 then
    url = "https://www.ups.com/track?track=yes&trackNums=" .. trk
  elseif (trk:match("^%d+$") and ({[12]=1,[15]=1,[20]=1,[22]=1})[#trk])
      or (trk:match("^96%d+$") and #trk == 22)
      or trk:match("^DT%d+$") then
    url = "https://www.fedex.com/fedextrack/?trknbr=" .. trk
  else
    url = "https://www.google.com/search?q=" .. trk:gsub(" ", "+")
  end
  openInChrome(url)
end)

-- Search Outlook/Mail with clipboard: Ctrl+Cmd+Shift+C (replaces Ctrl+Alt+Shift+C).
-- Activates Outlook (or Mail), focuses search, clears, pastes, submits.
hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "c", function()
  local app = hs.application.find("Microsoft Outlook") or hs.application.find("Mail")
  if not app then
    hs.alert.show("Outlook / Mail not running")
    return
  end
  app:activate()
  hs.timer.doAfter(0.15, function()
    hs.eventtap.keyStroke({ "cmd" }, "f", 0)
    hs.timer.doAfter(0.1, function()
      hs.eventtap.keyStroke({ "cmd" }, "a", 0)
      hs.eventtap.keyStroke({}, "delete", 0)
      hs.eventtap.keyStroke({ "cmd" }, "v", 0)
      hs.eventtap.keyStroke({}, "return", 0)
    end)
  end)
end)

-- Search ServiceNow: opens search URL in Chrome with clipboard as query.
-- Ctrl+Cmd+Shift+S (replaces Ctrl+Alt+Shift+S).
-- Simpler than AHK version which sent browser hotkeys; opening URL directly is more reliable.
hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "s", function()
  local cb = (hs.pasteboard.getContents() or ""):gsub("^%s+", ""):gsub("%s+$", "")
  local url = "https://ebayinc.service-now.com/nav_to.do?uri=textsearch.do?sysparm_search=" .. cb
  openInChrome(url)
end)
