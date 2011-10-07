" Some helpers for visual studio
"
if !has("win32") || exists("g:loaded_vshelp")
	finish
endif
let g:loaded_vshelp = 1


if !exists("g:vshelp_devenv")
	" assume pathogen
	let g:vshelp_devenv = expand('~\.vim\bundle\vshelp\scripts\open_in_visualstudio.cmd')

	" fall back on default
	if !filereadable(g:vshelp_devenv)
		let g:vshelp_devenv = expand('~\.vim\scripts\open_in_visualstudio.cmd')
	endif
endif

function s:OpenInVisualStudio()
	exec 'silent ! ' . g:vshelp_devenv . ' ' . fnameescape(expand('%:p')) . ' ' . line('.')
endfunction
command VSOpen call s:OpenInVisualStudio()
