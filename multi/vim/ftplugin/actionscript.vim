" actionscript ctags info
let tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'

" use indentation to fold since default syntax method doesn't work
" (Maybe I need to get better syntax for actionscript?)
set foldmethod=indent
set noexpandtab
set softtabstop=0

" Add trace that I can easily find
abb dtrace trace("DAVID");<ESC>bi
