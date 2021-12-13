augroup skeletons_shebang
    au!
    " Bash uses sh filetype
    au BufNewFile *.bash call skeletons#shebang#SetHeader("/bin/bash")

    exec skeletons#shebang#AutocmdForExecutableMatchingFiletype('/bin/', "sh")
    exec skeletons#shebang#AutocmdForExecutableMatchingFiletype('/usr/bin/env ', "py")
    exec skeletons#shebang#AutocmdForExecutableMatchingFiletype('/usr/bin/env ', "rb")
augroup END

" vim: set ts=4 sw=4 et:
