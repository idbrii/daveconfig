if !has('terminal')
    finish
endif

" Goal: Make terminal-insert behave like normal bash and terminal-normal to
" behave more like a normal buffer.

" Use C-w to delete a word in bash. Bash C-j is newline which I never use and
" vim C-j is snippets, which don't exist in :terminal.
set termwinkey=<C-J>

" Exit insert mode like a normal buffer.
tnoremap <silent> <C-l> <C-j>N
tnoremap <silent> <C-j><C-l> <C-l>
if &shell !~# 'bash'
    " readline compatibility -- this will mess up applications run in a terminal,
    " but I don't do that. Not silent so I know it's happening.
    tnoremap <C-u> <C-Home>
    tnoremap <C-k> <C-End>
endif


" https://github.com/vim/vim/issues/6040
tnoremap <S-space> <space>

function! s:SendRegisterToTerm(reg_arg)
    let reg = v:register
    if len(a:reg_arg) > 0
        let reg = a:reg_arg
    endif
    call term_sendkeys('', getreg(reg))

    " Vim doesn't update from job when in Terminal-Normal, so we won't see our
    " paste until we enter Terminal-Job to see our pasted text. Unfortunately,
    " we can't just feedkeys("A\<C-j>N") to do that, because vim needs to do
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
    command! -buffer -nargs=* TerminalSendRegister call s:SendRegisterToTerm(<q-args>)
    nnoremap <buffer> p <Cmd>TerminalSendRegister<CR>
    nnoremap <buffer> I <Cmd>call <sid>SnapCursor(0)<CR>I
    nnoremap <buffer> A <Cmd>call <sid>SnapCursor(1)<CR>A
endf


" Some limbo exists where terminal is partially implemented. : (
" TerminalOpen is needed to map normal mode commands only in terminal windows.
if exists('##TerminalWinOpen')
    " Only apply to terminals that have windows -- if vim is new enough.
    augroup david_terminal
        au!
        au TerminalWinOpen * call s:TryApplyTerminalMappings()
        au User ZeplTerminalWinOpen call s:TryApplyTerminalMappings()
    augroup END
elseif exists('##TerminalOpen')
    augroup david_terminal
        au!
        au TerminalOpen * call s:TryApplyTerminalMappings()
        au User ZeplTerminalWinOpen call s:TryApplyTerminalMappings()
    augroup END
else
    command! TerminalApplyMappings call s:TryApplyTerminalMappings()
endif


" zepl {{{1

" Can't set a universal fallback in g:repl_config, so make a shell command to
" replace :terminal.
function! s:Shell(args, mods, count) abort
    call zepl#start(&shell, a:mods, a:count)
    if len(a:args) > 0
        " Send the command instead of starting zepl with it so if command
        " terminates, window doesn't close.
        call zepl#send(a:args)
    endif
endf
command! -nargs=* -count Shell call s:Shell(<q-args>, <q-mods>, <count>)

