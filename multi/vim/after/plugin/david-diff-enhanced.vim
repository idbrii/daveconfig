
" Work around chrisbra/vim-diff-enhanced#3
" This is actually a gvim-windows vs git-cygwin problem.
if has('win32')
    function! s:CustomDiffAlgComplete(A,L,P)
        return "myers\nminimal\ndefault\npatience\nhistogram"
    endf
    command! -nargs=1 -complete=custom,s:CustomDiffAlgComplete CustomDiff :cd $TEMP | let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=<args>")'|:diffupdate
endif
