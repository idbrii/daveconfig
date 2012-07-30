" Simple scratch buffer

if !exists("g:scratch_always_split")
    let g:scratch_always_split = 0
endif

if !exists("g:scratch_always_vertical")
    let g:scratch_always_vertical = 0
endif

if !exists("g:scratch_always_horizontal")
    let g:scratch_always_horizontal = 0
endif

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

		let ft = ft .'.'
		let ft_command = 'setlocal filetype='.ft
	end

    if &modified || g:scratch_always_split
        " Split direction according to Vim's dimensions
        let is_narrow = &lines*2 > &columns
        if !g:scratch_always_vertical
                    \ && (is_narrow || g:scratch_always_horizontal)
            let edit_cmd = 'new'
        else
            let edit_cmd = 'vnew'
        endif
    else
        let edit_cmd = 'edit'
    endif

	exec printf('%s %s%i.vimscratch', edit_cmd, ft, s:sequence_number)
	exec ft_command
endfunction

command! -nargs=? -complete=filetype Scratch call s:OpenScratch(<f-args>)
