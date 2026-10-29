-- String utility hotstrings. All triggers use ]s- prefix.
-- Reads from pasteboard, outputs via hotstrings.typeText().

local hotstrings = require("modules.hotstrings")

-- ┌─────────────────────────────────────────────────────────────┐
-- │  Hotstring registrations                                    │
-- └─────────────────────────────────────────────────────────────┘

-- Trim: strip leading/trailing whitespace from each line
hotstrings.add("]s-trim", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(trimLines(cb))
end)

-- Dedent: remove common leading whitespace from all non-empty lines
hotstrings.add("]s-dedent", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(dedent(cb))
end)

-- Uppercase
hotstrings.add("]s-upper", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(cb:upper())
end)

-- Lowercase
hotstrings.add("]s-lower", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(cb:lower())
end)

-- Auto-capitalize: first char, after sentence endings, standalone i → I
hotstrings.add("]s-caps", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(autoCaps(cb))
end)

-- Title Case: capitalize first letter of every word
hotstrings.add("]s-title", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(titleCase(cb))
end)

-- snake_case
hotstrings.add("]s-snake", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(toSnake(cb))
end)

-- PascalCase
hotstrings.add("]s-pascal", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(toPascal(cb))
end)

-- camelCase
hotstrings.add("]s-camel", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(toCamel(cb))
end)

-- Spongebob mock: alternate upper/lower per letter
hotstrings.add("]s-mock", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(mockCase(cb))
end)

-- URL slug: lowercase, spaces/underscores → hyphens, strip non-alnum/hyphen
hotstrings.add("]s-slug", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(toSlug(cb))
end)

-- Sort lines A→Z (case-insensitive)
hotstrings.add("]s-sort", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(sortLines(cb, false))
end)

-- Sort lines Z→A (case-insensitive)
hotstrings.add("]s-sortd", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(sortLines(cb, true))
end)

-- Unique lines: remove duplicates, preserve first-occurrence order
hotstrings.add("]s-uniq", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(uniqueLines(cb))
end)

-- Indent duplicates: first occurrence as-is, repeats prefixed with 2 spaces
hotstrings.add("]s-idups", function()
  local cb = hs.pasteboard.getContents() or ""
  hotstrings.typeText(indentDups(cb))
end)

-- ┌─────────────────────────────────────────────────────────────┐
-- │  Helper functions                                           │
-- └─────────────────────────────────────────────────────────────┘

-- Split text into lines, preserving blank lines.
-- Returns table of line strings (without newline chars).
local function splitLines(text)
  text = text:gsub("\r\n", "\n"):gsub("\r", "\n")
  local lines = {}
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    table.insert(lines, line)
  end
  -- gmatch always appends one extra empty string from the sentinel "\n" we added.
  -- Remove it only when the original text did not end with a newline.
  if text:sub(-1) ~= "\n" and #lines > 0 and lines[#lines] == "" then
    table.remove(lines)
  end
  return lines
end

function trimLines(text)
  local lines = splitLines(text)
  for i, line in ipairs(lines) do
    lines[i] = line:match("^%s*(.-)%s*$")
  end
  return table.concat(lines, "\n")
end

function dedent(text)
  local lines = splitLines(text)
  -- Find minimum indent across all non-empty lines
  local minIndent = math.huge
  for _, line in ipairs(lines) do
    if line:match("%S") then  -- non-empty (has at least one non-space char)
      local indent = #line:match("^(%s*)")
      if indent < minIndent then
        minIndent = indent
      end
    end
  end
  if minIndent == math.huge or minIndent == 0 then
    return table.concat(lines, "\n")
  end
  for i, line in ipairs(lines) do
    if line:match("%S") then
      lines[i] = line:sub(minIndent + 1)
    end
    -- blank lines are left as-is (they may have fewer leading spaces than minIndent)
  end
  return table.concat(lines, "\n")
end

function autoCaps(text)
  if #text == 0 then return text end

  -- Capitalize first non-space character
  local result = text:gsub("^(%s*)(%a)", function(spaces, ch)
    return spaces .. ch:upper()
  end, 1)

  -- Capitalize first letter after sentence-ending punctuation followed by a space
  result = result:gsub("([%.!%?] )(%a)", function(punct, ch)
    return punct .. ch:upper()
  end)

  -- Standalone "i" → "I": at start, at end, or surrounded by spaces
  result = result:gsub("^(i)(%s)", function(_, sp) return "I" .. sp end)
  result = result:gsub("(%s)(i)(%s)", function(a, _, b) return a .. "I" .. b end)
  result = result:gsub("(%s)(i)$", function(sp, _) return sp .. "I" end)

  return result
end

function titleCase(text)
  return text:gsub("(%S+)", function(word)
    return word:sub(1, 1):upper() .. word:sub(2):lower()
  end)
end

-- Split a string into identifier parts by splitting on spaces, hyphens,
-- underscores, and camelCase/PascalCase word boundaries.
local function splitWords(text)
  -- Insert a space before uppercase letters that follow a lowercase letter or digit
  -- (camelCase/PascalCase boundaries), then split on non-alphanumeric runs.
  local spaced = text:gsub("(%l)(%u)", "%1 %2"):gsub("(%d)(%u)", "%1 %2")
  local parts = {}
  for word in spaced:gmatch("[%w]+") do
    table.insert(parts, word)
  end
  return parts
end

function toSnake(text)
  local parts = splitWords(text)
  for i, p in ipairs(parts) do
    parts[i] = p:lower()
  end
  return table.concat(parts, "_")
end

function toPascal(text)
  local parts = splitWords(text)
  for i, p in ipairs(parts) do
    parts[i] = p:sub(1, 1):upper() .. p:sub(2):lower()
  end
  return table.concat(parts)
end

function toCamel(text)
  local parts = splitWords(text)
  for i, p in ipairs(parts) do
    if i == 1 then
      parts[i] = p:lower()
    else
      parts[i] = p:sub(1, 1):upper() .. p:sub(2):lower()
    end
  end
  return table.concat(parts)
end

function mockCase(text)
  local result = {}
  local letterCount = 0  -- counts only letters; starts at 0 so first letter → index 1 → upper
  for i = 1, #text do
    local ch = text:sub(i, i)
    if ch:match("%a") then
      letterCount = letterCount + 1
      if letterCount % 2 == 1 then
        table.insert(result, ch:upper())
      else
        table.insert(result, ch:lower())
      end
    else
      table.insert(result, ch)
    end
  end
  return table.concat(result)
end

function toSlug(text)
  local s = text:lower()
  s = s:gsub("[ _]", "-")       -- spaces and underscores → hyphens
  s = s:gsub("[^%a%d%-]", "")   -- strip all non-alphanumeric, non-hyphen chars
  s = s:gsub("%-+", "-")        -- collapse multiple hyphens
  s = s:gsub("^%-+", ""):gsub("%-+$", "")  -- trim leading/trailing hyphens
  return s
end

function sortLines(text, descending)
  local lines = splitLines(text)
  table.sort(lines, function(a, b)
    local la, lb = a:lower(), b:lower()
    if descending then return la > lb else return la < lb end
  end)
  return table.concat(lines, "\n")
end

function uniqueLines(text)
  local lines = splitLines(text)
  local seen = {}
  local result = {}
  for _, line in ipairs(lines) do
    if not seen[line] then
      seen[line] = true
      table.insert(result, line)
    end
  end
  return table.concat(result, "\n")
end

function indentDups(text)
  local lines = splitLines(text)
  local seen = {}
  local result = {}
  for _, line in ipairs(lines) do
    if seen[line] then
      table.insert(result, "  " .. line)
    else
      seen[line] = true
      table.insert(result, line)
    end
  end
  return table.concat(result, "\n")
end
