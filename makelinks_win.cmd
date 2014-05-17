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
mklink    %USERPROFILE%\.gvimrc          %daveconfig%\multi\vim\gvimrc.vim
mklink    %USERPROFILE%\.vimrc           %daveconfig%\multi\vim\vimrc.vim


mklink    %USERPROFILE%\.gitconfig       %daveconfig%\multi\git\.gitconfig
mklink    %USERPROFILE%\.gitconfig.local %daveconfig%\multi\git\win.gitconfig.local
mklink    %USERPROFILE%\.gitignore       %daveconfig%\multi\git\.gitignore

mklink    %USERPROFILE%\.inputrc         %daveconfig%\win\cygwin\.inputrc
mklink    %USERPROFILE%\.minttyrc        %daveconfig%\win\cygwin\.minttyrc
mklink    %USERPROFILE%\_vsvimrc         %daveconfig%\win\visualstudio\_vsvimrc

