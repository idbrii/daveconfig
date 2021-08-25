
command! -buffer -range Gpeekcommit call david#git#peek_line()

augroup david_fugitive
    au! * <buffer>
    " o opens the commit in a split, but I often just want to see the commit
    " message. Use a popup window.
    " Consider only invoking if cursor is in first column?
    autocmd CursorHold <buffer> Gpeekcommit
augroup END

" Provide mapping to avoid repeated waiting. This uses x for examine.
nnoremap <buffer> x :<C-u>Gpeekcommit<CR>

