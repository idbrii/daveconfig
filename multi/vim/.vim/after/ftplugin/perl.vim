" Use :make to check a script with perl
setlocal makeprg=perl\ -c\ %\ $* errorformat=%f:%l:%m
