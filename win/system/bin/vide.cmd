:: Create a central server to edit in vim

goto :gvim_server


:nvim_server
:: Auto load session.
set session=
if exist %USERPROFILE%\.nvim-cache\session.vim (
    set session=-S ~/.nvim-cache/session.vim 
)

:: TODO: server/listen doesn't work. nvim's pipes don't seem to work on
:: Windows. just launch with session instead.
call gnvim.bat --maximized %session% %*
goto :eof

set servername=~/.nvim-cache/server.pipe

set file=%1
if defined file (
    call nvim.bat --server %servername% --remote-silent %*
) else (
    :: gnvim.bat is part of daveconfig.
    call gnvim.bat --listen %servername% --maximized %session% %*
)

goto :eof



:gvim_server
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

goto :eof
