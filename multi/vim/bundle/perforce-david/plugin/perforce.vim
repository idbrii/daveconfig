" Some extensions to perforce.vim

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

" Auto-checkout all readonly files. We need nested in the autocmd so filetype
" stuff commands are still called.
function! s:P4CheckOutFile(p4_root)
	let root = substitute(a:p4_root, '/', '.', 'g')
	let fname = expand('%:p')
	if len(fname) == 0 || fname !~? root
		return
	endif

	PEdit
	edit
endfunction

function! SetupPerforce()
	augroup p4autocheckout
		au!
		au FileChangedRO * nested :call <SID>P4CheckOutFile(g:DAVID_local_root)
	augroup END

	" Perforce shortcuts
	nnoremap <Leader>fi :PChange<CR>
	nnoremap <Leader>fd :PGDiff<CR>
endfunction

if exists('g:DAVID_local_root') && executable('p4')
	call SetupPerforce()
endif
