-- Scan mode: intercepts Enter → Tab for barcode scanning in spreadsheets.
-- Toggle: Cmd+Opt+- (replaces Win+- from AHK; Cmd+- conflicts with Excel delete-cells).
-- On enable: chooser asks whether to also send Down+Home after every 2nd scan.
--
-- STANDALONE USE (share with coworkers):
--   1. Copy this file to ~/.hammerspoon/scanning.lua
--   2. ~/.hammerspoon/init.lua needs at minimum:
--        require("scanning")
--      If init.lua doesn't exist yet, that single line is the whole file.

local M = {}
local scanActive = false
local autoNav = false
local scanCount = 0
local menubar = nil
local enterTap -- forward-declared; defined below

local function disableScan()
  enterTap:stop()
  scanActive = false
  autoNav = false
  scanCount = 0
  if menubar then menubar:delete(); menubar = nil end
  hs.alert.show("Scan Mode OFF")
end

local function enableMenubar()
  menubar = hs.menubar.new()
  menubar:setTitle(autoNav and "↩→⇥↓" or "↩→⇥")
  menubar:setTooltip("Scan Mode active — ↩ (return) is remapped to ⇥ (tab). Click to disable.")
  menubar:setMenu(function()
    return {
      { title = "Scan Mode Active",                                              disabled = true },
      { title = autoNav and "Mode: Scan + AutoNav" or "Mode: Scan only",        disabled = true },
      { title = string.format("Scans this session: %d", scanCount),             disabled = true },
      { title = "-" },
      { title = "Disable  (⌘⌥-)", fn = disableScan },
    }
  end)
end

enterTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
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
    disableScan()
    return
  end

  local chooser = hs.chooser.new(function(choice)
    if not choice then return end
    autoNav = choice.autoNav
    scanCount = 0
    enterTap:start()
    scanActive = true
    enableMenubar()
    hs.alert.show("Scan Mode ON — ↩ remapped to ⇥" .. (autoNav and " + AutoNav" or ""), 3)
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
