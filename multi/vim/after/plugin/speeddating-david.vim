" My increment/decrement are mapped to ^x^s and ^x^x instead of ^a and ^x. Use
" these for speeddating, if it's loaded.

if exists("g:loaded_speeddating") && g:loaded_speeddating
    nmap  <C-x><C-s>     <Plug>SpeedDatingUp
    nmap  <C-x><C-x>     <Plug>SpeedDatingDown
    xmap  <C-x><C-s>     <Plug>SpeedDatingUp
    xmap  <C-x><C-x>     <Plug>SpeedDatingDown
    nmap d<C-x><C-s>     <Plug>SpeedDatingNowUTC
    nmap d<C-x><C-x>     <Plug>SpeedDatingNowLocal
    " Ensure speeddating knows vim's commands for increment/decrement
    nnoremap <Plug>SpeedDatingFallbackUp   <C-A>
    nnoremap <Plug>SpeedDatingFallbackDown <C-X>

    function! s:ToggleRoman(use_roman) abort
        if a:use_roman
            21SpeedDatingFormat %v
            22SpeedDatingFormat %^v
        else
            21SpeedDatingFormat!
            22SpeedDatingFormat!
        endif
    endf

    " Bang to remove roman
    command! -bang -bar SpeedDatingRoman call s:ToggleRoman(<bang>1)
    " No roman by default. It's always accidental.
    SpeedDatingRoman!
endif
