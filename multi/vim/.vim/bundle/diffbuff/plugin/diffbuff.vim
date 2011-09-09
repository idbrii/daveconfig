" Diff arbitrary text
" 
" See autoload for implementation

if exists('g:loaded_diffbuff')
    finish
endif
let g:loaded_diffbuff = 1


" Diffs the last two deleted ranges
command -nargs=0 DiffDeletes call DiffText(@1, @2)


" Diff two strings. Use @r to pass in register r.
function DiffText(left, right)
    call diffbuff#diff_text(a:left, a:right)
endfunction
