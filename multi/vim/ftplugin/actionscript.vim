" actionscript ctags info
let tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'

" use indentation to fold since default syntax method doesn't work
" (Maybe I need to get better syntax for actionscript?)
if &foldmethod != 'diff'
    set foldmethod=indent
endif
set noexpandtab

" Add trace that I can easily find
abb dtrace trace("DAVID");<ESC>bi
