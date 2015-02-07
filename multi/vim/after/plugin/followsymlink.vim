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

    " Match any character for drive letter (drive letter case is arbitrary)
    " but otherwise exact match at beginning.
    let re_prefix = '^.\zs\C\V'
    let fname = a:fname

    let known_pairs = [
                \ [ '~/.vim', '~/data/settings/daveconfig/multi/vim' ],
                \ [ 'c:/bin', '~/data/settings/daveconfig/multi/vim/bundle/cv/scripts/bin' ]
                \ ]
    for pair in known_pairs
        " Already matching . for the drive letter, so strip actual letter.
        let link = resolve(expand(pair[0]))[1:]
        let real = resolve(expand(pair[1]))[1:]
        let fname = substitute(fname, re_prefix . link, real, '')
    endfor
    return fname
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
