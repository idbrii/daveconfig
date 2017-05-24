" Member function calls require a :
syn match luaError "\<\l\+\.\u\w\+(" display

" Constants are all caps with underscores. Minimum 4 characters.
" Source: http://stackoverflow.com/questions/1512602/highlighting-defined-value-in-vim/1515550#1515550
syn match luaConstant "\<[A-Z][A-Z0-9_]\{3,\}\>"
hi def link luaConstant Define

" Special highlight for method names
" Source: http://vim.wikia.com/wiki/Highlighting_of_method_names_in_the_definition
syn match luaFuncDef ":\~\?\zs\h\w*\ze([^)]*\()\s*\)\?$"
hi def link luaFuncDef Function
