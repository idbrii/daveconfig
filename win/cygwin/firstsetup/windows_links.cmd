:: Creates links to allow me to use cygwin paths in Windows tools (like vim).
:: This script needs to be run as Administrator (for mklink).
::
:: I recently replaced junction with mklink /D, but haven't tested it.
@echo off

setlocal

set fake_c=c:\cygdrive\c

:: For cygdrive paths
mkdir %fake_c%
call :create_junction %fake_c%\david c:\david
call :create_junction %fake_c%\Users c:\Users
call :create_junction c:\c %fake_c%

:: Setup tmp to make stuff like fc work from bash.
call :create_junction c:\tmp c:\cygwin\tmp

:: To remove, replace above create_junction with remove_junction (they take the same args).
REM rmdir %fake_c%

goto:eof


:: = = = = = = = = = = = = = = = = = = = = 
:: Subroutines

:create_junction
:: Make sure the directories leading up to the destination link exist.
mkdir %1
rmdir %1
:: for mklink, the second argument is the existing one
mklink /D %1 %2
goto:eof

:remove_junction
:: unlike junction, mklink has no delete command
del %1
goto:eof
