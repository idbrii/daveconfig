" C# has:
" 0 indents - namespace
" 1 indents - class
" 2 indents - method
let s:max_indents = 2
nnoremap <buffer> <C-g><C-g> :<C-u>call david#search#FindScope(s:max_indents)<CR>

