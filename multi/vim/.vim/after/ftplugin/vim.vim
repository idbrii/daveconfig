" Filetype set fo+=o, but I tend to use o and O to add whitespace, not
" to continue comments
setlocal formatoptions-=o

" For some reason in Ubuntu 10.10, keywordprg is always set to man
" Vim should use help
setlocal keywordprg=:help
