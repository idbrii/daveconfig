" Member function calls require a :
" This doesn't work on self with polyglot's lua syntax (since it makes self a
" builtin and I don't know how to handle that in vim syntax). It also shows
" false-positives on c modules.
" HACK: Ignore imgui,imguiraw by ignoring modules that end with [iw].
syn match luaError "\<\l\+[^iw]\.\u\w\+(" display
" Lua uses ~= for not equal.
syn match luaError "!=" display
" Lua does not support assignment-equals
syn match luaError "[+-]=" display
" Lua uses 1-indexed arrays
syn match luaError "\[0]" display


" Constants are all caps with underscores. Minimum 4 characters.
" Source: http://stackoverflow.com/questions/1512602/highlighting-defined-value-in-vim/1515550#1515550
syn match luaConstant "\<[A-Z][A-Z0-9_]\{3,\}\>"
hi def link luaConstant Define

" Special highlight for method names
" Source: http://vim.wikia.com/wiki/Highlighting_of_method_names_in_the_definition
syn match luaFuncDef ":\zs\h\w*\ze([^)]*)"
hi def link luaFuncDef Function
