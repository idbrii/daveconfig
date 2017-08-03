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


" Commentary {{{2

let g:commentary_marker = '~'

" Use common g prefix with / as an easy-to-type comment character.
xmap <unique> g/  <Plug>Commentary
nmap <unique> g/  <Plug>Commentary
omap <unique> g/  <Plug>Commentary
" Too many conflicts and g/w seems to do the same?
"nmap <unique> g/c <Plug>CommentaryLine
" Overlaps with textobj-comment.
"nmap <unique> cg/ <Plug>ChangeCommentary
nmap <unique> g/.  <Plug>Commentary<Plug>Commentary
nmap <unique> g/g/ <Plug>Commentary<Plug>Commentary

" Table-mode {{{2
"
" Change mode -- table mode
" I use it so frequently, that I don't need it on a short prefix.
let g:table_mode_map_prefix = '<Leader>ct'
