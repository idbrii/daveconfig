" Grep through all of your open buffers
"
if exists('loaded_bufgrep')
	finish
endif
let loaded_bufgrep = 1

command -nargs=+ BufGrep call <SID>BufGrep(<q-args>)
function s:BufGrep(query)
	" Using lazyredraw helps speed up drawing, especially since we go through
	" all of the buffers
	let save_lazyredraw = &lazyredraw
	set lazyredraw

	" We want to end back at the same point that we started from, so save that
	" buffer.
	let save_bufnr = bufnr('%')

	" Clear the quickfix -- we're adding to it so we want it to start empty
	call setqflist([])

	" For each buffer, if it has a name, then grep for the query in it. We use
	" g to get all matches and j to not jump anywhere -- we'll be on our way
	" to the next buffer anyway.
	exec 'noautocmd bufdo if !bufname("%") | silent! vimgrepadd/' . a:query . '/gj % | endif'

	" Go back to start point
	exec save_bufnr . 'buffer'

	let &lazyredraw = save_lazyredraw
endfunction
