" Settings for when vim is invoked from visual studio.
" Modified: 07 Aug 2008
"
" VS passes the following arguments to vim:
"   --servername VimualStudio --remote-silent +"call cursor($(CurLine),$(CurCol))" +"runtime visualstudioinvoke.vim" $(ItemFileName)$(ItemExt)

" Nice and wide for our huge files
set columns=145
" Centre cursor
normal zz
