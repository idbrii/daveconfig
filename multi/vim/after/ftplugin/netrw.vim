if !exists('g:loaded_netrw')
    finish
endif

nmap <buffer> <C-l> <Plug>NetrwRefresh
imap <buffer> <C-l> <Plug>NetrwRefresh

" Use tab to quickly search filenames. (Like tab completion.) Starts at first
" filename line at first column. This would probably be better as a netrw mode
" where you just kept typing and hitting enter to navigate.
nnoremap <buffer> <Tab> 8G/^
