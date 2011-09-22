" Easily switch between different fold methods
"

nmap <Leader>ff :call <SID>ToggleFold()<CR>
function! s:ToggleFold()
	if !exists("b:fold_toggle_options")
		" By default, use the main three. I rarely use custom expressions or
		" manual and diff is just for diffing.
		let b:fold_toggle_options = ["syntax", "indent", "marker"]
	endif

	" Find the current setting in the list
	let i = match(b:fold_toggle_options, &foldmethod)

	" Advance to the next setting
	let i = (i + 1) % len(b:fold_toggle_options)
	let &l:foldmethod = b:fold_toggle_options[i]

	echo 'foldmethod is now ' . &l:foldmethod
endfunction
