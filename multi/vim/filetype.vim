" Filetypes that already exist but I want to change the behaviour.
"
" Instead of using ~/.vim/ftdetect and `set ft=x`, put them here so the
" ftplugins are never loaded.

if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    " ldoc configuration files - replace *.ld 'Ld loader'
    au! BufRead,BufNewFile config.ld setf lua
augroup END
