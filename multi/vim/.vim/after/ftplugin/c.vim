" Use :make to compile c, even without a makefile
if glob('Makefile') == "" | let &mp="gcc -o %< %" | endif

setlocal cindent
runtime cscope_maps.vim
