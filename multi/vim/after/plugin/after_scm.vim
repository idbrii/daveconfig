" Mergetool          {{{1

" I only want one command.
command! Merge call mergetool#start()
delcommand MergetoolStart
delcommand MergetoolToggle

" When merge is active, swap Merge starter for layout controls.
" When merge ends, swap back.
augroup david_mergetool
  au!
  autocmd User MergetoolStart delcommand Merge | command! MergetoolThreeWay MergetoolToggleLayout LmR
  autocmd User MergetoolStop delcommand MergetoolThreeWay | command! Merge call mergetool#start()
augroup END

