@echo off
setlocal enabledelayedexpansion
set "GUIexe=GUI.exe"

:: Start GUI process picker and wait for it to close
if exist "%GUIexe%" (
    start /wait "" "%GUIexe%"
) else (
    echo %GUIexe% not found. Exiting.
    pause
    exit /b
)

:: Read processes.txt to get process list
if not exist processes.txt (
    echo processes.txt not found. Exiting.
    pause
    exit /b
)

set "PLIST="
for /f "usebackq delims=" %%P in ("processes.txt") do (
    set "PLIST=!PLIST! %%P"
)

:Task
for %%P in (%PLIST%) do (
    taskkill /F /im %%P
)
timeout /t 2 >nul
goto Task
