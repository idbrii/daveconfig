:: Remove Edit in Notepad
:: https://winaero.com/remove-edit-in-notepad-context-menu/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{CA6CC9F1-867A-481E-951E-A28C5E4F01EA}" /d "Block Notepad" /t REG_SZ /f

:: Remove Edit in Clipchamp
:: https://www.elevenforum.com/t/add-or-remove-edit-with-clipchamp-context-menu-in-windows-11.6882/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{8AB635F8-9A67-4698-AB99-784AD929F3B4}" /d "Block Clipchamp" /t REG_SZ /f


:: Remove Edit in Photos
:: https://www.elevenforum.com/t/add-or-remove-photos-context-menu-in-windows-10-and-windows-11.28302/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"  /t REG_SZ /f /v "{BFE0E2A4-C70C-4AD7-AC3D-10D1ECEBB5B4}" /d "Edit with Photos"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"  /t REG_SZ /f /v "{7A53B94A-4E6E-4826-B48E-535020B264E5}" /d "Create with Designer"
REM reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"  /t REG_SZ /f /v "{1100CBCD-B822-43F0-84CB-16814C2F6B44}" /d "Erase Object with Photos"
REM reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"  /t REG_SZ /f /v "{9AAFEDA2-97B6-43EA-9466-9DE90501B1B6}" /d "Visual Search with Bing"


:: Remove Edit in Paint
:: https://www.elevenforum.com/t/add-or-remove-edit-with-paint-context-menu-in-windows-11.30357/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"  /t REG_SZ /f /v "{2430F218-B743-4FD6-97BF-5C76541B4AE9}" /d "Edit with Paint"


:: Remove Open in Visual Studio
:: https://gist.github.com/en0ndev/0e70e5f07296fbfe3dd9628cd19615da
reg copy "HKEY_CLASSES_ROOT\Directory\Background\shell\AnyCode" "HKEY_CLASSES_ROOT\Directory\Background\shell\AnyCode_Disabled" /s
reg copy "HKEY_CLASSES_ROOT\Directory\shell\AnyCode" "HKEY_CLASSES_ROOT\Directory\shell\AnyCode_Disabled" /s

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\AnyCode" /f
reg delete "HKEY_CLASSES_ROOT\Directory\shell\AnyCode" /f

