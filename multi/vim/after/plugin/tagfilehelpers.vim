" Quick tagfile locate functions
"
" Call either locate function to search for the corresponding tagdatabase and
" set it.
" Author: David Briscoe
"
if exists("g:loaded_tagfilehelpers")
  finish
endif
let g:loaded_tagfilehelpers = 1

function <SID>FindTagFile(tag_file_name)
    " From our current directory, search up for tagfile
    let l:tag_file = findfile(a:tag_file_name, '.;/') " must be somewhere above us
    let l:tag_file = fnamemodify(l:tag_file, ':p')      " get the full path
    if filereadable(l:tag_file)
        return l:tag_file
    else
        return ''
    endif
endfunction


if exists('g:loaded_ctrlp')
    function LocateFilelist()
        """ List of files for CtrlP
        " Might be useful if you're using files from different directories.
        let l:tagfile = <SID>FindTagFile('filelist')
        if filereadable(l:tagfile)
            let g:ctrlp_project_root = string(l:tagfile)
            echomsg 'Filelist=' . g:ctrlp_project_root 
        endif
    endfunction
endif

if has("cscope")
    function LocateCscopeFile()
        " Database file for cscope.
        " Assumes that the database was built in its local directory (passes
        " that directory as the prepend path).
        " Also setup cscope_maps.
        let l:tagfile = <SID>FindTagFile('cscope.out')
        let l:tagpath = fnamemodify(l:tagfile, ':h')
        if filereadable(l:tagfile)
            let g:cscope_database = l:tagfile
            let g:cscope_relative_path = l:tagpath
            " Set the cscope file relative to where it was found
            execute 'cs add ' . l:tagfile . ' ' . l:tagpath
            runtime cscope_maps.vim
        endif
    endfunction
endif

" Currently can't check for executable("csearch") because it's not in my path.
function LocateCsearchIndex()
	let l:tagfile = <SID>FindTagFile('csearch.index')
	if filereadable(l:tagfile)
		let $CSEARCHINDEX = l:tagfile
		echomsg 'csearchindex=' . $CSEARCHINDEX
	endif
endfunction

" Just call them all -- don't use this if you don't have access to all of them
function LocateAll()
    " Make sure we have the full path
    silent! cd %:p:h
    " Locate all of our files
    call LocateCscopeFile()
	" Locate the nearest cindex
	call LocateCsearchIndex()
endfunction

" Call a shell script to build our LookupFile and Cscope databases
"
function s:BuildAltTags()
    execute '!bash ~/.vim/scripts/build_alttagfiles.sh' &cscopeprg &ft

    call LocateAll()
endf
command! BuildAltTags call s:BuildAltTags()
