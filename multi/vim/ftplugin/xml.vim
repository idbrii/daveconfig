command! -buffer FormatDocument :exec '%!python3' expand('~/.vim/scripts/prettyxml.py')
let &l:equalprg = expand('~/.vim/scripts/prettyxml.py')
