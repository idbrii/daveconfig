" My increment/decrement are mapped to ^x^s and ^x^x instead of ^a and ^x. Use
" these for speeddating, if it's loaded.

if exists("g:loaded_speeddating") && g:loaded_speeddating
    nmap  <C-x><C-s>     <Plug>SpeedDatingUp
    nmap  <C-x><C-x>     <Plug>SpeedDatingDown
    xmap  <C-x><C-s>     <Plug>SpeedDatingUp
    xmap  <C-x><C-x>     <Plug>SpeedDatingDown
    nmap d<C-x><C-s>     <Plug>SpeedDatingNowUTC
    nmap d<C-x><C-x>     <Plug>SpeedDatingNowLocal
endif
