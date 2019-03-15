
" Java has:
" 0 indents - class
" 1 indents - method
nnoremap <buffer> <C-g><C-g> :<C-u>call david#search#FindScope(1)<CR>

" C# code is usually contained within a class, so allow for more folding
" depth. (+1)
let &l:foldnestmax = max([g:david_foldnestmax + 1, &l:foldnestmax])

