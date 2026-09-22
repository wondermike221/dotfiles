$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptRoot '..\..')
$scriptContent = Get-Content -Raw (Join-Path $repoRoot 'run_onchange_deploy-userchrome-windows.ps1.tmpl')
$tempScript = Join-Path ([System.IO.Path]::GetTempPath()) "userchrome-deploy-test-$(Get-Random).ps1"
Set-Content -Path $tempScript -Value $scriptContent -NoNewline
. $tempScript
Remove-Item $tempScript -Force

$failures = 0

function Assert-Equal($actual, $expected, $message) {
    if ($actual -ne $expected) {
        Write-Host "FAIL: $message (expected '$expected', got '$actual')"
        $script:failures++
    } else {
        Write-Host "PASS: $message"
    }
}

# Test 1: Install-section profile takes precedence over legacy Default=1
$tmp1 = Join-Path ([System.IO.Path]::GetTempPath()) "uc-test-1-$(Get-Random)"
New-Item -ItemType Directory -Force -Path (Join-Path $tmp1 'LibreWolf\Profiles\stale.default') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $tmp1 'LibreWolf\Profiles\active.default-release') | Out-Null
@'
[Profile1]
Name=default
IsRelative=1
Path=Profiles/stale.default
Default=1

[InstallABC123]
Default=Profiles/active.default-release
Locked=1

[General]
StartWithLastProfile=1
Version=2
'@ | Set-Content -Path (Join-Path $tmp1 'LibreWolf\profiles.ini')

Deploy-UserChrome -BaseDir $tmp1 -CssContent 'TEST_CSS_1'
$written1 = Join-Path $tmp1 'LibreWolf\Profiles\active.default-release\chrome\userChrome.css'
Assert-Equal (Test-Path $written1) $true 'Install-section profile: chrome dir created for active profile'
if (Test-Path $written1) {
    Assert-Equal (Get-Content $written1 -Raw) 'TEST_CSS_1' 'Install-section profile: content written correctly'
}
$staleWritten = Join-Path $tmp1 'LibreWolf\Profiles\stale.default\chrome\userChrome.css'
Assert-Equal (Test-Path $staleWritten) $false 'Install-section profile: stale profile NOT written'

# Test 2: fallback to legacy Default=1 when no Install section exists
$tmp2 = Join-Path ([System.IO.Path]::GetTempPath()) "uc-test-2-$(Get-Random)"
New-Item -ItemType Directory -Force -Path (Join-Path $tmp2 'Firefox\Profiles\legacy.default') | Out-Null
@'
[Profile0]
Name=default
IsRelative=1
Path=Profiles/legacy.default
Default=1

[General]
StartWithLastProfile=1
Version=2
'@ | Set-Content -Path (Join-Path $tmp2 'Firefox\profiles.ini')

Deploy-UserChrome -BaseDir $tmp2 -CssContent 'TEST_CSS_2'
$written2 = Join-Path $tmp2 'Firefox\Profiles\legacy.default\chrome\userChrome.css'
Assert-Equal (Test-Path $written2) $true 'Legacy fallback: chrome dir created for Default=1 profile'

# Test 3: browser dir missing entirely -> no error, nothing written
$tmp3 = Join-Path ([System.IO.Path]::GetTempPath()) "uc-test-3-$(Get-Random)"
New-Item -ItemType Directory -Force -Path $tmp3 | Out-Null
Deploy-UserChrome -BaseDir $tmp3 -CssContent 'TEST_CSS_3'
Assert-Equal $true $true 'Missing browser dir: no exception thrown'

# Test 4: profiles.ini with no resolvable profile -> warning, no crash, no file written
$tmp4 = Join-Path ([System.IO.Path]::GetTempPath()) "uc-test-4-$(Get-Random)"
New-Item -ItemType Directory -Force -Path (Join-Path $tmp4 'Floorp') | Out-Null
@'
[General]
StartWithLastProfile=1
Version=2
'@ | Set-Content -Path (Join-Path $tmp4 'Floorp\profiles.ini')

Deploy-UserChrome -BaseDir $tmp4 -CssContent 'TEST_CSS_4' -WarningAction SilentlyContinue
$anyWritten = Get-ChildItem -Path $tmp4 -Recurse -Filter 'userChrome.css' -ErrorAction SilentlyContinue
Assert-Equal ($null -eq $anyWritten) $true 'Unresolvable profile: nothing written'

foreach ($t in @($tmp1, $tmp2, $tmp3, $tmp4)) { Remove-Item -Recurse -Force $t -ErrorAction SilentlyContinue }

if ($failures -gt 0) {
    Write-Host "`n$failures test(s) failed."
    exit 1
} else {
    Write-Host "`nAll tests passed."
    exit 0
}
