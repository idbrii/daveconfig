" Settings for when vim is invoked from an IDE.
"
" VS passes the following arguments to vim:
"   --servername VimualStudio --remote-silent +"call cursor($(CurLine),$(CurCol))" +"runtime visualstudioinvoke.vim" $(ItemFileName)$(ItemExt)
" Eclipse passes:
"   --servername Viclipse --remote-silent "+runtime visualstudioinvoke.vim" "+set path+=${project_loc}/**" ${resource_loc}

" It might be useful to include: +"set path+=$(SolutionDir)/**" 

"According to this: http://vim.wikia.com/wiki/VimTip716
"<c-z> brings gvim to foreground - on win2k, gvim gets focus but won't bring
"itself to foreground otherwise. You can remove it if you don't have this
"bring-to-foreground problem.
" This doesn't work, but it calls foreground() which does something. Look into
" that and remote_foreground({server})



" Disable resizing because it breaks under Ubuntu Natty in Unity
if !has("unix")
    " If default screen size then make it bigger
    if &columns==80 && &lines==24
        " Decent width
        set columns=100
        " Full screen height
        set lines=9999
    endif
endif

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

" Keep up to date on change from external editor
setlocal autoread
" We'll be opened with the full path, but jump to the local directory so
" Lookupfile, etc work better.
silent! cd %:p:h
