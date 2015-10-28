:: For perforce merge:
:: Location: path-to-this-file
:: Arguments in p4v: %1 %2 %b %r
::		Their/Source file: %1
::		Your/Target file: %2
::		Base file: %b
::		Result file: %r
set LOCAL="%1"
set REMOTE="%2"
set BASE="%3"
set MERGED="%4"

:: Always use normal vimdiff for diffs.
set USE_diffconflicts=%MERGED%
:: Uncomment to disable diffconflicts.
REM set USE_diffconflicts=

if defined USE_diffconflicts (
	REM diffconflicts works well for merging.
	set IS_PERFORCE=1
	%cyg_path%\bash %~dp0\..\..\..\multi\git\tool\mergetool.diffconflicts.git.sh gvim %BASE% %LOCAL% %REMOTE% %MERGED%
) else (
	REM Diff all files in large fullscreen window with equal width buffers and
	REM find the first conflict.
	gvim.exe +"set lines=999" +"set columns=9999" +"simalt ~x" +"wincmd =" +"wincmd w" +"normal gg]C" -d %REMOTE% %MERGED% %LOCAL%
)

REM Could use videinvoke instead?
REM gvim.exe -S c:/Users/davidb/.vim/videinvoke.vim -c "wincmd =" -d %*
