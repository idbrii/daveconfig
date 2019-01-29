" Supplementary gitcommit settings
" (So don't use did_ftplugin -- the base setting is already done and we just
" want to put some icing on it.)

if !exists('g:loaded_fugitive')
    finish
endif

if b:fugitive_type != 'index'
    " Only want these settings for Gstatus -- that's when we're editing the
    " index.
    finish
endif

" I can't remember all of the hotkeys available in Gstatus, so make it easy
" to see them.
function! <SID>PrintGitStatusHelp()
    echo 'GStatus commands:'
    echo '	<C-N> - next file'
    echo '	<C-P> - previous file'
    echo '	<CR>  - :Gedit'
    echo '	s     - un/stage'
    echo '	a     - alternative view'
    echo '	i     - index view'
    echo '	C     - commit'
    echo '	c     - verbose commit'
    echo '	ca    - amend commit'
    echo '	D     - diff'
    echo '	O     - :Gtabedit'
    echo '	o     - :Gsplit'
    echo '	p     - patch'
    echo '	q     - close status'
    echo '	R     - reload status'
    echo '	S     - :Gvsplit'
endfunction
nnoremap <buffer> <silent> <F1> :call <SID>PrintGitStatusHelp()<CR>

" Also use s to stage/unstage changes. Just shadow -.
nmap <buffer> <silent> s -
xmap <buffer> <silent> s -

" Include the diff in the commit and expand the window so we can see it.
nnoremap <buffer> <silent> c :<C-U>Gcommit --verbose<CR><C-w>_O<Esc>

" fugitive uses R to refresh the buffer. Remap C-l (my redraw command)
" instead.
nmap <buffer> <silent> <C-l> R<Plug>(david-redraw-screen) 

" Everything in git-status is line-wise, so use cursorline to make it easier
" to see what line you're operating on.
setlocal cursorline
