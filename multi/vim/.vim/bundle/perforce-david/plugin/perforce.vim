
" Open a history window for the current file
" Will probably show an open connection dialog
function P4VFileHistory()
    !start p4v -win 0 -cmd "history %:p"
endfunction
command PVHistory call P4VFileHistory()

" PChanges doesn't default to current file -- so add another option
command PChangesThisFile call perforce#PFIF(0, 0, 'changes', "%:p")

" Adds PDiffExternal to existing perforce.vim options
function P4DiffInExternalTool()
    exec '!p4 set P4DIFF=' . g:external_diff . ' & p4 diff %:p & p4 set P4DIFF='
endfunction
command PDiffExternal silent call P4DiffInExternalTool()

function s:PGDiff()
	PPrint
	vsplit #
	DiffBoth
endfunction
command PGDiff silent call <SID>PGDiff()
