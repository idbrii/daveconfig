function! david#lua#setup_qf_after_compile() abort
    " No errors detected in lua, so keep it really small if no callstack.
    call fixquick#window#resize_qf_to_errorcount(5,20)
    call fixquick#window#show_last_error_without_jump()
endf

function! david#lua#setup_for_running() abort
    let g:asyncrun_exit = 'call david#lua#setup_qf_after_compile()'

    " Run to execute and make to test.
    "
    " luatesty expects functions called test_[name of another function]()
    " install with `luarocks install testy`
    command! ProjectRun  compiler lua      | update | AsyncMake
    command! ProjectMake compiler luatesty | update | AsyncMake
endf

