:: Uses Windows Sysinternals junction to create a junction point in the current directory.
:: http://technet.microsoft.com/en-us/sysinternals/bb896768.aspx
@echo off
setlocal
set exist=%1
set noexist="%~dpn1\junctioned"

if .%exist%==. (
    echo Invalid input: %*
    pause
    exit /b 1
)

echo Creating link at
echo    %noexist%
echo pointing to
echo    %exist%
echo Are you sure that's okay (don't junction files)
pause
call junction %noexist% %exist%
pause
