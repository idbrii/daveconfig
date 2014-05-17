" Follow symlinks so we're editing the actual file instead of the symlink
" (change the value returned by %).
"
" Requires readlink - part of GNU coreutils
" Uses vim-bufkill if available.

" Wipe the current buffer and load the file that the symlink points to.
function! s:SwitchToActualFile()
    let fname = resolve(expand('%:p'))
    if exists("loaded_bufkill")
        " Use bufkill to clear the buffer, but not close the window.
        BW
    else
        " We'll lose the current window, but it's better than nothing.
        bwipeout
    endif
    exec "edit " . fname
endfunction
command FollowSymlink call s:SwitchToActualFile()
