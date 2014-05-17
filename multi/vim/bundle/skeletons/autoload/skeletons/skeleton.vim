function! skeletons#skeleton#setup_autocmd_for_types(filetype_list)
    augroup skeletons
        for ftype in a:filetype_list
            exec 'au BufNewFile *.'. ftype .' call skeletons#'. ftype .'#create()'
        endfor
    augroup END
endfunction

" vim: set ts=4 sw=4 et:
