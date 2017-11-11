" File: luarequire.vim -- Great stuff for headers
" Maintainer: David Briscoe (idbrii@gmail.com)
" Version: 0.1
" based on cpp_header.vim
"
" Functionality:
"   * Add the require for a tag
"

if (! exists('no_plugin_maps') || ! no_plugin_maps) &&
      \ (! exists('no_luarequire_maps') || ! no_luarequire_maps)

    if !hasmapto('<Plug>LuaAddRequireForTag')
        nmap <buffer> <unique> <Leader>hi <Plug>LuaAddRequireForTag
    endif

    noremap <script> <Plug>LuaAddRequireForTag <SID>AddIncludeForTag

    noremap <SID>AddIncludeForTag :call <SID>AddIncludeForTag_Impl(expand("<cword>"))<CR>
endif

" Protect against multiple reloads
if exists("loaded_luarequire")
	finish
endif
let loaded_luarequire = 1


" Ensure our settings variables exist and set defaults
if !exists('g:luarequire_use_preview')
    let g:luarequire_use_preview = 0
end
if !exists('g:luarequire_n_dir_to_trim')
    let g:luarequire_n_dir_to_trim = 0
end
if !exists('g:luarequire_max_element_in_path')
    let g:luarequire_max_element_in_path = 0
end
if !exists('g:luarequire_after_first_include')
    let g:luarequire_after_first_include = 0
end


" Save compatibility options
let s:save_cpo = &cpo
set cpo&vim

" Configurable options
let s:header_extensions = ["lua"]



" Purpose: Return the first header-based match for the specified tag
" expression.
"
" TODO: This could be improved to take a skip count so we could cycle between
" the headers.
function! s:GetHeaderForTag(tag_expr)
	let l:tags = taglist(a:tag_expr)
	for tag in l:tags
		" Convert to forward slashes.
		let l:fn = substitute(tag["filename"], "\\", "/", "g")
		let l:fnext = fnamemodify(l:fn, ":e")

		" Use header files straight away.
		if index(s:header_extensions, l:fnext) >= 0
			return [l:fn, tag]
		endif

	endfor
	return []
endfunction

function! s:GetPrefix(tag_dict)
    if a:tag_dict["kind"] == "v"
        return "local ". a:tag_dict["name"] ." = "
    else
        return ""
    endif
endf

" Purpose: Add a header path to the file.
function! s:InsertHeader(taginfo)
    " Save the current cursor so we can restore on error or completion
	let l:save_cursor = getpos(".")
    
    " Extension is not relevant part of path.
    let l:path = fnamemodify(a:taginfo[0], ':r')
    let l:require_prefix = s:GetPrefix(a:taginfo[1])

    " Only use the base name for higher likelihood of matches
    let l:filename = fnamemodify(l:path, ':t')

    " Check if including the current file
    let l:currentfile = expand('%:b')
    let l:samefile = match(l:currentfile, l:filename)
	if l:samefile == 0
        call setpos(".", l:save_cursor)
        echo 'include is current file'
        return
    endif

    " Check if include already exists
	let l:pattern = '\v^.*<require>[^"]*"(.*[\/\\])?' . l:filename . '"'
	let l:iline = search(l:pattern)
	if l:iline > 0
        " Include already exists. Inform the user.

        call setpos(".", l:save_cursor)
        if ( g:luarequire_use_preview )
            " Use the preview window to show the include
            set previewheight=1
            silent exec "pedit +" . l:iline
            echo 'include already present on line ' . l:iline
        else
            echo 'include already exists: ' . getline(l:iline)
        endif

        return
	endif

	if ( g:luarequire_after_first_include )
		" Search forwards for the first include.
		normal 0G
		let l:flags = ''
	else
		" Search backwards for the last include.
		normal G
		let l:flags = 'b'
	endif
	" search() will return 0 if there are no matches, which will make the
	" append append on the first line in the file.
	let l:to_insert_after = search('\v^.*<require>', l:flags)

    if ( g:luarequire_use_preview )
        " Use the preview window to show the include
        " Use height=2 because we open preview before we put line (to
        " avoid unsaved error). So we show the line before and the include.
        set previewheight=2
        silent exec "pedit +" . l:to_insert_after
    endif

    " We only support quotes! See below.
	let l:text = l:require_prefix. 'require "' . l:path . '"'
	call append(l:to_insert_after, l:text)
    " We inserted a line, so change the cursor position
    let l:save_cursor[1] += 1

    " Get in position to fix the include and auto trim some directories.
    " We always insert quotes around include, so we can assume there's a quote
    " at the start.
    normal jf"l
    if g:luarequire_n_dir_to_trim > 0
        exec "normal " . g:luarequire_n_dir_to_trim . "df/"
    endif
    if g:luarequire_max_element_in_path > 0
		normal! $
        exec 'normal! ' . g:luarequire_max_element_in_path . 'T/dT"'
    endif
    normal! 0f"l

    " Set lastpos mark so you can easily jump back to coding with ``
    call setpos("'`", l:save_cursor)

    if ( g:luarequire_use_preview )
        " We have the preview window, so main doesn't need to show include
        call setpos(".", l:save_cursor)
    endif
endfunction

function! s:AddIncludeForTag_Impl(tag_expr)
	let l:header = s:GetHeaderForTag(a:tag_expr)

	if len(l:header) == 0
		echo "No header declaring '" . a:tag_expr . "' found in tags"
		return
	endif

	call s:InsertHeader(header)
endfunction



" Reset compat options
let &cpo = s:save_cpo
