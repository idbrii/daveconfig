
" If I disable dirvish somewhere, then don't do this so netrw still works.
if !exists("g:loaded_dirvish") || g:loaded_dirvish == 0
 finish
endif

" Instead of netrw, I use dirvish. Remove netrw junk. {{{1

" Disable this file if I want to use network editing/browsing.

" Remove netrw commands
delcommand Nread
delcommand Nwrite
delcommand NetUserPass
delcommand Nsource
delcommand Ntree
delcommand Explore
delcommand Sexplore
delcommand Hexplore
delcommand Vexplore
delcommand Texplore
delcommand Nexplore
delcommand Pexplore
delcommand Lexplore
delcommand NetrwSettings
delcommand NetrwClean


" Remove netrw autocmds

augroup FileExplorer
 au!
augroup END
augroup! FileExplorer

augroup Network
 au!
augroup END
augroup! Network
