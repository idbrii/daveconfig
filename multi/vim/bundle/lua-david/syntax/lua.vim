" Member function calls require a :
" Hack around polyglot's lua syntax (which makes self a builtin and I don't
" know how to handle that in vim syntax).
syn clear luaBuiltIn
syn keyword luaBuiltIn _ENV
syn match luaError "self\(\.\l\+\)*\.\u\w\+(" display

" Our class system uses _base as the parent class. We want the instance passed
" as self and not the class.
syn match luaError "\<_base:" display
" Lua uses ~= for not equal.
syn match luaError "!=" display
" Lua does not support assignment-equals
syn match luaError "[+-]=" display
" Lua uses 1-indexed arrays
syn match luaError "\[0]" display
" Lua uses % to escape atoms (vim \w is %w)
syn match luaError "\v<(find|g?match|gsub)>.*\\[wad]" display


" Constants are all caps with underscores. Minimum 4 characters.
" Source: http://stackoverflow.com/questions/1512602/highlighting-defined-value-in-vim/1515550#1515550
syn match luaConstant "\<[A-Z][A-Z0-9_]\{3,\}\>"
hi def link luaConstant Define

" Make functions look like functions (vim-lua#19)
hi def link luaFuncCall Function
hi link luaFuncName Function
" Make local a keyword like return
hi! def link luaLocal Statement
