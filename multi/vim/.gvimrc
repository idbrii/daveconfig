colorscheme desert

" Ctrl + PgUp/Dn - Move between files
nnoremap <C-PageDown> :next<CR>
nnoremap <C-PageUp> :prev<CR>


" =-=-=-=-=-=
" Source work additions, if available
if filereadable(glob("$HOME/vimfiles/gwork.vim"))
    runtime gwork.vim
endif
