:: Create a central server to edit in vim

where /q nvim.exe
if ERRORLEVEL 1 (
    goto :gvim_server
) else (
    goto :nvim_server
)


:nvim_server
:: Auto load session.
set session=
if exist %USERPROFILE%\.nvim-cache\session.vim (
    set session=-S ~/.nvim-cache/session.vim 
)

set servername=localhost:8900

:: Unfortunately, nvim's solution requires specifying the server two different
:: ways so it's not very convenient: I need to explicitly start the server to
:: be able to send files to it. But if I failed to start the server, it will
:: open terminal with the wrong v:servername.
set file=%1
if defined file (
    :: Send the file to the server.
    call nvim --server %servername% --remote-silent %*
) else (
    :: Start the server.
    :: gnvim.bat is part of daveconfig.
    call gnvim.bat --maximized %* -- --listen %servername% %session%
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
