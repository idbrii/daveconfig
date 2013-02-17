" File: david.vim
" Description: Generic vimscript helpers (not for use in real plugins).

function! david#load_system_vimscript(vimscript_file)
    " Some tools offer vim integration and provide their own vimscript.
    " Instead of including it in ~/.vim, use this file to source it. Calls
    " to this function should be guarded with loaded_NAME so they can be
    " disabled in local.vim.
    "
    if filereadable(a:vimscript_file)
        exec 'source ' . a:vimscript_file
        return 1
    else
        " Probably because the apt or pip packages are not installed.
        let fname = fnamemodify(a:vimscript_file, ':t')
        let name = fnamemodify(fname, ':r')
        echom name .' not available: missing '. a:vimscript_file
        echom 'Ensure the package is installed and check pip or "apt-file find '. fname .'"'
        return 0
    endif
endf
