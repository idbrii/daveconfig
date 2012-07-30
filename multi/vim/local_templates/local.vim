" Special settings for local environment
"

" Set a different name for this location
iabbrev _me pydave (pydave@gmail.com)
iabbrev _company pydave

" Perforce
let g:p4Presets = 'perforce:1666 pydave_client pydave'
let g:external_diff = 'bcomp.bat'

" When Perforce is slow:
let g:p4EnableActiveStatus = 0
let g:p4EnableRuler = 0

" Enable my p4 customizations
let g:DAVID_local_root = "c:/p4/main"

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
        let g:cscope_database = 'cscope.out'

    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        let g:cscope_database = $CSCOPE_DB
    endif

    if exists("g:cscope_database") && g:cscope_database != ""
        cs add g:cscope_database
        let g:cscope_relative_path = '.'
    endif

    " okay, be verbose from now on
    set cscopeverbose

endif
