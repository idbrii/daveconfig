let rope = '/usr/local/ropevim.vim'
if filereadable(rope)
    exec 'source ' . rope
else
    " Probably because package python-rope is not installed
    echo 'ropevim not available: missing ' . rope
endif
