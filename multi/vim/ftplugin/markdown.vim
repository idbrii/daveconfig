" Instead of methods, jump between headings.
nnoremap <buffer> <silent> [m :<C-u>call search('^[#=]', 'bW')<CR>
nnoremap <buffer> <silent> ]m :<C-u>call search('^[#=]', 'W')<CR>


" These just go from top to bottom of the file. Continue my campaign of using
" them for 'method' jumping.
nmap <buffer> [[ [m
nmap <buffer> ]] ]m
