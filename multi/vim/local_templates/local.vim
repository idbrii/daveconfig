" Special settings for local environment
"

" Set a different name for this location
if has('win32')
	let g:snips_author = expand('$USERNAME')
else
	let g:snips_author = expand('$USER')
endif

" I often don't use perforce
let loaded_perforce = 0

" If I don't have eclipse, I'll want to turn off eclim. TODO: Use
" !executable('eclipse')?
let g:EclimDisabled = 1
let loaded_taglist = 1

" Some tools that depend on system packages and complain if they're not
" installed. If you don't use them, then set these to skip loading.
let loaded_python_bike = 0
let loaded_python_ipy = 0
let loaded_python_rope = 0

" Perforce
let g:p4Presets = 'perforce:1666 idbrii_client idbrii'
let g:external_diff = 'bcomp.bat'

" When Perforce is slow:
let g:p4EnableActiveStatus = 0
let g:p4EnableRuler = 0

" Enable my p4 customizations
let g:DAVID_local_root = "c:/p4/main"


" Also exclude logs
" TODO: For this to work, local.vim needs to be sourced after
" config_navigation.vim
let g:ctrlp_mruf_exclude = '.*\\\.git\\.*\|^c:\\temp\\.*\|\\AppData\\Local\\Temp\\\|\\build\\.*\\logfiles\\'
let g:ctrlp_mruf_case_sensitive = 0
let loaded_android_ctrlp = 1


" If most code has a path like: p4\game\main\packages\core\game\dev\src\
let g:cpp_header_n_dir_to_trim = 8
" After first or last include?
"let g:cpp_header_after_first_include = 1

if has('win32')
	" Prefer unix even though we're on Windows.
	set fileformats=unix,dos
endif

" Setup cscope for general use
if has("cscope")
    " Sometimes cscope is replaced with mlcscope (old cygwin).
	if !executable(&cscopeprg) && executable('mlcscope')
		set cscopeprg=mlcscope
	endif

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

" If python is not in the path (because that breaks build pipeline), but vim
" plugins need python, setup python's paths in vim. Any build scripts called
" from vim need to clear these variables.
let $PYTHONHOME = $MY_PYTHONHOME
let $PYTHONPATH = $PYTHONHOME . "/Lib"
if isdirectory($PYTHONHOME)
    let $PATH = $PATH . ';' . $PYTHONHOME
endif

" Portable git is installed with Github for Windows and SourceTree
let PORTABLEGIT = expand('$LocalAppData/Atlassian/SourceTree/git_local/bin')
let PORTABLEGIT = expand('$LocalAppData/GitHub/PortableGit_69703d1db91577f4c666e767a6ca5ec50a48d243/bin')
if !isdirectory(PORTABLEGIT)
    echoerr "Failed to find PortableGit. Did it update and change paths?"
else
    let $PATH = $PATH . ';' . PORTABLEGIT
endif

