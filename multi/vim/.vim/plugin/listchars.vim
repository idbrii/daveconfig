" TODO: Add something to the statusline so I can tell when listchars is on.
function! ListCharToggle()
    if &list
        set invlist
    else
        set list
        set listchars=tab:▸·,trail:·
    endif
endfunction
"nmap <leader>' :call ListCharToggle()<CR>

