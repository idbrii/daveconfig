:: Create a central server to edit in vim

:: Only use remote-silent if we have a file.
set file=%1
if defined file (
    set file=--remote-silent %*
) else (
    set file=
)

:: Auto load session.
set session=
if exist %USERPROFILE%\.vim-cache\session.vim (
    set session=-S ~/.vim-cache/session.vim 
)

:: Call the .bat because it doesn't leave our command prompt sticking around.
call gvim.bat --servername VIDE %session% %file%
