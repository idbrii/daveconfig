" Vim Command-line stuff

" Cycle through incsearch matches.
" The defaults are unintuitive. c-j is the same as CR and c-k is inserting
" digraphs, so replace them.
" Note: rsi maps c-t and c-g but maintains behavior in search mode.
cnoremap <C-j> <C-t>
cnoremap <C-k> <C-g>

" Use C-y to insert characters from current match like C-y in popupmenu.
cnoremap <C-y> <C-l>
" C-l to back out like esc from insert.
cnoremap <C-l> <C-c>


" AsyncRun {{{1
" Need enough lines to see error, 'stack traceback', and first line of error
" at the middle of the screen.
augroup david_resize_qf
    au!
    autocmd VimEnter,VimResized * let g:asyncrun_open = max([5, &lines / 10])
augroup END

" Replace TailMinusF
command! -nargs=1 -complete=file Tail AsyncRun tail -f <q-args>

function! s:CompleteCmdline()
    let cmd = getcmdtype()
    if cmd =~# '[/?]'
        " Open cmdline-window and complete.
        return "\<C-f>A\<C-n>"
    elseif cmd =~# ':'
        let line = getcmdline()
        if line =~# '^\w*$' || line =~# '^Verb(\w*) \w\?$'
            " For initial commands (n<C-space>) and Verbose, do quick leader
            " mappings.
            return 'map <Leader>'
        else
            " if there's any whitespace aside from verbose, do completion.
            return "\<C-f>A\<C-x>\<C-v>"
        endif
    endif
    " Attempt vim completion.
    return "\\<Tab>"
endf
cnoremap <expr> <C-space> <SID>CompleteCmdline()
