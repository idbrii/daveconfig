" File: cpp_header.vim -- Great stuff for headers
" Maintainer: pydave (pydave@gmail.com)
" Version: 0.1
" based on dice.vim by Andreas Fredriksson
"
" Functionality:
"   * Fix header guards
"   * Add the header for a tag
"
" TODO: Add forward declare
"       Jump to include on insert? -- need something since the includes are
"       big ugly paths since my tags aren't awesome.
"

" Protect against multiple reloads
if exists("loaded_cppheader")
	finish
endif
let loaded_cppheader = 1


" Ensure our settings variables exist and set defaults
if !exists('g:cpp_header_use_preview')
    let g:cpp_header_use_preview = 0
end
if !exists('g:cpp_header_n_dir_to_trim')
    let g:cpp_header_n_dir_to_trim = 0
end


" Save compatibility options
let s:save_cpo = &cpo
set cpo&vim

" Configurable options
let s:header_extensions = ["h", "hpp", "hh", "hxx"]



" Function: FixGuard()
" Purpose: Update the header guards in the current buffer.
"
" Given club/barmanager.h, this produces the header guard BARMANAGER_H.
function s:FixGuard()
	let l:save_cursor = getpos(".")
	let l:path = expand("%") 

	" Compute the guard value
	let l:guard = substitute(l:path, '\([a-z]\)', '\u\1', 'g')
	let l:guard = substitute(l:guard, '\.', '_', 'g')
	let l:guard = substitute(l:guard, '^[^A-Z0-9_].*', '', 'g')

	" See if we can find the #ifndef/#define pair
	call cursor(1, 1)

	let l:guard_found = 0
	let l:gline = search('^\s*#ifndef\s\+[A-Za-z0-9_]\+\s*', 'nc')

	if l:gline > 0
		let l:oldguard = substitute(getline(l:gline), '^#\s*ifndef\s\+\([A-Za-z0-9_]\+\)\s*$', '\1', '')
		let l:dpat = '^#\s*define\s\+' . l:oldguard . '\s*$'
		let l:dline = search(l:dpat, 'Wn')

		if l:dline == l:gline + 1
			let l:guard_found = 1
			call setline(l:gline, '#ifndef ' . l:guard)
			call setline(l:dline, '#define ' . l:guard)
		endif
	endif

	if 0 == l:guard_found
		echo "Failed to find header guard"
	endif

	" Restore cursor position
	call setpos('.', l:save_cursor)
endfunction



" Purpose: Return the first header-based match for the specified tag
" expression.
"
" TODO: This could be improved to take a skip count so we could cycle between
" the headers.
function s:GetHeaderForTag(tag_expr)
	let l:tags = taglist(a:tag_expr)
	for tag in l:tags
		" Convert to forward slashes.
		let l:fn = substitute(tag["filename"], "\\", "/", "g")
		let l:fnext = fnamemodify(l:fn, ":e")

		" Use header files straight away.
		if index(s:header_extensions, l:fnext) >= 0
			return l:fn
		endif

	endfor
	return ''
endfunction

" Purpose: Add a header path to the file.
function s:InsertHeader(path)
    if has('modify_fname')
        let l:filename = fnamemodify(a:path, ':t')
    else
        let l:filename = a:path
    endif
	let l:escaped_path = escape(a:path, "\\")
	let l:pattern = '\v^\s*#\s*include\s*["<](.*[\/\\])?' . l:filename . '[">]'
	let l:iline = search(l:pattern)

	if l:iline > 0
        " Include already exists. Inform the user.
        if ( g:cpp_header_use_preview )
            " Use the preview window to show the include
            set previewheight=1
            silent exec "pedit +" . l:iline
            echo 'include already present on line ' . l:iline
        else
            " Show the include in the command-line
            echo 'already included:'
            let l:save_cursor = getpos(".")
            call setpos('.', l:iline)
            number
            call setpos('.', l:save_cursor)
        endif
		return
	endif

    " Check if the tag is in the current file
    let l:currentfile = expand('%:b')
    let l:samefile = match(l:currentfile, l:filename)
	if l:samefile == 0
        echo 'include is current file'
        return
    endif

	" Search backwards for the last include. search() will return 0 if there
	" are no matches, which will make the append append on the first line in
	" the file.
	normal G
	let l:last_include_line = search('^\s*#\s*include', 'b')

	let l:text = '#include "' . a:path . '"'
	call append(l:last_include_line, l:text)

    " Get in position to fix the include and auto trim some directories.
    normal jf/
    if g:cpp_header_n_dir_to_trim > 0
        exec "normal " . g:cpp_header_n_dir_to_trim . "df/"
    endif
endfunction

function s:AddIncludeForTag_Impl(tag_expr)
	let l:header = s:GetHeaderForTag(a:tag_expr)

	if l:header == ''
		echo "No header declaring '" . a:tag_expr . "' found in tags"
		return
	endif

    " Save the current cursor and set lastpos mark so you can easily jump
    " back to coding with ``
	let l:save_cursor = getpos(".")
	call s:InsertHeader(header)
	call setpos("'`", l:save_cursor)
    if ( g:cpp_header_use_preview )
        call setpos(".", l:save_cursor)
    endif
endfunction



if (! exists('no_plugin_maps') || ! no_plugin_maps) &&
      \ (! exists('no_cpp_header_maps') || ! no_cpp_header_maps)

    if !hasmapto('<Plug>CppAddIncludeForTag')
        map <unique> <Leader>hi <Plug>CppAddIncludeForTag
    endif

    if !hasmapto('<Plug>CppFixHeaderGuard')
        map <unique> <Leader>hg <Plug>CppFixHeaderGuard
    endif

    noremap <unique> <script> <Plug>CppAddIncludeForTag <SID>AddIncludeForTag
    noremap <unique> <script> <Plug>CppFixHeaderGuard <SID>FixHeaderGuard

    noremap <SID>AddIncludeForTag :call <SID>AddIncludeForTag_Impl(expand("<cword>"))<CR>
    noremap <SID>FixHeaderGuard :call <SID>FixGuard()<CR>
endif

if (! exists('no_plugin_menus') || ! no_plugin_menus) &&
      \ (! exists('no_cpp_header_menus') || ! no_cpp_header_menus)

    noremenu <script> Cpp.Add\ Include\ for\ Symbol <SID>AddIncludeForTag
    noremenu <script> Cpp.Fix\ Header\ Guard <SID>FixHeaderGuard
endif

" Reset compat options
let &cpo = s:save_cpo
