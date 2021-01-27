:: Associates python with python files
:: Maybe requires admin?
@echo off
setlocal

:: For scoop. Be sure to update version number!
set PYTHONHOME=%USERPROFILE%\scoop\apps\python39\current
set PYTHONPATH=%USERPROFILE%\scoop\apps\python39\current\Lib

call :check_path PYTHONHOME %PYTHONHOME%
if not %ERRORLEVEL% == 0 (
	exit /b -1
)

call :check_path PYTHONPATH %PYTHONPATH%
if not %ERRORLEVEL% == 0 (
	exit /b -1
)

ftype Python.CompiledFile="%PYTHONHOME%\python.exe" "%%1" %%*
ftype Python.File="%PYTHONHOME%\python.exe" "%%1" %%*
ftype Python.NoConFile="%PYTHONHOME%\pythonw.exe" "%%1" %%*

assoc .py=Python.File
assoc .pyc=Python.CompiledFile
assoc .pyo=Python.CompiledFile
assoc .pyw=Python.NoConFile

pause
goto:eof


::
:: Subroutines

:check_path
set env_var_name=%1
set path_to_check=%2

echo %env_var_name% %path_to_check%

if not defined path_to_check (
	echo %env_var_name% is not defined. It must be setup for this association to work.
	echo %path_to_check%
	exit /b -1
)
if not exist %path_to_check% (
	echo Error: %env_var_name% does not point to a valid directory.
	echo path_to_check=%path_to_check%
	exit /b -1
)
goto:eof



:eof
