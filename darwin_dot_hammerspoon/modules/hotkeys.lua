-- General hotkeys (non-work). Add hs.hotkey.bind() calls here.
-- Example:
--   hs.hotkey.bind({"cmd", "alt"}, "`", function() ... end)

local hotstrings = require("modules.hotstrings")

-- Date/time expansions
local function todaysDate()
  return os.date("%m/%d/%y")
end

local function fileFriendlyDate()
  return os.date("%Y-%m-%d")
end

local function timeNow()
  return os.date("%H:%M")
end

hotstrings.add("]d", function() hs.eventtap.keyStrokes(todaysDate()) end)
hotstrings.add("]fd", function() hs.eventtap.keyStrokes(fileFriendlyDate()) end)
hotstrings.add("]now", function() hs.eventtap.keyStrokes(timeNow()) end)
