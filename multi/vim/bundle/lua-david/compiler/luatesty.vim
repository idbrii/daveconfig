" Compiler:	testy.lua

if exists("current_compiler")
  finish
endif

" Same as lua except makeprg is different.
runtime compiler/lua.vim

let current_compiler = "luatesty"

let s:cpo_save = &cpo
set cpo-=C

" error:
" testy strips off the "lua:" prefix from error() output when errors occur
" inside tests.
"    create basic npc ('\proj\conversation.lua')
"      [ERROR] test function 'test_create_basic_npc' died:
"      \proj\conversation.lua:53: I am error
"      stack traceback:
"            [C]: in function 'error'
"            \proj\conversation.lua:94: in field 'create_basic_npc'
"            \proj\conversation.lua:299: in function <\proj\conversation.lua:297>
"            [C]: in function 'xpcall'
"            ...lua53\\lib\luarocks\rocks-5.3\testy\0.2-53\bin\testy.lua:443: in main chunk
"            [C]: in ?
"    0 tests (0 ok, 0 failed, 1 errors)
CompilerSet errorformat+=%f:%l:\ %m


" Testy assert failures look like:
"   [FAIL] C:\code\proj\file.lua:265: in function 'test_File'
CompilerSet errorformat^=%.%#[FAIL]\ %f:%l:\ in\ %m
" Skip over stack frames inside testy itself.
CompilerSet errorformat^=%.%#testy.lua:%n:\ %m

CompilerSet makeprg=testy.lua\ %


let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2:
