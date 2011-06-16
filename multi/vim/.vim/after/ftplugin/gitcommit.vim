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

" Use the folding function
setlocal foldmethod=expr
setlocal foldexpr=FoldGitCommit(v:lnum)
