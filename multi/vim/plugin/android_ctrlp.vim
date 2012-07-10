" Hacks for android projects
if has('loaded_android_ctrlp')
    finish
endif

" My android projects have library code in another git repo, so I can't let
" ctrlp stop at the .git file.
function FixupCtrlPCommandForAndroid()
    let fullpath = expand('%:p')
    let android_prefix = matchstr(fullpath, '^.*/android/')
    if len(android_prefix) > 0
        exec 'com! -com=dir CtrlP cal ctrlp#init(0, "'. android_prefix .'")'
    endif
endfunction
augroup CtrlPAndroid
    au BufReadPost *.java call FixupCtrlPCommandForAndroid()
    au BufReadPost *.xml call FixupCtrlPCommandForAndroid()
augroup END
