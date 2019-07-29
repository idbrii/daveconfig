if !has('terminal')
    finish
endif

" I want terminal to behave more like a normal buffer.

" Exit insert mode like a normal buffer.
tnoremap <silent> <C-l> <C-w>N
tnoremap <silent> <C-w><C-l> <C-l>

function! s:SendRegisterToTerm(reg_arg, reg_count)
    let reg = a:reg_count
    if len(a:reg_arg) > 0
        let reg = a:reg_arg
    endif
    exec 'let content = @'. reg
    call term_sendkeys('', content)
    normal! A
endf


function! TryApplyTerminalMappings()
    if &hidden
        " Probably don't want mappings for hidden jobs?
        return
    endif
    command! -buffer -nargs=* -count=0 SendRegisterToTerm call s:SendRegisterToTerm(<q-args>, <count>)
    " Will pass count so you can use registers 0-1. Not quite the same as
    " normal p, but a good approximation.
    nnoremap <buffer> p :SendRegisterToTerm<CR>
endf

augroup david_terminal
    au!
    au TerminalOpen * call TryApplyTerminalMappings()
augroup END