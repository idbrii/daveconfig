" Markdown files are often just called .md (instead of .markdown).
"
" Override vim's default modula2 filetype (which is also .md).
au! filetypedetect BufRead,BufNewFile *.md

au BufRead,BufNewFile *.md setfiletype markdown
