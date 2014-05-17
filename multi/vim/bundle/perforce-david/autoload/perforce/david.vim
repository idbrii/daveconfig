function! s:P4Checkout(root, path)
	let fname = fnamemodify(a:root .'/'. a:path, ':p')
	let fname = fnameescape(fname)

	if exists('g:loaded_perforce')
		exec 'PEdit ' . fname
		" PEdit opens a new buffer, so switch back to the gitcommit buffer.
		wincmd p
	else
		if executable('p4')
			exec '!p4 edit ' . fname
		else
			echoerr 'p4 is not available'
		endif
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
