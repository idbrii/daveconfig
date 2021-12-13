" Add shebangs to scripts
" This is a little silly because files with an extension will be run with the
" associated program, but I like to have the shebang at the top.
" TODO: add the shebang to the ftplugin and call that from here

function! skeletons#shebang#SetHeader(program)
    if !&modifiable
        return
    endif
    
    call append("0", "\#! " . a:program)
    call append(".", "")
endfunction

function! skeletons#shebang#AutocmdForExecutableMatchingFiletype(program, file_ext)
    return "au BufNewFile *." . a:file_ext . " call skeletons#shebang#SetHeader('" . a:program . "' . &ft)"
endfunction

