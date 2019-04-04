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

    " Match any character for drive letter (drive letter case is arbitrary and
    " content is often linked between drives.) Otherwise exact match entire
    " filename. Using case sensitive even though it doesn't matter on Win32.
    " We'll replace the drive letter with what's in the substitution.
    let re_prefix = '^.\C\V'
    let fname = a:fname

    let known_pairs = [
                \ [ '~/.vim', '~/data/settings/daveconfig/multi/vim' ],
                \ [ ($USERPROFILE .'/.vim'), '~/data/settings/daveconfig/multi/vim' ],
                \ [ 'c:/bin', '~/data/settings/daveconfig/multi/vim/bundle/work/scripts/bin' ],
                \ [ 'c:/mnt/c', 'c:' ],
                \ [ 'c:/mnt/e', 'e:' ],
                \ ]
    for pair in known_pairs
        " Already matching . for the drive letter, so strip actual letter.
        let link = expand(pair[0])[1:]
        " Don't strip from result.
        let real = resolve(expand(pair[1]))
        let fname = substitute(fname, re_prefix . link, real, '')
    endfor
    return fname
endf

function! FollowWin32Symlink(...)
  let shellslash_save = &shellslash
  " directory separators need to be backslashes so cmd.exe doesn't think
  " they're options.
  set noshellslash
  " First argument is filename - defaults to current file
  let filename = a:0 > 0 ? a:1 : '%'
  " Second is remaining depth - defaults to 10
  let allowed_recur_depth = a:0 > 1 ? a:2 : 10
  call s:FollowWin32Symlink_recursive(fnamemodify(expand(filename), ':p'), allowed_recur_depth)
  let &shellslash = shellslash_save
endfunction

function! s:FollowWin32Symlink_recursive(filename, allowed_recur_depth)
  " Based on auwsmit's MyFollowSymlink: https://github.com/tpope/vim-fugitive/issues/147#issuecomment-203389621
  let fpath = a:filename
  let allowed_recur_depth = a:allowed_recur_depth
  if allowed_recur_depth <= 0
    return
  endif
  let ftail = fnamemodify(fpath, ':t')
  let dirstr = system('dir ' . fpath . '*')

  " check if current argument is a symlink
  let is_symlink = match(dirstr, '<SYMLINK..\s\+' . ftail . ' [') != -1
  if !is_symlink
    " if not, check if parent dir is symlink, up to $allowed_recur_depth directories
    let parent = fnamemodify(fpath, ':h')
    echo parent
    call s:FollowWin32Symlink_recursive(parent, allowed_recur_depth-1)
  else
    " extract symlink path
    let substr = '.*<SYMLINK..\s\+' . ftail . ' \[\(.\{-}\)\].*'
    let sympath = substitute(dirstr, substr, '\1', "")
    " figure out current file's path
    if filereadable(sympath)
      let resolvedfile = sympath
    else
      let resolvedfile = findfile(expand('%:t'), sympath, '**')
    endif

    " TODO: instead of following the link like this, we should store its path
    " and build the path to the actual file. wiping out buffers like this
    " fails for me (in the else case because there are multiple buffers
    " matching fpath).
    " Try changing these 'exec' to 'echo' to see what it's trying to do.
    " Also see if we can remove the write! -- that's dangerous.

    " 'follow' the symlink
    if bufexists(resolvedfile)
      exec 'buffer ' . resolvedfile . ' | bwipeout '.fpath
    else
      silent exec 'file ' . resolvedfile . ' | bwipeout '.fpath
      exec 'file ' . expand('%:p') . ' | write! | doautocmd BufRead'
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

    if exists("loaded_bbye")
        " Use bbye to clear the buffer, but not close the window.
        Bwipeout
    elseif exists("loaded_bufkill")
        " or bufkill
        BW
    else
        " We'll lose the current window, but it's better than nothing.
        bwipeout
    endif
    exec "edit " . fname
endfunction
command! FollowSymlink call s:SwitchToActualFile()
