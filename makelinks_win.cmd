:: Create Windows symlinks to config files.
::
:: Should work on Vista and later. Otherwise you can download mklink from
:: Microsoft.
::
:: You may have to run this in a cmd as Administrator. You can do that by:
::	1. Windows key
::	2. Type: cmd
::	3. Ctrl-Shift-Enter
::
set daveconfig=C:\david\settings\daveconfig

:: Make daveconfig in the same place everywhere (some scripts rely on this)
mklink /D %USERPROFILE%\data C:\david

:: Add links
mklink    %USERPROFILE%\.bash_aliases    %daveconfig%\unix\terminal\bash_aliases
mklink    %USERPROFILE%\.bashrc          %daveconfig%\unix\terminal\bashrc
mklink    %USERPROFILE%\.screenrc        %daveconfig%\unix\terminal\screenrc

mklink /D %USERPROFILE%\.vim             %daveconfig%\multi\vim
echo source %daveconfig%\multi\vim\gvimrc.vim> %USERPROFILE%\.gvimrc
echo source %daveconfig%\multi\vim\vimrc.vim > %USERPROFILE%\.vimrc


mklink    %USERPROFILE%\.gitconfig       %daveconfig%\multi\git\.gitconfig
mklink    %USERPROFILE%\.gitconfig.local %daveconfig%\multi\git\win.gitconfig.local
mklink    %USERPROFILE%\.gitignore       %daveconfig%\multi\git\.gitignore

mklink    %USERPROFILE%\.inputrc         %daveconfig%\win\cygwin\.inputrc
mklink    %USERPROFILE%\.minttyrc        %daveconfig%\win\cygwin\.minttyrc
mklink    %USERPROFILE%\_vsvimrc         %daveconfig%\win\visualstudio\_vsvimrc

mklink /D %USERPROFILE%\.zbstudio         %daveconfig%\multi\zbstudio

:: Bash on Windows puts drives in mnt. For cygwin, I could probably replace mnt
:: with cygdrive.
mkdir c:\mnt
mklink /D c:\mnt\c c:\
mklink /D c:\mnt\e e:\
mkdir e:\mnt
mklink /D e:\mnt\c c:\
mklink /D e:\mnt\e e:\
