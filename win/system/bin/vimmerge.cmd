:: For perforce merge:
:: Location: path-to-this-file
:: Arguments: %2 %r %1

:: Ensure we're fullscreen and diff all input files.
gvim.exe "+set lines=999" "+set columns=9999" "+simalt ~x" -c "wincmd =" -d %*

REM Could use videinvoke instead?
REM gvim.exe -S c:/Users/davidb/.vim/videinvoke.vim -c "wincmd =" -d %*
