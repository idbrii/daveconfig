" C# has:
" 0 indents - namespace
" 1 indents - class
" 2 indents - method
nnoremap <buffer> <C-g><C-g> :<C-u>call david#search#FindScope(2)<CR>

" Blocks of C++-style comments look much better than C-style.
let b:commentary_format = '//~ %s'
