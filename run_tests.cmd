@echo off
setlocal

REM Check if any arguments were provided
if "%~1"=="" (
    REM No arguments provided, use default
    addons\gdUnit4\runtest.cmd --godot_bin c:\tools\godot\4.4\godot44.exe -a tests
) else (
    REM Arguments provided, pass them to the test runner
    addons\gdUnit4\runtest.cmd --godot_bin c:\tools\godot\4.4\godot44.exe %*
)
