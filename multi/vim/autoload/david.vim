" Description: Generic vimscript helpers (not for use in real plugins).


" Message helpers {{{1

function! david#warn(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endf

" Call for assertions that you want to be true, but sometimes they're not.
function! david#should(expr, msg)
    if !a:expr
        return david#warn(a:msg)
    endif
endf

" Call for assertions that must always be true, and you should rewrite code if they're not.
function! david#must(expr, msg)
    if !a:expr
        echoerr a:msg
    endif
endf


" Loading helpers {{{1

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

function! david#python_version(major_version)
    if a:major_version == 2
        py  import sys; print(sys.version)
    else
        py3 import sys; print(sys.version)
    endif
    return ""
endf

function! david#has_registry_key(key_path)
    if has('win32')
        let result = system('reg QUERY '. a:key_path)
        return v:shell_error == 0
    else
        return v:false
    endif
endf

function! david#setup_python_paths(py_version, pythonhome)
    " If python is not in the path (because that breaks build pipeline), but
    " vim plugins need python, setup python's paths in vim. Any build scripts
    " called from vim need to clear these variables.
    if isdirectory(a:pythonhome)
        let has_key = v:false
        " For faster startup on known-good configuration:
        " let g:can_set_pythonhome = 0
        let g:can_set_pythonhome = get(g:, 'can_set_pythonhome', 1)
        if g:can_set_pythonhome
            if has('win32')
                " Python stores its paths in the registry, so we shouldn't need to set
                " them. If so, we only need to add it to PATH.
                " https://docs.python.org/2/using/windows.html#finding-modules
                let path_key = '\Software\Python\PythonCore\'. a:py_version .'\PythonPath'
                for hive in ['HKEY_CURRENT_USER', 'HKEY_LOCAL_MACHINE']
                    if david#has_registry_key(hive . path_key)
                        let has_key = v:true
                    endif
                endfor
            endif
            if !has_key
                " We don't want py2 in py3's PYTHONPATH and probably makes the
                " most sense to have PYTHONHOME match the first python found in
                " PATH.
                echomsg "Setting PYTHONPATH. Things might go wrong. Better to setup python in registry."
                let g:can_set_pythonhome = 0
                let $PYTHONHOME = a:pythonhome
                let $PYTHONPATH = $PYTHONHOME . "/Lib"
            endif
        endif

        if !exists("g:david_default_python")
            let g:david_default_python = a:py_version
            lockvar g:david_default_python

            " Make pydoc use the default (first in path, first configured) python.
            let python_folder = ''
            if len($PYTHONHOME) > 0
                let python_folder = $PYTHONHOME .'/'
            endif
            let g:pydoc_cmd = python_folder .'python -m pydoc'
        endif
        let $PATH = $PATH . ';' . a:pythonhome
        " Add Scripts to path so tools like black and mypy are available.
        let py_scripts = a:pythonhome .'/Scripts'
        if isdirectory(py_scripts)
            let $PATH = $PATH . ';' . py_scripts
        endif
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


" Parsing helpers {{{1

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


