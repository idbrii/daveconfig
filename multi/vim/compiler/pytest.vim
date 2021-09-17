" Compiler:	pytest

if exists("current_compiler")
  finish
endif

" Copy errorformat from python.
runtime compiler/python.vim

let current_compiler = "pytest"

" Using native lets us use default python errorformat and jump to assertion
" failures.
CompilerSet makeprg=pytest\ -q\ --no-header\ --tb=native

" vim:set sw=2 sts=2:
