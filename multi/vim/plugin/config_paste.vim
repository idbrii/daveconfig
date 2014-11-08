" Windows-style clipboard
" + is the clipboard and * is the selection buffer. See 'clipboard'
" Alt switches to use the selection.
xnoremap <C-c> "+y
nnoremap <C-v> "+p
nnoremap <A-v> "*p

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

" CopyFilenameToClipboard
" Argument: ("%") or ("%:p")
function! CopyFilenameToClipboard(filename)
    " TODO: Probably only need to set specific registers on different
    " platforms. Setting both lets me paste into terminals with middle mouse.
    let @*=expand(a:filename)
    let @+=@*
endfunction
" This is generally what I need
function! CopyFullPathToClipboard()
    call CopyFilenameToClipboard("%:p")
endfunction

" Yankstack
nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste


" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
