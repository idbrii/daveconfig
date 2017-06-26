" Compiler:	lua
" Last Change:	2017-05-17

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


" Combine three different forms of output:
"
" http://stackoverflow.com/questions/2771919/lua-jump-to-right-line
"       lua: blah.lua:2: '=' expected near 'var'
" debug.traceback():
"       scripts/mainfunctions.lua(198,1) in function 'SpawnPrefab'
" assert:
"       [00:00:04]: [string "scripts/gui.lua"]:97: Value() only accepts booleans and numbers
"       LUA ERROR stack traceback:
"           =[C]:-1 in (global) assert (C) <-1--1>
"           scripts/gui.lua:97 in (field) Value (Lua) <85-103>
"           scripts/update.lua:92 in () ? (Lua) <33-129>
" debugstack():
"       [00:29:08]: stack traceback:
"           scripts/mainfunctions.lua:139 in () ? (Lua) <136-184>
let &l:efm = join([
      \ '%.lua%#: %f:%l:%m',
      \ '@%\?%f:%l in %m',
      \ '%.%#: [string "%f"]:%l:%m',
      \ '%f(%l%\,%c) in %m',
      \ ], ",")



let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2:
