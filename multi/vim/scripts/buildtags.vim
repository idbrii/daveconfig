" Call a shell script to build our LookupFile and Cscope databases
"
if &ft is 'cpp'
    " Probably a big c++ project, so use the simple format
    !bash ~/vimfiles/scripts/build_alttagfiles.sh cpp
else
    " Don't know what we are so include anything that's not binary or junk
    !bash ~/vimfiles/scripts/build_alttagfiles.sh
endif

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
