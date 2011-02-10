if exists('g:loaded_redirecthelper')
    finish
endif
let g:loaded_redirecthelper = 1

" Redirect commands to new buffer
"" Puts the last g search command in a new buffer -- clobbers your c buffer
function! <SID>What()
    redir @c
    global/
    redir END
    new
    put! c
endfunction
command! What call <SID>What()
"" Puts whatever is in between in a new buffer
"" You can use ctag/cscope output, g searches, whatever! -- clobbers your c buffer
command! RStart redir @c
function! <SID>RedirectEnd()
    redir END
    sp ~/.redir.vimscratch
    put! c
endfunction
command! REnd call <SID>RedirectEnd()
"" Faster ways to start search redirects. Require REnd once complete.
cabbrev rg redir @c<CR>:g
cabbrev rv redir @c<CR>:v
