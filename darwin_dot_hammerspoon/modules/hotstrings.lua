-- Text expansion engine. Watches keystrokes, matches triggers, fires expansions.
-- Usage: M.add("]trigger", "replacement text")
--        M.add("]trigger", function() ... end)  -- for clipboard/dynamic expansions
-- Call M.start() after adding all expansions.

local M = {}
local buffer = ""
local expansions = {}

local tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
  local keyCode = e:getKeyCode()
  local char = e:getCharacters(true)

  if keyCode == 51 then -- delete/backspace
    buffer = buffer:sub(1, -2)
    return false
  end

  if char and #char == 1 and not e:getFlags().cmd and not e:getFlags().ctrl then
    buffer = buffer .. char

    for trigger, action in pairs(expansions) do
      if buffer:sub(-#trigger) == trigger then
        buffer = ""
        for _ = 1, #trigger do
          hs.eventtap.keyStroke({}, "delete", 0)
        end
        if type(action) == "function" then
          action()
        else
          hs.eventtap.keyStrokes(action)
        end
        return true
      end
    end

    if #buffer > 64 then
      buffer = buffer:sub(-64)
    end
  else
    buffer = ""
  end

  return false
end)

function M.add(trigger, action)
  expansions[trigger] = action
end

function M.start()
  tap:start()
end

function M.stop()
  tap:stop()
end

return M
