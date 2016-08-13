taskkill /im gwxux.exe
taskkill /im gwx.exe

:: Prevent win 10 upgrade nagging
:: Source: http://www.tweaking.com/articles/pages/remove_windows_nag_icon_to_upgrade_to_windows_10,1.html
:: Tried to undo this one
REM REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Gwx" /v DisableGWX /d 1 /f
:: I didn't do these registry changes.
REM REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableOSUpgrade /d 1 /f
REM REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /v AllowOSUpgrade /d 0 /f
REM REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /v ReservationsAllowed /d 0 /f
REM TASKKILL /IM GWX.exe /T /F 
REM 
:: I think I re-installed these
REM start /wait wusa /uninstall /kb:3035583 /quiet /norestart /log
REM start /wait wusa /uninstall /kb:3035583 /quiet /norestart /log
exit


:: Greg Smith: https://www.quora.com/Which-Windows-7-updates-should-you-avoid-and-why
:: Telemetry (spying) updates
REM start /wait wusa /uninstall /kb:3022345 /quiet /norestart /log
REM start /wait wusa /uninstall /kb:3068708 /quiet /norestart /log
REM start /wait wusa /uninstall /kb:3075249 /quiet /norestart /log
REM start /wait wusa /uninstall /kb:3080149 /quiet /norestart /log

:: Win10 upgrade
:: I didn't do these.
REM start /wait wusa /uninstall /kb:2952664 /quiet /norestart /log
REM start /wait wusa /uninstall /kb:2976978 /quiet /norestart /log
REM start /wait wusa /uninstall /kb:2977759 /quiet /norestart /log
REM start /wait wusa /uninstall /kb:2990214 /quiet /norestart /log
REM start /wait wusa /uninstall /kb:3021917 /quiet /norestart /log
REM start /wait wusa /uninstall /kb:3035583 /quiet /norestart /log
