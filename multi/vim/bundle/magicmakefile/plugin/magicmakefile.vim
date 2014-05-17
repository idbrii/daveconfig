if exists("b:loaded_magic_make")
	finish
endif
let b:loaded_magic_make = 1

if !exists("g:magicmakefile_dir")
    " By default, use our bundle directory to store the default makefiles.
    let g:magicmakefile_dir='~/.vim/bundle/magicmakefile'
endif

function GuessMakefile()
    if &buftype == 'nofile'
        " We only want to deal with real files.
        return
    endif

    let this_buf = bufname('%')
    if len(this_buf) == 0
        " Ignore cases where bufname is empty. This might happen if there are
        " multiple results or something is invalid.
        return
    endif

    " Guess the makefile to use.
    let b:makefile="Makefile"
    if filereadable(b:makefile) == 0
        let b:makefile = g:magicmakefile_dir . '/' . &ft . '.Makefile'
    endif

    if filereadable(b:makefile) == 0
        " No makefile found, must be unsupported filetype. Abort!
        return
    endif

    " If we have a valid makefile, then change the makeprg to use it.
    " NOTE: Assumes that we're using make (and not cmake or gmake).
    call setbufvar(this_buf, '&makeprg', 'make --makefile=' . b:makefile)
endfunction

augroup MagicMakefile
    " Guess the current makefile every time the filetype changes, since that's
    " most likely when we need to change the makefile. We need to provide the
    " file changed from the filetype or else we'll get invalid errors from
    " setbufvar.
    " NOTE: This causes a bug where we don't switch between the local and
    " default makefiles if we edit files in different folders (the switch only
    " happens when we first set the filetype). You can call GuessMakefile() to
    " force update the makefile.
    au FileType * call GuessMakefile()
augroup END


if (! exists("no_plugin_maps") || ! no_plugin_maps) &&
      \ (! exists("no_magicmakefile_maps") || ! no_magicmakefile_maps)

    " Build the current file with the extension removed and .out appended:
    "       qsort.cpp becomes qsort.out
    nmap <unique> <Leader>m :make! %<.out<CR>

endif
