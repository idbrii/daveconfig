" TODO: Add something to the statusline so I can tell when listchars is on.

" Make whitespace visible. Test	it out: 
function! s:ListCharToggle()
    if &list
        set invlist
    else
        set list
        set listchars=tab:»\ ,trail:·
        " May also want to use eol:¬

    endif
endfunction

command! ListCharToggle call s:ListCharToggle()
"nnoremap <leader>' :call <SID>ListCharToggle()<CR>
