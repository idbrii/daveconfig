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
    if isdirectory(a:pythonhome)
        if !exists('s:david_default_python')
            " We don't want py2 in py3's PYTHONPATH and probably makes the
            " most sense to have PYTHONHOME match the first python found in
            " PATH.
            let s:david_default_python = a:pythonhome
            let $PYTHONHOME = a:pythonhome
            let $PYTHONPATH = $PYTHONHOME . "/Lib"

            " Make sure pydoc is using our configured python.
            let g:pydoc_cmd = $PYTHONHOME .'/python -m pydoc'
        endif
        let $PATH = $PATH . ';' . a:pythonhome
    else
        echoerr "Invalid pythonhome directory: ". a:pythonhome
    endif
endfunction

function! david#add_to_path(absolute_directory)
    let success = isdirectory(a:absolute_directory)
    if success
        let $PATH = $PATH . ';' . a:absolute_directory
    else
        echoerr "Invalid directory: ". a:absolute_directory
    endif
    return success
endfunction

function! david#get_comma_pair_list_as_dict(comma_pair_list, delimiter)
    let list_as_dict = {}
    for key_and_literal in split(a:comma_pair_list, ',')
        let pair = split(key_and_literal, a:delimiter)
        if len(pair) <= 1
            let key = 'none'
            let literal = pair[0]
        else
            let key = pair[0]
            let literal = pair[1]
        endif
        let list_as_dict[key] = literal
    endfor
    return list_as_dict
endf

function! david#get_single_line_comment_leader()
    let comments_as_dict = david#get_comma_pair_list_as_dict(&comments, ':')

    " Cannot get try..catch to work with E716, so brute force.
    return get(comments_as_dict, 'none', printf(&commentstring, ""))
endf

