" Mergetool          {{{1

" I only want one command.
command! -bar Merge call mergetool#toggle()
delcommand MergetoolStart
delcommand MergetoolToggle

" While merge is active add layout controls.
augroup david_mergetool
  au!
  autocmd User MergetoolStart command! MergetoolThreeWay MergetoolToggleLayout LmR
  autocmd User MergetoolStop delcommand MergetoolThreeWay
augroup END

