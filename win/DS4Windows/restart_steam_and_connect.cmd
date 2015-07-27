:: Sometimes the DS4 isn't connected in exclusive mode because Steam is
:: running. Add this to steam and run it to allow DS4Windows to get exclusively
:: to the DS4.

:: For sleep. If this stops working, GitHub updated and change the PortableGit
:: location.
set PATH=%PATH%;%LocalAppData%\PortableGit_link\bin

:: Restart DS4Windows so the controller is not connected.
REM taskkill /im DS4Windows.exe
REM pushd C:\david\game\DS4Windows\
REM start C:\david\game\DS4Windows\DS4Windows.exe
REM popd

:: Kill big picture
taskkill /im steam.exe

:: Kill steam desktop
sleep 10s
taskkill /f /im steam.exe
sleep 10s
@echo.
@echo.
@echo.
@echo.
@echo Connect the DualShock controller now while Steam is inactive.
@echo.
@echo.
@echo.
@echo.
sleep 30s >NUL
@echo Restarting Steam...
start c:/david/steam/Steam.exe

exit /b 0
