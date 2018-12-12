:: Diff two files or directories in vim

set left=%1
set right=%2
if not defined right (
    echo "vdiff requires two arguments."
    exit /b 1
)

if exist %left%\NUL (
    call gvim +"DirDiff %left% %right%"
) else (
    call gvim -d %left% %right%
)
