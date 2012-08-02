augroup skeletons_shebang
    "Bash uses sh filetype
    au BufNewFile *.bash call skeletons#shebang#SetHeader("/bin/bash")

    call skeletons#shebang#Set('/bin/', "sh")
    call skeletons#shebang#Set('/usr/bin/env ', "py")
    call skeletons#shebang#Set('/usr/bin/env ', "rb")
augroup END

" vim: set ts=4 sw=4 et:
