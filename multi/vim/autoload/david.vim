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

function! david#setup_python_paths(pythonhome)
    " If python is not in the path (because that breaks build pipeline), but
    " vim plugins need python, setup python's paths in vim. Any build scripts
    " called from vim need to clear these variables.
    let $PYTHONHOME = a:pythonhome
    let $PYTHONPATH = $PYTHONHOME . "/Lib"
    if isdirectory($PYTHONHOME)
        let $PATH = $PATH . ';' . $PYTHONHOME
    endif
endfunction

