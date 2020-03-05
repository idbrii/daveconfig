" For some reason in Ubuntu 10.10, keywordprg is always set to man
" Vim should use help
setlocal keywordprg=:help


if &buftype != 'help' && &modifiable
    " When it's an editable file, the buftype changes to empty.
    setlocal colorcolumn=50
endif
