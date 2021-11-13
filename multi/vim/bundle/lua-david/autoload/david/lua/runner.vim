
" Global entrypoint
function! david#lua#runner#set_entrypoint(makeprg)
    " Use the current file and its directory and jump back there to run
    " (ensures any expected relative paths will work).
    let cur_file = david#path#to_unix('%:p')
    let cur_dir = david#path#to_unix(fnamemodify(cur_file, ':h'))
    let cur_module = david#path#to_unix(fnamemodify(cur_file, ':t:r'))

    if !exists("s:original_makeprg")
        let s:original_makeprg = &makeprg
    endif

    if a:makeprg =~# '^lovec\?\>'
        " Don't have a better way to distinguish love files, so use this to
        " configure checker properly.
        let g:ale_lua_luacheck_options .= ' --std love+luajit'
        let target = cur_dir

        " Gabe uses S for a global.
        let g:vim_lsp_settings_sumneko_lua_language_server_workspace_config.Lua.diagnostics.globals = 'S'
    else
        let target = cur_file
    endif
    
    let entrypoint_makeprg = a:makeprg
    if empty(a:makeprg)
        let entrypoint_makeprg = s:original_makeprg
    endif
    let entrypoint_makeprg = substitute(entrypoint_makeprg, '%', target, '')

    function! DavidProjectBuild() closure
        update
        ProjectKill
        " Wait long enough for app to close and asyncrun to terminate so
        " it doesn't fail to run again.
        sleep 1
        call execute('lcd '. cur_dir)
        let &makeprg = entrypoint_makeprg
        " Use AsyncRun instead of AsyncMake so we can pass cwd and ensure
        " callstacks are loaded properly.
        call execute('AsyncRun -program=make -auto=make -cwd='. cur_dir .' @')
    endf
    " Don't let python settings leak into lua.
    let g:asyncrun_exit = ''

    command! ProjectMake call DavidProjectBuild()
    command! ProjectRun  call DavidProjectBuild()
    exec david#path#build_kill_from_current_makeprg()

    " Clobber current project settings.
    silent! unlet g:david_project_filelist
    let g:david_project_root = fnamemodify(cur_file, ':h')
    call LocateAll()
    NotGrepRecursiveFrom .
    " I put code in ./src/
    let g:inclement_n_dir_to_trim = 2
    let g:inclement_after_first_include = 1
    let g:inclement_include_directories = "lib|src"
    " Must match tags file which uses no drive and forward slashes

    let src_root = g:david_project_root ..'/src/'
    if has('win32')
        let src_root = substitute(src_root, '\\', '/', 'g')
        let src_root = substitute(src_root, '^\w:', '', '')
    endif
    let g:inclement_src_root = src_root
endf
function! david#lua#runner#GetLoveCmd()
    if has('win32')
        " Lovec does a better job of outputting to the console on Windows.
        return 'lovec'
    else
        return 'love'
    endif
endf
