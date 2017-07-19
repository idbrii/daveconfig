" use indentation to fold since default syntax method doesn't work
" (Maybe I need to get better syntax for config files?)
if &foldmethod != 'diff'
    set foldmethod=indent
endif
