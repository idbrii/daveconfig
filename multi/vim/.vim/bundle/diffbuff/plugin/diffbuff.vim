" Diff arbitrary text
" Opens a tab to display a diff between the inputs. Quit the diff with q
" (closes the tab).

" Inspiration: http://stackoverflow.com/q/3619146/vimdiff-two-subroutines-in-same-file/#3621806

if exists('g:loaded_diffbuff')
    finish
endif
let g:loaded_diffbuff = 1

command -nargs=0 DiffDeletes call DiffText(@1, @2)

function DiffText(left, right)
    tabnew
    call CreateBuffer(a:left)
    vnew
    call CreateBuffer(a:right)
endfunction

function CreateBuffer(text)
    setlocal buftype=nofile
    call setline(1, split(a:text, "\n"))
    diffthis
    nmap <buffer> q :tabclose<CR>
endfunction
