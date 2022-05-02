

function! david#ultisnips#UltiSnipsEdit(list_files) abort
    " Always use Vedit so we can always navigate the loclist.
    exec "Vedit UltiSnips/".. &ft ..".snippets"
    if a:list_files
        lopen
    endif
endf
