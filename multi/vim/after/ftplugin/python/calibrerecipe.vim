if exists('loaded_calibrerecipe') || &cp
    finish
endif
let loaded_calibrerecipe = 1

function s:Calibre()
    setlocal makeprg=scons
    noremap <buffer> <F5> :AsyncMake 
endfunction

au BufNewFile,BufRead *.recipe			call s:Calibre()
