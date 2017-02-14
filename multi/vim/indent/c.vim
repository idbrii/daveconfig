" # is preprocessor and not comment. Without this, we may somehow keep the
" previous value from vimrc (#1) and will indent preprocessor statements by
" one space (don't know why we would indent by once space).
" This problem doesn't seem to occur in c, but adding this just in case.
setlocal cinoptions-=#1
setlocal cinoptions+=#0

