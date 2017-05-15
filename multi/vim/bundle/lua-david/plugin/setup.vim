
if has('win32')
    " TODO: Add lib to the path so vim will find the dll.
    let g:lua_compiler_name = expand("<sfile>:p:h:h") . '/lib/lua-5.3/luac53.exe'

    if !filereadable(g:lua_compiler_name) && &verbose >= 9
        echoerr "lua-david doesn't have a lua compiler installed. See ./lib/readme.md."
    endif
endif
