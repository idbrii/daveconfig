
" If I disable dirvish somewhere, then don't do this so netrw still works.
if !exists("g:loaded_dirvish") || g:loaded_dirvish == 0
 finish
endif

" Instead of netrw, I use dirvish. Remove netrw junk. {{{1

" vinegar is for netrw
let g:loaded_vinegar = 0

" Disable this file if I want to use network editing/browsing.

" Remove netrw commands
silent! delcommand Nread
silent! delcommand Nwrite
silent! delcommand NetUserPass
silent! delcommand Nsource
silent! delcommand Ntree
silent! delcommand Explore
silent! delcommand Sexplore
silent! delcommand Hexplore
silent! delcommand Vexplore
silent! delcommand Texplore
silent! delcommand Nexplore
silent! delcommand Pexplore
silent! delcommand Lexplore
silent! delcommand NetrwSettings
silent! delcommand NetrwClean


" Remove netrw autocmds

augroup FileExplorer
 au!
augroup END
augroup! FileExplorer

augroup Network
 au!
augroup END
augroup! Network
