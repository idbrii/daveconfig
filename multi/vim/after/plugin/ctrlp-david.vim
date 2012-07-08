" CtrlP - fuzzy file finder
" File: after/plugin/ctrlp.vim
" Description: Custom statusline example

" Make sure ctrlp is installed and loaded
if !exists('g:loaded_ctrlp')
    || ( exists('g:loaded_ctrlp') && !g:loaded_ctrlp )
    finish
endif


" ctrlp only looks for this
let g:ctrlp_status_func = {
            \ 'main': 'CtrlP_Statusline_Main',
            \ 'prog': 'CtrlP_Statusline_Progress',
            \ }


" This part's just an example that recreates the default styling based on
" CtrlP at 1.78:

" CtrlP_Statusline_Main and CtrlP_Statusline_Progress both must return a full statusline
" and are accessible globally.

" Main statusline is the same as default, but without the prev/next modes.
function! CtrlP_Statusline_Main(focus, byfname, regexp, prv, item, nxt, marked)
    let marked = a:marked
    let dyncwd = getcwd()

    let item    = '%#CtrlPMode1# '.a:item.' %*'
    let focus   = '%#CtrlPMode2# '.a:focus.' %*'
    let byfname = '%#CtrlPMode1# '.a:byfname.' %*'
    let regex   = a:regexp  ? '%#CtrlPMode2# regex %*' : ''
    " Don't show slider because it's confusing and cluttered.
    " default: let slider  = ' <'.a:prv.'>={'.a:item.'}=<'.a:nxt.'>'
    let slider  = ' {'.a:item.'}'
    let dir     = ' %=%<%#CtrlPMode2# '.dyncwd.' %*'
    let stl     = focus.byfname.regex.slider.marked.dir
    return stl
endfunction

" Progress statusline is the same as CtrlP default.
function! CtrlP_Statusline_Progress(enum)
    let dyncwd = getcwd()

    let txt = a:0 ? '(press ctrl-c to abort)' : ''
    let stl = '%#CtrlPStats# '.a:enum.' %* '.txt.'%=%<%#CtrlPMode2# '.dyncwd.' %*'
    return stl
endfunction

" vim:fen:fdm=marker:fmr={{{,}}}:fdl=0:fdc=1:ts=2:sw=2:sts=2
