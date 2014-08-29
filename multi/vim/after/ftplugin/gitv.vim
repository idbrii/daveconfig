
" Gitv uses u to refresh the buffer. Remap C-l (my redraw command) instead.
nmap <buffer> <silent> <C-l> u<Plug>(david-redraw-screen) 
nmap <buffer> <silent> <C-n> <Plug>(gitv-previous-commit)
nmap <buffer> <silent> <C-p> <Plug>(gitv-next-commit)
