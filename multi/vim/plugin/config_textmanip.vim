" Swapping text {{{1


" Exchange {{{2

" I only want to remap ExchangeLine, so I can just do the one.
let g:exchange_no_mappings = 1
nmap <Leader>x     <Plug>(Exchange)
xmap <Leader>x     <Plug>(Exchange)
nmap <Leader>xc    <Plug>(ExchangeClear)
nmap <Leader>x<CR> <Plug>(ExchangeLine)

nmap cx <Plug>(exchange-dwim)


" Sideways {{{2

" Use Sideways over Argumentative. Sideways does nothing when it can't figure
" out what to do (when there aren't matching braces). It seems to handle some
" missing braces okay sometimes too (argumentative often jumps wildly to the
" end of a block several lines away).
"
" Sideways doesn't support visual or operator pending maps for left/right (it
" clears visual selection when using SidewaysJump), but I've never used that
" feature of argumentative.
"
" The load time for sideways is shorter since it's autoloaded:
"	208.000  001.000  001.000: sourcing C:/Users/davidb/.vim/bundle/argumentative/plugin/argumentative.vim
"	413.000  000.000  000.000: sourcing C:/Users/davidb/.vim/bundle/sideways/plugin/sideways.vim

" Disable Argumentative.
let loaded_argumentative = 0

nnoremap [, :SidewaysJumpLeft<CR>
nnoremap ], :SidewaysJumpRight<CR>
nmap <, <Plug>SidewaysLeft
nmap >, <Plug>SidewaysRight

xmap i, <Plug>SidewaysArgumentTextobjI
xmap a, <Plug>SidewaysArgumentTextobjA
omap i, <Plug>SidewaysArgumentTextobjI
omap a, <Plug>SidewaysArgumentTextobjA
