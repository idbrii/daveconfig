" Special case for slime with python.
"
" Assumes we use ipython.
"
if (! exists('no_plugin_maps') || ! no_plugin_maps)
    " If we're using python, then we're probably in ipython. Sometimes python
    " indenting isn't understood correctly, so Load the file instead of sending
    " it.
    nmap <silent> <buffer> <Leader>R :call Slime_Send_to_Screen("%run <C-r>=expand("%:p")<CR>\n")<CR>:echo 'Slime_Send_to_Screen("%run ...")'<CR>
endif
