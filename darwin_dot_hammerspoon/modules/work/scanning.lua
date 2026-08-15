-- Scan mode: intercepts Enter → Tab for barcode scanning in spreadsheets.
-- Toggle: Cmd+Opt+- (replaces Win+- from AHK; Cmd+- conflicts with Excel delete-cells).
-- On enable: chooser asks whether to also send Down+Home after every 2nd scan.

local M = {}
local scanActive = false
local autoNav = false
local scanCount = 0

local enterTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
  if e:getKeyCode() == hs.keycodes.map["return"] then
    scanCount = scanCount + 1
    hs.eventtap.keyStroke({}, "tab", 0)
    if autoNav and (scanCount % 2 == 0) then
      hs.timer.doAfter(0.03, function()
        hs.eventtap.keyStroke({}, "down", 0)
        hs.eventtap.keyStroke({}, "home", 0)
      end)
    end
    return true
  end
  return false
end)

hs.hotkey.bind({ "cmd", "alt" }, "-", function()
  if scanActive then
    enterTap:stop()
    scanActive = false
    autoNav = false
    scanCount = 0
    hs.alert.show("Scan Mode OFF")
    return
  end

  local chooser = hs.chooser.new(function(choice)
    if not choice then return end
    autoNav = choice.autoNav
    scanCount = 0
    enterTap:start()
    scanActive = true
    hs.alert.show("Scan Mode ON" .. (autoNav and " + AutoNav" or ""))
  end)

  chooser:choices({
    {
      text = "Scan only",
      subText = "Enter → Tab",
      autoNav = false,
    },
    {
      text = "Scan + AutoNav",
      subText = "Enter → Tab, then Down+Home after every 2nd scan",
      autoNav = true,
    },
  })
  chooser:show()
end)

return M
