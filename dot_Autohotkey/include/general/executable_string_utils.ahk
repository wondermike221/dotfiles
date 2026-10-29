; String utility hotstrings — all read from A_Clipboard and output via SendText
; Trigger prefix: ]s-

; --- Simple inline transforms ---
:X:]s-upper::SendText(StrUpper(A_Clipboard))
:X:]s-lower::SendText(StrLower(A_Clipboard))

; --- Multi-line transforms (call named helpers) ---
:X:]s-trim::SendText(StringTrim(A_Clipboard))
:X:]s-dedent::SendText(StringDedent(A_Clipboard))
:X:]s-caps::SendText(StringAutoCaps(A_Clipboard))
:X:]s-title::SendText(StringTitleCase(A_Clipboard))
:X:]s-snake::SendText(StringSnakeCase(A_Clipboard))
:X:]s-pascal::SendText(StringPascalCase(A_Clipboard))
:X:]s-camel::SendText(StringCamelCase(A_Clipboard))
:X:]s-mock::SendText(StringMockCase(A_Clipboard))
:X:]s-slug::SendText(StringSlug(A_Clipboard))
:X:]s-sort::SendText(StringSortLines(A_Clipboard, false))
:X:]s-sortd::SendText(StringSortLines(A_Clipboard, true))
:X:]s-uniq::SendText(StringUniqLines(A_Clipboard))
:X:]s-idups::SendText(StringIndentDups(A_Clipboard))

; ---------------------------------------------------------------------------
; Helper functions
; ---------------------------------------------------------------------------

/**
 * Splits text into lines, normalizing CRLF → LF.
 * Returns an Array of line strings.
 */
SplitLines(text) {
    clean := StrReplace(text, "`r", "")
    return StrSplit(clean, "`n")
}

/**
 * Strips leading and trailing whitespace from each line.
 * Blank lines are preserved.
 */
StringTrim(text) {
    lines := SplitLines(text)
    result := []
    for line in lines {
        result.Push(Trim(line))
    }
    return StrJoin(result, "`n")
}

/**
 * Removes the common leading whitespace prefix from every line
 * (equivalent to Python's textwrap.dedent).
 * Empty lines are ignored when computing the minimum indent.
 */
StringDedent(text) {
    lines := SplitLines(text)

    ; Find minimum indent across non-empty lines
    minIndent := -1
    for line in lines {
        if (line = "")
            continue
        indent := 0
        loop StrLen(line) {
            ch := SubStr(line, A_Index, 1)
            if (ch = " " || ch = "`t")
                indent++
            else
                break
        }
        if (minIndent = -1 || indent < minIndent)
            minIndent := indent
    }

    if (minIndent <= 0)
        return text

    result := []
    for line in lines {
        if (line = "")
            result.Push("")
        else
            result.Push(SubStr(line, minIndent + 1))
    }
    return StrJoin(result, "`n")
}

/**
 * Auto-capitalizes text:
 *   1. First non-space character of the entire text.
 *   2. First letter after sentence-ending ". ", "! ", or "? ".
 *   3. Standalone word "i" → "I" (surrounded by spaces or at start/end of text).
 */
StringAutoCaps(text) {
    ; Capitalize first non-space character
    pos := 1
    loop StrLen(text) {
        if (SubStr(text, A_Index, 1) != " ") {
            pos := A_Index
            break
        }
    }
    text := SubStr(text, 1, pos - 1) . StrUpper(SubStr(text, pos, 1)) . SubStr(text, pos + 1)

    ; Capitalize after sentence endings: ". ", "! ", "? "
    for ending in [". ", "! ", "? "] {
        startPos := 1
        loop {
            found := InStr(text, ending, true, startPos)
            if (!found)
                break
            ; Position of the character after the space
            capPos := found + StrLen(ending)
            if (capPos > StrLen(text))
                break
            text := SubStr(text, 1, capPos - 1) . StrUpper(SubStr(text, capPos, 1)) . SubStr(text, capPos + 1)
            startPos := capPos + 1
        }
    }

    ; Standalone "i" → "I"
    ; Match: start-of-string i end-of-string, or space-i-space, space-i-end, start-i-space
    result := ""
    chars := StrSplit(text, " ")
    for idx, word in chars {
        if (word = "i")
            result .= (idx > 1 ? " " : "") . "I"
        else
            result .= (idx > 1 ? " " : "") . word
    }
    return result
}

/**
 * Title-cases text: first letter of every word uppercase, rest lowercase.
 * All words, no exceptions.
 */
StringTitleCase(text) {
    words := StrSplit(text, " ")
    result := []
    for word in words {
        if (StrLen(word) = 0)
            result.Push("")
        else
            result.Push(StrUpper(SubStr(word, 1, 1)) . StrLower(SubStr(word, 2)))
    }
    return StrJoin(result, " ")
}

/**
 * Splits input on word boundaries (spaces, hyphens, underscores, camelCase)
 * and returns an Array of lowercase parts.
 */
