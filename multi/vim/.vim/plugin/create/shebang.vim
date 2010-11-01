" Add shebangs to scripts
" This is a little silly because files with an extension will be run with the
" associated program, but I like to have the shebang at the top.
" TODO: add the shebang to the ftplugin and call that from here

function! <SID>SetShebangHeader(program)
    call append("0", "\#! " . a:program)
    call append(".", "")
endfunction

function! <SID>SetShebang(program, file_ext)
    exec "au BufNewFile *." . a:file_ext . " call <SID>SetShebangHeader('" . a:program . "' . &ft)"
endfunction

augroup Shebang
    "Bash uses sh filetype
    au BufNewFile *.bash call <SID>SetShebangHeader("/bin/bash")

    call <SID>SetShebang('/bin/', "sh")
    call <SID>SetShebang('/usr/bin/env ', "py")
    call <SID>SetShebang('/usr/bin/env ', "rb")
augroup END
