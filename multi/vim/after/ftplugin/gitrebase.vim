function! s:ReorderLocalToEnd()
    let @a = ''
    %g/\v\c^[^#]([a-z0-9]+\s){2}(work|local|hack|todo):/delete A
    exec search('^#') - 2 .'put a'
endf

" Move all "local" and "work" commits to become most recent in history.
command! GitReorderLocalToEnd :silent call s:ReorderLocalToEnd()


" Indent is not useful, so behave like Gstatus: show the diff. I can't do
" something fancy like an inline diff, but opening the commit works. This
" makes much more sense to me than the 'gf' behaviour (which isn't a mapping!)
nnoremap <buffer><nowait> > 0w:Git show <C-r><C-w><CR>

