" Fancy vim magic maps
" All of these should begin with <Leader>d


" Transpose the current and next parameter.
" Explanation: delete current parameter, delete comma and spaces, skip past
" next parameter, paste current parameter, turn off highlighting.
"nnoremap <Leader>dp "cdt,dW/.[),]<CR>a, <Esc>"cp:nohl<CR>

" Transpose the current and next item in arithmetic.
" Bug: Won't work if expression terminates without a semicolon.
" Explanation: Search is for operator or terminator. Delete current item into
" register c, delete operator and whitespace, skip to next operator (or end),
" paste operator, paste current item, turn off highlighting.
"nnoremap <Leader>da "cd/\v( [-+*/] )\|\)?;\s*$<CR>d//e<CR>//<CR>P"cp:nohl<CR>


" Transposing
" Source: https://github.com/justinmk/config/blob/31135cde3882ded0a08ac4ef2bae6568adff80a6/.vimrc#L876
"transpose words, preserving punctuation
nnoremap <silent> <Leader>dt :s,\v(\w+)(\W*%#\W*)(\w+),\3\2\1,<bar>nohl<CR>
"transpose WORDs, preserving whitespace
nnoremap <silent> <Leader>dT :s,\v(\S+)(\s*\S*%#\S*\s*)(\S+),\3\2\1,<bar>nohl<CR>
