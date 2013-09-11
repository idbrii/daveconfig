let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_powerline_fonts=0
let g:airline#extensions#whitespace#checks = [ 'indent' ]

" In increasing order of me liking them.
let g:airline_theme='luna'
let g:airline_theme='wombat'
let g:airline_theme='bubblegum'

"let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
	" TODO: Change the RO red to orange (brightorange).
	if g:airline_theme == 'bubblegum'
		for colors in values(a:palette.normal)
			let colors[1] = '#000000'
			let colors[3] = 0
		endfor
	endif
endfunction

"let g:airline_mode_map = {
"    \ '__' : '-',
"    \ 'n'  : 'N',
"    \ 'i'  : 'I',
"    \ 'R'  : 'R',
"    \ 'c'  : 'C',
"    \ 'v'  : 'V',
"    \ 'V'  : 'V',
"    \ '' : 'V',
"    \ 's'  : 'S',
"    \ 'S'  : 'S',
"    \ '' : 'S',
"    \ }
