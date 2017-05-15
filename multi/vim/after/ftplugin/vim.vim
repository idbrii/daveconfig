" Filetype set fo+=o, but I tend to use o and O to add whitespace, not
" to continue comments
setlocal formatoptions-=o

" My vim syntax doesn't have folding, so use indent.
setlocal foldmethod=indent

" Easy source file.
if exists(':Runtime') == 2
    " Use scriptease's Runtime to auto-disarm load guards.
    nnoremap <buffer> <Leader>vso :update<CR>:Runtime %<CR>
else
    nnoremap <buffer> <Leader>vso :update<CR>:source %<CR>
endif

" Easy execute line.
nnoremap <buffer> <Leader>v: 0y$:<C-r>"<CR>
" ; is easier than :
nnoremap <buffer> <Leader>v; 0y$:<C-r>"<CR>
" Source selection
xnoremap <buffer> <Leader>v; y:execute @"<CR>

" Easy echo.
nnoremap <buffer> <Leader>ve 0y$:echo <C-r>"<CR>
xnoremap <buffer> <Leader>ve y:execute 'echo '. @"<CR>

" In vimscript, use compl-vim instead of omnicomplete for smart completion.
inoremap <buffer> <C-Space> <C-x><C-v>

" No tabs in vim files.
setlocal expandtab