
" Workaround for vim-markdown#488: gx gets clobbered even though netrw isn't installed.
nmap <Leader>gx <Plug>Markdown_OpenUrlUnderCursor

command! -buffer -range=% SumEstimates :<line1>,<line2> call david#org#sum_estimates()
