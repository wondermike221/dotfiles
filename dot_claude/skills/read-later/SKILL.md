---
name: read-later
description: Converts browser tab URLs into organized Obsidian notes — one file per URL with title, source, description, AI summary, and opening content. Reads from clipboard or pasted input. Saves to Read Later/ at vault root. Trigger: /read-later
trigger: /read-later
---

# /read-later

Turn a browser tab dump into organized Obsidian notes. One file per URL, saved to `Read Later/` at vault root (`C:\Users\mhixon\life\Read Later\`). Each note has Clippings-style frontmatter, a 2-3 sentence summary, and the opening content of the article.

## Usage

```
/read-later              # reads URLs from clipboard
/read-later <urls>       # processes URLs pasted after the command
```

## What You Must Do When Invoked

### Step 1 — Get URLs

If the user pasted URLs directly in their message (after the `/read-later` command), use those.

Otherwise, run:
```powershell
Get-Clipboard
```

Parse: split by newlines, keep lines starting with `http://` or `https://`. Skip blank lines and non-URL text. Deduplicate. Strip trailing whitespace.

Print: `Found N URLs to process.`

If 0 URLs found: tell user to paste URLs or copy them to clipboard first, then stop.

### Step 2 — Fetch metadata in parallel

**MANDATORY: Use the Agent tool. Dispatch all subagents in a single message so they run in parallel. Never process URLs one-by-one inline — it is far too slow for large tab dumps.**

Batch size:
- ≤ 10 URLs: 1 URL per subagent
- 11–30 URLs: 3 URLs per subagent
- 31+ URLs: 5 URLs per subagent

For each batch, dispatch a general-purpose subagent with this prompt (substitute BATCH_URLS with the actual URL list, one per line):

```
You are a read-later content extractor for Obsidian. For each URL in your batch, extract metadata and content, then return structured JSON.

URLs:
BATCH_URLS

For EACH URL, do the following in order:

1. Run defuddle to get content:
   defuddle parse "<URL>" --json
   
   If defuddle is not installed, install it first: npm install -g defuddle
   
   If defuddle fails for a URL (network error, paywall, timeout), use this fallback:
   defuddle parse "<URL>" -p title
   defuddle parse "<URL>" -p description
   
   If all fetches fail, set error=true and continue.

2. From the defuddle JSON output, extract:
   - title: the page title (clean it — remove site name suffixes like " | TechCrunch")
   - description: og:description or meta description
   - published: publication date as YYYY-MM-DD if present, else null
   - domain: the site domain name (e.g. "github.com", "arstechnica.com")
   - content: the markdown body content

3. Write a 2-3 sentence summary. Focus on: what is this, what will the reader learn or get, why is it worth saving. Write in plain prose, not bullet points.

4. Extract the opening content: take the first ~600 characters of the markdown content (whole sentences/paragraphs only — don't cut mid-sentence). This is the "first section" to include in the note.

5. Guess 1-3 topic tags from the content (lowercase, hyphen-separated words). Always include "read-later".

6. Sanitize the title for a Windows filename:
   - Remove these characters: \ / : * ? " < > |
   - Replace multiple spaces with single space
   - Trim trailing periods and spaces
   - Truncate to 80 characters

Return a JSON array — one object per URL, in the same order as input:

[
  {
    "url": "https://...",
    "title": "Clean Article Title",
    "filename": "Clean Article Title",
    "description": "...",
    "domain": "example.com",
    "published": "2025-03-01",
    "summary": "2-3 sentence summary.",
    "opening": "First ~600 chars of article content...",
    "tags": ["read-later", "homelab"],
    "error": false
  }
]

For failed URLs set error=true, use the domain as title/filename, leave summary as "Could not fetch content — open URL to read.", and opening as "".

Return ONLY the JSON array. No markdown fences, no explanation.
```

Collect all subagent results. Merge the arrays back into a flat list in original URL order.

### Step 3 — Create Obsidian notes

Ensure the target directory exists:
```
C:\Users\mhixon\life\Read Later\
```

For each result object, write a file at:
```
C:\Users\mhixon\life\Read Later\<filename>.md
```

If a file with that name already exists, append ` 2`, ` 3`, etc. before the `.md` extension.

Note format (Clippings-style frontmatter):

```markdown
---
title: "<title>"
source: "<url>"
author:
  - "[[<domain>]]"
published: <YYYY-MM-DD, or leave key absent if null>
created: <today's date YYYY-MM-DD>
description: "<description>"
tags:
  - read-later
  - <tag2>
  - <tag3>
---

<summary paragraph>

---

<opening section content>
```

Omit the `published:` key entirely if null. Omit the `---` separator and opening section block if `opening` is empty.

### Step 4 — Report

Print a compact summary:

```
Saved N notes to Read Later/

  ✓ Title of note 1
  ✓ Title of note 2
  ⚠ domain.com — fetch failed (URL saved, open to read)
  ...

Tip: Review in Obsidian and move promising ones to your Clippings/ or Efforts/ folders as you read.
```

List all notes. Error notes get ⚠ instead of ✓.

If more than 20 notes were saved, offer to group them by tag.
