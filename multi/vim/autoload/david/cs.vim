
function! david#cs#FindScope()
    let last_search=@/
    
    normal ?\v^(    ){0,2}\w.*[^;]$? mark c
    nohlsearch
    echo getline("'c")

    let @/ = last_search
endf
