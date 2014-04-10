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
	command PVHistory call s:P4VFileHistory()

	function s:P4VTimeLapse()
		!start p4v -win 0 -cmd "annotate -i %:p"
	endfunction
	command PVTimeLapse call s:P4VTimeLapse()
endif


" Invoke external diff for current file {{{
function s:P4DiffInExternalTool()
    exec '!p4 set P4DIFF=' . g:external_diff . ' & p4 diff %:p & p4 set P4DIFF='
endfunction
command PDiffExternal silent call s:P4DiffInExternalTool()


" Dependent on perforce.vim {{{
if !exists('g:loaded_perforce') || g:loaded_perforce <= 0
	finish
endif

" PChanges doesn't default to current file -- so add another option. Also give
" longer descriptions so I can at least see the first line.
command PChangesThisFile PChanges -L %

" TODO: Support arbitrary revisions?
function! s:PAnnotate()
	if exists("g:p4SplitCommand")
		let p4SplitCommand_bak = g:p4SplitCommand
	endif

	let g:p4SplitCommand = 'vsplit'
	" -q for no header, so the lines match up.
	PF annotate -q %

	" Shrink to be an adjacent window. (So we can look in the
	" syntax-highlighted one instead.)
	setlocal nowrap
	vertical resize 20
	setlocal scrollbind
	wincmd p
	setlocal scrollbind
	syncbind
	" TODO: Should remove scrollbind when closed.

	if exists("p4SplitCommand_bak")
		let g:p4SplitCommand = p4SplitCommand_bak
	endif
endfunction
command PAnnotate call s:PAnnotate()

function s:PGDiff()
	PPrint
	wincmd H
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

function! s:InvasivePerforceSetup()
	augroup p4autocheckout
		au!
		au FileChangedRO * nested :call <SID>P4CheckOutFile(g:DAVID_local_root)
	augroup END

	" Perforce shortcuts
	nnoremap <Leader>fi :PChange<CR>
	nnoremap <Leader>fd :PGDiff<CR>
	nnoremap <Leader>fv :exec 'PChanges -L -u '. $USERNAME<CR>
	nnoremap <Leader>fV :PChangesThisFile<CR>
	nnoremap <Leader>fb :silent! cd %:p:h<CR>:PBlame<CR>

	delcommand PChange
endfunction

" Make sure local machine is setup to work before setting autocmds or maps.
if exists('g:DAVID_local_root')
	call s:InvasivePerforceSetup()
endif
