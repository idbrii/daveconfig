" ipython connectivity
"
" Requires:
"   aptinstall ipython python-zmq
"   cd /usr/share/doc/ipython/examples/vim
"   zcat ipy.vim.gz | sudo tee ipy.vim > /dev/null
"
" Usage:
"   From a shell:
"       ipython kernel
"   Copy the connection string, like: --existing kernel-14799.json
"   From vim:
"       :IPython <connection-string>
"   Example: 
"       :IPython --existing kernel-14799.json


if &cp
    finish
endif

" Maps <C-s> and doesn't only map to the local buffer.
let g:ipy_perform_mappings = 0

if !exists('loaded_python_ipy')
    let loaded_python_ipy = david#load_system_vimscript('/usr/share/doc/ipython/examples/vim/ipy.vim')
endif

if loaded_python_ipy
    map <silent> <F5> :python run_this_file()<CR>
    map <silent> <S-F5> :python run_this_line()<CR>
    map <silent> <F9> :python run_these_lines()<CR>
    map <silent> <leader>d :py get_doc_buffer()<CR>
    map <silent> <leader>s :py update_subchannel_msgs(); echo("vim-ipython shell updated",'Operator')<CR>
    map <silent> <S-F9> :python toggle_reselect()<CR>
    "map <silent> <C-F6> :python send('%pdb')<CR>
    "map <silent> <F6> :python set_breakpoint()<CR>
    "map <silent> <s-F6> :python clear_breakpoint()<CR>
    "map <silent> <F7> :python run_this_file_pdb()<CR>
    "map <silent> <s-F7> :python clear_all_breaks()<CR>
    imap <C-F5> <C-O><F5>
    imap <S-F5> <C-O><S-F5>
    imap <silent> <F5> <C-O><F5>
    map <C-F5> :call <SID>toggle_send_on_save()<CR>
    "" Example of how to quickly clear the current plot with a keystroke
    map <silent> <F12> :python run_command("plt.clf()")<cr>
    "" Example of how to quickly close all figures with a keystroke
    map <silent> <F11> :python run_command("plt.close('all')")<cr>

    "pi custom
    map <silent> <C-Return> :python run_this_file()<CR>
    map <silent> <C-s> :python run_this_line()<CR>
    imap <silent> <C-s> <C-O>:python run_this_line()<CR>
    map <silent> <M-s> :python dedent_run_this_line()<CR>
    vmap <silent> <C-S> :python run_these_lines()<CR>
    vmap <silent> <M-s> :python dedent_run_these_lines()<CR>
    map <silent> <M-c> I#<ESC>
    vmap <silent> <M-c> I#<ESC>
    map <silent> <M-C> :s/^\([ \t]*\)#/\1/<CR>
    vmap <silent> <M-C> :s/^\([ \t]*\)#/\1/<CR>
endif
