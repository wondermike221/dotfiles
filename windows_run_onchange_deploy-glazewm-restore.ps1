# glazewm-restore deployment — run by chezmoi when this script changes.
# chezmoi applies externals before run scripts, so the repo is already
# up-to-date at ~/repos/glazewm-session-restore when this fires.
#
# Bump this version comment to force a re-run on all machines:
#   version: 1

& "$env:USERPROFILE\repos\glazewm-session-restore\deploy.ps1" -NonInteractive
