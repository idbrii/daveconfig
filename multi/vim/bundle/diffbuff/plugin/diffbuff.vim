" Diff arbitrary text
" Opens a tab to display a diff between the inputs. Quit the diff with q
" (closes the tab).

" Inspiration: http://stackoverflow.com/q/3619146/vimdiff-two-subroutines-in-same-file/#3621806

if exists('g:loaded_diffbuff')
    finish
endif
let g:loaded_diffbuff = 1

" Diffs the last two deleted ranges
command -nargs=0 DiffDeletes call DiffText(@1, @2)


" Diff two strings. Use @r to pass in register r.
function DiffText(left, right)
    let ft = &ft
    tabnew
    call s:CreateBuffer(a:left, ft)
    vnew
    call s:CreateBuffer(a:right, ft)
endfunction


" Setup the buffer and add the text
function s:CreateBuffer(text, ft)
    " Don't use a file, since we're for quick comparisons
    setlocal buftype=nofile
    " Use the source file's filetype for syntax highlighting
    let &l:ft = a:ft
    " Paste the data and only the data
    call setline(1, split(a:text, "\n"))
    diffthis
    " Quick quit
    nmap <buffer> q :tabclose<CR>
endfunction
