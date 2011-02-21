" Settings for when vim is invoked from an IDE.
" Modified: 21 Feb 2011
"
" VS passes the following arguments to vim:
"   --servername VimualStudio --remote-silent +"call cursor($(CurLine),$(CurCol))" +"runtime visualstudioinvoke.vim" $(ItemFileName)$(ItemExt)
" Eclipse passes:
"   --servername Viclipse --remote-silent "+source ~/.vim/visualstudioinvoke.vim" ${resource_loc}

" Decent width
set columns=100
" Full screen height
set lines=9999
" Centre cursor
normal zz


""""" Load cscope database if we can
" Setup cscope for visual studio (game development)
if has("cscope")
    " disable verbose for our initial load
    set nocscopeverbose
    " add any database in current directory
    call LocateCscopeFile()
    " okay, be verbose from now on
    set cscopeverbose
endif

" We don't seem to be in the right directory in the vimrc, so call this again
silent call LocateFilenameTagsFile()

" Keep up to date on change from external editor
setlocal autoread
" We'll be opened with the full path, but jump to the local directory so
" Lookupfile, etc work better.
silent! cd %:p:h
