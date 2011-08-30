" AsyncCommands for Python

if exists('g:loaded_asynccommand_python')
    finish
endif
let g:loaded_asynccommand_python = 1

if !exists('g:loaded_asynccommand')
    echoerr "asynccommand_python.vim requires AsyncCommand"
    finish
endif

command! AsyncPython call s:AsyncPython(expand('%'))

function! s:AsyncPython(script_name)
    let command = 'python ' . a:script_name

    " Use errorformat to parse what I got from the internet.
    let l:efm = &efm

    " Source: http://www.vim.org/scripts/script.php?script_id=477
    "the last line: \%-G%.%# is meant to suppress some
    "late error messages that I found could occur e.g.
    "with wxPython and that prevent one from using :clast
    "to go to the relevant file and line of the traceback.
    setlocal errorformat=
        \%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
        \%C\ \ \ \ %.%#,
        \%+Z%.%#Error\:\ %.%#,
        \%A\ \ File\ \"%f\"\\\,\ line\ %l,
        \%+C\ \ %.%#,
        \%-C%p^,
        \%Z%m,
        \%-G%.%#
    let py_errorformat = &efm

    " restore the previous efm so we don't mess with that.
    let &efm = l:efm

    let handler = asynchandler#quickfix(py_errorformat, "Python: " . a:script_name)

    call asynccommand#run(command, handler)
endfunction
