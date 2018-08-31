
" Make the current line a header. Same map as top-level header comments since
" they aren't meaningful in markdown.
nnoremap <buffer> <silent> <Leader>hc :copy .<CR>Vr=

" Newline without any bullets
inoremap <buffer> <C-CR> <CR><C-u>

" Automatically add more bullets in a list.
setlocal formatoptions+=r
" Taken from java. This sets up /*c-style comments*/. Looks like vim doesn't
" do comment continuation for single-line comments, so we need to setup a
" multi-line comment.
setlocal comments^=s1:/*,mb:*,ex:*/

" Default is manual, but marker is more likely in markdown.
setlocal foldmethod=marker


" https://www.reddit.com/r/vim/comments/99veey/semantic_linefeeds_anyone_using_semantic/
" https://vi.stackexchange.com/questions/2846/how-to-set-up-vim-to-work-with-one-sentence-per-line/2848#2848
function! SemanticLineBreakFormatExpr(start, end)
    silent execute a:start.','.a:end.'s/[.!?]\zs /\r/g'
endfunction

setlocal formatexpr=SemanticLineBreakFormatExpr(v:lnum,v:lnum+v:count-1)

