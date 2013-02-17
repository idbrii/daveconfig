if exists('loaded_python_rope') || &cp
    finish
endif
let loaded_python_rope = 1

let rope = '/usr/local/ropevim.vim'
if filereadable(rope)
    exec 'source ' . rope
else
    " Probably because pip packages ropemode and ropevim are not installed
    if !exists("s:ropevim_missing")
        echo 'ropevim not available: missing ' . rope
    endif
    let s:ropevim_missing = 1
endif
