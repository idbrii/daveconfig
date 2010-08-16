" Special settings for local environment
"

" Switch to the directory of the current file, unless it's a help file.
if has("autocmd")
augroup vimrcEx
    au BufEnter * if &ft != 'help' | silent! cd %:p:h | endif
endif

" Set a different name for this location
iabbrev _me pydave (pydave@gmail.com)
iabbrev _company pydave

" Perforce
" Open a history window for the current file
" Will probably show an open connection dialog
cabbrev p4vhist !p4v -win 0 -cmd "history %:p"

let g:p4Presets = 'perforce:1666 pydave_client pydave'

let g:DAVID_local_root = "c:/p4/main"

" Vim on Windows defaults to findstr, but cygwin grep is better
set grepprg=grep\ -nH
" If most code has a path like: p4\game\main\packages\core\game\dev\src\
let g:cpp_header_n_dir_to_trim = 8

" Setup cscope for general use
if has("cscope")
    " using mlcscope from cygwin
    set cscopeprg=mlcscope

    """"" Load cscope database if we can
    " disable verbose for our initial load
    set nocscopeverbose
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    " okay, be verbose from now on
    set cscopeverbose

endif
