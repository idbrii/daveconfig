:: Creates links to allow me to use cygwin paths in Windows tools (like vim).
:: This script needs to be run as Administrator (for mklink).
::
@echo off

setlocal

set destination_drive_letter=c
set cygwin_install_dir=c:\cygwin

:: Setup tmp to make stuff like fc work from bash.
call :create_junction c:\tmp %cygwin_install_dir%\tmp

:: For cygdrive paths
call :create_junction %destination_drive_letter%:\d d:\
call :create_junction %destination_drive_letter%:\c c:\
call :create_junction %destination_drive_letter%:\cygdrive\d d:\
call :create_junction %destination_drive_letter%:\cygdrive\c c:\

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
goto:eof
