" Quick tagfile locate functions
"
" Call either locate function to search for the corresponding tagdatabase and
" set it.
" Author: pydave
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


if exists('loaded_lookupfile')
    function LocateFilenameTagsFile()
        """ Tag file for Lookupfile
        let l:tagfile = <SID>FindTagFile('filenametags')
        if filereadable(l:tagfile)
            let g:LookupFile_TagExpr = string(l:tagfile)
            let g:LookupFile_UsingSpecializedTags = 1   " only if the previous line is right
            echomsg 'Lookupfile=' . g:LookupFile_TagExpr
        else
            let g:LookupFile_UsingSpecializedTags = 0
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

" Just call them all -- don't use this if you don't have access to all of them
function LocateAll()
    call LocateFilenameTagsFile()
    call LocateCscopeFile()
endfunction


" setup filename tags if we can find it, but be quiet about it
silent call LocateFilenameTagsFile()
" don't automatically call cscope. we probably need cscopeprg, etc to get set
