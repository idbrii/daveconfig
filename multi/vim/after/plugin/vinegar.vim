
" I like the banner
let g:netrw_banner = 1

" I like shellslash, but it breaks shell stuff like gx. Hack around it.
if exists('+shellslash') && &shellslash
    function! David_NetrwBrowseX()
        set noshellslash
        exec "normal \<Plug>NetrwBrowseX"
        set shellslash
    endf
    nnoremap gx :call David_NetrwBrowseX()<CR>
endif
