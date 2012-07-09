" Windows clipboard
xmap <C-c> "+y
nnoremap <C-v> "+p

" I've started using Shift-Insert to paste too (especially in insert)
inoremap <S-Insert> <C-r>+
cnoremap <S-Insert> <C-r>+

" Paste last yanked item
noremap <Leader>p "0p
noremap <Leader>P "0P

" CopyFilenameToClipboard
" Argument: ("%") or ("%:p")
function! CopyFilenameToClipboard(filename)
    " TODO: Probably only need to set specific registers on different
    " platforms.
    let @*=expand(a:filename)
    let @+=@*
endfunction
" This is generally what I need
function! CopyFullPathToClipboard()
    call CopyFilenameToClipboard("%:p")
endfunction

" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
