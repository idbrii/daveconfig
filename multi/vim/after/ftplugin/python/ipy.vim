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
    noremap  <buffer> <silent> <F5> :python run_this_file()<CR>
    noremap  <buffer> <silent> <S-F5> :python run_this_line()<CR>
    noremap  <buffer> <silent> <F9> :python run_these_lines()<CR>
    noremap  <buffer> <silent> <LocalLeader>d :py get_doc_buffer()<CR>
    noremap  <buffer> <silent> <LocalLeader>s :py update_subchannel_msgs(); echo("vim-ipython shell updated",'Operator')<CR>
    noremap  <buffer> <silent> <S-F9> :python toggle_reselect()<CR>
    "noremap  <buffer> <silent> <C-F6> :python send('%pdb')<CR>
    "noremap  <buffer> <silent> <F6> :python set_breakpoint()<CR>
    "noremap  <buffer> <silent> <s-F6> :python clear_breakpoint()<CR>
    "noremap  <buffer> <silent> <F7> :python run_this_file_pdb()<CR>
    "noremap  <buffer> <silent> <s-F7> :python clear_all_breaks()<CR>
    imap <buffer> <C-F5> <C-O><F5>
    imap <buffer> <S-F5> <C-O><S-F5>
    imap <buffer> <silent> <F5> <C-O><F5>
    "noremap  <buffer> <C-F5> :call <SID>toggle_send_on_save()<CR>
    "" Example of how to quickly clear the current plot with a keystroke
    "noremap  <buffer> <silent> <F12> :python run_command("plt.clf()")<cr>
    "" Example of how to quickly close all figures with a keystroke
    "noremap  <buffer> <silent> <F11> :python run_command("plt.close('all')")<cr>

    "pi custom
    noremap  <buffer> <silent> <C-Return> :python run_this_file()<CR>
    noremap  <buffer> <silent> <LocalLeader>r :python run_this_line()<CR>
    inoremap <buffer> <silent> <LocalLeader>r <C-O>:python run_this_line()<CR>
    noremap  <buffer> <silent> <M-s> :python dedent_run_this_line()<CR>
    vnoremap <buffer> <silent> <LocalLeader>r :python run_these_lines()<CR>
    vnoremap <buffer> <silent> <M-s> :python dedent_run_these_lines()<CR>
    "noremap  <buffer> <silent> <M-c> I#<ESC>
    "vnoremap <buffer> <silent> <M-c> I#<ESC>
    "noremap  <buffer> <silent> <M-C> :s/^\([ \t]*\)#/\1/<CR>
    "vnoremap <buffer> <silent> <M-C> :s/^\([ \t]*\)#/\1/<CR>
endif
