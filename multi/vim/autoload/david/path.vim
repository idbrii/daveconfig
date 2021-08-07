if exists('&shellslash')
    function! david#path#to_unix(path)
        let shellslash_bak = &shellslash
        let &shellslash = 1
    
        let p = expand(a:path)
    
        let &shellslash = shellslash_bak
        return p
    endf

else
    function! david#path#to_unix(path)
        return expand(a:path)
    endf
endif

function! david#path#find_upwards_from_current_file(fname)
    let current_file_dir = expand('%:h')
    let found = findfile(a:fname, ';'.. current_file_dir)
    return found
endf

function! david#path#edit_upwards_from_current_file(fname)
    if stridx(a:fname, '*') >= 0
        echomsg "Glob is not supported"
        return
    endif
    let found = david#path#find_upwards_from_current_file(a:fname)
    if empty(found)
        echomsg printf("Failed to find file '%s' in directory above current file.", a:fname)
    else
        " Using execute() causes ale to fire errors
        "~ call execute('edit '.. found)
        execute 'edit '.. found
    endif
endf

function! david#path#build_kill_from_current_makeprg() abort
    let exe = &makeprg->split()[0]
    if exe !~? ".exe$"
        let exe .= ".exe"
    endif
    if !executable(exe)
        return ''
    endif
    
    let exe = fnamemodify(exe, ':t')
    return printf('command! ProjectKill call system("taskkill /im %s")', exe)
endf
