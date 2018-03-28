function! david#mappings#map_next_function_instead_of_zero_column()
    " These are properly ]m, but ]] is easier and more useful. Jumping to
    " brace in zero column is not helpful.

    nmap <buffer> ]] <Plug>(jumpmethod-curly-tostart-fwd)
    nmap <buffer> [[ <Plug>(jumpmethod-curly-tostart-back)
    nmap <buffer> ][ <Plug>(jumpmethod-curly-toend-fwd)
    nmap <buffer> [] <Plug>(jumpmethod-curly-toend-back)
                    
    xmap <buffer> ]] <Plug>(jumpmethod-curly-tostart-fwd)
    xmap <buffer> [[ <Plug>(jumpmethod-curly-tostart-back)
    xmap <buffer> ][ <Plug>(jumpmethod-curly-toend-fwd)
    xmap <buffer> [] <Plug>(jumpmethod-curly-toend-back)
                    
    omap <buffer> ]] <Plug>(jumpmethod-curly-tostart-fwd)
    omap <buffer> [[ <Plug>(jumpmethod-curly-tostart-back)
    omap <buffer> ][ <Plug>(jumpmethod-curly-toend-fwd)
    omap <buffer> [] <Plug>(jumpmethod-curly-toend-back)
endf
