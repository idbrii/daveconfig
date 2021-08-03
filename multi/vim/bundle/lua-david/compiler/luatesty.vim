" Compiler:	testy.lua

if exists("current_compiler")
  finish
endif

" Same as lua except makeprg is different.
runtime compiler/lua.vim

let current_compiler = "luatesty"

let s:cpo_save = &cpo
set cpo-=C


" Testy assert failures look like:
"   [FAIL] C:\code\proj\file.lua:265: in function 'test_File'
CompilerSet errorformat^=%.%#[FAIL]\ %f:%l:\ in\ %m

CompilerSet makeprg=testy.lua\ %


let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2:
