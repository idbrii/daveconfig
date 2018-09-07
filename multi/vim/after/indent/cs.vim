" Don't understand C# cindent: built-in indent/cs.vim file sets cindent,
" `set cindent?` reports nocindent, but this still works.
"
" Indent lambdas correctly.
setlocal cinoptions+=j1
" #defines in first column (not second)
setlocal cinoptions+=#0


