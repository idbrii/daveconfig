" Simple scratch buffer

let s:sequence_number = 0

function! s:OpenScratch(...)
	let s:sequence_number += 1

	let ft = ''
	let ft_command = ''
	if a:0 >= 1
		let ft = a:1
		if ft == '.'
			" Take on the current filetype.
			let ft = &ft
		endif

		let ft = '.'. ft
		let ft_command = 'setlocal filetype='.ft
	end

	" Hack: Always split
	if &modified || 1
		let edit_cmd = 'new'
	else
		let edit_cmd = 'edit'
	endif

	exec printf('%s %i%s.vimscratch', edit_cmd, s:sequence_number, ft)
	exec ft_command
endfunction

command! -nargs=? -complete=filetype Scratch call s:OpenScratch(<f-args>)
