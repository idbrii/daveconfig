" Some helpers for visual studio
"
if !has("win32") || exists("g:loaded_vshelp")
	finish
endif
let g:loaded_vshelp = 1


if !exists("s:vshelp_devenv")
	" assume relative to current
	let install_dir = expand("<sfile>:p:h:h")
	let s:vshelp_devenv = install_dir . expand('/scripts/open_in_visualstudio.cmd')

	" fail if not found
	if !filereadable(s:vshelp_devenv)
		echoerr 'vshelp is installed incorrectly. The plugin/ and scripts/ directories must be in the same folder.'
		finish
	endif
endif

function s:OpenInVisualStudio()
	let prefix = 'silent ! '
	if exists('g:loaded_asynccommand')
		let prefix = 'AsyncCommand '
	endif
	exec prefix . s:vshelp_devenv . ' ' . fnameescape(expand('%:p')) . ' ' . line('.')
endfunction
command VSOpen call s:OpenInVisualStudio()
