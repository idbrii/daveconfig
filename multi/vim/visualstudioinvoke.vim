" Settings for when vim is invoked from visual studio.
" Modified: 10 Sep 2010
"
" VS passes the following arguments to vim:
"   --servername VimualStudio --remote-silent +"call cursor($(CurLine),$(CurCol))" +"runtime visualstudioinvoke.vim" $(ItemFileName)$(ItemExt)

" Nice and wide for our huge files
set columns=140
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
