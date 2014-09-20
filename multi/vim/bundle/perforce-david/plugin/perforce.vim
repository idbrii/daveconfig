" Some extensions to perforce.vim

if !executable('p4')
	finish
endif


" Invoke p4v for current file {{{
if executable('p4v')
	" Open a history window for the current file
	" Will probably show an open connection dialog
    function s:P4VFileHistory()
        !start p4v -win 0 -cmd "history %:p"
    endfunction

    if executable('p4vc')
        function s:P4VRevisionGraph()
            !start p4vc revisiongraph %:p
        endfunction

        function s:P4VTimeLapse()
            !start p4vc timelapseview %:p
        endfunction
    else
        function s:P4VRevisionGraph()
            !start p4v -win 0 -cmd "tree -i %:p"
        endfunction

        function s:P4VTimeLapse()
            !start p4v -win 0 -cmd "annotate -i %:p"
        endfunction
    endif

	command PVHistory call s:P4VFileHistory()
	command PVRevisionGraph call s:P4VRevisionGraph()
	command PVTimeLapse call s:P4VTimeLapse()
endif


" Invoke external diff for current file {{{
command PDiffExternal silent call perforce#david#P4DiffInExternalTool()

" Dependent on perforce.vim {{{
if !exists('g:loaded_perforce') || g:loaded_perforce <= 0
	finish
endif

" PChanges doesn't default to current file -- so add another option. Also give
" longer descriptions so I can at least see the first line.
command PChangesThisFile PChanges -L %

command PAnnotate call perforce#david#PAnnotate()

" Vimdiff instead of diff output
command PGDiff silent call perforce#david#PVimDiff()

" p4 edit all args. Useful after doing Qargs and before doing search and
" replace on the quickfix. This will likely fail if there are hundreds of
" files in the quickfix.
command! PEditArgs execute 'PEdit '. join(argv(), ' ')
nnoremap <Leader>fq :Qargs <Bar> PEditArgs<CR>

if exists('g:DAVID_local_root')
	call perforce#david#InvasivePerforceSetup()
endif
