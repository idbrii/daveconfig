" Supplementary gitcommit settings
" (So don't use did_ftplugin -- the base setting is already done and we just
" want to put some icing on it.)

if !exists('g:loaded_fugitive')
    finish
endif

if expand('%:t') !=# 'index'
    " Only want these settings for GStatus -- that's when we're editing the
    " index.
    finish
endif

" I can't remember all of the hotkeys available in Gstatus, so make it easy
" to see them.
function! <SID>PrintGitStatusHelp()
    echo 'GStatus commands:'
    echo '    a     - alternative view'
    echo '    i     - index view'
    echo '    D     - diff'
    echo '    s     - un/stage'
    echo '    p     - patch'
    echo '    <C-N> - next file'
    echo '    <C-P> - previous file'
    echo '    C     - commit'
    echo '    c     - verbose commit'
endfunction
nnoremap <buffer> <silent> <F1> :call <SID>PrintGitStatusHelp()<CR>

" Also use s to stage/unstage changes. Just shadow -.
nmap <buffer> <silent> s -
xmap <buffer> <silent> s -

" Include the diff in the commit and expand the window so we can see it.
nnoremap <buffer> <silent> c :<C-U>Gcommit --verbose<CR><C-w>_

" Everything in git-status is line-wise, so use cursorline to make it easier
" to see what line you're operating on.
setlocal cursorline
