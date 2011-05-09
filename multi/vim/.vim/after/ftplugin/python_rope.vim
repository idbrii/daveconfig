let rope = '/usr/local/ropevim.vim'
if filereadable(rope)
    exec 'source ' . rope
else
    " Probably because package python-rope is not installed
    if !exists("s:ropevim_missing")
        echo 'ropevim not available: missing ' . rope
    endif
    let s:ropevim_missing = 1
endif
