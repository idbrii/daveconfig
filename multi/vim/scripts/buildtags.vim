" Call a shell script to build our LookupFile and Cscope databases
"
execute '!bash ~/.vim/scripts/build_alttagfiles.sh' &cscopeprg &ft

if filereadable('./cscope.out')
    set nocscopeverbose
    " add any database in current directory
    cscope add cscope.out
    set cscopeverbose
endif
