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

