

function! david#ultisnips#UltiSnipsEdit(list_files) abort
    " Always use Vedit so we can always navigate the loclist.
    Vedit UltiSnips/lua.snippets
    if a:list_files
        lopen
    endif
endf
