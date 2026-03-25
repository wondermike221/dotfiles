@echo off
SET "FILE_TO_CHECK=%~dp0includes.ahk"
SET "AHK_SCRIPT=%~dp0main.ahk"

REM Check if the file exists
IF NOT EXIST "%FILE_TO_CHECK%" (
    REM If not, create an empty file using the 'type' command redirecting NUL
    TYPE nul > "%FILE_TO_CHECK%"
    ECHO Created new file: %FILE_TO_CHECK%
) ELSE (
    ECHO File already exists: %FILE_TO_CHECK%
)

REM Run the AutoHotkey script
REM Use the full path to AutoHotkey.exe if it's not in your system's PATH
REM START "" "C:\Program Files\AutoHotkey\AutoHotkey.exe" "%AHK_SCRIPT%"
REM Alternatively, if AutoHotkey is properly installed and associated with .ahk files:
START "" "%AHK_SCRIPT%"

ECHO AutoHotkey script launched.
