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
    let handler = asynchandler#quickfix("%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m", "Python: " . a:script_name)
    call asynccommand#run(command, handler)
endfunction
