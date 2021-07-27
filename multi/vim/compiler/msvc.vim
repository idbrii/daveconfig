" Vim compiler file
" Compiler:	Microsoft Visual C

if exists("current_compiler")
  finish
endif
let current_compiler = "msvc"

" Default is a good starting errorformat for MSVC.
CompilerSet errorformat&
" Capture error and warning numbers.
CompilerSet errorformat^=%f(%l):\ %tarning\ C%n:\ %m
CompilerSet errorformat^=%f(%l):\ %trror\ C%n:\ %m
