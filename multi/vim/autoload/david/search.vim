
" Find containing scope, echo it, and return its line number. Some languages
" have different levels of relevant scope, so the number of indents is a
" parameter.
" Assumes lines ending with ; or , are not relevant to scope.
function! david#search#FindScope(max_indents)
    let last_search=@/

    let space_indent = repeat(' ', &shiftwidth)
    let query = '\v^('. space_indent .'|\t){0,'. a:max_indents .'}\w.*[^ \t;,]\s*$'
    let line = search(query, 'bWn')
    echo getline(line)

    let @/ = last_search

    " Also highlight current scope.
    call matchup#matchparen#highlight_surrounding()

    return line
endf
