if exists("g:loaded_asynccommand") && g:loaded_asynccommand
    " Using silent prevents blank lines of output that requires hitting enter
    " to clear every time I run make.
    nnoremap <S-F5> :silent AsyncMake 
    nnoremap <F5> :AsyncMake 
endif
