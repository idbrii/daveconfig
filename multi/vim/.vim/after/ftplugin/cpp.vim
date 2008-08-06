" Use :make to compile c, even without a makefile
if glob('Makefile') == "" | let &mp="g++ -o %< %" | endif

setlocal cindent
source $HOME/.vim/cscope_maps.vim
