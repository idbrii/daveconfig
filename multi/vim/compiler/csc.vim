" Vim compiler file for cs
" Compiler:    Mono C# Compiler

if exists("current_compiler")
  finish
endif

runtime $VIMRUNTIME/compiler/mcs.vim

let current_compiler = "csc"

let s:cpo_save = &cpo
set cpo-=C

" Remove %-G so you can see your program's output (+G would also make it
" visible, but cnext wouldn't skip over it).

setlocal errorformat-=%-G%.%#
setlocal errorformat-=%-G%\\s%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
