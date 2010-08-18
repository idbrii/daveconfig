" Location of cscope database for central project
"
if filereadable("c:/p4/main/cscope.out")
    cs add c:/p4/main/cscope.out c:/p4/main
endif

runtime cscope_maps.vim
