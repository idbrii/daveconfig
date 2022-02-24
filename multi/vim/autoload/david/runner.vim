
" Global entrypoint
function! david#runner#set_entrypoint(args)
    " Use the current file and its directory and jump back there to run
    " (ensures any expected relative paths will work).
    let cur_file = david#path#to_unix('%:p')
    let cur_dir = david#path#to_unix(fnamemodify(cur_file, ':h'))

    if !exists("s:original_makeprg")
        let s:original_makeprg = &makeprg
    endif

    let entrypoint_makeprg = s:original_makeprg
    let entrypoint_makeprg = substitute(entrypoint_makeprg, '%', cur_file, '')
    let entrypoint_makeprg .= a:args

    function! DavidProjectBuild() closure
        update
        call execute('lcd '. cur_dir)
        let &makeprg = entrypoint_makeprg
        " Use AsyncRun instead of AsyncMake so we can pass cwd and ensure
        " callstacks are loaded properly.
        call execute('AsyncRun -program=make -auto=make -cwd='. cur_dir .' @')
    endf

    "~ command! ProjectMake call DavidProjectBuild()
    command! ProjectRun  call DavidProjectBuild()
    let &makeprg = entrypoint_makeprg
endf
