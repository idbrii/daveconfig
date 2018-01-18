
" Java has:
" 0 indents - class
" 1 indents - method
let s:max_indents = 2
nnoremap <buffer> <C-g><C-g> :<C-u>call david#search#FindScope(s:max_indents)<CR>

