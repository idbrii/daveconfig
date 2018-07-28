" gv doesn't have a refresh. Should figure that out and remap C-l (my redraw command).
"~ nmap <buffer> <silent> <C-l> u<Plug>(david-redraw-screen) 

" Yank commit sha.
if has('mac') || !has('unix') || has('xterm_clipboard')
    nnoremap <silent> <buffer> yc :<C-u>let @+ = gv#sha()<CR>
else
    nnoremap <silent> <buffer> yc :<C-u>let @" = gv#sha()<CR>
endif

" Cycle between refs.
nnoremap <silent> <buffer> r /\%23c(<CR>:nohl<CR>
nnoremap <silent> <buffer> R ?\%23c(<CR>:nohl<CR>
function! s:search_for_head(direction, count)
    " TODO: How to save the search register? this doesn't search for any but
    " the first.
    let g:gv_search_bak = @/
    " After data and commit
    let @/ = '\%23c('
    let dir = (a:direction ? "/" : "?")

    let search = a:count . (a:direction ? "n" : "N")
    exec 'silent normal! '. search
endf
"~ nnoremap <silent> <buffer> r :<C-u>silent call <SID>search_for_head(1, v:count)<CR>
"~ nnoremap <silent> <buffer> R :<C-u>silent call <SID>search_for_head(0, v:count)<CR>
