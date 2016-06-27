" vim-exchange doesn't define a load guard, so use a command instead. (Better
" would be a Plug, but I don't know how.)
"if !exists('loaded_exchange')
if exists(':XchangeClear') != 2
    " Requires vim-exchange
    finish
endif


" A do-what-I-mean command for exchange. This preserves
function! s:back_off_from_separator()
    call search('.\%#[;,]', 'b', line("."))
endf

function! s:exchange_dwim()
    let lazyredraw_bak = &lazyredraw

    let win_save = winsaveview()

    " Find first word at or after cursor
    call search('\w', 'c', line("."))
    " Select it
    normal! viW
    " Ensure we didn't select a semicolon or comma
    call s:back_off_from_separator()
    " Mark for exchange. TODO: Can I use <Plug> here?
    normal X
    " Go back to start point.
    call winrestview(win_save)
    " Select previous word
    normal! BviW
    call s:back_off_from_separator()
    " Exchange it.
    normal X

    " Restore original cursor position.
    call winrestview(win_save)

    let &lazyredraw = lazyredraw_bak

    " Uses tpope's repeat.vim for dot repeating
    silent! call repeat#set("\<Plug>(exchange-dwim)")
endf

command! XchangeDwim keepjumps keepmarks call s:exchange_dwim()
nnoremap <Plug>(exchange-dwim) :<C-u>XchangeDwim<CR>


" I only want to remap ExchangeLine, so I can just do the one.
"let g:exchange_no_mappings = 1
"nmap cx  <Plug>(Exchange)
"xmap X   <Plug>(Exchange)
"nmap cxc <Plug>(ExchangeClear)
nmap cx<CR> <Plug>(ExchangeLine)

nmap cxx <Plug>(exchange-dwim)
