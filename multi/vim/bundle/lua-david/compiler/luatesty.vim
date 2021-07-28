" Compiler:	testy.lua

if exists("current_compiler")
  finish
endif

" Same as lua except makeprg is different.
runtime compiler/lua.vim

let current_compiler = "luatesty"

let s:cpo_save = &cpo
set cpo-=C


CompilerSet makeprg=testy.lua\ %


let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2:
