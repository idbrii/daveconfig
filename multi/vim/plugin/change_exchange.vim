" Transpose words on either side of cursor.
"
" Mnemonic: Change-exchange
" Invoke at start of line and use n to initiate search highlighting to get a
" rough preview.
" Source: https://github.com/justinmk/config/blob/31135cde3882ded0a08ac4ef2bae6568adff80a6/.vimrc#L876
"
" Transpose words, preserving punctuation
nnoremap <silent> cx :s,\v(\w+)(\W*%#\W*)(\w+),\3\2\1,<bar>nohl<CR>:normal! ``<CR>
" Transpose WORDs, preserving whitespace
nnoremap <silent> cX :s,\v(\S+)(\s*\S*%#\S*\s*)(\S+),\3\2\1,<bar>nohl<CR>:normal! ``<CR>
