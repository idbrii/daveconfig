" Windows-style clipboard
" + is the clipboard and * is the selection buffer. See 'clipboard'
" Alt switches to use the selection.
xnoremap <C-c> "+y
nnoremap <C-v> "+p
nnoremap <A-v> "*p

" Easier past without chording
xnoremap <Leader>bp "_d"+p
xnoremap <Leader>bP "_d"+P
nnoremap <Leader>bp "+p
nnoremap <Leader>bP "+P

" Make Y work like D and C
nnoremap Y y$

" Shift-Insert to paste (especially useful in insert). Breaks undo before
" insert paste.
inoremap <S-Insert> <C-g>u<C-r>+
cnoremap <S-Insert> <C-r>+
inoremap <A-Insert> <C-g>u<C-r>*
cnoremap <A-Insert> <C-r>*

" Paste last yanked item
noremap <Leader>p "0p
noremap <Leader>P "0P

" Argument: ("") for full path, otherwise something like ("%") or ("%:p")
function! s:CopyFilenameToClipboard(filename)
    let fname = a:filename
    if len(fname) == 0
        " Full path is generally what I need.
        let fname = "%:p"
    endif

    " TODO: Probably only need to set specific registers on different
    " platforms. Setting both lets me paste into terminals with middle mouse.
    let @*=expand(fname)
    let @+=@*
endfunction

command! -nargs=* CopyFilenameToClipboard call s:CopyFilenameToClipboard(<q-args>)


" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
