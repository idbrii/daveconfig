:: For perforce merge:
:: Location: path-to-this-file
:: Arguments: %2 %r %1

:: Diff all files in large fullscreen window with equal width buffers and find
:: the first conflict.
gvim.exe +"set lines=999" +"set columns=9999" +"simalt ~x" +"wincmd =" +"wincmd w" +"normal gg]C" -d %*

REM Could use videinvoke instead?
REM gvim.exe -S c:/Users/davidb/.vim/videinvoke.vim -c "wincmd =" -d %*
