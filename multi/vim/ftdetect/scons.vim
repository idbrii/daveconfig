" Scons files
"
function! <SID>SetupScons()
    setf python
    setlocal makeprg=scons\ -u
endfunction

augroup Scons_david
    au!
    au BufRead,BufNewFile SConstruct call <SID>SetupScons()
    au BufRead,BufNewFile SConscript call <SID>SetupScons()
augroup END
