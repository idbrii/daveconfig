let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_powerline_fonts=0

" Only enable these locally since I don't want to see them for files written
" by other people.
let g:airline#extensions#whitespace#checks = []

" In increasing order of me liking them.
let g:airline_theme='luna'
let g:airline_theme='wombat'
let g:airline_theme='bubblegum'
let g:airline_theme='sanity'

"let g:airline_theme_patch_func = 'AirlineThemePatch'
"function! AirlineThemePatch(palette)
"	if g:airline_theme == 'sanity'
"		for colors in values(a:palette.normal)
"			let colors[1] = '#000000'
"			let colors[3] = 0
"		endfor
"	endif
"endfunction

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
