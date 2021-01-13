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

    " Vim doesn't update from job when in Terminal-Normal, so we won't see our
    " paste until we enter Terminal-Job to see our pasted text. Unfortunately,
    " we can't just feedkeys("A\<C-w>N") to do that, because vim needs to do
    " an update in Terminal-Job.
endf

function! s:SnapCursor(to_end)
    if a:to_end
        call term_sendkeys('', "\<End>")
    else
        call term_sendkeys('', "\<Home>")
    endif
endf

function! s:TryApplyTerminalMappings()
    if &hidden
        " Probably don't want mappings for hidden jobs?
        return
    endif
    command! -buffer -nargs=* TerminalSendRegister call s:SendRegisterToTerm(<q-args>)
    nnoremap <buffer> p :TerminalSendRegister<CR>
    nnoremap <buffer> I :<C-u>call <sid>SnapCursor(0)<CR>I
    nnoremap <buffer> A :<C-u>call <sid>SnapCursor(1)<CR>A
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
