	" Use :make to check a script with perl
	au FileType perl set makeprg=perl\ -c\ %\ $* errorformat=%f:%l:%m
