:: Creates junctions to allow me to use cygwin paths in Windows tools (like
:: vim).
@echo off

setlocal

set fake_c=c:\cygdrive\c

mkdir %fake_c%
call :create_junction %fake_c%\david c:\david
call :create_junction %fake_c%\Users c:\Users
call :create_junction c:\c %fake_c%

REM call :remove_junction %fake_c%\david c:\david
REM call :remove_junction %fake_c%\Users c:\Users
REM call :remove_junction c:\c %fake_c%
REM rmdir %fake_c%

goto:eof


:: = = = = = = = = = = = = = = = = = = = = 
:: Subroutines

:create_junction
:: for junction, the second argument is the existing one
junction %1 %2
goto:eof

:remove_junction
:: for junction, the second argument is the existing one
junction -d %1
goto:eof
