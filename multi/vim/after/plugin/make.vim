if exists("g:loaded_asynccommand") && g:loaded_asynccommand
    " Using silent prevents blank lines of output that requires hitting enter
    " to clear every time I run make.
    nnoremap <S-F5> :<C-u>update<Bar>silent AsyncMake 
    nnoremap <F5>   :<C-u>update<Bar>AsyncMake 
endif
