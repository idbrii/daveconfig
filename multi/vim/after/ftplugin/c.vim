" Use :make to compile c, even without a makefile
" This is problematic with deep directories (and I don't understand glob)
"if glob('Makefile') == "" | let &mp="gcc -o %< %" | endif

setlocal cindent
runtime cscope_maps.vim

" Filetype set fo+=o, but I tend to use o and O to add whitespace, not
" to continue comments
setlocal formatoptions-=o
