function! skeletons#skeleton#setup_autocmd_for_types(filetype_list)
    augroup skeletons
        au!
        for ftype in a:filetype_list
            exec 'au BufNewFile *.'. ftype .' if &modifiable | call skeletons#'. ftype .'#create() | endif'
        endfor
    augroup END
endfunction

" vim: set ts=4 sw=4 et:
