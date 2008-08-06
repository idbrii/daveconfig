" Use :make to compile c, even without a makefile
if glob('Makefile') == "" | let &mp="g++ -o %< %" | endif

setlocal cindent
runtime cscope_maps.vim
