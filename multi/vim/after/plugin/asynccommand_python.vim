" AsyncCommands for Python

if exists('g:loaded_asynccommand_python')
    finish
endif
let g:loaded_asynccommand_python = 1

if !exists('g:loaded_asynccommand')
    echoerr "asynccommand_python.vim requires AsyncCommand"
    finish
endif

command! -nargs=1 -complete=file AsyncPython call s:AsyncPython(<q-args>)

function! s:AsyncPython(script_name)
    let command = 'python ' . a:script_name

    " Use errorformat to parse what I got from the internet.
    let l:efm = &efm

    " Source: http://www.vim.org/scripts/script.php?script_id=477
    setlocal errorformat=
        \%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
        \%C\ \ \ \ %.%#,
        \%+Z%.%#Error\:\ %.%#,
        \%A\ \ File\ \"%f\"\\\,\ line\ %l,
        \%+C\ \ %.%#,
        \%-C%p^,
        \%Z%m
    let py_errorformat = &efm

    " restore the previous efm so we don't mess with that.
    let &efm = l:efm

    let handler = asynchandler#quickfix(py_errorformat, "Python: " . a:script_name)

    call asynccommand#run(command, handler)
endfunction
