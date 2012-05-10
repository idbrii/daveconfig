" Fancy vim magic maps
" All of these should begin with <Leader>d


" Transpose the current and next parameter.
" Explanation: delete current parameter, delete comma and spaces, skip past
" next parameter, paste current parameter, turn off highlighting.
nnoremap <Leader>dp "cdt,dW/.[),]<CR>a, <Esc>"cp:nohl<CR>

" Transpose the current and next item in arithmetic.
" Bug: Won't work if expression terminates without a semicolon.
" Explanation: Search is for operator or terminator. Delete current item into
" register c, delete operator and whitespace, skip to next operator (or end),
" paste operator, paste current item, turn off highlighting.
nnoremap <Leader>da "cd/\v( [-+*/] )\|\)?;\s*$<CR>d//e<CR>//<CR>P"cp:nohl<CR>
