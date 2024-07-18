@echo off
rem Run nvim without leaving a command window open behind it.
rem
rem Created by idbrii based on gvim script from vim 8.2.314
rem See also https://github.com/vim/vim/blob/1fa8d2c33d7290eda7dc2a94d4ec6a599a2d61dd/src/dosinst.c#L842-L950
rem -- Run Vim --
rem # uninstall key: vim82 #

setlocal
set VIM_EXE_DIR=%USERPROFILE%\scoop\apps\goneovim\current\
set VIM_EXE=%VIM_EXE_DIR%\goneovim.exe

if exist "%VIM_EXE%" goto havevim
echo "%VIM_EXE%" not found
goto eof

:havevim
rem collect the arguments in VIMARGS for Win95
set VIMARGS=
set VIMNOFORK=
:loopstart
if .%1==. goto loopend
if NOT .%1==.--nofork goto noforklongarg
set VIMNOFORK=1
:noforklongarg
if NOT .%1==.-f goto noforkarg
set VIMNOFORK=1
:noforkarg
set VIMARGS=%VIMARGS% %1
shift
goto loopstart
:loopend

if .%OS%==.Windows_NT goto ntaction

if .%VIMNOFORK%==.1 goto nofork
start "%VIM_EXE%"  %VIMARGS%
goto eof

:nofork
start /w "%VIM_EXE%"  %VIMARGS%
goto eof

:ntaction
rem for WinNT we can use %*
if .%VIMNOFORK%==.1 goto noforknt
start "dummy" /b "%VIM_EXE%"  %*
goto eof

:noforknt
start "dummy" /b /wait "%VIM_EXE%"  %*

:eof
set VIMARGS=
set VIMNOFORK=
