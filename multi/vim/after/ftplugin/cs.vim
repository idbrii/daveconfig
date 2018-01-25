" C# has:
" 0 indents - namespace
" 1 indents - class
" 2 indents - method
nnoremap <buffer> <C-g><C-g> :<C-u>call david#search#FindScope(2)<CR>

" C# code is usually contained within a namespace and a class, so allow for
" more folding depth. (My normal is 3, so +2 = 5.)
let &l:foldnestmax = max([5, &l:foldnestmax])

" Blocks of C++-style comments look much better than C-style.
let b:commentary_format = '//~ %s'

