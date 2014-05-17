" Ignore vim's default for Conary Recipe
au! filetypedetect BufNewFile,BufRead *.recipe
" Use regular python. .recipe files are calibre.
au BufNewFile,BufRead *.recipe			setfiletype python
