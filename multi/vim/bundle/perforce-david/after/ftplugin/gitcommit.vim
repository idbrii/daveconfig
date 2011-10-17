function! P4CheckoutFilesInGitCommit()
	if !executable('p4')
		echoerr 'p4 is not available'
		return
	endif

    let line = getline('.')
    let line = substitute(line, '^#\s*\w*:\s*', '', '')

    " Search for the git directory and find its parent
    let root = finddir('.git', '.;')
    if root == ''
        echoerr "Couldn't find git root"
        return
    endif
    let root = fnamemodify(root, ':h')

    let fname = root .'/'. line

	exec '!p4 edit ' . fnameescape(fname)
endfunction

function! P4CheckoutFilesInGitDiff()
	if !executable('p4')
		echoerr 'p4 is not available'
		return
	endif

    let bareline = getline('.')
    let line = substitute(bareline, '^diff.*\sb/', '', '')
	if len(bareline) == len(line)
		" diff wasn't found, so skip this line
		return
	endif

    " Search for the git directory and find its parent
    let root = '//depot'
    let fname = root .'/'. line

	exec '!p4 edit ' . fname
endfunction
