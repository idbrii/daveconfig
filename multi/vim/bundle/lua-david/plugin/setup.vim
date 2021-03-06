

" lua-xolox config {{{1
"

let g:lua_check_syntax = 0
let g:lua_check_globals = 0

if has('win32')
    let lua_compiler_folder = expand("<sfile>:p:h:h") . '/lib/lua-5.3/'
    " Config lua-xolox's compiler for CheckSyntax.
    let g:lua_compiler_name = lua_compiler_folder .'/luac53.exe'

    if executable(g:lua_compiler_name)
        " Add lua binaries to path so vim will find the dll (and I can access
        " compiler and interpreter). Ensure they come first so we don't find
        " some other lua (that doesn't version match vim).
        let $PATH = lua_compiler_folder .';'. $PATH
        if len($LUA_PATH_5_3) == 0
            let $LUA_PATH_5_3 = lua_compiler_folder
        endif
    elseif &verbose >= 9
        echoerr "lua-david doesn't have a lua compiler installed. See ./lib/readme.md."
    endif

    unlet lua_compiler_folder
endif
