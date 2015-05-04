
" Make the current line a header. Same map as top-level header comments since
" they aren't meaningful in markdown.
nnoremap <buffer> <silent> <Leader>hc :copy .<CR>Vr=


" Automatically add more bullets in a list.
setlocal formatoptions+=r
" Taken from java. This sets up /*c-style comments*/. Looks like vim doesn't
" do comment continuation for single-line comments, so we need to setup a
" multi-line comment.
setlocal comments^=s1:/*,mb:*,ex:*/
