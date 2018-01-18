
function! david#cs#FindScope()
    let last_search=@/

    let line = search('\v^(    |\t){0,2}\w.*\w\s*$', 'bWn')
    echo getline(line)

    let @/ = last_search
endf
