" Make it easy to jump to files defined in batch files
setlocal isfname-==

" Run batch files and capture their output in quickfix
setlocal makeprg=%

" Built-in dosbatch syntax file provides no folding
setlocal foldmethod=indent

" :: Is how I insert documentation comments, but commentstring is generally
" for inserting temporary commments.
setlocal commentstring=REM\ %s
