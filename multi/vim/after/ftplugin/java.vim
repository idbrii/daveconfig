
" Java has:
" 0 indents - class
" 1 indents - method
nnoremap <buffer> <C-g><C-g> :<C-u>call david#search#FindScope(1)<CR>

" C# code is usually contained within a class, so allow for more folding
" depth. (My normal is 3, so +1 = 4.)
let &l:foldnestmax = max([4, &l:foldnestmax])

