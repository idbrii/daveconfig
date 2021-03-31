function! s:BuildLove(additional_args)
    update
    exec 'lcd' g:david_project_root

    let version_name = system('git rev-parse --short HEAD')
    if version_name =~# 'fatal: '
        let version_name = ''
    else
        " Prefix with a number so it looks more like a version number. Use the
        " commit hash so it's easy to match versions to git history. If I get
        " serious, I should be smarter about my number prefix.
        let version_name = '--version-name 1.0.'.. trim(version_name)
    endif
    
    let &l:makeprg = printf('makelove %s %s', version_name, a:additional_args)
    AsyncMake
endf
command! -buffer -nargs=* LuaMakeLove call s:BuildLove(<q-args>)
