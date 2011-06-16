function! ShowLines(FoldFunction)
    let nlines = 20
    let lazyredraw = &lazyredraw
    set lazyredraw

    let @c = ''
    for a in range(nlines)
        let @c .= a:FoldFunction(a+1) . ''
    endfor

    normal gg
    set scrollbind
    vsplit numbers
    set ft=vimscratch
    normal ggdG
    put c
    normal ggdd
    %s///
    vert resize 2
    normal gg
    set scrollbind
    syncbind
    wincmd p

    let &lazyredraw = lazyredraw
    redraw
endfunction
