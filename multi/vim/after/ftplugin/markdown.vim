
" Make the current line a header. Same map as top-level header comments since
" they aren't meaningful in markdown.
nnoremap <buffer> <silent> <Leader>hc :copy .<CR>Vr=
