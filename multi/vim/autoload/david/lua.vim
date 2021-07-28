
function! david#lua#setup_for_running() abort
    let g:asyncrun_exit = 'call david#window#show_last_error_without_jump()'
    " Run to execute and make to test.
    "
    " luatesty expects functions called test_[name of another function]()
    " install with `luarocks install testy`
    command! ProjectRun  compiler lua      | update | AsyncMake
    command! ProjectMake compiler luatesty | update | AsyncMake
endf

