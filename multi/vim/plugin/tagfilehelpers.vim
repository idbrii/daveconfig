" Quick tagfile locate functions
"
" Call locate function to search for the corresponding tagdatabase and set it.
" Author: David Briscoe
"
if exists("g:loaded_tagfilehelpers")
  finish
endif
let g:loaded_tagfilehelpers = 1

function! <SID>FindTagFile(tag_file_name)
    " From our current directory, search up for tagfile
    let l:tag_file = findfile(a:tag_file_name, '.;/') " must be somewhere above us
    let l:tag_file = fnamemodify(l:tag_file, ':p')      " get the full path
    if filereadable(l:tag_file)
        return l:tag_file
    else
        return ''
    endif
endfunction


function! LocateFilelist()
	""" List of files for CtrlP/Unite
	" Might be useful if you're using files from different directories.
	let l:tagfile = <SID>FindTagFile('filelist')
	if filereadable(l:tagfile)
		let g:david_project_filelist = (l:tagfile)
		echomsg 'Filelist=' . g:david_project_filelist
	endif
endfunction

function! LocateCscopeFile()
	if has("cscope")
		" Database file for cscope.
		" Assumes that the database was built in its local directory (passes
		" that directory as the prepend path).
		" Also setup cscope_maps.
		let l:tagfile = <SID>FindTagFile('cscope.out')
		let l:tagpath = fnamemodify(l:tagfile, ':h')
		if filereadable(l:tagfile)
			let g:cscope_database = l:tagfile
			" The Vim/Cscope tutorial says to set this environment variable to
			" ensure vim figures out the path correctly:
			"	http://cscope.sourceforge.net/cscope_vim_tutorial.html
			let $CSCOPE_DB = l:tagfile
			let g:cscope_relative_path = l:tagpath
			" Set the cscope file relative to where it was found
			execute 'cs add ' . l:tagfile . ' ' . l:tagpath
			runtime cscope_maps.vim
		endif
	endif
endfunction

" Currently can't check for executable("csearch") because it's not in my path.
function! LocateCsearchIndex()
	let l:tagfile = <SID>FindTagFile('csearch.index')
	if filereadable(l:tagfile)
		let $CSEARCHINDEX = l:tagfile
		echomsg 'csearchindex=' . $CSEARCHINDEX
	endif
endfunction

" Just call them all -- don't use this if you don't have access to all of them
function! LocateAll()
    " Make sure we have the full path
    silent! cd %:p:h
    " Locate all of our files
    call LocateCscopeFile()
	" Locate the nearest cindex
	call LocateCsearchIndex()
	" Locate the listing of project files
	call LocateFilelist()
endfunction

" Call a shell script to build our filelist, ctags, and cscope databases.
function! s:BuildTags()
    execute '!bash ~/.vim/scripts/buildtags' &cscopeprg &ft

    call LocateAll()
endf
command! BuildTags call s:BuildTags()