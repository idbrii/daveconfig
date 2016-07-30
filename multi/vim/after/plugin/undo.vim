
" Gundo -- visualize the undo tree
if exists("g:loaded_mundo") && g:loaded_mundo > 0
    nnoremap <F2> :<C-u>MundoToggle<CR>
else
    nnoremap <F2> :<C-u>GundoToggle<CR>
endif
