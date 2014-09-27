" Follow symlinks so we're editing the actual file instead of the symlink
" (change the value returned by %).
"
" Requires readlink - part of GNU coreutils
" Uses vim-bufkill if available.

function! s:TranslateKnownLinks(fname)
    " Workaround https://code.google.com/p/vim/issues/detail?id=147
    " resolve() can't understand Windows mklink symlinks -- it only handles
    " lnk files which is useless to me. Instead, manage known symlinks and
    " resolve ourselves.
    if !has("win32")
        return a:fname
    endif

    let dot_vim = resolve(expand('~/.vim'))
    let real_vim = resolve(expand('~/data/settings/daveconfig/multi/vim'))
    " Require exact match at beginning of string.
    let regex_settings = '^\C\V'
    return substitute(a:fname, regex_settings . dot_vim, real_vim, '')
endf

function! s:SwitchToActualFile()
    " Wipe the current buffer and load the file that the symlink points to.
    let fname = resolve(expand('%:p'))
    let fname = s:TranslateKnownLinks(fname)

    if !filereadable(fname)
        echoerr "Failed to find file. Looked for ". fname
        return
    endif

    if exists("loaded_bufkill")
        " Use bufkill to clear the buffer, but not close the window.
        BW
    else
        " We'll lose the current window, but it's better than nothing.
        bwipeout
    endif
    exec "edit " . fname
endfunction
command! FollowSymlink call s:SwitchToActualFile()
