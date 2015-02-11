" Everything requires the p4 executable {{{1
if !executable('p4')
	finish
endif


function! perforce#david#P4DiffInExternalTool()
    exec '!p4 set P4DIFF=' . g:external_diff . ' & p4 diff %:p & p4 set P4DIFF='
endfunction

function! s:P4Checkout(root, path)
	let fname = fnamemodify(a:root .'/'. a:path, ':p')
	let fname = fnameescape(fname)

	if exists('g:loaded_perforce')
		exec 'PEdit ' . fname
		" PEdit opens a new buffer, so switch back to the gitcommit buffer.
		wincmd p
	else
        exec '!p4 edit ' . fname
	endif
endfunction

function! perforce#david#P4CheckoutFilesInGitCommit()
    let line = getline('.')
    let line = substitute(line, '^#\s*\w*:\s*', '', '')

    " Search for the git directory and find its parent
    let root = finddir('.git', '.;')
    if root == ''
        echoerr "Couldn't find git root"
        return
    endif
    let root = fnamemodify(root, ':h')

	call s:P4Checkout(root, line)
endfunction

function! perforce#david#P4CheckoutFilesInGitDiff()
    let bareline = getline('.')
    let line = substitute(bareline, '^diff.*\sb/', '', '')
	if len(bareline) == len(line)
		" diff wasn't found, so skip this line
		return
	endif

    " Search for the git directory and find its parent
    let root = '//depot'

	call s:P4Checkout(root, line)
endfunction


" Dependent on perforce.vim {{{1
if !exists('g:loaded_perforce') || g:loaded_perforce <= 0
	finish
endif

function! perforce#david#P4CheckOutFile(p4_root)
    " Auto-checkout if file is under our p4 root. Doesn't try to checkout
    " system files and other readonly files that aren't in perforce.

	let root = substitute(a:p4_root, '/', '.', 'g')
	let fname = expand('%:p')
	if len(fname) == 0 || fname !~? root
		return
	endif

	PEdit
	edit
endfunction

" p4 edit all args. Useful after doing Qargs and before doing search and
" replace on the quickfix. This will likely fail if there are hundreds of
" files in the quickfix.
function! perforce#david#PerforceEditArgs(only_readonly, batch_size)
    " Limit input to PFIF to prevent E740: Too many arguments for function
    " perforce#PFIF
    let args = argv()
    if a:only_readonly
        let args = filter(args, 'filewritable(v:val) != 1')
    endif
    for i in range(0, len(args), a:batch_size)
        exec 'let cmd = args['. i .':'. (i+a:batch_size) .']'
        execute 'PEdit '. join(cmd, ' ')
        " Remove the edit windows (so we don't run out of space)
        "silent! wincmd o
    endfor
endfunction

function! perforce#david#PAnnotate()
    " Open a split with blame annotations.
    " TODO: Support arbitrary revisions?

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

function! perforce#david#PVimDiff()
    " Output the head revision, push it to the left, and diff against current.

	PPrint
	wincmd H
	DiffBoth
endfunction

function! perforce#david#InvasivePerforceSetup()
    " Make sure local machine is setup to work before setting autocmds or
    " maps.

	augroup p4autocheckout
		au!
        " Auto-checkout all readonly files. We need nested in the autocmd so
        " filetype stuff commands are still called.
		au FileChangedRO * nested :call perforce#david#P4CheckOutFile(g:DAVID_local_root)
	augroup END

	" Perforce shortcuts
	nnoremap <Leader>fi :PChange<CR>
	nnoremap <Leader>fd :PGDiff<CR>
	nnoremap <Leader>fv :exec 'PChanges -L -u '. $USERNAME<CR>
	nnoremap <Leader>fV :PChangesThisFile<CR>
	nnoremap <Leader>fb :silent! cd %:p:h<CR>:PBlame<CR>

    " PChange doesn't work, so delete it to prevent confusion with PChanges.
	delcommand PChange
endfunction

