:: Creates junctions to allow me to use cygwin paths in Windows tools (like
:: vim).
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
:: for junction, the second argument is the existing one
junction %1 %2
goto:eof

:remove_junction
:: for junction, the argument is the link
junction -d %1
goto:eof
