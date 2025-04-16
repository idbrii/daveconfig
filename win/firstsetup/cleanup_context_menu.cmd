:: Remove Edit in Notepad
:: https://winaero.com/remove-edit-in-notepad-context-menu/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{CA6CC9F1-867A-481E-951E-A28C5E4F01EA}" /d "Block Notepad" /t REG_SZ /f

:: Remove Edit in Clipchamp
:: https://www.elevenforum.com/t/add-or-remove-edit-with-clipchamp-context-menu-in-windows-11.6882/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{8AB635F8-9A67-4698-AB99-784AD929F3B4}" /d "Block Clipchamp" /t REG_SZ /f


:: Remove Open in Visual Studio
:: https://gist.github.com/en0ndev/0e70e5f07296fbfe3dd9628cd19615da
reg copy "HKEY_CLASSES_ROOT\Directory\Background\shell\AnyCode" "HKEY_CLASSES_ROOT\Directory\Background\shell\AnyCode_Disabled" /s
reg copy "HKEY_CLASSES_ROOT\Directory\shell\AnyCode" "HKEY_CLASSES_ROOT\Directory\shell\AnyCode_Disabled" /s

reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\AnyCode" /f
reg delete "HKEY_CLASSES_ROOT\Directory\shell\AnyCode" /f

