" Make space work like a wild card (like VisualAssist)
" Map() cleverness from http://marksman.wordpress.com/vimrc/
"
augroup lookupfile_custom
    au!
    au BufEnter * if &filetype == 'lookupfile' | call MapLookupfileRegex() | endif
augroup END

function! MapLookupfileRegex(...)
    " if no parameter, or a non-zero parameter, set up the mappings:
    if a:0 == 0 || a:1 != 0
        inoremap <Space> .*

        autocmd! BufLeave * call MapLookupfileRegex(0)

    else
        silent! iunmap <Space>

        " once done, get rid of the autocmd that called this:
        autocmd! BufLeave *

    endif
endfunction

