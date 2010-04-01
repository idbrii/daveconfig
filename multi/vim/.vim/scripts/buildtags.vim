" Call a shell script to build our LookupFile and Cscope databases
"
execute '!bash ~/.vim/scripts/build_alttagfiles.sh' &cscopeprg &ft

if filereadable('./filenametags')
    let g:LookupFile_TagExpr = string('./filenametags')
    let g:LookupFile_UsingSpecializedTags = 1       " only if the previous line is right
endif
if filereadable('./cscope.out')
    set nocscopeverbose
    " add any database in current directory
    cscope add cscope.out
    set cscopeverbose
endif
