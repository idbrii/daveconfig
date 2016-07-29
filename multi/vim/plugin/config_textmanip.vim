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
" missing braces okay sometimes too (argumentative often jumped to the end of
" a block several lines away).
"
" Sideways doesn't support visual or operator pending maps for left/right (it
" clears visual selection when using SidewaysJump), but I've never used that
" feature of argumentative.

nnoremap [, :SidewaysJumpLeft<CR>
nnoremap ], :SidewaysJumpRight<CR>
nmap <, <Plug>SidewaysLeft
nmap >, <Plug>SidewaysRight

xmap i, <Plug>SidewaysArgumentTextobjI
xmap a, <Plug>SidewaysArgumentTextobjA
omap i, <Plug>SidewaysArgumentTextobjI
omap a, <Plug>SidewaysArgumentTextobjA
