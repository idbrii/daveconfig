" Supplementary sovereign settings
" (So don't use did_ftplugin -- the base setting is already done and we just
" want to put some icing on it.)

" Not sure this is all necessary yet.

if !exists('g:loaded_sovereign')
    finish
endif

if b:sovereign_type != 'index'
    " Only want these settings for Gstatus -- that's when we're editing the
    " index.
    finish
endif

" I can't remember all of the hotkeys available in Gstatus, so make it easy
" to see them.
function! <SID>PrintGitStatusHelp()
    echo 'Sstatus commands:'
    echo '	<C-N> - next file'
    echo '	<C-P> - previous file'
    echo '	<CR>  - :Gedit'
    echo '	s     - un/stage'
    echo '	gm    - merge'
    echo '	a     - alternative view'
    echo '	i     - next file or hunk'
    echo '	>     - expand hunk'
    echo '	C     - commit'
    echo '	c     - verbose commit'
    echo '	ca    - amend commit'
    echo '	D     - diff'
    echo '	O     - :Gtabedit'
    echo '	o     - :Gsplit'
    echo '	p     - patch'
    echo '	gq    - close status'
    echo '	:edit - reload status'
endfunction
nnoremap <buffer> <silent> <F1> :call <SID>PrintGitStatusHelp()<CR>

"~ " Also use s to stage/unstage changes. Just shadow -.
"~ nmap <buffer> <silent> s -
"~ xmap <buffer> <silent> s -

" Easier launching of vim-mergetool.
nmap <buffer> gm <CR>:Merge<CR>

if !exists("g:david_toggle_fold_cmd")
    " Can't try to get this more than once or it might be our remap.
    let g:david_toggle_fold_cmd = maparg('<Leader>l', 'n')
endif
" Toggle diff "folds" on status items with our fold toggle map. If we're not
" on a status item, use default behavior.
nmap <buffer> <expr> <Leader>l getline('.') =~# '^\u \S' ? '=' : g:david_toggle_fold_cmd
" Unconditional toggle is like toggle all.
nmap <buffer>        <Leader>L =

" Include the diff in the commit and expand the window so we can see it.
" Sovereign is always verbose, so we don't include --verbose
nnoremap <buffer> <silent> ci :<C-U>Scommit<Bar>wincmd _<CR>O

" sovereign uses R to refresh the buffer. Remap C-l (my redraw command)
" instead.
nmap <buffer> <silent> <C-l> R<Plug>(david-redraw-screen) 

" Everything in sovereign-status is line-wise, so use cursorline to make it easier
" to see what line you're operating on.
setlocal cursorline
