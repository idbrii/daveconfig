" Vim plugin that generates new Java source file when you type
"    vim nonexistent.java.
" Scripts tries to detect package name from the directory path, e. g.
" .../src/main/java/com/mycompany/myapp/app.java gets header
" package com.mycompany.myapp;
"
" Author:   DBriscoe
" Based on Stepan Koltsov's create-scala

function! skeletons#java#create()
    if exists("b:template_used") && b:template_used
        return
    endif
    
    let b:template_used = 1
    
    let filename = expand("<afile>:p")
    let x = substitute(filename, "\.java$", "", "")
    
    let p = substitute(x, "/[^/]*$", "", "")
    let p = substitute(p, "/", ".", "g")
    let p = substitute(p, ".*\.src$", "@", "") " unnamed package
    let p = substitute(p, ".*\.src\.", "!", "")
    let p = substitute(p, "^!main\.java\.", "!", "") "
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
    

    let user = $USERNAME
    call append("$", "\/**")
    call append("$", " * Copyright (C) " . strftime("%Y") . " " . user)
    call append("$", " */")
    call append("$", "")

    " insert package if we know it
    if p != "@"
        call append("$", "package " . p . ";")
        call append("$", "")
    endif
    
    call append("$", "class " . class . " {")
    call append("$", "    public " . class . "() {")
    call append("$", "    }")
    call append("$", "}")
    "call append(".", "")
    "call append(".", "// vim: set ts=4 sw=4 et:")

    " clear the first (blank) line and position the cursor at the ctor
    normal ggdd7jw
endfunction

" vim: set ts=4 sw=4 et:
