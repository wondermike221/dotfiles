# AHK Dotfiles Merge Guide

## The Situation

| Location | State |
|---|---|
| This machine (personal) | Reorganized structure pushed to `origin/main` |
| Work machine | Has local commits/changes on the old flat structure |

Your work changes fall into three categories with different strategies for each.

---

## Step 1 — Commit your work changes first

Before pulling anything, make sure your work changes are captured in chezmoi and committed locally. If they aren't yet:

```bash
chezmoi re-add ~/.Autohotkey/
chezmoi git -- add dot_Autohotkey/
chezmoi git -- commit -m "work: snippet manager and hotstring additions"
```

Run `chezmoi git -- log --oneline -5` to confirm you have a local commit on top of the old origin.

---

## Step 2 — Pull via rebase

Rebase is cleaner than merge here since your work commits are just additions on top of the old structure:

```bash
chezmoi git -- fetch origin
chezmoi git -- rebase origin/main
```

Git should detect that the old flat files were renamed to subdirectories and attempt to carry your changes forward automatically. After the rebase, check `chezmoi git -- status` before continuing.

---

## Step 3 — Handle each change

### `start.bat` — discard the work version

Your work fix is superseded by the `%~dp0` fix here. If you get a conflict, take origin's version:

```bash
# Inside the chezmoi source dir
chezmoi git -- checkout --theirs dot_Autohotkey/executable_start.bat
chezmoi git -- add dot_Autohotkey/executable_start.bat
```

Then `chezmoi git -- rebase --continue`.

---

### Snippet manager — place it in the right directory

This is a new file with no conflict. The only question is where it lands after the rebase.

**If it shows up at the old flat path** (`dot_Autohotkey/include/snippet_manager.ahk` or similar), move it to the right place manually:

```bash
# In the chezmoi source dir
mv dot_Autohotkey/include/snippet_manager.ahk dot_Autohotkey/include/work/snippet_manager.ahk
chezmoi git -- add dot_Autohotkey/include/
```

Since you said it has very little personal/work overlap and you want to split it later, **put it in `include/work/` for now**. It will auto-load on work machines and be invisible on personal ones. When you're ready to split it, pull out the general parts into `include/general/`.

**If it isn't tracked by chezmoi yet** (you only created the file, never ran `chezmoi add`), just add it from the target side after the rebase:

```bash
chezmoi add ~/.Autohotkey/include/work/snippet_manager.ahk
```

---

### Work hotstrings — the trickiest part

Your additions were made to the old `include/work_hotstrings.ahk`. That file was renamed to `include/work/work_hotstrings.ahk` in the reorganization.

**Best case — git auto-merges the rename:** After the rebase, check the new path and confirm your additions are there:

```bash
# Spot check
chezmoi git -- diff HEAD~1 dot_Autohotkey/include/work/work_hotstrings.ahk
```

**If git doesn't follow the rename** and you see a conflict or your additions are missing:

1. Before starting the rebase, copy your new hotstrings to a temp file:
   ```bash
   chezmoi git -- show HEAD:dot_Autohotkey/include/work_hotstrings.ahk > /tmp/work_hotstrings_backup.txt
   ```
2. Proceed with the rebase, taking origin's version of the file if needed
3. Manually append your hotstrings to `dot_Autohotkey/include/work/work_hotstrings.ahk`
4. Stage and continue: `chezmoi git -- add dot_Autohotkey/ && chezmoi git -- rebase --continue`

---

## Step 4 — Verify and push

```bash
chezmoi status                      # should be empty if source matches target
chezmoi git -- log --oneline -5     # confirm clean history
chezmoi git -- push
```

If `chezmoi status` still shows diffs after the rebase (because files landed in wrong paths), use `chezmoi add` / `chezmoi forget` to reconcile, then amend or add a fixup commit.

---

## Quick reference: paths that changed

| Old path | New path |
|---|---|
| `include/hotstrings.ahk` | `include/general/hotstrings.ahk` |
| `include/nato.txt` | `include/general/nato.txt` |
| `include/auto_qr.ahk` | `include/work/auto_qr.ahk` |
| `include/work_hotkeys.ahk` | `include/work/work_hotkeys.ahk` |
| `include/work_hotstrings.ahk` | `include/work/work_hotstrings.ahk` |
| `hotstrings/-ayubi.txt` | `hotstrings/work/-ayubi.txt` |
| *(new)* | `include/general/hotkeys.ahk` |
| *(new)* | `include/work/enter_tab_toggle.ahk` |
