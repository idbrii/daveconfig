" don't let xolox-lua clobber my map.
nnoremap <buffer> <F1> :<C-u>sp ~/.vim-aside<CR>
"inoremap <buffer> <F1> <Esc>

" TODO: Make this a compiler
setlocal makeprg=lua\ %
" http://stackoverflow.com/questions/2771919/lua-jump-to-right-line
"       lua: blah.lua:2: '=' expected near 'var'

setlocal efm=%s:\ %f:%l:%m
" debug.traceback():
"       scripts/mainfunctions.lua(198,1) in function 'SpawnPrefab'
setlocal efm=%f(%l%\\,%c)\ in\ %m
" debugstack():
"       [00:29:08]: stack traceback:
"           scripts/mainfunctions.lua:139 in () ? (Lua) <136-184>
setlocal efm=%f:%l\ in\ %m


" debug.traceback():
"       scripts/mainfunctions.lua(198,1) in function 'SpawnPrefab'
" debugstack():
"       [00:29:08]: stack traceback:
"           scripts/mainfunctions.lua:139 in () ? (Lua) <136-184>
setlocal efm=%f:%l\ in\ %m,%f(%l%\\,%c)\ in\ %m