SplitWords(text) {
    ; Insert underscore before uppercase-after-lowercase transitions (camelCase)
    result := ""
    loop StrLen(text) {
        ch := SubStr(text, A_Index, 1)
        if (A_Index > 1) {
            prev := SubStr(text, A_Index - 1, 1)
            if (ch >= "A" && ch <= "Z" && prev >= "a" && prev <= "z")
                result .= "_"
        }
        result .= ch
    }
    ; Replace spaces, hyphens, underscores with underscores
    result := StrReplace(result, " ", "_")
    result := StrReplace(result, "-", "_")
    ; Lowercase everything
    result := StrLower(result)
    ; Split on underscores, filtering empty parts
    raw := StrSplit(result, "_")
    parts := []
    for part in raw {
        if (part != "")
            parts.Push(part)
    }
    return parts
}

/**
 * Converts text to snake_case.
 */
StringSnakeCase(text) {
    parts := SplitWords(text)
    return StrJoin(parts, "_")
}

/**
 * Converts text to PascalCase.
 */
StringPascalCase(text) {
    parts := SplitWords(text)
    result := ""
    for part in parts {
        result .= StrUpper(SubStr(part, 1, 1)) . SubStr(part, 2)
    }
    return result
}

/**
 * Converts text to camelCase.
 */
StringCamelCase(text) {
    parts := SplitWords(text)
    result := ""
    for idx, part in parts {
        if (idx = 1)
            result .= part
        else
            result .= StrUpper(SubStr(part, 1, 1)) . SubStr(part, 2)
    }
    return result
}

/**
 * Spongebob mock case: alternate upper/lower for each letter.
 * Spaces and punctuation are output unchanged and do not affect the alternation counter.
 */
StringMockCase(text) {
    result := ""
    letterIdx := 0
    loop StrLen(text) {
        ch := SubStr(text, A_Index, 1)
        if ((ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z")) {
            letterIdx++
            if (Mod(letterIdx, 2) = 1)
                result .= StrUpper(ch)
            else
                result .= StrLower(ch)
        } else {
            result .= ch
        }
    }
    return result
}

/**
 * Converts text to a URL slug:
 * lowercase, spaces/underscores → hyphens, strip non-alphanumeric/non-hyphen,
 * collapse multiple hyphens, trim hyphens from start/end.
 */
StringSlug(text) {
    result := StrLower(text)
    result := StrReplace(result, " ", "-")
    result := StrReplace(result, "_", "-")

    ; Strip non-alphanumeric/non-hyphen characters
    clean := ""
    loop StrLen(result) {
        ch := SubStr(result, A_Index, 1)
        if ((ch >= "a" && ch <= "z") || (ch >= "0" && ch <= "9") || ch = "-")
            clean .= ch
    }

    ; Collapse multiple consecutive hyphens
    loop {
        prev := clean
        clean := StrReplace(clean, "--", "-")
        if (clean = prev)
            break
    }

    ; Trim leading/trailing hyphens
    while (SubStr(clean, 1, 1) = "-")
        clean := SubStr(clean, 2)
    while (SubStr(clean, StrLen(clean), 1) = "-")
        clean := SubStr(clean, 1, StrLen(clean) - 1)

    return clean
}

/**
 * Sorts lines alphabetically (ascending or descending, case-insensitive).
 */
StringSortLines(text, descending) {
    lines := SplitLines(text)
    n := lines.Length

    ; Insertion sort (simple, correct for small-to-medium inputs)
    loop n - 1 {
        i := A_Index + 1
        while (i > 1) {
            a := StrLower(lines[i - 1])
            b := StrLower(lines[i])
            shouldSwap := descending ? (a < b) : (a > b)
            if (shouldSwap) {
                tmp := lines[i - 1]
                lines[i - 1] := lines[i]
                lines[i] := tmp
                i--
            } else {
                break
            }
        }
    }

    return StrJoin(lines, "`n")
}

/**
 * Removes duplicate lines, preserving the order of first occurrence.
 * Comparison is case-sensitive.
 */
StringUniqLines(text) {
    lines := SplitLines(text)
    seen := Map()
    result := []
    for line in lines {
        if (!seen.Has(line)) {
            seen.Set(line, true)
            result.Push(line)
        }
    }
    return StrJoin(result, "`n")
}

/**
 * Identifies duplicate lines. Outputs the first occurrence as-is;
 * every subsequent occurrence of a duplicate line is indented with 2 spaces.
 */
StringIndentDups(text) {
    lines := SplitLines(text)

    ; Count occurrences of each line
    counts := Map()
    for line in lines {
        if (counts.Has(line))
            counts.Set(line, counts.Get(line) + 1)
        else
            counts.Set(line, 1)
    }

    ; Build output: first occurrence as-is, subsequent ones indented
    seen := Map()
    result := []
    for line in lines {
        if (counts.Get(line) > 1) {
            if (!seen.Has(line)) {
                seen.Set(line, true)
                result.Push(line)
            } else {
                result.Push("  " . line)
            }
        } else {
            result.Push(line)
        }
    }

    return StrJoin(result, "`n")
}

/**
 * Joins an Array of strings with a separator.
 */
StrJoin(arr, sep) {
    result := ""
    for idx, item in arr {
        if (idx > 1)
            result .= sep
        result .= item
    }
    return result
}
