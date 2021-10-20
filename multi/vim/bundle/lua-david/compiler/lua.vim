" Compiler:	lua

if exists("current_compiler")
  finish
endif
let current_compiler = "lua"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Options:
"
CompilerSet makeprg=lua53\ %
CompilerSet makeprg=lua\ %


" Support several formats of error. Order is very important.
let s:efm = []

" hotswap:
" (Specifically https://github.com/rxi/lume but this might cover any use of
" `require` at runtime.)
"       error loading module 'screens/mainscreen' from file 'scripts/screens/mainscreen.lua':
"              [string "cannot OLDFILEACCESSMETHOD @scripts/screens/mainscreen.lua..."]:234: 'end' expected near 'self'
call add(s:efm, '%.%#[string "cannot OLDFILEACCESSMETHOD @%f"]:%l:%m')

" love2d assert:
"       [00:00:04]: [string "scripts/gui.lua"]:97: Value() only accepts booleans and numbers
"       LUA ERROR stack traceback:
"           =[C]:-1 in (global) assert (C) <-1--1>
"           scripts/gui.lua:97 in (field) Value (Lua) <85-103>
"           scripts/update.lua:92 in () ? (Lua) <33-129>
"       [00:19:25]: hotswap : error	#[string "scripts/widget/util.lua"]:77: variable 'Text' is not declared	
call add(s:efm, '%+G%.%#[string "boot.lua"]%.%#')
call add(s:efm, '%.%#[string "%f"]:%l:%m')

" debugstack():
"       [00:29:08]: stack traceback:
"           scripts/mainfunctions.lua:139 in () ? (Lua) <136-184>
call add(s:efm, '@%\?%f:%l:%\? in %m')

" debug.traceback():
"       scripts/mainfunctions.lua(198,1) in function 'SpawnPrefab'
" love2d:
"       stack traceback:
"       	[string "boot.lua"]:637: in function '__lt'
"       	src/lib/flux/init.lua:91: in function 'new'
call add(s:efm, '%f(%l%\,%c) in %m')

" Standard lua:
" http://stackoverflow.com/questions/2771919/lua-jump-to-right-line
"       lua53: string.lua:7: bad argument #1 to 'find' (string expected, got nil)
"       stack traceback:
"       	[C]: in function 'string.find'
"       	string.lua:7: in function 'string.findall'
"       	string.lua:21: in main chunk
"       	[C]: in ?
" running lua with full path:
"       C:\apps\lua53\bin\lua.exe: conversation.lua:53: 'TALK_1' doesn't exist.
call add(s:efm, '%.%#lua%.%#: %f:%l: %m')


let &l:efm = join(s:efm, ",")
unlet s:efm


let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2:
