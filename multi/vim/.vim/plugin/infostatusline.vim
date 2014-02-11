" InfoStatusLine
" Author: pydave
" Toggles an informative statusbar

if exists('loaded_infostatusline')
  finish
endif
let loaded_infostatusline = 1


set laststatus=2				" Always show statusline, even if only 1 window
if !exists('g:alt_statusline')
    let g:alt_statusline = 'ascii:%-3b hex:%2B %{PrintNumSelected()} %= HiLi<%{synIDattr(synID(line("."),col("."),1),"name")}> what<%{synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")}> %l,%c%V %P '
endif

function PrintNumSelected()
    " Show information about selected lines in the status bar:
    "  nonblank:[nLines with text] code:[nLines with code] enum:[num defined enums]
    " Enum should give you the value of the enum if you start selecting from
    " the enum with value = 1

    let l:lines = getline('.', 'v')
    if len(l:lines) == 0
		" TODO: how to detect this earlier? Maybe use `< and `> instead?
        let l:lines = getline('v', '.')
    endif
    let l:count_nonblank = 0
    let l:count_code = 0
    let l:count_enum = 0
    for line in l:lines
        if match(line, '^\s*$') >= 0
            " line was all whitespace
            continue
        endif
        let l:count_nonblank += 1

		" Only works for one type of comments (e.g., c++ uses /* \n\n */ in
		" commentstring)
		let comment_regex = '^\s*' . printf(&commentstring, '.*')
        if match(line, comment_regex) >= 0
            " line was just a comment
            continue
        endif
        let l:count_code += 1

        if match(line, '=') >= 0
            " line was an assigned enum
            continue
        endif
        let l:count_enum += 1

    endfor

    let l:out_str = ''
    if l:count_nonblank > 1
        let l:out_str .= ' nonblank:' . l:count_nonblank
    endif

    if l:count_code > 1
        let l:out_str .= ' code:' . l:count_code
    endif

    if l:count_enum > 1
        let l:out_str .= ' enum:' . l:count_enum
    endif

    return l:out_str
endfunction


function <SID>UseInfoStatusLine()
	if exists('w:std_statusline')
		let &statusline = w:std_statusline
		unlet w:std_statusline
	else
		let w:std_statusline = &statusline
		let &statusline = g:alt_statusline
	endif
endfunction

if (! exists('no_plugin_maps') || ! no_plugin_maps)
    nnoremap <Leader>si :call <SID>UseInfoStatusLine()<CR>
endif
