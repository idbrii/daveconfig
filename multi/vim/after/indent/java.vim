" Prevent the default java indent from indenting after annotations
" Inspiration:
" http://stackoverflow.com/questions/200932/how-do-i-make-vim-indent-java-annotations-correctly/211820#211820
function! GetJavaIndent_improved()
    let theIndent = GetJavaIndent()
    let lnum = prevnonblank(v:lnum - 1)
    let line = getline(lnum)
    if line =~ '^\s*@.*$'
        " the previous line was an annotation, ignore the built-in method of
        " indenting after an annotation and use the same indent instead
        let theIndent = indent(lnum)
    endif

    return theIndent
endfunction
setlocal indentexpr=GetJavaIndent_improved()
