if !executable('p4')
	finish
endif

command! -buffer P4CheckoutFilesInGitCommit call perforce#david#P4CheckoutFilesInGitCommit()
command! -buffer P4CheckoutFilesInGitDiff call perforce#david#P4CheckoutFilesInGitDiff()
