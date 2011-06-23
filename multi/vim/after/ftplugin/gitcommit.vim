" Supplementary gitcommit settings
" (So don't use did_ftplugin -- the base setting is already done and we just
" want to put some icing on it.)

" Fold filenames under the three headings: staged, modified, untracked
function! FoldGitCommit(lnum)
    let text = getline(a:lnum)

    if      text=~'^# \u'
        " heading -- starts fold so it's used as the title
        return '>1'
    elseif  text=~'^#\t'
        " filename
        return 1
    elseif  text=~'^#$' || text=~'^#\s*('
        " blank line or help text
        return '='
    endif
    return 0
endfunction

" Locate the trash folder.
" Used by DeleteFilesInGitCommit
function! s:GetTrash()
    let trashes = [ '$HOME/.local/share/Trash/files', '$HOME/.Trash' ]
    for t in trashes
        let t = expand(t)
        if isdirectory(t)
            return t
        endif
    endfor
    throw 'no trash found'
endfunction

" After merges, there are *.orig and *.REMOTE.* *.LOCAL.* files left behind.
" This function makes it easy to remove them.
function! DeleteFilesInGitCommit()
    let line = getline('.')
    let line = substitute(line, '^#\s*', '', '')

    " Search for the git directory and find its parent
    let root = finddir('.git', '.;')
    if root == ''
        echoerr "Couldn't find git root"
        return
    endif
    let root = fnamemodify(root, ':h')

    let fname = root .'/'. line

    try
        " Try to move it to trash instead of just deleting it
        let trash = s:GetTrash()
        exec '!mv -t '. trash .' --backup=t ' . fnameescape(fname)
    catch /^no trash found/
        " Couldn't find the trash folder, so just delete it
        let result = delete(fname)
        if result != 0
            echoerr 'Failed to delete file: ' . fname
        endif
    endtry
endfunction

" Use the folding function
setlocal foldmethod=expr
setlocal foldexpr=FoldGitCommit(v:lnum)
