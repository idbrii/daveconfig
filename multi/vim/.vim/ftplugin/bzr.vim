" Vim filetype plugin
" Language:	bzr commit file

" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif

let b:did_ftplugin = 1

if &textwidth == 0
  " make sure that log messages play nice with bzr-log on standard terminals
  setlocal textwidth=72
endif
