" Diff next failure. Uses textobj-indent and diffusable.
nmap <buffer> <CR> /- \v(Expected<Bar>Got)<CR>jv<Plug>(textobj-indent-a)"1ynjv<Plug>(textobj-indent-a)"2y:DiffDeletes<CR>
