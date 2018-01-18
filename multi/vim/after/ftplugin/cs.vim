" C# has:
" 0 indents - namespace
" 1 indents - class
" 2 indents - method
let s:max_indents = 2
nnoremap <buffer> <C-g><C-g> :<C-u>call david#search#FindScope(s:max_indents)<CR>

" Open unity docs.
" Move to unite-david when I've figured out converting this to a unite source
" Mnemonic: Open K (vim for help)
nnoremap <buffer> <Leader>ok :CtrlPUnity3DDocs<CR>

