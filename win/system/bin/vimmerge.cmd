:: For perforce merge:
:: Location: path-to-this-file
:: Arguments in p4v: %b %2 %1 %r
::		Base file: %b
::		Your/Target file: %2
::		Their/Source file: %1
::		Result file: %r
set BASE=%1
set LOCAL=%2
set REMOTE=%3
set MERGED=%4

:: Diff all files in large fullscreen window with equal width buffers and find
:: the first conflict.
gvim.exe +"set lines=999" +"set columns=9999" +"simalt ~x" +"wincmd =" +"wincmd w" +"normal gg]C" -d %LOCAL% %MERGED% %REMOTE%

REM Could use videinvoke instead?
REM gvim.exe -S c:/Users/davidb/.vim/videinvoke.vim -c "wincmd =" -d %*
