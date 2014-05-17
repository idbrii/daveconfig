" Scons files
"
function <SID>SetupScons()
    setf python
    setlocal makeprg=scons\ -u
endfunction

au BufRead,BufNewFile SConstruct call <SID>SetupScons()
au BufRead,BufNewFile SConscript call <SID>SetupScons()
