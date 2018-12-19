" Don't understand C# cindent: built-in indent/cs.vim file sets cindent,
" `set cindent?` reports nocindent, but this still works.
"
" Indent lambdas correctly.
setlocal cinoptions+=j1
" #defines in first column (not second)
setlocal cinoptions+=#0

" Kinda does switch indents right, but I don't like the big hanging indents
" for open parens.
"~ call david#indent#SetupCindentWithNiceSwitchIndents()

