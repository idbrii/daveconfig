@echo off
:: This doesn't actually work.
set scoop_python_path=%USERPROFILE%\scoop\apps\python310
if not exist %scoop_python_path% (
	echo "Wrong python version in %0."
	echo "%scoop_python_path% doesn't exist."
	exit /b 1
)
@echo on
:: Not sure where py_auto_file comes from. Maybe a magic name from windows?
::~ assoc .py=py_auto_file
ftype py_auto_file="%scoop_python_path%\current\py.exe" "%%1" %%*
::~ assoc .pyw=pyw_auto_type
ftype pyw_auto_file="%scoop_python_path%\current\pythonw.exe" "%%1" %%*
