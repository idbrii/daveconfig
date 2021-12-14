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

function! david#path#lowercase_drive_letter(path) abort
    let f = a:path
    if f[1] == ':'
        let f = printf('%s:%s', tolower(f[0]), f[2:])
    endif
    return f
endf

" If relative_parent is a parent of path, return the relative path. Otherwise
" return the absolute path.
function! david#path#relative_to_parent(path, relative_parent) abort
    let file = david#path#lowercase_drive_letter(david#path#to_unix(fnamemodify(a:path, ':p')))
    let dir  = david#path#lowercase_drive_letter(david#path#to_unix(a:relative_parent))

    if file->stridx(dir) >= 0
        let n = len(dir)
        return file[n+1:]
    endif
    return file
endf

function! david#path#find_upwards_from_current_file(fname)
    " Don't force unix path so vim interprets slashes correctly.
    let current_file_dir = expand('%:p:h')
    let found = findfile(a:fname, current_file_dir ..';/')
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
    return printf('command! ProjectKill update | call system("taskkill /im %s")', exe)
endf

" See also the more aggressive after/plugin/followsymlink.vim
function! david#path#chdir_to_current_file() abort
    call chdir(david#path#get_currentfile_resolved_as_dir())
endf

function! david#path#get_currentfile_resolved_as_dir() abort
    return resolve(escape(expand('%:p:h'), '%#'))
endf
function! david#path#get_currentfile_resolved() abort
    return resolve(escape(expand('%:p'), '%#'))
endf
