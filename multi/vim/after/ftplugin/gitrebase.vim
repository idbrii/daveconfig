function! s:ReorderLocalToEnd()
    let @a = ''
    %g/\v\c^[^#].{12}(work|local|hack|todo):/delete A
    exec search('^#') - 2 .'put a'
endf

" Move all "local" and "work" commits to become most recent in history.
command! GitReorderLocalToEnd :silent call s:ReorderLocalToEnd()

