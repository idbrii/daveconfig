
function! david#cs#FindScope()
    let last_search=@/
    let wrapscan_bak = &wrapscan
    let &wrapscan = 0

    normal ?\v^(    |\t){0,2}\w.*\w\s*$? mark c 
    nohlsearch
    echo getline("'c")

    let &wrapscan = wrapscan_bak
    let @/ = last_search
endf
