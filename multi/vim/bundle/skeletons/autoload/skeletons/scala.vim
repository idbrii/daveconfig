" Vim plugin that generates new Scala source file when you type
"    vim nonexistent.scala.
" Scripts tries to detect package name from the directory path, e. g.
" .../src/main/scala/com/mycompany/myapp/app.scala gets header
" package com.mycompany.myapp
"
" Author     :   Stepan Koltsov <yozh@mx1.ru>
" Revision   : 17312
"        https://lampsvn.epfl.ch/trac/scala/export/18603/scala-tool-support/trunk/src/vim/plugin/31-create-scala.vim

function! skeletons#scala#create()
    if exists("b:template_used") && b:template_used
        return
    endif
    
    let b:template_used = 1
    
    let filename = expand("<afile>:p")
    let x = substitute(filename, "\.scala$", "", "")
    
    let p = substitute(x, "/[^/]*$", "", "")
    let p = substitute(p, "/", ".", "g")
    let p = substitute(p, ".*\.src$", "@", "") " unnamed package
    let p = substitute(p, ".*\.src\.", "!", "")
    let p = substitute(p, "^!main\.scala\.", "!", "") "
    let p = substitute(p, "^!.*\.ru\.", "!ru.", "")
    let p = substitute(p, "^!.*\.org\.", "!org.", "")
    let p = substitute(p, "^!.*\.com\.", "!com.", "")
    
    " ! marks that we found package name.
    if match(p, "^!") == 0
        let p = substitute(p, "^!", "", "")
    else
        " Don't know package name.
        let p = "@"
    endif
    
    let class = substitute(x, ".*/", "", "")
    
    if p != "@"
        call append("0", "package " . p)
    endif
    
    norm G
    call append(".", "class " . class . " {")
    
    norm G
    "call append(".", "} /// end of " . class)
    call append(".", "}")
    
    call append(".", "// vim: set ts=4 sw=4 et:")
    call append(".", "")
endfunction

" vim: set ts=4 sw=4 et:
