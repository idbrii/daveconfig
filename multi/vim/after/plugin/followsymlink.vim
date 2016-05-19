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

function! s:FollowWin32Symlink(...)
  let filename = a:0 ? a:1 : '%'
  let allowed_recur_depth = a:0 > 1 ? a:2 : 10
  return s:FollowWin32Symlink_recursive(fnamemodify(expand(filename), ':p'), allowed_recur_depth)
endfunction

function! s:FollowWin32Symlink_recursive(filename, allowed_recur_depth)
  let filename = a:filename
  let allowed_recur_depth = a:allowed_recur_depth
  if !allowed_recur_depth
    return
  endif
  let fpath = expand(filename)
  let ftail = expand(filename.':t')
  let dirstr = system('dir ' . fpath . '*')

  " check if current argument is a symlink
  if (match(dirstr, '<SYMLINK..\s\+' . ftail . ' [') == -1)
    " if not, check if parent dir is symlink, up to $allowed_recur_depth directories
    call s:FollowWin32Symlink_recursive(filename . ':h', allowed_recur_depth-1)
  else
    " extract symlink path
    let substr = '.*<SYMLINK..\s\+' . ftail . ' \[\(.\{-}\)\].*'
    let sympath = substitute(dirstr, substr, '\1', "")
    " figure out current file's path
    let resolvedfile = filereadable(sympath) ?  sympath :
          \ findfile(expand('%:t'), sympath, '**')

    " 'follow' the symlink
    if bufexists(resolvedfile)
      exec 'buffer ' . resolvedfile . ' | bw '.fpath
    else
      silent exec 'file ' . resolvedfile . ' | bw '.fpath
      exec 'file ' . expand('%:p') . ' | w! | doau BufRead'
    endif
  endif
endfunction

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
