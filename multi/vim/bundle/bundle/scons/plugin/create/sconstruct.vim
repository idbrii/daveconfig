function! s:Create()
    setfiletype python
    0r ~/.vim/bundle/scons/skeleton/sconstruct
    let @/='REPLACE_'
endfunction

augroup create_sconstruct
    au!
    au BufNewFile [sS][cC]onstruct call s:Create()
augroup END
