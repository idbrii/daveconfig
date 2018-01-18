" Similar to standard one, but since C# is a namespace containing a class
" containing functions, we need to handle more indentation. Fortunately, lines
" end with ; so we can discard false positives.
function! s:FindScope()
    let last_search=@/
    
    normal ?\v^(    ){0,2}\w.*[^;]$? mark c
    nohlsearch
    echo getline("'c")

    let @/ = last_search
endf
nnoremap <buffer> <C-g><C-g>  :<C-u>call <SID>FindScope()<CR>

" Open unity docs.
" Move to unite-david when I've figured out converting this to a unite source
" Mnemonic: Open K (vim for help)
nnoremap <buffer> <Leader>ok :CtrlPUnity3DDocs<CR>

