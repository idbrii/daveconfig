if exists("b:loaded_magic_make")
	finish
endif
let b:loaded_magic_make = 1

if !exists("g:magicmakefile_dir")
    " By default, use our bundle directory to store the default makefiles.
    let g:magicmakefile_dir='~/.vim/bundle/magicmakefile'
endif

function GuessMakefile()
    let this_buf = bufname('%')

    " Store the original makeprg so we have something to append to.
    if getbufvar(this_buf, 'base_makeprg') == ""
        call setbufvar(this_buf, 'base_makeprg', &makeprg)
    endif

    " Guess the makefile to use.
    let b:makefile="Makefile"
    if filereadable(b:makefile) == 0
        let b:makefile = g:magicmakefile_dir . '/' . &ft . '.Makefile'
    endif

    if filereadable(b:makefile) == 0
        " If we have a valid makefile, then change the makeprg to use it.
        call setbufvar(this_buf, '&makeprg', b:base_makeprg . ' --makefile=' . b:makefile)
    endif
endfunction

augroup MagicMakefile
    " Guess the current makefile every time the filetype changes, since that's
    " most likely when we need to change the makefile.
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
