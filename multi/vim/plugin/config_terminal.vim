if !has('terminal')
    finish
endif

" I want terminal to behave more like a normal buffer.

" Exit insert mode like a normal buffer.
tnoremap <silent> <C-l> <C-w>N
tnoremap <silent> <C-w><C-l> <C-l>

function! s:SendRegisterToTerm(reg_arg)
    let reg = v:register
    if len(a:reg_arg) > 0
        let reg = a:reg_arg
    endif
    call term_sendkeys('', getreg(reg))
endf

function! s:TryApplyTerminalMappings()
    if &hidden
        " Probably don't want mappings for hidden jobs?
        return
    endif
    command! -buffer -nargs=* TerminalSendRegister call s:SendRegisterToTerm(<q-args>)
    nnoremap <buffer> p :TerminalSendRegister<CR>
endf


" Some limbo exists where terminal is partially implemented. : (
" TerminalOpen is needed to map normal mode commands only in terminal windows.
if exists('##TerminalWinOpen')
    " Only apply to terminals that have windows -- if vim is new enough.
    augroup david_terminal
        au!
        au TerminalWinOpen * call s:TryApplyTerminalMappings()
    augroup END
elseif exists('##TerminalOpen')
    augroup david_terminal
        au!
        au TerminalOpen * call s:TryApplyTerminalMappings()
    augroup END
else
    command! TerminalApplyMappings call s:TryApplyTerminalMappings()
endif
