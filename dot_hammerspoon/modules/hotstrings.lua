-- Text expansion engine. Watches keystrokes, matches triggers, fires expansions.
-- Usage: M.add("]trigger", "static text")
--        M.add("]trigger", function() ... end)  -- for clipboard/dynamic expansions
-- Handles \n (newlines) and \t (tabs) in string expansions.
-- Call M.start() after all expansions are registered.

local M = {}
local buffer = ""
local expansions = {}

local function typeSegment(text)
  local parts = {}
  for part in (text .. "\t"):gmatch("([^\t]*)\t") do
    table.insert(parts, part)
  end
  for i, part in ipairs(parts) do
    if #part > 0 then hs.eventtap.keyStrokes(part) end
    if i < #parts then hs.eventtap.keyStroke({}, "tab", 0) end
  end
end

local function typeText(text)
  text = text:gsub("\r\n", "\n"):gsub("\n$", "")
  local lines = {}
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    table.insert(lines, line)
  end
  for i, line in ipairs(lines) do
    typeSegment(line)
    if i < #lines then hs.eventtap.keyStroke({}, "return", 0) end
  end
end

M.typeText = typeText

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
          typeText(action)
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

-- General expansions
M.add("]shrug", "¯\\_(ツ)_/¯")
M.add("]nato", "https://militaryalphabet.net/")

-- NATO phonetic alphabet: ]na through ]nz
local natoWords = {
  "Alpha","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel",
  "India","Juliet","Kilo","Lima","Mike","November","Oscar","Papa",
  "Quebec","Romeo","Sierra","Tango","Uniform","Victor","Whiskey",
  "X-Ray","Yankee","Zulu",
}
local alpha = "abcdefghijklmnopqrstuvwxyz"
for i = 1, 26 do
  M.add("]n" .. alpha:sub(i, i), natoWords[i])
end

-- Clipboard → comma-separated values
M.add("]csv", function()
  local cb = hs.pasteboard.getContents() or ""
  cb = cb:gsub("\r\n", ","):gsub("\n", ",")
  typeText(cb)
end)

-- Form filler: types tab-delimited clipboard data into form fields.
-- Tab between cells, Enter between rows, no trailing Enter on empty last row.
M.add("]formfill", function()
  local input = hs.pasteboard.getContents() or ""
  input = input:gsub("\r\n", "\n"):gsub("\r", "\n")
  input = input:gsub("\n$", "")

  local rows = {}
  for row in (input .. "\n"):gmatch("([^\n]*)\n") do
    table.insert(rows, row)
  end

  for i, row in ipairs(rows) do
    local fields = {}
    for field in (row .. "\t"):gmatch("([^\t]*)\t") do
      table.insert(fields, field)
    end
    for j, field in ipairs(fields) do
      if #field > 0 then hs.eventtap.keyStrokes(field) end
      if j < #fields then hs.eventtap.keyStroke({}, "tab", 0) end
    end
    if i < #rows or rows[#rows] ~= "" then
      hs.eventtap.keyStroke({}, "return", 0)
    end
  end
end)

return M
