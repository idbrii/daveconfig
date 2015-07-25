" Windows-style clipboard
" + is the clipboard and * is the selection buffer. See 'clipboard'
" Alt switches to use the selection.
xnoremap <C-c> "+ygvy
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

" Unified clipboard
" Use unnamedplus if available because I think that works how I expect under
" X. Windows doesn't have a selection clipboard, so there isn't a significant
" difference.
"
" Oddly, this means that `p` will paste from a different register than `""p`.
" However, I can use <Leader>p to paste my last vim yank.
"
" This makes some of the above yank mappings less useful.
"
" I don't really want deletes to be put on the system clipboard.
" Behavior I think I want: I want the system clipboard to be put into @" when
" I enter vim (if it changed) and my last yank to be put into @+ when I leave
" (if it changed). I could use FocusGained and FocusLost to manage the
" clipboard myself. I don't want any other registers to be modified.
" TODO: Testing FocusClip to provide better behavior. It requires I disable
" unnamed.
"if has('unnamedplus')
"    set clipboard+=unnamedplus
"else
"    set clipboard+=unnamed
"endif

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
