" Easily switch between different fold methods
"

nnoremap <Leader>ff :call <SID>ToggleFold()<CR>
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

function! s:FoldParagraphs()
    setlocal foldmethod=expr
    setlocal fde=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
endfunction
command! FoldParagraphs call s:FoldParagraphs()
