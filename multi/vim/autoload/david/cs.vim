
function! david#cs#FindScope()
    let last_search=@/

    let space_indent = repeat(' ', &shiftwidth)
    let query = '\v^('. space_indent .'|\t){0,2}\w.*[^ \t;,]\s*$'
    let line = search(query, 'bWn')
    echo getline(line)

    let @/ = last_search
endf
