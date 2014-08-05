" Undo some rsi maps.
if !exists('g:loaded_rsi')
    " Instead of using silent! to squelsh errors if rsi didn't map these keys,
    " just abort so if rsi is replaced I don't mess with these mappings.
    finish
endif

" Single character forward/back is dumb. These keys have prime locations that
" aren't worth wasting.
iunmap <C-B>
cunmap <C-B>
iunmap <C-F>
cunmap <C-F>

" I use the default behavior for indents (and rarely at the end of a line).
iunmap <C-D>

