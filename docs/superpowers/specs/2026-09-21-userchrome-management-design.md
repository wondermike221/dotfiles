# userChrome.css management via chezmoi

Date: 2026-09-21

## Problem

Michael runs LibreWolf (and potentially other Firefox-family browsers) with the
tab bar hidden via `userChrome.css`, to work with the Sidebery extension
(sidebar tab tree instead of top tabs). This CSS currently lives only in the
live profile directory and isn't managed by chezmoi, so it's not backed up,
versioned, or reproduced on a new machine.

Firefox-family browsers store profile data under a per-install directory with
a randomized hash (e.g. `LibreWolf/Profiles/0umq3p27.default-default`), so
chezmoi can't target the file with a plain static path.

Original open question: since hiding tabs removes the normal way to navigate
to the extension store, does deploying userChrome.css need an enable/disable
toggle so a freshly-provisioned browser (no Sidebery yet) isn't left
unnavigable?

**Resolved:** no toggle. Tabs stay always-hidden; keyboard shortcuts (e.g.
`Ctrl+Shift+A` for Add-ons, `Ctrl+L` for the URL bar) are sufficient to
install Sidebery on a fresh profile.

## Decisions

- **Browser scope:** LibreWolf, Firefox, and other Firefox-family forks
  (Floorp, Zen, Waterfox) — same CSS applied to all.
- **Profile targeting:** parse each browser's `profiles.ini` at apply time.
  Prefer `[InstallXXXX] Default=` (per-install active profile, the modern and
  reliable pointer) over the legacy `[ProfileN] Default=1` flag, which can
  point at a stale/unused profile (confirmed on this machine: `Default=1`
  pointed at `u9gmo16a.default`, an unused profile, while the actual active
  one — found via the Install section — was `0umq3p27.default-default`).
- **Toggle/enable-disable:** none. Always-on.
- **OS scope:** Windows, macOS, and Linux (Arch/Ubuntu), best-effort.
- **CSS content:** single shared file, identical across all browsers/profiles
  (no per-browser override mechanism).
- **Script language:** native per OS — PowerShell for Windows (matches the
  existing `windows_run_onchange_deploy-glazewm-restore.ps1` convention in
  this repo), POSIX `sh` for macOS/Linux. No cross-platform runtime
  dependency required.

## Architecture

Single source-of-truth `userChrome.css` lives in the chezmoi repo. Two
`run_onchange_` scripts (one Windows/PowerShell, one POSIX sh for mac/linux)
run on `chezmoi apply` whenever that CSS content changes. Each script:

1. Enumerates known Firefox-family browser data dirs for its OS.
2. For each one that exists, parses `profiles.ini`.
3. Resolves the active profile per install.
4. Ensures `chrome/` exists under that profile and writes `userChrome.css`.

No toggle, no Sidebery-installed detection — deployment is unconditional.

### Browser data dirs per OS

| OS | Path pattern |
|---|---|
| Windows | `%APPDATA%\<Browser>` |
| macOS | `~/Library/Application Support/<Browser>` |
| Linux | `~/.<browser>` (native install); flatpak paths vary — best-effort, not exhaustively handled |

Browser names: LibreWolf, Firefox, Floorp, Waterfox, Zen.

## Source layout in repo

```
dot_config/browser-chrome/userChrome.css           # single source of truth (plain file)
windows_run_onchange_deploy-userchrome.ps1.tmpl     # Windows deploy script
run_onchange_deploy-userchrome.sh.tmpl              # mac/linux deploy script (no-ops on windows)
```

`dot_config/browser-chrome/` is not a real deploy target — it's a stash
location under chezmoi's source tree so the CSS is version-controlled. Each
`run_onchange_` script embeds a comment containing
`{{ include "dot_config/browser-chrome/userChrome.css" | sha256sum }}` so
chezmoi reruns the script whenever the CSS content changes — this is the
standard chezmoi pattern, since `run_onchange_` triggers off the *rendered
script's* content hash, not files it touches at runtime.

## Script logic (shared shape, per OS)

1. Static list of `{name, basePathTemplate}` per browser.
2. For each browser dir that exists on disk: read `profiles.ini`.
3. Parse `[InstallXXXX]` sections first (each represents a distinct browser
   install) → `Default=` gives the relative profile path. If no Install
   section exists, fall back to the `[ProfileN]` with `Default=1`.
4. For every resolved profile path: create `<profile>/chrome/` if missing,
   write `userChrome.css` there (overwrite unconditionally — it's a
   chezmoi-managed file, no user edits expected in place).
5. Log what was written (browser name + resolved profile path) so
   `chezmoi apply -v` shows the effect.

## Error handling

- Missing browser dir → skip silently (browser not installed on this
  machine; expected, not an error).
- `profiles.ini` present but unparseable, or no resolvable profile → log a
  warning to stderr, continue to the next browser. Never abort the whole
  `chezmoi apply` over one browser's bad state.
- Write failure (permissions, disk) → log and continue to the next browser.

## Testing

- **Manual, this machine (Windows):** run `chezmoi apply -v`, confirm
  `LibreWolf/Profiles/0umq3p27.default-default/chrome/userChrome.css` is
  rewritten with matching content, and confirm the script skips
  Firefox/Floorp/Waterfox/Zen (not installed here) without error.
- **Mac/Linux:** smoke-test on those machines when next available, or
  dry-run against a scratch directory with a fake `profiles.ini` to validate
  parsing logic before relying on a real machine.

## Explicitly out of scope

- Detecting whether Sidebery is installed.
- Any enable/disable toggle mechanism.
- Per-browser CSS overrides/fragments.
- Exhaustive Linux flatpak/snap path coverage.
