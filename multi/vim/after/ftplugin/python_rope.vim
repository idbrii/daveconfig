let rope = '/usr/local/ropevim.vim'
if filereadable(rope)
    exec 'source ' . rope
else
    echo 'ropevim not available: missing ' . rope
endif
