@echo off
echo Starting compile...

lime test windows
if %ERRORLEVEL% NEQ 0 (
    echo lime failed, trying haxelib run lime...
    haxelib run lime test windows
    if %ERRORLEVEL% NEQ 0 (
        echo Build failed!
        exit /b 1
    )
)

echo Build succeeded!
