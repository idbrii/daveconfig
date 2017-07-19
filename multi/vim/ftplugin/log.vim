" Don't use spell checking in log files
setlocal nospell

" Log files usually have indenting
if &foldmethod != 'diff'
    set foldmethod=indent
endif
