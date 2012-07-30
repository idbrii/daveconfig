" Filetype set fo+=o, but I tend to use o and O to add whitespace, not
" to continue comments
setlocal formatoptions-=o

" For some reason in Ubuntu 10.10, keywordprg is always set to man
" Vim should use help
setlocal keywordprg=:help

" My vim syntax doesn't have folding, so use indent.
setlocal foldmethod=indent

" Vimscript function arguments have a: prepended to them in the body of the
" function, which prevents their names from being autocompleted unless we
" remove : from the keyword chars.
setlocal iskeyword-=:

" Easy source file.
nnoremap <buffer> <Leader>vso :w<CR>:source %<CR>
" Easy execute line.
nnoremap <buffer> <Leader>v: 0y$:<C-r>"<CR>
